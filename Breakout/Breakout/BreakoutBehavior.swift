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
    
    func addBarrier(path: UIBezierPath, named name: String) {
        collider.removeBoundaryWithIdentifier(name)
        collider.addBoundaryWithIdentifier(name, forPath: path)
    }
    
    func removeBarrier(identifier: String) {
        collider.removeBoundaryWithIdentifier(identifier)
    }
    
    var collisionDelegate: UICollisionBehaviorDelegate? {
        didSet {
            if collisionDelegate != nil {
                collider.collisionDelegate = collisionDelegate
            }
        }
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
        lazilyCreatedItemBehavior.friction = 0
        lazilyCreatedItemBehavior.resistance = 0
        lazilyCreatedItemBehavior.allowsRotation = false
        return lazilyCreatedItemBehavior
    }()
    
    private var gravity = UIGravityBehavior()
}
