import CoreGraphics

/**
 *  Any figure from which a path can be derived
 *  that can then be drawn.
 */
public protocol Drawable {
    var path: CGPath? { get }
}
