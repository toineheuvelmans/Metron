import CoreGraphics
import Metron

/*: Circle
 # Circle
 A circle is represented by a center and a radius.
 */

let circle1 = Circle(center: CGPoint(x: 5.0, y: 5.0), radius: 5.0)
var circle2 = Circle(center: CGPoint(x: 5.0, y: 5.0), diameter: 10.0)
let circle3 = Circle(in: Square(origin: .zero, edges: 8.0))

// Initialize by passing a rect, in which the circle will be aspect-fitted in the center:

let circle4 = Circle(in: CGRect(origin: CGPoint(x: -5.0, y: 0.0), size: CGSize(width: 20.0, height: 10.0)))

circle1.diameter
circle1.circumference

// The bounding square:

circle1.square

// `Circle` type conforms to `Shape` protocol, each `Shape` has the following properties:

circle1.area
circle1.perimeter // Same as circumference.

circle1.minX
circle1.minY

circle1.maxX
circle1.maxY

circle1.midX
circle1.midY

circle1.width
circle1.height
circle1.boundingRect

// Each `Shape` can be hit-tested:

circle1.contains(CGPoint(x: 2.5, y: 2.5))
circle1.contains(CGPoint.zero)

circle1 == circle2  // Equal when radius matches.
circle1 === circle2 // Equal when radius and center match.

circle2.center = CGPoint(x: 10.0, y: 10.0)
circle1 == circle2
circle1 === circle2

circle1 > circle4

// And a little extra:

let startingAngle = Angle(0)
let direction = RotationDirection.clockwise
let points = circle1.pointsAlongPerimeter(dividedInto: 5, startingAt: startingAngle, rotating: direction)

//: ---

//: [BACK: LineSegment](@previous)     |     [NEXT: Triangle](@next)
