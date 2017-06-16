public func hasProperty<T, U>(_ propertyMatcher: Matcher<String>, _ matcher: Matcher<U>) -> Matcher<T> {
    return Matcher("has property \(propertyMatcher.description) with value \(matcher.description)") {
        (value: T) -> MatchResult in
        if let propertyValue = getProperty(value, keyMatcher: propertyMatcher) {
            if let propertyValue = propertyValue as? U {
                return delegateMatching(propertyValue, matcher) {
                    return "property value " + describeActualValue(propertyValue, $0)
                }
            } else {
                return .mismatch("incompatible property type")
            }
        } else {
            return .mismatch("missing property")
        }
    }
}

public func hasProperty<T, U: Equatable>(_ propertyName: String, _ expectedValue: U) -> Matcher<T> {
    return hasProperty(equalToWithoutDescription(propertyName), equalToWithoutDescription(expectedValue))
}

public func hasProperty<T, U>(_ propertyName: String, _ matcher: Matcher<U>) -> Matcher<T> {
    return hasProperty(equalToWithoutDescription(propertyName), matcher)
}

private func getProperty<T>(_ value: T, keyMatcher: Matcher<String>) -> Any? {
    let mirror = Mirror(reflecting: value)
    for property in mirror.children {
        if let label = property.label, keyMatcher.matches(label).boolValue {
            return property.value
        }
    }
    return nil
}
