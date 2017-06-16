import CoreGraphics

extension Comparable {
    /// - returns: Value clipped to the provided minimum (first argument)
    /// and maximum (second argument).
    /// - note: no check is made whether the provided minimum is lower than
    /// the provided maximum.
    public func clipped(_ minValue: Self, _ maxValue: Self) -> Self {
        return max(minValue, min(self, maxValue))
    }
    
    /// - returns: true if the value is between the 
    /// provided lower and upper limits.
    public func between(lower: Self, upper: Self) -> Bool {
        return self >= min(lower, upper) &&
               self <= max(lower, upper)
    }
}

// MARK: Axis

/// Represents either the horizontal (x) or vertical (y) axis.
public enum Axis {
    case xAxis, yAxis
}

// MARK: Summable

/// Represents entities that can logically be summed.
/// (For example, angles).
public protocol Summable {
    static func +(lhs: Self, rhs: Self) -> Self
}
