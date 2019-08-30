//
//  TestScrollView.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 6/23/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit
import Firebase

class TestScrollView: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return classes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let course = classes[row]
        return (course.department! + " " + course.code!)
    }

    var classes = [Course]()
    var allReviews = [Review]()
    var currentUserInfo : User?
    var numSessions = 0
    var numReviews = 0
    var pending : Bool = false
    var needReview : Bool = false
    var seshForReview : String?
    var tutorReviewed : String?
    
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
        label.text = " "
        label.font = UIFont.boldSystemFont(ofSize: 24.0)

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ratingLabel : UILabel = {
        let label = UILabel()
        label.text = " ⭐️ "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bioLabel : UILabel = {
        let label = UILabel()
        label.text = "About"
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let aboutText : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    let availLabel : UILabel = {
        let label = UILabel()
        label.text = "Availability"
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let availText : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subjectsLabel : UILabel = {
        let label = UILabel()
        label.text = "Subjects"
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
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
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let reviewsTV : UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let noReviews : UILabel = {
        let label = UILabel()
        label.text = "No reviews"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let toolbar : UIToolbar = {
        let bar = UIToolbar()
        bar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker));
        bar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        return bar
    }()
    
    let datePicker : UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = UIDatePicker.Mode.dateAndTime
        picker.minuteInterval = 15
        return picker
    }()
    
    let classesPicker : UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()

    let bookSessionTF : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.text = "Book Session"
        tf.backgroundColor = UIColor(displayP3Red: 255/255, green: 124/255, blue: 89/355, alpha: 1)
        tf.textColor = .white
        tf.textAlignment = .center
        return tf
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
        v.backgroundColor = .white
        return v
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        getSessionAndReviewInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 255/255, green: 124/255, blue: 89/355, alpha: 1)
        self.navigationController?.navigationBar.tintColor = .white

        // add the scroll view to self.view
        self.view.addSubview(scrollView)
        
        // constrain the scroll view to 8-pts on each side
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        setupScrollViews()
        subjectsTV.delegate = self
        subjectsTV.dataSource = self
        subjectsTV.register(ClassInfoCell.self, forCellReuseIdentifier: "cellId")
        
        reviewsTV.delegate = self
        reviewsTV.dataSource = self
        reviewsTV.register(ClassInfoCell.self, forCellReuseIdentifier: "cellId")
        
        classesPicker.dataSource = self
        classesPicker.delegate = self
    
        pullCourses()
        if currentTutor?.reviews != nil{
            pullReviews()
        }
        currentUserInfo = getUserForUID(Auth.auth().currentUser!.uid)
        
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "messages_white"), for: UIControl.State.normal)
        button.addTarget(self, action:#selector(sendMessage), for:.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    func pullCourses(){
        if currentTutor?.courses != nil{
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
    }
    
    func pullReviews(){
        let revRef = Database.database().reference().child("grouped-reviews")
        if currentTutor?.reviews != nil{
            for r in currentTutor!.reviews!{
                revRef.child(currentTutor!.id!).child(r).observeSingleEvent(of: .value) { (snapshot) in
                    if let dict = snapshot.value as? [String:Any]{
                        let review = Review()
                        review.rating = dict["rating"] as? NSNumber
                        review.text = dict["text"] as? String
                        self.allReviews.append(review)
                    }
                    DispatchQueue.main.async { self.reviewsTV.reloadData() }
                }
            }
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
        nameLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -8)
        nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 10).isActive = true
//        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        nameLabel.text = currentTutor?.name
        self.scrollView.addSubview(ratingLabel)
        ratingLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        ratingLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -8).isActive = true
        ratingLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15).isActive = true
        self.scrollView.addSubview(bioLabel)
        bioLabel.leftAnchor.constraint(equalTo: self.profileImageView.leftAnchor, constant: -8).isActive = true
        bioLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10).isActive = true
        bioLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        bioLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.scrollView.addSubview(aboutText)
        aboutText.leftAnchor.constraint(equalTo: self.profileImageView.leftAnchor, constant: -8).isActive = true
        aboutText.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 5).isActive = true
        aboutText.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
