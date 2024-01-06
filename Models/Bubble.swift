import Foundation
import UIKit

/**
 `Bubble` is a UIButton subclass representing a bubble in the game. It provides properties and methods for positioning, animation, and tracking bubble-related information.

 Usage:
 - Initialize an instance of `Bubble` using the designated initializer.
 - Call `animation()` to animate the bubble with a spring animation.
 - Call `flash()` to apply a flashing effect to the bubble.
 - Call `flyOutAnimation(completion:)` to animate the bubble flying out of the screen.
 */
class Bubble: UIButton {

    /// The x-position of the bubble.
    var xPosition: Int {
        let screenWidth = Int(UIScreen.main.bounds.width)
        return Int.random(in: 20...(screenWidth - 70)) // Adjusted range for x-position
    }

    /// The y-position of the bubble.
    var yPosition: Int {
        let screenHeight = Int(UIScreen.main.bounds.height)
        let minY = 200 // Minimum y-position
        let maxY = screenHeight - 70 // Adjusted range for y-position

        return Int.random(in: minY...maxY)
    }

    /// The point value associated with the bubble.
    var pointValue: Int = 0

    var floatingDuration: TimeInterval = 10.0 // Default floating duration

    /**
       Initializes a new instance of `Bubble` with the specified frame.
       
       - Parameter frame: The frame rectangle for the bubble.
       */
    override init(frame: CGRect) {
        super.init(frame: frame)

        let screenWidth = Int(UIScreen.main.bounds.width)
        let screenHeight = Int(UIScreen.main.bounds.height)

        let minX = 20
        let minY = 200
        let maxX = screenWidth - 70
        let maxY = screenHeight - 70

        let xPosition = Int.random(in: minX...maxX)
        let yPosition = Int.random(in: minY...maxY)

        self.frame = CGRect(x: xPosition, y: yPosition, width: 50, height: 50)
        self.backgroundColor = .red
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /**
         Applies a spring animation to the bubble. Used when animating it into the screen.
         */
    func animation() {
        let springAnimation = CASpringAnimation(keyPath: "transform.scale")
        springAnimation.duration = 0.3
        springAnimation.fromValue = 1
        springAnimation.toValue = 0.8
        springAnimation.repeatCount = 1
        springAnimation.initialVelocity = 0.5
        springAnimation.damping = 1

        layer.add(springAnimation, forKey: nil)
    }

    /**
         Applies a flashing effect to the bubble.
         */
    func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 2
        flash.toValue = 0.1
        flash.fromValue = 1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3

        layer.add(flash, forKey: nil)
    }

    /**
        Animates the bubble flying out of the screen.
        
        - Parameter completion: A closure to be executed after the animation completes.
        */
    func flyOutAnimation(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = CGAffineTransform(translationX: CGFloat(self.xPosition), y: -CGFloat(self.yPosition))
        }, completion: { _ in
            completion()
        })
    }

    /**
        Animates the bubble floating up.
        
        - Parameter floatingDuration: The amount of time it takes for the animation to complete. Controls how fast the bubble moves - the smaller the value, the faster.
        */
    func startFloating(floatingDuration: TimeInterval) {
        let floatingAnimator = UIViewPropertyAnimator(duration: floatingDuration, curve: .linear) {
            // Adjust the bubble's position vertically to make it float upwards
            self.frame.origin.y = -100 // Adjust the y-axis value as needed
        }

        floatingAnimator.addAnimations({
            // Animate the bubble's alpha (optional)
            self.alpha = 0.5
        }, delayFactor: 0.5)

        floatingAnimator.addCompletion { [weak self] _ in
            // Reset the bubble's position and alpha when the animation completes
            self?.frame.origin.y = CGFloat(self?.yPosition ?? 0)
            self?.alpha = 1.0

            // Restart the floating animation
            self?.startFloating(floatingDuration: floatingDuration)
        }

        floatingAnimator.startAnimation()
    }


}
