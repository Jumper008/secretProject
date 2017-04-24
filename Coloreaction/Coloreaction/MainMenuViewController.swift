//
//  MainMenuViewController.swift
//  Coloreaction
//
//  Created by Alejandro Zamudio on 4/13/17.
//
//

import UIKit
import RealmSwift
import AVFoundation

class MainMenuViewController: UIViewController, UITableViewDataSource, ReloadHighscores, ClearHighscores, ChangeAppVolume, ReplayMainMenuMusic, AVAudioPlayerDelegate {
    
    @IBOutlet weak var highscoresTableView: UITableView!
    @IBOutlet weak var timeAttackButton: UIButton! {
        willSet {
            newValue.titleLabel?.minimumScaleFactor = 0.2
            newValue.titleLabel?.numberOfLines = 1
            newValue.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet weak var blitzButton: UIButton!
    @IBOutlet weak var survivalButton: UIButton!
    @IBOutlet weak var endlessButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    var highscores = [Score]()
    /*
     - Game mode code signing is as follows:
     - Time Attack = 0
     - Blitz = 1
     - Survival = 2
     - Endless = 3
     */
    var selectedGameMode = 0
    var noHighscoresView: UIView = UIView()
    var noHighscoresLabel: UILabel = UILabel()
    let mainMenuMusic = NSURL(fileURLWithPath: Bundle.main.path(forResource: "MainMenu", ofType: "wav")!)
    var audioPlayer = AVAudioPlayer()
    var appVolume: Float = 1.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.timeAttackButton.layer.cornerRadius = 8
        self.blitzButton.layer.cornerRadius = 8
        self.survivalButton.layer.cornerRadius = 8
        self.endlessButton.layer.cornerRadius = 8
        self.startButton.layer.cornerRadius = 8
        self.highscoresTableView.layer.cornerRadius = 8
        self.highscoresTableView.layer.borderColor = UIColor.mainColor().cgColor
        self.highscoresTableView.layer.borderWidth = 2
        self.startButton.isHidden = true
        try! self.audioPlayer = AVAudioPlayer(contentsOf: self.mainMenuMusic as URL)
        self.audioPlayer.prepareToPlay()
        self.audioPlayer.play()
        self.audioPlayer.delegate = self
        
        changeHighscoreTable(self.timeAttackButton)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.displayNoneInTableViewIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.highscores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeue a cell for the given indexPath
        let cell = highscoresTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! HighscoreTableViewCell
        
        let score = self.highscores[indexPath.row]
        
        cell.nameLabel.text = score.name
        cell.scoreLabel.text = "\(score.score)"
        
        return cell
    }
    
    @IBAction func changeHighscoreTable(_ sender: UIButton) {
        self.highscores.removeAll()
        let realm = try! Realm()
        if sender == self.timeAttackButton
        {
            self.selectedGameMode = 0
            loadTimeAttackHighscores(realm)
        }
        else if sender == self.blitzButton
        {
            self.selectedGameMode = 1
            loadBlitzHighscores(realm)
        }
        else if sender == self.survivalButton
        {
            self.selectedGameMode = 2
            loadSurvivalHighscores(realm)
        }
        else
        {
            self.selectedGameMode = 3
            loadEndlessHighscores(realm)
        }
        
        self.startButton.isHidden = false
        
        self.highscoresTableView.reloadData()
        self.displayNoneInTableViewIfNeeded()
    }
    
    func displayNoneInTableViewIfNeeded() {
        self.noHighscoresLabel.removeFromSuperview()
        self.noHighscoresView.removeFromSuperview()
        
        if self.highscores.count == 0
        {
            var frame = self.highscoresTableView.frame
            self.noHighscoresView = UIView(frame: frame)
            self.noHighscoresView.backgroundColor = UIColor.white
            self.noHighscoresView.clipsToBounds = true
            self.noHighscoresView.layer.cornerRadius = 8
            frame = CGRect(x: 0.0, y: self.highscoresTableView.frame.size.height / 3, width: self.highscoresTableView.frame.size.width, height: self.highscoresTableView.frame.size.height / 6)
            self.noHighscoresLabel = UILabel(frame: frame)
            self.noHighscoresLabel.backgroundColor = UIColor.white
            self.noHighscoresLabel.textColor = UIColor.pastelGrayColor()
            self.noHighscoresLabel.text = "None"
            self.noHighscoresLabel.textAlignment = NSTextAlignment.center
            self.noHighscoresLabel.font = UIFont(name: "HelveticaNeue", size: 30)
            
            self.view.addSubview(self.noHighscoresView)
            self.noHighscoresView.addSubview(self.noHighscoresLabel)
        }
    }
    
    func loadTimeAttackHighscores(_ realm: Realm) {
        let scores = realm.objects(TimeAttackScore.self).sorted(byKeyPath: "score")
        var numberOfScores = 0
        if scores.count <= 10
        {
            numberOfScores = scores.count
        }
        else
        {
            numberOfScores = 10
        }
        
        for index in 0..<numberOfScores {
            self.highscores.insert(scores[index], at: 0)
        }
    }
    
    func loadBlitzHighscores(_ realm: Realm) {
        let scores = realm.objects(BlitzScore.self).sorted(byKeyPath: "score")
        var numberOfScores = 0
        if scores.count <= 10
        {
            numberOfScores = scores.count
        }
        else
        {
            numberOfScores = 10
        }
        
        for index in 0..<numberOfScores {
            self.highscores.insert(scores[index], at: 0)
        }
    }
    
    func loadSurvivalHighscores(_ realm: Realm) {
        let scores = realm.objects(SurvivalScore.self).sorted(byKeyPath: "score")
        var numberOfScores = 0
        if scores.count <= 10
        {
            numberOfScores = scores.count
        }
        else
        {
            numberOfScores = 10
        }
        
        for index in 0..<numberOfScores {
            self.highscores.insert(scores[index], at: 0)
        }
    }
    
    func loadEndlessHighscores(_ realm: Realm) {
        let scores = realm.objects(EndlessScore.self).sorted(byKeyPath: "score")
        var numberOfScores = 0
        if scores.count <= 10
        {
            numberOfScores = scores.count
        }
        else
        {
            numberOfScores = 10
        }
        
        for index in 0..<numberOfScores {
            self.highscores.insert(scores[index], at: 0)
        }
    }
    
    func reloadHighscores() {
        self.highscores.removeAll()
        let realm = try! Realm()
        if self.selectedGameMode == 0
        {
            loadTimeAttackHighscores(realm)
        }
        else if self.selectedGameMode == 1
        {
            loadBlitzHighscores(realm)
        }
        else if self.selectedGameMode == 2
        {
            loadSurvivalHighscores(realm)
        }
        else
        {
            loadEndlessHighscores(realm)
        }
        
        displayNoneInTableViewIfNeeded()
        
        self.highscoresTableView.reloadData()
    }
    
    func clearHighscores() {
        self.highscores.removeAll()
        displayNoneInTableViewIfNeeded()
        self.highscoresTableView.reloadData()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.audioPlayer.play()
    }
    
    func changeAppVolume(_ volume: Float) {
        self.appVolume = volume
        self.audioPlayer.setVolume(volume, fadeDuration: 1.0)
    }
    
    func replayMainMenuMusic() {
        self.audioPlayer.setVolume(self.appVolume, fadeDuration: 1.0)
        self.audioPlayer.play()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "Start"
        {
            let inGameUIViewController = segue.destination as! InGameViewController
            inGameUIViewController.selectedGameMode = self.selectedGameMode
            inGameUIViewController.delegate = self
            inGameUIViewController.gameVolume = self.appVolume
            self.audioPlayer.stop()
        }
        else
        {
            let settingsMenuUIViewController = segue.destination as! SettingsMenuViewController
            settingsMenuUIViewController.delegate = self
        }
    }
}
