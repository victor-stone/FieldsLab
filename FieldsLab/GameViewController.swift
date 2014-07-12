//
//  GameViewController.swift
//  FieldsLab
//
//  Created by victor on 7/11/14.
//  Copyright (c) 2014 AOTK. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        
        let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks")
        
        var sceneData = NSData.dataWithContentsOfFile(path, options: .DataReadingMappedIfSafe, error: nil)
        var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
        
        archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
        let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
        archiver.finishDecoding()
        return scene
    }
}

class GameViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate
{

    @IBOutlet var fieldTable : UITableView
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
            
            fieldTable.reloadData()
            fieldTable.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: false, scrollPosition: .None)
            
            gs.createFieldEnvironment(fieldTypeNames[0])
            
        }
    }

    var gs:GameScene {
        return (view as SKView).scene as GameScene
    }
    
    
    let fieldTypeNames:Array<FieldTypeNames> = [ .None, .Spring, .RadialGravity, .Drag, .Vortex, .VelocityTexture,
                                        .Noise, .Turbulence, .Electric, .Magnetic ]
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
        return fieldTypeNames.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        cell.textLabel.text = fieldTypeNames[ indexPath.row ].toRaw()
        return cell
    }

    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        gs.createFieldEnvironment(FieldTypeNames.fromRaw(cell.textLabel.text)!)
    }
    
    
}
