import Foundation
import SpriteKit
import PlaygroundSupport
import UIKit
import AVFoundation


public class GameScene: SKScene {

    //variable
    var player: AVAudioPlayer?
    var memoriseTime = true
    var level = 1
    var findNumber = Int()
    var counterM = 5
    var counterG = 10
    var timer:Timer?
    var timerG:Timer?
    var score = 0
    var minimumscore = 3
    var numberArray:[Int] = []
    var numberCount = 4
    var y = 30
    var randomX = 0
    var variableY = 70
    var buttonArray:[UIButton] = []
    var lives = 5
    var levellabel = SKLabelNode()
    var instructionLabel = SKLabelNode()
    let timerM = SKLabelNode()  
    let gameTimer = SKLabelNode()
    var scorelabel = SKLabelNode()
    var livesLabel = SKLabelNode()
    
    public override func didMove(to view: SKView) {
        
        //background
        let background = SKSpriteNode(imageNamed: "Background/gamebg1.jpeg")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(background)
        
        //level
        levellabel = SKLabelNode(text: "Level: \(level)")
        levellabel.fontName = "AmericanTypewriter-Bold"
        levellabel.fontSize = 23
        levellabel.position = CGPoint(x: frame.minX + 50, y: 455)
        levellabel.fontColor = .white
        addChild(levellabel)
        
        
        //instruction
        instructionLabel.fontName = "AmericanTypewriter-Bold"
        instructionLabel.fontSize = 23
        instructionLabel.fontColor = .red
        instructionLabel.position = CGPoint(x: frame.midX, y: 10)
        instructionLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        addChild(instructionLabel)
        instruct()
        
        //timerM
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounterM), userInfo: nil, repeats: true)
        timerM.fontName = "AmericanTypewriter-Bold"
        timerM.position = CGPoint(x: frame .midX, y: 60)
        timerM.fontSize = 58
        timerM.fontColor = UIColor.red
        timerM.zPosition = 3
        addChild(timerM)
        
        //GameTimer
        gameTimer.fontName =  "AmericanTypewriter-Bold"
        gameTimer.fontSize = 23
        gameTimer.position = CGPoint(x: frame .midX, y: 455)
        gameTimer.fontColor = UIColor.white
        addChild(gameTimer)
        
        //score
        scoreMethod()
        scorelabel.fontName = "AmericanTypewriter-Bold"
        scorelabel.fontSize = 23
        scorelabel.position = CGPoint(x: frame .maxX-155, y: 455)
        scorelabel.fontColor = UIColor.white
        addChild(scorelabel)
        
        //chances
        livesLabel.fontName = "AmericanTypewriter-Bold"
        livesLabel.fontSize = 23
        livesLabel.position = CGPoint(x: frame .maxX-65, y: 455)
        livesLabel.fontColor = UIColor.white
        livesLabel.text = "Lives : \(lives)"
        addChild(livesLabel)
        
        generateRandomNumber()
        
        
        createNumberButton()
        
        
}
    
//MARK:- Random Number
    func generateRandomNumber() {
        while numberArray.count < numberCount {
            let number = Int.random(in: 0..<11)
            if numberArray.contains(number) == false{
                numberArray.append(number)
            }
        }
    }
    
//MARK:- Score
    
    func scoreMethod() {
        scorelabel.text = "\(score) / 3"
    }
    
//MARK:- Instruction
    
    func instruct() {
        if memoriseTime == true {
            instructionLabel.text = "Memorise The Number!"
            instructionLabel.fontSize = 23
        } else {
            findNumber = numberArray.randomElement()!
            instructionLabel.text = "Find number \(findNumber)!"
            instructionLabel.fontSize = 30
        }
    }
    
//MARK:- UpdateCounterMemorise

    @objc func updateCounterM() {
        if counterM > 0 {
            timerM.text = "\(counterM)s"
            self.timerM.alpha = 1.0
            counterM -= 1
        } else {
            for button in buttonArray {
                button.backgroundColor = UIColor.red
                button.titleLabel?.layer.opacity = 0.0
            }
            if level == 2{
                createEmptyButton()
            }
            timerM.text = "\(counterM)s"
            UIView.animate(withDuration: 1) {
                self.timerM.alpha = 0.0
            }
            memoriseTime = false
            instruct()
            
            timer?.invalidate()
            
            gameTimer.text = "Timer: \(counterG) s"
            timerG = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounterG), userInfo: nil, repeats: true)
        }
    }
    
//MARK:- UpdateCounterGame
    
    @objc func updateCounterG() {
        if counterG > 0 {
            counterG -= 1
            gameTimer.text = "Timer: \(counterG) s"
        } else {
            gameTimer.text = "Timer: \(counterG) s"
            timerG?.invalidate()
            if lives > 0 {
                lives -= 1
                livesLabel.text = "Lives: \(lives)"
            }
            if lives == 0 {
                gameOver()
            }
        }
    }
    
