# Changelog

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
