//
//  LoginViewController.swift
//  Project19
//
//  Created by Mykhailo Tymchyshyn on 3/16/18.
//  Copyright © 2018 Mykhailo Tymchyshyn. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
   
    @IBAction func login(_ sender: UIButton) {
        let fieldsCorrect = validate()
        if fieldsCorrect {
            //TODO: do post request to "users/login"
        } else {
            //present alert to user.
            let alert = UIAlertController(title: "Bad password/login", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func singUp(_ sender: UIButton) {
        performSegue(withIdentifier: "SegueToSignUp", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 10
        loginButton.layer.borderWidth = 2
        loginButton.layer.borderColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - Field validation
    private func validate() -> Bool {
        return loginValid() && passwordValid()
    }
    
    private func loginValid() -> Bool {
        if let loginLength = login.text?.count {
            return loginLength > 5
        }
        return false
    }
    
    private func passwordValid() -> Bool {
        if let passwordLength = password.text?.count {
            return passwordLength > 5
        }
        return false
    }
    
    @objc private func dismissKeyboard(){
        view.endEditing(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
