//
//  LBFlatUIColor2ViewController.swift
//  BangDevLab
//
//  Created by Bang Nguyen on 14/07/2014.
//  Copyright (c) Năm 2014 Bang Nguyen. All rights reserved.
//

import UIKit
import QuartzCore

class LBFlatUIColor2ViewController: UITableViewController {
    
    var colorArr:[UIColor]?
    
    init(coder aDecoder: NSCoder!)  {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorArr = [
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
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        let cellIdentifier = "cell"
        var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        }
        
        if var count = colorArr?.count {
            var index = indexPath.row % count
            cell.contentView.backgroundColor = colorArr?[ index ]
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView!, willDisplayCell cell: UITableViewCell!, forRowAtIndexPath indexPath: NSIndexPath!) {
        
        var transform = CATransform3DIdentity
        transform.m34 = 1.0/500.0
        
        var scale = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 0.8
        scale.toValue = 1
        scale.duration = 0.5
        
        var rotate = CABasicAnimation(keyPath: "transform.rotation.x")
        rotate.fromValue = 1.5
        rotate.toValue = 0
        rotate.duration = 0.5
        
        var animate = CAAnimationGroup()
        animate.animations = [ scale, rotate ]
        animate.duration = 0.5
        
        cell.contentView.layer.addAnimation(animate, forKey: "animate")
        //cell.contentView.layer.speed = 0
        
        cell.contentView.layer.transform = transform
    }
}
