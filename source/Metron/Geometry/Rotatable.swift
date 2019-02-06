public enum RotationDirection {
    case clockwise, counterClockwise
}

/**
 *  A `Rotatable` is an entity that can be iterated over
 *  in a rotating manner (clockwise or counter-clockwise),
 *  such as corners or edges.
 */
public protocol Rotatable : Opposable {
    
    static func all(startingAt: Self, rotating: RotationDirection) -> [Self]
    
    func next(rotating: RotationDirection) -> Self
    func previous(rotating: RotationDirection) -> Self
}

public extension Rotatable where Self: Equatable {
    
    /// - returns: The next element rotated in the provided direction.
    public func next(rotating: RotationDirection) -> Self {
        let allInDirection = (rotating == .clockwise) ? Self.all : Self.all.reversed()
        let nextIndex = (allInDirection.index(of: self)! + 1) % allInDirection.count
        return allInDirection[nextIndex]
    }
    
    /// - returns: The previous element rotated in the provided direction.
    public func previous(rotating: RotationDirection) -> Self {
        return next(rotating: rotating).opposite
    }
    
    /// - returns: All elements starting and in rotating order as provided.
    public static func all(startingAt start: Self,
                           rotating: RotationDirection = .clockwise) -> [Self] {
        var arrangedAll: [Self] = Self.all
        arrangedAll = rotating == .clockwise ? arrangedAll : arrangedAll.reversed()
        while arrangedAll[0] != start {
            arrangedAll.append(arrangedAll.remove(at: 0))
        }
        return arrangedAll
    }
}
