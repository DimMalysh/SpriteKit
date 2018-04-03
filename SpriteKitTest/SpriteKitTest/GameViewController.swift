//
//  GameViewController.swift
//  SpriteKitTest
//
//  Created by mac on 03.04.18.
//  Copyright © 2018 Dim Malysh. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    var scene = GameScene(size: CGSize(width: 1024, height: 768))
    
    @IBOutlet weak var reloadGameButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scene.scaleMode = .aspectFill
        scene.gameViewControllerBridge = self
        reloadGameButton.isHidden = true
        
        let view = self.view as! SKView
        view.ignoresSiblingOrder = true
        view.presentScene(scene)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func reloadGameAction(_ sender: UIButton) {
        scene.reloadGame()
    }
    
}
