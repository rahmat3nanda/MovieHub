// swiftlint:disable force_unwrapping
// swiftlint:disable identifier_name
// swiftlint:disable line_length
// swiftlint:disable nesting

// The MIT License (MIT)
//
// Copyright (c) 2017-2022 Alexander Grebenyuk (github.com/kean).

import UIKit

public protocol LayoutItem {
    var superview: UIView? { get }
}

extension UIView: LayoutItem {
    @discardableResult
    public func height(_ value: CGFloat) -> Self {
        anchors.height.equal(value)
        return self
    }
}

extension UILayoutGuide: LayoutItem {
    public var superview: UIView? { owningView }
}

extension LayoutItem { // Align methods are available via `LayoutAnchors`
    @nonobjc public var anchors: LayoutAnchors<Self> { LayoutAnchors(self) }
}

// MARK: - LayoutAnchors

public struct LayoutAnchors<T: LayoutItem> {
    public let item: T

    public init(_ item: T) { self.item = item }

    // Deprecated in Align 3.0
    @available(*, deprecated, message: "Please use `view` to `layoutGuide`.")
    public var base: T { item }

    // MARK: Anchors

    public var top: Anchor<AnchorType.Edge, AnchorAxis.Vertical> { Anchor(item, .top) }
    public var bottom: Anchor<AnchorType.Edge, AnchorAxis.Vertical> { Anchor(item, .bottom) }
    public var left: Anchor<AnchorType.Edge, AnchorAxis.Horizontal> { Anchor(item, .left) }
    public var right: Anchor<AnchorType.Edge, AnchorAxis.Horizontal> { Anchor(item, .right) }
    public var leading: Anchor<AnchorType.Edge, AnchorAxis.Horizontal> { Anchor(item, .leading) }
    public var trailing: Anchor<AnchorType.Edge, AnchorAxis.Horizontal> { Anchor(item, .trailing) }

    public var centerX: Anchor<AnchorType.Center, AnchorAxis.Horizontal> { Anchor(item, .centerX) }
    public var centerY: Anchor<AnchorType.Center, AnchorAxis.Vertical> { Anchor(item, .centerY) }

    public var firstBaseline: Anchor<AnchorType.Baseline, AnchorAxis.Vertical> { Anchor(item, .firstBaseline) }
    public var lastBaseline: Anchor<AnchorType.Baseline, AnchorAxis.Vertical> { Anchor(item, .lastBaseline) }

    public var width: Anchor<AnchorType.Dimension, AnchorAxis.Horizontal> { Anchor(item, .width) }
    public var height: Anchor<AnchorType.Dimension, AnchorAxis.Vertical> { Anchor(item, .height) }

    // MARK: Anchor Collections

    public var edges: AnchorCollectionEdges { AnchorCollectionEdges(item: item) }
    public var center: AnchorCollectionCenter { AnchorCollectionCenter(x: centerX, y: centerY) }
    public var size: AnchorCollectionSize { AnchorCollectionSize(width: width, height: height) }
}

// MARK: - Anchors

public enum AnchorAxis {
    public class Horizontal {}
    public class Vertical {}
}

public enum AnchorType {
    public class Dimension {}
    public class Alignment {}
    public class Center: Alignment {}
    public class Edge: Alignment {}
    public class Baseline: Alignment {}
}

public struct Anchor<Type, Axis> { // type and axis are phantom types
    let item: LayoutItem
    let attribute: NSLayoutConstraint.Attribute
    let offset: CGFloat
    let multiplier: CGFloat

    init(_ item: LayoutItem, _ attribute: NSLayoutConstraint.Attribute, offset: CGFloat = 0, multiplier: CGFloat = 1) {
        self.item = item
        self.attribute = attribute
        self.offset = offset
        self.multiplier = multiplier
    }

    public func offsetting(by offset: CGFloat) -> Anchor {
        Anchor(item, attribute, offset: self.offset + offset, multiplier: self.multiplier)
    }

    public func multiplied(by multiplier: CGFloat) -> Anchor {
        Anchor(item, attribute, offset: self.offset * multiplier, multiplier: self.multiplier * multiplier)
    }
}

public func + <Type, Axis>(anchor: Anchor<Type, Axis>, offset: CGFloat) -> Anchor<Type, Axis> {
    anchor.offsetting(by: offset)
}

public func - <Type, Axis>(anchor: Anchor<Type, Axis>, offset: CGFloat) -> Anchor<Type, Axis> {
    anchor.offsetting(by: -offset)
}

