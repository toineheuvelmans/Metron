/**
 *  A `CornerPosition` represents the visual concept of corners
 *  (i.e. topLeft, bottomLeft, topRight, bottomRight).
 */
public enum CornerPosition {
    case topLeft, bottomLeft, topRight, bottomRight
    
    public init(x xSide: Side, y ySide: Side) {
        switch (xSide, ySide) {
        case (.left, .top): self = .topLeft
        case (.left, .bottom): self = .bottomLeft
        case (.right, .top): self = .topRight
        case (.right, .bottom): self = .bottomRight
        default: fatalError("Incorrect side axis")
        }
    }
    
    /// A corner represents two sides meeting.
    /// This returns the side for the given axis
    /// (e.g. `left` or `right` for the `xAxis`).
    public func side(on axis: Axis) -> Side {
        switch axis {
        case .xAxis: return xSide
        case .yAxis: return ySide
        }
    }
    
    /// This returns the side for the `xAxis`.
    /// (`left` or `right`).
    public var xSide: Side {
        switch self {
        case .topLeft, .bottomLeft: return .left
        case .topRight, .bottomRight: return .right
        }
    }
    
    /// This returns the side for the `yAxis`.
    /// (`top` or `bottom`).
    public var ySide: Side {
        switch self {
        case .topLeft, .topRight: return .top
        case .bottomLeft, .bottomRight: return .bottom
        }
    }
    
    /// - returns: The `CornerPosition` that is opposite along the given axis.
    /// For example, the `topLeft` corner's opposite along
    /// the `xAxis` is `topRight`.
    public func opposite(on axis: Axis) -> CornerPosition {
        switch axis {
        case .xAxis: return CornerPosition(x: xSide.opposite, y: ySide)
        case .yAxis: return CornerPosition(x: xSide, y: ySide.opposite)
        }
    }
}

extension CornerPosition : Rotatable {
    public static var allOpposites: [(CornerPosition, CornerPosition)] {
        return [(.topLeft, .bottomRight), (.topRight, .bottomLeft)]
    }
}

extension CornerPosition : CornerType {
    public typealias EdgesType = Side
    
    public var edges: (Side, Side) {
        return (xSide, ySide)
    }
}
