//
//  CategoryTableViewController.swift
//  venue
//
//  Created by Dmitriy Butin on 26.05.2020.
//  Copyright © 2020 Dmitriy Butin. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    
    var presenter: CategoryTableViewPresenterProtocol!
    var addMarkerView: AddMarkerScreenProtocol?
    let categoryArray = DataService.shared.categoryArray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellReuseIdentifier: "CategoryCell")
        tableView.backgroundColor = ConfigUI.shared.greenVenue
        tableView.sectionHeaderHeight = 40
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerText = UILabel()
        headerText.textColor = .label
        headerText.font = .boldSystemFont(ofSize: 20)
        headerText.text = "Укажите подходящую категорию"
        headerText.adjustsFontSizeToFitWidth = true
        headerText.textAlignment = .center
        return headerText
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)

        cell.categoryLabel.text = categoryArray[indexPath.row].0
        cell.categoryImage.image = UIImage(named: categoryArray[indexPath.row].1)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categoryArray[indexPath.row].0
        let imageName = categoryArray[indexPath.row].1
        DataService.shared.categoryEvent = (category, imageName)
        addMarkerView?.setCategory(name: category, imageName: imageName)
        self.dismiss(animated: true)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */


    
}


extension CategoryTableViewController: CategoryTableViewProtocol {
    
}
