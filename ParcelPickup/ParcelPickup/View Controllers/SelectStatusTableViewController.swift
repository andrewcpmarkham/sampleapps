//
//  SelectStatusTableViewController.swift
//  ParcelPickup
//
//  Created by Andrew CP Markham on 24/7/20.
//  Copyright © 2020 Xercise Pro. All rights reserved.
//

import UIKit

protocol SelectStatusTableViewControllerDelegate:class {
    func didSelectStatus(status: Status)
}

class SelectStatusTableViewController: UITableViewController {

    //Properties
    var status: Status?
    weak var delegate: SelectStatusTableViewControllerDelegate?
    
    //Event Actions
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //Table View Overrides
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return PropertyKeys.statusSelectionViewSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Status.all.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.cellStatusCell, for: indexPath)

        let status = Status.all[indexPath.row]
        //Feedback: Setup Cell in Cell controller -> Pass the model to the CellVC to keep this clean
        //Response - hadn't implemented an custome cell here? Do we always override the cells?
        cell.textLabel?.text = status.description()
        
        if status == self.status{
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        status = Status.all[indexPath.row]
        delegate?.didSelectStatus(status: status!)
    }
}
