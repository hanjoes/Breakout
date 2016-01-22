//
//  BreakoutBehavior.swift
//  Breakout
//
//  Created by Hanzhou Shi on 1/18/16.
//  Copyright © 2016 USF. All rights reserved.
//

import UIKit

class BreakoutBehavior: UIDynamicBehavior {
    
    // MARK: - API
    
    override init() {
        super.init()
        addChildBehavior(collider)
        addChildBehavior(itemBehavior)
        addChildBehavior(gravity)
    }
    
    func addItem(item: UIView) {
//        gravity.addItem(item)
        collider.addItem(item)
        itemBehavior.addItem(item)
    }
    
    func removeItem(item: UIView) {
//        gravity.removeItem(item)
        collider.removeItem(item)
        itemBehavior.removeItem(item)
        item.removeFromSuperview()
    }
    
    func addBall(ball: Ball) {
        collider.addItem(ball)
        itemBehavior.addItem(ball)
    }
    
    func addPaddle(paddle: Paddle) {
        collider.addItem(paddle)
    }

    // MARK: - Private
    
    private lazy var collider: UICollisionBehavior = {
        let lazilyCreatedCollider = UICollisionBehavior()
        lazilyCreatedCollider.translatesReferenceBoundsIntoBoundary = true
//        lazilyCreatedCollider.addBoundaryWithIdentifier(<#T##identifier: NSCopying##NSCopying#>, forPath: <#T##UIBezierPath#>)
        return lazilyCreatedCollider
    }()
    
    private lazy var itemBehavior: UIDynamicItemBehavior = {
        let lazilyCreatedItemBehavior = UIDynamicItemBehavior()
        lazilyCreatedItemBehavior.elasticity = 1
        lazilyCreatedItemBehavior.friction = 0
        lazilyCreatedItemBehavior.allowsRotation = false
        return lazilyCreatedItemBehavior
    }()
    
    private var gravity = UIGravityBehavior()
}
