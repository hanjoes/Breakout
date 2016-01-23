//
//  BreakoutViewController.swift
//  Breakout
//
//  Created by Hanzhou Shi on 1/18/16.
//  Copyright © 2016 USF. All rights reserved.
//

import UIKit

class BreakoutViewController: UIViewController {
    @IBOutlet weak var gameScene: BezierUIView!
    
    @IBAction func panPaddle(sender: UIPanGestureRecognizer) {
        let gesturePoint = sender.locationInView(gameScene)
        
        switch sender.state {
        case .Changed:
            var origin = paddleFrame.origin
            origin.x = min(max(gesturePoint.x, 0), gameScene.bounds.width-paddleSize.width)
            shiftPaddleTo(origin)
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

        createBalls()
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
        layoutPaddle()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Paddle Delegate
    func updateBallsFrame(frame: CGRect) {
//        print("frame: \(frame)")
        layoutBalls()
    }

    // MARK: - Brick Related Properties

    private var balls = [Ball]()
    private var ballAttachments = [Ball:UIAttachmentBehavior]()
    
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
        let midX = gameScene.bounds.midX
        let x = midX - paddleSize.width / 2
        let y = gameScene.bounds.maxY - paddleSize.height
        let origin = CGPoint(x: x, y: y)
        return CGRect(origin: origin, size: paddleSize)
    }
    
    private var paddle: Paddle = Paddle(rect: CGRect.zero, color: Constants.DefaultPaddleColor) {
        willSet {
            updateBallsFrame(newValue.bounds)
        }
    }
    
    private var paddleSize: CGSize {
        let paddleWidth = gameScene.bounds.width / Constants.DefaultPaddleWidthRatio
        let paddleHeight = paddleWidth / Constants.DefaultPaddleRatio
        return CGSize(width: paddleWidth, height: paddleHeight)
    }

    // MARK: - UIDynamicBehavior Related Properties
    
    private var behavior = BreakoutBehavior()
    private lazy var animator: UIDynamicAnimator = {
        let lazilyCreatedAnimator = UIDynamicAnimator(referenceView: self.gameScene)
        return lazilyCreatedAnimator
    }()
    
    
    // MARK: - Helper functions
    
    private func createBalls() {
        let actualNum = max(min(numBalls, 10), 1)
        for _ in 0..<actualNum {
            let ball = Ball(frame: CGRect.zero, color: Constants.DefaultBallColor)
            balls.append(ball)
            gameScene.addSubview(ball)
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
            let brick = Brick(rect: frame, color: Constants.DefaultBrickColor)
            behavior.addBarrier(brick, named: identifier)
            gameScene.setPath(brick, named: identifier)
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
        let ballY = gameScene.bounds.height-paddleSize.height-ballScale
//        print("bounds: \(gameScene.bounds) ballX: \(ballX)")

        for ball in balls.filter({ (b) -> Bool in b.attached }) {
            let origin = CGPoint(x: ballX, y: ballY)
            let frame = CGRect(origin: origin, size: Constants.DefaultBallSize)
            ball.frame = frame

            // update the position for the next ball
            ballX += ballScale
        }
    }
    
    private func layoutPaddle() {
        paddle = Paddle(rect: paddleFrame, color: Constants.DefaultPaddleColor)
        gameScene.setPath(paddle, named: Constants.PaddleIdentifier)
        behavior.addBarrier(paddle, named: Constants.PaddleIdentifier)
    }
    
    private func shiftPaddleTo(origin: CGPoint) {
        paddle = Paddle(rect: CGRect(origin: origin, size: paddleSize), color: Constants.DefaultPaddleColor)
        gameScene.setPath(paddle, named: Constants.PaddleIdentifier)
        behavior.addBarrier(paddle, named: Constants.PaddleIdentifier)
    }
    
    private func gameStart() {
        // add all views to behavior
        shootBalls()
    }
    
    private func shootBalls() {
        for ball in balls {
            if !ball.attached { continue }
            
            behavior.addItem(ball)
            
            ball.attached = false
            
            let p = UIPushBehavior(items: [ball], mode: .Instantaneous)
            p.magnitude = 0.1
            p.angle = 10
            animator.addBehavior(p)
        }
    }
}

private extension UIView {
    func setPath() {
        
    }
}
