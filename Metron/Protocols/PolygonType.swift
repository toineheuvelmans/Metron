import CoreGraphics

/**
 *  Represents any shape that can be defined as a `Polygon`,
 *  i.e. a number (> 2) of connected points.
 */
public protocol PolygonType : Shape {
    var edgeCount: Int { get }
    var points: [CGPoint] { get }
    var lineSegments: [LineSegment] { get }
}


extension PolygonType {
    /// - returns: A `Polygon` representing this type.
    public var polygon: Polygon {
        return Polygon(points: points)
    }
}
