import CoreGraphics

/**
 *  A continous `Line` defined by either the combination of
 *  a slope and y-intercept, or if vertical by the x-position.
 */
public struct Line {
    
    public enum Definition {
        case sloped(slope: CGFloat, yIntercept: CGFloat)
        case vertical(x: CGFloat)
    }
    
    /// The definition of this line, which can either be
    /// sloped or vertical.
    public var definition: Definition
    
    public init(slope: CGFloat, yIntercept: CGFloat) {
        definition = .sloped(slope: slope, yIntercept: yIntercept)
    }
    
    public init(verticalAtX x: CGFloat) {
        definition = .vertical(x: x)
    }
}

public extension Line {
    
    /// Initializes a `Line` through the provided two points.
    public init(a: CGPoint, b: CGPoint) {
        let dx = a.x - b.x
        if dx == 0.0 {
            definition = .vertical(x: a.x)
        } else {
            let slope = (a.y - b.y) / dx
            definition = .sloped(slope: slope,
                            yIntercept: (slope * -a.x) + a.y)
        }
    }
    
    /// Initializes a line that goes through the start and end points
    /// of the provided `LineSegment`.
    public init(lineSegment: LineSegment) {
        self.init(a: lineSegment.a, b: lineSegment.b)
    }
    
    /// Initializes a line that runs at the provided `Angle`
    /// through the provided `CGPoint`.
    public init(angle: Angle, through point: CGPoint) {
        self.init(a: point, b: point + CGVector(angle: angle, magnitude: 1.0))
    }

    /// - returns: If the definition of this line is non-vertical, the slope of the line.
    public var slope: CGFloat? {
        guard case .sloped(let s, _) = definition else { return nil }
        return s
    }
    
    /// - returns: If the definition of this line is non-vertical, the y-intercept of the line.
    public var yIntercept: CGFloat? {
        guard case .sloped(_, let y) = definition else { return nil }
        return y
    }
    
    /// - returns: If the definition of this line is vertical, the x-position of the line.
    public var xPosition: CGFloat? {
        guard case .vertical(let x) = definition else { return nil }
        return x
    }
    
    /// - returns: True if this line is vertical.
    public var isVertical: Bool {
        if case .vertical(_) = definition {
            return true
        }
        return false
    }
    
    /// - returns: True if this line is horizontal (slope equals zero).
    public var isHorizontal: Bool {
        if case .sloped(let slope, _) = definition {
            return slope == 0.0
        }
        return false
    }
    
    /// - returns: The (x,y) point on this line where x equals the provided x.
    /// Will be nil for vertical lines.
    /// y = mx+b
    public func point(atX x: CGFloat) -> CGPoint? {
        guard case .sloped(let slope, let yIntercept) = definition else { return nil }
        return CGPoint(x: x, y: slope * x + yIntercept)
    }
    
    /// - returns: The (x,y) point on this line where y equals the provided y.
    /// Will be nil for horizontal lines.
    /// x = (y-b)/m
    public func point(atY y: CGFloat) -> CGPoint? {
        switch definition {
        case .sloped(let slope, let yIntercept):
            guard slope != 0 else { return nil }
            return CGPoint(x: (y - yIntercept) / slope, y: y)
        case .vertical(let x):
            return CGPoint(x: x, y: y)
        }
    }
    
    /// - returns: The value for x on this line where y is 0.
    public var xIntercept: CGFloat? {
        switch definition {
        case .sloped(let slope, let yIntercept):
            guard slope != 0 else { return nil }
            return -yIntercept / slope
        case .vertical(let x):
            return x
        }
    }
    
    /// - returns: The segment of this line that is between the provided points.
    public func segment(between p1: CGPoint, and p2: CGPoint) -> LineSegment? {
        let a = point(atX: p1.x) ?? point(atY: p1.y)
        let b = point(atX: p2.x) ?? point(atY: p2.y)
        if let a = a, let b = b {
            return LineSegment(a: a, b: b)
        }
        return nil
    }
    
    /// - returns: True when the provided point is on this `Line`.
    /// - note: An error margin of 1e-14 is allowed.
    public func contains(_ point: CGPoint) -> Bool {
        guard let pointAtX = self.point(atX: point.x) else { return false }
        return point.distance(to: pointAtX) <= 1e-14
    }
    
    /// - returns: The intersection of this `Line` with the provided `Line`.
    /// Will be nil for parallel lines.
    public func intersection(with line: Line) -> CGPoint? {
        switch (self.definition, line.definition) {
        case (.sloped(let slope1, let yIntercept1),
              .sloped(let slope2, let yIntercept2)):
            let dSlope = slope1 - slope2
            guard dSlope != 0.0 else { return nil } // parallel
            return point(atX: (yIntercept2 - yIntercept1) / dSlope)
        case (.vertical(let x),
              .sloped(let slope, let yIntercept)),
             (.sloped(let slope, let yIntercept),
              .vertical(let x)):
            return CGPoint(x: x, y: slope * x + yIntercept)
        case (.vertical(_), .vertical(_)): return nil
        }
    }
    
    /// - returns: The intersection of this `Line` with the provided `LineSegment`.
    /// Similar to intersection(with line:…), but this also checks if a
    /// found intersection is also between the line segment's start and end points.
    public func intersection(with lineSegment: LineSegment) -> CGPoint? {
        let line = lineSegment.line
        if let intersection = self.intersection(with: line) {
            return lineSegment.contains(intersection) ? intersection : nil
        } else if lineSegment.isVertical, let intersection = point(atX: lineSegment.minX) {
            return lineSegment.contains(intersection) ? intersection : nil
        }
        return nil
    }
    
    /// - returns: true if this `Line` runs parallel along the provided `Line`.
    /// Always true for two vertical lines. True for sloped lines with
    /// equal slopes.
    public func isParallel(to line: Line) -> Bool {
        switch (self.definition, line.definition) {
        case (.sloped(let slope1, _),
              .sloped(let slope2, _)):
            return slope1 == slope2
        case (.vertical(_), .vertical(_)): return true
        default: return false
        }
    }
    
    /// - returns: A `Line` that runs at a 90° angle through self,
    /// through the provided point.
    public func perpendicular(through point: CGPoint) -> Line {
        switch definition {
        case .sloped(let slope, _):
            if slope == 0.0 {
                return Line(verticalAtX: point.x)
            } else {
                let m = -1.0 / slope
                let b = -(m * point.x - point.y)
                return Line(slope: m, yIntercept: b)
            }
        case .vertical(_):
            return Line(slope: 0.0, yIntercept: point.y)
        }
    }
}

// MARK: Equatable

extension Line.Definition : Equatable {
    public static func ==(lhs: Line.Definition, rhs: Line.Definition) -> Bool {
        switch (lhs, rhs) {
            case (.sloped(let lhsSlope, let lhsYIntercept),
                  .sloped(let rhsSlope, let rhsYIntercept)):
                return lhsSlope == rhsSlope &&
                       lhsYIntercept == rhsYIntercept
            case (.vertical(let lhsX),
                  .vertical(let rhsX)):
                return lhsX == rhsX
            default: return false
        }
    }
}

extension Line : Equatable {
    public static func ==(lhs: Line, rhs: Line) -> Bool {
        return lhs.definition == rhs.definition
    }
}

// MARK: CustomDebugStringConvertible

extension Line : CustomDebugStringConvertible {
    public var debugDescription: String {
        switch definition {
        case .sloped(let slope, let yIntercept): return "Line {slope: \(slope), yIntercept: \(yIntercept)}"
        case .vertical(let x): return "Line {verticalAtX: \(x)}"
        }
    }
}
