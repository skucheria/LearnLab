//
//  MenuVC.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 8/24/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit

class MenuVC: UIViewController {

    lazy var cancelButton : UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "cancel")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var profileButton : UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showProfile), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setupViews()

        // Do any additional setup after loading the view.
    }
    
    func setupViews(){
        self.view.addSubview(cancelButton)
        self.view.addSubview(profileButton)
        
        cancelButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        
        profileButton.leftAnchor.constraint(equalTo: cancelButton.leftAnchor, constant: 5).isActive = true
        profileButton.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 45).isActive = true
    }
    
    @objc func cancelPressed(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func showProfile(){
        let prof = UINavigationController(rootViewController: ProfileVC())
        present(prof, animated: true, completion: nil)
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
