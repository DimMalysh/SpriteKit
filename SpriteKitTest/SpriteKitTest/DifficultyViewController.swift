//
//  DifficultyViewController.swift
//  SpriteKitTest
//
//  Created by mac on 06.04.18.
//  Copyright © 2018 Dim Malysh. All rights reserved.
//

import UIKit
import SpriteKit

class DifficultyViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func selectDifficultyAction(_ sender: UIButton) {
        SKTAudio.sharedInstance().playSoundEffect(filename: "button_press.wav")
        
        if let storyboard = storyboard {
            let selectBgViewController = storyboard.instantiateViewController(withIdentifier: "SelectBgViewController") as! SelectBgViewController
            
            selectBgViewController.selectBgDifficulty = DifficultyChoosing(rawValue: sender.tag)
            
            navigationController?.pushViewController(selectBgViewController, animated: true)
        }
    }
     
    @IBAction func backAction(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
        navigationController?.dismiss(animated: true, completion: nil)
    }

}
