import Bool "mo:core/Bool";
import Char "mo:core/Char";
import Float "mo:core/Float";
import Int "mo:core/Int";
import Iter "mo:core/Iter";
import List "mo:core/List";
import Nat32 "mo:core/Nat32";
import Text "mo:core/Text";
import { type Iter } "mo:core/Types";

/// JSON values, and conversions to and from their textual form.
module Json {

  /// A JSON value, as defined by RFC 8259.
  ///
  /// Numbers keep the Int/Float distinction of the source document: a lexeme
  /// with a fraction or an exponent decodes to `#Float`, every other number to
  /// `#Int`. Motoko's `Int` is arbitrary precision, so integers never lose
  /// range, but `#Float` is an IEEE 754 double and does lose precision.
  ///
  /// Objects are a list of pairs rather than a map, so that key order and
  /// duplicate keys survive a roundtrip.
  public type Json = {
    #Null;
    #Bool : Bool;
    #Number : Number;
    #String : Text;
    #Array : [Json];
    #Object : [(Text, Json)];
  };

  public type Number = {
    #Int : Int;
    #Float : Float
  };

  /// Parse a JSON document, returning `null` if it is not valid JSON.
  ///
  /// A document is a single value, optionally surrounded by whitespace, and
  /// nothing else — trailing content is an error rather than being ignored.
  ///
  /// Two cases RFC 8259 leaves to the implementation: an escape denoting a lone
  /// surrogate, like `"\uD800"`, is rejected, because Motoko's `Char` is a
  /// Unicode scalar value and cannot hold one; and nesting is limited to
  /// `maxDepth`.
  public func parse(input : Text) : ?Json {
    let chars = cursor(input);
    skipWhitespace(chars);
    let ?value = parseValue(chars, 0) else return null;
    skipWhitespace(chars);
    if (chars.peek() != null) return null;
    ?value
  };

  /// How deeply arrays and objects may nest before a document is rejected.
  ///
  /// This is a recursive-descent parser, so nesting costs stack. Left unbounded,
  /// a document like `[[[[...` exhausts it and traps — measured at between 20k
  /// and 50k levels with a 4MB wasm stack — and a trap takes down the whole
  /// message, which is far worse than refusing the document. JSONTestSuite
  /// expects such documents to be rejected in any case.
  public let maxDepth = 512;

  /// A single-character-lookahead cursor over the input.
  ///
  /// JSON needs no more lookahead than this and no context-sensitive lexing, so
  /// the parser reads characters directly instead of tokenizing first.
  type Cursor = {
    chars : Iter<Char>;
    var lookahead : ?Char;
  };

  func cursor(input : Text) : Cursor {
    { chars = input.chars(); var lookahead = null }
  };

  func peek(self : Cursor) : ?Char {
    switch (self.lookahead) {
      case null {
        self.lookahead := self.chars.next();
        self.lookahead
      };
      case some some;
    }
  };

  func next(self : Cursor) : ?Char {
    switch (self.lookahead) {
      case null self.chars.next();
      case (?char) {
        self.lookahead := null;
        ?char
      };
    }
  };

  func eat(self : Cursor, char : Char) : Bool {
    if (self.peek() == ?char) {
      ignore self.next();
      true
    } else {
      false
    }
  };

  func nextIf(self : Cursor, predicate : Char -> Bool) : ?Char {
    let ?char = self.peek() else return null;
    if (predicate(char)) self.next() else null
  };

  /// The four characters RFC 8259 allows between tokens. Notably not a BOM, and
  /// not any of the other Unicode whitespace.
  func skipWhitespace(chars : Cursor) {
    loop {
      switch (chars.peek()) {
        case (?(' ' or '\t' or '\n' or '\r')) ignore chars.next();
        case _ return;
      }
    }
  };

  func parseValue(chars : Cursor, depth : Nat) : ?Json {
    let ?char = chars.peek() else return null;
    switch char {
      case '{' parseObject(chars, depth);
      case '[' parseArray(chars, depth);
      case '\"' {
        let ?text = parseString(chars) else return null;
        ?#String(text)
      };
      case 't' if (keyword(chars, "true")) ?#Bool(true) else null;
      case 'f' if (keyword(chars, "false")) ?#Bool(false) else null;
      case 'n' if (keyword(chars, "null")) ?#Null else null;
      case _ parseNumber(chars);
    }
  };

