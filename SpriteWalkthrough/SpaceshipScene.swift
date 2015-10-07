//
//  SpaceshipScene.swift
//  SpriteWalkthrough
//
//  Created by Moin Uddin on 6/10/15.
//  Copyright (c) 2015 Moin Uddin. All rights reserved.
//

import SpriteKit

extension SKColor{
    class func randomColor() -> SKColor{
        var randomRed:CGFloat = CGFloat(arc4random() % 256) / 256
        var randomGreen:CGFloat = CGFloat(arc4random() % 256) / 256
        var randomBlue:CGFloat = CGFloat(arc4random() % 256) / 256
        return SKColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    class func randomColor2() ->SKColor{
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
        
        return SKColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
}

class SpaceshipScene: SKScene {
    
    var contentCreated: Bool = false
    
    var spaceShip: SKSpriteNode!
    
    func skRandf() -> CGFloat{
        return CGFloat(rand()) / CGFloat(RAND_MAX)
    }
    
    func skRand(low: CGFloat, high: CGFloat) -> CGFloat{
        return skRandf() * (high - low) + low
    }
    
    func skRandBool()->Bool{
        let number: Float = Float(arc4random() % 61) + 40
        if number % 2 == 0{
            return true
        }
        return false
    }
    
    override func didMoveToView(view: SKView) {
        self.physicsWorld.gravity = CGVectorMake(0, -2.0)
        if !self.contentCreated{
            self.createSceneContents()
            self.contentCreated = true
        }
    }
    
    func createSceneContents(){
        self.backgroundColor = SKColor.grayColor()
        self.scaleMode = SKSceneScaleMode.AspectFit
        //self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        
        spaceShip = self.newSpaceship()
        spaceShip.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        
        let makeRocks: SKAction = SKAction.sequence([
            SKAction.runBlock({self.addRock(self)}),
            SKAction.waitForDuration(0.50, withRange: 0.15)
        ])
        
        self.runAction(SKAction.repeatActionForever(makeRocks))
        
        self.addChild(spaceShip)
    }
    
    func addRock(target: SKScene){
        
        var addedObject: AnyObject!
        
        if skRandBool(){
            let sizeX: CGFloat = skRand(10, high: 20)
            let rock: SKShapeNode = SKShapeNode(circleOfRadius: sizeX)
            rock.position = CGPointMake(skRand(0, high: self.size.width), self.size.height)
            rock.name = "rock"
            
            rock.fillColor = SKColor.randomColor()
            rock.strokeColor = SKColor.clearColor()
            
            rock.physicsBody = SKPhysicsBody(circleOfRadius: sizeX)
            //rock.physicsBody?.mass = 100
            //rock.physicsBody?.density = 100
            //println(rock.physicsBody?.mass)
            rock.physicsBody?.usesPreciseCollisionDetection = true
            target.addChild(rock)
            addedObject = rock
        }else{
            let sizeX: CGFloat = skRand(20, high: 40)
            let rock: SKSpriteNode = SKSpriteNode(color: SKColor.randomColor(), size: CGSizeMake(sizeX, sizeX))
            
            rock.position = CGPointMake(skRand(0, high: self.size.width), self.size.height)
            rock.name = "rock"
            rock.physicsBody = SKPhysicsBody(rectangleOfSize: rock.size)
            rock.physicsBody?.usesPreciseCollisionDetection = true
            target.addChild(rock)
            addedObject = rock
        }
        
        if skRandBool(){
            if addedObject.isKindOfClass(SKSpriteNode){
                let pulseColor: SKAction = SKAction.sequence([
                    SKAction.colorizeWithColor(SKColor.randomColor(), colorBlendFactor: 1.0, duration: 0.15),
                    SKAction.waitForDuration(0.15),
                    SKAction.colorizeWithColor(SKColor.randomColor2(), colorBlendFactor: 1.0, duration: 0.15),
                    ])
                let obj: SKSpriteNode = addedObject as! SKSpriteNode
                obj.runAction(SKAction.repeatActionForever(pulseColor))
                //obj.blendMode = SKBlendMode.Add
                //obj.physicsBody?.affectedByGravity = false
            }
        }
    }
    
