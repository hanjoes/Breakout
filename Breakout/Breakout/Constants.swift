//
//  Constants.swift
//  Breakout
//
//  Created by Hanzhou Shi on 1/18/16.
//  Copyright © 2016 USF. All rights reserved.
//

import UIKit

// MARK: - Constants

struct Constants {
    /// Brick related
    static let DefaultBrickNumPerRow: CGFloat = 10
    static let BrickAspectRatio: CGFloat = 2.5
    static let DefaultBrickLevels: CGFloat = 5
    static let DefaultBrickMarginX: CGFloat = 5
    static let DefaultBrickMarginY: CGFloat = 5
    static let DefaultBrickColor = UIColor.blueColor()
    /// Paddle related
    static let DefaultPaddleColor = UIColor.grayColor()
    static let DefaultPaddleWidthRatio: CGFloat = 6
    static let DefaultPaddleRatio: CGFloat = 5
    /// Ball related
    static let DefaultBallNum = 1
    static let DefaultBallNumMax = 10
    static let DefaultBallSize = CGSize(width: 10, height: 10)
    static let DefaultBallColor = UIColor.redColor()
}