import CoreGraphics
import Metron

/*: Polygon
 # Polygon
 A `Polygon` is a shape existing of at least three connected
 points (and thus of at least three sides).
 */

/// Let's create a pentagon
let circle = Circle(in: Square(origin: .zero, edges: 50.0))
let points = circle.pointsAlongPerimeter(dividedInto: 5)

/// You initialize a polygon by passing a sequence of points.
let polygon1 = Polygon(points: points)
/// The points are stored in a rearranged fashion to allow for
/// easier calculation of derived properties;
polygon1.points

/// You can also initialize a polygon by passing a number of line segments:
let square = Square(origin: .zero, edges: 10.0)
let polygon2 = Polygon(lineSegments: square.lineSegments)


polygon1.lineSegments
polygon2?.lineSegments

polygon1.edgeCount
polygon2?.edgeCount

polygon1.isSelfIntersecting
polygon1.isConvex
polygon1.isConcave

/// A `Polygon` is also a Shape:
polygon1.area
polygon1.perimeter
polygon1.center    //  Is the most common: the centroid

polygon1.minX
polygon1.minY

polygon1.maxX
polygon1.maxY

polygon1.midX
polygon1.midY

polygon1.width
polygon1.height
polygon1.boundingRect

polygon1.contains(CGPoint(x: 25.0, y: 25.0))

/// A handy extension on a collection of CGPoints will
/// calculate the convex hull. This is a polygon that
/// wraps around the collection of points like a rubber band.
var pointCloud = [CGPoint]()
100.do {
    pointCloud.append(CGPoint(x: drand48() * 100.0, y: drand48() * 100.0))
}

if let convexHull = pointCloud.convexHull {
    convexHull
    convexHull.edgeCount
    convexHull.boundingRect
}

//: ---

//: [BACK: Square](@previous)     |     [NEXT: Corner](@next)
