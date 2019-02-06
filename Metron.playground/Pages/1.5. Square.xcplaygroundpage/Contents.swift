import Metron

/*: Square
 # Square
 A `Square` is a rectangle with edges of equal length.
 */

let square1 = Square(origin: CGPoint.zero, edges: 10.0)

/// A `Square` can also be initialized by passing a rect, in which the square will be aspect-fitted in the center.
let square2 = Square(in: CGRect(origin: CGPoint.zero, size: CGSize(width: 20.0, height: 10.0)))

square2.origin
square2.edges

/// A `Square` is also a Shape:
square2.area
square2.perimeter
square2.center    //  Is the most common: the centroid

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

/// A `Square` is also a PolygonType:
square2.edgeCount
square2.points
square2.lineSegments

//: ---

//: [BACK: Triangle](@previous)     |     [NEXT: Polygon](@next)