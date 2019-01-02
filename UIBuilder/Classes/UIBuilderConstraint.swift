//
//  UIBuilderConstraint.swift
//  UIBuilder
//
//  Created by Eric Chapman on 1/1/19.
//

import Foundation

public class UIBuilderConstraint {
    var parent: UIView { didSet { self.parent.translatesAutoresizingMaskIntoConstraints = false } }
    var from: UIView { didSet { self.from.translatesAutoresizingMaskIntoConstraints = false } }
    var fromAttr: NSLayoutConstraint.Attribute?
    var to: UIView? { didSet { self.to?.translatesAutoresizingMaskIntoConstraints = false } }
    var toAttr: NSLayoutConstraint.Attribute?
    var relation: NSLayoutConstraint.Relation = .equal
    var multiplier: CGFloat = 1
    var constant: CGFloat = 0
    
    private var editingFrom = true
    
    /**
     Constructor
     
     - Parameter parent: The object who will be the view where the constraint
     it added to.  Note that it also defaults the "from" operator
     to the parent view.  This is useful in "height" and "width" calls
     **/
    public init(_ parent: UIView) {
        self.parent = parent
        self.from = parent
        self.editingFrom = true
    }
    
    // ----------------------------------------------------------------------------------
    // MARK: Standard Methods
    // ----------------------------------------------------------------------------------
    
    /**
     Specifies the "from" view
     
     - Parameter from: The "from" view
     
     - Returns: The constraint builder
     **/
    public func from(_ from: UIView) -> Self {
        self.from = from
        self.editingFrom = true
        return self
    }
    
    /**
     Specifies the "to" view
     
     - Parameter to: The "to" view
     
     - Returns: The constraint builder
     **/
    public func to(_ to: UIView) -> Self {
        self.to = to
        self.editingFrom = false
        return self
    }
    
    
    /**
     Sets the attribute for the last set "from" or "to" view
     
     - Parameter attribute: The attribute to set
     
     - Returns: The constraint builder
     
     Examples:
     - "view.constrain.attribute(.width)" sets the attribute for "from" view
     - "view.constrain.from(view1).attribute(.width)" sets the attribute for "from" view
     - "view.constrain.to(view1).attribute(.width)" sets the attribute for "to" view
     **/
    public func attribute(_ attribute: NSLayoutConstraint.Attribute) -> Self {
        if self.editingFrom {
            self.fromAttr = attribute
        }
        else {
            self.toAttr = attribute
        }
        return self
    }
    
    /**
     Sets the relation
     
     - Parameter relation: The relation between the "from" and "to" views
     
     - Returns: The constraint builder
     **/
    public func relation(_ relation: NSLayoutConstraint.Relation) -> Self {
        self.relation = relation
        return self
    }
    
    /**
     Sets the multipler
     
     - Parameter multiplier: The multipler
     
     - Returns: The constraint builder
     **/
    public func multiplier(_ multiplier: CGFloat) -> Self {
        self.multiplier = multiplier
        return self
    }
    
    /**
     Sets the constant
     
     - Parameter constant: The constant
     
     - Returns: The constraint builder
     **/
    public func constant(_ constant: CGFloat) -> Self {
        self.constant = constant
        return self
    }
    
    /**
     This method will build the constraint and add it to the list.  Note that it will check if there
     are laredy existing constraints that match the criteria before adding.  If it finds an
     existing one, it will update the constant and call "layoutIfNeeded()" on the parent to kick-off
     a redraw
     
     - Parameter update: If "true", will check existing constraints
     
     - Returns: The newly created constraint or the existing constraint if one was found
     **/
    @discardableResult
    public func build(update: Bool=false) -> NSLayoutConstraint {
        // TODO: Check Values
        
        let from = self.from
        let fromAttribute = self.fromAttr!
        let to = self.to
        let toAttribute = self.toAttr ?? .notAnAttribute
        let relation = self.relation
        let multiplier = self.multiplier
        let constant = self.constant
        
        // Check for an existing constraint if update is true
        var existingConstraint: NSLayoutConstraint?
        if update == true {
            for constraint in self.parent.constraints {
                if constraint.firstItem === from && constraint.firstAttribute == fromAttribute &&
                    constraint.secondItem === to && constraint.secondAttribute == toAttribute &&
                    constraint.relation == relation && constraint.multiplier == multiplier {
                    existingConstraint = constraint
                    break
                }
            }
        }
        
        // If we have an existing constraint, update it, else create a new one
        if let constraint = existingConstraint {
            if constraint.constant != constant {
                constraint.constant = constant
                self.parent.layoutIfNeeded()
            }
            return constraint
        }
        else {
            let constraint = NSLayoutConstraint(
                item: from, attribute: fromAttribute, relatedBy: relation,
                toItem: to, attribute: toAttribute,
                multiplier: multiplier, constant: constant)
            self.parent.addConstraint(constraint)
            return constraint
        }
    }
    
