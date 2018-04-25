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
import Darwin
import AVFoundation

public class Game {
    
    static let TILE_SIZE:CGFloat = 64

    var DeathAudio:AVAudioPlayer?;
    var Entities = [Entity]()
    let Player:Entity;
    let GameMap:Map;

    let SelectedTile:SKSpriteNode;
    let ProgressBar:SKSpriteNode;
    let AttackButton:SKSpriteNode;
    let TurnLabel:SKLabelNode;
    let SwordTexture:SKTexture;
    let BowTexture:SKTexture;
    let ConsoleLabel:SKLabelNode;
    let YouDied:SKSpriteNode;
    let BlackBar:SKSpriteNode;

    //False for melee, true for ranged
    var AttackMode:Bool = false;
    var HasDied:Bool = false;
    var Actions:[SKAction]
    var IsPlayerTurn: Bool
    let DelayTime = 30
    var DelayTimer = 30
    var Scene:SKScene?;
    
    init(){
        //let deathPath = URL(fileURLWithPath:(forResource: "you_ded", ofType: "mp3")!)
        //DeathAudio = try? AVAudioPlayer(contentsOf: deathPath)
        GameMap = Map(background:SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "map1600x1600"))), xSize:25, ySize:25)

        SelectedTile = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "selectionframe")))
        SelectedTile.zPosition = 2
        SelectedTile.position = GameMap.findTile(tileX:1,tileY:1).Location
        
        ProgressBar = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "greenHighlight")))
        ProgressBar.position = CGPoint(x: 0, y: 180)
        ProgressBar.scale(to: CGSize(width: 350, height: 65))
        ProgressBar.zPosition = 4
        
        TurnLabel = SKLabelNode(text: "Player's Turn")
        TurnLabel.fontSize = 55
        TurnLabel.fontColor = SKColor.black
        TurnLabel.position = CGPoint(x: 0, y: 160)
        TurnLabel.zPosition = 5
        TurnLabel.fontName = "Marion-Bold"

        ConsoleLabel = SKLabelNode(text: "Game initialized")
        ConsoleLabel.fontSize = 28
        ConsoleLabel.fontColor = SKColor.black
        ConsoleLabel.position = CGPoint(x: -175, y: -200)
        ConsoleLabel.zPosition = 4
        ConsoleLabel.fontName = "Marion-Bold"

        BowTexture = SKTexture(image: #imageLiteral(resourceName: "bow_button"))
        SwordTexture = SKTexture(image: #imageLiteral(resourceName: "sword_button"))
        AttackButton = SKSpriteNode(texture: SwordTexture)
        AttackButton.position = CGPoint(x: 300, y: -150)
        AttackButton.scale(to: CGSize(width: 64, height: 64))
        AttackButton.zPosition = 5
        
        YouDied = SKSpriteNode(texture: SKTexture(image:#imageLiteral(resourceName: "uded")))
        YouDied.scale(to: CGSize(width:250,height:100))
        YouDied.zPosition = 10
        YouDied.run(SKAction.fadeOut(withDuration: 0))
        BlackBar = SKSpriteNode(texture: SKTexture(image:#imageLiteral(resourceName: "bb")))
        BlackBar.scale(to: CGSize(width:900,height:150))
        BlackBar.zPosition = 9
        BlackBar.run(SKAction.fadeOut(withDuration: 0))
        
        

        //Player
        let pTile = GameMap.findTile(tileX: -5, tileY: 0);
        //let pAtlas = SKTextureAtlas(named:"knight")
        let pAtlas = SKTextureAtlas(dictionary: ["image00":#imageLiteral(resourceName: "knight_00"), "image01":#imageLiteral(resourceName: "knight_01"), "image02":#imageLiteral(resourceName: "knight_02"), "image03":#imageLiteral(resourceName: "knight_03"), "image04":#imageLiteral(resourceName: "knight_04"), "image05":#imageLiteral(resourceName: "knight_05"), "image06":#imageLiteral(resourceName: "knight_06"), "image07":#imageLiteral(resourceName: "knight_07"), "image08":#imageLiteral(resourceName: "knight_08"), "image09":#imageLiteral(resourceName: "knight_09"), "image10":#imageLiteral(resourceName: "knight_10"), "image11":#imageLiteral(resourceName: "knight_11"), "image12":#imageLiteral(resourceName: "knight_12"),"image13":#imageLiteral(resourceName: "knight_13"),"image14":#imageLiteral(resourceName: "knight_14"), "image15":#imageLiteral(resourceName: "knight_15")])
        
        Player = Entity(sprite:SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "knight_00"))), x:pTile.Location.x, y:pTile.Location.y, w:Game.TILE_SIZE, h:Game.TILE_SIZE, enemy:false, atlas:pAtlas)
        pTile.TileOc = OccupiedType.friend
        //Enemy
        let eTile1 = GameMap.findTile(tileX:12, tileY: 12);
        let eTile2 = GameMap.findTile(tileX:-10, tileY: 10);
        let eTile3 = GameMap.findTile(tileX:5, tileY: 2);
        let eTile4 = GameMap.findTile(tileX:5, tileY: -2);
        //let eAtlas = SKTextureAtlas(named:"something")
        let eAtlas = SKTextureAtlas(dictionary: ["image00":#imageLiteral(resourceName: "demon_00"), "image01":#imageLiteral(resourceName: "demon_01"), "image02":#imageLiteral(resourceName: "demon_02"), "image03":#imageLiteral(resourceName: "demon_03"), "image04":#imageLiteral(resourceName: "demon_04"), "image05":#imageLiteral(resourceName: "demon_05"), "image06":#imageLiteral(resourceName: "demon_06"), "image07":#imageLiteral(resourceName: "demon_07"), "image08":#imageLiteral(resourceName: "demon_08"), "image09":#imageLiteral(resourceName: "demon_09"), "image10":#imageLiteral(resourceName: "demon_10"), "image11":#imageLiteral(resourceName: "demon_11"), "image12":#imageLiteral(resourceName: "demon_12"),"image13":#imageLiteral(resourceName: "demon_13"),"image14":#imageLiteral(resourceName: "demon_14"), "image15":#imageLiteral(resourceName: "demon_15")])
        
        let enemy1 = Entity(sprite:SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "demon_00"))), x:eTile1.Location.x, y:eTile1.Location.y, w:Game.TILE_SIZE, h:Game.TILE_SIZE, enemy:true,atlas:eAtlas)
        let enemy2 = Entity(sprite:SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "demon_00"))), x:eTile2.Location.x, y:eTile2.Location.y, w:Game.TILE_SIZE, h:Game.TILE_SIZE, enemy:true,atlas:eAtlas)
        let enemy3 = Entity(sprite:SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "demon_00"))), x:eTile3.Location.x, y:eTile3.Location.y, w:Game.TILE_SIZE, h:Game.TILE_SIZE, enemy:true,atlas:eAtlas)
        let enemy4 = Entity(sprite:SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "demon_00"))), x:eTile4.Location.x, y:eTile4.Location.y, w:Game.TILE_SIZE, h:Game.TILE_SIZE, enemy:true,atlas:eAtlas)
        eTile1.TileOc = OccupiedType.enemy
        eTile2.TileOc = OccupiedType.enemy
        eTile3.TileOc = OccupiedType.enemy
        eTile4.TileOc = OccupiedType.enemy
        
        Entities.append(enemy1)
        Entities.append(enemy2)
        Entities.append(enemy3)
        Entities.append(enemy4)
        Entities.append(Player)
        
        Actions = [SKAction]()
        IsPlayerTurn = true
    }
    func Add_Children(GameScene:SKScene) {
        GameScene.addChild(GameMap.Background)
        GameScene.addChild(SelectedTile)
        for ent in Entities {
            GameScene.addChild(ent.Sprite)
            GameScene.addChild(ent.Title)
        }
        GameScene.addChild(TurnLabel)
        GameScene.addChild(ProgressBar)
        GameScene.addChild(AttackButton)
        GameScene.addChild(ConsoleLabel)
        GameScene.addChild(YouDied)
        GameScene.addChild(BlackBar)
        Scene = GameScene
    }
    
    func Update() {
        if HasDied{
            return
        }
        if Player.Health <= 0{
            HasDied = true
        }
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
                ProgressBar.size.width = CGFloat(350 / DelayTime * DelayTimer)
            }
            else {
                Enemys_Turn()
                DelayTimer = DelayTime
                TurnLabel.text = "Player's Turn"
                IsPlayerTurn = true
            }
        }
        if HasDied {
            Scene?.run(SKAction.playSoundFileNamed("you_ded.mp3", waitForCompletion: false))
            YouDied.run(SKAction.fadeIn(withDuration: 5))
            BlackBar.run(SKAction.fadeIn(withDuration: 5))
            
        }
        
    }

    func Move_Selection(to: CGPoint) {
        let moveAction = SKAction.move(to: to, duration: 0.1)
        Actions.append(moveAction)
    }
    func PushMessageToLabel(msg: String) {
        
    }

    func CheckUI(pos : CGPoint)->Bool {
        let a = CGPoint(x:AttackButton.position.x - (AttackButton.size.width / 2), y:AttackButton.position.y - (AttackButton.size.height / 2))
        let b = CGPoint(x:AttackButton.position.x + (AttackButton.size.width / 2), y:AttackButton.position.y + (AttackButton.size.height / 2))
        if (pos.x >= a.x && pos.x < b.x && pos.y >= a.y && pos.y < b.y) {
            AttackMode = !AttackMode
            AttackButton.texture = AttackMode ? BowTexture : SwordTexture
            return true
        }
        return false
    }

    func Touch_Down(atPoint pos : CGPoint) {
        if CheckUI(pos: pos) {
            return;
        }
        if IsPlayerTurn {
            if Players_Turn(atPoint: pos) {
                TurnLabel.text = "Enemy's Turn"
                ProgressBar.size.width = 100
                IsPlayerTurn = false
            }
        }
        else {
            //TODO: Simply move selection tile
            let tile:MapNode = GameMap.findTile(location: pos)
            if tile.TileOc != OccupiedType.nan {
                Move_Selection(to: tile.Location)
            }
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
            case .nan:
                break
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
                let dmg = Player.GetAttack()
                if let e = Get_Entity_At_Pos(pos: pos) {
                    if AttackMode {
                        if dmg == 0 {
                            ConsoleLabel.text = "Player missed."
                            return true;
                        }
                        if e.Damage(Damage: Player.Attack) {
                            tile.TileOc = OccupiedType.nothing
                        }
                        ConsoleLabel.text = "Player did \(dmg) damage to enemy."
                        return true
                    }
                    else {
                        let xx = abs(tile.TileX - ptile.TileX)
                        let yy = abs(tile.TileY - ptile.TileY)
                        if xx < 2 && yy < 2 {
                            if dmg == 0 {
                                ConsoleLabel.text = "Player missed."
                                return true;
                            }
                            if e.Damage(Damage: dmg) {
                                tile.TileOc = OccupiedType.nothing
                            }
                            return true
                        }
                    }
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
                let result = e.TakeTurn(player: Player, from: tile, to: ptile) 
                if  result.dmg == -1 || result.dmg == 0
                {
                    ConsoleLabel.text = "Enemy missed attack."
                }
                else if result.dmg > 0 {
                    ConsoleLabel.text = "Enemy did \(result.dmg) damage to player."
                }
                else if result.dmg == -2 {
                    let newTile:MapNode = GameMap.findTile(location: result.newPos)
                    newTile.TileOc = OccupiedType.enemy
                    tile.TileOc = OccupiedType.nothing
                }
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


