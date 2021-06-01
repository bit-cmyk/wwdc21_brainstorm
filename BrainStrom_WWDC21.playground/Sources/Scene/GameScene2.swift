import Foundation
import SpriteKit
import PlaygroundSupport
import UIKit
import AVFoundation
import CoreML
import Vision



public class GameScene2 : SKScene, AVCapturePhotoCaptureDelegate {
    
    var player: AVAudioPlayer?
    var indoor = UIButton()
    var outdoor = UIButton()
    var questionLabel = SKLabelNode()
    
    
//    game setting
    var memoriseTime = true
    var level = 3
    var findNumber = Int()
    var counterM = 5
    var counterG = 60
    let timerM = SKLabelNode()
    let gameTimer = SKLabelNode()
    let instructionLabel = SKLabelNode()
    let instructionLabelC = SKLabelNode()
    var scorelabelM = SKLabelNode()
    var scorelabelC = SKLabelNode()
    var timer:Timer?
    var timerG:Timer?
    var scoreM = 0
    var scoreC = 0
    var minimumscore = 5
    var numberArray:[Int] = []
    var numberCount = 4
    
    var y = 30
    var randomX = 0
    var variableY = 70
    
    var buttonArray:[UIButton] = []
    var levelLabel = SKLabelNode()
    
    //MARK:- ImageRecognisationPart
    let previewView = UIView(frame: CGRect(x: 410, y: 79, width: 350, height: 356))
    let imageView = UIImageView()
    var snapButton = UIButton()
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    var items:[String] = []
    var item = ""
    var itemNumber = 0
    
