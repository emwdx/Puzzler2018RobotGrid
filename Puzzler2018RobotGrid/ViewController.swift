//
//  ViewController.swift
//  SSISPuzzle2018
//
//  Created by Evan Weinberg on 6/6/18.
//  Copyright © 2018 Evan Weinberg. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

    @IBOutlet weak var mainView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var scene = MazeScene(size: mainView.frame.size)
        /*
        // Get label node from scene and store it for use later
        var upLabel = SKLabelNode(text:"Up")
        upLabel.position = CGPoint(x:0.5*scene.size.width,y:0.875*scene.size.height)
        var downLabel = SKLabelNode(text:"Down")
        downLabel.position = CGPoint(x:0.5*scene.size.width,y:0.125*scene.size.height)
        var leftLabel = SKLabelNode(text:"Left")
        leftLabel.position = CGPoint(x:0.125*scene.size.width,y:0.5*scene.size.height)
        var rightLabel = SKLabelNode(text:"Right")
        rightLabel.position = CGPoint(x:0.875*scene.size.width,y:0.5*scene.size.height)
        var labels = [upLabel,downLabel,leftLabel,rightLabel]
        
        for label in labels {
           label.fontSize = 56.0
            
            
        }
        
        scene.addChild(upLabel)
        scene.addChild(downLabel)
        scene.addChild(rightLabel)
        scene.addChild(leftLabel)
        */
 
        // Present the scene
        mainView.presentScene(scene)
        
       
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   

}

class MazeScene:SKScene{
    