    // ----------------------------------------------------------------------------------
    // MARK: Helper Methods
    // ----------------------------------------------------------------------------------
    
    /**
     Creates (or updates) the width constraint of a view
     
     - Parameter width: The width of the view
     
     - Returns: The constraint builder
     **/
    public func width(_ width: CGFloat) -> Self {
        return self.attribute(.width).constant(width)
    }
    
    /**
     Creates (or updates) the height constraint of a view
     
     - Parameter height: The height of the view
     
     - Returns: The constraint builder
     **/
    public func height(_ height: CGFloat) -> Self {
        return self.attribute(.height).constant(height)
    }
    
    /**
     Constrains the left side of the view
     
     - Parameter view: The view to constrain left
     - Parameter innerSpacing: The distance between the outer view and the inner view (default: 0)
     - Parameter useMargin: Boolean specifying if they should lock to the margin
     
     - Returns: The constraint builder
     **/
    public func leftEdges(_ view: UIView, innerSpacing: CGFloat=0, useMargin: Bool=true) -> Self {
        let attr: NSLayoutConstraint.Attribute = (useMargin == true) ? .leftMargin : .left
        return self.attribute(attr).to(view).attribute(.left).constant(-innerSpacing)
    }
    
    /**
     Constrains to the right of the view
     
     - Parameter view: The view to constrain right
     - Parameter innerSpacing: The distance between the outer view and the inner view (default: 0)
     - Parameter useMargin: Boolean specifying if they should lock to the margin
     
     - Returns: The constraint builder
     **/
    public func rightEdges(_ view: UIView, innerSpacing: CGFloat=0, useMargin: Bool=true) -> Self {
        let attr: NSLayoutConstraint.Attribute = (useMargin == true) ? .rightMargin : .right
        return self.attribute(attr).to(view).attribute(.right).constant(innerSpacing)
    }
    
    /**
     Constrains to the top of the view
     
     - Parameter view: The view to constrain top
     - Parameter innerSpacing: The distance between the outer view and the inner view (default: 0)
     - Parameter useMargin: Boolean specifying if they should lock to the margin
     
     - Returns: The constraint builder
     **/
    public func topEdges(_ view: UIView, innerSpacing: CGFloat=0, useMargin: Bool=true) -> Self {
        let attr: NSLayoutConstraint.Attribute = (useMargin == true) ? .topMargin : .top
        return self.attribute(attr).to(view).attribute(.top).constant(-innerSpacing)
    }
    
    /**
     Constrains to the bottom of the view
     
     - Parameter view: The view to constrain bottom
     - Parameter innerSpacing: The distance between the outer view and the inner view (default: 0)
     - Parameter useMargin: Boolean specifying if they should lock to the margin
     
     - Returns: The constraint builder
     **/
    public func bottomEdges(_ view: UIView, innerSpacing: CGFloat=0, useMargin: Bool=true) -> Self {
        let attr: NSLayoutConstraint.Attribute = (useMargin == true) ? .bottomMargin : .bottom
        return self.attribute(attr).to(view).attribute(.bottom).constant(innerSpacing)
    }
    
    /**
     Centers the view horizontally inside of this view.  Note that you must set the
     height and width parameters independently
     
     - Parameter view: The view to center horizontally
     - Parameter offset: The distance from center in the X direction (default: 0)
     
     - Returns: The constraint builder
     **/
    public func centerX(_ view: UIView, offset: CGFloat=0) -> Self {
        return self.attribute(.centerX).to(view).attribute(.centerX).constant(offset)
    }
    
    /**
     Centers the view vertically inside of this view.  Note that you must set the
     height and width parameters independently
     
     - Parameter view: The view to center vertically
     - Parameter offset: The distance from center in the Y direction (default: 0)
     
     - Returns: The constraint builder
     **/
    public func centerY(_ view: UIView, offset: CGFloat=0) -> Self {
        return self.attribute(.centerY).to(view).attribute(.centerY).constant(offset)
    }
    
