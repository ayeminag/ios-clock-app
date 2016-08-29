//
//  ClockView.swift
//  Clock
//
//  Created by Aye Min Aung on 8/30/16.
//  Copyright © 2016 Aye Min Aung. All rights reserved.
//

import UIKit
let π: CGFloat = CGFloat(M_PI)
let Origin: CGFloat = 3*π/2
let RadPerMin = 2 * π / 60.0
let RadPerHour = 2 * π / 12.0
@IBDesignable class ClockView: UIView {
    
    
    var currentDate: NSDate! = NSDate() {
        didSet {
            setup()
        }
    }
    
    var hour: CGFloat!
    var minute: CGFloat!
    var second: CGFloat!
    
    var hourAngle: CGFloat!
    var minuteAngle: CGFloat!
    var secondAngle: CGFloat!
    var timer: NSTimer?
    
    @IBInspectable weak var dialColor: UIColor! = UIColor.greenColor()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        let diameter = min(bounds.width, bounds.height)
        let center = CGPointMake(bounds.width/2.0, bounds.height/2.0)
        
        let dialPath = UIBezierPath(arcCenter: center, radius: diameter/2 - 20, startAngle: 0.0, endAngle: 2 * CGFloat(M_PI), clockwise: true)
        dialColor.setFill()
        dialPath.fill()
        
        CGContextSaveGState(context)
        //Translate Context to make the origin equl to current center
        CGContextTranslateCTM(context, center.x, center.y)
        
        //Saving Translated Context
        CGContextSaveGState(context)
        //Rotating to hour angle
        CGContextRotateCTM(context, hourAngle)
        let hourArm = UIBezierPath()
        hourArm.moveToPoint(CGPoint(x: -5.0, y: 0.0))
        hourArm.addLineToPoint(CGPoint(x: 0.0, y: -15.0))
        hourArm.addLineToPoint(CGPoint(x: 5.0, y: 0.0))
        hourArm.addLineToPoint(CGPoint(x: 0.0, y: diameter/3))
        hourArm.closePath()
        UIColor.blackColor().setStroke()
        hourArm.stroke()
        CGContextRestoreGState(context)
        
        
        CGContextSaveGState(context)
        //Rotating to hour angle
        CGContextRotateCTM(context, minuteAngle)
        let minArm = UIBezierPath()
        minArm.moveToPoint(CGPoint(x: -5.0, y: 0.0))
        minArm.addLineToPoint(CGPoint(x: 0.0, y: -15.0))
        minArm.addLineToPoint(CGPoint(x: 5.0, y: 0.0))
        minArm.addLineToPoint(CGPoint(x: 0.0, y: diameter/2 - 30))
        minArm.closePath()
        UIColor.redColor().setStroke()
        minArm.stroke()
        CGContextRestoreGState(context)
        
        CGContextSaveGState(context)
        CGContextRotateCTM(context, secondAngle)
        let secondArm = UIBezierPath()
        secondArm.moveToPoint(CGPoint(x: 0.0, y: -10.0))
        secondArm.addLineToPoint(CGPoint(x: 0.0, y: diameter/2 - 30))
        UIColor.brownColor().setStroke()
        secondArm.stroke()
        CGContextRestoreGState(context)
        
        let markerPath = UIBezierPath(rect:
            CGRect(x: -5.0/2,
                y: 0,
                width: 5.0,
                height: 15.0))
        for i in 1...12 {
            //4 - save the centred context
            CGContextSaveGState(context)
            
            //5 - calculate the rotation angle
            let angle = RadPerHour * CGFloat(i) + Origin - π/2
            
            //rotate and translate
            CGContextRotateCTM(context, angle)
            CGContextTranslateCTM(context,
                                  0,
                                  diameter/2 - 36)
            
            //6 - fill the marker rectangle
            UIColor.blackColor().setFill()
            markerPath.fill()
            
            //7 - restore the centred context for the next rotate
            CGContextRestoreGState(context)
        }
        
        let minMarkerPath = UIBezierPath(rect:
            CGRect(x: -1.0,
                y: 0,
                width: 2.0,
                height: 10.0))
        
        for i in 1...60 {
            //4 - save the centred context
            CGContextSaveGState(context)
            
            //5 - calculate the rotation angle
            let angle = RadPerMin * CGFloat(i) + Origin - π/2
            
            //rotate and translate
            CGContextRotateCTM(context, angle)
            CGContextTranslateCTM(context,
                                  0,
                                  diameter/2 - 31)
            
            //6 - fill the marker rectangle
            UIColor.blackColor().setFill()
            minMarkerPath.fill()
            
            //7 - restore the centred context for the next rotate
            CGContextRestoreGState(context)
        }
        let circle = UIBezierPath(arcCenter: CGPoint(x: 0.0, y: 0.0), radius: 5.0, startAngle: 0.0, endAngle: 2 * π, clockwise: true)
        UIColor.yellowColor().setFill()
        circle.fill()
        CGContextRestoreGState(context)
    }
    
    func setup() {
        timer?.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ClockView.updatetime), userInfo: nil, repeats: true)
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components([.Hour, .Minute, .Second], fromDate: currentDate)
        self.minute = CGFloat(integerLiteral: dateComponents.minute)
        let comphour = dateComponents.hour > 11 ? dateComponents.hour / 12 : dateComponents.hour
        self.hour = CGFloat(integerLiteral: comphour) + self.minute/60
        self.hourAngle = Origin + RadPerHour * self.hour - π/2
        self.minuteAngle = Origin + RadPerMin * self.minute - π/2
        self.second = CGFloat(integerLiteral: dateComponents.second)
        self.secondAngle = Origin + RadPerMin * self.second - π/2
        setNeedsDisplay()
    }
    
    func updatetime() {
        currentDate = NSDate()
    }
}