    func newSpaceship() -> SKSpriteNode{
        //let hull: SKSpriteNode = SKSpriteNode(color: SKColor.grayColor(), size: CGSizeMake(64, 32))
        let hull: SKSpriteNode = SKSpriteNode(imageNamed: "Spaceship")
        hull.size = CGSizeMake(64, 56.36)
        
        hull.color = SKColor.redColor()
        hull.colorBlendFactor = 0.5
        
        //hull.physicsBody = SKPhysicsBody(rectangleOfSize: hull.size)
        hull.physicsBody = SKPhysicsBody(texture: hull.texture, size: hull.size)
        hull.physicsBody?.allowsRotation = false
        hull.physicsBody?.dynamic = false
        
        /*let light1: SKSpriteNode = self.newLight()
        light1.position = CGPointMake(-24, -27)
        hull.addChild(light1)
        
        let light2: SKSpriteNode = self.newLight()
        light2.position = CGPointMake(24, -27)
        hull.addChild(light2)*/
        
        /*let hover: SKAction = SKAction.sequence([
            SKAction.waitForDuration(1.0),
            SKAction.moveByX(100, y: 50, duration: 1.0),
            SKAction.waitForDuration(1.0),
            SKAction.moveByX(-100, y: -50, duration: 1.0)
        ])
        
        hull.runAction(hover)*/
        
        // add flame
        if let flame: SKEmitterNode = self.newRocketFlame(){
            flame.position = CGPointMake(0, -(hull.size.height / 2))
            hull.addChild(flame)
        }
        
        return hull
    }
    
    func newLight() -> SKSpriteNode{
        let light: SKSpriteNode = SKSpriteNode(color: SKColor.yellowColor(), size: CGSizeMake(8, 8))
        
        let blink: SKAction = SKAction.sequence([
            SKAction.fadeOutWithDuration(0.25),
            SKAction.fadeInWithDuration(0.25)
        ])
        
        let blinkForever: SKAction = SKAction.repeatActionForever(blink)
        
        light.runAction(blinkForever)
        
        return light
    }
    
    func newRocketFlame() -> SKEmitterNode?{
        if let path: NSString = NSBundle.mainBundle().pathForResource("RocketFlame", ofType: "sks"){
            if let flame: SKEmitterNode = NSKeyedUnarchiver.unarchiveObjectWithFile(path as String) as? SKEmitterNode{
                return flame
            }
        }
        return nil
    }
    
    override func didSimulatePhysics() {
        self.enumerateChildNodesWithName("rock", usingBlock: { (node: SKNode!, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
            if node.position.y < 0{
                node.removeFromParent()
            }
        })
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in touches{
            if let t: UITouch = touch as? UITouch{
                let location: CGPoint = t.locationInView(self.view)
                let newLocation: CGPoint = CGPointMake(location.x, self.view!.bounds.size.height - location.y)
                self.spaceShip.runAction(SKAction.moveTo(newLocation, duration: 0.25))
                //println(location)
                //println(newLocation)
                //println(self.spaceShip.position)
                //self.spaceShip.runAction(SKAction.moveTo(CGPointMake(0, 0), duration: 0.1))
            }
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in touches{
            if let t: UITouch = touch as? UITouch{
                let location: CGPoint = t.locationInView(self.view)
                let newLocation: CGPoint = CGPointMake(location.x, self.view!.bounds.size.height - location.y)
                self.spaceShip.runAction(SKAction.moveTo(newLocation, duration: 0.1))
                //println(location)
                //println(newLocation)
                //println(self.spaceShip.position)
                //self.spaceShip.runAction(SKAction.moveTo(CGPointMake(0, 0), duration: 0.1))
            }
        }
    }
    
}
