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
        segment.tintColor = UIColor(displayP3Red: 255/255, green: 124/255, blue: 89/355, alpha: 1)
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(segChanged), for: .valueChanged )
        segment.isUserInteractionEnabled = true
        return segment
    }()
    
    let topView : UIView = {
        let view = UIView()
//        view.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 240/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let sessionsTV : UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
//        tv.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 240/255, alpha: 1)
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
//        self.view.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 240/255, alpha: 1)
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .white

        sessionsTV.delegate = self
        sessionsTV.dataSource = self
        sessionsTV.register(PendingSessionCell.self, forCellReuseIdentifier: "cellId")

        sessionStatusChanged()
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
    
    func sessionStatusChanged(){
        //this only gets the one that changed, need to figure out whether it's been accepted or declined
        let changedRef = Database.database().reference().child("sessions")
        changedRef.observe(.childChanged) { (snapshot) in
            if let dictionary = snapshot.value as? [String:Any]{
                let session = Session()
                session.active = dictionary["active"] as? String
                session.tutorID = dictionary["tutorID"] as? String
                session.studentID = dictionary["studentID"] as? String
                session.startTime = dictionary["startTime"] as? NSNumber
                session.declined = dictionary["declined"] as? String
                session.sessionID = dictionary["sessionID"] as? String
                // cases to check:
                // if session confirmed --> add to sessions, remove from pending
                // if session declined --> dont add to session, remove from pending
                if session.active == "yes"{
                    self.sessions.append(session)
                    self.sessions.sort(by: { (m1, m2) -> Bool in
                        return (m1.startTime?.intValue)! < (m2.startTime?.intValue)!
                    })
                }
                
                var counter = 0
                for s in self.pending{
                    if s.sessionID == session.sessionID{
                        self.pending.remove(at: counter)
                    }
                    counter+=1
                }
            }
            DispatchQueue.main.async { self.sessionsTV.reloadData() }
        }
    }
    
    func getSessions(){
        let currentTime: NSNumber = (Date().timeIntervalSince1970 as AnyObject as! NSNumber)
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
                    session.declined = dictionary["declined"] as? String
                    session.sessionID = dictionary["sessionID"] as? String
                    
                    if session.startTime!.floatValue < currentTime.floatValue{
                        if session.declined == "no"{
                            self.past.append(session)
                            self.past.sort(by: { (m1, m2) -> Bool in
                                return (m1.startTime?.intValue)! < (m2.startTime?.intValue)!
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
    
    @objc func segChanged(){
        self.sessionsTV.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let title = sessionSegment.titleForSegment(at: sessionSegment.selectedSegmentIndex)
        if title == "Past"{
            return 1
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = sessionSegment.titleForSegment(at: sessionSegment.selectedSegmentIndex)
        if title == "Current"{
            if section == 0{
                return "Pending"
            }
            return "Upcoming"
        }
        return "Past Sessions"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let title = sessionSegment.titleForSegment(at: sessionSegment.selectedSegmentIndex)
        if title == "Current"{
            if section == 0 {
                return pending.count
            }
            return sessions.count
        }
        else{
            return past.count
        }
        
//        return pending.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = sessionSegment.titleForSegment(at: sessionSegment.selectedSegmentIndex)

        let pendingCell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! PendingSessionCell
        pendingCell.delegate = self
//        cell.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 240/255, alpha: 1)
        var session = Session()
        
        if title == "Current"{
            if(indexPath.section == 0){
                session = pending[indexPath.row]
                pendingCell.confirmIndex = indexPath.row
                if Auth.auth().currentUser?.uid == session.studentID{
                    pendingCell.confirmButton.isHidden = true
                    pendingCell.declineButton.isHidden = true
                }
                else{
                    pendingCell.confirmButton.isHidden = false
                    pendingCell.declineButton.isHidden = false
                }
            }
            else{
                session = sessions[indexPath.row]
                pendingCell.confirmButton.isHidden = true
                pendingCell.declineButton.isHidden = true
            }
        }
        else{
            session = past[indexPath.row]
            pendingCell.confirmButton.isHidden = true
            pendingCell.declineButton.isHidden = true
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
            pendingCell.infoLabel.text = user.name! + " " + timeStamp
        }
        
        return pendingCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension SessionsVC: CustomCellDelegate {
    func confirmPressed(cell: PendingSessionCell) {
        print("Getting here")
        let session = pending[cell.confirmIndex!]
        print("Session : ", session)
        let ref = Database.database().reference().child("sessions").child(session.sessionID!)
        ref.updateChildValues(["active" : "yes"])
        
        self.cellUser = self.getUserForUID(session.studentID!)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            print("to token: ", self.cellUser!.fcmToken!)
            let sender = PushNotificationSender()
            sender.sendPushNotification(to: self.cellUser!.fcmToken!, title: "Session status", body: "Your session request has been confirmed!")
        }
    }
    
    func declinePressed(cell: PendingSessionCell) {
        print("pressed the decline")
        let session = pending[cell.confirmIndex!]
        let ref = Database.database().reference().child("sessions").child(session.sessionID!)
        ref.updateChildValues(["declined" : "yes"])
        
        self.cellUser = self.getUserForUID(session.studentID!)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            print("to token: ", self.cellUser!.fcmToken!)
            let sender = PushNotificationSender()
            sender.sendPushNotification(to: self.cellUser!.fcmToken!, title: "Session status", body: "Your session request has been declined!")
        }
    }
}

extension Session{
    static func == (lhs: Session, rhs: Session) -> Bool {
        return lhs.sessionID == rhs.sessionID
    }
}
