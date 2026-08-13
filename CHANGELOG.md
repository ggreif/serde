# Changelog

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
