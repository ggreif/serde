import List "mo:core/List";
import Iter "mo:core/Iter";

module {

  public type Buffer<T> = {
    write : (T) -> ();
  };

  public func writeMany<T>(buffer : Buffer<T>, items : Iter.Iter<T>) {
    for (item in items) {
      buffer.write(item);
    };
  };

  public func fromList<T>(list : List.List<T>) : Buffer<T> {
    {
      write = func(item : T) {
        List.add(list, item);
      };
    };
  };

  public func fromArray<T>(array : [var T], startIndex : Nat) : Buffer<T> {
    var i = startIndex;
    {
      write = func(item : T) {
        array[i] := item;
        i += 1;
      };
    };
  };
};
