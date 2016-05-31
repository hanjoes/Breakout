//
//  BreakoutBehavior.swift
//  Breakout
//
//  Created by Hanzhou Shi on 1/18/16.
//  Copyright © 2016 USF. All rights reserved.
//

import UIKit

class BreakoutBehavior: UIDynamicBehavior {
    
    // MARK: Initializers
    
    override init() {
        super.init()
        addChildBehavior(collider)
        addChildBehavior(itemBehavior)
        addChildBehavior(gravity)
    }
	
	// MARK: Properties
    
    var collisionDelegate: UICollisionBehaviorDelegate? {
        didSet {
            if collisionDelegate != nil {
                collider.collisionDelegate = collisionDelegate
            }
        }
    }
	
	var pushMagnitude = Constants.DefaultPushMagnitude
	
    private lazy var collider: UICollisionBehavior = {
        let lazilyCreatedCollider = UICollisionBehavior()
        lazilyCreatedCollider.translatesReferenceBoundsIntoBoundary = true
        return lazilyCreatedCollider
    }()
    
    lazy var itemBehavior: UIDynamicItemBehavior = {
        let lazilyCreatedItemBehavior = UIDynamicItemBehavior()
        lazilyCreatedItemBehavior.elasticity = 1
        lazilyCreatedItemBehavior.friction = 0
        lazilyCreatedItemBehavior.resistance = 0
        lazilyCreatedItemBehavior.allowsRotation = false
        return lazilyCreatedItemBehavior
    }()
	
    private var gravity = UIGravityBehavior()
	
	
	// MARK: Methods
    
    func addItem(item: UIView) {
        collider.addItem(item)
        itemBehavior.addItem(item)
    }
    
    func removeItem(item: UIView) {
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
    
    func pushItem(item: UIView) {
		let pb = UIPushBehavior(items: [item], mode: .Instantaneous)
		pb.magnitude = pushMagnitude
        pb.angle = randomAngle()
		addChildBehavior(pb)
		
		pb.action = {
			self.removeChildBehavior(pb)
			pb.removeItem(item)
        }
    }
	
    private func randomAngle() -> CGFloat {
        return 10
    }
}
