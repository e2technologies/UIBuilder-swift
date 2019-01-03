//
//  UIBuilderConstraint.swift
//  UIBuilder
//
//  Created by Eric Chapman on 1/1/19.
//

import Foundation

public class UIBuilderConstraint {
    var params = [String:Any]()
    private var editingFrom = true
    
    func setup(view: UIView) { view.translatesAutoresizingMaskIntoConstraints = false }
    
    let parentKey = "parent"
    let fromKey = "from"
    let fromAttrKey = "from_attr"
    let toKey = "to"
    let toAttrKey = "to_attr"
    let multiplierKey = "multiplier"
    let relationKey = "relation"
    let constantKey = "constant"
    
    var parent: UIView { return self.params[parentKey] as! UIView }
    var from: UIView { return self.params[fromKey] as! UIView }
    var fromAttribute: NSLayoutConstraint.Attribute { return self.params[fromAttrKey] as! NSLayoutConstraint.Attribute }
    var to: UIView? { return self.params[toKey] as? UIView }
    var toAttribute: NSLayoutConstraint.Attribute { return self.params[toAttrKey] as? NSLayoutConstraint.Attribute ?? .notAnAttribute }
    var relation: NSLayoutConstraint.Relation { return self.params[relationKey] as? NSLayoutConstraint.Relation ?? .equal }
    var multiplier: CGFloat { return self.params[multiplierKey] as? CGFloat ?? 1 }
    var constant: CGFloat { return self.params[constantKey] as? CGFloat ?? 0 }
    
    // ----------------------------------------------------------------------------------
    // MARK: initialization
    // ----------------------------------------------------------------------------------
    
    public init(_ parent: UIView) {
        self.setup(view: parent)
        self.attr(parentKey, value: parent)
        self.attr(fromKey, value: parent)
    }
    
    // ----------------------------------------------------------------------------------
    // MARK: Standard Methods
    // ----------------------------------------------------------------------------------
    
    @discardableResult
    public func attr(_ name: String, value: Any) -> Self {
        self.params[name] = value
        return self
    }
    
    public func from(_ from: UIView) -> Self { self.editingFrom = true; self.setup(view: from); return self.attr(fromKey, value: from) }
    public func to(_ to: UIView) -> Self { self.editingFrom = false; self.setup(view: to); return self.attr(toKey, value: to) }
    public func attribute(_ attribute: NSLayoutConstraint.Attribute) -> Self { return self.attr((self.editingFrom ? fromAttrKey : toAttrKey), value: attribute) }
    public func relation(_ relation: NSLayoutConstraint.Relation) -> Self { return self.attr(relationKey, value: relation) }
    public func multiplier(_ multiplier: CGFloat) -> Self { return self.attr(multiplierKey, value: multiplier) }
    public func constant(_ constant: CGFloat) -> Self { return self.attr(constantKey, value: constant) }

    // ----------------------------------------------------------------------------------
    // MARK: Build Method
    // ----------------------------------------------------------------------------------
    
    /**
     See if a constraint already exists that matches the criteria
     */
    public func find() -> NSLayoutConstraint? {
        for constraint in parent.constraints {
            if constraint.firstItem === from && constraint.firstAttribute == fromAttribute &&
                constraint.secondItem === to && constraint.secondAttribute == toAttribute &&
                constraint.relation == relation && constraint.multiplier == multiplier {
                return constraint
            }
        }
        
        return nil
    }
    
    /**
     Creates the constraint
     */
    @discardableResult
    public func build(update: Bool=false) -> NSLayoutConstraint {

        // If update is set, search for an existing one and update it.
        // Else create a new one
        if update, let constant = self.update(constant: constant) {
            return constant
        }
        else {
            let constraint = NSLayoutConstraint(
                item: from, attribute: fromAttribute, relatedBy: relation,
                toItem: to, attribute: toAttribute,
                multiplier: multiplier, constant: constant)
            parent.addConstraint(constraint)
            return constraint
        }
    }
    
    /**
     Updates the constraint if it exists and returns it
     */
    @discardableResult
    public func update(constant: CGFloat) -> NSLayoutConstraint? {
        if let constraint = self.find() {
            if constraint.constant != constant {
                constraint.constant = constant
                parent.layoutIfNeeded()
            }
            return constraint
        }
        return nil
    }
    
    // ----------------------------------------------------------------------------------
    // MARK: Helper Methods
    // ----------------------------------------------------------------------------------
    
    /** Creates a width constraint */
    public func width(_ width: CGFloat) -> Self { return self.attribute(.width).constant(width) }
    
    /** Creates a height constraint */
    public func height(_ height: CGFloat) -> Self { return self.attribute(.height).constant(height) }
    
    /** Locks the left edge of the view to the parents left edge */
    public func leftEdges(_ view: UIView, innerSpacing: CGFloat=0, useMargin: Bool=true) -> Self { return self.attribute(useMargin ? .leftMargin : .left).to(view).attribute(.left).constant(-innerSpacing) }
    
