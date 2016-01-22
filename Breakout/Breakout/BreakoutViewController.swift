//
//  BreakoutViewController.swift
//  Breakout
//
//  Created by Hanzhou Shi on 1/18/16.
//  Copyright © 2016 USF. All rights reserved.
//

import UIKit

class BreakoutViewController: UIViewController, PaddleDelegate {
    @IBOutlet weak var gameView: UIView!
    
    @IBAction func panPaddle(sender: UIPanGestureRecognizer) {
        let gesturePoint = sender.locationInView(gameView)
        
        switch sender.state {
        case .Changed:
            var origin = paddle.frame.origin
            origin.x = min(max(gesturePoint.x, 0), gameView.bounds.width-paddleSize.width)
            shiftPaddleTo(origin)
        default: break
        }
    }
    
    @IBAction func shoot(sender: UITapGestureRecognizer) {
    }
    
    // MARK: - API
    
    let numBricksPerRow = Int(Constants.DefaultBrickNumPerRow)
    let numBrickLevels = Int(Constants.DefaultBrickLevels)
    let numBalls = Constants.DefaultBallNum
    var gameInProgress = false

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBricks()
        createBalls()
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
        layoutBalls()
        
        animator.addBehavior(brickBehavior)
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

    private var bricks = [Brick]()
    private var balls = [Ball]()
    private var ballAttachments = [Ball:UIAttachmentBehavior]()
    
    /// width * num + (num - 1) * margin = frameSize
    /// width = (frameSize - (num-1) * margin) / num
    private var brickSize: CGSize {
        let boundSize = gameView.bounds.width
        let width = (boundSize - (CGFloat(numBricksPerRow-1)) * Constants.DefaultBrickMarginX) / CGFloat(numBricksPerRow)
        let height = width / Constants.BrickAspectRatio
        return CGSize(width: width, height: height)
    }

    // MARK: - Paddle Related Properties
    
    private lazy var paddle: Paddle = {
        let paddle = Paddle(frame: CGRect.zero, color: Constants.DefaultPaddleColor)
        paddle.delegate = self
        return paddle
    }()
    
    private var paddleSize: CGSize {
        let paddleWidth = gameView.bounds.width / Constants.DefaultPaddleWidthRatio
        let paddleHeight = paddleWidth / Constants.DefaultPaddleRatio
        return CGSize(width: paddleWidth, height: paddleHeight)
    }

    // MARK: - UIDynamicBehavior Related Properties
    
    private var brickBehavior = BrickBehavior()
    private lazy var animator: UIDynamicAnimator = {
        let lazilyCreatedAnimator = UIDynamicAnimator(referenceView: self.gameView)
        return lazilyCreatedAnimator
    }()
    
    
    // MARK: - Helper functions
    
    private func createBalls() {
        let actualNum = max(min(numBalls, 10), 1)
        for _ in 0..<actualNum {
            let ball = Ball(frame: CGRect.zero, color: Constants.DefaultBallColor)
            balls.append(ball)
            ball.attachedPaddle = paddle
            gameView.addSubview(ball)
        }
    }
    
    private func createBricks() {
        // create bricks only if there are no bricks
        guard bricks.count == 0 else { return }
        for _ in 0..<(numBricksPerRow*numBrickLevels) {
            let brick = Brick(frame: CGRect.zero, color: Constants.DefaultBrickColor)
            bricks.append(brick)
            gameView.addSubview(brick)
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
            let brick = bricks[rowNum*numBricksPerRow+offset]
            brick.frame = frame
        }
    }
    
    private var firstOffsetXForBalls: CGFloat {
        let ballsCount = CGFloat(balls.count)
        let totalWidth = ballsCount*Constants.DefaultBallSize.width
        let offset = (paddleSize.width - totalWidth) / 2
        
        return paddle.frame.minX + offset
    }
    
    private func layoutBalls() {
        let ballScale = Constants.DefaultBallSize.width
        var ballX = firstOffsetXForBalls
        let ballY = gameView.bounds.height-paddleSize.height-ballScale
//        print("bounds: \(gameView.bounds) ballX: \(ballX)")
        for ball in balls.filter({ (b) -> Bool in b.attached }) {
            let origin = CGPoint(x: ballX, y: ballY)
            let frame = CGRect(origin: origin, size: Constants.DefaultBallSize)
            ball.frame = frame
            
            // update the position for the next ball
            ballX += ballScale
        }
    }
    
    private func layoutPaddle() {
        let midX = self.gameView.bounds.midX
        let x = midX - self.paddleSize.width / 2
        let y = self.gameView.bounds.maxY - self.paddleSize.height
        let origin = CGPoint(x: x, y: y)
        paddle.frame = CGRect(origin: origin, size: paddleSize)
        gameView.addSubview(paddle)
    }
    
    private func shiftPaddleTo(origin: CGPoint) {
        paddle.frame = CGRect(origin: origin, size: paddleSize)
    }
}
