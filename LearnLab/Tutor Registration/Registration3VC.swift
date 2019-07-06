//
//  Registration3VC.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 7/5/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit

class Registration3VC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "What courses can you tutor? Select any course or subject you have taken and mastereds"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    let addButton : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Select courses", for: .normal)
        return button
    }()
    
    let addSeparator : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let classesTable : UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
        setupConstraints()
        classesTable.delegate = self
        classesTable.dataSource = self
        classesTable.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
    }
    
    func setupConstraints(){
        self.view.addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        
        self.view.addSubview(addButton)
        addButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15).isActive = true
//        addButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        addButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15).isActive = true
        
        self.view.addSubview(addSeparator)
        addSeparator.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        addSeparator.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        addSeparator.topAnchor.constraint(equalTo: addButton.bottomAnchor).isActive = true
        addSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.view.addSubview(classesTable)
        classesTable.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        classesTable.topAnchor.constraint(equalTo: addSeparator.bottomAnchor, constant: 5).isActive = true
        classesTable.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        classesTable.heightAnchor.constraint(greaterThanOrEqualToConstant: 150).isActive = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = "Text"
        return cell
    }
}
