//
//  AddVehicleViewController.swift
//  Project19
//
//  Created by Mykhailo Tymchyshyn on 3/19/18.
//  Copyright © 2018 Mykhailo Tymchyshyn. All rights reserved.
//

import UIKit

class AddVehicleViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var user: User!
    var vehiclePhoto: UIImage?
    let imagePicker = UIImagePickerController()
    
    
    @IBOutlet weak var vehicleImage: UIImageView!
    @IBOutlet weak var carNameTextField: UITextField!
    
    @IBOutlet weak var passengerSeatCountLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    var alertContorller: UIAlertController!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        stepperSetup()
        
        alertContorller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertContorller.addAction(UIAlertAction(title: "Take Photo", style: .default) {
            [unowned self]
            alertAction in
            if UIImagePickerController.isSourceTypeAvailable( .camera) {
                self.imagePicker.sourceType = .camera
            }
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        alertContorller.addAction(UIAlertAction(title: "Choose from Library", style: .default) {
            [unowned self]
            alertAction in
            if UIImagePickerController.isSourceTypeAvailable( .photoLibrary ) {
                self.imagePicker.sourceType = .photoLibrary
            }
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        alertContorller.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
    }
    
    //MARK: - IBAction
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        if checkFields() {
            if let carName = carNameTextField.text {
                let newCar = Car(name: carName, passengerSeatsCount: Int(stepper.value))
                newCar.setCarPhoto(photo: vehiclePhoto!)
                user.addCar(car: newCar)
                if let presenter = (presentingViewController as? UINavigationController)?.viewControllers[1] as? UserDetailsTableViewController {
                    presenter.tableView.reloadData()
                }
                presentingViewController?.dismiss(animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Incomplete car info.", message: "Please set image and name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        vehicleImage.image = pickedImage
        vehicleImage.contentMode = .scaleAspectFit
        vehiclePhoto = pickedImage
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Check Fields
    private func checkFields() -> Bool {
        if vehiclePhoto == nil || (carNameTextField.text?.isEmpty)!{
            return false
        } else {
        return true
        }
    }
    // MARK: - UIGestureRecognizer
    @IBAction func handleTapOnVehicleImage(_ sender: UITapGestureRecognizer) {
        present(alertContorller, animated: true, completion: nil)
    }
   
    @IBAction func handleTapOnView(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - UIStepper
    func stepperSetup() {
        stepper.maximumValue = Double(Constants.maxAllowedPassengerSeatCount)
        passengerSeatCountLabel.text = String(Int(stepper.value))
    }
   
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        passengerSeatCountLabel.text = String(Int(stepper.value))
    }
        
}


