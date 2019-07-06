//
//  Registration1VC.swift
//  LearnLab
//
//  Created by Siddharth Kucheria on 6/8/19.
//  Copyright © 2019 Siddharth Kucheria. All rights reserved.
//

import UIKit
import Firebase

class Registration1VC: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    let bioLabel : UILabel = {
        let label = UILabel()
        label.text = "Create your short bio (between 70 and 125 characters) "
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()

    lazy var bioTV : UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.isScrollEnabled = false
        tv.returnKeyType = .next
        return tv
    }()
    
    let separatorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let availLabel : UILabel = {
        let label = UILabel()
        label.text = "Describe your availability"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    lazy var availTV : UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.isScrollEnabled = false
        tv.returnKeyType = .next
        return tv
    }()
    
    let availSep : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let rateLabel : UILabel = {
        let label = UILabel()
        label.text = "Enter your hourly rate"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()

    lazy var rateTV : UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.isScrollEnabled = false
        tv.returnKeyType = .done
        tv.keyboardType = .decimalPad
        tv.inputAccessoryView = toolbar
        return tv
    }()
    
    let rateSep : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nextButton : UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(nextPressed), for: .touchUpInside)
        return button
    }()
    
    let cancelButton : UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        return button
    }()
    
    let toolbar : UIToolbar = {
        let bar = UIToolbar()
        bar.sizeToFit()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneRate));
        bar.setItems([spaceButton, doneButton], animated: false)
        return bar
    }()
    
    var ref : DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
//        navigationController?.navigationBar.barTintColor = .green
        addSubviews()
        // Do any additional setup after loading the view.
        
        bioTV.delegate = self
        availTV.delegate = self
        ref = Database.database().reference()
        setupBio()
        setupButton()
    }
    
    func addSubviews(){
        self.view.addSubview(bioLabel)
        self.view.addSubview(bioTV)
        self.view.addSubview(nextButton)
        self.view.addSubview(cancelButton)
        self.view.addSubview(separatorView)
        self.view.addSubview(availLabel)
        self.view.addSubview(availTV)
        self.view.addSubview(availSep)
        self.view.addSubview(rateLabel)
        self.view.addSubview(rateTV)
        self.view.addSubview(rateSep)
    }
    
    func setupBio(){
        //setup constraints for bio labe and textfield
        bioLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        bioLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        bioLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        
        bioTV.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        bioTV.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        bioTV.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 5).isActive = true
        
        separatorView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        separatorView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        separatorView.topAnchor.constraint(equalTo: bioTV.bottomAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        availLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        availLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        availLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 20).isActive = true
        
        availTV.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        availTV.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        availTV.topAnchor.constraint(equalTo: availLabel.bottomAnchor, constant: 5).isActive = true
        
        availSep.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        availSep.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        availSep.topAnchor.constraint(equalTo: availTV.bottomAnchor).isActive = true
        availSep.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        rateLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        rateLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        rateLabel.topAnchor.constraint(equalTo: availSep.bottomAnchor, constant: 20).isActive = true
        
        rateTV.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        rateTV.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        rateTV.topAnchor.constraint(equalTo: rateLabel.bottomAnchor, constant: 5).isActive = true
        
        rateSep.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        rateSep.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        rateSep.topAnchor.constraint(equalTo: rateTV.bottomAnchor).isActive = true
        rateSep.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setupButton(){
        nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
//        cancelButton.isEnabled = false
    }
    
    @objc func nextPressed(){
        if bioTV.text!.isEmpty || availTV.text!.isEmpty || rateTV.text!.isEmpty{
            print("add an alertview telling them to finish up fields")
            let alert = UIAlertController(title: "You must enter all fields before continuing", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                case .cancel:
                    print("cancel")
                case .destructive:
                    print("destructive")
                }}))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let reg2 = Registration2VC()
            self.present(reg2, animated: false)
        }
        
        ref?.child("user").child((Auth.auth().currentUser!.uid)).updateChildValues(["bio" : bioTV.text!, "tutor" : "yes", "availability" : availTV.text!, "rate" : rateTV.text!])
    }
    
    @objc func cancelPressed(){
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            if textView == bioTV{
                availTV.becomeFirstResponder()
            }
            else if availTV == textView {
                rateTV.becomeFirstResponder()
            }
//            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    @objc func doneRate(){
        self.view.endEditing(true)
    }
    
}
