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
    let Background = SKSpriteNode()
    var Nodes = [MapNode]()
    
    
//    func getNodeType(location:CGPoint){
//        for aNode in nodes{
//            if(aNode.loc == location){
//
//            }
//        }
//    }
    
//    func setNodeType(node:MapNode , type:MapNode.occupiedType){
//
//    }
    
    
}

struct MapNode{
    enum occupiedType{
        case nothing ,enemy ,friend , blockedTile
    }
    var TileOc:occupiedType;
    let Loc:CGPoint
    
    init(location:CGPoint , tileOccupiedBy tileOc:occupiedType){
        Loc = location
        TileOc = tileOc
    }
    
    
}
