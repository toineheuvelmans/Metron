import CoreGraphics

/**
 *  A `LineSegment` represents a straight line between two points.
 */
public struct LineSegment {
    public var a: CGPoint
    public var b: CGPoint
    
    public init(a: CGPoint, b: CGPoint) {
        self.a = a
        self.b = b
    }
}

public extension LineSegment {
    
    public init(origin: CGPoint, vector: CGVector) {
        self.a = origin
        self.b = origin + vector
    }
    
    /// - returns: A `Line` that runs through this line segment's points.
    public var line: Line {
        return Line(a: a, b: b)
    }
    
    public var minX: CGFloat {
        return min(a.x, b.x)
    }
    
    public var maxX: CGFloat {
        return max(a.x, b.x)
    }
    
    public var minY: CGFloat {
        return min(a.y, b.y)
    }
    
    public var maxY: CGFloat {
        return max(a.y, b.y)
    }
    
    /// - returns: The vector of this `LineSegment`, originating from point a.
    public var vector: CGVector {
        return CGVector(dx: b.x - a.x, dy: b.y - a.y)
    }
    
    /// If vertical, there's no slope so no Line can be derived from this segment. 
    public var isVertical: Bool {
        return minX == maxX
    }
    
    /// - returns: true when the provided point is on this lineSegment's line and 
    /// between its points.
    /// - note: An error margin of 1e-14 is allowed.
    public func contains(_ point: CGPoint) -> Bool {
        if isVertical {
            return point.x == minX && point.y.between(lower: a.y, upper: b.y)
        }
        return line.contains(point) &&
            point.x.between(lower: a.x, upper: b.x) &&
            point.y.between(lower: a.y, upper: b.y)
    }
    
    /// - returns: The start and end points of this `LineSegment` as an array.
    public var points: [CGPoint] {
        return [a, b]
    }
    
    /// - returns: The point halfway A->B.
    public var midpoint: CGPoint {
        return CGPoint(x: (a.x + b.x) / 2.0,
                       y: (a.y + b.y) / 2.0)
    }

    /// - returns: The length of this `LineSegment`, i.e. the distance from A to B.
    public var length: CGFloat {
        return a.distance(to: b)
    }
    
    /// - returns: The intersection of this `LineSegment` with the provided `Line`.
    public func intersection(with line: Line) -> CGPoint? {
        return line.intersection(with: self)
    }
    
    /// - returns: The intersection of this `LineSegment` with the provided `LineSegment`.
    public func intersection(with lineSegment: LineSegment) -> CGPoint? {
        if let intersection = line.intersection(with: lineSegment) {
            return contains(intersection) ? intersection : nil
        }
        return nil
    }
    
    /// - returns: A new `LineSegment` that is rotated by the provided angle,
    /// around point A.
    public func rotatedAroundA(_ angle: Angle) -> LineSegment {
        let t = CGAffineTransform(rotationAngle: angle)
        return self.applying(t, anchorPoint: a)
    }
    
    /// - returns: A new `LineSegment` that is rotated by the provided angle,
    /// around point B.
    public func rotatedAroundB(_ angle: Angle) -> LineSegment {
        let t = CGAffineTransform(rotationAngle: angle)
        return self.applying(t, anchorPoint: b)
    }
}

extension LineSegment : Transformable {
    public func applying(_ t: CGAffineTransform) -> LineSegment {
        return LineSegment(a: a.applying(t), b: b.applying(t))
    }
}

extension LineSegment : Drawable {
    public var path: CGPath? {
        let path = CGMutablePath()
        path.move(to: self.a)
        path.addLine(to: self.b)
        return path.copy()
    }
}

// MARK: Equatable / Comparable

extension LineSegment : Equatable {
    /// True if the angle is the same, regardless of unit
    public static func ==(lhs: LineSegment, rhs: LineSegment) -> Bool {
        return lhs.length == rhs.length
    }
}

/// True if angle and unit are the same
public func ===(lhs: LineSegment, rhs: LineSegment) -> Bool {
    return lhs.a == rhs.a &&
           lhs.b == rhs.b
}

/// A LineSegment is Comparable by length.
extension LineSegment : Comparable {
    public static func <(lhs: LineSegment, rhs: LineSegment) -> Bool {
        return lhs.length < rhs.length
    }
}

// MARK: CustomDebugStringConvertible

extension LineSegment : CustomDebugStringConvertible {
    public var debugDescription: String {
        return "LineSegment {a: \(a), b: \(b)}"
    }
}
