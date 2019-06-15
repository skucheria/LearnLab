//
//  SessionsVC.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 6/15/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit
import Firebase

class SessionsVC: UIViewController {

    let sessionSegment : UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Current", "Past"])
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.tintColor = .white
        segment.selectedSegmentIndex = 1
//        segment.addTarget(self, action: #selector(segChanged), for: .valueChanged )
        segment.isUserInteractionEnabled = true
        return segment
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(sessionSegment)
        self.view.backgroundColor = .gray
        self.title = "Sessions"
        setupSegment()
        
        // Do any additional setup after loading the view.
    }
    
    func setupSegment(){
        let barHeight = 2 *  (self.navigationController?.navigationBar.frame.height)!
//        sessionSegment.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        sessionSegment.topAnchor.constraint(equalTo: view.topAnchor, constant: barHeight).isActive = true
        sessionSegment.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sessionSegment.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        sessionSegment.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
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
