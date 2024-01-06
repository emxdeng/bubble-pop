//
//  ViewController.swift
//  bubbleAssignment
//
//  Created by Emily Deng on 4/4/2023.
//

import UIKit

/**
 The main view controller of the app, responsible for the homepage display.

 The `ViewController` class represents the initial screen of the app. It contains buttons for starting a new game and accessing high scores. This class also handles the initialization of the view and clearing the high scores table for testing purposes.
 */
class ViewController: UIViewController {

    /**
        Hides the default back button of the navigation bar.
        */
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true

    }


}
