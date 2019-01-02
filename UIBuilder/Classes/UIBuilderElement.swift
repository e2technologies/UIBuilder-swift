//
//  UIBuilderElement.swift
//  UIBuilder
//
//  Created by Eric Chapman on 1/1/19.
//

import Foundation

public class UIBuilderElement {
    var view: UIView?
    var margin: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    var padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    var height: CGFloat?
    var width: CGFloat?
    var verticalAlign: UIBuilderAlign.Vertical = .top
    var horizontalAlign: UIBuilderAlign.Horizontal = .left
    
    /**
     Sets the view for the element
    
     - Parameter view: The view for the element
     - Returns: The build element
     **/
    public func view(_ view: UIView) -> Self { self.view = view; return self }
    
    /**
     Sets the margin for the element
     
     - Parameter margin: The margin for the element
     - Returns: The build element
     **/
    public func margin(_ margin: UIEdgeInsets) -> Self { self.margin = margin; return self }
    
    /**
     Sets the padding for the element
     
     - Parameter padding: The padding for the element
     - Returns: The build element
     **/
    public func padding(_ padding: UIEdgeInsets) -> Self { self.padding = padding; return self }
    
    /**
     Sets the height for the element
     
     - Parameter height: The height for the element
     - Returns: The build element
     **/
    public func height(_ height: CGFloat) -> Self { self.height = height; return self }
    
    /**
     Sets the width for the element
     
     - Parameter width: The width for the element
     - Returns: The build element
     **/
    public func width(_ width: CGFloat) -> Self { self.width = width; return self }
    
    /**
     Sets the vertical alignment for the element
     
     - Parameter align: The vertical alignment for the element
     - Returns: The build element
     **/
    public func valign(_ align: UIBuilderAlign.Vertical) -> Self { self.verticalAlign = align; return self }
    
    /**
     Sets the horizontal alignment for the element
     
     - Parameter align: The horizontal alignment for the element
     - Returns: The build element
     **/
    public func halign(_ align: UIBuilderAlign.Horizontal) -> Self { self.horizontalAlign = align; return self }
    
    // Override when subclassing
    @discardableResult
    public func build() -> UIView { return UIView() }
}
