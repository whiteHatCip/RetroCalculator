//
//  ViewController.swift
//  RetroCalculator
//
//  Created by Fabio Cipriani on 16/08/16.
//  Copyright © 2016 Fabio Cipriani. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    // MARK: @Properties
    var btnSound: AVAudioPlayer!
    
    enum Operation: String {
        case Divide = "/"
        case Multipy = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    
    var currentOperation = Operation.Empty
    var runningNumber = ""
    var leftVal = ""
    var rightVal = ""
    var result = "0"
    
    // MARK: @IBOutlets
    @IBOutlet weak var counterLbl: UILabel!
    
    // MARK: Initialize Views
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        let soundURL = URL(fileURLWithPath: path!)
        
        do {
            try btnSound = AVAudioPlayer(contentsOf: soundURL)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        counterLbl.text = "0"
    }
    
    // MARK: @IBActions
    @IBAction func numberPressed (sender: UIButton) {
        playSound()
        if sender.tag != -1 {
            if runningNumber == "0" || runningNumber == "" {
                runningNumber = "\(sender.tag)"
            } else {
                runningNumber += "\(sender.tag)"
            }
            counterLbl.text = runningNumber
        }
    }
    
    @IBAction func onDividePressed (sender: UIButton){
        processOperation(operation: .Divide)
    }
    
    @IBAction func onMultiplyPressed (sender: UIButton){
        processOperation(operation: .Multipy)
    }
    
    @IBAction func onSubtractPressed (sender: UIButton){
        processOperation(operation: .Subtract)
    }
    
    @IBAction func onAddPressed (sender: UIButton){
        processOperation(operation: .Add)
    }
    
    @IBAction func onEqualPressed (sender: UIButton){
        processOperation(operation: currentOperation)
        currentOperation = Operation.Empty
        leftVal = ""
        rightVal = ""
        //runningNumber = ""
        //result = ""
    }
    
    @IBAction func onClearPressed(_ sender: AnyObject) {
        clearTempVars()
    }
    
    // MARK: Functions
    func playSound () {
        if btnSound.isPlaying {
            btnSound.stop()
        }
        btnSound.play()
    }
    
    func clearTempVars() {
        currentOperation = Operation.Empty
        leftVal = ""
        rightVal = ""
        runningNumber = ""
        counterLbl.text = "0"
        result = "0"
    }
    
    func processOperation (operation: Operation) {
        if currentOperation != Operation.Empty {
            // A user selected an operator, but then selected another operator without first entering a number
            if runningNumber != "" {
                
                rightVal = runningNumber
                runningNumber = ""
                
                if leftVal != "" {
                    
                    if currentOperation == Operation.Multipy {
                        result = "\(Double(leftVal)! * Double(rightVal)!)"
                    } else if currentOperation == Operation.Divide {
                        result = "\(Double(leftVal)! / Double(rightVal)!)"
                    } else if currentOperation == Operation.Subtract {
                        result = "\(Double(leftVal)! - Double(rightVal)!)"
                    } else if currentOperation == Operation.Add {
                        result = "\(Double(leftVal)! + Double(rightVal)!)"
                    }
                    leftVal = result
                    counterLbl.text = result
                } else {
                    let currentResult: Double = Double(result)!
                    if currentOperation == Operation.Multipy {
                        result = "\(currentResult * Double(rightVal)!)"
                    } else if currentOperation == Operation.Divide {
                        result = "\(currentResult / Double(rightVal)!)"
                    } else if currentOperation == Operation.Subtract {
                        result = "\(currentResult - Double(rightVal)!)"
                    } else if currentOperation == Operation.Add {
                        result = "\(currentResult + Double(rightVal)!)"
                    }
                    leftVal = result
                    counterLbl.text = result
                }
            }
            currentOperation = operation
        } else {
            // This is the first time the user presses an operation button
            leftVal = runningNumber
            runningNumber =  ""
            currentOperation = operation
            
        }
    }
}

