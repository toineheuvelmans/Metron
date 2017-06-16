import CoreGraphics

public extension CGPoint {
    
    /// - returns: A `CGVector` with dx: x and dy: y.
    public var vector: CGVector {
        return CGVector(dx: x, dy: y)
    }
    
    /// - returns: A `CGPoint` with rounded x and y values.
    public var rounded: CGPoint {
        return CGPoint(x: round(x), y: round(y))
    }
    
    /// - returns: The Euclidean distance from self to the given point.
    public func distance(to point: CGPoint) -> CGFloat {
        return (point - self).magnitude
    }
    
    /// Constrains the x and y value to within the provided rect.
    public func clipped(to rect: CGRect) -> CGPoint {
        return CGPoint(x: x.clipped(rect.minX, rect.maxX),
                       y: y.clipped(rect.minY, rect.maxY))
    }
    
    /// - returns: The relative position inside the provided rect.
    public func position(in rect: CGRect) -> CGPoint {
        return CGPoint(x: x - rect.origin.x,
                       y: y - rect.origin.y)
    }
    
    /// - returns: The position inside the provided rect,
    /// where horizontal and vertical position are normalized
    /// (i.e. mapped to 0-1 range).
    public func normalizedPosition(in rect: CGRect) -> CGPoint {
        let p = position(in: rect)
        return CGPoint(x: (1.0 / rect.width) * p.x,
                       y: (1.0 / rect.width) * p.y)
    }
    
    /// - returns: True if the line contains the point.
    public func isAt(line: Line) -> Bool {
        return line.contains(self)
    }
}

// MARK: Arithmetic

public func +(lhs: CGPoint, rhs: CGPoint) -> CGVector {
    return CGVector(dx: lhs.x + rhs.x, dy: lhs.y + rhs.y)
}

public func -(lhs: CGPoint, rhs: CGPoint) -> CGVector {
    return CGVector(dx: lhs.x - rhs.x, dy: lhs.y - rhs.y)
}


public func +(lhs: CGPoint, rhs: CGVector) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
}

public func -(lhs: CGPoint, rhs: CGVector) -> CGPoint {
    return CGPoint(x: lhs.x - rhs.dx, y: lhs.y - rhs.dy)
}


public func *(lhs: CGPoint, rhs: CGFloat) -> CGPoint {
    return CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
}

public func *(lhs: CGFloat, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: rhs.x * lhs, y: rhs.y * lhs)
}
