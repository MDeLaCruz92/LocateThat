//
//  ViewController.swift
//  LocateThat
//
//  Created by Michael De La Cruz on 1/20/17.
//  Copyright © 2017 Michael De La Cruz. All rights reserved.
//

import UIKit

class LocateVC: UIViewController {
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  
  var locateResults: [LocateResult] = []
  var hasSearched = false

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = 80
    tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
    
    var cellNib = UINib(nibName: TableViewCellIdentifiers.locateResultCell, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.locateResultCell)
    
    cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
  }
  
  struct TableViewCellIdentifiers {
    static let locateResultCell = "LocateResultCell"
    static let nothingFoundCell = "NothingFoundCell"
  }
  

  

}

