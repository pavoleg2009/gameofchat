//
//  NewMessageController.swift
//  gameofchat
//
//  Created by Oleg Pavlichenkov on 26/11/2016.
//  Copyright © 2016 Oleg Pavlichenkov. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
    
    let cellId = "cellId"
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()
    }
    
    func fetchUser(){
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: {snapshot in
            
            if let dict = snapshot.value as? [String : Any] {
                let user = User()
                
                // this settet can crash app if some value is nil
                user.setValuesForKeys(dict)
                self.users.append(user)
                
                // this will crash becouse of background thread, so we need dispathc_asynck
                // self.tableView.reloadData()
                //dispatch_async(dispatch_get_main_queue(), {
                DispatchQueue.main.async { // or without .main
                    self.tableView.reloadData()
                }

            }
            
        }, withCancel: {error in
            print(error)
        })
    }
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
      
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        if indexPath.row % 2 == 1 {
            cell.backgroundColor = UIColor(r: 240, g: 240, b: 240)
        }
        
        
        if let profileImageUrl = user.profileImageUrl {
            let url = URL(string: profileImageUrl)
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                
                if error != nil {
                    print("===[NewMessageController]\(error)\n")
                    return
                }
                
                
                let queue = DispatchQueue(label: "com.just-eng.gameofchat", qos: DispatchQoS.default, target: nil)
                queue.async {
                   cell.profileImageView.image = UIImage(data: data!)
                }
                
            }.resume()
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}
