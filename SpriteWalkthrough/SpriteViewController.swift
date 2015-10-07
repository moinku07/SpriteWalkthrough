//
//  SpriteViewController.swift
//  SpriteWalkthrough
//
//  Created by Moin Uddin on 6/10/15.
//  Copyright (c) 2015 Moin Uddin. All rights reserved.
//

import UIKit
import SpriteKit

class SpriteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let spriteView: SKView = self.view as! SKView
        spriteView.showsDrawCount = true
        spriteView.showsFPS = true
        spriteView.showsNodeCount = true
    }
    
    override func viewWillAppear(animated: Bool) {
        let hello: HelloScene = HelloScene()
        //hello.size = CGSizeMake(768, 1024)
        hello.size = self.view.bounds.size
        println(hello.size)
        
        let spriteView: SKView = self.view as! SKView
        spriteView.presentScene(hello)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
