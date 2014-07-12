//
//  GameScene.swift
//  FieldsLab
//
//  Created by victor on 7/11/14.
//  Copyright (c) 2014 AOTK. All rights reserved.
//

import SpriteKit

enum FieldTypeNames : String {
    case None = "None"
    case Spring = "Spring"
    case RadialGravity = "Radial Gravity"
    case Drag = "Drag"
    case Vortex = "Vortex"
    case VelocityTexture = "Velocity Texture"
    case Noise = "Noise"
    case Turbulence = "Turbulence"
    case Electric = "Electric"
    case Magnetic = "Magnetic"
    
    /*
     missing:
    @see linearGravityFieldWithVector
    @see velocityFieldWithVector
    */
}

class GameScene: SKScene {
    
    
    override func didMoveToView(view: SKView)
    {
        physicsWorld.gravity = CGVectorMake(0, 0)
    }

    var midPt:CGPoint {
        return CGPoint( x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
    }
    
    var fieldPos:CGPoint {
        var mid = midPt
        mid.x += (mid.x * 0.25)
        return mid
    }
    
    var emitterPos:CGPoint {
        var mid = midPt
        mid.x -= (mid.x * 0.40)
        return mid
    }
    
    var bestBodyMass:CGFloat = 1.0
    var impulseMultiplier:CGFloat = 400
    
    func createFieldEnvironment(name:FieldTypeNames)
    {
        removeAllChildren()
        
        /*
        var region: SKRegion!
        var strength: CFloat
        var falloff: CFloat
        var minimumRadius: CFloat
        var enabled: Bool
        var exclusive: Bool
        
        @see SKPhysicsBody.fieldBitMask
        @see SKEmitterNode.fieldBitMask
        var categoryBitMask: UInt32
        
        var smoothness: CGFloat
        var animationSpeed: CGFloat
        
        var texture: SKTexture!
        */
        
        var field:SKFieldNode?
        
        switch( name )
        {
            case .None:
                break
            case .RadialGravity:
                var radial = SKFieldNode.radialGravityField()
                impulseMultiplier = 300
                bestBodyMass = 0.5
                field = radial
                field!.strength = 4.0
            case .Vortex:
                var vortext = SKFieldNode.vortexField()
                impulseMultiplier = 500
                bestBodyMass = 0.6
                field = vortext
                field!.strength = 1.0
            case .Drag:
                var drag = SKFieldNode.dragField()
                drag.strength = 0.5
                bestBodyMass = 1.1
                impulseMultiplier = 200
                field = drag
            case .VelocityTexture:
                println("Not implemented: \(name.toRaw())")
            case .Noise:
                var noise = SKFieldNode.noiseFieldWithSmoothness(1.0, animationSpeed: 0.5)
                bestBodyMass = 0.2
                impulseMultiplier = 3.0
                field = noise
            case .Turbulence:
                var turbulence = SKFieldNode.turbulenceFieldWithSmoothness(1.0, animationSpeed: 0.5)
                bestBodyMass = 1.0
                impulseMultiplier = 300.0
                field = turbulence
            case .Spring:
                var spring = SKFieldNode.springField()
                spring.strength = 1.0
                bestBodyMass = 0.1
                field = spring
                impulseMultiplier = 400
            case .Electric:
                var electric = SKFieldNode.electricField()
                electric.strength = 100.0
                bestBodyMass = 0.5
                impulseMultiplier = 400
                field = electric
            case .Magnetic:
                var magnetic = SKFieldNode.magneticField()
                magnetic.strength = 1.0
                bestBodyMass = 0.5
                impulseMultiplier = 400
                field = magnetic
        }
        
        if let f = field
        {
            f.enabled = true
            f.position = fieldPos
            addChild(f)
            
            var shape = SKShapeNode(circleOfRadius: 8)
            shape.strokeColor = UIColor.whiteColor()
            shape.fillColor = UIColor.blackColor()
            shape.alpha = 0.7
            shape.position = f.position
            addChild(shape)
        }
        
        
        var shape = SKShapeNode(circleOfRadius: 8)
        shape.strokeColor = UIColor.whiteColor()
        shape.fillColor = UIColor.greenColor()
        shape.alpha = 0.7
        shape.position = emitterPos
        addChild(shape)
    }
    
    var charge:CGFloat = 500.0
    
    func makeNode() -> SKNode
    {
        var node = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width:20,height:20))
        node.position = emitterPos
        node.physicsBody = SKPhysicsBody(rectangleOfSize: node.size)
        node.physicsBody.dynamic = true
        node.physicsBody.charge = charge
        charge *= -1.0
        node.physicsBody.mass = bestBodyMass
        node.physicsBody.allowsRotation = true
        addChild(node)
        return node
    }
    
    var lastTimeMark:CFTimeInterval?
    var emitterThreshold = 2.0 // seconds
    
    override func update(currentTime: CFTimeInterval)
    {
        if let timeMark = lastTimeMark
        {
            if( currentTime - timeMark > emitterThreshold )
            {
                var node = makeNode()
                node.physicsBody.applyImpulse( CGVectorMake( node.physicsBody.mass * impulseMultiplier, 50))
                lastTimeMark = currentTime
            }
        }
        else
        {
            lastTimeMark = currentTime
        }
    }
}
