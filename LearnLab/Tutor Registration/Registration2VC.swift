//
//  Registration2VC.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 6/9/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit
import Firebase

class Registration2VC: UIViewController {

    var ref : DatabaseReference?
    
    let doneButton : UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        ref = Database.database().reference()
        
        self.view.addSubview(doneButton)
        setupDoneButton()
        
        // Do any additional setup after loading the view.
    }
    
    func setupDoneButton(){
        doneButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    @objc func donePressed(){
    
    
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
