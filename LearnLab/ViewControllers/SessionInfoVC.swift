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
            // set all labels
//            var timeStamp = "TIME"
//            var date = NSDate(timeIntervalSince1970: (currentSession?.startTime!.doubleValue)!)
//            let format = DateFormatter()
//            format.dateFormat = "MMMM d, h:mm a"
//            timeStamp = format.string(from: date as Date)
//            self.timeInput.text = timeStamp
//            date = NSDate(timeIntervalSince1970: (currentSession?.endTime!.doubleValue)!)
//            format.dateFormat = "MMMM d, h:mm a"
//            timeStamp = format.string(from: date as Date)
//            self.durationInput.text = timeStamp
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
    
    let dateTextField : UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 10
        tf.placeholder = "Enter date and time"
        tf.layer.borderColor = UIColor.red.cgColor
        tf.layer.borderWidth = 2
        tf.layer.masksToBounds = false
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textColor = .white
        tf.isUserInteractionEnabled = false
        return tf
    }()
    
    let datePicker : UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = UIDatePicker.Mode.dateAndTime
        return picker
    }()
    
    let durationPicker : UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = UIDatePicker.Mode.countDownTimer
        picker.minuteInterval = 15
        return picker
    }()
    
    let toolbar : UIToolbar = {
        let bar = UIToolbar()
        bar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        bar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        return bar
    }()
    
    let toolbar2 : UIToolbar = {
        let bar = UIToolbar()
        bar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDurPicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDurPicker));
        bar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        return bar
    }()
    
    let optionsTV : UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let topSeparator : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let timeInput : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .clear
//        tf.placeholder = "Pick date and time of session"
        tf.textColor = .white
        tf.isUserInteractionEnabled = false
        return tf
    }()
    
    let timeSeparator : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let durationInput : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .clear
//        tf.placeholder = "How long do you want the session?"
        tf.textColor = .white
        tf.isUserInteractionEnabled = false
        return tf
    }()
    
    let durationSeparator : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let locationInput : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .clear
        tf.placeholder = "Where will the session be?"
        return tf
    }()
    
    let locationButton  : UIButton = {
        let button = UIButton()
        button.setTitle("See location", for: .normal)
        //        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = .clear
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(selectLocation), for: .touchUpInside)
        return button
    }()
    
    let locationSeparator : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .white
        self.view.backgroundColor = UIColor(red: 31/255, green: 9/255, blue: 87/255, alpha: 1)
//        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.navigationBar.barStyle = .black
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleCancel))
        msgTutor = getUserForUID(tutorId!)
//        curr = getUserForUID(Auth.auth().currentUser!.uid)
        setupComponents()
        setupMap()

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
        self.view.addSubview(infoLabel)
        infoLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        infoLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        infoLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.view.addSubview(detailsLabel)
        detailsLabel.leftAnchor.constraint(equalTo: infoLabel.leftAnchor).isActive = true
        detailsLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 10).isActive = true
        detailsLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
//        self.view.addSubview(topSeparator)
//        topSeparator.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        topSeparator.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        topSeparator.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 10).isActive = true
//        topSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
//        self.view.addSubview(timeInput)
//        timeInput.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
//        timeInput.topAnchor.constraint(equalTo: topSeparator.bottomAnchor).isActive = true
//        timeInput.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
//        timeInput.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        timeInput.inputView = datePicker
//        timeInput.inputAccessoryView = toolbar
//        self.view.addSubview(timeSeparator)
//        timeSeparator.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        timeSeparator.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        timeSeparator.topAnchor.constraint(equalTo: timeInput.bottomAnchor).isActive = true
//        timeSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
//        self.view.addSubview(durationInput)
//        durationInput.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
//        durationInput.topAnchor.constraint(equalTo: timeSeparator.bottomAnchor).isActive = true
//        durationInput.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
//        durationInput.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        durationInput.inputView = durationPicker
//        durationInput.inputAccessoryView = toolbar2
//        self.view.addSubview(durationSeparator)
//        durationSeparator.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        durationSeparator.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        durationSeparator.topAnchor.constraint(equalTo: durationInput.bottomAnchor).isActive = true
//        durationSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
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
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, h:mm a"
        timeInput.text = formatter.string(from: datePicker.date)
        time = (datePicker.date.timeIntervalSince1970 as AnyObject as! NSNumber)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    @objc func doneDurPicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "h m"
        let helper = formatter.string(from: durationPicker.date)
        let timeArr = helper.components(separatedBy: " ")
        durationInput.text = timeArr[0] + " hour(s) " + timeArr[1] + " minute(s)"
        dur = durationPicker.countDownDuration as NSNumber
        self.view.endEditing(true)
    }
    
    @objc func cancelDurPicker(){
        self.view.endEditing(true)
    }

    @objc func selectLocation(){
        let locationVC = LocationInfoVC()
        locationVC.long = currentSession?.long
        locationVC.lat = currentSession?.lat
        let navController = UINavigationController(rootViewController: locationVC)
        self.navigationController?.present(navController, animated: true, completion: nil)
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
        chatVC.toUser = msgTutor
        chatVC.curr = self.curr
 
        print("tutor ", tutorId)
        print("student ", curr!.id)
        print("current uid: ", Auth.auth().currentUser!.uid)
        present(navController, animated: true, completion: nil)
    }
}
