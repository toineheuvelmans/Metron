public func equalTo<T: Equatable>(_ expectedValue: T) -> Matcher<T> {
    return Matcher("equal to \(expectedValue)") {$0 == expectedValue}
}

public func closeTo(_ expectedValue: Double, _ delta: Double) -> Matcher<Double> {
    return Matcher("within \(delta) of \(expectedValue)") {
        (value: Double) -> MatchResult in
        let actual = abs(value - expectedValue)
        return MatchResult(actual < delta, "difference of \(actual)")
    }
}

public func closeTo(_ expectedValue: Float, _ delta: Double) -> Matcher<Float> {
    let matcher = closeTo(Double(expectedValue), delta)
    return Matcher(matcher.description) {matcher.matches(Double($0))}
}

public func greaterThan<T: Comparable>(_ expectedValue: T) -> Matcher<T> {
    return Matcher("greater than \(expectedValue)") {$0 > expectedValue}
}

public func greaterThanOrEqualTo<T: Comparable>(_ expectedValue: T) -> Matcher<T> {
    return Matcher("greater than or equal to \(expectedValue)") {$0 >= expectedValue}
}

public func lessThan<T: Comparable>(_ expectedValue: T) -> Matcher<T> {
    return Matcher("less than \(expectedValue)") {$0 < expectedValue}
}

public func lessThanOrEqualTo<T: Comparable>(_ expectedValue: T) -> Matcher<T> {
    return Matcher("less than or equal to \(expectedValue)") {$0 <= expectedValue}
}

public func inInterval<T>(_ expectedInterval: ClosedRange<T>) -> Matcher<T> {
    return Matcher("in interval \(expectedInterval)") {expectedInterval.contains($0)}
}

public func inInterval<T>(_ expectedInterval: Range<T>) -> Matcher<T> {
	return Matcher("in interval \(expectedInterval)") {expectedInterval.contains($0)}
}
