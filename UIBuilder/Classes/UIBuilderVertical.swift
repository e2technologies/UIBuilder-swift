//
//  UIBuilderVertical.swift
//  UIBuilder
//
//  Created by Eric Chapman on 1/1/19.
//

import Foundation

public class UIBuilderVertical: UIBuilderHorizontal {
    
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
        var fixedWidth = true
        var maxWidth: CGFloat = 0
        var fixedHeight = true
        var totalHeight: CGFloat = self.padding.top + self.padding.bottom
        
        // Iterate through the datas and layout horizontally
        for element in self.elements {
            
            // Create the view and add it
            let view = element.build()
            container.addSubview(view)
            
            // If the first view, then lock to the top, else lock to the subsequent view
            if let aboveView = lastView {
                let spacing = lastMargin + element.margin.top
                container.constrain.topBottom(topView: aboveView, bottomView: view, betweenSpacing: spacing).build()
            }
            else {
                firstView = view
                firstMargin = element.margin.top
            }
            
            // Check the height
            if fixedHeight, let height = element.height {
                totalHeight += element.margin.top + height + element.margin.bottom
            }
            else { fixedHeight = false }
            
            // If the element has the height defined, vertically align.
            // Else lock the edges for resizing
            if let width = element.width {
                
                // Calculate the max width
                if fixedWidth {
                    let newWidth = self.padding.left + element.margin.left + width + element.margin.right + self.padding.right
                    maxWidth = max(newWidth, maxWidth)
                }
                
                // Set the alignment
                switch element.horizontalAlign {
                case .left:
                    container.constrain.leftEdges(view, innerSpacing: element.margin.left).build()
                    break
                case .center:
                    container.constrain.centerX(view).build()
                    break
                case.right:
                    container.constrain.rightEdges(view, innerSpacing: element.margin.right).build()
                    break
                }
            }
            else {
                fixedWidth = false
                container.constrain.leftEdges(view, innerSpacing: element.margin.left).build()
                container.constrain.rightEdges(view, innerSpacing: element.margin.right).build()
            }
            
            // Set items for the next iterations
            lastView = view
            lastMargin = element.margin.bottom
        }
        
        // If we have a fixed height, set it
        if fixedWidth && self.width == nil {
            self.width = maxWidth
            container.constrain.width(maxWidth).build()
        }
        
        // Check if the views are nil
        if let lView = lastView, let fView = firstView {
            
            // If the width is fixed, place accordingly
            if fixedHeight {
                
                // If the height doesn't exist, use the calculated width
                if self.height == nil {
                    self.height = totalHeight
                    container.constrain.height(totalHeight).build()
                }
                
                if let height = self.height {
                    
                    // If the height is less than needed, implement a negative offset
                    if height < totalHeight {
                        let offset = round((totalHeight-height)/2)
                        container.constrain.topEdges(fView, innerSpacing: -offset).build()
                    }
                        // Align the row data accordingly
                    else {
                        switch self.verticalAlign {
                        case .top:
                            container.constrain.topEdges(fView, innerSpacing: firstMargin).build()
                            break
                        case .center:
                            let offset = round((height-totalHeight)/2)
                            container.constrain.topEdges(fView, innerSpacing: firstMargin+offset).build()
                            break
                        case.bottom:
                            container.constrain.bottomEdges(lView, innerSpacing: lastMargin).build()
                            break
                        }
                    }
                }
            }
                // Else it is dynamic, lock the edges
            else {
                container.constrain.topEdges(fView, innerSpacing: firstMargin).build()
                container.constrain.bottomEdges(lView, innerSpacing: lastMargin).build()
            }
        }
        
        return container
    }
}
