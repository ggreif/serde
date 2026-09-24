# jayson — vendored `Json.mo`

`src/Json.mo` is copied verbatim from **jayson 0.1.1**
(<https://github.com/christoph-dfinity/motoko-jayson>, also on mops as
`jayson@0.1.1`), by Christoph Hegemann. Licensed **Apache-2.0**; serde-core is
MIT, and Apache-2.0 permits this provided the notice is retained — hence this
file.

## Why vendored rather than depended on

The jayson *package* declares `[requirements] moc = "1.14.0"`, because its
codec layer (`lib.mo`, `*Json.mo`) uses implicit arguments. A mops dependency
would therefore push that requirement onto every consumer of serde-core — and
the whole connector fleet is pinned at moc 1.6.0.

`Json.mo` itself uses **no implicits** and needs only `core`. It was verified to
compile clean under moc 1.6.0 as well as 1.16.0, so vendoring this one file
takes the parser without moving anyone's toolchain.

Only `Json.mo` is taken; the codec layer is not used. Re-sync by copying
`src/Json.mo` from a newer jayson release and re-running `mops test`.
