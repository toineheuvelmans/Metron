import Metron

/*: Line
 # Line
 This is a continous line defined by either the combination of
 a slope and y-intercept, or if vertical by the x-position.
 */
let slopedLine1 = Line(slope: 0.5, yIntercept: 2.0)

/// A line through 2 points:
let slopedLine2 = Line(a: CGPoint(x: 0.0, y: 2.0), b: CGPoint(x: 4.0, y: 4.0))

let verticalLine1 = Line(verticalAtX: 4.0)
let verticalLine2 = Line(angle: Angle(0.5 * .pi), through: CGPoint(x: 5.0, y: 5.0))

/// A line following a LineSegment (a line between two points):
let lineSegment = LineSegment(origin: CGPoint.zero, vector: CGVector(dx: 10.0, dy: 0.0))
let horizontalLine = Line(lineSegment: lineSegment)

horizontalLine.isHorizontal
verticalLine1.isVertical

slopedLine1.slope
slopedLine1.yIntercept    /// The y-coordinate where x = 0
slopedLine1.xIntercept    /// The x-coordinate where y = 0

verticalLine2.xPosition
verticalLine2.isParallel(to: verticalLine1)

slopedLine1.point(atX: 10.0)
slopedLine1.point(atY: 7.0)

slopedLine1.segment(between: CGPoint.zero, and: CGPoint(x: 10.0, y: 7.0))

slopedLine1.contains(CGPoint(x: 10.0, y: 7.0))
slopedLine1.contains(CGPoint(x: 5.0, y: 5.0))

slopedLine1.intersection(with: verticalLine1)

slopedLine1.perpendicular(through: CGPoint.zero)

//: ---

//: [BACK: New types](@previous)     |     [NEXT: Line Segment](@next)