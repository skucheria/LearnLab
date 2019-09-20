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
        
        if selectedImage != nil {
            profImageButton.titleLabel?.text = "Image selected!"
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleRegister(){
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("form is not valid")
            return
        }
        
        // change to by segment and then check for individual fields there
        
        if loginRegSegment.selectedSegmentIndex == 1{ // jif registering
            if (email.isEmpty || password.isEmpty || name.isEmpty || self.profileImageView.image == nil){ // if any fields are missing, dont allow registration
                // incomplete registration info, dont do anything
                print("not enough info for registering")
            }
            else{
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    if error == nil{
                        print("successfully created user")
                        print("user info? ", user?.user.uid)
                    }
                    else{
                        print(error!)
                    }
                    //save user here
                    let values = ["name": name, "email": email ]
                    self.ref?.child("user").child((user?.user.uid)!).updateChildValues(values)
                    let pushManager = PushNotificationManager(userID: (user?.user.uid)!)
                    pushManager.registerForPushNotifications()
                    
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
                                    let vals = ["profilePic" : urlString, "tutor" : "no", "bio" : " ", "rating" : 0] as [String : Any]
                                    self.ref?.child("user").child((user?.user.uid)!).updateChildValues(vals) //updating with url link for image
                                }
                            })
                        }
                    }
                }
                let newVC = MainVC()
                self.present(newVC, animated: true)
            }
        }
        else{ // if logging in
            if (email.isEmpty || password.isEmpty){ // if any fields are missing, dont allow registration
                // incomplete registration info, dont do anything
                print("not enough info for logging in")
            }
            else{ // do the logging in
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    if error == nil{
                        self.progressHUD.show()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            self.progressHUD.hide()
                            let newVC = MainVC()
                            self.present(newVC, animated: true)
                        }
                    }
                    else{
                        let alert = UIAlertController(title: "The username or password is incorrect!", message: nil, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            switch action.style{
                            case .default:
                                print("default")
                            case .cancel:
                                print("cancel")
                            case .destructive:
                                print("destructive")
                            }}))
                        self.present(alert, animated: true, completion: nil)
                    }
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
