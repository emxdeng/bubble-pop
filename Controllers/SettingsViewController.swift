//
//  ViewController.swift
//  bubbleAssignment
//
//  Created by Emily Deng on 4/4/2023.
//

import UIKit

class SettingsViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var maxBubbleSlider: UISlider!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var maxBubbleLabel: UILabel!

    // MARK: - View Lifecycle

    /// Set up initial values and target actions for time and max bubble labels and sliders
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set initial values for the labels
        timeLabel.text = "\(Int(timeSlider.value))"
        maxBubbleLabel.text = "\(Int(maxBubbleSlider.value))"

        // Add target-action for value changes of sliders
        timeSlider.addTarget(self, action: #selector(timeSliderValueChanged(_:)), for: .valueChanged)
        maxBubbleSlider.addTarget(self, action: #selector(maxBubbleSliderValueChanged(_:)), for: .valueChanged)
    }

    // MARK: - Navigation

    /// Prepares for the segue to the GameViewController when the Start Game button is pressed.
    ///
    /// - Parameters:
    ///   - segue: The segue being performed.
    ///   - sender: The object that initiated the segue.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "goToGame" else {
            return
        }

        // Check if the nameTextField is empty
        guard let name = nameTextField.text, !name.isEmpty else {
            // Show an alert or display an error message to the user
            let alertController = UIAlertController(title: "Name Required", message: "Please enter your name.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
        }

        // Proceed to the GameViewController
        let gameViewController = segue.destination as! GameViewController
        gameViewController.name = name
        gameViewController.remainingTime = Int(timeSlider.value)
        gameViewController.maxBubbles = Int(maxBubbleSlider.value)
    }

    // MARK: - Slider Value Changes

    /** Updates the label displaying the selected time value when the time slider value changes.
    ///
     - Parameter sender: The UISlider object representing the time slider.
     */
    @objc func timeSliderValueChanged(_ sender: UISlider) {
        let value = Int(sender.value)
        timeLabel.text = "\(value) seconds"
    }

    /** Updates the label displaying the selected maximum bubble value when the max bubble slider value changes.
    ///
     - Parameter sender: The UISlider object representing the max bubble slider.
     */
    @objc func maxBubbleSliderValueChanged(_ sender: UISlider) {
        let value = Int(sender.value)
        maxBubbleLabel.text = "\(value) bubbles"
    }



}
