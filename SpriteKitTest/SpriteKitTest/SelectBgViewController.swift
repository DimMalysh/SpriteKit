//
//  SelectBgViewController.swift
//  SpriteKitTest
//
//  Created by mac on 06.04.18.
//  Copyright © 2018 Dim Malysh. All rights reserved.
//

import UIKit
import SpriteKit

class SelectBgViewController: UIViewController {

    @IBOutlet weak var totalPointLabel: UILabel!
    @IBOutlet weak var bg1Button: UIButton!
    @IBOutlet weak var bg2Button: UIButton!
    
    var selectBgDifficulty: DifficultyChoosing!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Model.sharedInstance.isSound {
            SKTAudio.sharedInstance().resumeBackgroundMusic()
        }
        
        totalPointLabel.text = "\(Model.sharedInstance.totalScore)"
        
        if Model.sharedInstance.totalScore > Model.sharedInstance.level2UnlockValue {
            let image = UIImage(named: "unlockBGBtn200.png") as UIImage!
            bg2Button.setImage(image, for: .normal)
        }
    }
    
    @IBAction func selectBGAction(_ sender: UIButton) {
        SKTAudio.sharedInstance().playSoundEffect(filename: "button_press.wav")
        
        if let storyboard = storyboard {
            let gameViewController = storyboard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
            
            gameViewController.bgChoosing = BgChoosing(rawValue: sender.tag)
            gameViewController.difficultyChoosing = selectBgDifficulty
            
            if gameViewController.bgChoosing.rawValue == 0 {
                navigationController?.pushViewController(gameViewController, animated: true)
            } else if gameViewController.bgChoosing.rawValue == 1 && Model.sharedInstance.totalScore >  Model.sharedInstance.level2UnlockValue {
                navigationController?.pushViewController(gameViewController, animated: true)
            }
        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
        navigationController?.dismiss(animated: true, completion: nil)
    }

}
