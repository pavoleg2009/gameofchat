//
//  ViewController.swift
//  gameofchat
//
//  Created by Oleg Pavlichenkov on 22/11/2016.
//  Copyright © 2016 Oleg Pavlichenkov. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    
    let image = UIImage(named: "edit_button")
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
    
    checkIfUserLoggedIn()
    
  }
  
  func handleNewMessage(){
    let newMessageController = NewMessageController()
    let navController = UINavigationController(rootViewController: newMessageController)
    present(navController, animated: true, completion: nil)
  }
  
  func checkIfUserLoggedIn(){
    if FIRAuth.auth()?.currentUser?.uid == nil {
      //handleLogout()
      perform(#selector(handleLogout), with: nil, afterDelay: 0) // to suspend some warning
    } else {
      fetchUserAndSetupNavBarTitle()
    }
  }
  
  func fetchUserAndSetupNavBarTitle() {
    guard let uid = FIRAuth.auth()?.currentUser?.uid else {
      return
    }
    
    FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
      if let dictionary = snapshot.value as? Dictionary<String,  Any>{
        self.navigationItem.title = dictionary["name"] as? String
      }
    })
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


