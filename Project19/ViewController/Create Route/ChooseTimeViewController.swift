//
//  ChooseTimeViewController.swift
//  Project19
//
//  Created by Mykhailo Tymchyshyn on 4/2/18.
//  Copyright © 2018 Mykhailo Tymchyshyn. All rights reserved.
//

import UIKit

class ChooseTimeViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.minimumDate = Date()
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        self.view.insertSubview(blurEffectView, at: 0)
    }

    @IBAction func setTime(_ sender: UIButton) {
        //TODO: set route time from date picker and perform segue to seat picker.
        //10800 as displacement for timezone.
        let time = datePicker.date.addingTimeInterval(10800)
        print(time)
        
        presentingViewController?.dismiss(animated: false, completion: nil)
        guard let navController = presentingViewController as? UINavigationController else {
            fatalError("presenting ViewController is not a UINavigationController.")
        }
        guard let createRouteViewController = navController.viewControllers[1] as? CreateRouteViewController else {
            fatalError("First controller in naviagtion stack is not a CreateRouteViewController.")
        }
        createRouteViewController.setRouteTime(date: time)
        createRouteViewController.presentPickSeatsViewController()
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
