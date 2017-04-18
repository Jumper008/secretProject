//
//  CreditsViewController.swift
//  Coloreaction
//
//  Created by Alejandro Zamudio on 4/17/17.
//
//

import UIKit

class CreditsViewController: UIViewController {
    
    @IBOutlet weak var creditsView: UIView!
    @IBOutlet weak var creditsLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.creditsView.layer.cornerRadius = 8
        self.creditsView.layer.borderWidth = 2
        self.creditsView.layer.borderColor = UIColor.mainColor().cgColor

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func returnToSettingsMenu(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