public func * <Type, Axis>(anchor: Anchor<Type, Axis>, multiplier: CGFloat) -> Anchor<Type, Axis> {
    anchor.multiplied(by: multiplier)
}

// MARK: - Anchors (AnchorType.Alignment)

public extension Anchor where Type: AnchorType.Alignment {
    @discardableResult func equal<OtherType: AnchorType.Alignment>(_ anchor: Anchor<OtherType, Axis>, constant: CGFloat = 0) -> NSLayoutConstraint {
        Constraints.add(self, anchor, constant: constant, relation: .equal)
    }

    @discardableResult func greaterThanOrEqual<OtherType: AnchorType.Alignment>(_ anchor: Anchor<OtherType, Axis>, constant: CGFloat = 0) -> NSLayoutConstraint {
        Constraints.add(self, anchor, constant: constant, relation: .greaterThanOrEqual)
    }

    @discardableResult func lessThanOrEqual<OtherType: AnchorType.Alignment>(_ anchor: Anchor<OtherType, Axis>, constant: CGFloat = 0) -> NSLayoutConstraint {
        Constraints.add(self, anchor, constant: constant, relation: .lessThanOrEqual)
    }
}

// MARK: - Anchors (AnchorType.Dimension)

public extension Anchor where Type: AnchorType.Dimension {
    @discardableResult func equal<OtherType: AnchorType.Dimension, OtherAxis>(_ anchor: Anchor<OtherType, OtherAxis>, constant: CGFloat = 0) -> NSLayoutConstraint {
        Constraints.add(self, anchor, constant: constant, relation: .equal)
    }

    @discardableResult func greaterThanOrEqual<OtherType: AnchorType.Dimension, OtherAxis>(_ anchor: Anchor<OtherType, OtherAxis>, constant: CGFloat = 0) -> NSLayoutConstraint {
        Constraints.add(self, anchor, constant: constant, relation: .greaterThanOrEqual)
    }

    @discardableResult func lessThanOrEqual<OtherType: AnchorType.Dimension, OtherAxis>(_ anchor: Anchor<OtherType, OtherAxis>, constant: CGFloat = 0) -> NSLayoutConstraint {
        Constraints.add(self, anchor, constant: constant, relation: .lessThanOrEqual)
    }
}

// MARK: - Anchors (AnchorType.Dimension)

public extension Anchor where Type: AnchorType.Dimension {
    @discardableResult func equal(_ constant: CGFloat) -> NSLayoutConstraint {
        Constraints.add(item: item, attribute: attribute, relatedBy: .equal, constant: constant)
    }

    @discardableResult func greaterThanOrEqual(_ constant: CGFloat) -> NSLayoutConstraint {
        Constraints.add(item: item, attribute: attribute, relatedBy: .greaterThanOrEqual, constant: constant)
    }

    @discardableResult func lessThanOrEqual(_ constant: CGFloat) -> NSLayoutConstraint {
        Constraints.add(item: item, attribute: attribute, relatedBy: .lessThanOrEqual, constant: constant)
    }

    @discardableResult func clamp(to limits: ClosedRange<CGFloat>) -> [NSLayoutConstraint] {
        [greaterThanOrEqual(limits.lowerBound), lessThanOrEqual(limits.upperBound)]
    }
}

// MARK: - Anchors (AnchorType.Edge)

public extension Anchor where Type: AnchorType.Edge {
    @discardableResult func pin(to container: LayoutItem? = nil, inset: CGFloat = 0) -> NSLayoutConstraint {
        let isInverted = [.trailing, .right, .bottom].contains(attribute)
        return Constraints.add(self, toItem: container ?? item.superview!, attribute: attribute, constant: (isInverted ? -inset : inset))
    }

    @discardableResult func spacing<OtherType: AnchorType.Edge>(_ spacing: CGFloat, to anchor: Anchor<OtherType, Axis>, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let isInverted = (attribute == .bottom && anchor.attribute == .top) ||
            (attribute == .right && anchor.attribute == .left) ||
            (attribute == .trailing && anchor.attribute == .leading)
        return Constraints.add(self, anchor, constant: isInverted ? -spacing : spacing, relation: isInverted ? relation.inverted : relation)
    }
}

// MARK: - Anchors (AnchorType.Center)

public extension Anchor where Type: AnchorType.Center {
    @discardableResult func align(offset: CGFloat = 0) -> NSLayoutConstraint {
        Constraints.add(self, toItem: item.superview!, attribute: attribute, constant: offset)
    }
}

// MARK: - AnchorCollectionEdges

