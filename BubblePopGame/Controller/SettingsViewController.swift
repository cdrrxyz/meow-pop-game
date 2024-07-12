//
//  SettingsViewController.swift
//  BubblePopGame
//
//  Created by Xueying Zou on 2022/4/22.
//

import Foundation
import UIKit

var playerName:String?

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var playerNameTextField: UITextField!
    @IBOutlet weak var gameTimeSlider: UISlider!
    @IBOutlet weak var gameTimeLabel: UILabel!
    @IBOutlet weak var numberSlider: UISlider!
    @IBOutlet weak var numberLabel: UILabel!
    
    var gameTime = 60
    var bubblesNumber = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    // pass settings to game view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGame"{
            let VC = segue.destination as! GameViewController
            VC.maxBubblesNumber = bubblesNumber
            VC.remainingTime = gameTime
            VC.playerName = playerNameTextField.text!
        }
    }

    @IBAction func startGame(_ sender: Any) {
        // invalid player name
        if playerNameTextField.text!.isEmpty {
            UIView.animate(withDuration: 0.2, animations: {self.playerNameTextField.layer.borderColor = UIColor.red.cgColor
                self.playerNameTextField.layer.borderWidth = 1.0
            })
        }else{
            playerName = playerNameTextField.text!
            performSegue(withIdentifier: "goToGame", sender: nil)
        }
    }
    
    // set game time
    @IBAction func gameTimeSliderChanged(_ sender: Any) {
        gameTime = Int(gameTimeSlider.value)
        gameTimeLabel.text = String(gameTime)
    }
    
    // set max number of bubbles
    @IBAction func numberSliderChanged(_ sender: Any) {
        bubblesNumber = Int(numberSlider.value)
        numberLabel.text = String(bubblesNumber)
    }
}
