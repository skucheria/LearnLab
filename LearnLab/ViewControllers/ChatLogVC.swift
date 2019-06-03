//
//  ChatLogVC.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 5/22/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ChatLogVC : UIViewController, UITextFieldDelegate{
    
    var ref : DatabaseReference?
    
    var toUser : User? {
        didSet{
            navigationItem.title = toUser?.name
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tabBarController?.tabBar.isHidden = true

//        navigationItem.title = "Chat Log"
        self.view.backgroundColor = .white
        ref = Database.database().reference()

        setupInputComponents()
    }
    
    lazy var inputTextField : UITextField = {
        let inputTextField = UITextField()
        inputTextField.placeholder = "Enter message"
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.delegate = self
        return inputTextField
    }()
    

    
    func setupInputComponents(){
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(containerView)
        let barHeight = -1 * (self.tabBarController?.tabBar.frame.size.height)!
        containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: barHeight).isActive = true
        containerView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        containerView.addSubview(inputTextField)
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive=true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive=true
        
        let separatorLineView = UIView()
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        separatorLineView.backgroundColor = UIColor(displayP3Red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        containerView.addSubview(separatorLineView)
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    @objc func handleSend(){
        let timestamp: NSNumber = (Date().timeIntervalSince1970 as AnyObject as! NSNumber)
        let values = ["text" : inputTextField.text!, "fromID" : Auth.auth().currentUser!.uid, "toID" : toUser!.id!, "timestamp" : timestamp ] as [String : Any]
//        let values2 = ["timestamp" : timestamp]
        let re = Database.database().reference().child("messages")
        let childRef = re.childByAutoId()
        childRef.updateChildValues(values)
//        childRef.updateChildValues(values2)
//        groupMessages(key: childRef.key!)
        inputTextField.text = ""
        
        let groupRef = Database.database().reference().child("group-messages")
        let child = groupRef.child((Auth.auth().currentUser?.uid)!)
        child.updateChildValues([childRef.key! : 1])
        
        let recipientMessageRef = Database.database().reference().child("group-messages").child(toUser!.id!)
        
        recipientMessageRef.updateChildValues([childRef.key! : 1])
    }
    
    func groupMessages(key : String){
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    
    
    
    
    
}
