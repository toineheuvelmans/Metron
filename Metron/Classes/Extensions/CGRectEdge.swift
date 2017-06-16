import CoreGraphics

extension CGRectEdge : Opposable {
    public static var allOpposites: [(CGRectEdge, CGRectEdge)] {
        return [(.minXEdge, .maxXEdge), (.minYEdge, .maxYEdge)]
    }
}

extension CGRectEdge : EdgeType {
    
    public typealias CornerType = Corner
    
    public var corners: (CornerType, CornerType) {
        switch self {
        case .minXEdge: return (.minXminY, .minXmaxY)
        case .minYEdge: return (.minXminY, .maxXminY)
        case .maxXEdge: return (.maxXminY, .maxXmaxY)
        case .maxYEdge: return (.minXmaxY, .maxXmaxY)
        }
    }
    
    public var axis: Axis {
        switch self {
        case .minXEdge, .maxXEdge: return .xAxis
        case .minYEdge, .maxYEdge: return .yAxis
        }
    }
}

extension CGRectEdge : CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .minXEdge: return "minXEdge"
        case .maxXEdge: return "maxXEdge"
        case .minYEdge: return "minYEdge"
        case .maxYEdge: return "maxYEdge"
        }
    }
}
