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
    var IsPlayerTurn: Bool
    let DelayTime = 30
    var DelayTimer = 30
    
    init(){
        GameMap = Map(background:SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "grid10x10"))), xSize:10, ySize:10, width: CGFloat(64*10), height: CGFloat(64*10))
        GameMap.Background.zPosition = 0
        
        SelectedTile = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "redHighlight")))
        SelectedTile.zPosition = 1
        SelectedTile.position = GameMap.findTile(tileX:1,tileY:1).Location
        
        //Player
        let pTile = GameMap.findTile(tileX: 1, tileY: 1);
        Player = Entity(sprite:SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "player_tmp"))), x:pTile.Location.x, y:pTile.Location.y, w:Game.TILE_SIZE, h:Game.TILE_SIZE, enemy:false)
        pTile.TileOc = OccupiedType.friend
        //Enemy
        let eTile = GameMap.findTile(tileX:3, tileY: 3);
        let enemy = Entity(sprite:SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "enemy_tmp"))), x:eTile.Location.x, y:eTile.Location.y, w:Game.TILE_SIZE, h:Game.TILE_SIZE, enemy:false)
        eTile.TileOc = OccupiedType.enemy
        
        Entities.append(enemy)
        Entities.append(Player)
        
        Actions = [SKAction]()
        IsPlayerTurn = false
    }
    func Add_Children(GameScene:SKScene) {
        GameScene.addChild(GameMap.Background)
        GameScene.addChild(SelectedTile)
        for ent in Entities {
            GameScene.addChild(ent.Sprite)
        }
    }
    
    
    func Update() {
        //Run the gui actions
        for act in Actions{
            SelectedTile.run(act)
        }
        //Run the entity actions
        for e in Entities {
            e.Update();
        }
        if !IsPlayerTurn {
            if DelayTimer > 0 {
                DelayTimer -= 1
            }
            else {
                Enemys_Turn()
                DelayTimer = DelayTime
                IsPlayerTurn = true
            }
        }
    }
    func Move_Selection(to: CGPoint) {
        let moveActionX = SKAction.moveTo(x: to.x, duration: 0.1)
        let moveActionY = SKAction.moveTo(y: to.y, duration: 0.1)
        Actions.append(moveActionX)
        Actions.append(moveActionY)
    }
    func Touch_Down(atPoint pos : CGPoint) {
        if IsPlayerTurn {
            Players_Turn(atPoint: pos)
            IsPlayerTurn = false
        }
        else {
            //TODO: Simply move selection tile
        }
    }
    func Players_Turn(atPoint pos : CGPoint) {
        let tile:MapNode = GameMap.findTile(location: pos)
        let ptile:MapNode = GameMap.findTile(location: Player.Sprite.position)
        Move_Selection(to: tile.Location);
        
        switch tile.TileOc {
            case OccupiedType.nothing:
                if(ptile.TileX == tile.TileX) {
//                    if(ptile.TileY == -1 && tile.TileY == 1||ptile.TileY == 1 && tile.TileY == -1){
//
//                    }
                    if(ptile.TileY + 1 == tile.TileY || (ptile.TileY == -1 && tile.TileY == 1)) {
                        tile.TileOc = OccupiedType.friend;
                        ptile.TileOc = OccupiedType.nothing;
                        Player.Move(dir: Entity.Relative.NORTH);
                    }
                    else if(ptile.TileY - 1 == tile.TileY || (ptile.TileY == 1 && tile.TileY == -1)) {
                        tile.TileOc = OccupiedType.friend;
                        ptile.TileOc = OccupiedType.nothing;
                        Player.Move(dir: Entity.Relative.SOUTH);
                    }
                }
                else if(ptile.TileY == tile.TileY) {
                    if(ptile.TileX + 1 == tile.TileX || (ptile.TileX == -1 && tile.TileX == 1)) {
                        tile.TileOc = OccupiedType.friend;
                        ptile.TileOc = OccupiedType.nothing;
                        Player.Move(dir: Entity.Relative.EAST);
                    }
                    else if(ptile.TileX - 1 == tile.TileX || (ptile.TileX == 1 && tile.TileX == -1)) {
                        tile.TileOc = OccupiedType.friend;
                        ptile.TileOc = OccupiedType.nothing;
                        Player.Move(dir: Entity.Relative.WEST);
                    }
                }
                break
            case OccupiedType.enemy:
                if let e = Get_Entity_At_Pos(pos: pos) {
                    if e.Damage(Damage: Player.Attack) {
                        tile.TileOc = OccupiedType.nothing
                    }
                }
                break
            case OccupiedType.friend:
                break
            case OccupiedType.blockedTile:
                break
        }
    }
    func Enemys_Turn() {
        for e in Entities {
            if e.IsEnemy {
                e.Move(towards: Player.Sprite.position)
            }
        }
    }
    
    func Is_In_Bounds(a: CGPoint, b: CGPoint, pos: CGPoint)->Bool {
        let betweenX:Bool = (pos.x > a.x && pos.x < b.x) || (pos.x > b.x && pos.x < a.x)
        let betweenY:Bool = (pos.y > a.y && pos.y < b.y) || (pos.y > b.y && pos.y < a.y)
        return betweenX && betweenY
    }
    func Get_Entity_At_Pos(pos: CGPoint)->Entity?{
        for e in  Entities {
            let bounds = e.Get_Bounds(pos: Entity.Relative.CENTER)
            if(Is_In_Bounds(a: bounds.lower_left, b: bounds.upper_right, pos: pos)) {
                return e;
            }
        }
        return nil;
    }
    
}


