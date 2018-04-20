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
        GameMap = Map(background:SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "grid10x10"))), xSize:10, ySize:10)
        SelectedTile = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "redHighlight")))
        SelectedTile.zPosition = 3
        SelectedTile.position = GameMap.findTile(tileX:1,tileY:1).Location
        
        //Player
        let pTile = GameMap.findTile(tileX: 1, tileY: 1);
        Player = Entity(sprite:SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "player_tmp"))), x:pTile.Location.x, y:pTile.Location.y, w:Game.TILE_SIZE, h:Game.TILE_SIZE, enemy:false)
        pTile.TileOc = OccupiedType.friend
        //Enemy
        let eTile = GameMap.findTile(tileX:3, tileY: 3);
        let enemy = Entity(sprite:SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "enemy_tmp"))), x:eTile.Location.x, y:eTile.Location.y, w:Game.TILE_SIZE, h:Game.TILE_SIZE, enemy:true)
        eTile.TileOc = OccupiedType.enemy
        
        Entities.append(enemy)
        Entities.append(Player)
        
        Actions = [SKAction]()
        IsPlayerTurn = true
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
        let moveAction = SKAction.move(to: to, duration: 0.1)
        Actions.append(moveAction)
    }
    func Touch_Down(atPoint pos : CGPoint) {
        if IsPlayerTurn {
            if Players_Turn(atPoint: pos) {
                //print("[Player] took their turn.")
                IsPlayerTurn = false
            }
        }
        else {
            //TODO: Simply move selection tile
            let tile:MapNode = GameMap.findTile(location: pos)
            Move_Selection(to: tile.Location);
        }
    }
    func Players_Turn(atPoint pos : CGPoint)->Bool {
        print("Input at \(pos)")
        let tile:MapNode = GameMap.findTile(location: pos)
        print("Got tile from input \(tile.Location) at index \(tile.TileX), \(tile.TileX)")
        let ptile:MapNode = GameMap.findTile(location: Player.Sprite.position)
        print("Player tile at \(ptile.Location) at index \(ptile.TileX), \(ptile.TileX)")
        Move_Selection(to: tile.Location);
        
        
        switch tile.TileOc {
            case OccupiedType.nothing:
                if(ptile.TileX == tile.TileX) {
                    if(ptile.TileY + 1 == tile.TileY || (ptile.TileY == -1 && tile.TileY == 1)) {
                        tile.TileOc = OccupiedType.friend;
                        ptile.TileOc = OccupiedType.nothing;
                        Player.Move(dir: Entity.Relative.NORTH);
                        return true
                    }
                    else if(ptile.TileY - 1 == tile.TileY || (ptile.TileY == 1 && tile.TileY == -1)) {
                        tile.TileOc = OccupiedType.friend;
                        ptile.TileOc = OccupiedType.nothing;
                        Player.Move(dir: Entity.Relative.SOUTH);
                        return true
                    }
                }
                else if(ptile.TileY == tile.TileY) {
                    if(ptile.TileX + 1 == tile.TileX || (ptile.TileX == -1 && tile.TileX == 1)) {
                        tile.TileOc = OccupiedType.friend;
                        ptile.TileOc = OccupiedType.nothing;
                        Player.Move(dir: Entity.Relative.EAST);
                        return true
                    }
                    else if(ptile.TileX - 1 == tile.TileX || (ptile.TileX == 1 && tile.TileX == -1)) {
                        tile.TileOc = OccupiedType.friend;
                        ptile.TileOc = OccupiedType.nothing;
                        Player.Move(dir: Entity.Relative.WEST);
                        return true
                    }
                }
                break
            case OccupiedType.enemy:
                if let e = Get_Entity_At_Pos(pos: pos) {
                    if e.Damage(Damage: Player.Attack) {
                        tile.TileOc = OccupiedType.nothing
                    }
                    return true
                }
                break
            case OccupiedType.friend:
                break
            case OccupiedType.blockedTile:
                break
        }
        return false
    }
    func Enemys_Turn() {
        for e in Entities {
            if e.IsEnemy {
                let tile:MapNode = GameMap.findTile(location: e.Sprite.position)
                let ptile:MapNode = GameMap.findTile(location: Player.Sprite.position)
                e.TakeTurn(player: Player, from: tile, to: ptile)
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


