/**
 *  A corner represents a place where two edges meet.
 */
public protocol CornerType {
    associatedtype EdgesType
    
    var edges: (EdgesType, EdgesType) { get }
}
