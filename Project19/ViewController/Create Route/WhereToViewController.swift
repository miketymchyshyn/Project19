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

let defaultFieldSpacing: CGFloat = 8
let defaultFieldHeight: CGFloat = 30

class WhereToViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    var currentMapRegion: MKCoordinateRegion!
    
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var whereToField: UITextField!
    @IBOutlet weak var fromWhereField: UITextField!
    @IBOutlet weak var addStopStackView: UIStackView!
    
    @IBOutlet weak var addStopField: UITextField!
    @IBOutlet weak var spacingBetweenFromWhereAndWhereTo: NSLayoutConstraint!
    @IBOutlet weak var addStopButtonOutlet: UIButton!
    @IBOutlet weak var deleteStopButtonOutlet: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addStopButton(_ sender: UIButton) {
        spacingBetweenFromWhereAndWhereTo.constant = defaultFieldSpacing + defaultFieldHeight + defaultFieldSpacing
        
        addStopStackView.isHidden = false
        addStopButtonOutlet.isHidden = true
        topViewHeightConstraint.constant = topViewHeightConstraint.constant + (defaultFieldSpacing + defaultFieldHeight)
        deleteStopButtonOutlet.transform = CGAffineTransform(rotationAngle: 45 * CGFloat.pi/180)
        addStopField.becomeFirstResponder()
    }
    
    @IBAction func deleteStopButton(_ sender: UIButton) {
        spacingBetweenFromWhereAndWhereTo.constant = defaultFieldSpacing
        addStopStackView.isHidden = true
        addStopButtonOutlet.isHidden = false
        path.stop = nil
        path.stopLocationDescription = nil
        topViewHeightConstraint.constant = topViewHeightConstraint.constant - (defaultFieldSpacing + defaultFieldHeight)
        deleteStopButtonOutlet.transform = CGAffineTransform(rotationAngle: 45 * CGFloat.pi/180)
    }

    //map items that are displayed while you type in locaion name.
    private var requsetRelatedMapItems = [MKMapItem]()
    private var path = Path()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeGestureRecognizer.direction = .down
        topView.addGestureRecognizer(swipeGestureRecognizer)
        
        whereToField.becomeFirstResponder()
        whereToField.delegate = self
        fromWhereField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        addStopField.delegate = self
        
        spacingBetweenFromWhereAndWhereTo.constant = defaultFieldSpacing
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        self.view.insertSubview(blurEffectView, at: 0)
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        if whereToField.isFirstResponder {
            //TODO: uncommert this line when debuggin full scenario of route creation.
            if let presentingNavVC = presentingViewController as? UINavigationController {
                if let presentingVC = presentingNavVC.viewControllers.last as? CreateRouteViewController {
                    //            if let presentingVC = presentingViewController as? CreateRouteViewController {
                    
                    //create and show route
                    path.destination = requsetRelatedMapItems[indexPath.row].placemark.coordinate
                    path.destinationLocationDescription = requsetRelatedMapItems[indexPath.row].name
                    
                    presentingVC.showRouteOnMap(path: path)
                    presentingVC.whereToView.isHidden = true
                    //enable cancel button
                    presentingVC.navigationItem.rightBarButtonItem?.isEnabled = true
                    
                    //dismiss route picking controller
                    presentingVC.dismiss(animated: false, completion: nil)
                    presentingVC.presentChooseTimeViewController()
                }
            }
        } else if fromWhereField.isFirstResponder {
            path.from = requsetRelatedMapItems[indexPath.row].placemark.coordinate
            path.fromLocationDescription = requsetRelatedMapItems[indexPath.row].name
            fromWhereField.text = requsetRelatedMapItems[indexPath.row].name
            
        } else if addStopField.isFirstResponder {
            path.stop = requsetRelatedMapItems[indexPath.row].placemark.coordinate
            path.stopLocationDescription = requsetRelatedMapItems[indexPath.row].name
            addStopField.text = requsetRelatedMapItems[indexPath.row].name
        }
    }
    
    // MARK: HandleSwipe
    @objc
    private func handleSwipe(_ gestureRecognizer: UISwipeGestureRecognizer){
        if gestureRecognizer.state == .ended {
            whereToField.resignFirstResponder()
            presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }

}
