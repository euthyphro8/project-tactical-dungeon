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
    
    static let TILE_SIZE:CGFloat = 64
    
    var Entities = [Entity]()
    let Player:Entity;
    let GameMap:Map;
    let SelectedTile:SKSpriteNode;
    var Actions:[SKAction]
    
    
    init(){
        GameMap = Map(background:SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "grid10x10"))), xSize:10, ySize:10, width: CGFloat(64*10), height: CGFloat(64*10))
        GameMap.Background.zPosition = 0
        SelectedTile = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "redHighlight")))
        SelectedTile.zPosition = 1
        SelectedTile.position = GameMap.findTile(tileX:1,tileY:1).Location
        
        //playerStartLoc
        
        Player = Entity(sprite:SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "player_tmp"))), x:GameMap.findTile(tileX:1, tileY: 1).Location.x, y:GameMap.findTile(tileX:1, tileY: 1).Location.y, w:64, h:64)
        Player.Sprite.zPosition = 2
//        Player.Sprite.position.x = GameMap.findTile(tileX:1, tileY: 1).Location.x
//        Player.Sprite.position.y = GameMap.findTile(tileX:1, tileY: 1).Location.y
        Entities.append(Player)
        //Entities.append(new Entity())
        Actions = [SKAction]()
    }
    
    
    
    func Add_Children(GameScene:SKScene) {
        GameScene.addChild(GameMap.Background)
        GameScene.addChild(SelectedTile)
        for ent in Entities {
            GameScene.addChild(ent.Sprite)
        }
    }
    
    
    func Touch_Down(atPoint pos : CGPoint) {
        //GameMap.Background.position.x+=100
        let tileLoc:CGPoint = GameMap.findTile(location: pos).Location
        //let moveAction = SKAction.move
        let moveActionX = SKAction.moveTo(x: tileLoc.x, duration: 0.1)
        let moveActionY = SKAction.moveTo(y: tileLoc.y, duration: 0.1)
        Actions.append(moveActionX)
        Actions.append(moveActionY)
        SelectedTile.run(moveActionX)
        SelectedTile.run(moveActionY)
       // SelectedTile.action
        //SelectedTile.position = SelectedTile.position.applying(CGAffineTransform(translationX:(tileLoc.x-SelectedTile.position.x),y:(tileLoc.y-SelectedTile.position.y)))
        //[SelectedTile .runAction[SKAction .moveTo(x: tileLoc.x, duration: 0.0)] ]
        //[SelectedTile runAction[SKAction moveTo : newPosition duration 0.0]]
//        SelectedTile.position.x+=(tileLoc.x-SelectedTile.position.x)
//        SelectedTile.position.y+=(tileLoc.y-SelectedTile.position.y)
        SelectedTile.physicsBody?.isDynamic = true
        SelectedTile.position.x = tileLoc.x
        SelectedTile.position.y = tileLoc.y
        //GameScene.addChild(SelectedTile)
        print("(Game)\(tileLoc)")
        print("(Game)\(SelectedTile.position)")
//        for r in Entity.Relative.Cases() {
//            let bounds = Player.Get_Bounds(pos:r);
//            if Is_In_Bounds(a: bounds.lower_left, b: bounds.upper_right, pos: pos) {
//
//                Player.Move(dir: r);
//                break;
//            }
//        }
        
        
//        print("Player: " + String(a));
//        print("Touch: " + String(a));
    }
    
    func Is_In_Bounds(a: CGPoint, b: CGPoint, pos: CGPoint)->Bool {
        let betweenX:Bool = (pos.x > a.x && pos.x < b.x) || (pos.x > b.x && pos.x < a.x)
        let betweenY:Bool = (pos.y > a.y && pos.y < b.y) || (pos.y > b.y && pos.y < a.y)
        return betweenX && betweenY
    }
    func Get_Entity_At_Pos(pos: CGPoint)->Entity{
        for e in  Entities {
            let bounds = e.Get_Bounds(pos: Entity.Relative.CENTER)
            if(Is_In_Bounds(a: bounds.lower_left, b: bounds.upper_right, pos: pos)) {
                return e;
            }
        }
        //shouldn't make it here I think
        return Entities[0];
    }
    
}


