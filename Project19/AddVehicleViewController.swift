//
//  AddVehicleViewController.swift
//  Project19
//
//  Created by Mykhailo Tymchyshyn on 3/19/18.
//  Copyright © 2018 Mykhailo Tymchyshyn. All rights reserved.
//

import UIKit

class AddVehicleViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var user: User!
    
    let seats = ["1", "2", "3", "4", "5", "6", "7"]
    var vehiclePhoto: UIImage?
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var vehicleImage: UIImageView!
    @IBOutlet weak var carNameTextField: UITextField!
    @IBOutlet weak var seatsLabel: UILabel!
    @IBOutlet weak var passengerSeatsPicker: UIPickerView!
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
   
    @IBAction func save(_ sender: UIBarButtonItem) {
        //TODO: check if fields are filled correctly.

        if checkFields() {
            if let carName = carNameTextField.text, let seatCountText = seatsLabel.text {
                let seatCount = Int(seatCountText)!
                let newCar = Car(name: carName, passengerSeatsCount: seatCount)
                newCar.setCarPhoto(photo: vehiclePhoto!)
                user.addCar(car: newCar)
                if let presenter = (presentingViewController as? UINavigationController)?.viewControllers[1] as? UserDetailsTableViewController {
                    presenter.tableView.reloadData()
                }
                presentingViewController?.dismiss(animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Incomplete car info.", message: "Please set image, name, and seat count.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                print("alert for incomplete info.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passengerSeatsPicker.dataSource = self
        passengerSeatsPicker.delegate = self
        imagePicker.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOnVehicleImage))
        vehicleImage.isUserInteractionEnabled = true
        vehicleImage.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizerForSeats = UITapGestureRecognizer(target: self, action: #selector(handleTapOnSeatsLabel))
        seatsLabel.isUserInteractionEnabled = true
        seatsLabel.addGestureRecognizer(tapGestureRecognizerForSeats)
        
        let tapGestureRecognizerForView = UITapGestureRecognizer(target: self, action: #selector(handleTapOnView))
        view.addGestureRecognizer(tapGestureRecognizerForView)
        
    }

    //MARK: - Tap selectors
    @objc func handleTapOnVehicleImage() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handleTapOnSeatsLabel() {
        passengerSeatsPicker.isHidden = false
    }
    
    @objc func handleTapOnView() {
        carNameTextField.resignFirstResponder()
    }
    
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        vehicleImage.contentMode = .scaleAspectFit
        vehicleImage.image = pickedImage
        vehiclePhoto = pickedImage
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return seats.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return seats[row]
    }
    
    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        seatsLabel.text = seats[row]
    }
    
    // MARK: - Check Fields
    private func checkFields() -> Bool {
        //TODO: better cheking.
        if vehiclePhoto == nil || (carNameTextField.text?.isEmpty)! || (seatsLabel.text == "Set")  {
            return false
            } else {
            return true
        }
    }
}


