//
//  ParcelDetailTableViewController.swift
//  ParcelPickup
//
//  Created by Andrew CP Markham on 23/7/20.
//  Copyright © 2020 Xercise Pro. All rights reserved.
//

import UIKit

class ParcelDetailTableViewController: UITableViewController {
    
    //Outlets
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusDateLabel: UILabel!
    @IBOutlet weak var statusDatePickerView: UIDatePicker!
    @IBOutlet weak var trackingNoTextField: UITextField!
    @IBOutlet weak var recipientNameTextField: UITextField!
    @IBOutlet weak var deliveryAddressTextField: UITextField!
    @IBOutlet weak var deliveryDateLabel: UILabel!
    @IBOutlet weak var deliveryDatePickerView: UIDatePicker!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    //Properties
    var parcel: Parcel?
    var status: Status?
    var isStatusDatePickerHidden = true
    var isDeliveryDatePickerHidden = true
    let statusDateLabelIndexPath = IndexPath(row: 1, section: 0)
    let statusDatePickerIndexPath = IndexPath(row: 2, section: 0)
    let deliveryDateLabelIndexPath = IndexPath(row: 3, section: 1)
    let deliveryDatePickerIndexPath = IndexPath(row: 4, section: 1)
    let notesTextViewIndexPath = IndexPath(row: 0, section: 2)
    
    //Event actions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
        updateSaveButtonState()
    }

    //Table View Overrides
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case statusDatePickerIndexPath:
            return isStatusDatePickerHidden ? 0 : statusDatePickerView.frame.height
        case deliveryDatePickerIndexPath:
            return isDeliveryDatePickerHidden ? 0 : deliveryDatePickerView.frame.height
        case notesTextViewIndexPath:
            return notesTextView.frame.height
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == statusDateLabelIndexPath{
            isStatusDatePickerHidden = !isStatusDatePickerHidden
            statusDateLabel.textColor = isStatusDatePickerHidden ? .black: tableView.tintColor
            tableView.beginUpdates()
            tableView.endUpdates()
        }else if indexPath == deliveryDateLabelIndexPath{
            isDeliveryDatePickerHidden = !isDeliveryDatePickerHidden
            deliveryDateLabel.textColor = isDeliveryDatePickerHidden ? .black: tableView.tintColor
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    
    //Functions
    func updateView(){
        ///Function to set all outlets/data points for new parcel
        updateStatus(status: Status.getInitialStatus())
        deliveryDateLabel.text = Status.isNotCompleted()
        
    }
    
    func updateSaveButtonState(){
        ///Function to update the save button state when data is validated
        let name = recipientNameTextField.text ?? ""
        let address = deliveryAddressTextField.text ?? ""
        saveButton.isEnabled = !name.isEmpty && !address.isEmpty
    }
    
    func updateDateLabelFromPicker(datePicker: UIDatePicker, label: UILabel){
        ///Function to update the corresponding label when a date picker is cahnged
        label.text = PropertyKeys.dateFormatter.string(from: datePicker.date)
    }
    
    func updateStatus(status: Status){
        ///Function to update the status view data
        self.status = status
        statusDatePickerView.date = Date()
        datePickerChanged(statusDatePickerView)
        statusLabel.text = status.description()
        if Status.isCompleted(status: status){
            deliveryDatePickerView.date = Date()
            datePickerChanged(deliveryDatePickerView)
        }else{
            //Clear our any delivery data
            datePickerChanged(nil)
        }
    }
    
    //Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == PropertyKeys.segueSelectStatus{
            //Passing refference to self and current status to status views controller
            let destinationViewController = segue.destination as? SelectStatusTableViewController
            destinationViewController?.delegate = self
            destinationViewController?.status = status
        }else if(segue.identifier == PropertyKeys.segueSaveUnwind){
            if let _ = segue.destination as? ParcelTableViewController{
                
                let status = self.status ?? Status.getInitialStatus()
                let statusUpdatedDate = statusDatePickerView.date
                let trackingNo = trackingNoTextField.text ?? nil
                let recipientName = recipientNameTextField.text ?? ""
                let deliveryAddress = deliveryAddressTextField.text ?? ""
                let deliveryDate = deliveryDateLabel.text != Status.isNotCompleted() ?  deliveryDatePickerView.date : nil
                let notes = notesTextView.text
 
                parcel = Parcel(status: status, statusUpdatedDate: statusUpdatedDate, trackingNo: trackingNo, recipientName: recipientName, deliveryAddress: deliveryAddress, deliveryDate: deliveryDate, notes: notes)
            }
        }
    }
    
    //Actions
    @IBAction func textEditingChanged(_ sender: UITextField) {
           updateSaveButtonState()
    }
    
    @IBAction func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker?) {
        guard let sender = sender else {
            parcel?.deliveryDate = nil
            deliveryDateLabel.text = Status.isNotCompleted()
            return
        }
        
        if sender.tag == 0{
            updateDateLabelFromPicker(datePicker: sender, label: statusDateLabel)
        }else if sender.tag == 1{
            updateDateLabelFromPicker(datePicker: sender, label: deliveryDateLabel)
        }
    }
    
    @IBAction func unwindParcelDetail(segue: UIStoryboardSegue){
        // no logic required ATM
    }
}

extension ParcelDetailTableViewController: SelectStatusTableViewControllerDelegate{
    ///Protocol Implementation
    func didSelectStatus(status: Status){
        //Function for when a status is selected/changed
        updateStatus(status: status)
    }
}
