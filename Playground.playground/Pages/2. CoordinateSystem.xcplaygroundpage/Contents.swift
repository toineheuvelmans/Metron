import CoreGraphics
import Metron

/*: CoordinateSystem, CornerPosition and Side
 # CoordinateSystem
 A `CoordinateSystem` is a simple description of a two-dimensional space defined by its origin (the visual corner in which the origin `{0, 0}` is found. On iOS this defaults to top / left, while on macOS this is bottom / left.
 The `CoordinateSystem` is used to translate from visual positions (e.g. top, right, bottom, left) to coordinate positions (minY, maxX, maxY, minX).
 */

let cs1 = CoordinateSystem.default
let cs2 = CoordinateSystem(origin: .bottomRight)

let cs = cs1

cs.edges

cs.side(for: .minYEdge)
cs.edge(for: .left)

cs.corners

cs.corner(for: .bottomRight)
cs.position(for: .maxXminY)

cs.corners(startingAt: .minXminY, rotating: .clockwise)
cs.edges(startingAt: .minXEdge, rotating: .counterClockwise)


//: ---

//: [BACK: Angle](@previous)     |     [NEXT: Extensions](@next)
