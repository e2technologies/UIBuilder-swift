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
        
        self.view.backgroundColor = UIColor.gray
        
        let stripeHeight: CGFloat = 20
 
        // Build the top side
        let blueSquare = UIView()
        blueSquare.backgroundColor = UIColor.blue
        let blueSquareElement = blueSquare.element.height(7*stripeHeight).width(7*stripeHeight).halign(.left).valign(.top)
        
        var tStripes = [UIBuilderElement]()
        for i in 0..<7 {
            let stripe = UIView()
            stripe.backgroundColor = (i % 2) == 0 ? UIColor.red : UIColor.white
            tStripes.append(stripe.element.height(stripeHeight))
        }

        let topRightStripes = UIBuilder.stack(vertical: tStripes)
        let topHStack = UIBuilder.stack(horizontal: [blueSquareElement, topRightStripes])
        
        // Build the bottom side
        var bStripes = [UIBuilderElement]()
        for i in 0..<7 {
            let stripe = UIView()
            stripe.backgroundColor = (i % 2) == 0 ? UIColor.white : UIColor.red
            bStripes.append(stripe.element.height(stripeHeight))
        }
        let bottomVStack = UIBuilder.stack(vertical: bStripes)
     
        // Combine the top and bottom
        let mainView = UIBuilder.stack(vertical: [topHStack, bottomVStack]).build()
        
        self.view.addSubview(mainView)
        self.view.constrain.leftEdges(mainView).build()
        self.view.constrain.rightEdges(mainView).build()
        self.view.constrain.topEdges(mainView).build()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

