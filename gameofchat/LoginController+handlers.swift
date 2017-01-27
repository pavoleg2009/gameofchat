//
//  LoginController+handlers.swift
//  gameofchat
//
//  Created by Oleg Pavlichenkov on 30/11/2016.
//  Copyright © 2016 Oleg Pavlichenkov. All rights reserved.
//

import UIKit
import Firebase

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

////////////////////////////////
// Handle image selection
////////////////////////////////
    
    func handleProfileImageViewTapped(){

        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            profileImageView.image = editedImage
        }
        
 
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("image selection canceled")
        dismiss(animated: true, completion: nil)
    }

////////////////////////////////
//
////////////////////////////////
    
    func handleRegister() {
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text  else {
            print("===[LoginVC].handleRegister() : username or email or password is empty\n")
            return
        }
        
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print("===[LoginVC].handleRegister() : Error creating user in Firebase : \(error.debugDescription)\n")
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            // successfully authenticated user
            let imageName = NSUUID().uuidString
            
            let storageRef = FIRStorage.storage().reference().child("profileImages").child("\(imageName).png")
            
            if let uploadDate = UIImagePNGRepresentation(self.profileImageView.image!) {
              
              // TODO: add metadata for 
                let metadata = FIRStorageMetadata()
                metadata.contentType = "image/jpeg"
              
                storageRef.put(uploadDate, metadata: metadata, completion: { (metadata, error) in
                    
                    if error != nil {
                        print("\(error)")
                        return
                    }
                    
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                        self.registerUserIntoDatabaseWith(uid: uid, values: values)
                    }
                })
            }
        })
    }
    
    private func registerUserIntoDatabaseWith(uid: String, values: [String : Any]) {
        let ref = FIRDatabase.database().reference(fromURL: "https://gameofchat-d2a86.firebaseio.com/")
        let usersReference = ref.child("users").child(uid)
        //let ref = FIRDatabase.database().reference()

        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
        if err != nil {
        print("===[LoginVC].handleRegister() : \n")
        return
        }
        
        self.dismiss(animated: true, completion: nil)
        print("==[LoginVC].handleRegister() : Save user successfully in Firebase db\n")
        })
    }
}


