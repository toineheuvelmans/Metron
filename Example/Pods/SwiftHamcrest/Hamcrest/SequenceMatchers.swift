public func empty<T: Collection>() -> Matcher<T> {
    return describedAs("empty", hasCount(0))
}

public func hasCount<T: Collection>(_ matcher: Matcher<T.IndexDistance>) -> Matcher<T> {
    return Matcher("has count " + matcher.description) {
        (value: T) -> MatchResult in
        let n = value.count
        return delegateMatching(n, matcher) {
            return "count " + describeActualValue(n, $0)
        }
    }
}

public func hasCount<T: Collection>(_ expectedCount: T.IndexDistance) -> Matcher<T> {
    return hasCount(equalToWithoutDescription(expectedCount))
}

public func everyItem<T, S: Sequence>(_ matcher: Matcher<T>)
    -> Matcher<S> where S.Iterator.Element == T {

    return Matcher("a sequence where every item \(matcher.description)") {
        (values: S) -> MatchResult in
        var mismatchDescriptions: [String?] = []
        for value in values {
            switch delegateMatching(value, matcher, {
                (mismatchDescription: String?) -> String? in
                "mismatch: \(value)" + (mismatchDescription.map{" (\($0))"} ?? "")
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

private func hasItem<T, S: Sequence>(_ matcher: Matcher<T>,
                                                                        _ values: S) -> Bool where S.Iterator.Element == T {
    for value in values {
        if matcher.matches(value).boolValue {
            return true
        }
    }
    return false
}

public func hasItem<T, S: Sequence>(_ matcher: Matcher<T>)
    -> Matcher<S> where S.Iterator.Element == T {

    return Matcher("a sequence containing \(matcher.description)") {
        (values: S) -> Bool in hasItem(matcher, values)
    }
}

public func hasItem<T: Equatable, S: Sequence>(_ expectedValue: T)
    -> Matcher<S> where S.Iterator.Element == T {

    return hasItem(equalToWithoutDescription(expectedValue))
}

private func hasItems<T, S: Sequence>(_ matchers: [Matcher<T>])
    -> Matcher<S> where S.Iterator.Element == T {

    return Matcher("a sequence containing \(joinMatcherDescriptions(matchers))") {
        (values: S) -> MatchResult in
        var missingItems = [] as [Matcher<T>]
        for matcher in matchers {
            if !hasItem(matcher, values) {
                missingItems.append(matcher)
            }
        }
        switch missingItems.count {
        case 0:
            return .match
        case 1:
            return .mismatch("missing item \(missingItems[0].description)")
        default:
            return .mismatch("missing items " + joinDescriptions(matchers.map({$0.description})))
        }
    }
}

public func hasItems<T, S: Sequence>(_ matchers: Matcher<T>...)
    -> Matcher<S> where S.Iterator.Element == T {

    return hasItems(matchers)
}

public func hasItems<T: Equatable, S: Sequence>
    (_ expectedValues: T...) -> Matcher<S> where S.Iterator.Element == T {

    return hasItems(expectedValues.map {equalToWithoutDescription($0)})
}

private func contains<T, S: Sequence>(_ matchers: [Matcher<T>])
    -> Matcher<S> where S.Iterator.Element == T {

    return Matcher("a sequence containing " + joinDescriptions(matchers.map({$0.description}))) {
        (values: S) -> MatchResult in
        return applyMatchers(matchers, values: values)
    }
}

public func contains<T, S: Sequence>(_ matchers: Matcher<T>...)
    -> Matcher<S> where S.Iterator.Element == T {

    return contains(matchers)
}

public func contains<T: Equatable, S: Sequence>
    (_ expectedValues: T...) -> Matcher<S> where S.Iterator.Element == T {

    return contains(expectedValues.map {equalToWithoutDescription($0)})
}

private func containsInAnyOrder<T, S: Sequence>
    (_ matchers: [Matcher<T>]) -> Matcher<S> where S.Iterator.Element == T {

    let descriptions = joinDescriptions(matchers.map({$0.description}))

    return Matcher("a sequence containing in any order " + descriptions) {
        (values: S) -> MatchResult in

        var unmatchedValues: [T] = []
        var remainingMatchers = matchers

        values:
            for value in values {
                var i = 0
                for matcher in remainingMatchers {
                    if matcher.matches(value).boolValue {
                        remainingMatchers.remove(at: i)
                        continue values
                    }
                    i += 1
                }
                unmatchedValues.append(value)
        }
        let isMatch = remainingMatchers.isEmpty && unmatchedValues.isEmpty
        if !isMatch {
            return applyMatchers(remainingMatchers, values: unmatchedValues)
        } else {
            return .match
        }
    }
}

public func containsInAnyOrder<T, S: Sequence>
    (_ matchers: Matcher<T>...) -> Matcher<S> where S.Iterator.Element == T {

    return containsInAnyOrder(matchers)
}

public func containsInAnyOrder<T: Equatable, S: Sequence>
    (_ expectedValues: T...) -> Matcher<S> where S.Iterator.Element == T {

    return containsInAnyOrder(expectedValues.map {equalToWithoutDescription($0)})
}

func applyMatchers<T, S: Sequence>
    (_ matchers: [Matcher<T>], values: S) -> MatchResult where S.Iterator.Element == T {

    var mismatchDescriptions: [String?] = []

    var i = 0
    for (value, matcher) in zip(values, matchers) {
        switch delegateMatching(value, matcher, {
            "mismatch: " + describeMismatch(value, matcher.description, $0)
        }) {
        case let .mismatch(mismatchDescription):
            mismatchDescriptions.append(mismatchDescription)
        default:
            break
        }
        i += 1
    }
    var j = 0;
    for value in values {
        if j >= i {
            mismatchDescriptions.append("unmatched item \(describe(value))")
        }
        j += 1
    }
    for matcher in matchers[i..<matchers.count] {
        mismatchDescriptions.append("missing item \(matcher.description)")
    }
    return MatchResult(mismatchDescriptions.isEmpty, joinDescriptions(mismatchDescriptions))
}