  func keyword(chars : Cursor, word : Text) : Bool {
    for (expected in word.chars()) {
      if (not chars.eat(expected)) return false;
    };
    true
  };

  func parseArray(chars : Cursor, depth : Nat) : ?Json {
    if (depth >= maxDepth) return null;
    if (not chars.eat('[')) return null;
    skipWhitespace(chars);
    if (chars.eat(']')) return ?#Array([]);

    let elements = List.empty<Json>();
    loop {
      skipWhitespace(chars);
      let ?element = parseValue(chars, depth + 1) else return null;
      elements.add(element);
      skipWhitespace(chars);
      // A trailing comma leaves the loop expecting a value and fails above.
      if (chars.eat(']')) return ?#Array(elements.toArray());
      if (not chars.eat(',')) return null;
    }
  };

  func parseObject(chars : Cursor, depth : Nat) : ?Json {
    if (depth >= maxDepth) return null;
    if (not chars.eat('{')) return null;
    skipWhitespace(chars);
    if (chars.eat('}')) return ?#Object([]);

    let fields = List.empty<(Text, Json)>();
    loop {
      skipWhitespace(chars);
      // Keys must be strings; bare identifiers are not JSON.
      let ?key = parseString(chars) else return null;
      skipWhitespace(chars);
      if (not chars.eat(':')) return null;
      skipWhitespace(chars);
      let ?value = parseValue(chars, depth + 1) else return null;
      fields.add((key, value));
      skipWhitespace(chars);
      if (chars.eat('}')) return ?#Object(fields.toArray());
      if (not chars.eat(',')) return null;
    }
  };

  func parseString(chars : Cursor) : ?Text {
    if (not chars.eat('\"')) return null;
    var result = "";
    loop {
      // Running out of input means the string was never closed.
      let ?char = chars.next() else return null;
      switch char {
        case '\"' return ?result;
        case '\\' {
          let ?escape = chars.next() else return null;
          switch escape {
            case '\"' result #= "\"";
            case '\\' result #= "\\";
            case '/' result #= "/";
            case 'b' result #= "\u{08}";
            case 'f' result #= "\u{0C}";
            case 'n' result #= "\n";
            case 'r' result #= "\r";
            case 't' result #= "\t";
            case 'u' {
              let ?escaped = parseUnicodeEscape(chars) else return null;
              result #= escaped.toText();
            };
            case _ return null;
          };
        };
        case _ {
          // Control characters have to be escaped inside a string.
          if (char.toNat32() < 0x20) return null;
          result #= char.toText();
        };
      };
    }
  };

  /// Parse the four hex digits after `\u`, joining a surrogate pair into the
  /// single scalar value it encodes. A lone surrogate is rejected; see `parse`.
  func parseUnicodeEscape(chars : Cursor) : ?Char {
    let ?first = hexQuad(chars) else return null;
    if (first < 0xD800 or first > 0xDFFF) {
      return ?Char.fromNat32(first);
    };
    // A low surrogate cannot come first.
    if (first > 0xDBFF) return null;
    if (not chars.eat('\\')) return null;
    if (not chars.eat('u')) return null;
    let ?second = hexQuad(chars) else return null;
    if (second < 0xDC00 or second > 0xDFFF) return null;
    ?Char.fromNat32(0x10000 + (first - 0xD800) * 0x400 + (second - 0xDC00))
  };

  func hexQuad(chars : Cursor) : ?Nat32 {
    var value : Nat32 = 0;
    var digits = 0;
    while (digits < 4) {
      let ?char = chars.next() else return null;
      let ?digit = hexValue(char) else return null;
      value := value * 16 + digit;
      digits += 1;
    };
    ?value
  };

  func hexValue(char : Char) : ?Nat32 {
    let code = char.toNat32();
    if (code >= 0x30 and code <= 0x39) return ?(code - 0x30); // 0-9
    if (code >= 0x41 and code <= 0x46) return ?(code - 0x41 + 10); // A-F
    if (code >= 0x61 and code <= 0x66) return ?(code - 0x61 + 10); // a-f
    null
  };

