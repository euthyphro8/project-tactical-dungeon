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
import Darwin

public class Entity {
    
    enum Relative : EnumCollection {
        case CENTER
        case NORTH
        case EAST
        case SOUTH
        case WEST
    }
    let IsEnemy:Bool
    let Sprite:SKSpriteNode
    let Atlas:SKTextureAtlas
    let Title:SKLabelNode
    var TitleText:String
    
    let Max_Health:Int
    var Health:Int
    let Attack:Int
    let Defense:Int
    let Agility:Int
    var Actions:[SKAction]


    
    init(sprite:SKSpriteNode, x:CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, enemy:Bool, atlas:SKTextureAtlas) {
        Max_Health = 100
        Health = Max_Health
        Attack = 10
        Defense = 10
        Actions = [SKAction]()
        IsEnemy = enemy
        Agility = IsEnemy ? 60 : 80

        Atlas = atlas
        Sprite = sprite
        Sprite.position = CGPoint(x:x,y:y)
        Sprite.scale(to: CGSize(width: w, height: h))
        Sprite.zPosition = 3

        TitleText = (IsEnemy ? "Enemy" : "Player") + " \(Health) / \(Max_Health)"
        Title = SKLabelNode(text: TitleText)
        Title.fontSize = 20
        Title.color = SKColor.black
        Title.position = CGPoint(x: x, y: y + 40)
        Title.zPosition = 3
    }

    func Update() {
        for act in Actions{
            Sprite.run(act)
        }
        if(Health <= 0) {
            Sprite.removeFromParent()
            Title.removeFromParent()
        }
        
        TitleText = (IsEnemy ? "Enemy" : "Player") + " \(Health) / \(Max_Health)"
        Title.text = TitleText
        Title.position = CGPoint(x: Sprite.position.x, y: Sprite.position.y + 40)
    }

    func Damage(Damage:Int)->Bool {
        let dead = Health - Damage <= 0
        Health = dead ? 0 : Health - Damage
        return dead
    }
    func Move(dir:Relative) {
        switch dir {
            case Relative.CENTER:
                break
            case Relative.NORTH:
                Sprite.texture = Atlas.textureNamed("image12")
                let moveAction = SKAction.moveTo(y: Sprite.position.y + Game.TILE_SIZE, duration: 0.1)
                Actions.append(moveAction)
                break
            case Relative.EAST:
                Sprite.texture = Atlas.textureNamed("image08")
                let moveAction = SKAction.moveTo(x: Sprite.position.x + Game.TILE_SIZE, duration: 0.1)
                Actions.append(moveAction)
                break
            case Relative.SOUTH:
                Sprite.texture = Atlas.textureNamed("image00")
                let moveAction = SKAction.moveTo(y: Sprite.position.y - Game.TILE_SIZE, duration: 0.1)
                Actions.append(moveAction)
                break
            case Relative.WEST:
                Sprite.texture = Atlas.textureNamed("image04")
                let moveAction = SKAction.moveTo(x: Sprite.position.x - Game.TILE_SIZE, duration: 0.1)
                Actions.append(moveAction)
                break
            }
    }
    ///Enemy turn : returns true if attack and false if otherwise.
    func TakeTurn(player: Entity, from: MapNode, to: MapNode)->Int {
        //print("Taking turn")
        let xx = to.TileX - from.TileX
        let yy = to.TileY - from.TileY
        let x = abs(xx)
        let y = abs(yy)
        if x < 2 && y < 2 {
            let dmg = GetAttack()
            if dmg != 0 {
                if player.Damage(Damage: Attack) {
                    print("Game Over")
                    //Game over
                    return dmg // Changed from Damage to dmg to make code compile...not sure if that's a real fix - Nathanael
                }
            }
            else {
                return -1
            }
            return dmg // Changed from Damage to dmg to make code compile...not sure if that's a real fix - Nathanael
        }
        if y <= x || y < 2 {
            if xx < 0 {
                Move(dir: Relative.WEST)
                from.TileOc = OccupiedType.nothing
                return 0
            }
            if xx > 0 {
                Move(dir: Relative.EAST)
                from.TileOc = OccupiedType.nothing
                return 0
            }
        }
        if x < y || x < 2 {
            if yy < 0 {
                Move(dir: Relative.SOUTH)
                from.TileOc = OccupiedType.nothing
                return 0
            }
            if yy > 0 {
                Move(dir: Relative.NORTH)
                from.TileOc = OccupiedType.nothing
                return 0
            }
        }
        print("[Entity][TakeTurn] Reached end of block and entity hasn't taken a turn at (\(from.TileX), \(from.TileY)) with player at (\(to.TileX), \(to.TileY)).")
        return 0
    }
    func Move(towards pos : CGPoint) {
//        let x = Sprite.position.x - pos.x
//        let y = Sprite.position.y - pos.y
//        if y <= x && y >= -x {
//            Move(dir: Relative.EAST)
//        }
//        else if y <= x && y <= -x {
//            Move(dir: Relative.SOUTH)
//        }
//        else if y >= x && y <= -x {
//            Move(dir: Relative.WEST)
//        }
//        else if y >= x && y >= -x {
//            Move(dir: Relative.NORTH)
//        }
    }
    func GetAttack()->Int {
       let rng = Int(arc4random_uniform(100))
       if rng <= Agility {
           return Attack
       }
       else {
           return 0
       }

    }
    func Get_Bounds(pos:Relative)->(lower_left:CGPoint, upper_right:CGPoint) {
        var x0:CGFloat = 1
        var y0:CGFloat = 1
        var x1:CGFloat = 1
        var y1:CGFloat = 1
        switch pos {
            case Relative.CENTER:
                x0 = -1
                y0 = -1
                x1 = 1
                y1 = 1
                break
            case Relative.NORTH:
                x0 = -1
                y0 = 1
                x1 = 1
                y1 = 3
                break
            case Relative.EAST:
                x0 = 1
                y0 = -1
                x1 = 3
                y1 = 1
                break
            case Relative.SOUTH:
                x0 = -1
                y0 = -3
                x1 = 1
                y1 = -1
                break
            case Relative.WEST:
                x0 = -3
                y0 = -1
                x1 = -1
                y1 = 1
                break
        }
        let a = CGPoint(x:Sprite.position.x + ((Sprite.size.width / 2) * x0), y:Sprite.position.y + ((Sprite.size.height / 2) * y0))
        let b = CGPoint(x:Sprite.position.x + ((Sprite.size.width / 2) * x1), y:Sprite.position.y + ((Sprite.size.height / 2) * y1))
        return (a, b)
    }
}

protocol EnumCollection : Hashable {}
extension EnumCollection {
    static func Cases() -> AnySequence<Self> {
        typealias S = Self
        return AnySequence { () -> AnyIterator<S> in
            var raw = 0
            return AnyIterator {
                let current : Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: S.self, capacity: 1) { $0.pointee } }
                guard current.hashValue == raw else { return nil }
                raw += 1
                return current
            }
        }
    }
}
