//
//  BezierUIView.swift
//  Breakout
//
//  Created by Hanzhou Shi on 1/22/16.
//  Copyright © 2016 USF. All rights reserved.
//

import UIKit

class BezierUIView: UIView {
    
    override func drawRect(rect: CGRect) {
        for (_, path) in paths { path.draw() }
    }
    
    var paths = [String:CustomUIBezierPath]()
    
    func setPath(path: CustomUIBezierPath?, named name: String) {
        paths[name] = path
        setNeedsDisplay()
    }
    
    func removePath(name: String) {
        paths[name] = nil
        setNeedsDisplay()
    }
}