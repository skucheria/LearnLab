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

class NewReviewVC: UIViewController {
    var currentTutor : User? {
        didSet{
            info.text = "Review for " + currentTutor!.name!
        }
    }
    
    let info : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
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

    lazy var reviewTV : UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.isScrollEnabled = false
        tv.returnKeyType = .done
        tv.font = .systemFont(ofSize: 16)
        return tv
    }()
    
    let separatorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bookSessionButton  : UIButton = {
        let button = UIButton()
        button.setTitle("Leave Review", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor(displayP3Red: 255/255, green: 124/255, blue: 89/355, alpha: 1)
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
        // Do any additional setup after loading the view.
    }
    
    func setupComponents(){
        self.view.addSubview(info)
        info.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        info.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        info.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        info.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.view.addSubview(stars)
        stars.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stars.topAnchor.constraint(equalTo: info.bottomAnchor, constant: 25).isActive = true
        stars.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        stars.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.view.addSubview(reviewTV)
        reviewTV.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        reviewTV.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        reviewTV.topAnchor.constraint(equalTo: stars.bottomAnchor, constant: 15).isActive = true
        self.view.addSubview(separatorView)
        separatorView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        separatorView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        separatorView.topAnchor.constraint(equalTo: reviewTV.bottomAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        self.view.addSubview(bookSessionButton)
        bookSessionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bookSessionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bookSessionButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        bookSessionButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    @objc func review(){
        print("Leaving review with rating: ", stars.rating)
    }
}
