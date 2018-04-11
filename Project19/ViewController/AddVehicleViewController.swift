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
    var vehiclePhoto: UIImage?
    let imagePicker = UIImagePickerController()
    
    
    @IBOutlet weak var vehicleImage: UIImageView!
    @IBOutlet weak var carNameTextField: UITextField!
    @IBOutlet weak var passengerSeatsPicker: UIPickerView!
    var passengerSeatCount: Int = 1
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable( .camera) {
            imagePicker.sourceType = .camera
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOnVehicleImage))
        vehicleImage.isUserInteractionEnabled = true
        vehicleImage.addGestureRecognizer(tapGestureRecognizer)

        let tapGestureRecognizerForView = UITapGestureRecognizer(target: self, action: #selector(handleTapOnView))
        view.addGestureRecognizer(tapGestureRecognizerForView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        passengerSeatsPicker.selectRow(2, inComponent: 0, animated: false)
        passengerSeatCount = 3
    }
    
    //MARK: - IBAction
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        if checkFields() {
            if let carName = carNameTextField.text {
                let newCar = Car(name: carName, passengerSeatsCount: passengerSeatCount)
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

    //MARK: - Tap selectors
    @objc func handleTapOnVehicleImage() {
        present(imagePicker, animated: true, completion: nil)
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
        return Constants.maxAllowedPassengerSeatCount
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row + 1)
    }
    
    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        passengerSeatCount = row + 1
        print(passengerSeatCount)
    }
    
    // MARK: - Check Fields
    private func checkFields() -> Bool {
        //TODO: better cheking.
        if vehiclePhoto == nil || (carNameTextField.text?.isEmpty)!{
            return false
            } else {
            return true
        }
    }
}


