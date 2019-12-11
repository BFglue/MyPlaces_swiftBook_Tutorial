//
//  NewPlaceTableViewController.swift
//  MyPlaces
//
//  Created by Дмитрий Березин on 11/12/2019.
//  Copyright © 2019 Dmitry Berezin. All rights reserved.
//

import UIKit

class NewPlaceTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()

    }
    
    // MARK: Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
             
        } else {
            view.endEditing(true)
        }
    }
}

//MARK: Text field delegate

extension NewPlaceTableViewController: UITextFieldDelegate {
    // Скрываем клавиатуру по нажатию Done

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


