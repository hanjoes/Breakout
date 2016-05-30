//
//  BreakoutSettingViewController.swift
//  Breakout
//
//  Created by Hanzhou Shi on 5/30/16.
//  Copyright © 2016 USF. All rights reserved.
//

import UIKit

class BreakoutSettingViewController: UIViewController {
	
	// MARK: Constants
	
	private struct Constants {
		static let BallSpeedDefaultKey = "Breakout.BallSpeed"
		static let NumberOfBallsDefaultKey = "Breakout.NumberOfBalls"
		static let BouncinessDefaultKey = "Breakout.Bounciness"
		static let PadSpeedDefaultKey = "Breakout.PadSpeed"
		
		static let BallSpeedDefaultValue = 1.0
		static let NumberOfBallsDefaultValue = 1.0
		static let BouncinessDefaultValue = 1.0
		static let PadSpeedDefaultValue = 1.0
	}
	
	// MARK: Actions/Outlets

	@IBOutlet weak var ballSpeedLabel: UILabel!
	
	@IBOutlet weak var numberOfBallsLabel: UILabel!
	
	@IBOutlet weak var bouncinessLabel: UILabel!
	
	@IBOutlet weak var padSpeedLabel: UILabel!
	
	@IBOutlet weak var ballSpeedStepper: UIStepper!
	
	@IBOutlet weak var numberOfBallsStepper: UIStepper!
	
	@IBOutlet weak var bouncinessStepper: UIStepper!
	
	@IBOutlet weak var padSpeedStepper: UIStepper!
	
	@IBAction func changeBallSpeed(sender: UIStepper) {
		ballSpeed = sender.value
	}
	
	@IBAction func changeNumberOfBalls(sender: UIStepper) {
		numberOfBalls = sender.value
	}

	@IBAction func changeBounciness(sender: UIStepper) {
		bounciness = sender.value
	}
	
	@IBAction func changePadSpeed(sender: UIStepper) {
		padSpeed = sender.value
	}
	
	var ballSpeed: Double {
		set {
			ballSpeedLabel.text = "\(newValue)"
			setDefault(forKey: Constants.BallSpeedDefaultKey, doubleVal: newValue)
		}
		
		get {
			return NSUserDefaults.standardUserDefaults().objectForKey(Constants.BallSpeedDefaultKey) as! Double
		}
	}
	
	var numberOfBalls: Double {
		set {
			numberOfBallsLabel.text = "\(newValue)"
			setDefault(forKey: Constants.NumberOfBallsDefaultKey, doubleVal: newValue)
		}
		
		get {
			return NSUserDefaults.standardUserDefaults().objectForKey(Constants.NumberOfBallsDefaultKey) as! Double
		}
	}
	
	var bounciness: Double {
		set {
			bouncinessLabel.text = "\(newValue)"
			setDefault(forKey: Constants.BouncinessDefaultKey, doubleVal: newValue)
		}
		
		get {
			return NSUserDefaults.standardUserDefaults().objectForKey(Constants.BouncinessDefaultKey) as! Double
		}
	}
	
	var padSpeed: Double {
		set {
			padSpeedLabel.text = "\(newValue)"
			setDefault(forKey: Constants.PadSpeedDefaultKey, doubleVal: newValue)
		}
		
		get {
			return NSUserDefaults.standardUserDefaults().objectForKey(Constants.PadSpeedDefaultKey) as! Double
		}
	}
	
	// MARK: Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
		
		// setup stepper properties
		setupStepperProperties(ballSpeedStepper, minVal: 1.0, maxVal: 10.0)
		setupStepperProperties(numberOfBallsStepper, minVal: 1.0, maxVal: 4.0)
		setupStepperProperties(bouncinessStepper, minVal: 1.0, maxVal: 5.0)
		setupStepperProperties(padSpeedStepper, minVal: 1.0, maxVal: 10.0)
		
		// initialize from NSUserDefaults
		initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	// MARK: Methods
	
	private func setupStepperProperties(stepper: UIStepper, minVal: Double, maxVal: Double, stepVal: Double = 1.0) {
		stepper.minimumValue = minVal
		stepper.maximumValue = maxVal
		stepper.stepValue = stepVal
	}
	
	private func getDefaultDouble(forKey key: String) -> Double? {
		return NSUserDefaults.standardUserDefaults().objectForKey(key) as? Double
	}
	
	private func setDefault(forKey key: String, doubleVal: Double) {
		NSUserDefaults.standardUserDefaults().setObject(doubleVal, forKey: key)
	}
	
	private func initialize() {
		ballSpeed = getDefaultDouble(forKey: Constants.BallSpeedDefaultKey) ?? Constants.BallSpeedDefaultValue
		numberOfBalls = getDefaultDouble(forKey: Constants.NumberOfBallsDefaultKey) ?? Constants.NumberOfBallsDefaultValue
		bounciness = getDefaultDouble(forKey: Constants.BouncinessDefaultKey) ?? Constants.BouncinessDefaultValue
		padSpeed = getDefaultDouble(forKey: Constants.PadSpeedDefaultKey) ?? Constants.PadSpeedDefaultValue
	}

}
