public struct Matcher<T> {

    public let description: String
    let f: (T) -> MatchResult

    public init(_ description: String, _ f: @escaping (T) -> MatchResult) {
        self.description = description
        self.f = f
    }

    public init(_ description: String, _ f: @escaping (T) -> Bool) {
        self.description = description
        self.f = {value in f(value) ? .match : .mismatch(nil)}
    }

    public func matches(_ value: T) -> MatchResult {
        return f(value)
    }
}
