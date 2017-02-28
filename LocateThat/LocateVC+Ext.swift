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
    locate.performSearch(for: searchBar.text!,
                         category: segmentedControl.selectedSegmentIndex,
                         completion: { success in
      if !success {
        self.showNetworkError()
      }
      self.tableView.reloadData()
    })
    
    tableView.reloadData()
    searchBar.resignFirstResponder()
  }
  
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
}

extension LocateVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if locate.isLoading {
      return 1
    } else if !locate.hasLocated {
      return 0
    } else if locate.locateResults.count == 0 {
      return 1
    } else {
      return locate.locateResults.count
    }
  }
}

extension LocateVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if locate.isLoading {
      let cell = tableView.dequeueReusableCell(withIdentifier:
        TableViewCellIdentifiers.loadingCell, for: indexPath)
      
      let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
      spinner.startAnimating()
      return cell
    } else if locate.locateResults.count == 0 {
      return tableView.dequeueReusableCell(withIdentifier:
        TableViewCellIdentifiers.nothingFoundCell, for: indexPath)
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier:
        TableViewCellIdentifiers.locateResultCell, for: indexPath) as! LocateResultCell
      
      let locateResult = locate.locateResults[indexPath.row]
      cell.configure(for: locateResult)
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    performSegue(withIdentifier: "ShowDetail", sender: indexPath)
  }
  
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    if locate.locateResults.count == 0 || locate.isLoading {
      return nil
    } else {
      return indexPath
    }
  }
}

