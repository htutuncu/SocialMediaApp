//
//  SettingsVC.swift
//  SocialMediaApp
//
//  Created by Hikmet Tütüncü on 14.06.2024.
//

import UIKit
import FirebaseAuth

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toViewController", sender: nil)
        } catch {
            print("Error when signing out.")
        }
    }

}
