//
//  LoginHandlers.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 5/16/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit
import Firebase


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
                    print(error)
                }
                //save user here
                let values = ["name": name, "email": email ]
                self.ref?.child("user").child(Auth.auth().currentUser?.uid ?? "autoid").updateChildValues(values)
            }
            let imageRef = Storage.storage().reference().child("test.png")
            
            if let uploadData = self.profileImageView.image?.pngData(){
                print("UPLOADING IMAGE DATA ", uploadData)
                imageRef.putData(uploadData)
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
}
