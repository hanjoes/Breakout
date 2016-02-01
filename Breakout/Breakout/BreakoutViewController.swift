//
//  BreakoutViewController.swift
//  Breakout
//
//  Created by Hanzhou Shi on 1/18/16.
//  Copyright © 2016 USF. All rights reserved.
//

import UIKit

class BreakoutViewController: UIViewController, UICollisionBehaviorDelegate {
    @IBOutlet weak var gameScene: BezierUIView!
    
    @IBAction func panPaddle(sender: UIPanGestureRecognizer) {
        let gesturePoint = sender.locationInView(gameScene)
        
        switch sender.state {
        case .Changed:
            var origin = paddleFrame.origin
            origin.x = min(max(gesturePoint.x, 0), gameScene.bounds.width-paddleSize.width)
            paddleFrame = CGRect(origin: origin, size: paddleSize)
        default: break
        }
    }
    
    @IBAction func shoot(sender: UITapGestureRecognizer) {
        gameStart()
    }
    
    // MARK: - API
    
    let numBricksPerRow = Int(Constants.DefaultBrickNumPerRow)
    let numBrickLevels = Int(Constants.DefaultBrickLevels)
    let numBalls = Constants.DefaultBallNum
    var gameInProgress = false

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        behavior.collisionDelegate = self
        createBalls()
        createBricks()
        animator.addBehavior(behavior)
    }
    
    override func viewDidLayoutSubviews() {
        // setup game scene after all predefined subviews 
        // are settled.
        super.viewDidLayoutSubviews()

        // put bricks and paddle into their expected position
        // we layout bricks and do the setup here because in a
        // TabBarController we need to implement viewDidLayoutSubviews
        // in an idempotent way.
        layoutBricks()
        layoutPaddle(paddleFrame)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Collision Delegate
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint) {
        if let id = identifier as? String {
            switch id {
            case Constants.PaddleIdentifier: break // collides on the paddle
            case Constants.LowerBoundIdentifier: restart()
            default: // collides on the brick
                removeBrickFromView(id)
                break
            }
        }
    }
    
    private var balls = [Ball]()
    private var bricks = [String:Brick]()

    // MARK: - Brick Related Properties
    
    /// width * num + (num - 1) * margin = frameSize
    /// width = (frameSize - (num-1) * margin) / num
    private var brickSize: CGSize {
        let boundSize = gameScene.bounds.width
        let width = (boundSize - (CGFloat(numBricksPerRow-1)) * Constants.DefaultBrickMarginX) / CGFloat(numBricksPerRow)
        let height = width / Constants.BrickAspectRatio
        return CGSize(width: width, height: height)
    }

    // MARK: - Paddle Related Properties
    
    private var paddleFrame: CGRect {
        get {
            let midX = gameScene.bounds.midX
            let x = midX - paddleSize.width / 2
            let y = lowerBoundY - paddleSize.height
            let origin = CGPoint(x: x, y: y)
            return CGRect(origin: origin, size: paddleSize)
        }
        
        set {
            layoutPaddle(newValue)
        }
    }
    
    private var paddle: Paddle = Paddle(rect: CGRect.zero, color: Constants.DefaultPaddleColor) {
        didSet {
            updateBallsFrame()
            updateLowerBound()
        }
    }
    
    private var paddleSize: CGSize {
        let paddleWidth = gameScene.bounds.width / Constants.DefaultPaddleWidthRatio
        let paddleHeight = paddleWidth / Constants.DefaultPaddleRatio
        return CGSize(width: paddleWidth, height: paddleHeight)
    }
    
    // MARK: - Lower Bound Related
    
    private var lowerBound = CGRect(origin: CGPoint.zero, size: CGSize.zero)
    
    private var lowerBoundY: CGFloat {
        return gameScene.bounds.maxY - gameScene.bounds.maxY / Constants.DefaultLowerBoundHeightRatio
    }

    // MARK: - UIDynamicBehavior Related Properties
    
    private var behavior = BreakoutBehavior()
    private lazy var animator: UIDynamicAnimator = {
        let lazilyCreatedAnimator = UIDynamicAnimator(referenceView: self.gameScene)
        return lazilyCreatedAnimator
    }()
    
    
    // MARK: - Helper functions
    
    private func createBricks() {
        // create bricks only if there are no bricks
        guard bricks.count == 0 else { return }
        for index in 0..<(numBricksPerRow*numBrickLevels) {
            let identifier = Constants.BrickIdentifierPrefix + "\(index)"
            let brick = Brick(frame: CGRect.zero, color: Constants.DefaultBrickColor)
            bricks[identifier] = brick
        }
    }
    
    private func createBalls() {
        let actualNum = max(min(numBalls, 10), 1)
        for _ in 0..<actualNum {
            let ball = Ball(frame: CGRect.zero, color: Constants.DefaultBallColor)
            balls.append(ball)
            ball.attachedPaddle = paddle
        }
    }
    
    private func layoutBricks() {
        for rowNum in 0..<numBrickLevels {
            layoutBricksAtRow(rowNum)
        }
    }
    
    private func layoutBricksAtRow(rowNum: Int) {
        for offset in 0..<Int(numBricksPerRow) {
            let x = CGFloat(offset)*(brickSize.width + Constants.DefaultBrickMarginX)
            let y = CGFloat(rowNum)*(brickSize.height + Constants.DefaultBrickMarginY)
            let origin = CGPoint(x: x, y: y)
            let frame = CGRect(origin: origin, size: brickSize)
            
            let identifier = Constants.BrickIdentifierPrefix + "\(offset + rowNum * numBricksPerRow)"
            // make sure that the path exists
            if let brick = bricks[identifier] {
                if brick.alpha != 0.0 {
                    brick.frame = frame
                    gameScene.addSubview(brick)
                    behavior.addBarrier(brick.boundary, named: identifier)
                }
            }
        }
    }
    
    private var firstOffsetXForBalls: CGFloat {
        let ballsCount = CGFloat(balls.count)
        let totalWidth = ballsCount*Constants.DefaultBallSize.width
        let offset = (paddleSize.width - totalWidth) / 2
        return paddle.bounds.minX + offset
    }
    
    private func layoutBalls() {
        let ballScale = Constants.DefaultBallSize.width
        var ballX = firstOffsetXForBalls
        let ballY = lowerBoundY-paddleSize.height-ballScale
//        print("bounds: \(gameScene.bounds) ballX: \(ballX)")

        for ball in balls.filter({ (b) -> Bool in b.attached }) {
            let origin = CGPoint(x: ballX, y: ballY)
            let frame = CGRect(origin: origin, size: Constants.DefaultBallSize)
            ball.frame = frame
            gameScene.addSubview(ball)
            // update the position for the next ball
            ballX += ballScale
        }
    }
    
    private func layoutLowerBound() {
        let from = CGPoint(x: gameScene.bounds.minX, y: lowerBoundY)
        lowerBound = CGRect(origin: from, size: CGSize(width: gameScene.bounds.width, height: 1))
        let path = CustomUIBezierPath(rect: lowerBound)
        path.fillColor = Constants.DefaultLowerBoundColor
        gameScene.setPath(path, named: Constants.LowerBoundIdentifier)
        behavior.addBarrier(path, named: Constants.LowerBoundIdentifier)
    }
    
    private func layoutPaddle(rect: CGRect) {
        paddle = Paddle(rect: rect, color: Constants.DefaultPaddleColor)
        gameScene.setPath(paddle, named: Constants.PaddleIdentifier)
        behavior.addBarrier(paddle, named: Constants.PaddleIdentifier)
    }
    
    private func gameStart() {
        // add all views to behavior
        shootBalls()
    }
    
    private func shootBalls() {
        for ball in balls {
            ball.attached = false
            // we actually shoot the ball here
            behavior.pushItem(ball)
        }
    }
    
    private func updateBallsFrame() {
//        print("frame: \(frame)")
        layoutBalls()
    }
    
    private func updateLowerBound() {
        layoutLowerBound()
    }
    
    private func removeBrickFromView(id: String) {
//        print("removing barrier for id: \(id)")
        if let brick = bricks[id] {
            behavior.removeBarrier(id)
            UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut,
                animations: { brick.alpha = 0.0 },
                completion: { if $0 {  } })
        }
    }
    
    private func restart() {
        // reset all bricks meaning they will appear and become barriers again.
        for index in 0..<(numBricksPerRow*numBrickLevels) {
            let identifier = Constants.BrickIdentifierPrefix + "\(index)"
            if let brick = bricks[identifier] {
                behavior.addBarrier(brick.boundary, named: identifier)
                brick.alpha = 1.0
            }
        }
        
        // reset balls status such that they will be "re-attached" to paddle.
        let _ = balls.map {
            behavior.removeItem($0)
            $0.attached = true
        }
        
        // this will trigger balls' re-attachment.
        layoutPaddle(paddleFrame)
    }
    
}
