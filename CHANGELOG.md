# Changelog

## 0.3.0

New JSON parser and printer: `submodules/json.mo` (aviate-labs) is replaced by the parser from
**jayson 0.1.1** by Christoph Hegemann, vendored as `submodules/jayson/src/Json.mo`. A minor bump
rather than a patch, because serialiser output changed for every consumer — see *What you may feel*
below.

Vendored rather than depended on: the jayson *package* declares `[requirements] moc = "1.14.0"` for
its codec layer, which a dependency would push onto every consumer of `serde-core`. `Json.mo` alone
uses no implicit arguments and needs only `core`; it compiles clean under moc 1.6.0 and 1.16.0.
Provenance, commit SHA and sha256 are recorded in `submodules/jayson/PROVENANCE.md`.
`submodules/parser-combinators.mo` stays — UrlEncoded and the Candid text parser still use it.

### Six classes of defect fixed

- **Five malformed inputs crashed the canister.** Malformed surrogate escapes — a lone low
  surrogate, a high surrogate followed by a non-surrogate, two highs, a low then a high, and a
  reversed pair — trapped (`wasm unreachable`) instead of returning `#err`. Since JSON parsing runs
  on HTTP response bodies, any endpoint returning one took the calling canister down. A lone *high*
  surrogate was correctly rejected, which disguised the rest of the family.
- **Negative fractions lost their sign.** The sign was applied to the integer part and the fraction
  added afterwards, so any negative number with a zero integer part came back positive: `-0.5`
  parsed as `0.5`, `-0.25` as `0.25`. `-1.5` and `-10.5` were unaffected, which is why it survived.
- **No recursion guard.** The parser descended without bound, accepted 2000 levels of nesting and on
  a deep enough body exhausted the Wasm stack and trapped. Input past **512** levels is now refused
  with an `#err`.
- **Floats were truncated to two decimal places.** `123.123456789` serialised as `123.12`, pi as
  `3.14`, `1e-300` as `0`. Every connector sending a float — quantities, rates, coordinates,
  ratings — was losing precision.
- **Valid JSON rejected, invalid JSON accepted.** RFC 8259's `exp` production allows a signed
  exponent, but `1e+2`, `1E+2`, `1.5e+3` and `0e+0` were rejected as malformed. Conversely, leading
  zeros (`01` read as `1`) and raw control characters inside strings were accepted — with U+0001 and
  U+001F silently *deleted*, making corrupt input indistinguishable from clean.
- **String escaping lived in the wrong place.** The old `show` emitted string contents verbatim,
  producing invalid JSON for any value containing a quote, backslash or control character;
  `ToText.mo` compensated with `escapeJSONString` before every call. jayson's `stringify` escapes per
  RFC 8259 section 7 itself, so that helper is **deleted** and the invariant lives in the printer.
  `FromText.mo`'s matching input-side `Text.replace` hack goes too.

### What you may feel

All of these are output or acceptance changes, not API changes — same modules, same signatures:

- **Floats print in full precision.** `123.12` becomes `123.123456789`, `1.50` becomes `1.5`.
- **Output is compact.** `{"a": 1}` becomes `{"a":1}`, which also trims bytes off every outcall body.
- **Unicode escapes use upper-case hex digits**, where the previous encoder used lower case. RFC 8259
  fixes neither case and every parser accepts both.
- **Parsing is stricter**: leading zeros and raw control characters in strings are now rejected, and
  nesting deeper than 512 levels is refused.
- **Parsing is also looser**: signed positive exponents (`1e+2`) now parse.

If you assert on serialised JSON as text, expect golden-string diffs. Values round-trip unchanged.

### Tests

**215 to 357.** Beyond the 31 cases pinning the fixes above, this release adds 111 cases closing
gaps the suite had regardless of the parser swap: the first negative tests (all 27 prior uses of
`#err` were error-unwrapping on the success path), property tests for JSON, UrlEncoded and CBOR
(only Candid was fuzzed before), coverage for `Candid.decodeOne` and `JSON.fromCandidWith` (both
exported with zero test references), and for `src/Candid/Text/Parser/` (15 modules, ~900 lines that
nothing called).

