//
//  ViewController.swift
//  UIBuilder
//
//  Created by Eric Chapman on 01/01/2019.
//  Copyright (c) 2019 Eric Chapman. All rights reserved.
//

import UIKit
import UIBuilder

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let margin = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        var elements = [UIBuilderElement]()
        
        // Fixed
        elements.removeAll()
        for _ in 0..<5 {
            let view = UIView()
            view.backgroundColor = UIColor.red
            elements.append(view.element.width(25).height(25).margin(margin))
        }
        let row1 = UIBuilder.stack(horizontal: elements).halign(.center)
        
        // One width stretching
        elements.removeAll()
        for i in 0..<3 {
            let view = UIView()
            view.backgroundColor = UIColor.yellow
            if i == 1 {
                elements.append(view.element.height(25).margin(margin))
            }
            else {
                elements.append(view.element.width(25).height(25).margin(margin))
            }
        }
        let row2 = UIBuilder.stack(horizontal: elements)
        
        // One width and all of the height stretching
        elements.removeAll()
        for i in 0..<7 {
            let view = UIView()
            view.backgroundColor = UIColor.green
            if i == 1 {
                elements.append(view.element.height(25).margin(margin))
            }
            else {
                elements.append(view.element.height(25).width(25).margin(margin))
            }
        }
        let row3 = UIBuilder.stack(horizontal: elements)
        
        let tempView = UIView()
        tempView.backgroundColor = UIColor.blue
        let row4 = tempView.element.width(50).halign(.center).margin(margin)
        
        // Create the view
        let view = UIBuilder.stack(vertical: [row2, row1, row4, row3]).build()
        
        self.view.addSubview(view)
        self.view.constrainInside(view, innerSpacing: 20, useMargin: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

