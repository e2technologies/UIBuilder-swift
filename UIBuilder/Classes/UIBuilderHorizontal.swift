//
//  UIBuilderHorizontal.swift
//  UIBuilder
//
//  Created by Eric Chapman on 1/1/19.
//

import Foundation

public class UIBuilderHorizontal: UIBuilderElement {
    var elements: [UIBuilderElement]
    
    public func addElement(_ element: UIBuilderElement) {
        self.elements.append(element)
    }
    
    init(elements: [UIBuilderElement]) {
        self.elements = elements
    }
    
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
        
        // Store the last view
        var firstView: UIView?
        var firstMargin: CGFloat = 0
        var lastView: UIView?
        var lastMargin: CGFloat = 0
        
        // See if the height/width are fixed
        var fixedHeight = true
        var maxHeight: CGFloat = 0
        var fixedWidth = true
        var totalWidth: CGFloat = self.padding.left + self.padding.right
        
        // Iterate through the datas and layout horizontally
        for element in self.elements {
            
            // Create the view and add it
            let view = element.build()
            container.addSubview(view)
            
            // If the first view, then lock to the top, else lock to the subsequent view
            if let leftView = lastView {
                let spacing = lastMargin + element.margin.left
                container.constrain.leftRight(leftView: leftView, rightView: view, betweenSpacing: spacing).build()
            }
            else {
                firstView = view
                firstMargin = element.margin.left
            }
            
            // Check the width
            if fixedWidth, let width = element.width {
                totalWidth += element.margin.left + width + element.margin.right
            }
            else { fixedWidth = false }
            
            // If the element has the height defined, vertically align.
            // Else lock the edges for resizing
            if let height = element.height {
                
                // Calculate the max height
                if fixedHeight{
                    let newHeight = self.padding.top + element.margin.top + height + element.margin.bottom + self.padding.bottom
                    maxHeight = max(newHeight, maxHeight)
                }
                
                // Set the alignment
                switch element.verticalAlign {
                case .top:
                    container.constrain.topEdges(view, innerSpacing: element.margin.top).build()
                    break
                case .center:
                    container.constrain.centerY(view).build()
                    break
                case.bottom:
                    container.constrain.bottomEdges(view, innerSpacing: element.margin.bottom).build()
                    break
                }
            }
            else {
                fixedHeight = false
                container.constrain.topEdges(view, innerSpacing: element.margin.top).build()
                container.constrain.bottomEdges(view, innerSpacing: element.margin.bottom).build()
            }
            
            // Set items for the next iterations
            lastView = view
            lastMargin = element.margin.right
        }
        
        // If we have a fixed height, set it
        if fixedHeight && self.height == nil {
            self.height = maxHeight
            container.constrain.height(maxHeight).build()
        }
        
        // Check if the views are nil
        if let lView = lastView, let fView = firstView {
            
            // If the width is fixed, place accordingly
            if fixedWidth {
                
                // If the width doesn't exist, use the calculated width
                if self.width == nil {
                    self.width = totalWidth
                    container.constrain.width(totalWidth).build()
                }
                
                // Set the view based on the width
                if let width = self.width {
                    
                    // If the width is less than needed, implement a negative offset
                    if width < totalWidth {
                        let offset = round((totalWidth-width)/2)
                        container.constrain.leftEdges(fView, innerSpacing: -offset).build()
                    }
                        // Align the row data accordingly
                    else {
                        switch self.horizontalAlign {
                        case .left:
                            container.constrain.leftEdges(fView, innerSpacing: firstMargin).build()
                            break
                        case .center:
                            let offset = round((width-totalWidth)/2)
                            container.constrain.leftEdges(fView, innerSpacing: firstMargin+offset).build()
                            break
                        case.right:
                            container.constrain.rightEdges(lView, innerSpacing: lastMargin).build()
                            break
                        }
                    }
                }
            }
                // Else it is dynamic, lock the edges
            else {
                container.constrain.leftEdges(fView, innerSpacing: firstMargin).build()
                container.constrain.rightEdges(lView, innerSpacing: lastMargin).build()
            }
        }
        
        return container
    }
}
