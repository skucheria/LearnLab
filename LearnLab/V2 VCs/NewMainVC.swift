//
//  NewMainVC.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 1/30/20.
//  Copyright © 2020 Siddharth Kucheria. All rights reserved.
//

import UIKit

class NewMainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var messagesVC : UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 31/255, green: 9/255, blue: 87/255, alpha: 1)
        
        addSubviews()
        setupSubviews()
        configureMessagesVC()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if( sessionSegment.titleForSegment(at: sessionSegment.selectedSegmentIndex) == "Current"){
            if section == 0{
                return "Pending"
            }
            return "Upcoming"
        }
        return "Past Sessions"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if( sessionSegment.titleForSegment(at: sessionSegment.selectedSegmentIndex) == "Current"){
            if section == 0{
                return 2 //pending cells
            }
            return 2 //upcoming cells
        }
        return 2 //past cells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID")!
        cell.textLabel?.text = "Cell"
        return cell
    }
    
    // MARK: - UI Elements
    
    let mainLabel : UILabel = {
        let mainLabel = UILabel()
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.font = UIFont.boldSystemFont(ofSize: 24.0)
        mainLabel.textColor = .white
        mainLabel.text = "LearnLab"
        return mainLabel
    }()
    
    lazy var profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 125/2
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    let nameLabel : UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.boldSystemFont(ofSize: 36.0)
        nameLabel.text = "Hey, Sid!"
        nameLabel.textColor = .white
        return nameLabel
    }()
    
    lazy var menuButton : UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "menu")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
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
    
    let sessionsLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Sessions"
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let sessionSegment : UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Current", "Past"])
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.tintColor = .white
        segment.selectedSegmentIndex = 0
//        segment.addTarget(self, action: #selector(segChanged), for: .valueChanged )
        segment.isUserInteractionEnabled = true
        return segment
    }()
    
    let sessionsTV : UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.layer.cornerRadius = 5
        tv.layer.masksToBounds = true
        return tv
    }()
    
    let bookButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 245/255, green: 166/255, blue: 25/255, alpha: 1)
        button.setTitle("Book Session", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
//        button.addTarget(self, action: #selector(showSearch), for: .touchUpInside)
        return button
    }()

}
