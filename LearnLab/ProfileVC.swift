//
//  ProfileVC.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 5/25/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit


class ProfileVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    let topView : UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Sensei")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    let name : UILabel = {
        let name = UILabel()
        name.text = "FirstName LastName"
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    let options : UITableView = {
        let options = UITableView()
        options.translatesAutoresizingMaskIntoConstraints = false
        return options
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ProfileVC"
        self.view.backgroundColor = .white
        self.view.isUserInteractionEnabled = true
        view.addSubview(options)

        setupTopView()
        setupTableView()
        
        options.delegate = self
        options.dataSource = self
        options.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")

    }
    
    func setupTopView(){
        
        view.addSubview(topView)
        view.addSubview(profileImageView)
        view.addSubview(name)
        
        //constraints x,y,w,h
        let barHeight = 2 *  (self.navigationController?.navigationBar.frame.height)!
        topView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topView.topAnchor.constraint(equalTo: view.topAnchor, constant: barHeight).isActive = true
        topView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        profileImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -25).isActive = true
        profileImageView.topAnchor.constraint(equalTo: topView.topAnchor, constant: 50).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        name.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        name.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10).isActive = true
        name.widthAnchor.constraint(equalToConstant: 50)
        name.heightAnchor.constraint(equalToConstant: 20)
        
    }
    
    func setupTableView(){
//        view.addSubview(options)
        options.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        options.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        options.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        options.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = "Cell"
        
        
        return cell
    }
    
    

   

}
