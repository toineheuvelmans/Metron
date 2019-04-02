import CoreGraphics

/**
 *  Represents any shape that can be defined as a `Polygon`,
 *  i.e. a number (> 2) of connected points.
 */
public protocol PolygonType: Shape {
    var edgeCount: Int { get }
    var points: [CGPoint] { get }
    var lineSegments: [LineSegment] { get }
}


extension PolygonType {
    /// - returns: A `Polygon` representing this type.
    public var polygon: Polygon {
        return Polygon(points: points)
    }
}

/// A `Polygon` is a shape existing of at least three connected points (and thus of at least three sides).
public struct Polygon: PolygonType {

    /// The default initializer, returns a `Polygon` given the provided array of `CGPoints`.
    public init(points: [CGPoint]) {
        assert(points.count >= 3, "A polygon must have at least 3 points.")
        self.points = points
    }

    public let points: [CGPoint]
}

public extension Polygon {

    /// Initializes a `Polygon` given a number of `LineSegments`.
    /// The first lineSegment is taken as starting point,
    /// from which a connecting lineSegment is saught,
    /// until all lineSegments are connected.
    /// Then the default initializer is called, passing
    /// all points of the connected lineSegments.
    public init?(lineSegments: [LineSegment]) {
        var remainingLineSegments = lineSegments
        var points = [CGPoint]()
        if let firstSegment = remainingLineSegments.popLast() {
            points.append(contentsOf: firstSegment.points)
        }
        while remainingLineSegments.count > 0,
              let lastPoint = points.last,
              let nextSegmentIndex = remainingLineSegments.index(where: { $0.a == lastPoint || $0.b == lastPoint }) {
            let nextSegment = remainingLineSegments.remove(at: nextSegmentIndex)
            let nextPoint = nextSegment.a == lastPoint ? nextSegment.b : nextSegment.a
            if let firstPoint = points.first, nextPoint != firstPoint {
                points.append(nextPoint)
            }
        }
        guard points.count > 2 else { return nil }
        self.init(points: points)
    }

    /// The individual line segments between consecutive points of this polygon.
    public var lineSegments: [LineSegment] {
        var lineSegments = [LineSegment]()
        (0..<edgeCount).forEach { pointIndex in
            let point = points[pointIndex]
            let nextPoint = points[(pointIndex + 1) % edgeCount]
            lineSegments.append(LineSegment(a: point, b: nextPoint))
        }
        return lineSegments
    }

    /// The number of edges of this polygon.
    public var edgeCount: Int {
        return points.count
    }

    /// - returns: True if line segments of this polygon intersect each other.
    public var isSelfIntersecting: Bool {
        //  Might be implemented more efficiently
        var lineSegments = self.lineSegments
        while let segment = lineSegments.popLast() {
            if let _ = lineSegments.first(where: { $0.intersection(with: segment) != nil }) {
                return true
            }
        }
        return false
    }

    /// - returns: True if all interior angles are less than 180°.
    public var isConvex: Bool {
        for pointIndex in 0..<edgeCount {
            let a = points[pointIndex]
            let b = points[(pointIndex + 1) % edgeCount]
            let c = points[(pointIndex + 2) % edgeCount]

            let angle = b.angle(previous: a, next: c).normalized
            if angle.radians > .pi {
                return false
            }
        }
        return true
    }

    /// - returns: true if one or more interior angles is more than 180°.
    public var isConcave: Bool {
        return !isConvex
    }
}

extension Polygon: Drawable {

    public var path: CGPath? {
        let path = CGMutablePath()
        path.addLines(between: self.points)
        path.closeSubpath()
        return path
    }
}

extension Polygon: Shape {

    public var center: CGPoint {
        return boundingRect.center
    }

    public var perimeter: CGFloat {
        return lineSegments.reduce(CGFloat(0.0), { $0 + $1.length })
    }

