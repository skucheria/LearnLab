//
//  Registration2VC.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 6/9/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit
import Firebase

class Registration2VC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var ref : DatabaseReference?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        ref = Database.database().reference()
        
        self.view.addSubview(topView)
        self.view.addSubview(bottomView)
        self.view.addSubview(classesTableViews)
        
        setupTopView()
        setupBottomView()
        setupDoneButton()
        setupTableViews()
        
        classesTableViews.delegate = self
        classesTableViews.dataSource = self
        classesTableViews.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        // Do any additional setup after loading the view.
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
//        classesTableViews.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        classesTableViews.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
    }
    
    @objc func donePressed(){ //upload list of classes they picked
        //
        
        // dismiss the view
        dismiss(animated: true, completion: nil)
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.selectionStyle = .blue
//        cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        cell.textLabel?.text = "cell " + String(indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
