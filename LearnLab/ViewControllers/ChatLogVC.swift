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

class ChatLogVC : UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout{
    
    var ref : DatabaseReference?
    var messages = [Message]()
    
    var toUser : User? {
        didSet{
            navigationItem.title = toUser?.name
            observeMessages()
        }
    }
    
    func observeMessages(){
        let userMsgRef = Database.database().reference().child("group-messages").child((Auth.auth().currentUser?.uid)!)
        userMsgRef.observe(.childAdded, with: { (snapshot) in
            let msgsRef = Database.database().reference().child("messages").child(snapshot.key) //getting the message for messageID from snapshot key
            msgsRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dict = snapshot.value as? [String:AnyObject] else{return}
                let msg = Message()
                msg.setValuesForKeys(dict)
                
                let chatPartnerID : String?
                if msg.fromID == Auth.auth().currentUser?.uid{
                    chatPartnerID = msg.toID
                }
                else{
                    chatPartnerID = msg.fromID
                }
                
                if chatPartnerID == self.toUser?.id{
                    self.messages.append(msg)
                    DispatchQueue.main.async { self.collectionView?.reloadData() }
                }
            })
        }, withCancel: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tabBarController?.tabBar.isHidden = true
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: "cellId")//        navigationItem.title = "Chat Log"
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
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 40)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.item]
        cell.textView.text = message.text
        
        setupCell(cell, message: message)

        cell.bubbleWidthAnchor?.constant = estimateFrameForText(message.text!).width + 32

        return cell
    }
    
    fileprivate func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont.systemFont(ofSize: 16)]), context: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    fileprivate func setupCell(_ cell: ChatMessageCell, message: Message) {
        if let profileImageUrl = self.toUser?.profLinik {
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        
        if message.fromID == Auth.auth().currentUser?.uid {
            //outgoing blue
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = true
            
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            
        } else {
            //incoming gray
            cell.bubbleView.backgroundColor = UIColor(displayP3Red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
            cell.textView.textColor = UIColor.black
            cell.profileImageView.isHidden = false
            
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
    }
    
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


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}