  /// Parse a number, per the JSON grammar: an optional `-`, an integer part with
  /// no leading zeros, then an optional fraction and an optional exponent. A
  /// leading `+`, a bare `.5` or a trailing `5.` are all rejected.
  ///
  /// A lexeme with a fraction or an exponent becomes a `#Float`, anything else
  /// an `#Int`. `-0` therefore loses its sign, since `Int` has no negative zero,
  /// while `-0.0` keeps it.
  func parseNumber(chars : Cursor) : ?Json {
    let negative = chars.eat('-');

    var significand : Int = 0;
    var exponent : Int = 0;
    var isFloat = false;

    if (chars.eat('0')) {
      // `0` may not be followed by more digits.
      switch (chars.peek()) {
        case (?char) if (char.isDigit()) return null;
        case _ {};
      };
    } else {
      let ?first = chars.nextIf(Char.isDigit) else return null;
      significand := digitValue(first);
      loop {
        let ?digit = chars.nextIf(Char.isDigit) else break;
        significand := significand * 10 + digitValue(digit);
      };
    };

    if (chars.eat('.')) {
      isFloat := true;
      // At least one digit has to follow the point.
      let ?first = chars.nextIf(Char.isDigit) else return null;
      significand := significand * 10 + digitValue(first);
      exponent -= 1;
      loop {
        let ?digit = chars.nextIf(Char.isDigit) else break;
        significand := significand * 10 + digitValue(digit);
        exponent -= 1;
      };
    };

    if (chars.eat('e') or chars.eat('E')) {
      isFloat := true;
      let negativeExponent = if (chars.eat('-')) true else {
        ignore chars.eat('+');
        false
      };
      let ?first = chars.nextIf(Char.isDigit) else return null;
      var magnitude : Int = digitValue(first);
      loop {
        let ?digit = chars.nextIf(Char.isDigit) else break;
        // Clamped so that `1e99999999999999` cannot make us build an absurd
        // integer. Anything past this already overflows or underflows a double,
        // and the clamped value overflows the same way.
        if (magnitude <= 1_000_000) {
          magnitude := magnitude * 10 + digitValue(digit);
        };
      };
      exponent += (if (negativeExponent) -magnitude else magnitude);
    };

    if (isFloat) {
      let magnitude = decimalToFloat(significand, exponent);
      ?#Number(#Float(if (negative) -magnitude else magnitude))
    } else {
      ?#Number(#Int(if (negative) -significand else significand))
    }
  };

  func digitValue(char : Char) : Nat {
    Nat32.toNat(char.toNat32() - 0x30)
  };