    public override func didMove(to view: SKView) {
        
        //background
        let background = SKSpriteNode(imageNamed: "Background/gamebg2.jpeg")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(background)
        
        //questionLabel
        questionLabel.fontName = "AmericanTypewriter-Bold"        
        questionLabel.text = "Before we start level 3,\nwhere are you now?"
        questionLabel.horizontalAlignmentMode = .center
        questionLabel.numberOfLines = 0
        questionLabel.fontSize = 34
        questionLabel.position = CGPoint(x: frame .midX, y: frame .maxY-150)
        questionLabel.fontColor = UIColor.orange
        addChild(questionLabel)

//        optionButton
        indoor = UIButton(frame: CGRect(x: 200 , y: frame.midY, width: 150, height: 50))
        indoor.backgroundColor = UIColor.blue
        indoor.setTitle("INDOOR", for: .normal)
        indoor.titleLabel?.font = UIFont(name: "AmericanTypewriter-Bold", size: 23)
        indoor.setTitleColor(.white, for: .normal)
        indoor.layer.borderWidth = 4.0
        indoor.layer.borderColor = (UIColor.red).cgColor
        indoor.addTarget(self, action: #selector(indoorGame), for: .touchUpInside)
        self.view!.addSubview(indoor)

        outdoor = UIButton(frame: CGRect(x: 400 , y: frame.midY, width: 150, height: 50))
        outdoor.backgroundColor = UIColor.green
        outdoor.setTitle("OUTDOOR", for: .normal)
        outdoor.titleLabel?.font = UIFont(name: "AmericanTypewriter-Bold", size: 23)
        outdoor.setTitleColor(.black, for: .normal)
        outdoor.layer.borderWidth = 4.0
        outdoor.layer.borderColor = (UIColor.red).cgColor
        outdoor.addTarget(self, action: #selector(outdoorGame), for: .touchUpInside)
        self.view!.addSubview(outdoor)
        
        
    }
    
    @objc func indoorGame() {
        
        playSound("play", "wav")
        game("Indoor")
    }
    @objc func outdoorGame() {
        
        playSound("play", "wav")
        game("Outdoor")
    
    }
    
    func game(_ mode: String) {
        if mode == "Indoor" {
            items = ["Computer Mouse","Pencil","Apple Logo","Smartphone","Backpack"]
        } else {
            items = ["Tree","Green Leaf","Blue Sky","Car","Smartphone"]
        }
        
        indoor.removeFromSuperview()
        outdoor.removeFromSuperview()
        questionLabel.alpha = 0
        
        //background
        let background = SKSpriteNode(imageNamed: "Background/gamebg3.jpeg")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(background)
        
        //MARK:- Game
        
        //level
        levelLabel = SKLabelNode(text: "Level: \(level)")
        levelLabel.fontName = "AmericanTypewriter-Bold"
        levelLabel.fontSize = 23
        levelLabel.position = CGPoint(x: frame.minX + 50, y: 455)
        levelLabel.fontColor = .white
        addChild(levelLabel)


        //instruction
        instruct()
        instructionLabel.fontName = "AmericanTypewriter-Bold"
        instructionLabel.fontSize = 23
        instructionLabel.fontColor = .red
        instructionLabel.position = CGPoint(x: frame.minX + 150, y: 10)
        instructionLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        addChild(instructionLabel)
        
        instructC()
        instructionLabelC.fontName = "AmericanTypewriter-Bold"
        instructionLabelC.fontColor = .red
        instructionLabelC.position = CGPoint(x: frame.maxX - 150, y: 10)
        instructionLabelC.fontSize = 23     
        instructionLabelC.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        addChild(instructionLabelC)
        

        //timerM
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounterM), userInfo: nil, repeats: true)
        timerM.fontName = "AmericanTypewriter-Bold"
        timerM.position = CGPoint(x: frame.minX + 150, y: 60)
        timerM.fontSize = 60
        timerM.fontColor = UIColor.red
        timerM.zPosition = 3
        addChild(timerM)

        //GameTimer
        timerG = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounterG), userInfo: nil, repeats: true)
        gameTimer.text = "Timer: \(counterG) s"
        gameTimer.fontName = "AmericanTypewriter-Bold"
        gameTimer.fontSize = 23
        gameTimer.position = CGPoint(x: frame.midX, y: 455)
        gameTimer.fontColor = UIColor.white
        addChild(gameTimer)

        //score
        scoreMethodM()
        scorelabelM.fontName = "AmericanTypewriter-Bold"
        scorelabelM.fontSize = 23
        scorelabelM.position = CGPoint(x: frame.midX-40, y: 420)
        scorelabelM.fontColor = UIColor.white
        addChild(scorelabelM)
        
        scoreMethodC()
        scorelabelC.fontName = "AmericanTypewriter-Bold"
        scorelabelC.fontSize = 23
        scorelabelC.position = CGPoint(x: frame.maxX-40, y: 420)
        scorelabelC.fontColor = UIColor.white
        addChild(scorelabelC)
        
        generateRandomNumber()
        
        createNumberButton()
        
        //MARK:- SnapGame
        //Camera Setup Session
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("Unable to access back camera!")
            return
        }
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            stillImageOutput = AVCapturePhotoOutput()
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput){
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        }
        catch let error {
            print("Error Unable to initialize back camera: \(error.localizedDescription)")
        }
        
        //cameraPreview
        self.view?.addSubview(previewView)
        
        //imagepreview
        imageView.frame = CGRect(x: 665, y: 295, width: 95, height: 93)
        view?.addSubview(imageView)
        
        //snapButton
        snapButton = UIButton(frame: CGRect(x: 560 , y: 392, width: 40, height: 40))
        snapButton.backgroundColor = UIColor.white
        snapButton.layer.masksToBounds = true
        snapButton.layer.cornerRadius = snapButton.frame.width/2
        snapButton.layer.borderColor = (UIColor.white).cgColor
        snapButton.addTarget(self, action: #selector(didTakePhoto), for: .touchUpInside)
        self.view!.addSubview(snapButton)
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
        
        func scoreMethodM() {
            scorelabelM.text = "\(scoreM) / 5"
            if scoreC == 5 && scoreM == 5 {
                end("Congratulation, you WON!")
            }
        }
    
    func scoreMethodC() {
        scorelabelC.text = "\(scoreC) / 5"
        if scoreC == 5 && scoreM == 5 {
            end("Congratulation, you WON!")
        }
    }
        
    //MARK:- Instruction
        
        func instruct() {
            if memoriseTime == true {
                instructionLabel.fontSize = 23
                instructionLabel.text = "Memorise The Number!"
            } else {
                findNumber = numberArray.randomElement()!
                instructionLabel.fontSize = 30
                instructionLabel.text = "Find number \(findNumber)!"
            }
            
        }
    
    //MARK:- InstructionC
    
    func instructC() {
        item = items[itemNumber]
        instructionLabelC.text = "Snap \(item)!"
    }
    
    //MARK:- UpdateCounterM
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
            timerM.text = "\(counterM)s"
            UIView.animate(withDuration: 1) {
                self.timerM.alpha = 0.0
            }
            memoriseTime = false
            instruct()
            
            timer?.invalidate()
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
                if scoreC == 5 && scoreM == 5 {
                    end("Congratulation, you WON!")
                } else {
                    end("GameOver, try again!")
                    
                }
            }
        }
    
    //MARK:- CreateNumberButton
    
    func createNumberButton() {
        
        for number in numberArray{
            y += variableY
            let X = Int.random(in: 0..<263)
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
        if scoreM == 5 {
            return
        }
        if memoriseTime == true {
            return
        }
        button.titleLabel?.layer.opacity = 1.0
        if button.titleLabel?.text == "\(findNumber)" {
            playSound("correct", "wav")
            if scoreM < 4 {
                scoreM += 1
                scoreMethodM()
                again()
            } else {
                scoreM += 1
                scoreMethodM()
                instructionLabel.text = "Done"
            }
            
        } else {
            playSound("incorrect", "wav")
            print("Try Again")
        }
    }
    
    //MARK:- Again Method
        
        func again() {
            
            if numberCount < 6 {
                numberCount += 1
            }

            counterM = 5
            memoriseTime = true
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
    
    //MARK:- Live Preview
    func setupLivePreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspect
        videoPreviewLayer.connection?.videoOrientation = .landscapeRight
        previewView.layer.addSublayer(videoPreviewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.previewView.bounds
            }
        }
    }
    
    //MARK:- Did Take Photo Method
    @objc func didTakePhoto() {
        
        if scoreC == 5 {
            return
        }
        
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
        
    }
    
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else {
            return
        }
        
        if let image = UIImage(data: imageData) {
            
            imageView.image = image
            imageView.transform = CGAffineTransform(rotationAngle: 270 * .pi / 180)
            guard let cIimage = CIImage(image: image) else {
                fatalError("Fail to convert image to CIImage")
            }
            detect(image: cIimage)
        }
        
        
    }
    
    //MARK:- detectMethod
    
    func detect(image: CIImage){
        guard let model = try? VNCoreMLModel(for: ImageRecognisationModel_BrainStorm_1(configuration: MLModelConfiguration()).model) else {
            fatalError("Loading CoreML Model Failed")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            let classification = request.results?.first as? VNClassificationObservation
            if classification?.identifier == self.item {
                self.playSound("correct", "wav")
                if self.scoreC < 4{
                    self.scoreC += 1
                    self.scoreMethodC()
                    self.itemNumber += 1
                    self.instructC()
                } else if self.scoreC == 4 {
                    self.scoreC += 1
                    self.scoreMethodC()
                    self.instructionLabelC.text = "Done"
                } else {
                    return
                }
            } else {
                self.playSound("incorrect", "wav")
                self.statusLabel()
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
   
    }
    
    func statusLabel(){
        
        let statusLabel = UILabel(frame: CGRect(x: 419, y: 225, width: 220, height: 40))
        statusLabel.text = "Try Again!"
        statusLabel.font = UIFont(name: "AmericanTypewriter-Bold", size: 31)
        statusLabel.textColor = UIColor.white
        self.view?.addSubview(statusLabel)
        UIView.animate(withDuration: 1) {
            statusLabel.alpha = 0.0
        }

    }
    
    func end(_ message:String) {
        view?.subviews.forEach({ $0.removeFromSuperview() })
        removeAllChildren()
        let endLabel = SKLabelNode()
        endLabel.numberOfLines = 0
        endLabel.text = message
        endLabel.horizontalAlignmentMode = .center
        endLabel.fontName = "AmericanTypewriter-Bold"
        endLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        endLabel.fontSize = 31
        endLabel.fontColor = UIColor.red
        addChild(endLabel)
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