    let mazeLayout = [0,0,0,0,0,
                      1,1,1,0,0,
                      1,0,1,0,0,
                      1,0,1,1,2,
                      1,0,0,0,0]
    var mazePosition = 20
    var currentRobotStatus:robotStatus = .ok
    var controlsEnabled = true
    var upLabel = SKLabelNode(text:"Up")
    var downLabel = SKLabelNode(text:"Down")
    var leftLabel = SKLabelNode(text:"Left")
    var rightLabel = SKLabelNode(text:"Right")
    var robotStatusLabel = SKLabelNode(text:"😀")
    
    
    override init(size: CGSize) {
        
        upLabel = SKLabelNode(text:"Up")
        upLabel.position = CGPoint(x:0.5*size.width,y:0.875*size.height)
        upLabel.name = "up"
        downLabel = SKLabelNode(text:"Down")
        downLabel.position = CGPoint(x:0.5*size.width,y:0.125*size.height)
        downLabel.name = "down"
        leftLabel = SKLabelNode(text:"Left")
        leftLabel.position = CGPoint(x:0.125*size.width,y:0.5*size.height)
        leftLabel.name = "left"
        rightLabel = SKLabelNode(text:"Right")
        rightLabel.position = CGPoint(x:0.875*size.width,y:0.5*size.height)
        rightLabel.name = "right"
        
        var labels = [upLabel,downLabel,leftLabel,rightLabel]
        
        for label in labels {
            label.fontSize = 56.0
           
        }
        
        robotStatusLabel = SKLabelNode(text:"😀")
        robotStatusLabel.fontSize = 80
        robotStatusLabel.position = CGPoint(x:0.5*size.width,y:0.5*size.height)
        robotStatusLabel.name = "robotStatusLabel"
        super.init(size:size)
        
        self.addChild(upLabel)
        self.addChild(downLabel)
        self.addChild(rightLabel)
        self.addChild(leftLabel)
        self.addChild(robotStatusLabel)
    }
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches{
            
            let location = touch.location(in: self)
            let touchedNodes = nodes(at: location)
           
            if(controlsEnabled && touchedNodes.count>0){
                switch touchedNodes[0].name{
                
                case "up":
                    mazePosition -= 5
                    currentRobotStatus = checkMazePosition(maze:mazeLayout ,newPosition:mazePosition)
                    print("up touched, new status is \(currentRobotStatus)")
                    
                    
                    break
                case "down":
                    mazePosition += 5
                    currentRobotStatus = checkMazePosition(maze:mazeLayout ,newPosition:mazePosition)
                    print("down touched, new status is \(currentRobotStatus)")
                    break
                case "left":
                    if(mazePosition % 5 == 0){
                    print("left touched, new status is \(currentRobotStatus)")
                    currentRobotStatus = checkMazePosition(maze:mazeLayout ,newPosition:26)
                    }
                    else{
                    mazePosition -= 1
                    currentRobotStatus = checkMazePosition(maze:mazeLayout ,newPosition:mazePosition)
                    print("left touched, new status is \(currentRobotStatus)")
                    }
                    break
                case "right":
                    mazePosition += 1
                    currentRobotStatus = checkMazePosition(maze:mazeLayout ,newPosition:mazePosition)
                    print("right touched, new status is \(currentRobotStatus)")
                    break
                default:
                    break
                }
                
                let transmitSignal = SKAction.customAction(withDuration: 1) {
                    (node, elapsedTime) in
                    if let label = node as? SKLabelNode {
                        
                        self.robotStatusLabel.text = "Transmitting..."
                        self.controlsEnabled = false
                        
                        
                        
                    }
                }
                
               
                
                
                switch currentRobotStatus{
                    
                case .crashed:
                    
                    self.robotStatusLabel.run(.sequence([transmitSignal,
                        .scale(to:1.5, duration: 0.5),
                        
                        .scale(to:0.8, duration: 0.5),
                        
                        ])){
                            let buttonFadeAction = SKAction.fadeOut(withDuration: 0.5)
                            self.upLabel.run(buttonFadeAction)
                            self.downLabel.run(buttonFadeAction)
                            self.rightLabel.run(buttonFadeAction)
                            self.leftLabel.run(buttonFadeAction)
                            
                    }
                    
                   
                    let showAngryFace = SKAction.customAction(withDuration: 1) {
                        (node, elapsedTime) in
                        if let label = node as? SKLabelNode {
                            
                           self.robotStatusLabel.text = "😡"
                            self.controlsEnabled = false
                            
                            
                            
                        }
                    }
                    
                    let showCrashMessage = SKAction.customAction(withDuration: 1) {
                        (node, elapsedTime) in
                        if let label = node as? SKLabelNode {
                            
                            self.robotStatusLabel.text = "Robot crashed"
                            
                        }
                    }
                    
                    let countdownToReset = SKAction.customAction(withDuration: 5) {
                        (node, elapsedTime) in
                        if let label = node as? SKLabelNode {
                            label.text = "Resetting in \(5 - Int(elapsedTime)) seconds"
                        }
                    }
                    let restoreToOriginal = SKAction.customAction(withDuration: 1) {
                        (node, elapsedTime) in
                        if let label = node as? SKLabelNode {
                            
                            self.robotStatusLabel.text = "😀"
                            self.mazePosition = 20
                            let buttonFadeAction = SKAction.fadeIn(withDuration: 0.5)
                            self.upLabel.run(buttonFadeAction)
                            self.downLabel.run(buttonFadeAction)
                            self.rightLabel.run(buttonFadeAction)
                            self.leftLabel.run(buttonFadeAction)
                            self.controlsEnabled = true
                            
                        }
                    }
                    
                    self.robotStatusLabel.run(.sequence([transmitSignal,showAngryFace,showCrashMessage,.wait(forDuration: 1),
                        countdownToReset,restoreToOriginal])){
                        
                    }
                 
                    
                    
                    break
                    
                    
                
                case .finished:
                    //self.robotStatusLabel.text = "🤓"
                    let nowRingTheBell = SKAction.customAction(withDuration: 5) {
                        (node, elapsedTime) in
                        if let label = node as? SKLabelNode {
                            label.fontSize = 18.0
                            label.text = "To complete this challenge, ring the bell."
                        }
                    }
                    
                    let scaleAction = SKAction.scale(to:1.5, duration: 1)
                    let buttonFadeAction = SKAction.fadeOut(withDuration: 1)
                    self.robotStatusLabel.run(scaleAction)
                    self.upLabel.run(buttonFadeAction)
                    self.downLabel.run(buttonFadeAction)
                    self.rightLabel.run(buttonFadeAction)
                    self.robotStatusLabel.text = "Task Complete!"
                    self.leftLabel.run(buttonFadeAction){
                        
                        self.robotStatusLabel.run(.sequence([.wait(forDuration: 2),nowRingTheBell]))
                        
                    }
                    
                    
                    
                    
                    break
                    
                case .ok:
                    self.robotStatusLabel.run(transmitSignal){
                    self.robotStatusLabel.text = "😀"
                    self.controlsEnabled = true
                    
                        
                    }
                    break
                
            
            }
            
                
        
        }
        
        }
        
        
    }
    
    func checkMazePosition(maze:[Int],newPosition:Int)->robotStatus{
        print(newPosition)
        if(newPosition>=maze.count){
            return .crashed
            
        }
        else if maze[newPosition] == 0{
            return .crashed
        }
        else if maze[newPosition] == 2{
            return .finished
        }
        else{
            return .ok
        }
        
    }
    
    enum robotStatus:String{
        case crashed, ok, finished
        
    }
    
}

