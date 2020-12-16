//
//  ParcelTableViewController.swift
//  ParcelPickup
//
//  Created by Andrew CP Markham on 22/7/20.
//  Copyright © 2020 Xercise Pro. All rights reserved.
//

//REVISIONS
//Folder Structure for grouping files added
//Seperated out ParcelCellDelegate Protocol logic into an extension
//Implemented UUID
//Implemented update function in table cell
//31/7/2020
//direct return to parcel detail when a status is entered
//1/8/2020
//Property Keys sepperated and identified - Sperate File
//Replace logic for header implmentation and use titleForHeaderInSection
//2/8/2020
//Seperate out View for editing from view for creating new parcel
//Updated all logic
//5/8/2020
//Moved sample parcels to it's own model struct warehouse
//Slight modifications to file structure - group delegates, add storyboard to Views and add property keys to Helper Controller group
//added property to property keys
//7/8/2020
//Converted Status Model into Enum implementation


import UIKit

class ParcelTableViewController: UITableViewController {

    //Properties
    //Model Collection
    var parcels: [Parcel] = []
    
    //Event Actions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load data
        if let savedParcels = Parcel.loadParcels(){
            parcels = savedParcels
        }else{
            parcels = Warehouse.getSampleParcels()
        }
        
        //Load Table Header
        tableView.register(ParcelHeader.self, forHeaderFooterViewReuseIdentifier: PropertyKeys.parcelHeaderIdentifier)
    }

    // Table View Overrides
    override func numberOfSections(in tableView: UITableView) -> Int {
        return PropertyKeys.parcelTableViewSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parcels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.parcelCellIdentifier) as? ParcelCell else {fatalError("Could not dequeue parcell cell")}
            
        let parcel = parcels[indexPath.row]
        cell.updateCell(with: parcel)
        cell.delegate = self
            
        return cell

    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
                // Delete the row from the data source
                parcels.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                Parcel.saveParcels(parcels)
           }
       }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return PropertyKeys.parcelTableViewHeaderRowHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: PropertyKeys.parcelHeaderIdentifier) as? ParcelHeader
        header?.updateLabels(name: PropertyKeys.parcelHeaderCollumn1, address: PropertyKeys.parcelHeaderCollumn2, status: PropertyKeys.parcelHeaderCollumn3)
        return header
    }
    
    //Functions
    //Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == PropertyKeys.segueEditParcel, let navController = segue.destination as? UINavigationController, let parcelDetailEditTableViewController = navController.topViewController as? ParcelDetailEditTableViewController{
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedParcel = parcels[indexPath.row]
            parcelDetailEditTableViewController.parcel = selectedParcel
        }else if segue.identifier == PropertyKeys.segueAddParcel {
            //needs to ensure any previously selected row is released
            if let indexPath = tableView.indexPathForSelectedRow{
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    //Actions
    @IBAction func unwindParcelList(segue: UIStoryboardSegue){
        if segue.identifier == PropertyKeys.segueSaveUnwind || segue.identifier == PropertyKeys.segueCancelUnwind {
            //New Parcel Action
            let sourceViewController = segue.source as! ParcelDetailTableViewController
            
            if let parcel = sourceViewController.parcel{
                let newIndexPath = IndexPath(row: parcels.count, section: PropertyKeys.parcelTableViewSections - 1)
                parcels.append(parcel)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }else if segue.identifier == PropertyKeys.segueSaveEditUnwind || segue.identifier == PropertyKeys.segueDeleteUnwind{
            //Edit Parcel Action
            let sourceViewController = segue.source as! ParcelDetailEditTableViewController
            
            if sourceViewController.deleteParcel{
                if let selectedIndexPath = tableView.indexPathForSelectedRow{
                    parcels.remove(at: selectedIndexPath.row)
                    tableView.deleteRows(at: [selectedIndexPath], with: .automatic)
                }
            }else if let parcel = sourceViewController.parcel{
                if let selectedIndexPath = tableView.indexPathForSelectedRow{
                    parcels[selectedIndexPath.row] = parcel
                    //Update Cells Checked Image
                    guard let cell = tableView.cellForRow(at: selectedIndexPath) as? ParcelCell else { return}
                    if parcel.status == Status.getFinalStatus(){
                        cell.isDeliveredButton.setImage(UIImage(systemName: PropertyKeys.imageCheckMark), for: .normal)
                    }else{
                        cell.isDeliveredButton.setImage(UIImage(systemName: PropertyKeys.imageCheckMarkEmpty), for: .normal)
                    }
                    tableView.reloadRows(at: [selectedIndexPath], with: .none)
                }
            }
        }else {return}
    
        
        
        Parcel.saveParcels(parcels)
    }
}


extension ParcelTableViewController: ParcelCellDelegate{
    func checkmarkTapped(sender: ParcelCell) {
        //Cell Protocol function implementation for checking off delivered items
        if let indexPath = tableView.indexPath(for: sender){
            var parcel = parcels[indexPath.row]
            
            //Only action if not delivered
            if parcel.status != Status.getFinalStatus() {
                parcel.status = Status.getFinalStatus()
                parcel.statusUpdatedDate = Date()
                parcel.deliveryDate = parcel.statusUpdatedDate
                parcels[indexPath.row] = parcel
                Parcel.saveParcels(parcels)
                
                
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
}
