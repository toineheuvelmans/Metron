import CoreGraphics
import Foundation
import Metron
import Nimble
import Quick

internal class PolygonSpec: QuickSpec {
    override internal func spec() {
        it("can calculate convex hull") {

            // Thanks to http://www2.lawrence.edu/fast/GREGGJ/CMSC210/convex/convex.html.

            let polygonPoints: [CGPoint] = [(2.0, 6.0), (4.0, 6.0), (3.0, 5.0), (0.1, 4.0), (2.1, 4.0), (4.1, 4.0), (6.1, 4.0), (1.3, 3.0), (3.3, 3.0), (5.3, 3.0), (0.0, 2.0), (2.1, 2.0), (4.1, 2.0), (6.1, 2.0), (3.0, 1.0), (2.0, 0.0), (4.0, 0.0)].map { CGPoint(x: $0.0, y: $0.1) }
            let expectedConvexHullPoints: [CGPoint] = [(2.0, 0.0), (4.0, 0.0), (6.1, 2.0), (6.1, 4.0), (4.0, 6.0), (2.0, 6.0), (0.1, 4.0), (0.0, 2.0)].map { CGPoint(x: $0.0, y: $0.1) }
            let convexHull: Metron.Polygon? = polygonPoints.convexHull

            expect(convexHull).toNot(beNil())
            expect(convexHull?.points) == expectedConvexHullPoints
        }
    }
}
