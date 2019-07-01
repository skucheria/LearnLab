//
//  SessionsVC.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 6/15/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit
import Firebase

class SessionsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var sessions = [Session]()
    var pending = [Session]()
    var past = [Session]()
    var upcoming = [Session]()
    var cellUser : User?

    let sessionSegment : UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Current", "Past"])
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.tintColor = UIColor(displayP3Red: 254/255, green: 74/255, blue: 26/355, alpha: 1)
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(segChanged), for: .valueChanged )
        segment.isUserInteractionEnabled = true
        return segment
    }()
    
    let topView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 240/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let sessionsTV : UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 240/255, alpha: 1)
        return tv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
        self.title = "Sessions"
        setupSegment()
        setupTableView()
        getSessions()
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 255/255, green: 124/255, blue: 89/355, alpha: 1)
        self.view.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 240/255, alpha: 1)
//        tabBarController?.tabBar.barTintColor = UIColor(displayP3Red: 202/255, green: 235/255, blue: 242/255, alpha: 1)
        
        sessionsTV.delegate = self
        sessionsTV.dataSource = self
        sessionsTV.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
        sessionRemoved()
    }
    
    func setupSegment(){
        self.view.addSubview(topView)
        let barHeight = 2 *  (self.navigationController?.navigationBar.frame.height)!
        topView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topView.topAnchor.constraint(equalTo: view.topAnchor, constant: barHeight).isActive = true
        topView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        topView.addSubview(sessionSegment)
        sessionSegment.topAnchor.constraint(equalTo: view.topAnchor, constant: barHeight).isActive = true
        sessionSegment.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sessionSegment.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        sessionSegment.heightAnchor.constraint(equalToConstant: 33).isActive = true
    }
    
    func setupTableView(){
        self.view.addSubview(sessionsTV)
        sessionsTV.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sessionsTV.topAnchor.constraint(equalTo: sessionSegment.bottomAnchor).isActive = true
        sessionsTV.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        sessionsTV.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func sessionRemoved(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let seshRef = Database.database().reference().child("grouped-sessions").child(uid)
        seshRef.observe(.childRemoved) { (snapshot) in
            self.pending.removeAll()
            self.sessions.removeAll()
            let sessionID = snapshot.key
            let indRef = Database.database().reference().child("sessions").child(sessionID)
            indRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String:Any]{
                    let session = Session()
                    session.active = dictionary["active"] as? String
                    session.tutorID = dictionary["tutorID"] as? String
                    session.studentID = dictionary["studentID"] as? String
                    session.startTime = dictionary["startTime"] as? NSNumber
                    if session.active == "no"{
                        self.pending.append(session)
                    }
                    else{
                        self.sessions.append(session)
                    }                }
                DispatchQueue.main.async { self.sessionsTV.reloadData() }
            })
        }
    }
    
    func getSessions(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let seshRef = Database.database().reference().child("grouped-sessions").child(uid)
        seshRef.observe(.childAdded) { (snapshot) in
            let sessionID = snapshot.key
            let indRef = Database.database().reference().child("sessions").child(sessionID)
            indRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String:Any]{
                    let session = Session()
                    session.active = dictionary["active"] as? String
                    session.tutorID = dictionary["tutorID"] as? String
                    session.studentID = dictionary["studentID"] as? String
                    session.startTime = dictionary["startTime"] as? NSNumber
                    if session.active == "no"{
                        self.pending.append(session)
                    }
                    else{
                        self.sessions.append(session)
                    }
                }
                DispatchQueue.main.async { self.sessionsTV.reloadData() }
            })
        }
    }
    
    @objc func segChanged(){
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Pending"
        }
        return "Upcoming"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return pending.count
        }
        return sessions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 240/255, alpha: 1)
        
        var session = Session()
        
        if(indexPath.section == 0){
            session = pending[indexPath.row]
        }
        else{
            session = sessions[indexPath.row]
        }

        let seconds = session.startTime?.doubleValue
        var timeStamp = "TIME"
        if(seconds != nil){
            let date = NSDate(timeIntervalSince1970: seconds!)
            let format = DateFormatter()
            format.dateFormat = "dd hh:mm a"
            timeStamp = format.string(from: date as Date)
        }
        var tLabel : String?
        if session.tutorID == Auth.auth().currentUser!.uid{
            tLabel = session.studentID
        }
        else{
            tLabel = session.tutorID
        }
        
        let user = getUserForUID(tLabel!)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            cell.textLabel?.text = user.name! + " " + timeStamp
        }
        
        return cell
    }
    
    
}
