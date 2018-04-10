//
//  SignUpTableViewController.swift
//  Project19
//
//  Created by Mykhailo Tymchyshyn on 3/21/18.
//  Copyright © 2018 Mykhailo Tymchyshyn. All rights reserved.
//

import UIKit

class SignUpTableViewController: UITableViewController, UITextViewDelegate {
    let textViewPlaceholderText = "Write something about yourself."
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var aboutTextView: UITextView!
    
    @IBAction func SignUpButton(_ sender: UIButton) {
        //TODO: Input validation. Create new user; form POST requset; Send it to user/signup endpoint; Save token recieved in response.
        performSegue(withIdentifier: "SegueToRoutesFromSignUp", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAboutTextView()
    }
    
    private func setupAboutTextView(){
        aboutTextView.layer.borderWidth = 1
        aboutTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.25).cgColor
        aboutTextView.layer.cornerRadius = 8
        aboutTextView.text = textViewPlaceholderText
        aboutTextView.textColor = UIColor.lightGray
    }
    
    //    MARK: - UITextViewDelegte.
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = textViewPlaceholderText
            textView.textColor = UIColor.lightGray
        }
    }
}

