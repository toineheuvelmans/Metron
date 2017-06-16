/*: Extensions
 
 # Extensions
 
 Metron also extends the basic CoreGraphics types CGPoint, CGVector, CGSize, CGRect and CGRectEdge. It offers a range of new initializers, as well as numerous common properties.
*/

import Metron

/*: CGPoint
 ## CGPoint */

let point1 = CGPoint(x: 3.5, y: 4.75)

point1.vector
point1.rounded
point1.distance(to: CGPoint(x: 10.0, y: 10.0))

let clipRect = CGRect(origin: .zero, size: CGSize(width: 3, height: 5))
point1.clipped(to: clipRect)

let containerRect = CGRect(origin: CGPoint(x: 2.0, y: 2.0), size: CGSize(width: 5.0, height: 5.0))
point1.position(in: containerRect)
point1.normalizedPosition(in: containerRect)


let line = Line(slope: 0.0, yIntercept: 4.75)
point1.isAt(line: line)

let vector = CGVector(dx: 5.0, dy: 3.0)
let point2 = point1 + vector
let point3 = point1 - vector

/*: CGVector
 ## CGVector */

let vector1 = CGVector(angle: Angle(0.125 * .pi), magnitude: 10.0)
vector1.angle
vector1.magnitude

vector1.inversed

vector1.point

vector1.dominantEdge
vector1.dominantCorner

vector1.line(through: CGPoint.zero)
vector1.lineSegment(from: point1)

let biggerVector = vector1 * 10

let translation = CGAffineTransform(translation: biggerVector)

/*: CGSize
 ## CGSize */

let size1 = CGSize(edges: 10.0)

size1.area

let size2 = CGSize(width: 20.0, height: 5.0)
size2.swapped
size2.clipped(to: size1)

size1 * size2
size1 * 5
size1 / 5

/*: CGRect
 ## CGRect */

let rectSize = CGSize(width: 8.0, height: 5.0)
let rect1 = CGRect(size: rectSize)

let rectPoint = CGPoint(x: 20.0, y: 20.0)
let rect2 = CGRect(center: rectPoint, size: rectSize)

let rect3 = CGRect(origin: rectPoint, edges: 10.0)
let rect4 = CGRect(center: rectPoint, edges: 10.0)

let rect5 = CGRect(minX: 1.0, minY: 2.0, maxX: 3.0, maxY: 4.0)

let rect6a = CGRect(size: rectSize, origin: rectPoint, inCorner: .minXminY)
let rect6b = CGRect(size: rectSize, origin: rectPoint, inCorner: .maxXminY)
let rect6c = CGRect(size: rectSize, origin: rectPoint, inCorner: .minXmaxY)
let rect6d = CGRect(size: rectSize, origin: rectPoint, inCorner: .maxXmaxY)

let rect7 = CGRect(aspectFitSize: rectSize, inRect: rect3)
let rect8 = CGRect(aspectFillSize: rectSize, inRect: rect3)


rect8.edge(.minXEdge)
rect8.edge(.maxXEdge)
rect8.edge(.minYEdge)
rect8.edge(.maxYEdge)

rect8.corner(.minXminY)
rect8.corner(.maxXminY)
rect8.corner(.minXmaxY)
rect8.corner(.maxXmaxY)

rect8.scaled(by: 2.0)
rect8.scaled(by: 2.0, corner: .minXminY)
rect8.scaled(by: 2.0, corner: .maxXmaxY)

rect8.lineSegments
rect8.lineSegment(for: .minXEdge)

rect8.path

rect8.area
rect8.center
rect8.perimeter
rect8.boundingRect

rect8.edgeCount
rect8.points

/*: CGRectEdge
 ## CGRectEdge */

let edge = CGRectEdge.maxXEdge
edge.corners
edge.axis
edge.opposite

//: ---

//: [BACK: CoordinateSystem](@previous)