    /**
     *  Note: area for a self-intersecting polygon is
     *  not supported, so this will return .nan .
     */
    public var area: CGFloat {
        guard isSelfIntersecting == false else { return .nan }
        var numerator = CGFloat(0.0)
        (0..<edgeCount).forEach { pointIndex in
            let point = points[pointIndex]
            let nextPoint = points[(pointIndex + 1) % edgeCount]
            numerator += (point.x * nextPoint.y) - (point.y * nextPoint.x)
        }
        return abs(numerator / 2.0)
    }

    public var minX: CGFloat {
        return points.reduce(CGFloat.greatestFiniteMagnitude, { current, point -> CGFloat in
            return min(current, point.x)
        })
    }

    public var maxX: CGFloat {
        return points.reduce(-CGFloat.greatestFiniteMagnitude, { current, point -> CGFloat in
            return max(current, point.x)
        })
    }

    public var minY: CGFloat {
        return points.reduce(CGFloat.greatestFiniteMagnitude, { current, point -> CGFloat in
            return min(current, point.y)
        })
    }

    public var maxY: CGFloat {
        return points.reduce(-CGFloat.greatestFiniteMagnitude, { current, point -> CGFloat in
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
        guard boundingRect.contains(point) else { return false }
        //  Raycasting
        let lineThroughPoint = Line(angle: Angle(0.0), through: point)
        let intersectionsBefore = lineSegments.compactMap { $0.intersection(with: lineThroughPoint) }.filter { $0.x < point.x }
        return intersectionsBefore.count % 2 == 1
    }
}

extension Collection where Element == CGPoint, Index == Int {

    /// A convex hull – a convex polygon that wraps around the outer-most 
    /// points of the collection like a rubber band.
    public var convexHull: Polygon? {
        guard self.count >= 3 else { return nil }

        // Graham scan:
        let startPoint = sortedClockwise.reduce(self[0]) { (minY, p) -> CGPoint in
            if p.y < minY.y {
                return p
            } else if p.y == minY.y {
                //  tie: minX too
                return p.x < minY.x ? p : minY
            }
            return minY
        }

        //  sort by polarAngle
        let sortValue: (CGPoint) -> CGFloat = { p in
            return p.polarAngle(reference: startPoint).radians
        }
        let sorted = self.sorted { sortValue($0) < sortValue($1) }

        //  pre-populate
        var hullPoints: [CGPoint] = Array(sorted[0...2])

        //  scan
        let direction: (CGPoint, CGPoint, CGPoint) -> CGFloat = { a, b, c in
            return (b.x - a.x) * (c.y - a.y) - (c.x - a.x) * (b.y - a.y)
        }

        for pointIndex in 3..<sorted.count {
            let p = sorted[pointIndex]
            while direction(hullPoints[hullPoints.count - 2], hullPoints.last!, p) <= 0 {
                let _ = hullPoints.popLast()
            }
            hullPoints.append(p)
        }

        return Polygon(points: hullPoints)
    }
}

extension Collection where Element == CGPoint {

    /// - see: https://stackoverflow.com/a/6989383/458356
    internal var sortedClockwise: [CGPoint] {
        if self.isEmpty { return [] }

        let points: [CGPoint] = Array(self)

        //  Store them in a clockwise direction – the sum of edges should be positive.
        var lastPoint: CGPoint = points.last!
        var edgeSum: CGFloat = 0

        for point in points {
            edgeSum += (lastPoint.x - point.x) * (lastPoint.y + point.y)
            lastPoint = point
        }

        let clockwisePoints: [CGPoint] = (edgeSum >= 0) ? points : points.reversed()

        //  Find the minX minY point index.
        let index: Int = clockwisePoints.indices.reduce(0, { (clockwisePoints[$1].x <= clockwisePoints[$0].x && clockwisePoints[$1].y <= clockwisePoints[$0].y) ? $1 : $0 })
        return index == 0 ? clockwisePoints : Array(clockwisePoints.suffix(from: index) + clockwisePoints.prefix(index))
    }
}
