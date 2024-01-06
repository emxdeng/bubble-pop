//
//  GameViewController.swift
//  bubbleAssignment
//
//  Created by Emily Deng on 4/4/2023.
//
//  The `GameViewController` class is responsible for managing the game screen, including the countdown timer, score tracking, bubble generation, and user interaction. It displays the remaining time, current score, and high score on the screen. When the time runs out, it transitions to the high score screen and passes the game score to be displayed. The class also handles the logic for generating bubbles, tracking consecutive bubble pops, and updating the score based on user interaction.
//

import UIKit

class GameViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    // MARK: - Properties

    /// The player's name.
    var name: String = ""

    /// The remaining time in seconds.
    var remainingTime = 60

    /// The timer used for the game.
    var timer = Timer()

    /// The maximum number of bubbles allowed in the game.
    var maxBubbles = 15

    /// The current game score.
    var gameScore: GameScore = GameScore(name: "", score: 0)

    /// The score for the current game.
    var score: Double = 0

    /// The color for the bubbles.
    let lightPinkColor = UIColor(red: 1.0, green: 0.75, blue: 0.8, alpha: 1.0)

    /// The color of the last popped bubble.
    var lastBubbleColor: UIColor?

    /// The number of consecutive bubbles popped.
    var consecutiveBubblesPopped: Int = 0

    /// The list of existing bubble rectangles.
    var existingBubbles: [CGRect] = []

    /// The bubble manager responsible for handling bubbles.
    var bubbleManager: BubbleManager!

    /// The high score obtained from the HighScoreManager.
    var highScore : Double = 0
   
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        bubbleManager = BubbleManager() // Initialize the bubble manager

        nameLabel.text = name
        remainingTimeLabel.text = String(remainingTime)
        scoreLabel.text = "Score: \(score)"

        do {
            highScore = try HighScoreManager.readHighScore()
        } catch HighScoreError.decodingFailed {
            print("Error decoding high score")
        } catch HighScoreError.encodingFailed {
            print("Error encoding high score")
        } catch {
            print("Unknown error occurred: \(error)")
        }
        
        // Update the high score label initially
        updateHighScoreLabel()

        // Active timer and generate bubbles every second
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.counting()
            self.generateBubbles()
        }
    }

    // MARK: - Timer

    /// Updates the countdown timer and handles the game logic when the time reaches zero.
    func counting() {
        remainingTime -= 1
        remainingTimeLabel.text = String(remainingTime)

        if remainingTime == 0 {
            timer.invalidate() // Stop the timer

            let roundedScore = score.rounded(toPlaces: 1)

            // Create the game score instance
            gameScore = GameScore(name: name, score: roundedScore)

            // Add the game score to the high scores
            do {
                try HighScoreManager.addScoreToHighScores(score: gameScore)
            } catch HighScoreError.encodingFailed {
                print("Error encoding high score")
            } catch {
                print("Unknown error occurred: \(error)")
            }

            // Pass the game score to the high score view controller
            let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your storyboard name
            let highScoreVC = storyboard.instantiateViewController(identifier: "HighScoreViewController") as! HighScoreViewController
            highScoreVC.gameScore = gameScore // Assign the game score to the high score view controller

            // Push the high score view controller onto the navigation stack
            self.navigationController?.pushViewController(highScoreVC, animated: true)
            highScoreVC.navigationItem.setHidesBackButton(true, animated: true)
        }
    }

    // MARK: - High Score Label
    
    /// Determine whether current score has exceed high score, and display current score if this is true
    func updateHighScoreLabel() {
        // Compare the current score with the high score value
        let currentScore = score.rounded(toPlaces: 1)
        if currentScore > highScore {
            highScore = currentScore
        }

        // Update the high score label
        highScoreLabel.text = "High Score: \(highScore)"
    }

    // MARK: - Bubble Pressed
    
    /// Handles the logic when a bubble is pressed, including updating the score and animating the bubble fly out.
    ///
    /// - Parameter sender: The bubble that was pressed.
    @objc func bubblePressed(_ sender: Bubble) {
        let currentColor = sender.backgroundColor

        // Check if the current bubble color matches the last popped color
        let isCombo = currentColor == lastBubbleColor

        // Calculate score multiplier
        let multiplier = isCombo ? 1.5 : 1

        // Update the last popped color
        lastBubbleColor = currentColor

        // Increment consecutive bubbles popped count or reset to 0 if not a combo
        if isCombo {
            consecutiveBubblesPopped += 1
        } else {
            consecutiveBubblesPopped = 0
        }

        let scoreToAdd = Double(sender.pointValue) * multiplier
        score += scoreToAdd
        scoreLabel.text = String(score)

        // Update the high score label
        updateHighScoreLabel()

        // Animate the bubble flying out
        sender.flyOutAnimation {
            sender.removeFromSuperview()
        }
    }

    // MARK: - Bubble Generation
    
    /// Delete all existing bubbles, then generate a new group of floating bubbles each time it is called
    func generateBubbles() {
        // Remove all bubbles from the view
        bubbleManager.removeAllBubbles()
        var generatedBubbles: [Bubble] = []

        // Generate a new set of randomly positioned bubbles
        do {
            generatedBubbles = try bubbleManager.generateBubbles(count: maxBubbles)
            // Process the generated bubbles
            // ...
        } catch BubbleGenerationError.maxAttemptsReached {
            // Handle the error when maximum attempts are reached
            print("Maximum attempts reached while generating bubbles.")
        } catch {
            // Handle other errors
            print("An error occurred while generating bubbles: \(error)")
        }
        
        if !generatedBubbles.isEmpty {
            print("Bubbles were not generated.")
        }

        // Add the generated bubbles to the view
        for bubble in generatedBubbles {

            // Add a target for the bubble's button press event
            bubble.addTarget(self, action: #selector(bubblePressed(_:)), for: .touchUpInside)

            // Add the bubble to the view
            view.addSubview(bubble)

            // Add float up animation for bubbles. If 15 seconds or less remaining, float up twice as fast.
            if remainingTime <= 15 {
                bubble.startFloating(floatingDuration: 5.0)
            } else {
                bubble.startFloating(floatingDuration: 10.0)
            }



        }
    }
}

// MARK: - Double Extension

/// An extension to round a Double value to a specified number of decimal places.
extension Double {

    /// Rounds the Double value to the specified number of decimal places.
    ///
    /// - Parameter places: The number of decimal places to round to.
    /// - Returns: The rounded Double value.
    func rounded(toPlaces places: Int) -> Double {

        // Calculate the divisor needed for rounding.
        let divisor = pow(10.0, Double(places))

        // Multiply the Double value by the divisor, round it, and then divide it by the divisor to get the rounded value.
        let roundedValue = (self * divisor).rounded() / divisor

        // Return the rounded value.
        return roundedValue
    }
}
