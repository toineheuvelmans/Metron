import CoreGraphics

// MARK: Triangle Helpers

/// A Vertex is a meeting point of two lines forming an angle.
public typealias Vertex = CGPoint

/// A Triplet is an (a, b, c) representation of
/// three related values of a specific type.
public struct Triplet<T> {
    public var a: T
    public var b: T
    public var c: T
    
    public init(a: T, b: T, c: T) {
        self.a = a
        self.b = b
        self.c = c
    }
    
    public init?(_ array: [T]) {
        guard array.count == 3 else { return nil }
        self.a = array[0]
        self.b = array[1]
        self.c = array[2]
    }
    
    public var asArray: [T] {
        return [a, b, c]
    }
}

public extension Triplet where T: Summable {
    public var sum: T {
        return a + b + c
    }
}

// MARK: Triangle

/**
 *  A `Triangle` is a shape with three straight sides and three angles.
 *  It is defined by its three vertices, the points where the sides
 *  meet.
 */
public struct Triangle {
    public var vertices: Triplet<Vertex>
    
    public init(_ verticesTriplet: Triplet<Vertex>) {
        self.vertices = verticesTriplet
    }
    
    public init(a: Vertex, b: Vertex, c: Vertex) {
        self.vertices = Triplet<Vertex>(a: a, b: b, c: c)
    }
}


public extension Triangle {
    
    public var vertexA: Vertex {
        return vertices.a
    }
    public var vertexB: Vertex {
        return vertices.b
    }
    public var vertexC: Vertex {
        return vertices.c
    }
}

public extension Triangle {
    
    /// Side A is opposite `vertexA`.
    public var sideA: LineSegment {
        return LineSegment(a: vertices.b, b: vertices.c)
    }
    /// Side B is opposite `vertexB`.
    public var sideB: LineSegment {
        return LineSegment(a: vertices.c, b: vertices.a)
    }
    /// Side C is opposite `vertexC`.
    public var sideC: LineSegment {
        return LineSegment(a: vertices.a, b: vertices.b)
    }
    
    /// All sides as `Triplet`.
    public var sides: Triplet<LineSegment> {
        return Triplet(a: sideA, b: sideB, c: sideC)
    }
}

public extension Triangle {
    
    /// Angle A is the angle at vertex A,
    /// from side C to side B.
    public var angleA: Angle {
        return angles.a
    }
    
    /// Angle B is the angle at vertex B,
    /// from side A to side C.
    public var angleB: Angle {
        return angles.b
    }
    
    /// Angle C is the angle at vertex C,
    /// from side B to side A.
    public var angleC: Angle {
        return angles.c
    }
    
    /// All angles as `Triplet`. These are calculated together
    /// to guarantee the angles are not inversed (negative or reflex).
    public var angles: Triplet<Angle> {
        let a = vertexA.angle(previous: vertexC, next: vertexB)
        let b = vertexB.angle(previous: vertexA, next: vertexC)
        let c = vertexC.angle(previous: vertexB, next: vertexA)
        
        if a.value < 0 || b.value < 0 || c.value < 0 {
            return Triplet(a: a.inversed, b: b.inversed, c: c.inversed)
        }
        return Triplet(a: a, b: b, c: c)
    }
}

public extension Triangle {
    
    /// An angle bisector divides the angle into two angles with equal measures.
    /// `angleBisectorA` bisects `angleA`.
    public var angleBisectorA: LineSegment {
        return LineSegment(a: vertices.a, b: vertices.b).rotatedAroundA(0.5 * angleA)
    }
    
    /// An angle bisector divides the angle into two angles with equal measures.
    /// `angleBisectorB` bisects `angleB`.
    public var angleBisectorB: LineSegment {
        return LineSegment(a: vertices.b, b: vertices.c).rotatedAroundA(0.5 * angleB)
    }
    
    /// An angle bisector divides the angle into two angles with equal measures.
    /// `angleBisectorC` bisects `angleC`.
    public var angleBisectorC: LineSegment {
        return LineSegment(a: vertices.c, b: vertices.a).rotatedAroundA(0.5 * angleC)
    }
    
    /// All angle bisectors as `Triplet`.
    public var angleBisectors: Triplet<LineSegment> {
        return Triplet(a: angleBisectorA, b: angleBisectorB, c: angleBisectorC)
    }
}

public extension Triangle {
    
    /// An altitude of a triangle is a straight line through a vertex 
    /// and perpendicular to the opposite side.
    /// `altitudeA` goes perpendicular from `sideA` to `vertexA`.
    public var altitudeA: LineSegment {
        let line = sideA.line.perpendicular(through: vertexA)
        return line.segment(between: line.intersection(with: sideA)!, and: vertexA)!
    }
    
    /// An altitude of a triangle is a straight line through a vertex
    /// and perpendicular to the opposite side.
    /// `altitudeB` goes perpendicular from `sideB` to `vertexB`.
    public var altitudeB: LineSegment {
        let line = sideB.line.perpendicular(through: vertexB)
        return line.segment(between: line.intersection(with: sideB)!, and: vertexB)!
    }
    
    /// An altitude of a triangle is a straight line through a vertex
    /// and perpendicular to the opposite side.
    /// `altitudeC` goes perpendicular from `sideC` to `vertexC`.
    public var altitudeC: LineSegment {
        let line = sideC.line.perpendicular(through: vertexC)
        return line.segment(between: line.intersection(with: sideC)!, and: vertexC)!
    }
    
    /// All altitudes as `Triplet`.
    public var altitudes: Triplet<LineSegment> {
        return Triplet(a: altitudeA, b: altitudeB, c: altitudeC)
    }
}

// MARK: Classification

public extension Triangle {
    
    //  By lengths of sides
    
