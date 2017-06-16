import Foundation
import Swift
import XCTest

/// Reporter function that is called whenever a Hamcrest assertion fails.
/// By default this calls XCTFail, except in Playgrounds where it does nothing.
/// This is intended for testing Hamcrest itself.
public var HamcrestReportFunction: (_: String, _ file: StaticString, _ line: UInt) -> () = HamcrestDefaultReportFunction
public let HamcrestDefaultReportFunction =
    isPlayground()
        ? {(message, file, line) in}
        : {(message, file, line) in XCTFail(message, file: file, line: line)}

// MARK: helpers

func filterNotNil<T>(_ array: [T?]) -> [T] {
    return array.filter({$0 != nil}).map({$0!})
}

func delegateMatching<T>(_ value: T, _ matcher: Matcher<T>, _ mismatchDescriber: (String?) -> String?) -> MatchResult {
    switch matcher.matches(value) {
    case .match:
        return .match
    case let .mismatch(mismatchDescription):
        return .mismatch(mismatchDescriber(mismatchDescription))
    }
}

func equalToWithoutDescription<T: Equatable>(_ expectedValue: T) -> Matcher<T> {
    return describedAs(describe(expectedValue), equalTo(expectedValue))
}

func isPlayground() -> Bool {
    let infoDictionary = Bundle.main.infoDictionary
    let bundleIdentifier = infoDictionary?["CFBundleIdentifier"]
    return (bundleIdentifier as? String)?.hasPrefix("com.apple.dt.Xcode") ?? false
}

// MARK: assertThrows

@discardableResult public func assertThrows<T>(_ value: @autoclosure () throws -> T, file: StaticString = #file, line: UInt = #line) -> String {
    do {
        _ = try value()
        return reportResult(describeExpectedError(), file: file, line: line)
    } catch {
        return reportResult(nil, file: file, line: line)
    }
}

@discardableResult public func assertThrows<S, T: Error>(_ value: @autoclosure () throws -> S, _ error: T, file: String = #file, line: UInt = #line) -> String where T: Equatable {
    return assertThrows(value, equalToWithoutDescription(error), file: file, line: line)
}

@discardableResult public func assertThrows<S, T: Error>(_ value: @autoclosure () throws -> S, _ matcher: Matcher<T>, file: String = #file, line: UInt = #line) -> String {
    return reportResult(applyErrorMatcher(matcher, toBlock: value))
}

@discardableResult private func applyErrorMatcher<S, T: Error>(_ matcher: Matcher<T>, toBlock: () throws -> S) -> String? {
    do {
        _ = try toBlock()
        return describeExpectedError(matcher.description)
    } catch let error as T {
        let match = matcher.matches(error)
        switch match {
        case .match:
            return nil
        case let .mismatch(mismatchDescription):
            return describeErrorMismatch(error, matcher.description, mismatchDescription)
        }
    } catch let error {
        return describeErrorMismatch(error, matcher.description, nil)
    }
}

// MARK: assertThat

@discardableResult public func assertThat<T>(_ value: @autoclosure () throws -> T, _ matcher: Matcher<T>, file: StaticString = #file, line: UInt = #line) -> String {
    return reportResult(applyMatcher(matcher, toValue: value), file: file, line: line)
}

@discardableResult func applyMatcher<T>(_ matcher: Matcher<T>, toValue: () throws -> T) -> String? {
    do {
        let value = try toValue()
        let match = matcher.matches(value)
        switch match {
        case .match:
            return nil
        case let .mismatch(mismatchDescription):
            return describeMismatch(value, matcher.description, mismatchDescription)
        }
    } catch let error {
        return describeError(error)
    }
}

func reportResult(_ possibleResult: String?, file: StaticString = #file, line: UInt = #line)
    -> String {

    if let result = possibleResult {
        HamcrestReportFunction(result, file, line)
        return result
    } else {
        // The return value is just intended for Playgrounds.
        return "✓"
    }
}
