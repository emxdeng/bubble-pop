//
//  HighScoreViewController.swift
//  bubbleAssignment
//
//  Created by Emily Deng on 4/4/2023.
//

import UIKit

// Define the key used for reading and writing the high score in user defaults.
let KEY_HIGH_SCORE = "highScore"

/**
 View controller responsible for displaying and managing the high scores.
 */
class HighScoreViewController: UIViewController {

    //MARK: - OUTLETS

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backToHomeBtn: UIButton!

    // MARK: - Variable Definitions

    /// An array to store the high scores achieved in the game.
    var highScore: [GameScore] = []

    /// The current game score.
    var gameScore: GameScore = GameScore(name: "", score: 0)

    // MARK: - HIGH SCORES

    /**
         Load the high score list sorted in descending order in a table view.
         */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load high scores from persistent storage
        do {
            highScore = try HighScoreManager.readHighScores()
        } catch HighScoreError.decodingFailed {
            print("Failed to decode high scores from UserDefaults.")
        } catch {
            print("An error occurred while reading high scores: \(error)")
        }


        // Sort the high scores in descending order
        highScore.sort { $0.score > $1.score }

        // Reload the table view to reflect the sorted scores
        tableView.reloadData()
    }

    /**
         Reads the high scores from user defaults.
         
         - Returns: An array of `GameScore` objects representing the high scores.
         */
    func readHighScores() -> [GameScore] {
        let defaults = UserDefaults.standard

        if let savedArrayData = defaults.value(forKey: KEY_HIGH_SCORE) as? Data {
            if let array = try? PropertyListDecoder().decode(Array<GameScore>.self, from: savedArrayData) {
                return array
            } else {
                return []
            }
        } else {
            return []
        }
    }
}

// MARK: - UITableViewDelegate

/// Gets data from persistant storage and stores it in the UITable cells
extension HighScoreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highScore.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let score = highScore[indexPath.row]
        cell.textLabel?.text = score.name
        cell.detailTextLabel?.text = "Score: \(score.score)"
        return cell
    }

}
