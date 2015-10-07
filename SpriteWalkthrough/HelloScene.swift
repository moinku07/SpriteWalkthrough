//
//  HelloScene.swift
//  SpriteWalkthrough
//
//  Created by Moin Uddin on 6/10/15.
//  Copyright (c) 2015 Moin Uddin. All rights reserved.
//

import SpriteKit

class HelloScene: SKScene {
    
    var contentCreated: Bool = false
    
    override func didMoveToView(view: SKView) {
        if !self.contentCreated{
            self.createSceneContents()
            self.contentCreated = true
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * Int64(NSEC_PER_SEC)), dispatch_get_main_queue()){
                self.bringNextScene()
            }
        }
    }
    
    func createSceneContents(){
        self.backgroundColor = SKColor.blueColor()
        self.scaleMode = SKSceneScaleMode.AspectFit
        self.addChild(self.newHelloNode())
    }
    
    func newHelloNode()->SKLabelNode{
        let helloNode: SKLabelNode = SKLabelNode(fontNamed: "Chalkduster")
        helloNode.name = "helloNode"
        helloNode.text = "Space Ship"
        helloNode.fontSize = 42
        helloNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        return helloNode
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        if let helloNode: SKNode = self.childNodeWithName("helloNode"){
            helloNode.name = nil
            let moveUp: SKAction = SKAction.moveByX(0, y: 100, duration: 0.5)
            let zoom: SKAction = SKAction.scaleTo(2, duration: 0.25)
            let pause: SKAction = SKAction.waitForDuration(0.5)
            let fadeAway: SKAction = SKAction.fadeOutWithDuration(0.25)
            let remove: SKAction = SKAction.removeFromParent()
            let moveSequence: SKAction = SKAction.sequence([moveUp,zoom,pause,fadeAway,remove])
            //helloNode.runAction(moveSequence)
            helloNode.runAction(moveSequence, completion: { () -> Void in
                let spaceshipScene: SpaceshipScene = SpaceshipScene()
                spaceshipScene.size = self.size
                let doors: SKTransition = SKTransition.doorsOpenVerticalWithDuration(0.5)
                self.view?.presentScene(spaceshipScene, transition: doors)
            })
        }//else{
            //self.addChild(self.newHelloNode())
        //}
        
    }
    
    func bringNextScene(){
        if let helloNode: SKNode = self.childNodeWithName("helloNode"){
            helloNode.name = nil
            let moveUp: SKAction = SKAction.moveByX(0, y: 100, duration: 0.5)
            let zoom: SKAction = SKAction.scaleTo(2, duration: 0.25)
            let pause: SKAction = SKAction.waitForDuration(0.5)
            let fadeAway: SKAction = SKAction.fadeOutWithDuration(0.25)
            let remove: SKAction = SKAction.removeFromParent()
            let moveSequence: SKAction = SKAction.sequence([moveUp,zoom,pause,fadeAway,remove])
            //helloNode.runAction(moveSequence)
            helloNode.runAction(moveSequence, completion: { () -> Void in
                let spaceshipScene: SpaceshipScene = SpaceshipScene()
                spaceshipScene.size = self.size
                let doors: SKTransition = SKTransition.doorsOpenVerticalWithDuration(0.5)
                self.view?.presentScene(spaceshipScene, transition: doors)
            })
        }
    }
}
