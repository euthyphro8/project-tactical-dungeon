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
        Player = Entity(sprite:SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "player_tmp"))), x:GameMap.findTile(tileX:1, tileY: 1).Location.x, y:GameMap.findTile(tileX:1, tileY: 1).Location.y, w:64, h:64)
        Player.Sprite.zPosition = 2
        Entities.append(Player)
        Actions = [SKAction]()
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
        for act in game.Actions{
            game.SelectedTile.run(act)
        }
        //Run the entity actions
        for e in Entities {
            e.Update();
        }
    }
    func Move_Selection(to: CGPoint) {
        let moveActionX = SKAction.moveTo(x: to.x, duration: 0.1)
        let moveActionY = SKAction.moveTo(y: to.y, duration: 0.1)
        Actions.append(moveActionX)
        Actions.append(moveActionY)
    }
    func Touch_Down(atPoint pos : CGPoint) {
        let tile:MapNode = GameMap.findTile(location: pos)
        let ptile:MapNode = GameMap.findTile(location: Player.Sprite.position)
        Move_Selection(to: tile.Location);

        switch tile.TileOc {
            case MapNode.occupiedType.nothing:
                if(ptile.TileX == tile.TileX) {
                    if(ptile.TileY + 1 == tile.TileY) {
                        tile.TileOC = MapNode.occupiedType.friend;
                        pTile.TileOC = MapNode.occupiedType.nothing;
                        Player.Move(dir: Entity.Relative.NORTH);
                    }
                    else if(ptile.TileY - 1 == tile.TileY) {
                        tile.TileOC = MapNode.occupiedType.friend;
                        pTile.TileOC = MapNode.occupiedType.nothing;
                        Player.Move(dir: Entity.Relative.SOUTH);
                    }
                }
                else if(ptile.TileY == tile.TileY) {
                    if(ptile.TileX + 1 == tile.TileX) {
                        tile.TileOC = MapNode.occupiedType.friend;
                        pTile.TileOC = MapNode.occupiedType.nothing;
                        Player.Move(dir: Entity.Relative.EAST);
                    }
                    else if(ptile.TileX - 1 == tile.TileX) {
                        tile.TileOC = MapNode.occupiedType.friend;
                        pTile.TileOC = MapNode.occupiedType.nothing;
                        Player.Move(dir: Entity.Relative.WEST);
                    }
                }
                break
            case MapNode.occupiedType.enemy:
                break
            case MapNode.occupiedType.friend:
                break
            case MapNode.occupiedType.blockedtile:
                break
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


