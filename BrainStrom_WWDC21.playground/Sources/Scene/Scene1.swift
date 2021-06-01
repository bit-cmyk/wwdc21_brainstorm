import Foundation
import SpriteKit
import PlaygroundSupport
import UIKit
import AVFoundation

public class Scene1: SKScene {
    
    var player: AVAudioPlayer?
    var imagePlayer = SKSpriteNode()
    
    public override func didMove(to view: SKView) {
        
        //background
        let background = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Photo.png")) )
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(background)
        
        
        let startButton = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Photo 1.png")))
        startButton.setScale(0.7)
        startButton.position = CGPoint(x: frame.midX, y: frame .midY-150)
        startButton.name = "Start"
        addChild(startButton)
        
        let title = UIImage(named: "Title/BrainStorm")
        let texture = SKTexture(image:title!)
        imagePlayer = SKSpriteNode(texture:texture)
        imagePlayer.setScale(0.7)
        imagePlayer.position = CGPoint(x: frame.midX, y: frame.midY + 50)
        addChild(imagePlayer)
        
        
        let action = SKAction.playSoundFileNamed("bgm.mp3", waitForCompletion: true)
        self.run(action)
        
    }
    
    @objc func play() {
        playSound("play", "wav")
        let screenView = SKView(frame: CGRect(x: 0, y: 0, width: 640, height: 480))
        let scene = GameScene (size: CGSize(width: 640, height: 480))
        scene.scaleMode = .aspectFit
        screenView.presentScene(scene)
        PlaygroundSupport.PlaygroundPage.current.liveView = screenView
    }
    //MARK:- Sound
    
    func playSound(_ soundName:String, _ extens:String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: extens) else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            player?.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if touchedNode.name == "Start" {
                play()
                
            }
            
        }
    }
}

