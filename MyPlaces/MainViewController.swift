//
//  MainViewController.swift
//  MyPlaces
//
//  Created by Дмитрий Березин on 10/12/2019.
//  Copyright © 2019 Dmitry Berezin. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
        
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var places: Results<Place>!
    private var filteredPlaces: Results<Place>!
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var ascendingSorting = true
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var reversedSortingButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        places = realm.objects(Place.self)
        
        // Setup search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false // allow us to communicate with elements of UI
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true // allow to get free searchbar after move to another screen
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.isEmpty ? 0 : places.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        let place = places[indexPath.row]

        cell.nameLabel?.text = place.name
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        cell.imageOfPlace.image = UIImage(data: place.imageData!)

        cell.imageOfPlace?.layer.cornerRadius = cell.imageOfPlace.frame.size.height / 2
        cell.imageOfPlace?.clipsToBounds = true

        return cell
    }
    
    // MARK: Table view delegate
//    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let place = places[indexPath.row]
//        let deletAction = UITableViewRowAction(style: .default, title: "Delete") { (_, _) in
//            StorageManager.deleteObject(place)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        }
//
//        return [deletAction]
//    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let place = places[indexPath.row]
        let deletAction = UIContextualAction(style: .destructive,
                                             title: "Delete",
                                             handler: { (_, _, _) in
                                                StorageManager.deleteObject(place)
                                                tableView.deleteRows(at: [indexPath], with: .automatic)
        })
        let editAction = UIContextualAction(style: .normal,
                                             title: "Edit",
                                             handler: { (_, _, _) in
                                                StorageManager.deleteObject(place)
                                                tableView.deleteRows(at: [indexPath], with: .automatic)
        })
        let configuration = UISwipeActionsConfiguration(actions: [deletAction, editAction])
        return configuration
    }
    


    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let place = places[indexPath.row]
            let newPlaceVC = segue.destination as! NewPlaceTableViewController
            newPlaceVC.currentPlace = place
        }
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard let newPlaceVC = segue.source as? NewPlaceTableViewController else { return }
        newPlaceVC.savePlace()
        tableView.reloadData()
    }
    
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
        sorting()
    }
    
    @IBAction func reversedSorting(_ sender: Any) {
        ascendingSorting.toggle()
        
        if ascendingSorting {
            reversedSortingButton.image = #imageLiteral(resourceName: "AZ")
        } else {
            reversedSortingButton.image = #imageLiteral(resourceName: "ZA")
        }
        
        sorting()
        
    }
    
    private func sorting() {
        if segmentedControl.selectedSegmentIndex == 0 {
            places = places.sorted(byKeyPath: "date", ascending: ascendingSorting)
        } else {
            places = places.sorted(byKeyPath: "name", ascending: ascendingSorting)
        }
        
        tableView.reloadData()
    }
    
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
//        filterContentForSearchText(searchController.searchBar.text!)
    }

//    private func filterContentForSearchText (_ searchText: String) {
//        filteredPlaces = places.filter("name CONTAINS[c] %@ OR location CONTAINS[c] %@", searchText, searchText)
//        tableView.reloadData()
//    }
}
