import CoreGraphics

/**
 *  A `CoordinateSystem` is a simple description of a two-dimensional space,
 *  defined by its origin (the visual corner in which the origin {0, 0}
 *  is found. On iOS this defaults to top / left, while on macOS this is
 *  bottom / left.
 *  The `CoordinateSystem` is used to translate from visual positions
 *  (top, right, bottom, left) to coordinate positions (minY, maxX, maxY, minX).
 */
public struct CoordinateSystem {
    
    #if os(macOS)
    public static let `default` = CoordinateSystem(origin: .bottomLeft)
    #elseif os(iOS) || os(watchOS) || os(tvOS)
    public static let `default` = CoordinateSystem(origin: .topLeft)
    #endif
    
    public var origin: CornerPosition
    
    public init(origin: CornerPosition) {
        self.origin = origin
    }
}

public extension CoordinateSystem {

    // MARK: Corners
    
    /**
     *  Returns the `Corners` matching the `CornerPositions` in this
     *  coordinate system, running clockwise starting at topLeft.
     */
    public var corners: [Corner] {
        return CornerPosition.all.map { corner(for: $0) }
    }
    
    /**
     *  Returns the `Corners` matching the `CornerPositions` in this
     *  coordinate system, starting and in rotating order as
     *  provided.
     */
    public func corners(startingAt start: Corner,
             rotating: RotationDirection = .clockwise) -> [Corner] {
        var arrangedCorners: [Corner] = corners
        arrangedCorners = rotating == .clockwise ? arrangedCorners : arrangedCorners.reversed()
        while arrangedCorners[0] != start {
            arrangedCorners.append(arrangedCorners.remove(at: 0))
        }
        return arrangedCorners
    }
    
    /// - returns: The `CornerPosition` of the `Corner` in this CoordinateSystem.
    public func position(for corner: Corner) -> CornerPosition {
        let tlsCorner: CornerPosition   //  topLeft system corner
        switch corner {
        case .minXminY: tlsCorner = .topLeft
        case .maxXminY: tlsCorner = .topRight
        case .minXmaxY: tlsCorner = .bottomLeft
        case .maxXmaxY: tlsCorner = .bottomRight
        }
        switch origin {
        case .topLeft: return tlsCorner
        case .topRight: return tlsCorner.opposite(on: .xAxis)
        case .bottomLeft: return tlsCorner.opposite(on: .yAxis)
        case .bottomRight: return tlsCorner.opposite
        }
    }
    
    /// - returns: The `Corner` at the `CornerPosition` in this CoordinateSystem.
    public func corner(for position: CornerPosition) -> Corner {
        let tlsPosition: Corner   //  topLeft system position
        switch position {
        case .topLeft: tlsPosition = .minXminY
        case .topRight: tlsPosition = .maxXminY
        case .bottomLeft: tlsPosition = .minXmaxY
        case .bottomRight: tlsPosition = .maxXmaxY
        }
        switch origin {
        case .topLeft: return tlsPosition
        case .topRight: return tlsPosition.opposite(on: .xAxis)
        case .bottomLeft: return tlsPosition.opposite(on: .yAxis)
        case .bottomRight: return tlsPosition.opposite
        }
    }
    
    // MARK: Edges
    
    /**
     *  Returns the `CGRectEdges` matching the `Sides` in this
     *  coordinate system, running clockwise starting at top.
     */
    public var edges: [CGRectEdge] {
        return Side.all.map { edge(for: $0) }
    }
    
    /**
     *  Returns the `CGRectEdges` matching the `Sides` in this
     *  coordinate system, starting and in rotating order as
     *  provided.
     */
    public func edges(startingAt start: CGRectEdge,
                        rotating: RotationDirection = .clockwise) -> [CGRectEdge] {
        var arrangedEdges: [CGRectEdge] = edges
        arrangedEdges = rotating == .clockwise ? arrangedEdges : arrangedEdges.reversed()
        while arrangedEdges[0] != start {
            arrangedEdges.append(arrangedEdges.remove(at: 0))
        }
        return arrangedEdges
    }
    
    /// - returns: The `Side` of the `CGRectEdge` in this CoordinateSystem
    public func side(for edge: CGRectEdge) -> Side {
        let tlsSide: Side   //  topLeft system side
        switch edge {
        case .minXEdge: tlsSide = .left
        case .maxXEdge: tlsSide = .right
        case .minYEdge: tlsSide = .top
        case .maxYEdge: tlsSide = .bottom
        }
        switch origin {
        case .topLeft: return tlsSide
        case .topRight: return tlsSide.axis == .xAxis ? tlsSide.opposite : tlsSide
        case .bottomLeft: return tlsSide.axis == .yAxis ? tlsSide.opposite : tlsSide
        case .bottomRight: return tlsSide.opposite
        }
    }
    
    /// - returns: The `CGRectEdge` at the `Side` in this CoordinateSystem
    public func edge(for side: Side) -> CGRectEdge {
        let tlsEdge: CGRectEdge   //  topLeft system edge
        switch side {
        case .top: tlsEdge = .minYEdge
        case .right: tlsEdge = .maxXEdge
        case .bottom: tlsEdge = .maxYEdge
        case .left: tlsEdge = .minXEdge
        }
        switch origin {
        case .topLeft: return tlsEdge
        case .topRight: return tlsEdge.axis == .xAxis ? tlsEdge.opposite : tlsEdge
        case .bottomLeft: return tlsEdge.axis == .yAxis ? tlsEdge.opposite : tlsEdge
        case .bottomRight: return tlsEdge.opposite
        }
    }
    
    /// - returns: True if a circle, traced by incrementing an angle, runs clockwise
    public var circleRunsClockwise: Bool {
        switch origin {
        case .topLeft, .bottomRight: return true
        case .bottomLeft, .topRight: return false
        }
    }
}

// MARK: CustomDebugStringConvertible

extension CoordinateSystem : CustomDebugStringConvertible {
    public var debugDescription: String {
        return "CoordinateSystem {origin: \(origin)}"
    }
}