//MARK:- CreateNumberButton
    
    func createNumberButton() {
        
        for number in numberArray{
            y += variableY
            let X = Int.random(in: 0..<580)
            let button = UIButton(frame: CGRect(x: X, y: y, width: 50, height: 50))
            if number == numberArray[2]{
                randomX = X
            }
            button.backgroundColor = UIColor.cyan
            button.setTitle("\(number)", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.layer.borderWidth = 4.0
            button.layer.borderColor = (UIColor.blue).cgColor
            button.titleLabel?.font = UIFont(name: "AmericanTypewriter-Bold", size: 23)
            button.addTarget(self, action: #selector(verify), for: .touchUpInside)
            buttonArray.append(button)
            self.view!.addSubview(button)
        }
        
    }
    
//MARK:- Verify
    
    @objc func verify(_ button:UIButton) {
        
        if memoriseTime == true {
            return
        }
        
        button.titleLabel?.layer.opacity = 1.0
        if button.titleLabel?.text == "\(findNumber)" {
            playSound("correct", "wav")
            if score < 2 {
                score += 1
                scoreMethod()
                again()
            } else {
                score += 1
                scoreMethod()
                timerG?.invalidate()
                statusLabel("Level Passed!")
                if level == 1 {
                    leveltwo()
                } else {
                    levelthree()
                }
                
            }
            
        } else {
            playSound("incorrect", "wav")
            if lives > 0 {
                lives -= 1
                livesLabel.text = "Lives : \(lives)"
            
            }
            if lives == 0 {
                gameOver()
            }
        }
    }

//MARK:- Again Method
    
    func again() {
        
        numberCount += 1
        counterM = 5
        counterG = 10
        memoriseTime = true
        timerG?.invalidate()
        gameTimer.text = ""
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounterM), userInfo: nil, repeats: true)
        instruct()
        for button in buttonArray {
            button.removeFromSuperview()
        }
        buttonArray = []
        numberArray = []
        
        generateRandomNumber()
        
        y = 10
        variableY = 55
        createNumberButton()
        
    }
    
//MARK:- Status Label
    
    func statusLabel(_ message:String) {
        
        let statusLabel = UILabel(frame: CGRect(x: 250, y: 220, width: 220, height: 40))
        statusLabel.text = "\(message)"
        statusLabel.font = UIFont(name: "AmericanTypewriter-Bold", size: 31)
        statusLabel.textColor = UIColor.white
        self.view?.addSubview(statusLabel)
        UIView.animate(withDuration: 1) {
            statusLabel.alpha = 0.0
        }

    }
    
//MARK:- GameOver
    
    func gameOver() {
        view?.subviews.forEach({ $0.removeFromSuperview() })
        removeAllChildren()
        let loseLabel = SKLabelNode()
        loseLabel.numberOfLines = 0
        loseLabel.text = "GameOver\n Try Again!"
        loseLabel.horizontalAlignmentMode = .center
        loseLabel.fontName = "AmericanTypewriter-Bold"
        loseLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        loseLabel.fontSize = 31
        loseLabel.fontColor = UIColor.red
        addChild(loseLabel)
    }
    
//MARK:- Level Two Method
    
    func leveltwo() {
        for button in buttonArray {
            button.removeFromSuperview()
        }
        gameTimer.text = ""
        memoriseTime = true
        counterM = 5
        counterG = 10
        score = 0
        numberArray = []
        level += 1
        levellabel.text = "Level: \(level)"
        numberCount = 4
        y = 30
        variableY = 70
        generateRandomNumber()
        createNumberButton()
        instruct()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounterM), userInfo: nil, repeats: true)
        scoreMethod()
        
        
        
    }
    
    func levelthree() {
        
        let screenView = SKView(frame: CGRect(x: 0, y: 0, width: 640, height: 480))
        let scene = GameScene2 (size: CGSize(width: 640, height: 480))
        scene.scaleMode = .aspectFit
        screenView.presentScene(scene)
        PlaygroundSupport.PlaygroundPage.current.liveView = screenView
        
    }
    
//MARK:- Create Empty Button
    func createEmptyButton() {
        if randomX > 500{
            randomX -= 100
        } else {
            randomX += 100
        }
        let button = UIButton(frame: CGRect(x: randomX, y: 170, width: 50, height: 50))
        button.backgroundColor = UIColor.red
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 4.0
        button.layer.borderColor = (UIColor.blue).cgColor
        button.addTarget(self, action: #selector(verify), for: .touchUpInside)
        buttonArray.append(button)
        self.view!.addSubview(button)
    }
    
    //MARK:- sound
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
}

