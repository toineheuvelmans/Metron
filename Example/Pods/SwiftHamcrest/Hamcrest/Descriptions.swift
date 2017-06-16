import Foundation

func describe<T>(_ value: T) -> String {
    if let stringArray = value as? [String] {
        return joinDescriptions(stringArray.map {describe($0)})
    }
    if let string = value as? String {
        return "\"\(string)\""
    }
    return String(describing: value)
}

func describeAddress<T: AnyObject>(_ object: T) -> String {
    return NSString(format: "%p", unsafeBitCast(object, to: Int.self)) as String
}

func describeError(_ error: Error) -> String {
    return "ERROR: \(error)"
}

func describeExpectedError() -> String {
    return "EXPECTED ERROR"
}

func describeExpectedError(_ description: String) -> String {
    return "EXPECTED ERROR: \(description)"
}

func describeErrorMismatch<T>(_ error: T, _ description: String, _ mismatchDescription: String?) -> String {
    return "GOT ERROR: " + describeActualValue(error, mismatchDescription) + ", EXPECTED ERROR: \(description)"
}

public func describeMismatch<T>(_ value: T, _ description: String, _ mismatchDescription: String?) -> String {
    return "GOT: " + describeActualValue(value, mismatchDescription) + ", EXPECTED: \(description)"
}

func describeActualValue<T>(_ value: T, _ mismatchDescription: String?) -> String {
    return describe(value) + (mismatchDescription.map{" (\($0))"} ?? "")
}

func joinDescriptions(_ descriptions: [String]) -> String {
    return joinStrings(descriptions)
}

func joinDescriptions(_ descriptions: [String?]) -> String? {
    let notNil = filterNotNil(descriptions)
    return notNil.isEmpty ? nil : joinStrings(notNil)
}

func joinMatcherDescriptions<S: Sequence, T>(_ matchers: S, prefix: String = "all of") -> String where S.Iterator.Element == Matcher<T> {
    var generator = matchers.makeIterator()
    if let first = generator.next(), generator.next() == nil {
        return first.description
    } else {
        return prefix + " " + joinDescriptions(matchers.map({$0.description}))
    }
}

private func joinStrings(_ strings: [String]) -> String {
    switch (strings.count) {
    case 1:
        return strings[0]
    default:
        return "[" + strings.joined(separator: ", ") + "]"
    }
}
