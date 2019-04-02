@testable import Metron
import CoreGraphics
import Foundation
import Nimble
import Quick

internal class Spec: QuickSpec {
}

extension CGPoint {
    internal init(_ x: Int, _ y: Int) { self.init(x: x, y: y) }
    internal init(_ x: CGFloat, _ y: CGFloat) { self.init(x: x, y: y) }
    internal init(_ tuple: (Int, Int)) { self.init(x: tuple.0, y: tuple.1) }
    internal init(_ tuple: (CGFloat, CGFloat)) { self.init(x: tuple.0, y: tuple.1) }
}

extension Array where Element == CGPoint {
    internal init(_ tuples: [(Int, Int)]) { self = tuples.map({ CGPoint($0) }) }
    internal init(_ tuples: [(CGFloat, CGFloat)]) { self = tuples.map({ CGPoint($0) }) }
}

extension LineSegment {
    internal init(_ a: (Int, Int), _ b: (Int, Int)) { self.init(a: CGPoint(a), b: CGPoint(b)) }
    internal init(_ a: (CGFloat, CGFloat), _ b: (CGFloat, CGFloat)) { self.init(a: CGPoint(a), b: CGPoint(b)) }
}
