//
//  PassengersViewController.swift
//  Project19
//
//  Created by Mykhailo Tymchyshyn on 4/10/18.
//  Copyright © 2018 Mykhailo Tymchyshyn. All rights reserved.
//

import UIKit

class PassengersViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleSwipeToHide(_ sender: UISwipeGestureRecognizer) {
        presentingViewController?.dismiss(animated: true, completion: nil)
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
