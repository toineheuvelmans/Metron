import CoreGraphics

/**
 *  A `Square` is a rectangle with edges of equal length.
 */
public struct Square {
    public var origin: CGPoint
    public var edges: CGFloat
    
    public init(origin: CGPoint, edges: CGFloat) {
        self.origin = origin
        self.edges = edges
    }
}


public extension Square {
    /// Initializes a `Square` that is aspect-fitted in
    /// the center of the provided rect.
    public init(in rect: CGRect) {
        let square = CGRect(aspectFitSize: CGSize(edges: min(rect.width, rect.height)), inRect: rect)
        self.init(origin: square.origin, edges: square.width)
    }
    
    /// - returns: The `CGRect` representing this square.
    public var rect: CGRect {
        return CGRect(origin: origin, edges: edges)
    }
}


extension Square : Drawable {
    public var path: CGPath? {
        return rect.path
    }
}

extension Square : Shape {
    
    public var area: CGFloat {
        return rect.area
    }
    
    public var perimeter: CGFloat {
        return rect.perimeter
    }
    
    public var center: CGPoint {
        return rect.center
    }
    
    /// Extremities:
    public var minX: CGFloat { return origin.x }
    public var maxX: CGFloat { return origin.x + edges }
    public var minY: CGFloat { return origin.y }
    public var maxY: CGFloat { return origin.y + edges }
    
    /// Midpoints:
    public var midX: CGFloat { return center.x }
    public var midY: CGFloat { return center.y }
    
    public var width: CGFloat { return edges }
    public var height: CGFloat { return edges }
    
    public var boundingRect: CGRect { return rect }
    
    public func contains(_ point: CGPoint) -> Bool {
        return rect.contains(point)
    }
}

extension Square : PolygonType {
    public var edgeCount: Int {
        return 4
    }
    public var points: [CGPoint] {
        let rect = self.rect
        return CoordinateSystem.default.corners.map { rect.corner($0) }
    }
    public var lineSegments: [LineSegment] {
        return rect.lineSegments
    }
}

// MARK: CustomDebugStringConvertible

extension Square : CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Square {origin: \(origin), edges: \(edges)}"
    }
}
