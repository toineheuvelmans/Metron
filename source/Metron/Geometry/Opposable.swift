/**
 *  Opposable relates to anything that spatially
 *  has an opposite, such as corners and edges.
 */
public protocol Opposable {
    
    /// An `Opposable` should return each unique pair
    /// of opposites, such as [(top, bottom), (right, left)].
    /// The order in which these are returned determines
    /// the order of `all`; each pair will be interleaved,
    /// so the above example will result in
    /// `all`: [top, right, bottom, left].
    static var allOpposites: [(Self, Self)] { get }
    
    /// - returns: All possible values for this opposable.
    /// You do not have to implement this because it is
    /// derived from `allOpposites`.
    static var all: [Self] { get }
    
    /// - returns: The opposite value for `self`.
    /// This is automatically derived from `Self.allOpposites`.
    var opposite: Self { get }
}

public extension Opposable where Self: Equatable {
    
    public static var all: [Self] {
        return allOpposites.map { $0.0 } + allOpposites.map { $0.1 }
    }
    
    public var opposite: Self {
        let allOpposites = Self.allOpposites
        for (lhs, rhs) in allOpposites {
            if self == lhs {
                return rhs
            } else if self == rhs {
                return lhs
            }
        }
        return self
    }
    
}
