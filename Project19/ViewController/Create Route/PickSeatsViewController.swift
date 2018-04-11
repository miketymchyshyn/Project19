//
//  PickSeatsViewController.swift
//  Project19
//
//  Created by Mykhailo Tymchyshyn on 4/2/18.
//  Copyright © 2018 Mykhailo Tymchyshyn. All rights reserved.
//

import UIKit

class PickSeatsViewController: UIViewController {

    var passengerSeatCount = 1
    var maxPassengerSeatCount: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        self.view.insertSubview(blurEffectView, at: 0)
    }
    
    @IBAction func setSeats(_ sender: UIButton) {
        //TODO: set route max passenger seats to passengerSeatCount peform segue to create route.
        print(passengerSeatCount)
        if let createRouteViewController = (presentingViewController as? UINavigationController)?.viewControllers[1] as? CreateRouteViewController{
            createRouteViewController.setMaxPassengerCount(to: passengerSeatCount)
            createRouteViewController.confirmButton.isHidden = false
        }
        presentingViewController?.dismiss(animated: true, completion: nil)
    }

}

extension PickSeatsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //TODO: set equal to driver's car passenger seat count
        return maxPassengerSeatCount
    }
    
    //MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row + 1)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.passengerSeatCount = row + 1
    }
}
