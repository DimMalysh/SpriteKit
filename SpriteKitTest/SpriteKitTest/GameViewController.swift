//
//  GameViewController.swift
//  SpriteKitTest
//
//  Created by mac on 03.04.18.
//  Copyright © 2018 Dim Malysh. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    var scene = GameScene(size: CGSize(width: 1024, height: 768))
    let textureAtlas = SKTextureAtlas(named: "scene.atlas")
    
    //Variables
    var bgChoosing: BgChoosing!
    var difficultyChoosing: DifficultyChoosing!
    
    @IBOutlet weak var reloadGameButton: UIButton!
    @IBOutlet weak var menuGameButton: UIButton!
    @IBOutlet weak var loadingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingView.isHidden = false
        _ = SwiftSpinner.show(title: "Loading...", animated: true)
        
        scene.scaleMode = .aspectFill
        scene.bgChoosing = bgChoosing
        scene.difficultyChoosing = difficultyChoosing
        scene.gameViewControllerBridge = self
        reloadGameButton.isHidden = true
        
        let view = self.view as! SKView
        view.ignoresSiblingOrder = true
        
        textureAtlas.preload {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.loadingView.isHidden = true
                SwiftSpinner.hide()
                view.presentScene(self.scene)
            })
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func menuGameAction(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: false)
        navigationController?.dismiss(animated: false, completion: nil)
        
        DispatchQueue.main.async {
            self.scene.removeAll()
        }
    }
    
    @IBAction func reloadGameAction(_ sender: UIButton) {
        SKTAudio.sharedInstance().playSoundEffect(filename: "button_press.wav")
        scene.reloadGame()
        scene.gameViewControllerBridge = self
        reloadGameButton.isHidden = true
    }
    
}
