//
//  HighScoreViewController.swift
//  BubblePopGame
//
//  Created by Xueying Zou on 2022/4/22.
//

import Foundation
import UIKit

let KEY_HIGH_SCORE = "highScore"

class HighScoreViewController: UIViewController {
    
    @IBOutlet weak var highScoreTableView: UITableView!
    
    var gameScore = [String: Int]()
    var highScores: Dictionary? = [String: Int]()
    var sortedHighScoresArray = [(key: String, value: Int)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        highScoreTableView.delegate = self
        highScoreTableView.dataSource = self

        readFromGame()
    }
    
    // get high score from game
    func readFromGame() {
        highScores = UserDefaults.standard.dictionary(forKey: KEY_HIGH_SCORE) as? Dictionary<String, Int>
        if highScores != nil {
            gameScore = highScores!
            // sorted in descending order
            sortedHighScoresArray = gameScore.sorted(by: {$0.value > $1.value})
        }
    }
}

extension HighScoreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedHighScoresArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "score")
        cell.textLabel!.text = "\(sortedHighScoresArray[indexPath.row].key)"
        cell.detailTextLabel!.text = "\(sortedHighScoresArray[indexPath.row].value)"
        return cell
    }
    
}

