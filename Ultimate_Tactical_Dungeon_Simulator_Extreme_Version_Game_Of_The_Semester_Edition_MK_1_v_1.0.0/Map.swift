//
//  Map.swift
//  Ultimate_Tactical_Dungeon_Simulator_Extreme_Version_Game_Of_The_Semester_Edition_MK_1_v_1.0.0
//
//  Created by Joshua Hess on 2/23/18.
//  Copyright © 2018 Ephemerality. All rights reserved.
//

import Foundation
import SpriteKit

class Map{
    // 64p nodes
    var Background:SKSpriteNode
    var Nodes = [[MapNode]]()
    let XSize:Int
    let YSize:Int
    let NAN:MapNode
    
    init(background:SKSpriteNode, xSize:Int, ySize:Int){
        Background = background
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = 0
        XSize = xSize
        YSize = ySize
        InitNodes()
    }
    func ToPixelPrecision(tileX: Int, tileY: Int)->CGPoint {
        return CGPoint(x: tileX * 64, y: tileY * 64)
    }
    func ToTilePrecision(pos: CGPoint)->(tileX: Int, tileY: Int) {
        print("[ToTilePrecision] using \(pos) and getting (\(Int(pos.x / Game.TILE_SIZE)), \(Int(pos.y / Game.TILE_SIZE)))")
        return (tileX: pos.x < 0 ? Int(pos.x / Game.TILE_SIZE) - 1 :  Int(pos.x / Game.TILE_SIZE), 
                    tileY: pos.y < 0 ? Int(pos.y / Game.TILE_SIZE) - 1 : Int(pos.y / Game.TILE_SIZE))
    }
    func ToTilePrecision(indexX: Int, indexY: Int)->(tileX: Int, tileY: Int) {
        return (tileX: indexX - (XSize / 2), tileY: indexY - (YSize / 2))
    }
    func ToIndexPrecision(tileX: Int, tileY: Int)->(indexX: Int, indexY: Int) {
        return (indexX: tileX + (XSize / 2), indexY: tileY + (YSize / 2))
    }
    func InitNodes(){
        for i in 0...XSize {
            var nodes = [MapNode]()
            for j in 0...YSize {
                let tile = ToTilePrecision(indexX: i, indexY: j)
                let pos = ToPixelPrecision(tileX: tile.tileX, tileY: tile.tileY)
                let node = MapNode(x:tile.tileX, y:tile.tileY, pos:pos)
                nodes.append(node)
            }
            Nodes.append(nodes)
        }
        NAN = MapNode(tileX: 0, tileY: 0, pos: CGPoint(0, 0))
        NAN.TileOc = OccupiedType.nan
    }
    func findTile(tileX: Int,tileY: Int)->MapNode{
        var index = ToIndexPrecision(tileX: tileX, tileY: tileY)
        if index.indexX >= XSize || index.indexY >= YSize {
            print("[Warning][Map][FindTile] Out of bounds, return node at 0,0.")
            return NAN
        }
        print("[FindTile] Turned (\(tileX),\(tileY)) to (\(index.indexX),\(index.indexY))")
        return Nodes[index.indexX][index.indexY]
    }
    func findTile(location:CGPoint)->MapNode{
        let tile = ToTilePrecision(pos: location)
        return findTile(tileX: tile.tileX, tileY: tile.tileY)
    }
    func getNodeType(location:CGPoint) -> OccupiedType{
        return findTile(location: location).TileOc
    }
}

enum OccupiedType{
    case nothing, enemy, friend, blockedTile, nan
}

class MapNode{
    
    var TileOc:OccupiedType;
    let TileX:Int
    let TileY:Int
    let Location:CGPoint
    init(x:Int, y:Int, pos: CGPoint, tileOccupiedBy tileOc:OccupiedType = OccupiedType.nothing){
        TileX=x
        TileY=y
        Location = pos
        TileOc = tileOc
    }
}
