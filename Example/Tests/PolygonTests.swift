import XCTest
import Metron
import Hamcrest

/// https://www.drivenbycode.com/the-missing-apply-function-in-swift/
/// Allows us to pass an array in a variadic function
func apply<T, U>(_ f: (T...) -> U, _ args: [T]) -> U {
    typealias FunctionType = ([T]) -> U
    return withoutActuallyEscaping(f) { f in
        unsafeBitCast(f, to: FunctionType.self)(args)
    }
}

class PolygonTests: XCTestCase {
    
    func testConvexHull() {
        /// Thanks to http://www2.lawrence.edu/fast/GREGGJ/CMSC210/convex/convex.html
        let points = [(2.0, 6.0), (4.0, 6.0), (3.0, 5.0), (0.1, 4.0), (2.1, 4.0), (4.1, 4.0), (6.1, 4.0), (1.3, 3.0), (3.3, 3.0), (5.3, 3.0), (0.0, 2.0), (2.1, 2.0), (4.1, 2.0), (6.1, 2.0), (3.0, 1.0), (2.0, 0.0), (4.0, 0.0)].map { CGPoint(x: $0.0, y: $0.1) }
        let expectedOutput = [(2.0, 0.0), (4.0, 0.0), (6.1, 2.0), (6.1, 4.0), (4.0, 6.0), (2.0, 6.0), (0.1, 4.0), (0.0, 2.0)].map { CGPoint(x: $0.0, y: $0.1) }
        if let polygon = points.convexHull {
            let polygonPoints = polygon.points
            assertThat(polygonPoints, apply(contains, expectedOutput))
        } else {
            XCTFail("No polygon could be derived from the points")
        }
        
    }
}
