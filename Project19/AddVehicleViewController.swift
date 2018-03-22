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
        //TODO: check if fields are filled correctly. Save car for user
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
            print("fields not filled.")
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Tap selectors
    
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
    
    // MARK: - Private Methods
    private func checkFields() -> Bool {
    // TODO: check car info fill fullness
        if vehiclePhoto == nil || (carNameTextField.text?.isEmpty)! {
            return false
            } else {
            return true
        }
    }
}


