//
//  TestScrollView.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 6/23/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit
import Firebase

class TestScrollView: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var classes = [Course]()
    
    var currentTutor : User? {
        didSet{
            navigationItem.title = currentTutor?.name
        }
    }
    
    lazy var profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Sensei")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 125/2
        imageView.layer.borderColor = UIColor.black.cgColor
        return imageView
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "NAME"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bioLabel : UILabel = {
        let label = UILabel()
        label.text = "ABOUT"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let aboutText : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let availLabel : UILabel = {
        let label = UILabel()
        label.text = "Availaility"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let availText : UILabel = {
        let label = UILabel()
        label.text = "MWF Afternoons"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subjectsLabel : UILabel = {
        let label = UILabel()
        label.text = "Subjects"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subjectsTV : UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
//        tv.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 240/255, alpha: 1)
        return tv
    }()
    
    let reviewsLabel : UILabel = {
        let label = UILabel()
        label.text = "Reviews"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let reviewsTV : UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let labelOne: UILabel = {
        let label = UILabel()
        label.text = "Scroll Top"
        label.backgroundColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let labelTwo: UILabel = {
        let label = UILabel()
        label.text = "Scroll Bottom"
        label.backgroundColor = .green
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .cyan
        return v
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        // add the scroll view to self.view
        self.view.addSubview(scrollView)
        
        // constrain the scroll view to 8-pts on each side
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        setupScrollViews()
        subjectsTV.delegate = self
        subjectsTV.dataSource = self
        subjectsTV.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
        pullCourses()

    }
    
    func pullCourses(){
        for c in currentTutor!.courses!{
            Firestore.firestore().collection("courses").document(c).getDocument(completion: { (snapshot, error) in
                if let dict = snapshot?.data() as? [String:String]{
                    let course = Course()
                    course.code = dict["code"]
                    course.department = dict["department"]
                    course.title = dict["title"]
                    course.school = dict["school"]
                    course.dbId = c
                    self.classes.append(course)
                }
                DispatchQueue.main.async { self.subjectsTV.reloadData() }
            })
        }
    }
    
    func setupScrollViews(){
        scrollView.addSubview(profileImageView)
        
        // constrain labelOne to left & top with 16-pts padding
        // this also defines the left & top of the scroll content
        profileImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.0).isActive = true
        profileImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16.0).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 125).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 125).isActive = true
        self.profileImageView.loadImageUsingCacheWithUrlString(urlString: currentTutor!.profLinik!)
        self.scrollView.addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 10).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        nameLabel.text = currentTutor?.name
        self.scrollView.addSubview(bioLabel)
        bioLabel.leftAnchor.constraint(equalTo: self.profileImageView.leftAnchor, constant: 10).isActive = true
        bioLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10).isActive = true
        bioLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        bioLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.scrollView.addSubview(aboutText)
        aboutText.leftAnchor.constraint(equalTo: self.profileImageView.leftAnchor, constant: 10).isActive = true
        aboutText.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 5).isActive = true
        aboutText.widthAnchor.constraint(equalToConstant: 150).isActive = true
        aboutText.heightAnchor.constraint(equalToConstant: 50).isActive = true
        aboutText.text = currentTutor!.bio
        self.scrollView.addSubview(availLabel)
        availLabel.leftAnchor.constraint(equalTo: self.profileImageView.leftAnchor, constant: 10).isActive = true
        availLabel.topAnchor.constraint(equalTo: aboutText.bottomAnchor, constant: 10).isActive = true
        availLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        availLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.scrollView.addSubview(availText)
        availText.leftAnchor.constraint(equalTo: self.profileImageView.leftAnchor, constant: 10).isActive = true
        availText.topAnchor.constraint(equalTo: availLabel.bottomAnchor, constant: 5).isActive = true
        availText.widthAnchor.constraint(equalToConstant: 150).isActive = true
        availText.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.scrollView.addSubview(subjectsLabel)
        subjectsLabel.leftAnchor.constraint(equalTo: self.profileImageView.leftAnchor, constant: 10).isActive = true
        subjectsLabel.topAnchor.constraint(equalTo: availText.bottomAnchor, constant: 10).isActive = true
        subjectsLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        subjectsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.scrollView.addSubview(subjectsTV)
        subjectsTV.leftAnchor.constraint(equalTo: self.profileImageView.leftAnchor, constant: -16).isActive = true
        subjectsTV.topAnchor.constraint(equalTo: subjectsLabel.bottomAnchor, constant: 5).isActive = true
        subjectsTV.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        subjectsTV.heightAnchor.constraint(equalToConstant: 130).isActive = true
        self.scrollView.addSubview(reviewsLabel)
        reviewsLabel.leftAnchor.constraint(equalTo: self.profileImageView.leftAnchor, constant: 10).isActive = true
        reviewsLabel.topAnchor.constraint(equalTo: subjectsTV.bottomAnchor, constant: 100).isActive = true
        reviewsLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        reviewsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.scrollView.addSubview(reviewsTV)
        reviewsTV.leftAnchor.constraint(equalTo: self.profileImageView.leftAnchor, constant: -16).isActive = true
        reviewsTV.topAnchor.constraint(equalTo: reviewsLabel.bottomAnchor, constant: 5).isActive = true
        reviewsTV.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        reviewsTV.heightAnchor.constraint(equalToConstant: 130).isActive = true
        reviewsTV.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        
        
        // add labelTwo to the scroll view
//        scrollView.addSubview(labelTwo)
//        // constrain labelTwo at 400-pts from the left
//        labelTwo.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
//        // constrain labelTwo at 1000-pts from the top
//        labelTwo.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 800).isActive = true
//        // constrain labelTwo to right & bottom with 16-pts padding
//        labelTwo.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -16.0).isActive = true
//        labelTwo.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16.0).isActive = true
//
    }


    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("NUMBER OF CLASSES ", classes.count)
        return classes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        let course = classes[indexPath.row]
        cell.textLabel?.text = course.department! + " " + course.code! + ", " + course.title!
        return cell
    }
    
}
