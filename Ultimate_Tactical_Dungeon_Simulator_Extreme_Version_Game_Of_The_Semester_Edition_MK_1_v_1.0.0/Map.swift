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
    let Background = SKSpriteNode(SKTexture())
    var Nodes = [[MapNode]]()
    
    
    func initNodes(xSize:Int, ySize:Int){
        
        for i in 0...xSize {
            for j in 0...ySize{
                var point = CGPoint()
                point.x = CGFloat(i*64)
                point.y = CGFloat(j*64)
                Nodes.append([MapNode(location:point,tileOccupiedBy:MapNode.occupiedType.nothing)])
            }
        }
//        Background=SkSpriteNode()
        
    }
    
    func getNodeType(location:CGPoint) -> MapNode.occupiedType{
        for aNodeA in Nodes{
            for aNode in aNodeA{
                    if(aNode.Loc == location){
                        return aNode.TileOc
                }
            }
        }
        //if past this point something is wrong
        return MapNode.occupiedType.blockedTile
    }
    
//    func setNodeType(node:MapNode , type:MapNode.occupiedType){
//
//    }
    
    
}

class MapNode{
    enum occupiedType{
        case nothing ,enemy ,friend , blockedTile
    }
    var TileOc:occupiedType;
    let Loc:CGPoint
    
    init(location:CGPoint , tileOccupiedBy tileOc:occupiedType = occupiedType.nothing){
        Loc = location
        TileOc = tileOc
    }
    
    
}
