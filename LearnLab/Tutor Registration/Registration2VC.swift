//
//  Registration2VC.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 6/9/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit
import Firebase

class Registration2VC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    var ref : DatabaseReference?
    var fstore : Firestore!
    var filteredData = [Course]()
    var data = [Course]()
    var selectedCourses = [String]()

    
    let doneButton : UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
        return button
    }()
    
    let pickClasses : UILabel = {
        let label = UILabel()
        label.text = "What clases or subjects can you tutor?"
        return label
    }()
    
    let topView : UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bottomView : UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let classesTableViews : UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    lazy var searchTF : UITextField =  {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        tf.delegate = self
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        ref = Database.database().reference()
        fstore = Firestore.firestore()

        self.view.addSubview(topView)
        self.view.addSubview(bottomView)
        self.view.addSubview(classesTableViews)
        
        setupTopView()
        setupBottomView()
        setupDoneButton()
        setupTableViews()
        
        classesTableViews.delegate = self
        classesTableViews.dataSource = self
        classesTableViews.register(ClassInfoCell.self, forCellReuseIdentifier: "cellId")
    }
    
    func setupDoneButton(){
        doneButton.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -10).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -10).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupTopView(){
        topView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        topView.addSubview(searchTF)
        searchTF.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchTF.topAnchor.constraint(equalTo: topView.topAnchor, constant: 50).isActive = true
        searchTF.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        searchTF.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupBottomView(){
        bottomView.addSubview(doneButton)
        bottomView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        bottomView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func setupTableViews(){
        classesTableViews.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        classesTableViews.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        classesTableViews.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        classesTableViews.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        
        classesTableViews.allowsMultipleSelection = true
    }
    
    @objc func donePressed(){ //upload list of classes they picked
        //
        
        let selected_indexPaths = classesTableViews.indexPathsForSelectedRows
        
        if selected_indexPaths!.count < 1{
            for indexPath in selected_indexPaths! {
                selectedCourses.append(filteredData[indexPath.row].dbId!)
            }
        }
        
        
//        ref?.child("user").child(Auth.auth().currentUser!.uid).updateChildValues(["classes" : selectedCourses])
        
        //need to fix this so tab bar comes up
        let prof = tab4()
        prof.navigationItem.setHidesBackButton(true, animated: false)
        self.present(prof, animated: false)

//        prof.nva«setHidesBackButton(true, animated:false);
//        dismiss(animated: true, completion: nil)
//        dismiss(animated: true, completion: nil)

    }
    
    @objc func textFieldDidChange(){
        let textSearched = searchTF.text
        if (textSearched!.isEmpty){
            filteredData = data
            classesTableViews.reloadData()
        }
        else{
            pullCourses(textSearched!.uppercased())
            classesTableViews.reloadData()
        }
    }

    func pullCourses(_ text : String){
        fstore?.collection("courses").whereField("department", isEqualTo: text).getDocuments(completion: { (snapshot, error) in
            for doc in snapshot!.documents{
                if let dictionary = doc.data() as? [String:String]{
                    let course = Course()
                    course.code = dictionary["code"]
                    course.school = dictionary["school"]
                    course.department = dictionary["department"]
                    course.title = dictionary["title"]
                    course.dbId = doc.documentID
                    self.filteredData.append(course)
                }
            }
            self.filteredData.sort(by: { (m1, m2) -> Bool in
                return (m1.code)! < (m2.code)!
            })
            DispatchQueue.main.async { self.classesTableViews.reloadData() }
        })
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ClassInfoCell
        
        let course = filteredData[indexPath.row]
        
        cell.selectionStyle = .blue
        cell.textLabel?.text = course.department! + " " + course.code!
        cell.detailTextLabel?.text = course.title!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = UITableViewCell.AccessoryType.none
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
