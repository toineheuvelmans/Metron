import CoreGraphics

/**
 *  An `Angle` in two-dimensional space, either expressed
 *  in radians or degrees.
 */
public struct Angle {
    
    public enum Unit {
        case radians, degrees
    }
    
    /// Expresses the angle value in the current unit.
    public var value: CGFloat
    
    /// The current unit in which the angle is expressed.
    public var unit: Unit
    
    /// Initializes a new `Angle`. Unit is radians by default.
    public init(_ value: CGFloat, unit: Unit = .radians) {
        self.value = value
        self.unit = unit
    }
}

public extension Angle {

    /// - returns: The angle expressed in radians.
    public var radians: CGFloat {
        return asUnit(.radians)
    }
    /// - returns: The angle expressed in degrees.
    public var degrees: CGFloat {
        return asUnit(.degrees)
    }
    
    
    private static let radiansToDegreesFactor: CGFloat = 180.0 / .pi
    private static let degreesToRadiansFactor: CGFloat = .pi / 180.0
    
    /// - returns: The angle expressed in the provided unit.
    public func asUnit(_ unit: Unit) -> CGFloat {
        if self.unit == unit {
            return value
        }
        switch unit {
        // value is radians
        case .degrees:  return value * Angle.radiansToDegreesFactor
        // value is degrees
        case .radians:  return value * Angle.degreesToRadiansFactor
        }
    }
    
    /// - returns: The floating point value representing a full rotation
    /// in the given unit (i.e. 2pi radians / 360 degrees)
    public static func fullRotation(unit: Unit) -> CGFloat {
        return unit == .radians ? (2.0 * .pi) : 360.0
    }
    
    /// - returns: The floating point value representing a full rotation
    /// expressed in the current unit of this angle.
    public var fullRotation: CGFloat {
        return Angle.fullRotation(unit: unit)
    }
    
    /// - returns: The angle expressed in a value normalized between
    /// 0 and `fullRotation`.
    public var normalized: Angle {
        let max = fullRotation
        let moduloValue = fmod(value, max)
        let normalizedValue = moduloValue >= 0.0 ? moduloValue : moduloValue + max
        return Angle(normalizedValue, unit: unit)
    }
    
    /// - returns: `fullRotation` minus the `normalized` angle.
    ///
    public var inversed: Angle {
        let max = fullRotation
        return Angle(max - normalized.value, unit: unit)
    }
}

// MARK: Equatable / Comparable

extension Angle : Equatable {
    /// True if the angle is the same, regardless of unit.
    public static func ==(lhs: Angle, rhs: Angle) -> Bool {
        return lhs.value == rhs.asUnit(lhs.unit)
    }
}

/// True if angle and unit are the same.
public func ===(lhs: Angle, rhs: Angle) -> Bool {
    return lhs.value == rhs.value &&
            lhs.unit == rhs.unit
}

extension Angle : Comparable {
    public static func <(lhs: Angle, rhs: Angle) -> Bool {
        return lhs.value < rhs.asUnit(lhs.unit)
    }
}

// MARK: Arithmetic
extension Angle : Summable {
    static public func +(lhs: Angle, rhs: Angle) -> Angle {
        return Angle(lhs.value + rhs.asUnit(lhs.unit), unit: lhs.unit)
    }
}
public func -(lhs: Angle, rhs: Angle) -> Angle {
    return Angle(lhs.value - rhs.asUnit(lhs.unit), unit: lhs.unit)
}
public func *(lhs: Angle, rhs: Angle) -> Angle {
    return Angle(lhs.value * rhs.asUnit(lhs.unit), unit: lhs.unit)
}
public func /(lhs: Angle, rhs: Angle) -> Angle {
    return Angle(lhs.value / rhs.asUnit(lhs.unit), unit: lhs.unit)
}

public func *(lhs: Angle, rhs: CGFloat) -> Angle {
    return Angle(lhs.value * rhs, unit: lhs.unit)
}
public func /(lhs: Angle, rhs: CGFloat) -> Angle {
    return Angle(lhs.value / rhs, unit: lhs.unit)
}
public func *(lhs: CGFloat, rhs: Angle) -> Angle {
    return Angle(rhs.value * lhs, unit: rhs.unit)
}

// MARK: Trigonometry

public func sin(_ angle: Angle) -> CGFloat {
    return sin(angle.asUnit(.radians))
}
public func cos(_ angle: Angle) -> CGFloat {
    return cos(angle.asUnit(.radians))
}
public func tan(_ angle: Angle) -> CGFloat {
    return tan(angle.asUnit(.radians))
}

public func asin(_ x: CGFloat) -> Angle {
    return Angle(CoreGraphics.asin(x), unit: .radians)
}
public func acos(_ x: CGFloat) -> Angle {
    return Angle(CoreGraphics.acos(x), unit: .radians)
}
public func atan(_ x: CGFloat) -> Angle {
    return Angle(CoreGraphics.atan(x), unit: .radians)
}
public func atan2(_ lhs: CGFloat, _ rhs: CGFloat) -> Angle {
    return Angle(CoreGraphics.atan2(lhs, rhs), unit: .radians)
}

// MARK: Points

public extension CGPoint {
    
    /// - returns: The `Angle` between horizontal line through `self`,
    /// and line from `self` to `reference.
    public func polarAngle(reference: CGPoint) -> Angle {
        return (self - reference).angle
    }
    
    /// - returns: The `Angle` between line from `self` to `previous`
    /// and `self` to `next`, i.e. the angle at vertex `self`
    /// of triangle (`previous`,`self`,`next`).
    public func angle(previous: CGPoint, next: CGPoint) -> Angle {
        let v1 = previous - self
        let v2 = next - self
        return atan2(v1.dy,v1.dx) - atan2(v2.dy,v2.dx)
    }
}

// MARK: Transform

public extension CGAffineTransform {
    
    /// Convenience initializer for rotation transform.
    public init(rotationAngle angle: Angle) {
        self.init(rotationAngle: angle.asUnit(.radians))
    }
    
    /// Convenienc function for rotating a transform.
    public func rotated(by angle: Angle) -> CGAffineTransform {
        return rotated(by: angle.asUnit(.radians))
    }
}

// MARK: CustomDebugStringConvertible

extension Angle : CustomDebugStringConvertible {
    public var debugDescription: String {
        switch unit {
        case .radians: return "Angle: \(value) rad. (\(degrees)°)"
        case .degrees: return "Angle: \(value)° (\(radians) rad.)"
        }
    }
}
