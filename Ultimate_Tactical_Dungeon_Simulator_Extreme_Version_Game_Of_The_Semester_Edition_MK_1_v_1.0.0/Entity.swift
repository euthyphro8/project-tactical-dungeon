//
//  Entity.swift
//  Ultimate_Tactical_Dungeon_Simulator_Extreme_Version_Game_Of_The_Semester_Edition_MK_1_v_1.0.0
//
//  Created by Joshua Hess on 2/14/18.
//  Copyright © 2018 Ephemerality. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

public class Entity {
    
    let Sprite:SKSpriteNode
    
    init(sprite:SKSpriteNode) {
        Sprite = sprite
        Sprite.position = CGPoint(x:50,y:50)
    }
    
    func Update() {
        
    }
    
}


