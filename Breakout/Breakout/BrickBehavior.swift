//
//  BreakoutBehavior.swift
//  Breakout
//
//  Created by Hanzhou Shi on 1/18/16.
//  Copyright © 2016 USF. All rights reserved.
//

import UIKit

class BrickBehavior: UIDynamicBehavior {
    
    // MARK: - API
    
    override init() {
        super.init()
        addChildBehavior(gravity)
    }
    
    func addItem(item: UIView) {
        gravity.addItem(item)
    }

    // MARK: - Private
    
    private var gravity = UIGravityBehavior()
}
