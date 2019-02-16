import CoreGraphics
import Metron

/*: LineSegment
 # LineSegment
 Represents a straight line between two points.
 */

let lineSegment1 = LineSegment(a: CGPoint(x: 0.0, y: 2.0), b: CGPoint(x: 10.0, y: 5.0))

lineSegment1.vector
lineSegment1.midpoint

let lineSegment2 = LineSegment(origin: CGPoint(x: 0.0, y: 2.0), vector: CGVector(dx: 5.0, dy: 5.0))

lineSegment2.a
lineSegment2.b

lineSegment2.line

lineSegment2.minX
lineSegment2.minY
lineSegment2.maxX
lineSegment2.maxY

lineSegment2.midpoint

lineSegment2.isVertical

lineSegment2.contains(lineSegment1.midpoint)

lineSegment2.points

lineSegment1.length
lineSegment2.length
lineSegment1 > lineSegment2

lineSegment1.intersection(with: lineSegment2)

lineSegment2.rotatedAroundA(Angle(0.5)).vector
lineSegment2.rotatedAroundB(Angle(0.5)).vector

lineSegment2.applying(CGAffineTransform(translationX: 5.0, y: 2.0))

//: ---

//: [BACK: Line](@previous)     |     [NEXT: Circle](@next)