public struct AnchorCollectionEdges {
    let item: LayoutItem
    var isAbsolute = false

    public func absolute() -> AnchorCollectionEdges {
        AnchorCollectionEdges(item: item, isAbsolute: true)
    }

    public typealias Axis = NSLayoutConstraint.Axis

    // MARK: Core API

    @discardableResult public func equal(_ item2: LayoutItem, insets: EdgeInsets = .zero) -> [NSLayoutConstraint] {
        pin(to: item2, insets: insets)
    }

    @discardableResult public func lessThanOrEqual(_ item2: LayoutItem, insets: EdgeInsets = .zero) -> [NSLayoutConstraint] {
        pin(to: item2, insets: insets, axis: nil, alignment: .center, isCenteringEnabled: false)
    }

    @discardableResult public func equal(_ item2: LayoutItem, insets: CGFloat) -> [NSLayoutConstraint] {
        pin(to: item2, insets: EdgeInsets(top: insets, left: insets, bottom: insets, right: insets))
    }

    @discardableResult public func lessThanOrEqual(_ item2: LayoutItem, insets: CGFloat) -> [NSLayoutConstraint] {
        pin(to: item2, insets: EdgeInsets(top: insets, left: insets, bottom: insets, right: insets), axis: nil, alignment: .center, isCenteringEnabled: false)
    }

    // MARK: Semantic API

    @discardableResult public func pin(to item2: LayoutItem? = nil, insets: CGFloat, axis: Axis? = nil, alignment: Alignment = .fill) -> [NSLayoutConstraint] {
        pin(to: item2, insets: EdgeInsets(top: insets, left: insets, bottom: insets, right: insets), axis: axis, alignment: alignment)
    }

    @discardableResult public func pin(to item2: LayoutItem? = nil, insets: EdgeInsets = .zero, axis: Axis? = nil, alignment: Alignment = .fill) -> [NSLayoutConstraint] {
        pin(to: item2, insets: insets, axis: axis, alignment: alignment, isCenteringEnabled: true)
    }

    private func pin(to item2: LayoutItem?, insets: EdgeInsets, axis: Axis?, alignment: Alignment, isCenteringEnabled: Bool) -> [NSLayoutConstraint] {
        let item2 = item2 ?? item.superview!
        let left: NSLayoutConstraint.Attribute = isAbsolute ? .left : .leading
        let right: NSLayoutConstraint.Attribute = isAbsolute ? .right : .trailing
        var constraints = [NSLayoutConstraint]()

        func constrain(attribute: NSLayoutConstraint.Attribute, relation: NSLayoutConstraint.Relation, constant: CGFloat) {
            constraints.append(Constraints.add(item: item, attribute: attribute, relatedBy: relation, toItem: item2, attribute: attribute, multiplier: 1, constant: constant))
        }

        if axis == nil || axis == .horizontal {
            constrain(attribute: left, relation: alignment.horizontal == .fill || alignment.horizontal == .leading ? .equal : .greaterThanOrEqual, constant: insets.left)
            constrain(attribute: right, relation: alignment.horizontal == .fill || alignment.horizontal == .trailing ? .equal : .lessThanOrEqual, constant: -insets.right)
            if alignment.horizontal == .center && isCenteringEnabled {
                constrain(attribute: .centerX, relation: .equal, constant: 0)
            }
        }
        if axis == nil || axis == .vertical {
            constrain(attribute: .top, relation: alignment.vertical == .fill || alignment.vertical == .top ? .equal : .greaterThanOrEqual, constant: insets.top)
            constrain(attribute: .bottom, relation: alignment.vertical == .fill || alignment.vertical == .bottom ? .equal : .lessThanOrEqual, constant: -insets.bottom)
            if alignment.vertical == .center && isCenteringEnabled {
                constrain(attribute: .centerY, relation: .equal, constant: 0)
            }
        }
        return constraints
    }

    public struct Alignment {

        public enum Horizontal {
            case fill
            case center
            case leading
            case trailing
        }

        public enum Vertical {
            case fill
            case center
            case top
            case bottom
        }
        public let horizontal: Horizontal
        public let vertical: Vertical

        public init(horizontal: Horizontal, vertical: Vertical) {
            (self.horizontal, self.vertical) = (horizontal, vertical)
        }