Three defects in **UrlEncoded** surfaced while writing those and are *not* fixed here — they are
pinned as characterisation tests marked `KNOWN DEFECT` so a later fix fails loudly: it does no
percent-encoding in either direction, so a value containing `&` makes the wire text un-decodable and
one containing `=` is silently truncated; an empty value decodes as `#Null` rather than `#Text("")`;
and a percent-escape in input arrives as literal characters.

## 0.2.1

Packaging only — no public API changes. Consumers now build on `core` alone: no `base`, no
`buffer`, no second `core`.

- A build depending on `serde-core` resolves exactly **`core` + `sha2`** (verified with a probe
  project holding `serde-core` as a non-root dependency, plus a consumer `main.mo` calling
  `Serde.JSON.fromText`). The same probe previously pulled `buffer@0.1.0` → `base@0.16.0` and
  `core@1.0.0` alongside `core@2`.
- Vendored the packages that carried those dependencies, wired by relative import so no downstream
  root can outvote them: `submodules/buffer` (de-based, `core@2`), `submodules/cbor`,
  `submodules/xtended-numbers`, `submodules/ByteUtils`. `[dependencies]` is now just `core` and
  `sha2`.
- Their `mo:core@1/…` imports became `mo:core/…` (64 sites), which also retires the multi-version
  `core`. All three trees typecheck against `core@2.4.0` with 0 errors.
- **If you imported one of those packages *through* serde-core** — `mo:cbor@4.1.0/…`,
  `mo:xtended-numbers/…`, `mo:buffer@0` — without declaring it yourself, you must now add it to your
  own `mops.toml`. Relying on a transitive alias was never supported, hence a patch release.
- Upstream context: `ByteUtils`' org is archived and the `buffer` fix has sat in
  edjCase/motoko_buffer#1 since 2026-07-15 unanswered. If those land upstream, drop the vendored
  copies and go back to the registry.
- `base` remains **dev-only** (`fuzz`, `tests/BenchTypes.mo`) and does not reach consumers.
- `mops test` passes 16 files (the vendored `buffer` and `ByteUtils` bring their own suites);
  toolchain `moc = "1.6.0"`, `wasmtime = "47.0.3"`, benches on `pocket-ic`.

## 0.2.0

De-base: `serde-core`'s own code no longer depends on `mo:base` or `mo:map`.

- Migrated all `mo:base`/`mo:map` usage to `mo:core`: mutable `core/Map` + `core/Set` (kept
  by-reference so the recursive-type cycle guard propagates across calls), `core/pure/Map` where a
  build-once map is passed to a pure consumer, and `mo:base/Buffer` → a `core/List`-backed
  `Utils.Buffer` wrapper.
- Vendored submodules `json.mo` and `parser-combinators.mo` also migrated to core
  (base `List` → `core/pure/List`, `Float.format` arg order, etc.).
- Dropped the `itertools@0.2.2` dependency (pulled `base@0.10.4`); migrated to `mo:core`
  and vendored `src/PeekableIter.mo` for the `peekable`/`takeWhile` gap.
- Bumped `sha2` **0.1.6 → 0.2.5** (0.1.6 pulled `base@0.14.14`; 0.2.5 is `core`-only).
  `RepIndyHash.mo` migrated to 0.2.5's functional digest API (`Sha256.new`/`writeBlob`/`sum`/…).
- `mops.toml`: `base`/`map` are now **dev-only** (tests/benches). The only `base` left in a
  consumer build is `base@0.16.0`, pulled by `buffer@0.1.0` (a dep of `cbor` + `xtended-numbers`,
  both latest/base-based upstream). Toolchain `moc = "1.6.0"`.
- Fixes the recursive-type stack-overflow that a pure-`Set` refactor had introduced (un-threaded
  local sets lost the "visited" state); the proven mutable-set guard is preserved.
- No public API changes. Verified on moc 1.6.0: 0 errors, no deprecation warnings; `mops test`
  passes all suites (incl. CyclicTypeTable, Candid.Large, Stress, JSON escaping).

_Prior 0.1.x history: see the `skip-null-fields` lineage (JSON escaping, `skip_null_fields`,
TypedSerializer, Candid recursive-type cycle fix)._
