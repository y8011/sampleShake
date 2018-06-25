//
//  ViewController.swift
//  shake
//
//  Created by yuka on 2018/06/25.
//  Copyright © 2018年 yuka. All rights reserved.
//

import UIKit
import AVFoundation

import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet var randLabel: UILabel!
    
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var state: UILabel!
    
    
    var score = 0
    var player = AVAudioPlayer()
    var isAlive = true
    var dieCount = 1
    
    // MotionManager
    let motionManager = CMMotionManager()
    
    // 3 axes
    @IBOutlet var accelerometerX: UILabel!
    @IBOutlet var accelerometerY: UILabel!
    @IBOutlet var accelerometerZ: UILabel!
    
    
    
    @IBAction func escape(sender: UIButton) {
        
        scoreLabel.text = "\(score)円を持って逃走した"
        state.isHidden = false

        let fileLocation = Bundle.main.path(forResource:"escape", ofType: "wav")
        do {
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileLocation!))
            
            player.play()
        
        } catch {
        
        }


    }
    @IBAction func goToStart(_ sender: UIButton) {
        retunToStart()
        
    }
    
    func retunToStart() {
    
        score = 0
        isAlive = true
        dieCount = 1
        state.isHidden = true
        randLabel.text = "ジャンプしてコインをゲット！"
        scoreLabel.text = "ここにゲットしたコイン数が出るよ"

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         retunToStart()
        
        initMotionManager()
    }
    
    
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {

        print(motion.rawValue)
        
        
        if event!.subtype == UIEventSubtype.motionShake {
            
            if isAlive {
                
                let rand = Int(arc4random_uniform(100))
                var fileLocation = Bundle.main.path(forResource:"nc106374" ,ofType: "wav")

                
                if rand < 3 * dieCount{
                    fileLocation = Bundle.main.path(forResource: "mario5", ofType: "mp3")
                    scoreLabel.text = "よくばるから...(´・∀・｀)"
                    randLabel.text = "死んじゃったお..."
                    
                    isAlive = true
                } else if rand > 98{
                    fileLocation = Bundle.main.path(forResource:"spel", ofType: "wav")
                    dieCount = 2
                    state.text = "あ，死ぬ確率2倍!!金も2倍!!"
                }
                else {
                    randLabel.text = "\(rand * 100 * dieCount)円をゲットした!!"
                    score = score + Int(rand * 100 * dieCount)
                    scoreLabel.text = "合計 \(score)円です"
                    
                }
                
                do {
                    try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileLocation!))
                    
                    player.play()
                    
                } catch {
                    
                }
                
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController {
    


    

    func initMotionManager() {
        if motionManager.isAccelerometerAvailable {
            // intervalの設定 [sec]
            motionManager.accelerometerUpdateInterval = 0.2
            
            // センサー値の取得開始
            motionManager.startAccelerometerUpdates(
                to: OperationQueue.current!,
                withHandler: {(accelData: CMAccelerometerData?, errorOC: Error?) in
                    self.outputAccelData(acceleration: accelData!.acceleration)
            })
            
        }
    }
    
    func outputAccelData(acceleration: CMAcceleration){
        // 加速度センサー [G]
        accelerometerX.text = String(format: "%06f", acceleration.x)
        accelerometerY.text = String(format: "%06f", acceleration.y)
        accelerometerZ.text = String(format: "%06f", acceleration.z)
    }
    
    // センサー取得を止める場合
    func stopAccelerometer(){
        if (motionManager.isAccelerometerActive) {
            motionManager.stopAccelerometerUpdates()
        }
    }
    
}

