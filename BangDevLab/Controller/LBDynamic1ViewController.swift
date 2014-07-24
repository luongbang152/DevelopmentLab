//
//  LBDynamic1ViewController.swift
//  BangDevLab
//
//  Created by Bang Nguyen on 15/07/2014.
//  Copyright (c) Năm 2014 Bang Nguyen. All rights reserved.
//

import UIKit
import CoreMotion

class LBDynamic1ViewController: UIViewController, UICollisionBehaviorDelegate {
    
    var _animator : UIDynamicAnimator?
    var _gravity : UIGravityBehavior?
    var _collision : UICollisionBehavior?
    var _objectBehavior : UIDynamicItemBehavior?
    var _motionManager : CMMotionManager?
    var _motionQueue : NSOperationQueue?
    var _colorArr : [UIColor]?
    
    init(coder aDecoder: NSCoder!)  {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        
        _colorArr = [
            UIColor.flatTurquoiseColor(),   UIColor.flatGreenSeaColor(),
            UIColor.flatEmeraldColor(),     UIColor.flatNephritisColor(),
            UIColor.flatPeterRiverColor(),  UIColor.flatBelizeHoleColor(),
            UIColor.flatAmethystColor(),    UIColor.flatWisteriaColor(),
            UIColor.flatWetAsphaltColor(),  UIColor.flatMidNightColor(),
            UIColor.flatSunFlowerColor(),   UIColor.flatOrangeColor(),
            UIColor.flatCarrotColor(),      UIColor.flatPumpkinColor(),
            UIColor.flatAlizarinColor(),    UIColor.flatPomegranateColor(),
            UIColor.flatCloudColor(),       UIColor.flatSilverColor(),
            UIColor.flatConcreteColor(),    UIColor.flatAsbestosColor()
        ]
        
        var object = UIView(frame: CGRectMake(0, 0, 20, 20))
        object.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.height/3)
        object.backgroundColor = _colorArr![Int(rand())%_colorArr!.count]
        object.layer.cornerRadius = 10
        
        self.view.addSubview(object)
        
        var wall = UIView(frame: CGRectMake(0, 250, 150, 20))
        wall.backgroundColor = _colorArr![Int(rand())%_colorArr!.count]
        
        var wall2 = UIView(frame: CGRectMake(self.view.bounds.width-150, 350, 150, 20))
        wall2.backgroundColor = _colorArr![Int(rand())%_colorArr!.count]
        
        self.view.addSubview(wall)
        self.view.addSubview(wall2)
        
        _animator = UIDynamicAnimator(referenceView: self.view)
        
        _gravity = UIGravityBehavior(items: [object])
        _gravity!.magnitude = 50
        _animator?.addBehavior(_gravity)
        
        _collision = UICollisionBehavior(items: [object])
        
        _collision?.addBoundaryWithIdentifier("wall", fromPoint: wall.frame.origin, toPoint: CGPointMake(wall.frame.origin.x + wall.frame.size.width, wall.frame.origin.y))
        _collision?.addBoundaryWithIdentifier("wall2", fromPoint: CGPointMake(wall.frame.origin.x, wall.frame.origin.y + wall.frame.size.height), toPoint: CGPointMake(wall.frame.origin.x + wall.frame.size.width, wall.frame.origin.y + wall.frame.size.height))
        
        _collision?.addBoundaryWithIdentifier("wall3", fromPoint: wall2.frame.origin, toPoint: CGPointMake(wall2.frame.origin.x + wall2.frame.size.width, wall2.frame.origin.y))
        _collision?.addBoundaryWithIdentifier("wall4", fromPoint: CGPointMake(wall2.frame.origin.x, wall2.frame.origin.y + wall2.frame.size.height), toPoint: CGPointMake(wall2.frame.origin.x + wall2.frame.size.width, wall2.frame.origin.y + wall2.frame.size.height))
        
        _collision?.setTranslatesReferenceBoundsIntoBoundaryWithInsets(UIEdgeInsetsZero)
        
        _animator?.addBehavior(_collision)
        
        _objectBehavior = UIDynamicItemBehavior(items: [object])
        _objectBehavior!.elasticity = 0.7
        _animator?.addBehavior(_objectBehavior)
        
        _collision!.collisionDelegate = self
        
        
        var tap = UITapGestureRecognizer(target: self, action: "tapHandle:")
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(tap)
        
        _motionQueue = NSOperationQueue()
        _motionQueue!.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount
        
        _motionManager = CMMotionManager()
        var weakGravity = _gravity
        _motionManager?.startDeviceMotionUpdatesToQueue(_motionQueue, withHandler: { (data: CMDeviceMotion!, error: NSError!) in
            var gravity = data.gravity
            dispatch_async(dispatch_get_main_queue(), {
                weakGravity!.gravityDirection = CGVectorMake(CGFloat(gravity.x), -CGFloat(gravity.y))
            })
        })
    }
    
    func collisionBehavior(behavior: UICollisionBehavior!, beganContactForItem item: UIDynamicItem!, withBoundaryIdentifier identifier: NSCopying!, atPoint p: CGPoint) {
//        var view = item as UIView
//        var _colorArr = self._colorArr
//        UIView.animateWithDuration(1, animations: ({
//            view.backgroundColor = _colorArr![Int(rand())%_colorArr!.count]
//        }))
    }
    
    func tapHandle(gesture: UITapGestureRecognizer?) {
        var location = gesture?.locationInView(gesture!.view)
        
        var object = UIView(frame: CGRectMake(location!.x, location!.y, 20, 20))
        object.backgroundColor = _colorArr![Int(rand())%_colorArr!.count]
        object.layer.cornerRadius = 10
        
        self.view.addSubview(object)
        
        _collision?.addItem(object)
        _gravity?.addItem(object)
        _objectBehavior?.addItem(object)
    }
}
