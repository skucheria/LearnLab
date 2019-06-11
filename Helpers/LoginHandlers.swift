//
//  LoginHandlers.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 5/16/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit
import Firebase
import CoreData



extension LoginVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @objc func uploadPic(){
        let picker = UIImagePickerController()
        //        picker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        print("shit")
        var selectedImage : UIImage?
        
        if let editedImage = info[.editedImage]{
            selectedImage = editedImage as? UIImage
        }
        else if let original = info[.originalImage] {
                selectedImage = original as? UIImage
        }
        
        if let imagePicked = selectedImage {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleRegister(){
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("form is not valid")
            return
        }
        
        
        if loginRegSegment.selectedSegmentIndex == 1{ //if registering
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if error == nil{
                    print("successfully created user")
                }
                else{
                    print(error!)
                }
                //save user here
                let values = ["name": name, "email": email ]
                self.ref?.child("user").child(Auth.auth().currentUser?.uid ?? "autoid").updateChildValues(values)
            }
            
            let imageName = NSUUID().uuidString
            
            let imageRef = Storage.storage().reference().child("prof_pics").child("\(imageName).jpg")
            
            if let uploadData = self.profileImageView.image?.jpegData(compressionQuality: 0.1){
                imageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    imageRef.downloadURL(completion: { (url, error) in
                        if error == nil{
                            let urlString = url?.absoluteString
                            let vals = ["profilePic" : urlString, "tutor" : "no", "bio" : " "]
                            self.ref?.child("user").child(Auth.auth().currentUser?.uid ?? "autoid").updateChildValues(vals) //updating with url link for image
                        }
                    })
                }
//                imageRef.putData(uploadData)
            }
            let newVC = MainTabController()
            self.present(newVC, animated: true)
            
        }
            
        else{ //if logging in
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if error == nil{
                    let newVC = MainTabController()
                    self.present(newVC, animated: true)
                }
            }
        }
        
    }
    
    func saveData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{ return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let usersEntity = NSEntityDescription.entity(forEntityName: "Users", in: managedContext)
        
        let curr = NSManagedObject(entity: usersEntity!, insertInto: managedContext)
        curr.setValue("name", forKey: "name")
        
        
        
        
    }
    
}
