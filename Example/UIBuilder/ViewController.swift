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
        

        self.complexFlagTest()
        
        self.testCenterAndEdge()
        
        self.testEdgeAndCorner()
    }
    
    func complexFlagTest() {
        
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
    
    func testCenterAndEdge() {
        
        let largerCenterView = UIView()
        largerCenterView.backgroundColor = UIColor.purple
        self.view.addSubview(largerCenterView)
        self.view.constrainInside(largerCenterView, innerSpacing: 100, useMargin: true)
        
        let centerView = UIView()
        centerView.backgroundColor = UIColor.orange
        centerView.constrainSize(CGSize(width: 120, height: 120))
        largerCenterView.addSubview(centerView)
        largerCenterView.constrainCenter(centerView)
        
        //=======================================================================
        // Test center offsets
        //=======================================================================
        
        let leftCenterView = UIView()
        leftCenterView.backgroundColor = UIColor.yellow
        leftCenterView.constrainSize(CGSize(width: 20, height: 20))
        centerView.addSubview(leftCenterView)
        centerView.constrain.leftOfCenter(leftCenterView, leftSpacing: 10).build()
        centerView.constrain.centerY(leftCenterView).build()
        
        let rightCenterView = UIView()
        rightCenterView.backgroundColor = UIColor.yellow
        rightCenterView.constrainSize(CGSize(width: 20, height: 20))
        centerView.addSubview(rightCenterView)
        centerView.constrain.rightOfCenter(rightCenterView, rightSpacing: 10).build()
        centerView.constrain.centerY(rightCenterView).build()
        
        let aboveCenterView = UIView()
        aboveCenterView.backgroundColor = UIColor.yellow
        aboveCenterView.constrainSize(CGSize(width: 20, height: 20))
        centerView.addSubview(aboveCenterView)
        centerView.constrain.aboveCenter(aboveCenterView, topSpacing: 10).build()
        centerView.constrain.centerX(aboveCenterView).build()
        
        let belowCenterView = UIView()
        belowCenterView.backgroundColor = UIColor.yellow
        belowCenterView.constrainSize(CGSize(width: 20, height: 20))
        centerView.addSubview(belowCenterView)
        centerView.constrain.belowCenter(belowCenterView, bottomSpacing: 10).build()
        centerView.constrain.centerX(belowCenterView).build()
        
        //=======================================================================
        // Test edge offsets
        //=======================================================================
        
        let leftOfLeftCenterView = UIView()
        leftOfLeftCenterView.backgroundColor = UIColor.red
        leftOfLeftCenterView.constrainSize(CGSize(width: 20, height: 20))
        centerView.addSubview(leftOfLeftCenterView)
        centerView.constrain.leftRight(leftView: leftOfLeftCenterView, rightView: leftCenterView, betweenSpacing: 10).build()
        centerView.constrain.centerY(leftOfLeftCenterView).build()
        
        let rightOfRightCenterView = UIView()
        rightOfRightCenterView.backgroundColor = UIColor.red
        rightOfRightCenterView.constrainSize(CGSize(width: 20, height: 20))
        centerView.addSubview(rightOfRightCenterView)
        centerView.constrain.leftRight(leftView: rightCenterView, rightView: rightOfRightCenterView, betweenSpacing: 10).build()
        centerView.constrain.centerY(rightOfRightCenterView).build()
        
        let aboveTheAboveCenterView = UIView()
        aboveTheAboveCenterView.backgroundColor = UIColor.red
        aboveTheAboveCenterView.constrainSize(CGSize(width: 20, height: 20))
        centerView.addSubview(aboveTheAboveCenterView)
        centerView.constrain.topBottom(topView: aboveTheAboveCenterView, bottomView: aboveCenterView, betweenSpacing: 10).build()
        centerView.constrain.centerX(aboveTheAboveCenterView).build()
        
        let belowTheBelowCenterView = UIView()
        belowTheBelowCenterView.backgroundColor = UIColor.red
        belowTheBelowCenterView.constrainSize(CGSize(width: 20, height: 20))
        centerView.addSubview(belowTheBelowCenterView)
        centerView.constrain.topBottom(topView: belowCenterView, bottomView: belowTheBelowCenterView, betweenSpacing: 10).build()
        centerView.constrain.centerX(belowTheBelowCenterView).build()
    }
    
    func testEdgeAndCorner() {
        for i in 0..<8 {
            let view = UIView()
            view.backgroundColor = UIColor.green
            view.constrainSize(CGSize(width: 40, height: 40))
            self.view.addSubview(view)
            
            if i == 0 { self.view.constrainTopLeft(view, innerSpacing: 10) }
            else if i == 1 { self.view.constrainTopCenter(view, innerSpacing: 20) }
            else if i == 2 { self.view.constrainTopRight(view, innerSpacing: 10) }
            else if i == 3 { self.view.constrainRightCenter(view, innerSpacing: 20) }
            else if i == 4 { self.view.constrainBottomRight(view, innerSpacing: 10) }
            else if i == 5 { self.view.constrainBottomCenter(view, innerSpacing: 20) }
            else if i == 6 { self.view.constrainBottomLeft(view, innerSpacing: 10) }
            else if i == 7 { self.view.constrainLeftCenter(view, innerSpacing: 20) }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

