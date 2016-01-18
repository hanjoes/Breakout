//
//  BreakoutViewController.swift
//  Breakout
//
//  Created by Hanzhou Shi on 1/18/16.
//  Copyright © 2016 USF. All rights reserved.
//

import UIKit

class BreakoutViewController: UIViewController {
    @IBOutlet weak var gameView: UIView!
    
    // MARK: - Properties
    
    let numBricksPerRow = Constants.DefaultBrickNumPerRow
    /// width * num + (num - 1) * margin = frameSize
    /// width = (frameSize - (num-1) * margin) / num
    var brickSize: CGSize {
        let boundSize = gameView.bounds.width
        let width = (boundSize - (numBricksPerRow-1) * Constants.DefaultBrickMarginX) / numBricksPerRow
        let height = width / Constants.BrickAspectRatio
        return CGSize(width: width, height: height)
    }
    
    var bricks = [Brick]()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        // setup game scene after all predefined subviews 
        // are settled.
        layoutBricks()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Private Methods
    
    private func layoutBricks() {
        for rowNum in 0..<Constants.DefaultBrickLevels {
            layoutBrickAtRow(rowNum)
        }
    }
    
    private func layoutBrickAtRow(rowNum: Int) {
        for offset in 0..<Int(numBricksPerRow) {
            let x = CGFloat(offset)*(brickSize.width + Constants.DefaultBrickMarginX)
            let y = CGFloat(rowNum)*(brickSize.height + Constants.DefaultBrickMarginY)
            let origin = CGPoint(x: x, y: y)
            let frame = CGRect(origin: origin, size: brickSize)
            addBrick(Brick(frame: frame, color: UIColor.redColor()))
        }
    }
    
    private func addBrick(brick: Brick) {
        gameView.addSubview(brick)
        bricks.append(brick)
    }
    
    // MARK: - Constants
    
    private struct Constants {
        static let DefaultBrickNumPerRow: CGFloat = 10
        static let BrickAspectRatio: CGFloat = 2.5
        static let DefaultBrickLevels = 5
        static let DefaultBrickMarginX: CGFloat = 5
        static let DefaultBrickMarginY: CGFloat = 5
    }
}
