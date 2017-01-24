//
//  LocateVC+Ext.swift
//  LocateThat
//
//  Created by Michael De La Cruz on 1/21/17.
//  Copyright © 2017 Michael De La Cruz. All rights reserved.
//

import UIKit

extension LocateVC: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    locateResults = []
    
    
    if searchBar.text! != "justin bieber" {
      for i in 0...2 {
        let locateResult = LocateResult()
        locateResult.name = String(format: "Fake Result %d for", i)
        locateResult.artistName = searchBar.text!
        locateResults.append(locateResult)
      }
      
      hasSearched = true
      tableView.reloadData()
    }
  }
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
}

extension LocateVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if locateResults.count == 0 {
      return 1
    } else {
      return locateResults.count
    }
  }
}

extension LocateVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier = "LocateResultCell"
    
    var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
    
    if locateResults.count == 0 {
      cell.textLabel!.text = "(Nothing found)"
      cell.detailTextLabel!.text = ""
    } else {
      let locateResult = locateResults[indexPath.row]
      cell.textLabel!.text = locateResult.name
      cell.detailTextLabel!.text = locateResult.artistName
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    if locateResults.count == 0 {
      return nil
    } else {
      return indexPath
    }
  }
}
