//
//  CustomUIBezierPath.swift
//  Breakout
//
//  Created by Hanzhou Shi on 1/22/16.
//  Copyright © 2016 USF. All rights reserved.
//

import UIKit


class CustomUIBezierPath: UIBezierPath {
    
    enum CustomUIBezierPathType {
        case FillType
        case LineType
    }
    
    var fillColor: UIColor = UIColor.whiteColor()
    var strokeColor: UIColor = UIColor.blackColor()
    var pathType = CustomUIBezierPathType.FillType
    
    var beginPoint: CGPoint?
    var endPoint: CGPoint?
    
    convenience init(rect: CGRect, color: UIColor) {
        self.init()
        self.init(rect: rect)
        
        fillColor = color
    }
    
    convenience init(type: CustomUIBezierPathType, from: CGPoint, to: CGPoint) {
        self.init()
        
        pathType = type
        beginPoint = from
        endPoint = to
    }
    
    func draw() {
        switch self.pathType {
        case .FillType:
            fillColor.setFill()
            self.fill()
        case .LineType:
            self.moveToPoint(beginPoint!)
            self.addLineToPoint(endPoint!)
            strokeColor.setStroke()
            self.stroke()
        }
    }
    
}
