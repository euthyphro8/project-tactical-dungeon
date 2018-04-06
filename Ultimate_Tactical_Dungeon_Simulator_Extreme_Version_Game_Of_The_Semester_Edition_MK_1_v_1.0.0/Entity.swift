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
    
    enum Relative : EnumCollection {
        case CENTER
        case NORTH
        case EAST
        case SOUTH
        case WEST
    }
    let IsEnemy:Bool
    let Sprite:SKSpriteNode
    let Max_Health:Int
    var Health:Int
    let Attack:Int
    let Defense:Int
    var Actions:[SKAction]
    
    init(sprite:SKSpriteNode, x:CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, enemy:Bool) {
        Sprite = sprite
        Sprite.position = CGPoint(x:x,y:y)
        Sprite.scale(to: CGSize(width: w, height: h))
        Sprite.zPosition = 2
        Max_Health = 100
        Health = Max_Health
        Attack = 10
        Defense = 10
        Actions = [SKAction]()
        IsEnemy = enemy
    }

    func Update() {
        for act in Actions{
            Sprite.run(act)
        }
        if(Health <= 0) {
            Sprite.removeFromParent()
        }
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
                let moveAction = SKAction.moveTo(y: Sprite.position.y + Game.TILE_SIZE, duration: 0.1)
                Actions.append(moveAction)
                break
            case Relative.EAST:
                let moveAction = SKAction.moveTo(x: Sprite.position.x + Game.TILE_SIZE, duration: 0.1)
                Actions.append(moveAction)
                break
            case Relative.SOUTH:
                let moveAction = SKAction.moveTo(y: Sprite.position.y - Game.TILE_SIZE, duration: 0.1)
                Actions.append(moveAction)
                break
            case Relative.WEST:
                let moveAction = SKAction.moveTo(x: Sprite.position.x - Game.TILE_SIZE, duration: 0.1)
                Actions.append(moveAction)
                break
            }
    }
    func Move(towards pos : CGPoint) {
        let x = Sprite.position.x - pos.x
        let y = Sprite.position.y - pos.y
        if y <= x && y >= -x {
            Move(dir: Relative.EAST)
        }
        else if y <= x && y <= -x {
            Move(dir: Relative.SOUTH)
        }
        else if y >= x && y <= -x {
            Move(dir: Relative.WEST)
        }
        else if y >= x && y >= -x {
            Move(dir: Relative.NORTH)
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