    /**
     Aligns the view to the right of the center
     
     - Parameter view: The view to center horizontally
     - Parameter rightSpacing: The distance to the right of the center
     
     - Returns: The constraint builder
     **/
    public func rightOfCenter(_ view: UIView, rightSpacing: CGFloat=0) -> Self {
        return self.attribute(.centerX).to(view).attribute(.left).constant(rightSpacing)
    }
    
    /**
     Aligns the view to the left of the center
     
     - Parameter view: The view to center horizontally
     - Parameter leftSpacing: The distance to the left of the center
     
     - Returns: The constraint builder
     **/
    public func leftOfCenter(_ view: UIView, leftSpacing: CGFloat=0) -> Self {
        return self.attribute(.centerX).to(view).attribute(.right).constant(-leftSpacing)
    }
    
    /**
     Aligns the view above the center
     
     - Parameter view: The view to center horizontally
     - Parameter topSpacing: The distance above the center
     
     - Returns: The constraint builder
     **/
    public func aboveCenter(_ view: UIView, topSpacing: CGFloat=0) -> Self {
        return self.attribute(.centerY).to(view).attribute(.bottom).constant(-topSpacing)
    }
    
    /**
     Aligns the view below the center
     
     - Parameter view: The view to center horizontally
     - Parameter bottomSpacing: The distance below the center
     
     - Returns: The constraint builder
     **/
    public func belowCenter(_ view: UIView, bottomSpacing: CGFloat=0) -> Self {
        return self.attribute(.centerY).to(view).attribute(.top).constant(bottomSpacing)
    }
    
    /**
     Constrain views next to one another
     
     - Parameter leftView: The left side view
     - Parameter rightView: The right side view
     - Parameter betweenSpacing: The distance between the left view and the right view (default: 0)
     
     - Returns: The constraint builder
     **/
    public func leftRight(leftView: UIView, rightView: UIView, betweenSpacing: CGFloat=0) -> Self {
        return self.from(leftView).attribute(.right).to(rightView).attribute(.left).constant(-betweenSpacing)
    }
    
    /**
     Constrain views on top of one another
     
     - Parameter topView: The left side view
     - Parameter bottomView: The right side view
     - Parameter betweenSpacing: The distance between the top view and the bottom view (default: 0)
     
     - Returns: The constraint builder
     **/
    public func topBottom(topView: UIView, bottomView: UIView, betweenSpacing: CGFloat=0) -> Self {
        return self.from(topView).attribute(.bottom).to(bottomView).attribute(.top).constant(-betweenSpacing)
    }
}

public extension UIView {
    
    /**
     Returns a new "constraint" object that can be used to build a constraint
     
     - Returns: The new config object
     **/
    var constrain: UIBuilderConstraint {
        return UIBuilderConstraint(self)
    }
    
    /**
     Sets the size of the view (width and height)
     
     - Parameter size: The size of the view
     **/
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
     **/
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
     **/
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
     **/
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
     **/
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
     **/
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
     **/
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
     **/
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
     **/
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
     **/
    func constrainBottomRight(_ view: UIView, innerSpacing: CGFloat=0, useMargin: Bool=true) {
        self.constrain.rightEdges(view, innerSpacing: innerSpacing, useMargin: useMargin).build()
        self.constrain.bottomEdges(view, innerSpacing: innerSpacing, useMargin: useMargin).build()
    }
    
    /**
     Constrains to the inside of the view
     
     - Parameter view: The view to constrain inside
     - Parameter innerSpacing: The distance between the outer view and the inner view (default: 0)
     - Parameter useMargin: Boolean specifying if they should lock to the margin
     **/
    func constrainInside(_ view: UIView, innerSpacing: CGFloat=0, useMargin: Bool=true) {
        self.constrain.topEdges(view, innerSpacing: innerSpacing, useMargin: useMargin).build()
        self.constrain.bottomEdges(view, innerSpacing: innerSpacing, useMargin: useMargin).build()
        self.constrain.leftEdges(view, innerSpacing: innerSpacing, useMargin: useMargin).build()
        self.constrain.rightEdges(view, innerSpacing: innerSpacing, useMargin: useMargin).build()
    }
}
