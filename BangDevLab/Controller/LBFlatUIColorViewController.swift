//
//  LBFlatUIColorViewController.swift
//  BangDevLab
//
//  Created by Bang Nguyen on 14/07/2014.
//  Copyright (c) Năm 2014 Bang Nguyen. All rights reserved.
//

import UIKit
import QuartzCore

class LBFlatUIColorViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var _scrollView : UIScrollView!
    
    init(coder aDecoder: NSCoder!)  {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        var colorArr = [
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
        
        var lastPos : CGFloat = self.view.bounds.width/2
        
        for var i = 0; i < colorArr.count; i++ {
            
            var view = UIView(frame: CGRectMake(0, 0, 280, 400))
            view.center = CGPointMake(lastPos, self.view.bounds.height/2)
            view.tag = i+1
            view.backgroundColor = colorArr[i]
            view.layer.cornerRadius = 8
            
            var scale = CABasicAnimation(keyPath: "transform.scale")
            scale.fromValue = 1
            scale.toValue = 0.5
            scale.duration = 1
            
            var rotate = CABasicAnimation(keyPath: "transform.rotation")
            rotate.fromValue = 0
            rotate.toValue = -2
            rotate.duration = 1
            
            var animation = CAAnimationGroup()
            animation.animations = [ scale, rotate ]
            animation.duration = 1
            
            view.layer.addAnimation(animation, forKey: "animate")
            view.layer.speed = 0
            
            _scrollView.addSubview(view)
            lastPos += self.view.bounds.width
        }
        
        _scrollView.contentSize = CGSizeMake(self.view.bounds.width * CGFloat(colorArr.count), self.view.bounds.height)
        
        self.view.backgroundColor = UIColor.whiteColor()
        _scrollView.backgroundColor = UIColor.clearColor()
        _scrollView.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView!) {
        
        // get index
        var index = Int(scrollView.contentOffset.x / self.view.bounds.width)
        var view = scrollView.viewWithTag(index+1)
        view.layer.timeOffset = CFTimeInterval( abs( (scrollView.contentOffset.x - self.view.bounds.width * CGFloat(index)) / self.view.bounds.width ) )
    }
}
