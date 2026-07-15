# Changelog

## 0.2.0

De-base: `serde-core`'s own code no longer depends on `mo:base` or `mo:map`.

- Migrated all `mo:base`/`mo:map` usage to `mo:core`: mutable `core/Map` + `core/Set` (kept
  by-reference so the recursive-type cycle guard propagates across calls), `core/pure/Map` where a
  build-once map is passed to a pure consumer, and `mo:base/Buffer` → a `core/List`-backed
  `Utils.Buffer` wrapper.
- `mops.toml`: **no `base` in runtime dependencies.** The vendored submodules `json.mo` and
  `parser-combinators.mo` were also migrated to core (base `List` → `core/pure/List` incl. the
  `push`→`pushFront` arg-swap, `Float.format` arg-order/`Nat8` spec, `toIter`→`values`). `base@0.16`
  and `map@9.0` are now **dev-only** (tests/benches). Core-aligned aliases; toolchain `moc = "1.6.0"`.
  (Residual `base@0.10` still enters transitively via `itertools@0.2.2` — tracked separately.)
- Fixes the recursive-type stack-overflow that a pure-`Set` refactor had introduced (un-threaded
  local sets lost the "visited" state); the proven mutable-set guard is preserved.
- No public API changes. Verified on moc 1.6.0: 0 errors, no deprecation warnings; `mops test`
  passes all suites (incl. CyclicTypeTable, Candid.Large, Stress, JSON escaping).

_Prior 0.1.x history: see the `skip-null-fields` lineage (JSON escaping, `skip_null_fields`,
TypedSerializer, Candid recursive-type cycle fix)._
