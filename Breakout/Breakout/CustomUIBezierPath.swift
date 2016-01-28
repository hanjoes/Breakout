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
    
    convenience init(rect: CGRect, color: UIColor) {
        self.init()
        self.init(rect: rect)
        
        fillColor = color
    }
    
    convenience init(type: CustomUIBezierPathType) {
        self.init()
        
        pathType = type
    }
    
    func draw() {
        switch self.pathType {
        case .FillType:
            fillColor.setFill()
            self.fill()
        case .LineType:
            strokeColor.setStroke()
            self.stroke()
        }
    }
    
}
