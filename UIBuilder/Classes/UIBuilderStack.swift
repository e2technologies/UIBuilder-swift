import Foundation

enum UIBuilderStackMode {
    case vertical
    case horizontal
}

/**
 This class will translate the insets parameters between horizontal and vertical
 */
private class UIEdgeInsetsTranslate {
    let insets: UIEdgeInsets
    let mode: UIBuilderStackMode
    
    init(insets: UIEdgeInsets, mode: UIBuilderStackMode) {
        self.insets = insets
        self.mode = mode
    }
    
    var left: CGFloat { return self.mode == .vertical ? self.insets.left : self.insets.bottom }
    var right: CGFloat { return self.mode == .vertical ? self.insets.right : self.insets.top }
    var top: CGFloat { return self.mode == .vertical ? self.insets.top : self.insets.left }
    var bottom: CGFloat { return self.mode == .vertical ? self.insets.bottom : self.insets.right }
}

/**
 This class will translate the element parameters between horizontal and vertical
 */
private class UIBuilderElementTranslate {
    let element: UIBuilderElement
    let mode: UIBuilderStackMode
    let padding: UIEdgeInsetsTranslate
    let margin: UIEdgeInsetsTranslate
    
    init(element: UIBuilderElement, mode: UIBuilderStackMode) {
        self.element = element
        self.mode = mode
        self.padding = UIEdgeInsetsTranslate(insets: self.element.padding, mode: self.mode)
        self.margin = UIEdgeInsetsTranslate(insets: self.element.margin, mode: self.mode)
    }
    
    var height: CGFloat? {
        set {
            if self.mode == .vertical { self.element.height = newValue }
            else { self.element.width = newValue }
        }
        get {
            if self.mode == .vertical { return self.element.height }
            else { return self.element.width }
        }
    }
    
    var width: CGFloat? {
        set {
            if self.mode == .vertical { self.element.width = newValue }
            else { self.element.height = newValue }
        }
        get {
            if self.mode == .vertical { return self.element.width }
            else { return self.element.height }
        }
    }
    
    var verticalAlign: UIBuilderAlign.Vertical {
        if self.mode == .vertical {
            return self.element.verticalAlign
        }
        else {
            switch self.element.horizontalAlign {
            case .left: return .top
            case .center: return .center
            case .right: return .bottom
            }
        }
    }
    
    var horizontalAlign: UIBuilderAlign.Horizontal {
        if self.mode == .vertical {
            return self.element.horizontalAlign
        }
        else {
            switch self.element.verticalAlign {
            case .top: return .left
            case .center: return .center
            case .bottom: return .right
            }
        }
    }
}

/**
 This class will translate some of the constraint builders between horizontal and vertical
 */

private class UIBuilderConstraintTranslate {
    let view: UIView
    let mode: UIBuilderStackMode
    
    init(view: UIView, mode: UIBuilderStackMode) {
        self.view = view
        self.mode = mode
    }
    
    func topBottom(topView: UIView, bottomView: UIView, betweenSpacing: CGFloat) -> UIBuilderConstraint {
        if self.mode == .vertical { return self.view.constrain.topBottom(topView: topView, bottomView: bottomView, betweenSpacing: betweenSpacing) }
        else { return self.view.constrain.leftRight(leftView: topView, rightView: bottomView, betweenSpacing: betweenSpacing) }
    }
    
    func leftEdges(_ view: UIView, innerSpacing: CGFloat) -> UIBuilderConstraint {
        if self.mode == .vertical { return self.view.constrain.leftEdges(view, innerSpacing: innerSpacing) }
        else { return self.view.constrain.topEdges(view, innerSpacing: innerSpacing) }
    }
    
    func rightEdges(_ view: UIView, innerSpacing: CGFloat) -> UIBuilderConstraint {
        if self.mode == .vertical { return self.view.constrain.rightEdges(view, innerSpacing: innerSpacing) }
        else { return self.view.constrain.bottomEdges(view, innerSpacing: innerSpacing) }
    }
    
    func topEdges(_ view: UIView, innerSpacing: CGFloat) -> UIBuilderConstraint {
        if self.mode == .vertical { return self.view.constrain.topEdges(view, innerSpacing: innerSpacing) }
        else { return self.view.constrain.leftEdges(view, innerSpacing: innerSpacing) }
    }
    
    func bottomEdges(_ view: UIView, innerSpacing: CGFloat) -> UIBuilderConstraint {
        if self.mode == .vertical { return self.view.constrain.bottomEdges(view, innerSpacing: innerSpacing) }
        else { return self.view.constrain.rightEdges(view, innerSpacing: innerSpacing) }
    }
    
    func centerX(_ view: UIView) -> UIBuilderConstraint {
        if self.mode == .vertical { return self.view.constrain.centerX(view) }
        else { return self.view.constrain.centerY(view) }
    }
    
    func height(_ height: CGFloat) -> UIBuilderConstraint {
        if self.mode == .vertical { return self.view.constrain.height(height) }
        else { return self.view.constrain.width(height) }
    }
    
