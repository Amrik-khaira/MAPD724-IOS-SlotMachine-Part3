//  WiningScene.swift
//  Author's name : Amrik Singh
//  StudentID : 301296257
//
//  Slot Machine Part 2
//
//  Created by Amrik on 04/02/23.
//
// Version: 2.0


import SpriteKit

class WiningScene: SKScene {
    //SpriteKit variables
    var player = SKSpriteNode()
    var textureArr = [SKTexture]()
    
    override func didMove(to view: SKView) {
        //Setup sprite node
        backgroundColor = SKColor.clear
        let AnimatedAtlas = SKTextureAtlas(named: "confetti")
        let numImages = AnimatedAtlas.textureNames.count
        //lode images in array for animating
        for i in 0 ..< numImages {
            let textureName = "7c4e638c439a481bb01eb7d989b1a46dwSa98TayipX6EeeY-\(i)"
            textureArr.append(SKTexture(imageNamed: textureName))
        }
        //Setup default texture
        let firstFrameTexture = textureArr[0]
        player = SKSpriteNode(texture: firstFrameTexture)
        player.position = CGPoint(x: size.width/2, y: size.height/1.6)
        player.size = CGSize(width: 300, height: 450)
        player.zPosition = 1
        self.addChild(player)
        //Execute texture animaton
        player.run(SKAction.repeatForever(
            SKAction.animate(with: textureArr,
                             timePerFrame: 0.1,
                             resize: false,
                             restore: true)),
                   withKey:"confittie")
    }
}
