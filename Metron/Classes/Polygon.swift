import CoreGraphics

/**
 *  A `Polygon` is a shape existing of at least three connected
 *  points (and thus of at least three sides).
 */
public struct Polygon : PolygonType {
    
    public let points: [CGPoint]
    
    /// The default initializer, returns a `Polygon` given
    /// the provided array of `CGPoints`. Note that the points
    /// will be rearranged in such a way that certain
    /// calculations can be done more easily.
    /// The initializer asserts on being given at least 3 points.
    public init(points: [CGPoint]) {
        assert(points.count > 2, "A polygon should at least have 3 points.")
        
        //  Store them in "clockwise" direction (sum of edges should be positive)
        var lastPoint = points.last!
        var edgeSum: CGFloat = 0.0
        for point in points {
            let edge = (lastPoint.x - point.x) * (lastPoint.y + point.y)
            edgeSum += edge
            lastPoint = point
        }
        let clockwisePoints = (edgeSum >= 0) ? points : points.reversed()
        
        //  Start at the minXminY point
        let minXminYPoint = clockwisePoints.reduce(clockwisePoints[0], { (($1.x <= $0.x) && ($1.y <= $0.y)) ? $1 : $0 })
        let index = clockwisePoints.index(of: minXminYPoint)!
        let pointsFromIndex = index == 0 ? clockwisePoints : Array((clockwisePoints[index..<clockwisePoints.count] + clockwisePoints[0..<index]))
        
        self.points = pointsFromIndex
    }
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
        if let  firstSegment = remainingLineSegments.popLast() {
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

extension Polygon : Drawable {
    
    public var path: CGPath? {
        var pointsIterator = points.makeIterator()
        if let first = pointsIterator.next() {
            let path = CGMutablePath()
            path.move(to: first)
            while let next = pointsIterator.next() {
                path.addLine(to: next)
            }
            path.closeSubpath()
            return path.copy()
        }
        return nil
    }
}

extension Polygon : Shape {
    
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
        let intersectionsBefore = lineSegments.flatMap { $0.intersection(with: lineThroughPoint) }.filter { $0.x < point.x }
        return intersectionsBefore.count % 2 == 1
    }
}

// MARK: Convex Hull

extension Collection where Iterator.Element == CGPoint, Index == Int {
    
    /**
     *  Any collection of points has a ConvexHull,
     *  which is a convex polygon that wraps around
     *  the outer-most points of the collection
     *  like a rubber band.
     */
    public var convexHull: Polygon? {
        guard count > 2 else { return nil }
        // Graham scan:
        let startPoint = reduce(self[0]) { (minY, p) -> CGPoint in
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
        let sorted = self.sorted { sortValue($0.0) < sortValue($0.1) }
        
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
