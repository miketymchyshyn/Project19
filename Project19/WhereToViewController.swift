//
//  WhereToViewController.swift
//  Project19
//
//  Created by Mykhailo Tymchyshyn on 3/12/18.
//  Copyright © 2018 Mykhailo Tymchyshyn. All rights reserved.
//

import UIKit
import MapKit

let locationCellIdentifier = "LocationCell"

class WhereToViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var whereToField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var currentMapRegion: MKCoordinateRegion!
    private var requsetRelatedMapItems = [MKMapItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeGestureRecognizer.direction = .down
        topView.addGestureRecognizer(swipeGestureRecognizer)
        whereToField.becomeFirstResponder()
        whereToField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //#incomplete implementation
        return requsetRelatedMapItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: locationCellIdentifier, for: indexPath)
        guard let locationCell = cell as? LocationTableViewCell else {
            fatalError("cell downcast failed.")
        }
        locationCell.locationDescription.text = requsetRelatedMapItems[indexPath.row].name
        locationCell.locationAddress.text = requsetRelatedMapItems[indexPath.row].placemark.title
        return locationCell
    }
    
    // MARK: - TextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let request = MKLocalSearchRequest()
            //TODO: check for non empty
            request.naturalLanguageQuery = textField.text

            // Set the region to an associated map view's region
            request.region = currentMapRegion
            let localSearch = MKLocalSearch(request: request)
            localSearch.start() { [weak self]
                (localSearchResponse, error) in
                if localSearchResponse != nil {
                    self?.requsetRelatedMapItems = localSearchResponse!.mapItems
                    self?.tableView.reloadData()
                }
        }
        return true
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(presentingViewController)
        if let presentingNavVC = presentingViewController as? UINavigationController {
            if let presentingVC = presentingNavVC.viewControllers.last as? CreateRouteViewController {
            //create and show route
            presentingVC.showRouteOnMap(to: requsetRelatedMapItems[indexPath.row].placemark.coordinate)
            
            //hide some views, show some other views
            presentingVC.whereToView.isHidden = true
            presentingVC.timePickerView.isHidden = false
            presentingVC.cancelButton.isHidden = false
            
            //modifi constraints
            presentingVC.MVtoBottom.constant = -161
            
            //dismiss route picking controller
            presentingVC.dismiss(animated: true, completion: nil)
        }
        }
    }
    
    // MARK: HandleSwipe
    @objc
    func handleSwipe(_ gestureRecognizer: UISwipeGestureRecognizer){
        if gestureRecognizer.state == .ended {
            whereToField.resignFirstResponder()
            presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }

}
