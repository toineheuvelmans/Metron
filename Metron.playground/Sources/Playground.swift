import Metron   //  If you get a build error on this line, try building for a Simulator device
import UIKit

// MARK: Playgrounds

public extension Metron.Drawable {
    public var customPlaygroundQuickLook: PlaygroundQuickLook {
        if let path = self.path {
            return .bezierPath(UIBezierPath(cgPath: path))
        }
        return PlaygroundQuickLook(reflecting: self)
    }
}

//extension LineSegment : CustomPlaygroundQuickLookable {}
//extension Circle : CustomPlaygroundQuickLookable {}
//extension Triangle : CustomPlaygroundQuickLookable {}
//extension Square : CustomPlaygroundQuickLookable {}
extension Metron.Polygon : CustomPlaygroundQuickLookable {}


public extension Int {
    public func `do`(_ block: () -> ()) {
        guard self > 0 else { return }
        for _ in 0..<self {
            block()
        }
    }
}
