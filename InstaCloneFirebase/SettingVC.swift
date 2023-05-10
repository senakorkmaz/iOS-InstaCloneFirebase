//
//  SettingVC.swift
//  InstaCloneFirebase
//
//  Created by Senanur Korkmaz on 5.05.2023.
//

import UIKit
import Firebase
class SettingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logOutTapped(_ sender: UIButton!){
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toMainVC", sender: nil)
        }catch{
            print("Error!")
        }
    }

}
