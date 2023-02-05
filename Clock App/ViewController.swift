//
//  ViewController.swift
//  Clock App
//
//  Created by Scarlett  on 2/4/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var startAndStopButton: UIButton!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    var clockTimer: Timer = Timer()
    var countdown: Timer = Timer()
    var remainingTime: Int?
    var audioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadDateTime()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func startAndStop(_ sender: UIButton) {
        countdown.invalidate()
        if (startAndStopButton.currentTitle == "Stop Music") {
            audioPlayer?.pause()
            startAndStopButton.setTitle("Start Timer", for: .normal)
                }
                else {
                    let chosenTime = datePicker.date
                    let hours = Calendar.current.component(.hour, from: chosenTime)
                    let minutes = Calendar.current.component(.minute, from: chosenTime)
                    remainingTime = hours * 3600 + minutes * 60
                    countdown.invalidate()
                    countdown = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(startCountDown) , userInfo: nil, repeats: true)
                    startAndStopButton.setTitle("Stop Music", for: .normal)
                }
    }
    
    @objc func startCountDown() {
        if (remainingTime! >= 0) {
            timeRemainingLabel.text = "Remaining time: \(remainingTime!)s"
            remainingTime! -= 1
        }
        else {
            playAudio()
        }
    }
    
    @objc func currentDateTime() {
        // Format the date
        let dateTime = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss"
        
        // Date converts into string for label
        let currentTime = dateFormatter.string(from: dateTime)
        self.dateTimeLabel.text = currentTime
        
        // Background changes based on time of the day (AM or PM)
        let hour = Calendar.current.component(.hour, from: Date())
        let backgroundImage: UIImage
        if hour <= 12 {
            backgroundImage = UIImage(named: "day.jpeg")!
        } else {
            backgroundImage = UIImage(named: "night.jpeg")!
        }
        view.backgroundColor = UIColor(patternImage: backgroundImage)
    }
    
    func loadDateTime() {
        clockTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(self.currentDateTime) , userInfo: nil, repeats: true)
    }
    
    func playAudio() {
        let path = Bundle.main.path(forResource: "laser.mp3", ofType : "mp3")!
        let url = URL(fileURLWithPath : path)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print ("There is an issue with this code!")
        }
    
        
    }

}
