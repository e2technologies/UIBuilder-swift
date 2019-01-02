//
//  UIBuilderView.swift
//  UIBuilder
//
//  Created by Eric Chapman on 1/1/19.
//

import Foundation

public class UIBuilderView: UIBuilderElement {
    public override func build() -> UIView {
        let tempView = self.view ?? UIView()
        
        // If the width is defined, set it
        if let width = self.width {
            tempView.constrain.width(width).build()
        }
        
        // If the height is defined, set it
        if let height = self.height {
            tempView.constrain.height(height).build()
        }
        
        return tempView
    }
}

public extension UIView {
    
    /**
     Returns a new "element" object that can be used to build a view
     
     - Returns: The new element object
     **/
    var element: UIBuilderElement {
        return UIBuilderView().view(self)
    }
}
