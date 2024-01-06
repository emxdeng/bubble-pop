//
//  BubbleManager.swift
//  bubbleAssignment
//
//  Created by Emily Deng on 3/5/2023.
//

import Foundation
import UIKit

/**
 `BubbleManager` is a class responsible for managing bubbles in the game. It provides methods to generate bubbles, handle overlap detection, and remove bubbles from the screen.

 Usage:
 - Call `generateBubbles(count:)` to generate a specified number of bubbles.
 - Call `removeAllBubbles()` to remove all bubbles from the screen.
 */
class BubbleManager {
    
    /// Array of bubbles generated
    private var bubbles: [Bubble] = []

    /// Generates a specified number of bubbles.
    ///
    /// - Parameter count: The number of bubbles to generate.
    /// - Returns: An array of generated bubbles.
    func generateBubbles(count: Int) throws -> [Bubble] {
        var generatedBubbles: [Bubble] = []
        let lightPinkColor = UIColor(red: 1.0, green: 0.75, blue: 0.8, alpha: 1.0)
        var existingBubbles: [CGRect] = []
        let generateCount = Int.random(in: 1...count)
        let maxAttempts = 150

        for _ in 1...generateCount {
            let bubble = Bubble()
            var isOverlapping = true
            var attempt = 0

            while isOverlapping {
                let randomNumber = Int.random(in: 1...100)
                if randomNumber <= 40 {
                    // Red bubble
                    bubble.backgroundColor = UIColor.red
                    bubble.pointValue = 1
                } else if randomNumber <= 70 {
                    // Pink bubble
                    bubble.backgroundColor = lightPinkColor
                    bubble.pointValue = 2
                } else if randomNumber <= 85 {
                    // Green bubble
                    bubble.backgroundColor = UIColor.green
                    bubble.pointValue = 5
                } else if randomNumber <= 95 {
                    // Blue bubble
                    bubble.backgroundColor = UIColor.blue
                    bubble.pointValue = 8
                } else {
                    // Black bubble
                    bubble.backgroundColor = UIColor.black
                    bubble.pointValue = 10
                }

                let bubbleSize = bubble.bounds.size
                let randomX = CGFloat.random(in: 0...(UIScreen.main.bounds.width - bubbleSize.width))
                let randomY = CGFloat.random(in: 200...(UIScreen.main.bounds.height - bubbleSize.height))
                bubble.frame = CGRect(x: randomX, y: randomY, width: bubbleSize.width, height: bubbleSize.height)

                isOverlapping = false
                for existingBubbleFrame in existingBubbles {
                    if bubble.frame.intersects(existingBubbleFrame.insetBy(dx: -10, dy: -10)) {
                        isOverlapping = true
                        break
                    }
                }
                
                attempt += 1
                if attempt >= maxAttempts {
                    throw BubbleGenerationError.maxAttemptsReached
                }
            }

            generatedBubbles.append(bubble)
            existingBubbles.append(bubble.frame)

            // Add the bubble to the bubbles array
            bubbles.append(bubble)

            // Animate the bubble
            bubble.animation()
        }

        return generatedBubbles
    }

    /// Removes all bubbles from the screen.
    func removeAllBubbles() {
        for bubble in bubbles {
            bubble.removeFromSuperview()
        }
        bubbles.removeAll()
    }
}
