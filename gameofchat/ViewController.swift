//
//  ViewController.swift
//  gameofchat
//
//  Created by Oleg Pavlichenkov on 22/11/2016.
//  Copyright © 2016 Oleg Pavlichenkov. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() { 
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(hangLogout))

        
    }

    func hangLogout() {
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
}

