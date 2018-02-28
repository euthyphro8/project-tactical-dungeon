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
    let Max_Health:Int
    var Health:Int
    let Attack:Int
    let Defense:Int
    
    
    init(sprite:SKSpriteNode, x:CGFloat, y: CGFloat) {
        Sprite = sprite
        Sprite.position = CGPoint(x:x,y:y)
        Max_Health = 100
        Health = Max_Health
        Attack = 10
        Defense = 10
    }
    init(sprite:SKSpriteNode, x:CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) {
        Sprite = sprite
        Sprite.position = CGPoint(x:x,y:y)
        Sprite.scale(to: CGSize(width: w, height: h))
        Max_Health = 100
        Health = Max_Health
        Attack = 10
        Defense = 10
    }
    
    func Damage(Damage:Int)->Bool {
        let dead = Health - Damage <= 0
        Health = dead ? 0 : Health - Damage
        return dead
    }
}


