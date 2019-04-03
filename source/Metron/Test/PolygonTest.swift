@testable import Metron
import CoreGraphics
import Foundation
import Nimble
import Quick

internal class PolygonSpec: Spec {
    override internal func spec() {
        it("can calculate convex hull") {

            // Thanks to http://www2.lawrence.edu/fast/GREGGJ/CMSC210/convex/convex.html.

            let polygonPoints: [CGPoint] = Array([(2, 6), (4, 6), (3, 5), (0.1, 4), (2.1, 4), (4.1, 4), (6.1, 4), (1.3, 3), (3.3, 3), (5.3, 3), (0, 2), (2.1, 2), (4.1, 2), (6.1, 2), (3, 1), (2, 0), (4, 0)])
            let expectedConvexHullPoints: [CGPoint] = Array([(2, 0), (4, 0), (6.1, 2), (6.1, 4), (4, 6), (2, 6), (0.1, 4), (0, 2)])
            let convexHull: Metron.Polygon? = polygonPoints.convexHull

            expect(convexHull).toNot(beNil())
            expect(convexHull?.points) == expectedConvexHullPoints
        }

        it("can return line segments") {
            let points: [CGPoint] = Array([(0, 0), (0, 5), (5, 5), (5, 0)])
            let segments = zip(points, points.suffix(from: 1) + points.prefix(1)).map({ LineSegment(a: $0, b: $1) })
            let polygon: Metron.Polygon = Metron.Polygon(points: points)

            expect(polygon.lineSegments) == segments
        }

        it("can check if self intersecting") {
            expect(Metron.Polygon(points: Array([(0, 0), (10, 5), (10, 0), (0, 5)])).isSelfIntersecting) == true
            expect(Metron.Polygon(points: Array([(0, 0), (10, 0), (10, 5), (0, 5)])).isSelfIntersecting) == false
        }

        it("can calculate area") {
            expect(Metron.Polygon(points: Array([(0, 0), (10, 0), (10, 5)])).area) == 25
            expect(Metron.Polygon(points: Array([(0, 0), (10, 0), (10, 5), (0, 5)])).area) == 50
            expect(Metron.Polygon(points: Array([(0, 0), (10, 5), (10, 0), (0, 5)])).area.isNaN) == true // Self-intersecting polygon area is not available.
        }
    }
}