    /// True if all sides are equal.
    public var isEquilateral: Bool {
        let sides = self.sides
        let (a, b, c) = (sides.a.length, sides.b.length, sides.c.length)
        return a == b &&
               a == c
    }
    
    /// True iff two sides are equal.
    public var isIsosceles: Bool {
        let sides = self.sides
        let (a, b, c) = (sides.a.length, sides.b.length, sides.c.length)
        return (a == b && a != c) ||
               (a == c && a != b) ||
               (b == c && a != b)
    }
    
    /// True if all sides are different.
    public var isScalene: Bool {
        let sides = self.sides
        let (a, b, c) = (sides.a.length, sides.b.length, sides.c.length)
        return a != b && a != c && b != c
    }
    
    //  By internal angles
    
    /// True if one angle is exactly 90°.
    public var isRight: Bool {
        return angles.asArray.first { round($0.degrees) == 90.0 } != nil
    }
    /// True of no angle is 90°.
    public var isOblique: Bool {
        return !isRight
    }
    
    /// True if all angles are less than 90°.
    public var isAcute: Bool {
        return angles.asArray.reduce(true, { return $0 && $1.degrees < 90.0 })
    }
    /// True if one angle is more than 90°.
    public var isObtuse: Bool {
        return !isAcute
    }
}

public extension Triangle {
    
    /// The intersection of the lines drawn from each 
    /// vertex to the midpoint of the other side.
    public var centroid: CGPoint {
        return CGPoint(x: (vertexA.x + vertexB.x + vertexC.x) / 3.0,
                       y: (vertexA.y + vertexB.y + vertexC.y) / 3.0)
    }
    
    /// The interscetion of each side's perpendicular bisector
    /// (a perpendicular line drawn from the midpoint of a side).
    public var cicrumcenter: CGPoint {
        let perpendicularBisectorA = sideA.line.perpendicular(through: sideA.midpoint)
        let perpendicularBisectorB = sideB.line.perpendicular(through: sideB.midpoint)
        return perpendicularBisectorA.intersection(with: perpendicularBisectorB)!
    }
    
    /// The intersection of each angle's bisector
    /// (An angle bisector divides the angle into two angles with equal measures).
    public var incenter: CGPoint {
        return angleBisectorA.intersection(with: angleBisectorB)!
    }
    
    /// The intersection of each side's altitude
    /// (a line drawn at right angle to a side and going through the opposite vertex).
    public var orthocenter: CGPoint {
        return altitudeA.intersection(with: altitudeB)!
    }
}

// MARK: Polygon

extension Triangle : PolygonType {
    
    public var edgeCount: Int {
        return 3
    }
    
    public var points: [CGPoint] {
        return vertices.asArray
    }
    
    public var lineSegments: [LineSegment] {
        return sides.asArray
    }
}

extension Triangle : Drawable {
    
    public var path: CGPath? {
        let path = CGMutablePath()
        path.move(to: vertices.a)
        path.addLine(to: vertices.b)
        path.addLine(to: vertices.c)
        
        path.closeSubpath()
        return path.copy()
    }
}

extension Triangle : Shape {
    
    public var area: CGFloat {
        //  Heron's Formula
        let s = perimeter / 2.0
        return sqrt(s * (s - sideA.length) * (s - sideB.length) * (s - sideC.length))
    }
    
    public var perimeter: CGFloat {
        return lineSegments.reduce(CGFloat(0.0), { $0 + $1.length })
    }
    
    /// This returns the most common of triangle centers, the centroid.
    public var center: CGPoint {
        return centroid
    }
    
    /// Extremities:
    public var minX: CGFloat {
        return vertices.asArray.reduce(CGFloat.greatestFiniteMagnitude, { current, point -> CGFloat in
            return min(current, point.x)
        })
    }
    public var maxX: CGFloat {
        return vertices.asArray.reduce(-CGFloat.greatestFiniteMagnitude, { current, point -> CGFloat in
            return max(current, point.x)
        })
    }
    public var minY: CGFloat {
        return vertices.asArray.reduce(CGFloat.greatestFiniteMagnitude, { current, point -> CGFloat in
            return min(current, point.y)
        })
    }
    public var maxY: CGFloat {
        return vertices.asArray.reduce(-CGFloat.greatestFiniteMagnitude, { current, point -> CGFloat in
            return max(current, point.y)
        })
    }
    
    /// Midpoints:
    public var midX: CGFloat {
        let minX = self.minX
        return minX + ((maxX - minX) / 2.0)
    }
    public var midY: CGFloat {
        let minY = self.minY
        return minY + ((maxY - minY) / 2.0)
    }
    
    public var width: CGFloat { return maxX - minX }
    public var height: CGFloat { return maxY - minY }
    
    public var boundingRect: CGRect {
        return CGRect(minX: minX, minY: minY, maxX: maxX, maxY: maxY)
    }
    
    public func contains(_ point: CGPoint) -> Bool {
        let planeDirection: (Vertex, Vertex) -> CGFloat = { v1, v2 in
            let plane = (v1.x - point.x) * (v2.y - point.y) - (v2.x - point.x) * (v1.y - point.y)
            return abs(plane) / plane
        }
        let dirAB = planeDirection(vertices.a, vertices.b)
        let dirBC = planeDirection(vertices.b, vertices.c)
        let dirCA = planeDirection(vertices.c, vertices.a)
        
        return dirAB == dirBC && dirBC == dirCA
    }
}


// MARK: CustomDebugStringConvertible

extension Triangle : CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Triangle {a: \(vertexA), b: \(vertexB), c: \(vertexC)}"
    }
}

extension Triplet : CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Triplet {a: \(a), b: \(b), c: \(c)}"
    }
}
