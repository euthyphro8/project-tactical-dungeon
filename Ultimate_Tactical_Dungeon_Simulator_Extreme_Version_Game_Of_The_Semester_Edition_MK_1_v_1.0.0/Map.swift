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
    let Width:CGFloat
    let Height:CGFloat
    
    init(background:SKSpriteNode, xSize:Int, ySize:Int, width:CGFloat, height:CGFloat){
        Background = background
        background.position = CGPoint(x:CGFloat(0),y:CGFloat(0))
        XSize = xSize
        YSize = ySize
        Width = width
        Height = height
        initNodes()
    }
    
    func initNodes(){
        for i in 0...XSize {
            for j in 0...YSize{
                var point = CGPoint()
                point.x = CGFloat(i*64)-(Width/2)
                point.y = CGFloat(j*64)-(Height/2)
                Nodes.append([MapNode(x:i-(YSize/2),y:j-(XSize/2),tileOccupiedBy:OccupiedType.nothing)])
            }
        }
    }
    
    func findTile(tileX:Int,tileY:Int)->MapNode{
        for nodeA in Nodes{
            if nodeA[0].TileY == tileY{
                for node in nodeA{
                    if (tileX == node.TileX){
                        print("(Map)inputX:\(tileX),inputY:\(tileY))")
                        print("(Map)TileX:\(node.TileX),TileY:\(node.TileY))")
                        return node
                    }
                }
            }
        }
        //shouldn't make it this far...
        return Nodes[tileX][tileY]
    }
    func findTile(location:CGPoint)->MapNode{
        let xPos = Int((location.x/64>=0) ? (location.x/64).rounded(.up) : (location.x/64).rounded(.down))

        let yPos = Int((location.y/64>=0) ? (location.y/64).rounded(.up) : (location.y/64).rounded(.down))
        return findTile(tileX:xPos,tileY:yPos)
        
    }
    
    func getNodeType(point:CGPoint) -> OccupiedType{
        let tile = findTile(location:point)
        return tile.TileOc
    }
    
    
}

enum OccupiedType{
    case nothing ,enemy ,friend , blockedTile
}

class MapNode{
    
    var TileOc:OccupiedType;
    let TileX:Int
    let TileY:Int
    let Location:CGPoint
    init(x:Int, y:Int, tileOccupiedBy tileOc:OccupiedType = OccupiedType.nothing){
        TileX=x
        TileY=y
        Location = CGPoint(x:((x>=0) ? CGFloat(TileX*64-32) : CGFloat(TileX*64+32)),y:((y>=0) ? CGFloat(TileY*64-32) : CGFloat(TileY*64+32)))
        TileOc = tileOc
        
    }
    
    
}
