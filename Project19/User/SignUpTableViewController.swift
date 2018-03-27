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
        //TODO: Input validation.
        //create new user.
        //save his info
        //log in
        //create token for user and save it to userDefaults
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()
        aboutTextView.layer.borderWidth = 1
        aboutTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        aboutTextView.layer.cornerRadius = 8

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    /*
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
