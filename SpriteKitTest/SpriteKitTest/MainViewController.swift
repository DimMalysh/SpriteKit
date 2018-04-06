//
//  MainViewController.swift
//  SpriteKitTest
//
//  Created by mac on 06.04.18.
//  Copyright © 2018 Dim Malysh. All rights reserved.
//

import UIKit
import SpriteKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.object(forKey: "totalScore") != nil {
            Model.sharedInstance.totalScore = UserDefaults.standard.object(forKey: "totalScore") as! Int
        }
        
        if Model.sharedInstance.isSound {
            SKTAudio.sharedInstance().playBackgroundMusic(filename: "backgroundMusic.mp3")
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func playGameAction(_ sender: UIButton) {
        SKTAudio.sharedInstance().playSoundEffect(filename: "button_press.wav")
        if let storyboard = storyboard {
            let difficultyViewController = storyboard.instantiateViewController(withIdentifier: "DifficultyViewController") as! DifficultyViewController
            navigationController?.pushViewController(difficultyViewController, animated: true)
        }
    }

}
