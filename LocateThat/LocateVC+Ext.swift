//
//  LocateVC+Ext.swift
//  LocateThat
//
//  Created by Michael De La Cruz on 1/21/17.
//  Copyright © 2017 Michael De La Cruz. All rights reserved.
//

import UIKit

extension LocateVC: UISearchBarDelegate {
  func performSearch() {
    if let category = Locate.Category(rawValue: segmentedControl.selectedSegmentIndex) {
      locate.performSearch(for: searchBar.text!, category: category,
                           completion: { success in
      if !success {
        self.showNetworkError()
      }
      self.tableView.reloadData()
    })
    
    tableView.reloadData()
    self.landscapeVC?.locateResultsReceived()
    searchBar.resignFirstResponder()
  }
}
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
}

extension LocateVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch locate.state {
    case .notLocatedYet:
      return 0
    case .loading:
      return 1
    case .noResults:
      return 1
    case .results(let list):
      return list.count
    }
  }
}

extension LocateVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch locate.state {
    case .notLocatedYet:
      fatalError("Should never get here")
      
    case .loading:
      let cell = tableView.dequeueReusableCell(withIdentifier:
        TableViewCellIdentifiers.loadingCell, for: indexPath)
      
      let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
      spinner.startAnimating()
      return cell
    case .noResults:
      return tableView.dequeueReusableCell(withIdentifier:
        TableViewCellIdentifiers.nothingFoundCell, for: indexPath)
      
    case .results(let list):
      let cell = tableView.dequeueReusableCell(withIdentifier:
        TableViewCellIdentifiers.locateResultCell, for: indexPath) as! LocateResultCell
      
      let locateResult = list[indexPath.row]
      cell.configure(for: locateResult)
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    performSegue(withIdentifier: "ShowDetail", sender: indexPath)
  }
  
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    switch locate.state {
    case .notLocatedYet, .loading, .noResults:
      return nil
    case .results:
      return indexPath
    }
  }
}

