//
//  SessionInfoVC.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 7/17/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class SessionInfoVC: UIViewController, MKMapViewDelegate  {
    var currentSession : Session? {
        didSet{
            let format = DateFormatter()
            format.dateFormat = "MMMM d"
            let format2 = DateFormatter()
            format2.dateFormat = "h:mma"
            let start = NSDate(timeIntervalSince1970: (currentSession?.startTime!.doubleValue)!)
            let end = NSDate(timeIntervalSince1970: (currentSession?.endTime!.doubleValue)!)
            dateLabel.text = format.string(from: start as Date)
            format.dateFormat = "d, h:mma"
            timeLabel.text = format.string(from: start as Date) + " - " + format2.string(from: end as Date)
            detailsLabel.text = currentSession?.name!
        }
    }
    var curr : User?
    var time : NSNumber?
    var dur : NSNumber?
    var currentTutor : String? {
        didSet{
            infoLabel.text = "Session with " + currentTutor!
        }
    }
    var tutorId : String?
    var msgTutor : User?
    
    let annotation = MKPointAnnotation()
    
    let infoLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        label.textColor = .white
        return label
    }()
    
    let detailsLabel : UILabel = {
        let label = UILabel()
        label.text = "Details"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    let locationLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Location"
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        label.textColor = .white
        return label
    }()
    
    lazy var mapView : MKMapView = {
        let map = MKMapView()
        map.mapType = MKMapType.standard
        map.isZoomEnabled = false
        map.isScrollEnabled = false
        map.delegate = self
        map.layer.masksToBounds = true
        map.layer.cornerRadius = 5
        return map
    }()
    
    let dateLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    let timeLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    lazy var messageButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 245/255, green: 166/255, blue: 35/255, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Message", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(showMessage), for: .touchUpInside)
        return button
    }()
    
    lazy var directionsButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 85/255, green: 100/255, blue: 255/255, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Directions", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(openMapForPlace), for: .touchUpInside)
        return button
    }()
    
    lazy var backButton : UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "chevron")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return button
    }()
    
    
    var fromChatUser : User?
    var toChatUser : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .white
        self.view.backgroundColor = UIColor(red: 31/255, green: 9/255, blue: 87/255, alpha: 1)
        
        toChatUser = getToUserObject(tutorId!)
        fromChatUser = getCurrUserObject(Auth.auth().currentUser!.uid)
        
        msgTutor = getUserForUID(tutorId!)
        setupComponents()
        setupMap()

//        fromChatUser
    }
    
    // write function for getting the person the session is with and the current user
    // person session is with is already passed in, need to fix current user for the messsages bug
    
    func getToUserObject(_ uid : String) -> User{
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
    
    func setupMap(){
        self.view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        mapView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        mapView.topAnchor.constraint(equalTo: self.locationLabel.bottomAnchor, constant: 10).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: 277).isActive = true
        let center = CLLocationCoordinate2D(latitude: CLLocationDegrees(currentSession!.lat!), longitude: CLLocationDegrees(truncating: currentSession!.long!))
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
        annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(currentSession!.lat!), longitude: CLLocationDegrees(currentSession!.long!))
        mapView.addAnnotation(annotation)
        
        self.view.addSubview(directionsButton)
        directionsButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        directionsButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        directionsButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        directionsButton.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 13).isActive = true
    
        self.view.addSubview(messageButton)
        messageButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        messageButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        messageButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        messageButton.topAnchor.constraint(equalTo: directionsButton.bottomAnchor, constant: 13).isActive = true
    }

    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupComponents(){
        self.view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        self.view.addSubview(infoLabel)
        infoLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        infoLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 15).isActive = true
        infoLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.view.addSubview(detailsLabel)
        detailsLabel.leftAnchor.constraint(equalTo: infoLabel.leftAnchor).isActive = true
        detailsLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 10).isActive = true
        detailsLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.view.addSubview(dateLabel)
        dateLabel.leftAnchor.constraint(lessThanOrEqualTo: infoLabel.leftAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 30).isActive = true
        self.view.addSubview(timeLabel)
        timeLabel.leftAnchor.constraint(lessThanOrEqualTo: infoLabel.leftAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 1).isActive = true
        self.view.addSubview(locationLabel)
        locationLabel.leftAnchor.constraint(equalTo: infoLabel.leftAnchor).isActive = true
        locationLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 45).isActive = true
    }
    
    @objc func openMapForPlace() {
        let center = CLLocationCoordinate2D(latitude: CLLocationDegrees(currentSession!.lat!), longitude: CLLocationDegrees(truncating: currentSession!.long!))
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        let opts = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span)
        ]
        let place = MKPlacemark(coordinate: center, addressDictionary: nil)
        let item = MKMapItem(placemark: place)
        item.name = "Session"
        item.openInMaps(launchOptions: opts)
    }
    
    @objc func showMessage(){
        let chatVC = ChatLogVC(collectionViewLayout: UICollectionViewFlowLayout())
        let navController = UINavigationController(rootViewController: chatVC)
        
        chatVC.toUser = toChatUser
        chatVC.curr = fromChatUser
 
        print("From chat user (current user) ", fromChatUser?.name)
        print("To char user (recipient) ", toChatUser?.name)

        present(navController, animated: true, completion: nil)
    }
    
    @objc func goBack(){
        dismiss(animated: true, completion: nil)
    }
}
