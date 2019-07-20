//
//  LocationVC.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 7/19/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit
import MapKit

class LocationVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select Location"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))

        
        let mapView = MKMapView()
        self.view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true

//        let leftMargin:CGFloat = 0
//        let topMargin:CGFloat = 60
//        let mapWidth:CGFloat = view.frame.size.width-20
//        let mapHeight:CGFloat = 300
//        
//        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
//        
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        // Or, if needed, we can position map in the center of the view
        mapView.center = view.center
        
        // Do any additional setup after loading the view.
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
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