//        aboutText.heightAnchor.constraint(equalToConstant: 50).isActive = true
        aboutText.text = currentTutor!.bio
        self.scrollView.addSubview(availLabel)
        availLabel.leftAnchor.constraint(equalTo: self.profileImageView.leftAnchor, constant: -8).isActive = true
        availLabel.topAnchor.constraint(equalTo: aboutText.bottomAnchor, constant: 25).isActive = true
        availLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        availLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.scrollView.addSubview(availText)
        availText.leftAnchor.constraint(equalTo: self.profileImageView.leftAnchor, constant: -8).isActive = true
        availText.topAnchor.constraint(equalTo: availLabel.bottomAnchor, constant: 5).isActive = true
        availText.widthAnchor.constraint(equalToConstant: 150).isActive = true
        availText.heightAnchor.constraint(equalToConstant: 20).isActive = true
        availText.text = currentTutor!.availability
        self.scrollView.addSubview(subjectsLabel)
        subjectsLabel.leftAnchor.constraint(equalTo: self.profileImageView.leftAnchor, constant: -8).isActive = true
        subjectsLabel.topAnchor.constraint(equalTo: availText.bottomAnchor, constant: 25).isActive = true
        subjectsLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        subjectsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.scrollView.addSubview(subjectsTV)
        subjectsTV.leftAnchor.constraint(equalTo: self.profileImageView.leftAnchor, constant: -16).isActive = true
        subjectsTV.topAnchor.constraint(equalTo: subjectsLabel.bottomAnchor, constant: 5).isActive = true
        subjectsTV.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        subjectsTV.heightAnchor.constraint(equalToConstant: 130).isActive = true
        self.scrollView.addSubview(reviewsLabel)
        reviewsLabel.leftAnchor.constraint(equalTo: self.profileImageView.leftAnchor, constant: -8).isActive = true
        reviewsLabel.topAnchor.constraint(equalTo: subjectsTV.bottomAnchor, constant: 25).isActive = true
        reviewsLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        reviewsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        self.scrollView.addSubview(bookSessionButton)
        if currentTutor?.reviews != nil{
            self.scrollView.addSubview(reviewsTV)
            reviewsTV.leftAnchor.constraint(equalTo: self.profileImageView.leftAnchor, constant: -16).isActive = true
            reviewsTV.topAnchor.constraint(equalTo: reviewsLabel.bottomAnchor, constant: 5).isActive = true
            reviewsTV.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
            reviewsTV.heightAnchor.constraint(equalToConstant: 174).isActive = true
            reviewsTV.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
//            bookSessionButton.topAnchor.constraint(equalTo: reviewsTV.bottomAnchor, constant: 5).isActive = true

        }
        else{
            self.scrollView.addSubview(noReviews)
            noReviews.leftAnchor.constraint(equalTo: self.profileImageView.leftAnchor, constant: -8).isActive = true
            noReviews.topAnchor.constraint(equalTo: reviewsLabel.bottomAnchor, constant: 5).isActive = true
            noReviews.widthAnchor.constraint(equalToConstant: 150).isActive = true
            noReviews.heightAnchor.constraint(equalToConstant: 20).isActive = true
            noReviews.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
//            bookSessionButton.topAnchor.constraint(equalTo: noReviews.bottomAnchor, constant: 5).isActive = true
        }
        

        // add labelTwo to the scroll view
//        scrollView.addSubview(labelTwo)
//        // constrain labelTwo at 400-pts from the left
//        labelTwo.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
//        // constrain labelTwo at 1000-pts from the top
//        labelTwo.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 800).isActive = true
//        // constrain labelTwo to right & bottom with 16-pts padding
//        labelTwo.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -16.0).isActive = true
//        labelTwo.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16.0).isActive = true
    }

    
    func getSessionAndReviewInfo(){
        //go through all sessions for current user and see if reviews < sessions
        let databaseReferece = Database.database().reference().child("grouped-sessions").child(Auth.auth().currentUser!.uid)
        databaseReferece.observeSingleEvent(of: .childAdded) { (snapshot) in
            let sessionID = snapshot.key
            let indRef = Database.database().reference().child("sessions").child(sessionID)
            indRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? [String : Any]{
                    if dict["studentID"] as? String == Auth.auth().currentUser!.uid{ // only do stuff is student already had booked sessions
                        if dict["active"] as? String == "yes"{
                            print("GOT HERE")
                            let currentTime: NSNumber = (Date().timeIntervalSince1970 as AnyObject as! NSNumber)
                            let end = dict["endTime"] as? NSNumber
                            if (end!.floatValue < currentTime.floatValue){
                                if (dict["reviewed"] as? Float == 0) {
                                    print("NOT REVIEWED")
                                    self.needReview = true
                                    self.seshForReview = dict["sessionID"] as? String
                                    self.tutorReviewed = dict["tutorID"] as? String
                                }
                            }
                        }
                        else if dict["active"] as? String == "no"{
                            if dict["declined"] as? String == "no"{
                                self.pending = true
                            }
                        }
                    }
                }
            })
        }
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == reviewsTV{
            return self.allReviews.count
        }
        return classes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ClassInfoCell
        
        if tableView == reviewsTV{
            let rate = allReviews[indexPath.row].rating as? Float
            cell.textLabel?.text = "Rating: " + String(rate!)
            cell.detailTextLabel?.text = allReviews[indexPath.row].text
            return cell
        }
        let course = classes[indexPath.row]
        cell.textLabel?.text = course.department! + " " + course.code!
        cell.rateLabel.text = "$ " + currentTutor!.rate!
        cell.detailTextLabel?.text = course.title!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView == subjectsTV{
            if needReview{
                let alert = UIAlertController(title: "You must fill out a review of your last session before you can book another!", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        print("default")
                        let review = NewReviewVC()
                        review.currentTutor = self.tutorReviewed
                        review.sessionForReview = self.seshForReview
                        self.navigationController?.pushViewController(review, animated: true)
                    case .cancel:
                        print("cancel")
                    case .destructive:
                        print("destructive")
                    }}))
                self.present(alert, animated: true, completion: nil)
            }
            else if pending{
                let alert = UIAlertController(title: "You currently have a session pending! Cannot book until after or decline", message: nil, preferredStyle: .alert)
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
            else{
                let bookSession = BookSessionVC()
                bookSession.currentTutor = self.currentTutor
                bookSession.currentCourse = classes[indexPath.row]
                let navController = UINavigationController(rootViewController: bookSession)
                present(navController, animated: true, completion: nil)
            }
        }
    }
    
    @objc func sendMessage(){
        let chatVC = ChatLogVC(collectionViewLayout: UICollectionViewFlowLayout())
        let navController = UINavigationController(rootViewController: chatVC)
        chatVC.toUser = currentTutor
        chatVC.curr = currentUserInfo
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    @objc func donePicker(){
        print(classesPicker.selectedRow(inComponent: 0))
    }
    
    @objc func cancelPicker(){
        self.view.endEditing(true)
    }
}
