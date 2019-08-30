//
//  MainVC.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 8/18/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit
import Firebase

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var currUser : User?
    var msgVC : UINavigationController!
    var profVC : UINavigationController!
    var bookUser = [User]()
    // for sessions:
    var sessions = [Session]()
    var pending = [Session]()
    var past = [Session]()
    var upcoming = [Session]()
    var tutors = [String]()
    

    let mainLabel : UILabel = {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = UIFont.boldSystemFont(ofSize: 24.0)
        name.textColor = UIColor.white
        name.text  = "LearnLab"
        return name
    }()
    
    lazy var profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 125/2
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    let name : UILabel = {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = UIFont.boldSystemFont(ofSize: 36.0)
        name.textColor = UIColor.white
        name.text  = "Hey @NAME@"
        return name
    }()
    
    lazy var menuButton : UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "menu")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
        return button
    }()
    
    lazy var profButton : UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "group3")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showProfile), for: .touchUpInside)
        return button
    }()
    
    lazy var messagesButton : UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "speech-bubble")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showMessages), for: .touchUpInside)
        return button
    }()
    
    lazy var classesButton : UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "group2")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showSearch), for: .touchUpInside)
        return button
    }()
    
    let profLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.white
        label.text  = "Profile"
        label.textAlignment = .center
        return label
    }()
    
    let messagesLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.white
        label.text  = "Messages"
        label.textAlignment = .center
        return label
    }()
    
    let classesLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.white
        label.text  = "Classes"
        label.textAlignment = .center
        return label
    }()
    
    let upcomingSessions : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Sessions"
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let sessionsTV : UITableView = {
        let options = UITableView()
        options.translatesAutoresizingMaskIntoConstraints = false
        options.layer.cornerRadius = 5
        options.layer.masksToBounds = true
        return options
    }()
    
    let bookbutton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 245/255, green: 166/255, blue: 25/255, alpha: 1)
        button.setTitle("Book Session", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(showSearch), for: .touchUpInside)
        return button
    }()
    
    let sessionSegment : UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Current", "Past"])
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.tintColor = .white
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(segChanged), for: .valueChanged )
        segment.isUserInteractionEnabled = true
        return segment
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 31/255, green: 9/255, blue: 87/255, alpha: 1)
        sessionsTV.delegate = self
        sessionsTV.dataSource = self
        sessionsTV.register(SessionCell.self, forCellReuseIdentifier: "cellId")
        currUser = getUserForUID(Auth.auth().currentUser!.uid)
        getSessions()
        fetchUser()
        setupViews()
        configureMessagesVC()
        configureProfileVC()
        // Do any additional setup after loading the view.
    }

    func fetchUser(){
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        let curr = User()
        ref.child("user").observeSingleEvent(of: .value
            , with: { (snapshot) in
                if let dictionary = snapshot.value as? [String : [String:Any]]{
                    for item in dictionary{
                        if(item.key == (uid!)){
                            curr.email = item.value["email"] as? String
                            curr.name = item.value["name"]as? String
                            curr.profLinik = item.value["profilePic"] as? String
                            curr.id = item.key
                            curr.courses =  item.value["classes"] as? [String]
                            self.name.text = "Hey " + curr.name!
                            let profileImageUrl = curr.profLinik
                            self.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl!)
                            self.bookUser.append(curr)
                        }
                    }
                }
        })
    }
    
    @objc func segChanged(){
//        self.progressHUD.show()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//            self.progressHUD.hide()
//        }
//        self.sessionsTV.reloadData()
    }
    
    
    func getSessions(){
        let currentTime: NSNumber = (Date().timeIntervalSince1970 as AnyObject as! NSNumber)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let seshRef = Database.database().reference().child("grouped-sessions").child(uid)
        seshRef.observe(.childAdded) { (snapshot) in
            let sessionID = snapshot.key
            print("Session ID snapshot key: ", sessionID)
            let indRef = Database.database().reference().child("sessions").child(sessionID)
            indRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String:Any]{
                    let session = Session()
                    session.active = dictionary["active"] as? String
                    session.tutorID = dictionary["tutorID"] as? String
                    session.studentID = dictionary["studentID"] as? String
                    session.startTime = dictionary["startTime"] as? NSNumber
                    session.declined = dictionary["declined"] as? String
                    session.sessionID = dictionary["sessionID"] as? String
                    session.endTime = dictionary["endTime"] as? NSNumber
                    session.long = dictionary["longitude"] as? NSNumber
                    session.lat = dictionary["latitude"] as? NSNumber
                    session.name = dictionary["name"] as? String
                    let end = (session.endTime!.floatValue)
                    if end < currentTime.floatValue{
                        if session.declined == "no"{
                            self.past.append(session)
                            self.past.sort(by: { (m1, m2) -> Bool in
                                return (m1.startTime?.floatValue)! < (m2.startTime?.floatValue)!
                            })
                        }
                    }
                    else if session.active == "no" && session.declined == "no"{ //waiting for confirm or decline
                        self.pending.append(session)
                        self.pending.sort(by: { (m1, m2) -> Bool in
                            return (m1.startTime?.intValue)! < (m2.startTime?.intValue)!
                        })
                    }
                    else if session.active == "yes" && session.declined == "no" { //session has been confirmed
                        self.sessions.append(session)
                        self.sessions.sort(by: { (m1, m2) -> Bool in
                            return (m1.startTime?.intValue)! < (m2.startTime?.intValue)!
                        })
                    }
                }
                DispatchQueue.main.async { self.sessionsTV.reloadData() }
            })
        }
    }
    
    func setupViews(){
        self.view.addSubview(profileImageView)
        self.view.addSubview(name)
        self.view.addSubview(mainLabel)
        self.view.addSubview(menuButton)
        self.view.addSubview(messagesButton)
        self.view.addSubview(upcomingSessions)
        self.view.addSubview(sessionsTV)
        self.view.addSubview(bookbutton)
        self.view.addSubview(sessionSegment)
        
        mainLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        mainLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        mainLabel.widthAnchor.constraint(equalToConstant: 100)
        mainLabel.heightAnchor.constraint(equalToConstant: 20)
        
        menuButton.topAnchor.constraint(equalTo: mainLabel.topAnchor).isActive = true
        menuButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        
        profileImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 35).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 125).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 125).isActive = true
        
        name.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 15).isActive = true
        name.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        name.widthAnchor.constraint(equalToConstant: 100)
        name.heightAnchor.constraint(equalToConstant: 20)
        
        messagesButton.topAnchor.constraint(equalTo: mainLabel.topAnchor).isActive = true
        messagesButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        
        upcomingSessions.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        upcomingSessions.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 30).isActive = true
        
        sessionSegment.topAnchor.constraint(equalTo:upcomingSessions.bottomAnchor, constant: 5).isActive = true
        sessionSegment.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        sessionSegment.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        sessionSegment.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        
        bookbutton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        bookbutton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        bookbutton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        bookbutton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        sessionsTV.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        sessionsTV.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        sessionsTV.topAnchor.constraint(equalTo: sessionSegment.bottomAnchor, constant: 8).isActive = true
        sessionsTV.bottomAnchor.constraint(equalTo: bookbutton.topAnchor, constant: -9).isActive = true
    }
    
    func configureMessagesVC(){
        if(msgVC == nil){
            msgVC = UINavigationController(rootViewController: MessagesVC())
        }
    }
    
    func configureProfileVC(){
        if(profVC == nil){
            profVC = UINavigationController(rootViewController: ProfileVC())
        }
    }
    
    @objc func showMessages(){
        present(msgVC, animated: true, completion: nil)
    }
    
    @objc func showProfile(){
        present(profVC, animated: true)
    }
    
    @objc func showMenu(){
        let newVC = MenuVC()
        present(newVC, animated: true)
    }

    @objc func showSearch(){
        let search = SearchVC()
        let navVC = UINavigationController(rootViewController: search)
        present(navVC, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return past.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! SessionCell
        var tLabel : String?
        let session = past[indexPath.row]
        if session.tutorID == Auth.auth().currentUser!.uid{
            tLabel = session.studentID
        }
        else{
            tLabel = session.tutorID
        }
        print("filling out the cells")
        let user = getCurrUserObject(tLabel!) // rewrite in this class
        let start = NSDate(timeIntervalSince1970: session.startTime!.doubleValue)
        let end = NSDate(timeIntervalSince1970: session.endTime!.doubleValue)
        let format = DateFormatter()
        format.dateFormat = "MMM d, h:mma"
        let format2 = DateFormatter()
        format2.dateFormat = "h:mma"
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            cell.nameLabel.text = user.name!
            cell.classLabel.text = session.name!
            cell.timeLabel.text = format.string(from: start as Date) + " - " + format2.string(from: end as Date)
            self.tutors.append(user.name!)
            print("adding tutor: ", user.name!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var sesh : Session?
        sesh = past[indexPath.row]
        
        for name in tutors{
            print("tutor: ", name)
        }
        
        print("number of tutors: ", tutors.count)
        
        let bookSession = SessionInfoVC()
        bookSession.currentSession = sesh
        bookSession.currentTutor = self.tutors[indexPath.row]
        bookSession.tutorId = past[indexPath.row].tutorID
//        bookSession.curr = bookUser[indexPath.row]
        present(bookSession, animated:true)
    }

    func getCurrUserObject(_ uid : String) -> User{
        let user = User()
        let ref = Database.database().reference()
        ref.child("user").observeSingleEvent(of: .value
            , with: { (snapshot) in
                if let dictionary = snapshot.value as? [String : [String:Any]]{
                    for item in dictionary{
                        user.id = item.key
                        if(user.id == uid){
                            user.tutor = item.value["tutor"] as? String
                            user.email = item.value["email"] as? String
                            user.name = item.value["name"] as? String
                            user.profLinik = item.value["profilePic"] as? String
                            user.bio = item.value["bio"] as? String
                            user.courses = item.value["classes"] as? [String]
                            user.rating = item.value["rating"] as? NSNumber
                            user.rate = item.value["rate"] as? String
                            user.availability = item.value["availability"] as? String
                            user.fcmToken = item.value["fcmToken"] as? String
                        }
                    }
                }
        })
        return user
    }
}

