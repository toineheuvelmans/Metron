import Foundation

public func containsString(_ string: String) -> Matcher<String> {
    return Matcher("contains \"\(string)\"") {$0.range(of: string) != nil}
}

public func containsStringsInOrder(_ strings: String...) -> Matcher<String> {
    return Matcher("contains in order \(describe(strings))") {
        (value: String) -> Bool in
        var range = value.characters.startIndex..<value.characters.endIndex
        for string in strings {
            let r = value.range(of: string, options: .caseInsensitive, range: range)
            if let r = r {
								range = r.upperBound..<value.characters.endIndex
            } else {
                return false
            }

        }
        return true
    }
}

public func hasPrefix(_ expectedPrefix: String) -> Matcher<String> {
    return Matcher("has prefix \(describe(expectedPrefix))") {$0.hasPrefix(expectedPrefix)}
}

public func hasSuffix(_ expectedSuffix: String) -> Matcher<String> {
    return Matcher("has suffix \(describe(expectedSuffix))") {$0.hasSuffix(expectedSuffix)}
}

public func matchesPattern(_ pattern: String, options: NSRegularExpression.Options = []) -> Matcher<String> {
    let regularExpression = try! NSRegularExpression(pattern: pattern, options: options)
    return matchesPattern(regularExpression)
}

public func matchesPattern(_ regularExpression: NSRegularExpression) -> Matcher<String> {
    return Matcher("matches \(describe(regularExpression.pattern))") {
        (value: String) -> Bool in
        let range = NSMakeRange(0, (value as NSString).length)
        return regularExpression.numberOfMatches(in: value, options: [], range: range) > 0
    }
}
