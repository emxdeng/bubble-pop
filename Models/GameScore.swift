//
//  GameScore.swift
//  bubbleAssignment
//
//  Created by Emily Deng on 2/5/2023.
//

import Foundation

/**
 Represents a game score achieved by a player.

 The `GameScore` struct encapsulates the player's name and the corresponding score attained in a game. It conforms to the `Codable` protocol, enabling it to be serialized to and deserialized from various data formats, such as JSON.

 Example Usage:
 ```
 let score = GameScore(name: "Emily", score: 95.5)
 ```
 */
struct GameScore: Codable {
    let name: String
    let score: Double
}