  /// The double nearest to `self`, correctly rounded.
  ///
  /// A `#Int` goes through the same exact arithmetic a `#Float` lexeme does, so
  /// `1` and `1.0` convert alike. Neither `Float.fromInt` (deprecated) nor a hop
  /// through `Int64` would do: `Int` here is arbitrary precision, so the latter
  /// traps on the very integers this parser keeps intact. Out of range gives
  /// infinity, as an overflowing lexeme does in `parse`.
  public func toFloat(self : Number) : Float {
    switch self {
      case (#Float(float)) float;
      case (#Int(int)) {
        if (int < 0) -decimalToFloat(Int.abs(int), 0) else decimalToFloat(int, 0)
      };
    }
  };

  /// The number of significant bits in a double, and the binary exponent of the
  /// smallest subnormal one.
  let significandBits = 53;
  let minSubnormalShift = 1074;
  let twoToSignificandBits : Int = 9007199254740992; // 2 ** 53

  /// Convert `significand * 10 ^ exponent` (with `significand >= 0`) to the
  /// nearest double, rounding ties to even — what a correct `strtod` does.
  ///
  /// This is done with exact integer arithmetic rather than by chaining Float
  /// operations. `Int` is arbitrary precision, so the value is held as an exact
  /// rational `numerator / denominator` and only the final division rounds.
  /// Computing `Float.fromInt(significand) * 10.0 ** exponent` instead would
  /// round up to three times and land a bit off for inputs like `0.1`, which
  /// `test/Conformance.test.mo` catches as a roundtripping failure.
  func decimalToFloat(significand : Int, exponent : Int) : Float {
    if (significand == 0) return 0.0;

    // Bail out before building enormous integers. A double tops out just past
    // 1e308 and its smallest subnormal is near 1e-324, so beyond these bounds
    // the answer is already infinity or zero.
    let magnitude = decimalDigits(significand) + exponent;
    if (magnitude > 310) return 1.0 / 0.0;
    if (magnitude < -350) return 0.0;

    var numerator = significand;
    var denominator : Int = 1;
    if (exponent >= 0) {
      numerator *= pow(10, Int.abs(exponent));
    } else {
      denominator := pow(10, Int.abs(exponent));
    };

    // Scale by a power of two so the quotient is exactly 53 bits wide: those are
    // the significant bits of the result, and the leftover remainder says how to
    // round. `value == quotient * 2 ** -shift`.
    //
    // Comparing bit lengths estimates the needed scale to within one bit, so the
    // loops below correct it.
    var shift = significandBits - (bitLength(numerator) - bitLength(denominator));

    // Subnormals have a fixed smallest exponent instead of a full 53 bits, so
    // never scale past it — that is what makes gradual underflow come out right.
    if (shift > minSubnormalShift) shift := minSubnormalShift;

    var quotient : Int = 0;
    var remainder : Int = 0;
    var divisor : Int = 1;

    func divide() {
      if (shift >= 0) {
        let scaled = numerator * pow(2, Int.abs(shift));
        quotient := scaled / denominator;
        remainder := scaled % denominator;
        divisor := denominator;
      } else {
        divisor := denominator * pow(2, Int.abs(shift));
        quotient := numerator / divisor;
        remainder := numerator % divisor;
      };
    };

    // Nudge the scale until the quotient really is 53 bits wide, testing against
    // the two bounds directly: a comparison is one bignum operation, where
    // `bitLength` costs one per bit and this is the hot path.
    divide();
    while (quotient >= twoToSignificandBits) {
      shift -= 1;
      divide();
    };
    while (shift < minSubnormalShift and quotient < twoToSignificandBits / 2) {
      shift += 1;
      divide();
    };

    // Round to nearest, ties to even.
    let twiceRemainder = remainder * 2;
    if (twiceRemainder > divisor or (twiceRemainder == divisor and quotient % 2 == 1)) {
      quotient += 1;
      // Rounding up can carry into a new bit, turning 2^53 - 1 into 2^53.
      if (quotient >= twoToSignificandBits) {
        quotient /= 2;
        shift -= 1;
      };
    };

    // `quotient` is at most 2^53 and so exactly representable, and halving or
    // doubling a float is exact as long as we stay in range — which the clamp on
    // `shift` and the bail-out above ensure.
    //
    // Scaling goes in strides of 32 bits so that a subnormal, needing over a
    // thousand halvings, does not cost a thousand iterations. The stride is itself
    // an exact power of two, and the value only ever moves towards the result, so
    // no intermediate step can overflow or underflow when the result does not.
    var result = Float.fromInt(quotient);
    var remaining = shift;
    while (remaining >= 32) {
      result /= 4294967296.0; // 2 ** 32
      remaining -= 32;
    };
    while (remaining <= -32) {
      result *= 4294967296.0;
      remaining += 32;
    };
    while (remaining > 0) {
      result /= 2.0;
      remaining -= 1;
    };
    while (remaining < 0) {
      result *= 2.0;
      remaining += 1;
    };
    result
  };

  func pow(base : Int, exponent : Nat) : Int {
    var result : Int = 1;
    var squared = base;
    var remaining = exponent;
    while (remaining > 0) {
      if (remaining % 2 == 1) result *= squared;
      remaining /= 2;
      if (remaining > 0) squared *= squared;
    };
    result
  };

  /// Only used to estimate the scale in `decimalToFloat`, so it steps down 32
  /// bits at a time before finishing bit by bit — each step is a bignum division
  /// and there can be a thousand bits to get through.
  func bitLength(value : Int) : Int {
    var remaining = value;
    var bits : Int = 0;
    while (remaining >= 4294967296) {
      remaining /= 4294967296; // 2 ** 32
      bits += 32;
    };
    while (remaining > 0) {
      remaining /= 2;
      bits += 1;
    };
    bits
  };

  func decimalDigits(value : Int) : Int {
    var remaining = value;
    var digits : Int = 0;
    while (remaining > 0) {
      remaining /= 10;
      digits += 1;
    };
    digits
  };

  /// Render a JSON value as a document, without insignificant whitespace.
  ///
  /// `stringify` is not the exact inverse of `parse`: whitespace is dropped and
  /// numbers are re-rendered from their decoded form, so `1.0e2` comes back as
  /// `100.0`. It is a fixpoint after one pass though, which is what
  /// `test/Conformance.test.mo` checks.
  ///
  /// A non-finite `#Float` has no JSON representation and is rendered as `inf`,
  /// `-inf` or `NaN`, none of which parse back.
  public func stringify(self : Json) : Text {
    switch self {
      case (#Null) "null";
      case (#Bool(bool)) bool.toText();
      case (#Number(#Int(int))) int.toText();
      case (#Number(#Float(float))) floatToText(float);
      case (#String(text)) quote(text);
      case (#Array(elements)) {
        var result = "[";
        var first = true;
        for (element in elements.values()) {
          if (not first) result #= ",";
          first := false;
          result #= stringify(element);
        };
        result # "]"
      };
      case (#Object(fields)) {
        var result = "{";
        var first = true;
        for ((key, value) in fields.values()) {
          if (not first) result #= ",";
          first := false;
          result #= quote(key);
          result #= ":";
          result #= stringify(value);
        };
        result # "}"
      };
    }
  };

  /// Wrap `self` in double quotes, escaping what RFC 8259 requires: `"`, `\`,
  /// and every character below U+0020. Everything else is emitted verbatim.
  public func quote(self : Text) : Text {
    var result = "\"";
    for (char in self.chars()) {
      result #= switch char {
        case '\"' "\\\"";
        case '\\' "\\\\";
        case '\u{08}' "\\b";
        case '\u{0C}' "\\f";
        case '\n' "\\n";
        case '\r' "\\r";
        case '\t' "\\t";
        case _ {
          let code = char.toNat32();
          if (code < 0x20) {
            "\\u00" # Char.toText(hexDigit(code / 16)) # Char.toText(hexDigit(code % 16))
          } else {
            char.toText()
          }
        };
      };
    };
    result # "\""
  };

  /// Seventeen significant digits always read back as the double they came from,
  /// so no rendering needs more and the shortest search never looks past it.
  let roundTripDigits = 17;

  /// `#exp` is asked for more digits than a rendering can ever need because the
  /// decision of which way to round at a given length is made on the digits that
  /// fall off the end, and those have to be the true ones. Both backends give the
  /// exact expansion of the double here, where at seventeen digits they would
  /// already have rounded it: `0.21791061013936996` is exactly `...9645996...`,
  /// whose eighteenth digit is a 4, but `#exp 17` renders it `...965`, which
  /// would round the seventeen-digit rendering the wrong way.
  ///
  /// A double's exact expansion can run to hundreds of digits, so this is not
  /// always all of them, and past here `#exp` rounds like anything else. That
  /// costs nothing that can be observed: for the rounding to mislead, the
  /// expansion would have to carry on past the thirtieth digit after a `5` and a
  /// run of zeros, and the two renderings it would then be choosing between are
  /// both shortest and both read back as the same double.
  let exactPrecision : Nat8 = 30;

  /// Render a float as the shortest JSON number that parses back to exactly it.
  ///
  /// `Float.format` cannot be used directly for this. Its `#exact` and `#gen`
  /// modes disagree between backends: the interpreter renders them like `%g`,
  /// but in compiled wasm they are fixed-point, so `1e-78` comes out as
  /// `0.00000000000000000` and the value is gone. `#exp` is the one mode that
  /// agrees and never loses anything, but it prints every digit it is asked for
  /// and no fewer (`0.5` as `5.000...0e-1`).
  ///
  /// So `#exp` supplies the digits, `parse` decides how few of them are enough,
  /// and the layout happens here — positional for ordinary magnitudes and
  /// exponential outside them, at the thresholds JavaScript uses. The result
  /// always carries a `.` or an `e`, so it reads back as `#Float` rather than
  /// `#Int`, which is what makes `parse ∘ stringify` stable.
  func floatToText(float : Float) : Text {
    // Non-finite floats have no JSON representation at all, so pass them through
    // rather than inventing one. Only these lack an exponent. See `stringify`.
    let full = float.format(#exp exactPrecision);
    if (not full.contains(#char 'e')) return full;

    // Split `[-]D[.DDD]e[±]X` into its digits and the decimal exponent of the
    // first one. Backends differ here too — `e+02` versus `e2` — so both the
    // sign and any padding are handled.
    var negative = false;
    var digits = "";
    var exponentText = "";
    var inExponent = false;
    for (char in full.chars()) {
      if (char == 'e') {
        inExponent := true;
      } else if (inExponent) {
        if (char != '+') exponentText #= char.toText();
      } else if (char == '-') {
        negative := true;
      } else if (char != '.') {
        digits #= char.toText();
      };
    };
    let ?exponent = Int.fromText(exponentText) else return full;

    // Cutting the digits to some length leaves two candidates for a rendering of
    // that length: the digits as cut, and that plus one in the last place. Which
    // of the two is nearer the value is decided by the digits that fall off the
    // end.
    func nearest(length : Nat) : (Text, Int) {
      roundDigits(digits, length, roundsUp(digits, length))
    };

    // Shortest wins, and it is never longer than this. Seventeen digits always
    // read back; so does the expansion once it has run out of significant digits,
    // which is the common case — a document tends to have been written by hand or
    // by another serializer, and `1.4` is two digits rather than seventeen.
    //
    // That shorter bound is safe because two distinct doubles differ somewhere in
    // their first seventeen digits: an expansion that is zeros from the
    // eighteenth on is nearer to the value it was cut from than to any other
    // double, so it reads back.
    let significantDigits = stripTrailingZeros(digits).size();
    let longest = if (significantDigits < roundTripDigits) significantDigits else roundTripDigits;

    let fallback = nearest(longest);
    var shortestDigits = fallback.0;
    var shortestExponent = exponent + fallback.1;

    // Sets the result and returns whether that rendering reads back exactly.
    func accept(length : Nat, roundUp : Bool) : Bool {
      let (candidate, carried) = roundDigits(digits, length, roundUp);
      let candidateExponent = exponent + carried;
      if (parse(exponential(negative, candidate, candidateExponent)) != ?#Number(#Float(float))) {
        return false
      };
      shortestDigits := candidate;
      shortestExponent := candidateExponent;
      true
    };

    // Both candidates have to be tried, not just the nearer one: the decimals
    // that read back as a given double are not spread evenly around it. At a
    // power of two the gap below is half the gap above, so the farther candidate
    // can be the one that reads back while the nearer one does not. `2 ** -24` is
    // the smallest case — exactly `5.9604644775390625e-8`, which at sixteen
    // digits sits midway between `...062` and `...063`, and only `...063` reads
    // back. Stopping at the nearer candidate would take that as proof that
    // sixteen digits are not enough and print seventeen.
    func readsBack(length : Nat) : Bool {
      let roundUp = roundsUp(digits, length);
      accept(length, roundUp) or accept(length, not roundUp)
    };

    // Digits are never worse for being more numerous: cutting to one more digit
    // lands at least as close to the value as cutting to one fewer, so a length
    // that reads back stays reading back as it widens. That makes the shortest
    // one a boundary to halve in on rather than a run to walk, and every length
    // not tried is a `parse` not run. `high` is only ever moved onto a length
    // that reads back, so the last rendering `accept` kept is the one it settles
    // on.
    var low = 1;
    var high = longest;
    while (low < high) {
      let middle = (low + high) / 2;
      if (readsBack(middle)) high := middle else low := middle + 1;
    };

    // Trailing zeros carry no information once the exponent is explicit.
    let significant = stripTrailingZeros(shortestDigits);

    let sign = if (negative) "-" else "";
    // Digits that belong before the decimal point.
    let pointPosition = shortestExponent + 1;

    if (pointPosition > 21 or pointPosition < -5) {
      return exponential(negative, significant, shortestExponent);
    };

    if (pointPosition <= 0) {
      return sign # "0." # repeatZeros(Int.abs(pointPosition)) # significant;
    };
    let width = significant.size();
    if (pointPosition >= width) {
      return sign # significant # repeatZeros(Int.abs(pointPosition) - width) # ".0";
    };
    let whole = Text.fromIter(significant.chars().take(Int.abs(pointPosition)));
    let fraction = Text.fromIter(significant.chars().drop(Int.abs(pointPosition)));
    sign # whole # "." # fraction
  };

  /// `[-]D[.DDD]e[±]X`: the form the shortest search asks `parse` about, and the
  /// one `stringify` emits outside the positional range.
  func exponential(negative : Bool, digits : Text, exponent : Int) : Text {
    let rest = Text.fromIter(digits.chars().drop(1));
    let mantissa = Text.fromIter(digits.chars().take(1)) # (if (rest == "") "" else "." # rest);
    let sign = if (negative) "-" else "";
    let exponentSign = if (exponent < 0) "-" else "+";
    sign # mantissa # "e" # exponentSign # Int.abs(exponent).toText()
  };

  /// The first `length` digits of `digits`, either cut there or rounded up in the
  /// last place. Rounding up can carry out of the leading digit — `999` becomes
  /// `100` — and the second component is the 1 the exponent gains when it does.
  ///
  /// `#exp` leaves exactly one nonzero digit before the point, so the digits kept
  /// are as many as asked for. The single exception is zero itself, whose digits
  /// are all zeros; one of them is enough for it and the search stops there.
  func roundDigits(digits : Text, length : Nat, up : Bool) : (Text, Int) {
    var value : Nat = 0;
    for (char in digits.chars().take(length)) {
      value := value * 10 + digitValue(char);
    };
    if (up) value += 1;
    let text = value.toText();
    if (text.size() > length) {
      (Text.fromIter(text.chars().take(length)), 1)
    } else {
      (text, 0)
    }
  };

  /// Whether cutting `digits` to `length` — at least one of them — should round
  /// the last kept digit up: what is dropped is past halfway, or exactly halfway
  /// with an odd digit left behind.
  ///
  /// The tie going to the even digit rather than to the larger candidate is the
  /// rule ECMA-262 recommends for the shortest form, so `1370.92657470703125`,
  /// which sits exactly between `1370.9265747070312` and `1370.9265747070313`
  /// with both reading back, renders as the former in JavaScript and here alike.
  func roundsUp(digits : Text, length : Nat) : Bool {
    let rest = digits.chars().drop(length);
    let ?dropped = rest.next() else return false;
    if (dropped != '5') return dropped > '5';
    for (char in rest) {
      if (char != '0') return true;
    };
    digitValue(digitAt(digits, length - 1)) % 2 == 1
  };

  /// The digit at `index`, or `'0'` where there is none — which the lengths the
  /// search works with never ask for.
  func digitAt(digits : Text, index : Nat) : Char {
    switch (digits.chars().drop(index).next()) {
      case (?char) char;
      case null '0';
    }
  };

  func stripTrailingZeros(digits : Text) : Text {
    var lastSignificant = 0;
    var index = 0;
    for (char in digits.chars()) {
      index += 1;
      if (char != '0') lastSignificant := index;
    };
    if (lastSignificant == 0) return "0";
    Text.fromIter(digits.chars().take(lastSignificant))
  };

  func repeatZeros(count : Nat) : Text {
    Text.fromIter(Iter.repeat('0', count))
  };

  func hexDigit(nibble : Nat32) : Char {
    if (nibble < 10) {
      Char.fromNat32(0x30 + nibble)
    } else {
      Char.fromNat32(0x41 + nibble - 10)
    }
  };

};
