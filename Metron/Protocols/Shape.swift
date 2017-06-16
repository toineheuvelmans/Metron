import CoreGraphics

/**
 *  Represents any shape in two-dimensional space.
 */
public protocol Shape {
    
    var area: CGFloat { get }
    var perimeter: CGFloat { get }
    var center: CGPoint { get }
    
    /// Extremities:
    var minX: CGFloat { get }
    var maxX: CGFloat { get }
    var minY: CGFloat { get }
    var maxY: CGFloat { get }
    
    /// Midpoints:
    var midX: CGFloat { get }
    var midY: CGFloat { get }
    
    /// Size along horizontal and vertical axis
    /// (i.e. width = maxX - minX).
    var width: CGFloat { get }
    var height: CGFloat { get }
    
    /// The smallest rect in which the shape can be fitted.
    var boundingRect: CGRect { get }
    
    /// True if the provided point is inside this shape.
    func contains(_ point: CGPoint) -> Bool
}
