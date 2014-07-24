//
//  LBButtonEffectController.swift
//  BangDevLab
//
//  Created by Bang Nguyen on 23/07/2014.
//  Copyright (c) Năm 2014 Bang Nguyen. All rights reserved.
//

import UIKit
import QuartzCore

class LBButtonEffectController: UIViewController {
    
    var _button : UIButton!
    
    private var topLine : CAShapeLayer = CAShapeLayer()
    private var middleLine : CAShapeLayer = CAShapeLayer()
    private var bottomLine : CAShapeLayer = CAShapeLayer()
    
    private var lineWidth : CGFloat?
    private var lineHeight : CGFloat?
    
    init(coder aDecoder: NSCoder!)  {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _button = UIButton(frame: CGRectMake(0, 0, 100, 100))
        _button.backgroundColor = UIColor.blackColor()
        _button.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2)
        _button.addTarget(self, action: "tappedButton:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(_button)
        
        setUpHamburger(_button)
    }
    
    func setUpHamburger(view : UIButton) {
        
        lineWidth = view.frame.size.width / 2
        lineHeight = lineWidth! / 6
        
        view.layer.addSublayer(createLayer(self.topLine, width: lineWidth!, height: lineHeight!))
        view.layer.addSublayer(createLayer(self.middleLine, width: lineWidth!, height: lineHeight!))
        view.layer.addSublayer(createLayer(self.bottomLine, width: lineWidth!, height: lineHeight!))
        
        topLine.position = CGPointMake(view.frame.size.width/2,  view.frame.size.height/2 - lineHeight!/2 - 10)
        middleLine.position = CGPointMake(view.frame.size.width/2, view.frame.size.height/2)
        bottomLine.position = CGPointMake(view.frame.size.width/2, view.frame.size.height/2 + lineHeight!/2 + 10)
    }
    
    func createLayer(layer : CAShapeLayer, width : CGFloat, height : CGFloat) -> CAShapeLayer {
        
        var path = UIBezierPath()
        path.moveToPoint(CGPointMake(0, 0))
        path.addLineToPoint(CGPointMake(width, 0))
        
        layer.path = path.CGPath
        layer.lineWidth = height
        layer.strokeColor = UIColor.whiteColor().CGColor
        
        var strokePath = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit)
        layer.bounds = CGPathGetBoundingBox(strokePath)
        
        return layer
    }
    
    func tappedButton(sender : AnyObject?) {
        NSLog("tapped")
        
        var button = sender as UIButton
        
        var topPath : UIBezierPath?
        var bottomPath : UIBezierPath?
        
        if button.selected {
            button.backgroundColor = UIColor.blackColor()
            
            topPath =  animationPath(CGPointMake(button.frame.size.width/2 - 10, button.frame.size.height/2 + lineHeight!/2 + 11), endPoint: CGPointMake(button.frame.size.width/2, button.frame.size.height/2 - lineHeight!/2 - 10), controlPoint: self.middleLine.position)
            bottomPath = animationPath(CGPointMake(button.frame.size.width/2 - 10, button.frame.size.height/2 - lineHeight!/2 - 11), endPoint: CGPointMake(button.frame.size.width/2, button.frame.size.height/2 + lineHeight!/2 + 10), controlPoint: self.middleLine.position)
            
        } else {
            button.backgroundColor = UIColor.grayColor()
            
            topPath =  animationPath(CGPointMake(button.frame.size.width/2, button.frame.size.height/2 - lineHeight!/2 - 10), endPoint: CGPointMake(button.frame.size.width/2 - 10, button.frame.size.height/2 + lineHeight!/2 + 11), controlPoint: self.middleLine.position)
            bottomPath = animationPath(CGPointMake(button.frame.size.width/2, button.frame.size.height/2 + lineHeight!/2 + 10), endPoint: CGPointMake(button.frame.size.width/2 - 10, button.frame.size.height/2 - lineHeight!/2 - 11), controlPoint: self.middleLine.position)
        }
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.4)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0))
        
        // animate middle line
        var middleAnimation = CAKeyframeAnimation(keyPath: "transform.rotation")
        middleAnimation.values = button.selected ? [ M_PI, 0 ] : [ 0, M_PI]
        
        self.middleLine.addAnimation(middleAnimation, forKey: "rotate")
        self.middleLine.setValue(button.selected ? 0 : M_PI, forKeyPath: "transform.rotation")
        
        // animate top line
        
        var topAnimationRotation = CAKeyframeAnimation(keyPath: "transform.rotation")
        topAnimationRotation.values = button.selected ? [ M_PI*5/4, 0] :[ 0, M_PI*5/4 ]
        topAnimationRotation.calculationMode = kCAAnimationCubic
        topAnimationRotation.keyTimes = [ 0, 0.33, 0.73, 1.0]
        
        var topAnimationPosition = CAKeyframeAnimation(keyPath: "position")
        topAnimationPosition.path = topPath!.CGPath
        
        var topAnimation = CAAnimationGroup()
        topAnimation.animations = [topAnimationRotation, topAnimationPosition]
        
        self.topLine.addAnimation(topAnimation, forKey: "animation")
        self.topLine.setValue(button.selected ? 0 : M_PI*5/4, forKeyPath: "transform.rotation")
        self.topLine.setValue(NSValue(CGPoint: button.selected ? CGPointMake(button.frame.size.width/2, button.frame.size.height/2 - lineHeight!/2 - 10) : CGPointMake(button.frame.size.width/2 - 10, button.frame.size.height/2 + lineHeight!/2 + 11)), forKeyPath: "position")

        // animate bottom line
        
        var bottomAnimationRotation = CAKeyframeAnimation(keyPath: "transform.rotation")
        bottomAnimationRotation.values = button.selected ? [ -M_PI*5/4, 0 ] : [ 0, -M_PI*5/4]
        bottomAnimationRotation.calculationMode = kCAAnimationCubic
        bottomAnimationRotation.keyTimes = [ 0, 0.33, 0.73, 1.0]
        
        var bottomAnimationPosition = CAKeyframeAnimation(keyPath: "position")
        bottomAnimationPosition.path = bottomPath!.CGPath
        
        var bottomAnimation = CAAnimationGroup()
        bottomAnimation.animations = [bottomAnimationRotation, bottomAnimationPosition]
        
        self.bottomLine.addAnimation(bottomAnimation, forKey: "animation2")
        self.bottomLine.setValue(button.selected ? 0 : -M_PI*5/4, forKeyPath: "transform.rotation")
        self.bottomLine.setValue(NSValue(CGPoint: button.selected ? CGPointMake(button.frame.size.width/2, button.frame.size.height/2 + lineHeight!/2 + 10) : CGPointMake(button.frame.size.width/2 - 10, button.frame.size.height/2 - lineHeight!/2 - 11)), forKeyPath: "position")
        
        CATransaction.commit()
        
        button.selected = !button.selected
    }
    
    func animationPath(startPoint: CGPoint, endPoint: CGPoint, controlPoint: CGPoint) -> UIBezierPath {
        var bezierCurvePath = UIBezierPath()
        bezierCurvePath.moveToPoint(startPoint)
        bezierCurvePath.addQuadCurveToPoint(endPoint, controlPoint: controlPoint)
        
        return bezierCurvePath
    }
}
