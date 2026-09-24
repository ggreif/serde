import Char "mo:core/Char";
import Nat32 "mo:core/Nat32";
import Result "mo:core/Result";
import Text "mo:core/Text";

import JSON "../../submodules/jayson/src/Json";
import NatX "../../submodules/xtended-numbers/src/NatX";
import IntX "../../submodules/xtended-numbers/src/IntX";

import Candid "../Candid";
import CandidType "../Candid/Types";
import Utils "../Utils";

module {
    let { Buffer } = Utils;
    type JSON = JSON.Json;
    type Candid = Candid.Candid;
    type Result<A, B> = Result.Result<A, B>;

    // No escaping helper here any more. jayson's `stringify` escapes string
    // values itself — backslash, quote, the named controls and the remaining
    // U+0000..U+001F as \u00XX — so serde no longer pre-escapes before handing
    // a value to the printer. The old parser's `show` emitted string contents
    // verbatim, which produced invalid JSON for any value containing a quote,
    // a backslash or a control character; escaping here was the workaround.

    /// Converts serialized Candid blob to JSON text
    public func toText(blob : Blob, keys : [Text], options : ?CandidType.Options) : Result<Text, Text> {
        let decoded_res = Candid.decode(blob, keys, options);
        let #ok(candid) = decoded_res else return Utils.send_error(decoded_res);

        let skip_null_fields = switch (options) {
            case (?opts) opts.skip_null_fields;
            case null false;
        };

        let json_res = fromCandidWith(candid[0], skip_null_fields);
        let #ok(json) = json_res else return Utils.send_error(json_res);
        #ok(json);
    };

    /// Convert a Candid value to JSON text (default: keep null fields).
    public func fromCandid(candid : Candid) : Result<Text, Text> =
        fromCandidWith(candid, false);

    /// Convert a Candid value to JSON text with explicit null-skip behaviour.
    public func fromCandidWith(candid : Candid, skip_null_fields : Bool) : Result<Text, Text> {
        let res = candidToJSON(candid, skip_null_fields);
        let #ok(json) = res else return Utils.send_error(res);

        #ok(JSON.stringify(json));
    };

    func candidToJSON(candid : Candid, skip_null_fields : Bool) : Result<JSON, Text> {
        let json : JSON = switch (candid) {
            case (#Null) #Null;
            case (#Bool(n)) #Bool(n);
            case (#Text(n)) #String(n);

            case (#Int(n)) #Number(#Int(n));
            case (#Int8(n)) #Number(#Int(IntX.from8ToInt(n)));
            case (#Int16(n)) #Number(#Int(IntX.from16ToInt(n)));
            case (#Int32(n)) #Number(#Int(IntX.from32ToInt(n)));
            case (#Int64(n)) #Number(#Int(IntX.from64ToInt(n)));

            case (#Nat(n)) #Number(#Int(n));
            case (#Nat8(n)) #Number(#Int(NatX.from8ToNat(n)));
            case (#Nat16(n)) #Number(#Int(NatX.from16ToNat(n)));
            case (#Nat32(n)) #Number(#Int(NatX.from32ToNat(n)));
            case (#Nat64(n)) #Number(#Int(NatX.from64ToNat(n)));

            case (#Float(n)) #Number(#Float(n));

            case (#Option(val)) {
                let res = switch (val) {
                    case (#Null) return #ok(#Null);
                    case (v) candidToJSON(v, skip_null_fields);
                };

                let #ok(optional_val) = res else return Utils.send_error(res);
                optional_val;
            };
            case (#Array(arr)) {
                let newArr = Buffer.Buffer<JSON>(arr.size());

                for (item in arr.vals()) {
                    let res = candidToJSON(item, skip_null_fields);
                    let #ok(json) = res else return Utils.send_error(res);
                    newArr.add(json);
                };

                #Array(Buffer.toArray(newArr));
            };

            case (#Record(records) or #Map(records)) {
                let newRecords = Buffer.Buffer<(Text, JSON)>(records.size());

                for ((key, val) in records.vals()) {
                    let res = candidToJSON(val, skip_null_fields);
                    let #ok(json) = res else return Utils.send_error(res);
                    // With `skip_null_fields`, entries whose value serialised
                    // to JSON `null` are treated as "field absent" — matches
                    // how external HTTP APIs read optional fields.
                    switch (skip_null_fields, json) {
                        case (true, #Null) ();
                        case _ newRecords.add((key, json));
                    };
                };

                #Object(Buffer.toArray(newRecords));
            };

            case (#Variant(variant)) {
                let (key, val) = variant;
                let res = candidToJSON(val, skip_null_fields);
                let #ok(json_val) = res else return Utils.send_error(res);

                #Object([("#" # key, json_val)]);
            };

            case (_) {
                return #err(debug_show candid # " is not supported by JSON");
            };

        };

        #ok(json);
    };
};
