# jayson — vendored `Json.mo`

`src/Json.mo` is copied verbatim from **jayson 0.1.1**
(<https://github.com/christoph-dfinity/motoko-jayson>, also on mops as
`jayson@0.1.1`), by Christoph Hegemann. Licensed **Apache-2.0**; serde-core is
MIT, and Apache-2.0 permits this provided the notice is retained — hence this
file.

## Exactly which bytes

Recorded so nobody has to re-derive it. Verified 2026-09-24:

| | |
|---|---|
| mops package | `jayson@0.1.1` (published 2026-09-21) |
| git commit | `464911faed0a` — `main` HEAD when this was taken |
| last commit touching `src/Json.mo` | `0aae0ef4d4ca`, 2026-08-13 |
| sha256 of `src/Json.mo` | `2e7b8eb105d192a66f1bd3a42ac6083106676b8511b05540e2e3ea589358ed62` |
| size | 794 lines |

The copy here is byte-identical to **all three** of: the published
`jayson@0.1.1` tarball, the repository at `464911faed0a`, and the repository at
`0aae0ef4d4ca`. `Json.mo` has not changed upstream since 2026-08-13, so taking
`main` HEAD and taking the release give the same file.

To re-check without trusting any of the above:

```sh
shasum -a 256 submodules/jayson/src/Json.mo
```

### A naming trap, if you go looking upstream

The version number cannot be found in git history, and the two upstream sources
disagree about their own identity:

- the **published package** calls itself `name = "jayson"`, `version = "0.1.1"`
- the **GitHub repository** calls itself `name = "motoko-jayson"`,
  `version = "1.0.0"` — at every commit, including HEAD

So `0.1.1` exists only in the mops registry; it was published from a working
copy whose `mops.toml` was never pushed. The repository also carries no tags
and no releases, and the published package sets `repository = ""`, so mops does
not link back either. **The commit SHA above is the only durable pin** — prefer
it to the version number when re-syncing.

## Why vendored rather than depended on

The jayson *package* declares `[requirements] moc = "1.14.0"`, because its
codec layer (`lib.mo`, `*Json.mo`) uses implicit arguments. A mops dependency
would therefore push that requirement onto every consumer of serde-core — and
the whole connector fleet is pinned at moc 1.6.0.

`Json.mo` itself uses **no implicits** and needs only `core`. It was verified to
compile clean under moc 1.6.0 as well as 1.16.0, so vendoring this one file
takes the parser without moving anyone's toolchain.

Only `Json.mo` is taken; the codec layer is not used.

To re-sync: copy `src/Json.mo` from a newer upstream commit, update the table
above (commit SHA and sha256, not just the version), and re-run `mops test`.
The JSON suite is deliberately strict about parser behaviour — malformed
surrogate escapes, the recursion guard, signed exponents, leading zeros, raw
control characters and float round-tripping are all pinned — so a regression in
a newer upstream should surface there rather than in a connector.
