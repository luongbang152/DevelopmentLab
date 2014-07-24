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
    
    var _button1 : UIButton!
    var _button2 : UIButton!
    
    private var lineArr = [ UIButton : [CAShapeLayer] ]()
    private var lineWidth : CGFloat!
    private var lineHeight : CGFloat!
    
    init(coder aDecoder: NSCoder!)  {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _button1 = UIButton(frame: CGRectMake(0, 0, 100, 100))
        _button1.backgroundColor = UIColor.blackColor()
        _button1.center = CGPointMake(self.view.bounds.size.width/2, 150)
        _button1.addTarget(self, action: "tappedButton1:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(_button1)
        
        _button2 = UIButton(frame: CGRectMake(0, 0, 100, 100))
        _button2.backgroundColor = UIColor.flatBelizeHoleColor()
        _button2.center = CGPointMake(self.view.bounds.size.width/2, _button1.center.y + 150)
        _button2.addTarget(self, action: "tappedButton2:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(_button2)
        
        lineWidth = 50
        lineHeight = lineWidth / 6
        setUpHamburger(_button1)
        setUpHamburger(_button2)
    }
    
    func setUpHamburger(view : UIButton) {
        
        var topLine = CAShapeLayer()
        var middleLine = CAShapeLayer()
        var bottomLine = CAShapeLayer()
        
        view.layer.addSublayer(createLayer(topLine, width: lineWidth!, height: lineHeight!))
        view.layer.addSublayer(createLayer(middleLine, width: lineWidth!, height: lineHeight!))
        view.layer.addSublayer(createLayer(bottomLine, width: lineWidth!, height: lineHeight!))
        
        topLine.position = CGPointMake(view.frame.size.width/2,  view.frame.size.height/2 - lineHeight!/2 - 10)
        middleLine.position = CGPointMake(view.frame.size.width/2, view.frame.size.height/2)
        bottomLine.position = CGPointMake(view.frame.size.width/2, view.frame.size.height/2 + lineHeight!/2 + 10)
        
        lineArr[view] = [ topLine, middleLine, bottomLine ]
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
    
    func animationPath(startPoint: CGPoint, endPoint: CGPoint, controlPoint: CGPoint) -> UIBezierPath {
        var bezierCurvePath = UIBezierPath()
        bezierCurvePath.moveToPoint(startPoint)
        bezierCurvePath.addQuadCurveToPoint(endPoint, controlPoint: controlPoint)
        return bezierCurvePath
    }
    
    func tappedButton1(sender : AnyObject?) {
        
        var button = sender as UIButton
        
        var tempArr = lineArr[button] as [CAShapeLayer]
        var topLine = tempArr[0]
        var middleLine = tempArr[1]
        var bottomLine = tempArr[2]
        
        var topPath : UIBezierPath?
        var bottomPath : UIBezierPath?
        var topPathEndPoint : CGPoint?
        var bottomPathEndPoint : CGPoint?
        
        var controlPoint = CGPointMake(button.frame.size.width/2 + 15, button.frame.size.height/2)
        
        if button.selected {
            
            topPathEndPoint = CGPointMake(button.frame.size.width/2, button.frame.size.height/2 - lineHeight!/2 - 10)
            bottomPathEndPoint = CGPointMake(button.frame.size.width/2, button.frame.size.height/2 + lineHeight!/2 + 10)
            
            topPath =  animationPath(CGPointMake(button.frame.size.width/2 - 10, button.frame.size.height/2 + lineHeight!/2 + 11), endPoint: topPathEndPoint!, controlPoint: controlPoint)
            bottomPath = animationPath(CGPointMake(button.frame.size.width/2 - 10, button.frame.size.height/2 - lineHeight!/2 - 11), endPoint: bottomPathEndPoint!, controlPoint: controlPoint)
            
        } else {
            
            topPathEndPoint = CGPointMake(button.frame.size.width/2 - 10, button.frame.size.height/2 + lineHeight!/2 + 11)
            bottomPathEndPoint = CGPointMake(button.frame.size.width/2 - 10, button.frame.size.height/2 - lineHeight!/2 - 11)
            
            topPath =  animationPath(CGPointMake(button.frame.size.width/2, button.frame.size.height/2 - lineHeight!/2 - 10), endPoint: topPathEndPoint!, controlPoint: controlPoint)
            bottomPath = animationPath(CGPointMake(button.frame.size.width/2, button.frame.size.height/2 + lineHeight!/2 + 10), endPoint: bottomPathEndPoint!, controlPoint: controlPoint)
        }
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.5)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0))
        
        // animate middle line
        var middleAnimation = CAKeyframeAnimation(keyPath: "transform.rotation")
        middleAnimation.values = button.selected ? [ M_PI, 0 ] : [ 0, M_PI]
        
        middleLine.addAnimation(middleAnimation, forKey: "rotate")
        middleLine.setValue(button.selected ? 0 : M_PI, forKeyPath: "transform.rotation")
        
        // animate top line
        
        var topAnimationRotation = CAKeyframeAnimation(keyPath: "transform.rotation")
        topAnimationRotation.values = button.selected ? [ M_PI*5/4, 0] :[ 0, M_PI*5/4 ]
        topAnimationRotation.calculationMode = kCAAnimationCubic
        topAnimationRotation.keyTimes = [ 0, 0.33, 0.73, 1.0]
        
        var topAnimationPosition = CAKeyframeAnimation(keyPath: "position")
        topAnimationPosition.path = topPath!.CGPath
        topAnimationPosition.removedOnCompletion = false
        topAnimationPosition.fillMode = kCAFillModeForwards
        
        topLine.addAnimation(topAnimationRotation, forKey: "animation")
        topLine.addAnimation(topAnimationPosition, forKey: "animation2")
        topLine.setValue(button.selected ? 0 : M_PI*5/4, forKeyPath: "transform.rotation")

        // animate bottom line
        
        var bottomAnimationRotation = CAKeyframeAnimation(keyPath: "transform.rotation")
        bottomAnimationRotation.values = button.selected ? [ -M_PI*5/4, 0 ] : [ 0, -M_PI*5/4]
        bottomAnimationRotation.calculationMode = kCAAnimationCubic
        bottomAnimationRotation.keyTimes = [ 0, 0.33, 0.73, 1.0]
        
        var bottomAnimationPosition = CAKeyframeAnimation(keyPath: "position")
        bottomAnimationPosition.path = bottomPath!.CGPath
        bottomAnimationPosition.removedOnCompletion = false
        bottomAnimationPosition.fillMode = kCAFillModeForwards
        
        bottomLine.addAnimation(bottomAnimationRotation, forKey: "animation")
        bottomLine.addAnimation(bottomAnimationPosition, forKey: "animation")
        bottomLine.setValue(button.selected ? 0 : -M_PI*5/4, forKeyPath: "transform.rotation")
        
        CATransaction.commit()
        
        button.selected = !button.selected
    }
    
    func tappedButton2(sender : AnyObject?) {
        
        var button = sender as UIButton
        
        var tempArr = lineArr[button] as [CAShapeLayer]
        var topLine = tempArr[0]
        var middleLine = tempArr[1]
        var bottomLine = tempArr[2]
        
        var topPath : UIBezierPath?
        var bottomPath : UIBezierPath?
        var topPathEndPoint : CGPoint?
        var bottomPathEndPoint : CGPoint?
        
        if button.selected {
            
            topPathEndPoint = CGPointMake(button.frame.size.width/2, button.frame.size.height/2 - lineHeight!/2 - 10)
            bottomPathEndPoint = CGPointMake(button.frame.size.width/2, button.frame.size.height/2 + lineHeight!/2 + 10)
            
            topPath =  animationPath(middleLine.position, endPoint: topPathEndPoint!, controlPoint: CGPointMake(button.bounds.size.width/2 + 20, button.frame.size.height/2 - lineHeight!/2 - 5))
            bottomPath = animationPath(middleLine.position, endPoint: bottomPathEndPoint!, controlPoint: CGPointMake(button.bounds.size.width/2 - 20, button.frame.size.height/2 + lineHeight!/2 + 5))
            
        } else {
            
            topPathEndPoint = middleLine.position
            bottomPathEndPoint = middleLine.position
            
            topPath =  animationPath(CGPointMake(button.frame.size.width/2, button.frame.size.height/2 - lineHeight!/2 - 10), endPoint: topPathEndPoint!, controlPoint: CGPointMake(button.bounds.size.width/2 + 20, button.frame.size.height/2 - lineHeight!/2 - 5))
            
            bottomPath = animationPath(CGPointMake(button.frame.size.width/2, button.frame.size.height/2 + lineHeight!/2 + 10), endPoint: bottomPathEndPoint!, controlPoint: CGPointMake(button.bounds.size.width/2 - 20, button.frame.size.height/2 + lineHeight!/2 + 5))
        }
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.5)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0))
        
        // animate middle line
        var middleAnimationRotation = CAKeyframeAnimation(keyPath: "transform.rotation")
        middleAnimationRotation.values = button.selected ? [ M_PI, 0 ] : [ 0, M_PI]
        
        var middleAnimationScale = CAKeyframeAnimation(keyPath: "transform.scale.x")
        middleAnimationScale.values = button.selected ? [ 0.1, 1 ] : [ 1, 0.1 ]
        
        middleLine.addAnimation(middleAnimationRotation, forKey: "rotate")
        middleLine.addAnimation(middleAnimationScale, forKey: "scale")
        middleLine.setValue(button.selected ? 0 : M_PI, forKeyPath: "transform.rotation")
        middleLine.setValue(button.selected ? 1 : 0.1, forKeyPath: "transform.scale.x")
        
        // animate top line
        
        var topAnimationRotation = CAKeyframeAnimation(keyPath: "transform.rotation")
        topAnimationRotation.values = button.selected ? [ -M_PI*5/4, 0] :[ 0, -M_PI*5/4 ]
        topAnimationRotation.calculationMode = kCAAnimationCubic
        topAnimationRotation.keyTimes = [ 0, 0.33, 0.73, 1.0]
        
        var topAnimationPosition = CAKeyframeAnimation(keyPath: "position")
        topAnimationPosition.path = topPath!.CGPath
        topAnimationPosition.removedOnCompletion = false
        topAnimationPosition.fillMode = kCAFillModeForwards
        
        topLine.addAnimation(topAnimationPosition, forKey: "animation")
        topLine.addAnimation(topAnimationRotation, forKey: "animation2")
        topLine.setValue(button.selected ? 0 : -M_PI*5/4, forKeyPath: "transform.rotation")
        
        
        // animate bottom line
        
        var bottomAnimationRotation = CAKeyframeAnimation(keyPath: "transform.rotation")
        bottomAnimationRotation.values = button.selected ? [ M_PI*5/4, 0 ] : [ 0, M_PI*5/4]
        bottomAnimationRotation.calculationMode = kCAAnimationCubic
        bottomAnimationRotation.keyTimes = [ 0, 0.33, 0.73, 1.0]
        
        var bottomAnimationPosition = CAKeyframeAnimation(keyPath: "position")
        bottomAnimationPosition.path = bottomPath!.CGPath
        bottomAnimationPosition.removedOnCompletion = false
        bottomAnimationPosition.fillMode = kCAFillModeForwards
        
        bottomLine.addAnimation(bottomAnimationPosition, forKey: "animation")
        bottomLine.addAnimation(bottomAnimationRotation, forKey: "animation2")
        bottomLine.setValue(button.selected ? 0 : M_PI*5/4, forKeyPath: "transform.rotation")
        
        CATransaction.commit()
        
        button.selected = !button.selected
    }
}
