//
//  SettingsMenuViewController.swift
//  Coloreaction
//
//  Created by Alejandro Zamudio on 4/13/17.
//
//

import UIKit
import RealmSwift

protocol ClearHighscores {
    func clearHighscores()
}

protocol ChangeAppVolume {
    func changeAppVolume(_ volume: Float)
}

class SettingsMenuViewController: UIViewController {
    
    @IBOutlet weak var clearScoresButton: UIButton!
    @IBOutlet weak var creditsButton: UIButton!
    
    var delegate: MainMenuViewController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearScoresButton.layer.cornerRadius = 8
        self.clearScoresButton.layer.borderWidth = 2
        self.clearScoresButton.layer.borderColor = UIColor.mainColor().cgColor
        self.creditsButton.layer.cornerRadius = 8
        self.creditsButton.layer.borderWidth = 2
        self.creditsButton.layer.borderColor = UIColor.mainColor().cgColor

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clearScores(_ sender: Any) {
        let realm = try! Realm()
        clearTimeAttackScores(realm, realm.objects(TimeAttackScore.self))
        clearSurvivalScores(realm, realm.objects(SurvivalScore.self))
        clearEndlessScores(realm, realm.objects(EndlessScore.self))
        clearBlitzScores(realm, realm.objects(BlitzScore.self))
        delegate?.clearHighscores()
    }
    
    func clearTimeAttackScores(_ realm: Realm, _ scores: Results<TimeAttackScore>) {
        try! realm.write {
            for score in scores {
                realm.delete(score)
            }
        }
    }
    
    func clearSurvivalScores(_ realm: Realm, _ scores: Results<SurvivalScore>) {
        try! realm.write {
            for score in scores {
                realm.delete(score)
            }
        }
    }
    
    func clearEndlessScores(_ realm: Realm, _ scores: Results<EndlessScore>) {
        try! realm.write {
            for score in scores {
                realm.delete(score)
            }
        }
    }
    
    func clearBlitzScores(_ realm: Realm, _ scores: Results<BlitzScore>) {
        try! realm.write {
            for score in scores {
                realm.delete(score)
            }
        }
    }
    
    @IBAction func returnToMainMenu(_ sender: Any) {
        //_ = navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changedAppVolume(_ sender: UISlider) {
        self.delegate?.changeAppVolume(sender.value)
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