    /** Locks the right edge of the view to the parents right edge */
    public func rightEdges(_ view: UIView, innerSpacing: CGFloat=0, useMargin: Bool=true) -> Self { return self.attribute(useMargin ? .rightMargin : .right).to(view).attribute(.right).constant(innerSpacing) }
    
    /** Locks the top edge of the view to the parents top edge */
    public func topEdges(_ view: UIView, innerSpacing: CGFloat=0, useMargin: Bool=true) -> Self { return self.attribute(useMargin ? .topMargin : .top).to(view).attribute(.top).constant(-innerSpacing) }
    
    /** Locks the bottom edge of the view to the parents bottom edge */
    public func bottomEdges(_ view: UIView, innerSpacing: CGFloat=0, useMargin: Bool=true) -> Self { return self.attribute(useMargin ? .bottomMargin : .bottom).to(view).attribute(.bottom).constant(innerSpacing) }
    
    /** Locks the horizontal center to the parents horizontal center */
    public func centerX(_ view: UIView, offset: CGFloat=0) -> Self { return self.attribute(.centerX).to(view).attribute(.centerX).constant(offset) }
    
    /** Locks the vertical center to the parents vertical center */
    public func centerY(_ view: UIView, offset: CGFloat=0) -> Self { return self.attribute(.centerY).to(view).attribute(.centerY).constant(offset) }
    
    /** Locks the views left side to the horizontal center of the parent */
    public func rightOfCenter(_ view: UIView, rightSpacing: CGFloat=0) -> Self { return self.attribute(.centerX).to(view).attribute(.left).constant(rightSpacing) }
    
    /** Locks the views right side to the horizontal center of the parent */
    public func leftOfCenter(_ view: UIView, leftSpacing: CGFloat=0) -> Self { return self.attribute(.centerX).to(view).attribute(.right).constant(-leftSpacing) }
    
    /** Locks the views bottom side to the vertical center of the parent */
    public func aboveCenter(_ view: UIView, topSpacing: CGFloat=0) -> Self { return self.attribute(.centerY).to(view).attribute(.bottom).constant(-topSpacing) }
    
    /** Locks the views top side to the vertical center of the parent */
    public func belowCenter(_ view: UIView, bottomSpacing: CGFloat=0) -> Self { return self.attribute(.centerY).to(view).attribute(.top).constant(bottomSpacing) }
    
    /** Locks the right side of the left view to the left side of the right view (side by side) */
    public func leftRight(leftView: UIView, rightView: UIView, betweenSpacing: CGFloat=0) -> Self { return self.from(leftView).attribute(.right).to(rightView).attribute(.left).constant(-betweenSpacing) }
    
    /** Locks the bottom of the top view to the top of the bottom view (above/below) */
    public func topBottom(topView: UIView, bottomView: UIView, betweenSpacing: CGFloat=0) -> Self { return self.from(topView).attribute(.bottom).to(bottomView).attribute(.top).constant(-betweenSpacing) }
}

public extension UIView {
    
    /**
     Returns a new "constraint" object that can be used to build a constraint
     
     - Returns: The new config object
     */
    var constrain: UIBuilderConstraint {
        return UIBuilderConstraint(self)
    }
    
    /**
     Sets the size of the view (width and height)
     
     - Parameter size: The size of the view
     */
    func constrainSize(_ size: CGSize) {
        self.constrain.width(size.width).build()
        self.constrain.height(size.height).build()
    }
    
    /**
     Centers the view inside of this view.  Note that you must set the
     height and width parameters independently
     
     - Parameter view: The view to center
     - Parameter offsetX: The distance from center in the X direction (default: 0)
     - Parameter offsetY: The distance from center in the Y direction (default: 0)
     */
    func constrainCenter(_ view: UIView, offsetX: CGFloat=0, offsetY: CGFloat=0) {
        self.constrain.centerX(view, offset: offsetX).build()
        self.constrain.centerY(view, offset: offsetY).build()
    }
    
    /**
     Set the view to be left side, centered vertically.  Note that you must set the
     height and width parameters independently
     
     - Parameter view: The view to center
     - Parameter innerSpacing: The distance between the outer view and the inner view (default: 0)
     - Parameter useMargin: Boolean specifying if they should lock to the margin
     */
    func constrainLeftCenter(_ view: UIView, innerSpacing: CGFloat=0, useMargin: Bool=true) {
        self.constrain.leftEdges(view, innerSpacing: innerSpacing, useMargin: useMargin).build()
        self.constrain.centerY(view).build()
    }
    
