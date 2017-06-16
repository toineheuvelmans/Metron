import CoreGraphics

public extension CGVector {
    
    /// - returns: A `CGPoint` with x: dx and y: dy.
    public var point: CGPoint {
        return CGPoint(x: dx, y: dy)
    }
    
    public var magnitude: CGFloat {
        return sqrt(dx * dx + dy * dy)
    }
    public var angle: Angle {
        return atan2(dy, dx)
    }
    
    public init(angle: Angle, magnitude: CGFloat) {
        dx = magnitude * cos(angle)
        dy = magnitude * sin(angle)
    }
    
    public var inversed: CGVector {
        return CGVector(dx: -dx, dy: -dy)
    }
    
    /// - returns: The `CGRectEdge` towards which this vector tends the most.
    public var dominantEdge: CGRectEdge {
        return abs(dx) > abs(dy) ? (dx > 0.0 ? .maxXEdge : .minXEdge) : (dy > 0.0 ? .maxYEdge : .minYEdge)
    }
    
    /// - returns: The `Corner` towards which this vector tends the most.
    public var dominantCorner: Corner {
        let xEdge: CGRectEdge = dx > 0 ? .maxXEdge : .minXEdge
        let yEdge: CGRectEdge = dy > 0 ? .maxYEdge : .minYEdge
        return Corner(x: xEdge, y: yEdge)
    }

    /// - returns: A `Line` drawn through the given point,
    /// following this vector.
    public func line(through point: CGPoint) -> Line {
        return Line(a: point, b: point + self)
    }
    
    /// - returns: A `LineSegment` drawn from the given point,
    /// following this vector. The `LineSegment` length
    /// equals the vector magnitude.
    public func lineSegment(from point: CGPoint) -> LineSegment {
        return LineSegment(a: point, b: point + self)
    }
}

// MARK: Arithmetic

public func +(lhs: CGVector, rhs: CGVector) -> CGVector {
    return CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
}

public func -(lhs: CGVector, rhs: CGVector) -> CGVector {
    return CGVector(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
}


public func *(lhs: CGVector, rhs: CGFloat) -> CGVector {
    return CGVector(dx: lhs.dx * rhs, dy: lhs.dy * rhs)
}

public func *(lhs: CGFloat, rhs: CGVector) -> CGVector {
    return CGVector(dx: rhs.dx * lhs, dy: rhs.dy * lhs)
}

public func /(lhs: CGVector, rhs: CGFloat) -> CGVector {
    return CGVector(dx: lhs.dx / rhs, dy: lhs.dy / rhs)
}

// MARK: Transform

extension CGVector : Transformable {
    public func applying(_ t: CGAffineTransform) -> CGVector {
        return point.applying(t).vector
    }
}

public extension CGAffineTransform {
    public init(translation: CGVector) {
        self.init(translationX: translation.dx, y: translation.dy)
    }
    
    public func translatedBy(vector: CGVector) -> CGAffineTransform {
        return translatedBy(x: vector.dx, y: vector.dy)
    }
}

// MARK: CustomDebugStringConvertible

extension CGVector : CustomDebugStringConvertible {
    public var debugDescription: String {
        return "{dx: \(dx), dy: \(dy)}"
    }
}
