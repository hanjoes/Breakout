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
        dynamicAnimator?.referenceView?.addSubview(item)
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
//        print("adding barrier: \(name)")
        collider.removeBoundaryWithIdentifier(name)
        collider.addBoundaryWithIdentifier(name, forPath: path)
    }
    
    func removeBarrier(identifier: String) {
        collider.removeBoundaryWithIdentifier(identifier)
    }
    
    func pushItem(item: UIView) {
        addItem(item)

        let push = UIPushBehavior(items: [], mode: .Instantaneous)
        push.magnitude = Constants.DefaultPushMagnitude
        push.angle = randomAngle()
        push.addItem(item)
        
        addChildBehavior(push)
        push.action = {
            [unowned self] in
            push.removeItem(item)
            self.removeChildBehavior(push)
        }
    }
    
    var collisionDelegate: UICollisionBehaviorDelegate? {
        didSet {
            if collisionDelegate != nil {
                collider.collisionDelegate = collisionDelegate
            }
        }
    }
    
    // MARK: - Private
    
    private func randomAngle() -> CGFloat {
        return 10
    }
    
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
