@testable import Metron
import CoreGraphics
import Foundation
import Nimble
import Quick

internal class LineSegmentSpec: Spec {
    override internal func spec() {
        it("can check if contains a point") {
            var segments: [LineSegment] = [LineSegment((0, 0), (10, 0)), LineSegment((0, 0), (10, 10)), LineSegment((0, 0), (0, 10))]
            segments += segments.map({ LineSegment(a: $0.b, b: $0.a) })

            segments.forEach({
                expect($0.contains($0.a)) == true
                expect($0.contains($0.b)) == true
                expect($0.contains($0.midpoint)) == true
            })
        }

        it("can calculate intersection point with another segment") {
            expect(LineSegment((0, 0), (10, 10)).intersection(with: LineSegment((0, 10), (10, 0)))) == CGPoint(5, 5)
            expect(LineSegment((10, 10), (0, 0)).intersection(with: LineSegment((10, 0), (0, 10)))) == CGPoint(5, 5)
            expect(LineSegment((0, 0), (10, 10)).intersection(with: LineSegment((0, 0), (10, -10)))) == CGPoint(0, 0)
            expect(LineSegment((0, 0), (10, 10)).intersection(with: LineSegment((10, 10), (20, 20)))).to(beNil()) // Because parallel…
        }
    }
}
