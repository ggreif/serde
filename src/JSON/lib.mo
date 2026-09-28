/// A module for converting between JSON and Motoko values.

import JSON "../../submodules/jayson/src/Json";

import Candid "../Candid";
import FromText "FromText";
import ToText "ToText";
import Utils "../Utils";

module {
    public type JSON = JSON.Json;
    public let defaultOptions = Candid.defaultOptions;

    public let { fromText; toCandid } = FromText;

    public let { toText; fromCandid; fromCandidWith } = ToText;

    public let concatKeys = Utils.concatKeys;
};
