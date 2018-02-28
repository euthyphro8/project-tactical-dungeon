//
//  Game.swift
//  Ultimate_Tactical_Dungeon_Simulator_Extreme_Version_Game_Of_The_Semester_Edition_MK_1_v_1.0.0
//
//  Created by Joshua Hess on 2/23/18.
//  Copyright © 2018 Ephemerality. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

public class Game {
    
    static let TILE_SIZE = 64
    
    var Entities = [Entity]()
    let Player:Entity;
    
    
    init(){
        Player = Entity(sprite:SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "player_tmp"))), x:0, y:0, w:64, h:64)
        Entities.append(Player)
    }
    
    
    
    func Add_Children(GameScene:SKScene) {
        for ent in Entities {
            GameScene.addChild(ent.Sprite)
        }
//        GameScene.addChild(Map.background)
    }
    
    
    func Touch_Down(atPoint pos : CGPoint) {
        let a = CGPoint(x:Player.Sprite.position.x,y:Player.Sprite.position.y)
        let b = CGPoint(x:Player.Sprite.position.x + Player.Sprite.size.width, y:Player.Sprite.position.y + Player.Sprite.size.height)
        if Is_In_Bounds(a: a, b: b, pos: pos) {
            Player.Sprite.position.x += 32
        }
    }
    
    func Is_In_Bounds(a: CGPoint, b: CGPoint, pos: CGPoint)->Bool {
        let betweenX:Bool = (pos.x > a.x && pos.x < b.x) || (pos.x > b.x && pos.x < a.x)
        let betweenY:Bool = (pos.y > a.y && pos.y < b.y) || (pos.y > b.y && pos.y < a.y)
        return betweenX && betweenY
    }
    
}
