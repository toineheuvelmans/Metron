public enum MatchResult: ExpressibleByBooleanLiteral {

    case match
    case mismatch(String?)

    public init(booleanLiteral match: Bool) {
        self = match ? .match : .mismatch(nil)
    }

    public init(_ match: Bool) {
        self = match ? .match : .mismatch(nil)
    }

    public init(_ match: Bool, _ mismatchDescription: String?) {
        self = match ? .match : .mismatch(mismatchDescription)
    }

    public var boolValue: Bool {
        switch self {
        case .match:
            return true
        case .mismatch:
            return false
        }
    }
}
