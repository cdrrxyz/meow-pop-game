//
//  GameViewController.swift
//  BubblePopGame
//
//  Created by Xueying Zou on 2022/4/22.
//

import Foundation
import UIKit
import AVFoundation

class GameViewController: UIViewController {
    
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var currentScoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    
    var countdownTimer = Timer()
    var timer = Timer()
    var bubble = Bubble()
    var bubbleArray = [Bubble]()
    var countdownTime = 3
    var remainingTime = 60
    var maxBubblesNumber = 15
    var playerName = ""
    var currentScore = 0
    var lastBubbleValue = 0
    var gameScores = [String: Int]()
    var highScores: Dictionary? = [String: Int]()
    var sortedHighScoresArray = [(key: String, value: Int)]()
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        countdownLabel.text = String(countdownTime)
        remainingTimeLabel.text = String(remainingTime)
        getHighScore()
        
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            timer in
            self.countdown()
        }
    }
    
    // show previous high score
    func getHighScore() {
        highScores = UserDefaults.standard.dictionary(forKey: KEY_HIGH_SCORE) as? Dictionary<String, Int>
        if highScores != nil {
            gameScores = highScores!
            sortedHighScoresArray = gameScores.sorted(by: {$0.value > $1.value})
            highScoreLabel.text = String(sortedHighScoresArray[0].value)
        }
    }
    
    // countdown before game started
    @objc func countdown() {
        countdownLabel.text = String(countdownTime)
        flash(element: countdownLabel)
        countdownTime -= 1
        
        if countdownTime < 0 {
            startGame()
            countdownLabel.isHidden = true
            countdownTimer.invalidate()
        }
    }
    
    // change remaining time label during the game
    @objc func counting() {
        remainingTime -= 1
        remainingTimeLabel.text = String(remainingTime)
    }
    
    func startGame() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            timer in
            self.removeBubble()
            self.generateBubble()
            self.counting()
            
            // speed up bubbles movement in the last 5 seconds
            if self.remainingTime == 10 {
                self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) {
                    timer in
                    self.generateBubble()
                    self.removeBubble()
                }
            }
            
            // stop game when time is over
            if self.remainingTime == 0 {
                timer.invalidate()
                
                // remove all bubbles
                for bubbles in self.bubbleArray {
                    bubbles.removeFromSuperview()
                }
                
                // save the score
                self.checkSavedHighScore()
                
                // show high scores
                let VC = self.storyboard?.instantiateViewController(identifier: "HighScoreViewController") as! HighScoreViewController
                self.navigationController?.pushViewController(VC, animated: true)
                VC.navigationItem.setHidesBackButton(true, animated: true)
            }
        }
    }
    
    // check bubbles positions
    func isOverlapped(bubbleToCreate: Bubble) -> Bool {
        for bubblesOnScreen in bubbleArray {
            if bubbleToCreate.frame.intersects(bubblesOnScreen.frame) {
                return true
            }
        }
        return false
    }
    
    // create bubble randomly
    func generateBubble() {
        var num = arc4random_uniform(UInt32(maxBubblesNumber)) + 1
        
        while num > 0 && maxBubblesNumber > bubbleArray.count {
            bubble = Bubble()
            bubble.animation()
            if !isOverlapped(bubbleToCreate: bubble) {
                bubble.addTarget(self, action: #selector(bubblePressed), for: .touchUpInside)
                self.view.addSubview(bubble)
                bubbleArray += [bubble]
                num = num - 1
            }
        }
    }
    
    // remove bubble randomly
    func removeBubble() {
        var num = arc4random_uniform(UInt32(maxBubblesNumber)) + 1
        
        while num > 0 && num <= bubbleArray.count {
            let i = arc4random_uniform(UInt32(bubbleArray.count))
            
            bubbleArray[Int(i)].removeFromSuperview()
            bubbleArray.remove(at: Int(i))
            num = num - 1
        }
    }
    
    @IBAction func bubblePressed(_ sender: Bubble) {
        // remove pressed bubble from view
        sender.removeFromSuperview()
        playSound()
        
        // double click on same color
        // score round to the nearest integer
        if lastBubbleValue == sender.value {
            currentScore += lround(Double(sender.value) * 1.5)
        }
        else {
            currentScore += sender.value
        }
        lastBubbleValue = sender.value
        currentScoreLabel.text = String(currentScore)
        
        // update current high score
        if highScores == nil {
            highScoreLabel.text = String(currentScore)
        }else if sortedHighScoresArray[0].value > currentScore {
            highScoreLabel.text = String(sortedHighScoresArray[0].value)
        }else if sortedHighScoresArray[0].value <= currentScore {
            highScoreLabel.text = String(currentScore)
        }
    }
    
    func saveScore() {
        gameScores.updateValue(currentScore, forKey: playerName)
        UserDefaults.standard.set(gameScores, forKey:KEY_HIGH_SCORE)
    }
    
    func checkSavedHighScore() {
        if highScores == nil {
            saveScore()
        }else {
            gameScores = highScores!
            // same player with different score
            if gameScores.keys.contains(playerName){
                let savedScore = gameScores[playerName]!
                if savedScore < currentScore {
                    saveScore()
                }
            }else {
                saveScore()
            }
        }
    }
    
    // flashing count down
    func flash(element: UIView) {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 1
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        
        element.layer.add(flash, forKey: nil)
    }
    
    // play bubble pop sound
    func playSound() {
        let sound = Bundle.main.url(forResource: "meow", withExtension: "m4a")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: sound!)
            audioPlayer?.play()
        }catch let error as NSError {
            print(error.debugDescription)
        }
    }
}
