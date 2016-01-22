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
    }
    
    func addItem(item: UIView) {
        collider.addItem(item)
        itemBehavior.addItem(item)
    }
    
    func removeItem(item: UIView) {
        collider.removeItem(item)
        itemBehavior.removeItem(item)
    }
    
    func addBall(ball: UIView) {
        collider.addItem(ball)
    }
    
    func addPaddle(paddle: UIView) {
        collider.addItem(paddle)
    }

    // MARK: - Private
    
    private lazy var collider: UICollisionBehavior = {
        let lazilyCreatedCollider = UICollisionBehavior()
        lazilyCreatedCollider.translatesReferenceBoundsIntoBoundary = true
        return lazilyCreatedCollider
    }()
    
    private lazy var itemBehavior: UIDynamicItemBehavior = {
        let lazilyCreatedItemBehavior = UIDynamicItemBehavior()
        lazilyCreatedItemBehavior.elasticity = 1
        lazilyCreatedItemBehavior.allowsRotation = false
        return lazilyCreatedItemBehavior
    }()
    
}
