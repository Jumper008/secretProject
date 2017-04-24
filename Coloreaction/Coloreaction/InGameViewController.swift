//
//  InGameViewController.swift
//  Coloreaction
//
//  Created by Alejandro Zamudio on 4/13/17.
//
//

import UIKit
import RealmSwift
import Foundation
import AVFoundation

protocol ReloadHighscores {
    func reloadHighscores()
}

protocol ReplayMainMenuMusic {
    func replayMainMenuMusic()
}

class InGameViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var questionUIView: UIView!
    @IBOutlet weak var possibleAnswer1: UIButton! {
        willSet {
            newValue.titleLabel?.minimumScaleFactor = 0.2
            newValue.titleLabel?.numberOfLines = 0
            newValue.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet weak var possibleAnswer2: UIButton! {
        willSet {
            newValue.titleLabel?.minimumScaleFactor = 0.2
            newValue.titleLabel?.numberOfLines = 0
            newValue.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet weak var possibleAnswer3: UIButton! {
        willSet {
            newValue.titleLabel?.minimumScaleFactor = 0.2
            newValue.titleLabel?.numberOfLines = 0
            newValue.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet weak var possibleAnswer4: UIButton! {
        willSet {
            newValue.titleLabel?.minimumScaleFactor = 0.2
            newValue.titleLabel?.numberOfLines = 0
            newValue.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet weak var questionTextView: UITextView! {
        willSet {
            newValue.isSelectable = true
            newValue.font = UIFont.font(for: .heading3)
            newValue.isSelectable = false
        }
    }
    @IBOutlet weak var addedScoreLabel: UILabel!
    
    /*
     - Game mode code signing is as follows:
     - Time Attack = 0
     - Blitz = 1
     - Survival = 2
     - Endless = 3
     */
    var selectedGameMode = 0
    var totalGameTime = 0
    var totalLives = 3
    var possibleQuestions = [Question]()
    var currentQuestion = Question()
    var currentScore: Int = 0
    var gameColor: UIColor = UIColor.pastelPinkColor()
    var gameTimer: Timer = Timer()
    var shadowView: UIView = UIView()
    var scoreRegisteringView: UIView = UIView()
    var scoreLabel: UILabel = UILabel()
    var nameInputTextField: UITextField = UITextField()
    var saveScoreButton: UIButton = UIButton()
    var continueGameButton: UIButton = UIButton()
    var delegate: MainMenuViewController? = nil
    let TimeGamesMusic = NSURL(fileURLWithPath: Bundle.main.path(forResource: "TimeGames", ofType: "wav")!)
    let OtherGamesMusic = NSURL(fileURLWithPath: Bundle.main.path(forResource: "OtherGames", ofType: "wav")!)
    let GameEndedSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "buzzer_x", ofType: "wav")!)
    let IncorrectAnswerSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "boing_x", ofType: "wav")!)
    let CorrectAnswerSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "chime_up", ofType: "wav")!)
    var gameAudioPlayer = AVAudioPlayer()
    var soundsAudioPlayer = AVAudioPlayer()
    var gameVolume: Float = 1.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadGameMusic()
        setGameSettings()
        loadGameQuestions()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadGameMusic() {
        if self.selectedGameMode <= 1
        {
            try! self.gameAudioPlayer = AVAudioPlayer(contentsOf: self.TimeGamesMusic as URL)
            self.gameAudioPlayer.enableRate = true
        }
        else
        {
            try! self.gameAudioPlayer = AVAudioPlayer(contentsOf: self.OtherGamesMusic as URL)
        }
        
        self.gameAudioPlayer.prepareToPlay()
        self.gameAudioPlayer.play()
        if #available(iOS 10.0, *) {
            self.gameAudioPlayer.setVolume(self.gameVolume, fadeDuration: 0.0)
        } else {
            self.gameAudioPlayer.volume = self.gameVolume
        }
        self.gameAudioPlayer.delegate = self
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.gameAudioPlayer.play()
    }
    
    @IBAction func returnToMainMenu(_ sender: Any) {
        if self.selectedGameMode == 3
        {
            endGame()
        }
        else
        {
            self.gameAudioPlayer.stop()
            self.delegate?.replayMainMenuMusic()
            dismiss(animated: true, completion: nil)
        }
    }
    
    func setGameSettings() {
        self.timerLabel.layer.cornerRadius = 8
        self.questionUIView.layer.cornerRadius = 8
        self.questionUIView.layer.borderWidth = 2
        self.possibleAnswer1.layer.cornerRadius = 8
        self.possibleAnswer1.layer.borderWidth = 2
        self.possibleAnswer1.isHidden = true
        self.possibleAnswer2.layer.cornerRadius = 8
        self.possibleAnswer2.layer.borderWidth = 2
        self.possibleAnswer2.isHidden = true
        self.possibleAnswer3.layer.cornerRadius = 8
        self.possibleAnswer3.layer.borderWidth = 2
        self.possibleAnswer3.isHidden = true
        self.possibleAnswer4.layer.cornerRadius = 8
        self.possibleAnswer4.layer.borderWidth = 2
        self.possibleAnswer4.isHidden = true
        
        if self.selectedGameMode == 0
        {
            self.gameColor = UIColor.pastelPinkColor()
            self.totalGameTime = 60
            self.gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTotalGameTime), userInfo: nil, repeats: true)
            self.pauseButton.isHidden = false
        }
        else if self.selectedGameMode == 1
        {
            self.gameColor = UIColor.pastelPurpleColor()
            self.totalGameTime = 60
            self.gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTotalGameTime), userInfo: nil, repeats: true)
            self.pauseButton.setImage(UIImage(named: "LightPurplePauseButton"), for: UIControlState.normal)
            self.pauseButton.isHidden = false
        }
        else if self.selectedGameMode == 2
        {
            self.gameColor = UIColor.pastelGreenColor()
            self.totalGameTime = -1
            self.timerLabel.text = "3"
            self.pauseButton.setImage(UIImage(named: "GreenishPauseButton"), for: UIControlState.normal)
        }
        else
        {
            self.gameColor = UIColor.pastelBlueColor()
            self.totalGameTime = 0
            self.timerLabel.text = "00:00"
            self.pauseButton.setImage(UIImage(named: "LightBluePauseButton"), for: UIControlState.normal)
        }
        
        setGameColor()
    }
    
    func setGameColor() {
        self.questionUIView.layer.borderColor = self.gameColor.cgColor
        self.timerLabel.backgroundColor = self.gameColor
        self.possibleAnswer1.layer.borderColor = self.gameColor.cgColor
        self.possibleAnswer1.setTitleColor(self.gameColor, for: UIControlState.normal)
        self.possibleAnswer2.layer.borderColor = self.gameColor.cgColor
        self.possibleAnswer2.setTitleColor(self.gameColor, for: UIControlState.normal)
        self.possibleAnswer3.layer.borderColor = self.gameColor.cgColor
        self.possibleAnswer3.setTitleColor(self.gameColor, for: UIControlState.normal)
        self.possibleAnswer4.layer.borderColor = self.gameColor.cgColor
        self.possibleAnswer4.setTitleColor(self.gameColor, for: UIControlState.normal)
        self.questionTextView.isSelectable = true
        self.questionTextView.textColor = self.gameColor
        self.questionTextView.isSelectable = false
        self.addedScoreLabel.textColor = self.gameColor
    }
    
    func updateTotalGameTime() {
        if self.totalGameTime > 0
        {
            if self.totalGameTime < 30
            {
                self.gameAudioPlayer.rate = 1.5
            }
            
            if self.totalGameTime < 15
            {
                self.gameAudioPlayer.rate = 2.0
            }
            
            self.totalGameTime = self.totalGameTime - 1
            let minutes: Int = self.totalGameTime / 60
            let seconds: Int = self.totalGameTime % 60
            if seconds > 9
            {
                self.timerLabel.text = "\(minutes):\(seconds)"
            }
            else
            {
                self.timerLabel.text = "\(minutes):0\(seconds)"
            }
        }
        else
        {
            endGame()
        }
    }
    
    func endGame() {
        self.gameTimer.invalidate()
        self.gameAudioPlayer.stop()
        playSound(WithURL: self.GameEndedSound)
        // UIViews set up
        var frame = self.view.frame
        self.shadowView = UIView(frame: frame)
        self.shadowView.backgroundColor = UIColor.shadowColor()
        frame = CGRect(x: self.view.frame.size.width / 8, y: self.view.frame.size.height / 4, width: self.view.frame.size.width / 1.3, height: self.view.frame.size.height / 3)
        self.scoreRegisteringView = UIView(frame: frame)
        self.scoreRegisteringView.backgroundColor = UIColor.white
        self.scoreRegisteringView.clipsToBounds = true
        self.scoreRegisteringView.layer.cornerRadius = 8
        // UILabel set up
        frame = CGRect(x: 0.0, y: scoreRegisteringView.frame.size.height / 8, width: scoreRegisteringView.frame.size.width, height: scoreRegisteringView.frame.size.height / 6)
        self.scoreLabel = UILabel(frame: frame)
        self.scoreLabel.backgroundColor = UIColor.white
        self.scoreLabel.textColor = self.gameColor
        self.scoreLabel.text = "\(self.currentScore)"
        self.scoreLabel.textAlignment = NSTextAlignment.center
        self.scoreLabel.font = UIFont(name: "HelveticaNeue", size: 50)
        // UITextField set up
        frame = CGRect(x: scoreRegisteringView.frame.size.width / 8, y: scoreRegisteringView.frame.size.height / 2.3, width: scoreRegisteringView.frame.size.width / 1.3, height: scoreRegisteringView.frame.size.height / 5.5)
        self.nameInputTextField = UITextField(frame: frame)
        self.nameInputTextField.borderStyle = UITextBorderStyle.roundedRect
        self.nameInputTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        self.nameInputTextField.textAlignment = NSTextAlignment.left
        self.nameInputTextField.keyboardType = UIKeyboardType.alphabet
        self.nameInputTextField.keyboardAppearance = UIKeyboardAppearance.light
        self.nameInputTextField.clearButtonMode = UITextFieldViewMode.always
        self.nameInputTextField.tintColor = self.gameColor
        self.nameInputTextField.textColor = self.gameColor
        self.nameInputTextField.font = UIFont(name: "HelveticaNeue", size: 15)
        self.nameInputTextField.placeholder = "Input your name"
        self.nameInputTextField.layer.borderColor = UIColor.black.cgColor
        // UIButton set up
        frame = CGRect(x: scoreRegisteringView.frame.size.width / 8, y: scoreRegisteringView.frame.size.height / 1.5, width: scoreRegisteringView.frame.size.width / 1.3, height: scoreRegisteringView.frame.size.height / 4.5)
        self.saveScoreButton = UIButton(frame: frame)
        self.saveScoreButton.backgroundColor = self.gameColor
        self.saveScoreButton.clipsToBounds = true
        self.saveScoreButton.layer.cornerRadius = 8
        self.saveScoreButton.setTitle("Save", for: UIControlState.normal)
        self.saveScoreButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.saveScoreButton.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        self.saveScoreButton.addTarget(self, action: #selector(saveGameScore), for: UIControlEvents.touchUpInside)
        
        
        self.view.addSubview(shadowView)
        self.view.addSubview(scoreRegisteringView)
        self.scoreRegisteringView.addSubview(scoreLabel)
        self.scoreRegisteringView.addSubview(nameInputTextField)
        self.scoreRegisteringView.addSubview(saveScoreButton)
    }
    
    func saveGameScore() {
        if self.nameInputTextField.hasText
        {
            let realm = try! Realm()
            let name = self.nameInputTextField.text
            var score = Score()
            if self.selectedGameMode == 0
            {
                score = TimeAttackScore()
                score.name = name!
                score.score = self.currentScore
            }
            else if self.selectedGameMode == 1
            {
                score = BlitzScore()
                score.name = name!
                score.score = self.currentScore
            }
            else if self.selectedGameMode == 2
            {
                score = SurvivalScore()
                score.name = name!
                score.score = self.currentScore
            }
            else
            {
                score = EndlessScore()
                score.name = name!
                score.score = self.currentScore
            }
            
            try! realm.write {
                realm.add(score)
            }
            
            dismissGame()
        }
        else
        {
            
        }
    }
    
    func dismissGame() {
        self.delegate?.reloadHighscores()
        self.delegate?.replayMainMenuMusic()
        dismiss(animated: true, completion: nil)
    }
    
    func loadGameQuestions() {
        let realm = try! Realm()
        let questions = realm.objects(Question.self)
        for question in questions {
            self.possibleQuestions.append(question)
        }
        loadRandomQuestion()
    }
    
    func reloadGameQuestions() {
        let realm = try! Realm()
        let questions = realm.objects(Question.self)
        for question in questions {
            self.possibleQuestions.append(question)
        }
    }
    
    func loadRandomQuestion() {
        self.possibleAnswer1.isHidden = true
        self.possibleAnswer2.isHidden = true
        self.possibleAnswer3.isHidden = true
        self.possibleAnswer4.isHidden = true
        let random = arc4random_uniform(UInt32(self.possibleQuestions.count))
        self.currentQuestion = self.possibleQuestions.remove(at: Int(random))
        self.questionTextView.text = self.currentQuestion.question
        let possibleAnswers = self.currentQuestion.possibleAnswers
        self.possibleAnswer1.setTitle(possibleAnswers[0].answer, for: UIControlState.normal)
        self.possibleAnswer1.isHidden = false
        self.possibleAnswer2.setTitle(possibleAnswers[1].answer, for: UIControlState.normal)
        self.possibleAnswer2.isHidden = false
        if possibleAnswers.count > 2
        {
            self.possibleAnswer3.setTitle(possibleAnswers[2].answer, for: UIControlState.normal)
            self.possibleAnswer3.isHidden = false
        }
        if possibleAnswers.count > 3
        {
            self.possibleAnswer4.setTitle(possibleAnswers[3].answer, for: UIControlState.normal)
            self.possibleAnswer4.isHidden = false
        }
        
        if self.possibleQuestions.count == 0
        {
            reloadGameQuestions()
        }
    }
    
    @IBAction func checkPressedAnswer(_ sender: UIButton) {
        let chosenAnswer = sender.currentTitle
        if chosenAnswer == self.currentQuestion.answer?.answer
        {
            print("Correct answer")
            playSound(WithURL: self.CorrectAnswerSound)
            performActionUponAnsweringAttempt(true)
            sender.layer.borderColor = UIColor.correctAnswerColor().cgColor
            sender.setTitleColor(UIColor.correctAnswerColor(), for: UIControlState.normal)
            self.currentScore = self.currentScore + self.currentQuestion.score
            self.addedScoreLabel.text = "+\(self.currentQuestion.score)"
            self.addedScoreLabel.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.addedScoreLabel.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
            })
            UIView.animate(withDuration: 0.5, animations: {
                self.addedScoreLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
            _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(hideAddedScoreLabel), userInfo: nil, repeats: false)
        }
        else
        {
            print("Wrong answer")
            playSound(WithURL: self.IncorrectAnswerSound)
            performActionUponAnsweringAttempt(false)
            sender.layer.borderColor = UIColor.incorrectAnswerColor().cgColor
            sender.setTitleColor(UIColor.incorrectAnswerColor(), for: UIControlState.normal)
            highlightCorrectAnswer((self.currentQuestion.answer?.answer)!)
        }
        
        _ = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(resetQuestionSettings), userInfo: nil, repeats: false)
    }
    
    func playSound(WithURL url: NSURL) {
        try! self.soundsAudioPlayer = AVAudioPlayer(contentsOf: url as URL)
        self.soundsAudioPlayer.prepareToPlay()
        self.soundsAudioPlayer.play()
        if #available(iOS 10.0, *) {
            self.soundsAudioPlayer.setVolume(self.gameVolume, fadeDuration: 1.0)
        } else {
            self.soundsAudioPlayer.volume = self.gameVolume
        }
    }
    
    func performActionUponAnsweringAttempt(_ isAnswerCorrect: Bool) {
        if isAnswerCorrect
        {
            if self.selectedGameMode == 0
            {
                self.totalGameTime = self.totalGameTime + self.currentQuestion.score
            }
        }
        else
        {
            if self.selectedGameMode == 2
            {
                self.totalLives = self.totalLives - 1
                self.timerLabel.text = "\(self.totalLives)"
                
                if self.totalLives == 0
                {
                    endGame()
                }
            }
        }
    }
    
    func highlightCorrectAnswer(_ correctAnswer: String) {
        if self.possibleAnswer1.currentTitle == correctAnswer
        {
            self.possibleAnswer1.layer.borderColor = UIColor.correctAnswerColor().cgColor
            self.possibleAnswer1.setTitleColor(UIColor.correctAnswerColor(), for: UIControlState.normal)
        }
        else if self.possibleAnswer2.currentTitle == correctAnswer
        {
            self.possibleAnswer2.layer.borderColor = UIColor.correctAnswerColor().cgColor
            self.possibleAnswer2.setTitleColor(UIColor.correctAnswerColor(), for: UIControlState.normal)
        }
        else if self.possibleAnswer3.currentTitle == correctAnswer
        {
            self.possibleAnswer3.layer.borderColor = UIColor.correctAnswerColor().cgColor
            self.possibleAnswer3.setTitleColor(UIColor.correctAnswerColor(), for: UIControlState.normal)
        }
        else
        {
            self.possibleAnswer4.layer.borderColor = UIColor.correctAnswerColor().cgColor
            self.possibleAnswer4.setTitleColor(UIColor.correctAnswerColor(), for: UIControlState.normal)
        }
    }
    
    func resetQuestionSettings() {
        setGameColor()
        loadRandomQuestion()
    }
    
    func hideAddedScoreLabel() {
        self.addedScoreLabel.isHidden = true
    }
    
    @IBAction func pauseGame(_ sender: Any) {
        self.gameAudioPlayer.pause()
        self.gameTimer.invalidate()
        self.questionTextView.textColor = UIColor.white
        // UIView set up
        var frame = self.view.frame
        self.shadowView = UIView(frame: frame)
        self.shadowView.backgroundColor = UIColor.darkerShadowColor()
        // UIButton set up
        frame = CGRect(x: self.view.frame.size.width / 6, y: self.view.frame.size.height / 3, width: self.view.frame.size.width / 1.5, height: self.view.frame.size.height / 10)
        self.continueGameButton = UIButton(frame: frame)
        self.continueGameButton.backgroundColor = self.gameColor
        self.continueGameButton.clipsToBounds = true
        self.continueGameButton.layer.cornerRadius = 8
        self.continueGameButton.setTitle("Continue", for: UIControlState.normal)
        self.continueGameButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.continueGameButton.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        self.continueGameButton.addTarget(self, action: #selector(continueGame), for: UIControlEvents.touchUpInside)
        
        self.view.addSubview(self.shadowView)
        self.view.addSubview(self.continueGameButton)
    }
    
    func continueGame() {
        self.gameAudioPlayer.play()
        self.gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTotalGameTime), userInfo: nil, repeats: true)
        self.questionTextView.textColor = self.gameColor
        self.continueGameButton.removeFromSuperview()
        self.shadowView.removeFromSuperview()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