    /**
     Set the view to be right side, centered vertically.  Note that you must set the
     height and width parameters independently
     
     - Parameter view: The view to center
     - Parameter innerSpacing: The distance between the outer view and the inner view (default: 0)
     - Parameter useMargin: Boolean specifying if they should lock to the margin
     */
    func constrainRightCenter(_ view: UIView, innerSpacing: CGFloat=0, useMargin: Bool=true) {
        self.constrain.rightEdges(view, innerSpacing: innerSpacing, useMargin: useMargin).build()
        self.constrain.centerY(view).build()
    }
    
    /**
     Set the view to be at the top, centered hoerizontally.  Note that you must set the
     height and width parameters independently
     
     - Parameter view: The view to center
     - Parameter innerSpacing: The distance between the outer view and the inner view (default: 0)
     - Parameter useMargin: Boolean specifying if they should lock to the margin
     */
    func constrainTopCenter(_ view: UIView, innerSpacing: CGFloat=0, useMargin: Bool=true) {
        self.constrain.topEdges(view, innerSpacing: innerSpacing, useMargin: useMargin).build()
        self.constrain.centerX(view).build()
    }
    
    /**
     Set the view to be at the bottom, centered hoerizontally.  Note that you must set the
     height and width parameters independently
     
     - Parameter view: The view to center
     - Parameter innerSpacing: The distance between the outer view and the inner view (default: 0)
     - Parameter useMargin: Boolean specifying if they should lock to the margin
     */
    func constrainBottomCenter(_ view: UIView, innerSpacing: CGFloat=0, useMargin: Bool=true) {
        self.constrain.bottomEdges(view, innerSpacing: innerSpacing, useMargin: useMargin).build()
        self.constrain.centerX(view).build()
    }
    
    /**
     Set the view to be the top/left side.  Note that you must set the height and width
     parameters independently
     
     - Parameter view: The view to place
     - Parameter innerSpacing: The distance between the outer view and the inner view (default: 0)
     - Parameter useMargin: Boolean specifying if they should lock to the margin
     */
    func constrainTopLeft(_ view: UIView, innerSpacing: CGFloat=0, useMargin: Bool=true) {
        self.constrain.leftEdges(view, innerSpacing: innerSpacing, useMargin: useMargin).build()
        self.constrain.topEdges(view, innerSpacing: innerSpacing, useMargin: useMargin).build()
    }
    
    /**
     Set the view to be the top/right side.  Note that you must set the height and width
     parameters independently
     
     - Parameter view: The view to place
     - Parameter innerSpacing: The distance between the outer view and the inner view (default: 0)
     - Parameter useMargin: Boolean specifying if they should lock to the margin
     */
    func constrainTopRight(_ view: UIView, innerSpacing: CGFloat=0, useMargin: Bool=true) {
        self.constrain.rightEdges(view, innerSpacing: innerSpacing, useMargin: useMargin).build()
        self.constrain.topEdges(view, innerSpacing: innerSpacing, useMargin: useMargin).build()
    }
    
    /**
     Set the view to be the bottom/left side.  Note that you must set the height and width
     parameters independently
     
     - Parameter view: The view to place
     - Parameter innerSpacing: The distance between the outer view and the inner view (default: 0)
     - Parameter useMargin: Boolean specifying if they should lock to the margin
     */
    func constrainBottomLeft(_ view: UIView, innerSpacing: CGFloat=0, useMargin: Bool=true) {
        self.constrain.leftEdges(view, innerSpacing: innerSpacing, useMargin: useMargin).build()
        self.constrain.bottomEdges(view, innerSpacing: innerSpacing, useMargin: useMargin).build()
    }
    
    /**
     Set the view to be the top/right side.  Note that you must set the height and width
     parameters independently
     
     - Parameter view: The view to place
     - Parameter innerSpacing: The distance between the outer view and the inner view (default: 0)
     - Parameter useMargin: Boolean specifying if they should lock to the margin
     */
    func constrainBottomRight(_ view: UIView, innerSpacing: CGFloat=0, useMargin: Bool=true) {
        self.constrain.rightEdges(view, innerSpacing: innerSpacing, useMargin: useMargin).build()
        self.constrain.bottomEdges(view, innerSpacing: innerSpacing, useMargin: useMargin).build()
    }
    
    /**
     Constrains to the inside of the view
     
     - Parameter view: The view to constrain inside
     - Parameter innerSpacing: The distance between the outer view and the inner view (default: 0)
     - Parameter useMargin: Boolean specifying if they should lock to the margin
     */
    func constrainInside(_ view: UIView, innerSpacing: CGFloat=0, useMargin: Bool=true) {
        self.constrain.topEdges(view, innerSpacing: innerSpacing, useMargin: useMargin).build()
        self.constrain.bottomEdges(view, innerSpacing: innerSpacing, useMargin: useMargin).build()
        self.constrain.leftEdges(view, innerSpacing: innerSpacing, useMargin: useMargin).build()
        self.constrain.rightEdges(view, innerSpacing: innerSpacing, useMargin: useMargin).build()
    }
}
