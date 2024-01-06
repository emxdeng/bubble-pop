//
//  ErrorEnums.swift
//  bubbleAssignment
//
//  Created by Emily Deng on 5/5/2023.
//

import Foundation

// Enum to represent an error when the maximum attempts for bubble generation are reached
enum BubbleGenerationError: Error {
    case maxAttemptsReached
}

// Enum to represent decoding and encoding errors for high scores
enum HighScoreError: Error {
    case decodingFailed
    case encodingFailed
}

// This BubbleGenerationError enum is used in the BubbleManager class for error handling during bubble generation.
// It is thrown when the maximum number of attempts for bubble generation is reached.
// See BubbleManager.swift for usage.

// This HighScoreError enum is used in the HighScoreManager class for error handling during high score reading and writing.
// It is thrown when there is a decoding or encoding failure.
// See HighScoreManager.swift for usage.
