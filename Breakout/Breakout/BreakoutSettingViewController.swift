//
//  BreakoutSettingViewController.swift
//  Breakout
//
//  Created by Hanzhou Shi on 5/30/16.
//  Copyright © 2016 USF. All rights reserved.
//

import UIKit
	
struct SettingConstants {
	static let BallSpeedDefaultKey = "Breakout.BallSpeed"
	static let NumberOfBallsDefaultKey = "Breakout.NumberOfBalls"
	static let BouncinessDefaultKey = "Breakout.Bounciness"
	static let ResistenceDefaultKey = "Breakout.Resistence"
	
	static let BallSpeedDefaultValue = 0.02
	static let NumberOfBallsDefaultValue = 1.0
	static let BouncinessDefaultValue = 0.8
	static let ResistenceDefaultValue = 0.0
}

class BreakoutSettingViewController: UIViewController {
	
	// MARK: Actions/Outlets

	@IBOutlet weak var ballSpeedLabel: UILabel!
	
	@IBOutlet weak var numberOfBallsLabel: UILabel!
	
	@IBOutlet weak var bouncinessLabel: UILabel!
	
	@IBOutlet weak var resistenceLabel: UILabel!
	
	// the speed of the push applied to the balls
	@IBOutlet weak var ballSpeedStepper: UIStepper!
	
	@IBOutlet weak var numberOfBallsStepper: UIStepper!
	
	@IBOutlet weak var bouncinessStepper: UIStepper!
	
	@IBOutlet weak var resistenceStepper: UIStepper!
	
	@IBAction func changeBallSpeed(sender: UIStepper) {
		ballSpeed = sender.value
	}
	
	@IBAction func changeNumberOfBalls(sender: UIStepper) {
		numberOfBalls = sender.value
	}

	@IBAction func changeBounciness(sender: UIStepper) {
		bounciness = sender.value
	}
	
	@IBAction func changeResistence(sender: UIStepper) {
		resistence = sender.value
	}
	
	var ballSpeed: Double {
		set {
			ballSpeedLabel.text = "\(newValue)"
			setDefault(forKey: SettingConstants.BallSpeedDefaultKey, doubleVal: newValue)
		}
		
		get {
			return NSUserDefaults.standardUserDefaults().objectForKey(SettingConstants.BallSpeedDefaultKey) as! Double
		}
	}
	
	var numberOfBalls: Double {
		set {
			numberOfBallsLabel.text = "\(newValue)"
			setDefault(forKey: SettingConstants.NumberOfBallsDefaultKey, doubleVal: newValue)
		}
		
		get {
			return NSUserDefaults.standardUserDefaults().objectForKey(SettingConstants.NumberOfBallsDefaultKey) as! Double
		}
	}
	
	var bounciness: Double {
		set {
			bouncinessLabel.text = "\(newValue)"
			setDefault(forKey: SettingConstants.BouncinessDefaultKey, doubleVal: newValue)
		}
		
		get {
			return NSUserDefaults.standardUserDefaults().objectForKey(SettingConstants.BouncinessDefaultKey) as! Double
		}
	}
	
	var resistence: Double {
		set {
			resistenceLabel.text = "\(newValue)"
			setDefault(forKey: SettingConstants.ResistenceDefaultKey, doubleVal: newValue)
		}
		
		get {
			return NSUserDefaults.standardUserDefaults().objectForKey(SettingConstants.ResistenceDefaultKey) as! Double
		}
	}
	
	// MARK: Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
		
		// setup stepper properties
		setupStepperProperties(ballSpeedStepper, minVal: 0.02, maxVal: 0.1, stepVal: 0.02)
		setupStepperProperties(numberOfBallsStepper, minVal: 1.0, maxVal: 4.0)
		setupStepperProperties(bouncinessStepper, minVal: 0.1, maxVal: 1.0, stepVal: 0.1)
		setupStepperProperties(resistenceStepper, minVal: 0.0, maxVal: 0.8, stepVal: 0.1)
		
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
		ballSpeed = getDefaultDouble(forKey: SettingConstants.BallSpeedDefaultKey) ?? SettingConstants.BallSpeedDefaultValue
		ballSpeedStepper.value = ballSpeed
		numberOfBalls = getDefaultDouble(forKey: SettingConstants.NumberOfBallsDefaultKey) ?? SettingConstants.NumberOfBallsDefaultValue
		numberOfBallsStepper.value = numberOfBalls
		bounciness = getDefaultDouble(forKey: SettingConstants.BouncinessDefaultKey) ?? SettingConstants.BouncinessDefaultValue
		bouncinessStepper.value = bounciness
		resistence = getDefaultDouble(forKey: SettingConstants.ResistenceDefaultKey) ?? SettingConstants.ResistenceDefaultValue
		resistenceStepper.value = resistence
	}

}
