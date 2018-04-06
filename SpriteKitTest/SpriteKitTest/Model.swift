//
//  Model.swift
//  SpriteKitTest
//
//  Created by mac on 06.04.18.
//  Copyright © 2018 Dim Malysh. All rights reserved.
//

import Foundation

enum DifficultyChoosing: Int {
    case easy, medium, hard
}

enum BgChoosing: Int {
    case bg1, bg2
}

class Model {
    
    static let sharedInstance = Model() //Singleton
    
    //Variables
    var isSound = true
    var score = 0
    var highScore = 0
    var totalScore = 0
    var level2UnlockValue = 200
    
}
