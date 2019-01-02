//
//  UIBuilderView.swift
//  UIBuilder
//
//  Created by Eric Chapman on 1/1/19.
//

import Foundation

public class UIBuilderView: UIBuilderElement {
    var view: UIView
    
    init(view: UIView) {
        self.view = view
    }
    
    public override func build() -> UIView {
        // If the width is defined, set it
        if let width = self.width {
            self.view.constrain.width(width).build()
        }
        
        // If the height is defined, set it
        if let height = self.height {
            self.view.constrain.height(height).build()
        }
        
        return self.view
    }
}

public extension UIView {
    
    /**
     Returns a new "element" object that can be used to build a view
     
     - Returns: The new element object
     **/
    var element: UIBuilderElement {
        return UIBuilderView(view: self)
    }
}
