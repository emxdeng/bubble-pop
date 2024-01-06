//
//  HighScoreManager.swift
//  bubbleAssignment
//
//  Created by Emily Deng on 3/5/2023.
//

import Foundation


/**
 HighScoreManager is a utility class that provides methods for managing high scores in a game. It handles reading and writing high scores to and from UserDefaults. The high scores are represented as an array of `GameScore` objects.

 The class provides the following functionalities:
 - Writing an array of `GameScore` objects to UserDefaults as the high scores.
 - Reading the high scores from UserDefaults and returning them as an array of `GameScore` objects.
 - Retrieving the highest score from the stored high scores as a `Double` value.

 Usage:
 To write new scores, use the `addScoreToHighScores(scores:)` method, passing in an array of `GameScore` objects.
 To read high scores, use the `readHighScores()` method, which returns an array of `GameScore` objects.
 To retrieve the highest score, use the `readHighScore()` method, which returns the highest score as a `Double` value.
 To clear the entire high score table, use the `clearHighScores()` method or '`clearHighScoresFromConsole()` in the console.


 Example usage:
 ```
 let highScores = HighScoreManager.readHighScores()
 let highestScore = HighScoreManager.readHighScore()
 ```
 
 Note: The high scores are stored in UserDefaults using the key KEY_HIGH_SCORE. Make sure to use the same key when reading and writing high scores.
 */

class HighScoreManager {
    /// Key for accessing the high score in UserDefaults.
    static let KEY_HIGH_SCORE = "highScore"

    /// Reads the high scores from UserDefaults.
    ///
    /// - Returns: An array of GameScore objects representing the high scores.
    /// - Throws: `HighScoreError.decodingFailed` if decoding fails.
    static func readHighScores() throws -> [GameScore] {
        let defaults = UserDefaults.standard

        if let savedArrayData = defaults.value(forKey: KEY_HIGH_SCORE) as? Data,
            let array = try? PropertyListDecoder().decode(Array<GameScore>.self, from: savedArrayData) {
            return array
        } else {
            throw HighScoreError.decodingFailed
        }
    }

    /// Adds a new score to the high scores array and writes it to UserDefaults.
    ///
    /// - Parameter score: The new score to be added.
    /// - Throws: `HighScoreError.encodingFailed` if encoding fails.
    static func addScoreToHighScores(score: GameScore) throws {
        var highScores = try readHighScores()
        highScores.append(score)
        let defaults = UserDefaults.standard

        do {
            let encodedData = try PropertyListEncoder().encode(highScores)
            defaults.set(encodedData, forKey: KEY_HIGH_SCORE)
        } catch {
            throw HighScoreError.encodingFailed
        }
    }

    /// Reads the highest score from the high scores array.
    ///
    /// - Returns: The highest score as a Double value.
    /// - Throws: `HighScoreError.decodingFailed` if decoding fails.
    static func readHighScore() throws -> Double {
        let highScores = try readHighScores()

        if let highestScore = highScores.max(by: { $0.score < $1.score }) {
            return highestScore.score
        } else {
            return 0
        }
    }

    /// Clears all the high scores from UserDefaults.
    static func clearHighScores() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: KEY_HIGH_SCORE)
    }
}