        public static let fill = Alignment(horizontal: .fill, vertical: .fill)
        public static let center = Alignment(horizontal: .center, vertical: .center)
        public static let topLeading = Alignment(horizontal: .leading, vertical: .top)
        public static let top = Alignment(horizontal: .center, vertical: .top)
        public static let topTrailing = Alignment(horizontal: .trailing, vertical: .top)
        public static let trailing = Alignment(horizontal: .trailing, vertical: .center)
        public static let bottomTrailing = Alignment(horizontal: .trailing, vertical: .bottom)
        public static let bottom = Alignment(horizontal: .center, vertical: .bottom)
        public static let bottomLeading = Alignment(horizontal: .leading, vertical: .bottom)
        public static let leading = Alignment(horizontal: .leading, vertical: .center)
    }
}

// MARK: - AnchorCollectionCenter

public struct AnchorCollectionCenter {
    let x: Anchor<AnchorType.Center, AnchorAxis.Horizontal>
    let y: Anchor<AnchorType.Center, AnchorAxis.Vertical>

    // MARK: Core API

    @discardableResult public func equal<Item: LayoutItem>(_ item2: Item, offset: CGPoint = .zero) -> [NSLayoutConstraint] {
        [x.equal(item2.anchors.centerX, constant: offset.x), y.equal(item2.anchors.centerY, constant: offset.y)]
    }

    @discardableResult public func greaterThanOrEqual<Item: LayoutItem>(_ item2: Item, offset: CGPoint = .zero) -> [NSLayoutConstraint] {
        [x.greaterThanOrEqual(item2.anchors.centerX, constant: offset.x), y.greaterThanOrEqual(item2.anchors.centerY, constant: offset.y)]
    }

    @discardableResult public func lessThanOrEqual<Item: LayoutItem>(_ item2: Item, offset: CGPoint = .zero) -> [NSLayoutConstraint] {
        [x.lessThanOrEqual(item2.anchors.centerX, constant: offset.x), y.lessThanOrEqual(item2.anchors.centerY, constant: offset.y)]
    }

    // MARK: Semantic API

    @discardableResult public func align() -> [NSLayoutConstraint] {
        [x.align(), y.align()]
    }

    @discardableResult public func align<Item: LayoutItem>(with item: Item) -> [NSLayoutConstraint] {
        [x.equal(item.anchors.centerX), y.equal(item.anchors.centerY)]
    }
}

// MARK: - AnchorCollectionSize

public struct AnchorCollectionSize {
    let width: Anchor<AnchorType.Dimension, AnchorAxis.Horizontal>
    let height: Anchor<AnchorType.Dimension, AnchorAxis.Vertical>

    // MARK: Core API

    @discardableResult public func equal(_ size: CGSize) -> [NSLayoutConstraint] {
        [width.equal(size.width), height.equal(size.height)]
    }

    @discardableResult public func greaterThanOrEqul(_ size: CGSize) -> [NSLayoutConstraint] {
        [width.greaterThanOrEqual(size.width), height.greaterThanOrEqual(size.height)]
    }

    @discardableResult public func lessThanOrEqual(_ size: CGSize) -> [NSLayoutConstraint] {
        [width.lessThanOrEqual(size.width), height.lessThanOrEqual(size.height)]
    }

    @discardableResult public func equal<Item: LayoutItem>(_ item: Item, insets: CGSize = .zero, multiplier: CGFloat = 1) -> [NSLayoutConstraint] {
        [width.equal(item.anchors.width * multiplier - insets.width), height.equal(item.anchors.height * multiplier - insets.height)]
    }

    @discardableResult public func greaterThanOrEqual<Item: LayoutItem>(_ item: Item, insets: CGSize = .zero, multiplier: CGFloat = 1) -> [NSLayoutConstraint] {
        [width.greaterThanOrEqual(item.anchors.width * multiplier - insets.width), height.greaterThanOrEqual(item.anchors.height * multiplier - insets.height)]
    }

    @discardableResult public func lessThanOrEqual<Item: LayoutItem>(_ item: Item, insets: CGSize = .zero, multiplier: CGFloat = 1) -> [NSLayoutConstraint] {
        [width.lessThanOrEqual(item.anchors.width * multiplier - insets.width), height.lessThanOrEqual(item.anchors.height * multiplier - insets.height)]
    }
}

// MARK: - Constraints

public final class Constraints: Collection {
    public typealias Element = NSLayoutConstraint
    public typealias Index = Int

    public subscript(position: Int) -> NSLayoutConstraint {
        constraints[position]
    }
    public var startIndex: Int { constraints.startIndex }
    public var endIndex: Int { constraints.endIndex }
    public func index(after i: Int) -> Int { i + 1 }

    public private(set) var constraints = [NSLayoutConstraint]()

