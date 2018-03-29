//
//  SignUpTableViewController.swift
//  Project19
//
//  Created by Mykhailo Tymchyshyn on 3/21/18.
//  Copyright © 2018 Mykhailo Tymchyshyn. All rights reserved.
//

import UIKit

class SignUpTableViewController: UITableViewController {

   
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
        aboutTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        aboutTextView.layer.cornerRadius = 8
    }
}
