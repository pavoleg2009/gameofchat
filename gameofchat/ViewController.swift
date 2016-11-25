//
//  ViewController.swift
//  gameofchat
//
//  Created by Oleg Pavlichenkov on 22/11/2016.
//  Copyright © 2016 Oleg Pavlichenkov. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController {

    override func viewDidLoad() { 
        super.viewDidLoad()

        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        if FIRAuth.auth()?.currentUser?.uid == nil {
            handleLogout()
        }
        
    }

    func handleLogout() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print("=== \(logoutError)\n")
        }
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
}