    @discardableResult public init(activate: Bool = true, _ closure: () -> Void) {
        Constraints.stack.append(self)
        closure() // create constraints
        Constraints.stack.removeLast()
        if activate { NSLayoutConstraint.activate(constraints) }
    }

    // MARK: Activate

    public func activate() {
        NSLayoutConstraint.activate(constraints)
    }

    public func deactivate() {
        NSLayoutConstraint.deactivate(constraints)
    }

    // MARK: Adding Constraints

    static func add(item item1: Any, attribute attr1: NSLayoutConstraint.Attribute, relatedBy relation: NSLayoutConstraint.Relation = .equal, toItem item2: Any? = nil, attribute attr2: NSLayoutConstraint.Attribute? = nil, multiplier: CGFloat = 1, constant: CGFloat = 0) -> NSLayoutConstraint {
        precondition(Thread.isMainThread, "Align APIs can only be used from the main thread")
        (item1 as? UIView)?.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: item1, attribute: attr1, relatedBy: relation, toItem: item2, attribute: attr2 ?? .notAnAttribute, multiplier: multiplier, constant: constant)
        install(constraint)
        return constraint
    }

    static func add<T1, A1, T2, A2>(_ lhs: Anchor<T1, A1>, _ rhs: Anchor<T2, A2>, constant: CGFloat = 0, multiplier: CGFloat = 1, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        add(item: lhs.item, attribute: lhs.attribute, relatedBy: relation, toItem: rhs.item, attribute: rhs.attribute, multiplier: (multiplier / lhs.multiplier) * rhs.multiplier, constant: constant - lhs.offset + rhs.offset)
    }

    static func add<T1, A1>(_ lhs: Anchor<T1, A1>, toItem item2: Any?, attribute attr2: NSLayoutConstraint.Attribute?, constant: CGFloat = 0, multiplier: CGFloat = 1, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        add(item: lhs.item, attribute: lhs.attribute, relatedBy: relation, toItem: item2, attribute: attr2, multiplier: multiplier / lhs.multiplier, constant: constant - lhs.offset)
    }

    private static var stack = [Constraints]() // this is what enabled constraint auto-installing

    private static func install(_ constraint: NSLayoutConstraint) {
        if let group = stack.last {
            group.constraints.append(constraint)
        } else {
            constraint.isActive = true
        }
    }
}

public extension Constraints {
    @discardableResult convenience init<A: LayoutItem>(for a: A, _ closure: (LayoutAnchors<A>) -> Void) {
        self.init { closure(a.anchors) }
    }

    @discardableResult convenience init<A: LayoutItem, B: LayoutItem>(for a: A, _ b: B, _ closure: (LayoutAnchors<A>, LayoutAnchors<B>) -> Void) {
        self.init { closure(a.anchors, b.anchors) }
    }

    @discardableResult convenience init<A: LayoutItem, B: LayoutItem, C: LayoutItem>(for a: A, _ b: B, _ c: C, _ closure: (LayoutAnchors<A>, LayoutAnchors<B>, LayoutAnchors<C>) -> Void) {
        self.init { closure(a.anchors, b.anchors, c.anchors) }
    }

    @discardableResult convenience init<A: LayoutItem, B: LayoutItem, C: LayoutItem, D: LayoutItem>(for a: A, _ b: B, _ c: C, _ d: D, _ closure: (LayoutAnchors<A>, LayoutAnchors<B>, LayoutAnchors<C>, LayoutAnchors<D>) -> Void) {
        self.init { closure(a.anchors, b.anchors, c.anchors, d.anchors) }
    }
}

// MARK: - Misc

public typealias EdgeInsets = UIEdgeInsets
extension NSLayoutConstraint.Relation {
    var inverted: NSLayoutConstraint.Relation {
        switch self {
        case .greaterThanOrEqual: return .lessThanOrEqual
        case .lessThanOrEqual: return .greaterThanOrEqual
        case .equal: return self
        @unknown default: return self
        }
    }
}

extension EdgeInsets {
    func inset(for attribute: NSLayoutConstraint.Attribute, edge: Bool = false) -> CGFloat {
        switch attribute {
        case .top:
            return top
        case .bottom:
            return edge ? -bottom : bottom
        case .left, .leading:
            return left
        case .right, .trailing:
            return edge ? -right : right
        default:
            return 0
        }
    }
}

// swiftlint:enable force_unwrapping
// swiftlint:enable identifier_name
// swiftlint:enable line_length
// swiftlint:enable nesting
