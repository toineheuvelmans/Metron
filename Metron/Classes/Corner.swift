import CoreGraphics

/**
 *  A `Corner` represents a place where two edges meet.
 */
public enum Corner {
    case minXminY
    case maxXminY
    case minXmaxY
    case maxXmaxY
}

public extension Corner {
    
    public init(x xEdge: CGRectEdge, y yEdge: CGRectEdge) {
        switch (xEdge, yEdge) {
        case (.minXEdge, .minYEdge): self = .minXminY
        case (.maxXEdge, .minYEdge): self = .maxXminY
        case (.minXEdge, .maxYEdge): self = .minXmaxY
        case (.maxXEdge, .maxYEdge): self = .maxXmaxY
        default: fatalError("Incorrect edge axis")
        }
    }

    /// - returns: The edge of this `Corner` for the provided axis.
    /// For example, the `minXminY` corner's `xAxis` edge is the `minXEdge`.
    public func edge(on axis: Axis) -> CGRectEdge {
        switch axis {
        case .xAxis: return xEdge
        case .yAxis: return yEdge
        }
    }
    
    /// - returns: The `xAxis` edge component of this corner
    /// (either `minXEdge` or `maxXEdge`).
    public var xEdge: CGRectEdge {
        switch self {
        case .minXminY, .minXmaxY: return .minXEdge
        case .maxXminY, .maxXmaxY: return .maxXEdge
        }
    }
    
    /// - returns: The `yAxis` edge component of this corner
    /// (either `minYEdge` or `maxYEdge`).
    public var yEdge: CGRectEdge {
        switch self {
        case .minXminY, .maxXminY: return .minYEdge
        case .minXmaxY, .maxXmaxY: return .maxYEdge
        }
    }
    
    /// - returns: The `Corner` that is opposite along the given axis.
    /// For example, the `minXminY` corner's opposite along
    /// the `xAxis` is `maxXminY`.
    public func opposite(on axis: Axis) -> Corner {
        switch axis {
        case .xAxis: return Corner(x: xEdge.opposite, y: yEdge)
        case .yAxis: return Corner(x: xEdge, y: yEdge.opposite)
        }
    }
}

// MARK: Opposable

extension Corner : Opposable {
    public static var allOpposites: [(Corner, Corner)] {
        return [(.minXminY, .maxXmaxY), (.maxXminY, .minXmaxY)]
    }
}

// MARK: CornerType

extension Corner : CornerType {
    public typealias EdgesType = CGRectEdge
    
    public var edges: (EdgesType, EdgesType) {
        return (xEdge, yEdge)
    }
}
