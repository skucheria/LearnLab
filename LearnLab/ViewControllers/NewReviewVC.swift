//
//  NewReviewVC.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 7/28/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit
import Firebase
import Cosmos

class NewReviewVC: UIViewController, UITextViewDelegate {
    var currentTutor : String?
    var curr : User?
    var currentCourse : Course?
    var sessionForReview : String?
    let info : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        label.text = "Write a review"
        return label
    }()
    
    let stars : CosmosView = {
        let cosmosView = CosmosView()
        cosmosView.settings.updateOnTouch = true
        cosmosView.rating = 0
        cosmosView.settings.fillMode = .half
        cosmosView.settings.starMargin = 5
        cosmosView.settings.starSize = 30
        cosmosView.didFinishTouchingCosmos = { rating in
             cosmosView.rating = rating
        }
        cosmosView.didTouchCosmos = { rating in
            cosmosView.rating = rating
        }
        cosmosView.translatesAutoresizingMaskIntoConstraints = false
        return cosmosView
    }()
    
    let reviewLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Write your review below. 150 characters or less"
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()

    lazy var reviewTV : UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.isScrollEnabled = false
        tv.returnKeyType = .done
        tv.font = .systemFont(ofSize: 16)
        tv.delegate = self
        return tv
    }()
    
    let separatorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let charsLabel : UILabel = {
        let label = UILabel()
        label.text = "(0/150)"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let makeReview  : UIButton = {
        let button = UIButton()
        button.setTitle("Leave Review", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor(red: 31/255, green: 9/255, blue: 87/255, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(review), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "New Review"
        self.view.backgroundColor = .white
        setupComponents()
        curr = getUserForUID(currentTutor!)
        // Do any additional setup after loading the view.
    }
    
    func setupComponents(){
        self.view.addSubview(info)
        info.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        info.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        info.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        info.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.view.addSubview(stars)
        stars.leftAnchor.constraint(equalTo: view.leftAnchor, constant: self.view.frame.width/4).isActive = true
        stars.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        stars.topAnchor.constraint(equalTo: info.bottomAnchor, constant: 15).isActive = true
        self.view.addSubview(reviewLabel)
        reviewLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        reviewLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        reviewLabel.topAnchor.constraint(equalTo: stars.bottomAnchor, constant: 10).isActive = true
        self.view.addSubview(reviewTV)
        reviewTV.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        reviewTV.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        reviewTV.topAnchor.constraint(equalTo: reviewLabel.bottomAnchor, constant: 10).isActive = true
        self.view.addSubview(separatorView)
        separatorView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        separatorView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        separatorView.topAnchor.constraint(equalTo: reviewTV.bottomAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        self.view.addSubview(charsLabel)
        charsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        charsLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        charsLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor).isActive = true
        self.view.addSubview(makeReview)
        makeReview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        makeReview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        makeReview.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        makeReview.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
           return false
        }
        charsLabel.text = "(\(textView.text.count)/150)"
        return textView.text.count + (text.count - range.length) <= 150
    }
    
    
    @objc func review(){
        //for grouped reviews
        let ref = Database.database().reference().child("grouped-reviews").child(currentTutor!)
        let revRef = ref.childByAutoId()
        revRef.updateChildValues(["rating" : stars.rating, "tutor" : currentTutor!, "text" : reviewTV.text, "student" : Auth.auth().currentUser!.uid])

//        ref.child(ref.childByAutoId().key!).updateChildValues(["rating" : stars.rating, "tutor" : currentTutor!, "text" : reviewTV.text, "student" : Auth.auth().currentUser!.uid])
        //marking session as reviewed
        let newRef = Database.database().reference()
        newRef.child("sessions").child(sessionForReview!).updateChildValues(["reviewed" : 1])
        //updating user rating and numReviews
        let userRef = Database.database().reference().child("user")
        var numReview : Float
        if(curr!.numReviews == nil){
            numReview = 0;
        }
        else{
            numReview = curr!.numReviews!
        }
//        var numReview  : Float = curr!.numReviews!
        let oldRating = (curr!.rating?.floatValue)!
        if numReview == 0{
            userRef.child(curr!.id!).updateChildValues(["rating" : stars.rating, "numReviews" : 1])
        }
        else{
            // do the math here
            let starRate : Float = Float(stars.rating)
            var newRating : Float = (oldRating * numReview) + starRate
            numReview += 1
            newRating = newRating / numReview
            print("Old overall rating: ", oldRating)
            print("Total num of reviews now ", numReview)
            print("New rating ", starRate)
            print("Overall new rating ", newRating)
            userRef.child(curr!.id!).updateChildValues(["rating" : newRating, "numReviews" : numReview])
        }
        var oldReviews = [String]()
        if(curr!.reviews !=  nil){
            for r in curr!.reviews!{
                oldReviews.append(r)
            }
        }

        oldReviews.append(revRef.key!)
        userRef.child(curr!.id!).updateChildValues(["reviews" : oldReviews])

        self.navigationController?.popToRootViewController(animated: true)
    }
}
