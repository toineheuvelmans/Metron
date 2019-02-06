/**
 *  A `Side` represents the visual concept of edges
 *  (i.e. top, right, bottom, left).
 */
public enum Side {
    case top, right, bottom, left
}

extension Side : Rotatable {
    public static var allOpposites: [(Side, Side)] {
        return [(.top, .bottom), (.right, .left)]
    }
}

extension Side : EdgeType {
    
    public typealias CornerType = CornerPosition
    
    public var corners: (CornerType, CornerType) {
        switch self {
        case .top: return (.topLeft, .topRight)
        case .right: return (.topRight, .bottomRight)
        case .bottom: return (.bottomLeft, .bottomRight)
        case .left: return (.topLeft, .bottomLeft)
        }
    }
    
    public var axis: Axis {
        switch self {
        case .left, .right: return .xAxis
        case .top, .bottom: return .yAxis
        }
    }
}