    func width(_ width: CGFloat) -> UIBuilderConstraint {
        if self.mode == .vertical { return self.view.constrain.width(width) }
        else { return self.view.constrain.height(width) }
    }
}

public class UIBuilderStack: UIBuilderElement {
    let elements: [UIBuilderElement]
    let mode: UIBuilderStackMode
    
    // ----------------------------------------------------------------------------------
    // MARK: Initialization
    // ----------------------------------------------------------------------------------
    
    init(elements: [UIBuilderElement], mode: UIBuilderStackMode) {
        self.elements = elements
        self.mode = mode
    }
    
    // ----------------------------------------------------------------------------------
    // MARK: Build Method
    // ----------------------------------------------------------------------------------
    
    public override func build() -> UIView {
        
        // Create the container view
        let container = self.view ?? UIView()
        container.layoutMargins = self.padding
        
        // If the width is defined, set it
        if let width = self.width {
            container.constrain.width(width).build()
        }
        
        // If the height is defined, set it
        if let height = self.height {
            container.constrain.height(height).build()
        }
        
        // Translate self
        let t_self = UIBuilderElementTranslate(element: self, mode: self.mode)
        let t_constrain = UIBuilderConstraintTranslate(view: container, mode: self.mode)
        
        // Store the last view
        var firstView: UIView?
        var firstMargin: CGFloat = 0
        var lastView: UIView?
        var lastMargin: CGFloat = 0
        
        // See if the height/width are fixed
        var fixedWidth = true
        var maxWidth: CGFloat = 0
        var fixedHeight = true
        var totalHeight: CGFloat = t_self.padding.top + t_self.padding.bottom
        
        // Iterate through the datas and layout horizontally
        for element in self.elements {
            
            // Translate element
            let t_element = UIBuilderElementTranslate(element: element, mode: self.mode)
            
            // Create the view and add it
            let view = element.build()
            container.addSubview(view)

            // If the first view, then lock to the top, else lock to the subsequent view
            if let aboveView = lastView {
                let spacing = lastMargin + t_element.margin.top
                t_constrain.topBottom(topView: aboveView, bottomView: view, betweenSpacing: spacing).build()
            }
            else {
                firstView = view
                firstMargin = t_element.margin.top
            }
            
            // Check the height
            if fixedHeight, let height = t_element.height {
                totalHeight += t_element.margin.top + height + t_element.margin.bottom
            }
            else { fixedHeight = false }
            
            // If the element has the height defined, vertically align.
            // Else lock the edges for resizing
            if let width = t_element.width {
                
                // Calculate the max width
                if fixedWidth {
                    let newWidth = t_self.padding.left + t_element.margin.left + width + t_element.margin.right + t_self.padding.right
                    maxWidth = max(newWidth, maxWidth)
                }
                
                // Set the alignment
                switch t_element.horizontalAlign {
                case .left:
                    t_constrain.leftEdges(view, innerSpacing: t_element.margin.left).build()
                    break
                case .center:
                    t_constrain.centerX(view).build()
                    break
                case.right:
                    t_constrain.rightEdges(view, innerSpacing: t_element.margin.right).build()
                    break
                }
            }
            else {
                fixedWidth = false
                t_constrain.leftEdges(view, innerSpacing: t_element.margin.left).build()
                t_constrain.rightEdges(view, innerSpacing: t_element.margin.right).build()
            }
            
            // Set items for the next iterations
            lastView = view
            lastMargin = t_element.margin.bottom
        }
        
        // If we have a fixed height, set it
        if fixedWidth && t_self.width == nil {
            t_self.width = maxWidth
            t_constrain.width(maxWidth).build()
        }
        
        // Check if the views are nil
        if let lView = lastView, let fView = firstView {
            
            // If the width is fixed, place accordingly
            if fixedHeight {
                
                // If the height doesn't exist, use the calculated width
                if t_self.height == nil {
                    t_self.height = totalHeight
                    t_constrain.height(totalHeight).build()
                }
                
                if let height = t_self.height {
                    
                    // If the height is less than needed, implement a negative offset
                    if height < totalHeight {
                        let offset = round((totalHeight-height)/2)
                        container.constrain.topEdges(fView, innerSpacing: -offset).build()
                    }
                        // Align the row data accordingly
                    else {
                        switch t_self.verticalAlign {
                        case .top:
                            t_constrain.topEdges(fView, innerSpacing: firstMargin).build()
                            break
                        case .center:
                            let offset = round((height-totalHeight)/2)
                            t_constrain.topEdges(fView, innerSpacing: firstMargin+offset).build()
                            break
                        case.bottom:
                            t_constrain.bottomEdges(lView, innerSpacing: lastMargin).build()
                            break
                        }
                    }
                }
            }
                // Else it is dynamic, lock the edges
            else {
                t_constrain.topEdges(fView, innerSpacing: firstMargin).build()
                t_constrain.bottomEdges(lView, innerSpacing: lastMargin).build()
            }
        }
        
        return container
    }
}
