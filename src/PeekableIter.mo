/// Peekable Iterator
///
/// An iterator equipped with a `peek` method that returns the next value without advancing the iterator.
///
/// Vendored from `itertools@0.2.2/PeekableIter` and migrated to `mo:core` so that
/// serde-core no longer depends on `itertools` (which transitively pulls `base`).
///
import Iter "mo:core/Iter";

module {
    /// Peekable Iterator Type.
    public type PeekableIter<T> = Iter.Iter<T> and {
        peek : () -> ?T;
    };

    /// Creates a `PeekableIter` from an `Iter`.
    public func fromIter<T>(iter : Iter.Iter<T>) : PeekableIter<T> {
        var next_item = iter.next();

        return object {
            public func peek() : ?T {
                next_item;
            };

            public func next() : ?T {
                switch (next_item) {
                    case (?val) {
                        next_item := iter.next();
                        ?val;
                    };
                    case (null) {
                        null;
                    };
                };
            };
        };
    };

    public func hasNext<T>(iter : PeekableIter<T>) : Bool {
        switch (iter.peek()) {
            case (?_) { true };
            case (null) { false };
        };
    };

    public func isNext<T>(iter : PeekableIter<T>, val : T, isEq : (T, T) -> Bool) : Bool {
        switch (iter.peek()) {
            case (?v) { isEq(v, val) };
            case (null) { false };
        };
    };

    /// Skips elements continuously while the predicate is true.
    public func skipWhile<A>(iter : PeekableIter<A>, pred : (A) -> Bool) {
        label l loop {
            switch (iter.peek()) {
                case (?val) {
                    if (not pred(val)) {
                        break l;
                    };

                    ignore iter.next();
                };
                case (_) {
                    break l;
                };
            };
        };
    };

    /// Creates an iterator that returns elements from the given iter while the predicate is true.
    public func takeWhile<A>(iter : PeekableIter<A>, predicate : A -> Bool) : PeekableIter<A> {
        var iterate = true;

        return object {
            public func next() : ?A {
                if (not iterate) return null;

                let item = switch (iter.peek()) {
                    case (?item) item;
                    case (_) {
                        iterate := false;
                        return null;
                    };
                };

                if (predicate(item)) {
                    iter.next();
                } else {
                    iterate := false;
                    null;
                };
            };

            public func peek() : ?A = iter.peek();
        };
    };
};
