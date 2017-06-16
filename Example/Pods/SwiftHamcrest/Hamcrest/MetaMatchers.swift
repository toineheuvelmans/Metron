public func not<T>(_ matcher: Matcher<T>) -> Matcher<T> {
    return Matcher("not \(matcher.description)") {value in !matcher.matches(value).boolValue }
}

public func not<T: Equatable>(_ expectedValue: T) -> Matcher<T> {
    return not(equalToWithoutDescription(expectedValue))
}

public func describedAs<T>(_ description: String, _ matcher: Matcher<T>) -> Matcher<T> {
    return Matcher(description) {matcher.matches($0) as MatchResult}
}

public func allOf<T>(_ matchers: Matcher<T>...) -> Matcher<T> {
    return allOf(matchers)
}

public func allOf<S: Sequence, T>(_ matchers: S) -> Matcher<T> where S.Iterator.Element == Matcher<T> {
    return Matcher(joinMatcherDescriptions(matchers)) {
        (value: T) -> MatchResult in
        var mismatchDescriptions: [String?] = []
        for matcher in matchers {
            switch delegateMatching(value, matcher, {
                (mismatchDescription: String?) -> String? in
                "mismatch: \(matcher.description)"
                    + (mismatchDescription.map{" (\($0))"} ?? "")
            }) {
            case let .mismatch(mismatchDescription):
                mismatchDescriptions.append(mismatchDescription)
            default:
                break
            }
        }
        return MatchResult(mismatchDescriptions.isEmpty, joinDescriptions(mismatchDescriptions))
    }
}

public func && <T>(lhs: Matcher<T>, rhs: Matcher<T>) -> Matcher<T> {
    return allOf(lhs, rhs)
}

public func anyOf<T>(_ matchers: Matcher<T>...) -> Matcher<T> {
    return anyOf(matchers)
}

public func anyOf<S: Sequence, T>(_ matchers: S) -> Matcher<T> where S.Iterator.Element == Matcher<T> {
    return Matcher(joinMatcherDescriptions(matchers, prefix: "any of")) {
        (value: T) -> MatchResult in
        let matchedMatchers = matchers.filter {$0.matches(value).boolValue}
        return MatchResult(!matchedMatchers.isEmpty)
    }
}

public func || <T>(lhs: Matcher<T>, rhs: Matcher<T>) -> Matcher<T> {
    return anyOf(lhs, rhs)
}
