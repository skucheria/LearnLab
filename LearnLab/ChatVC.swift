//
//  ChatVC.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 5/14/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit
import Firebase
import MessageKit
import FirebaseFirestore
import MessageInputBar
import MessageUI
import CoreData



class ChatVC: MessagesViewController {

    var messages: [Message] = []
    var member: Member!
    var fstore : Firestore!
    var chatName = String()
    var fName = String()
    var lName = String()
    var userData : [String : Any]?
    override func viewDidLoad() {
        super.viewDidLoad()
        fstore = Firestore.firestore()
        
//        let doc = fstore.collection("users").document(Auth.auth().currentUser?.uid ?? "poop")
//        doc.getDocument { (snapchat, error) in
//            if let d = snapchat?.data(){
//                self.userData = d
//                print(self.userData ?? "poop")
//                self.fName = (self.userData?["firstName"]) as! String
//                self.lName = self.userData?["lastName"] as! String
//                print(self.fName)
////                print(self.chatName)
//            }
//        }
        
        //CORE DATA STUFF ?HERE
        var userArray = [Users]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        do{
            userArray = try context.fetch(request) as! [Users]
            print ("Fetched data")
        }
        catch{
            print("Unable to fetch data")
        }

        //CHAT BUBBLES PART HERE
        member = Member(name: "poop", color: .blue)
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
}

extension ChatVC: MessagesDataSource {
    func numberOfSections(
        in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func currentSender() -> Sender {
        return Sender(id: member.name, displayName: member.name)
    }
    
    func messageForItem(
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        return messages[indexPath.section]
    }
    
    func messageTopLabelHeight(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 12
    }
    
    func messageTopLabelAttributedText(
        for message: MessageType,
        at indexPath: IndexPath) -> NSAttributedString? {
        
        return NSAttributedString(
            string: message.sender.displayName,
            attributes: [.font: UIFont.systemFont(ofSize: 12)])
    }
}

extension ChatVC: MessagesLayoutDelegate {
    func heightForLocation(message: MessageType,
                           at indexPath: IndexPath,
                           with maxWidth: CGFloat,
                           in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 0
    }
}

extension ChatVC: MessagesDisplayDelegate {
    func configureAvatarView(
        _ avatarView: AvatarView,
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) {
        
        let message = messages[indexPath.section]
        let color = message.member.color
        avatarView.backgroundColor = color
    }
}

extension ChatVC: MessageInputBarDelegate {
    func messageInputBar(
        _ inputBar: MessageInputBar,
        didPressSendButtonWith text: String) {
        
        let newMessage = Message(
            member: member,
            text: text,
            messageId: UUID().uuidString)
        
        messages.append(newMessage)
        inputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)
    }
}
