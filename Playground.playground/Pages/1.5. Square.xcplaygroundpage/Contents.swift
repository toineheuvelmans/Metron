import CoreGraphics
import Metron

/*: Square
 # Square
 A rectangle with edges of equal length.
 */

let square1 = Square(origin: CGPoint.zero, edges: 10.0)

// Initialize by passing a rect, in which the square will be aspect-fitted in the center:

let square2 = Square(in: CGRect(origin: CGPoint.zero, size: CGSize(width: 20.0, height: 10.0)))

square2.origin
square2.edges

// `Square` type conforms to `PolygonType` protocol:

square2.edgeCount
square2.points
square2.lineSegments

// `PolygonType` inherits from `Shape` protocol:

square2.area
square2.perimeter
square2.center // Is the most common: the centroid.

square2.minX
square2.minY

square2.maxX
square2.maxY

square2.midX
square2.midY

square2.width
square2.height
square2.boundingRect

square2.contains(CGPoint(x: 2.5, y: 2.5))

// `Square` is also a PolygonType:


//: ---

//: [BACK: Triangle](@previous)     |     [NEXT: Polygon](@next)
