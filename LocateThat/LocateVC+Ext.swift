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
    if !searchBar.text!.isEmpty {
      searchBar.resignFirstResponder()
      
      isLoading = true
      tableView.reloadData()
      
      hasLocated = true
      locateResults = []
      
      let queue = DispatchQueue.global()
      
      queue.async {
        let url = self.iTunesURL(locateText: searchBar.text!)
        
        if let jsonString = self.performStoreRequest(with: url),
          let jsonDictionary = self.parse(json: jsonString) {
          
          self.locateResults = self.parse(dictionary: jsonDictionary)
          self.locateResults.sort(by: <)
          
          DispatchQueue.main.async {
            self.isLoading = false
            self.tableView.reloadData()
          }
          return
        }
        
        DispatchQueue.main.async {
          self.showNetworkError()
        }
      }
    }
  }
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
}

extension LocateVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if isLoading {
      return 1
    } else if !hasLocated {
      return 0
    } else if locateResults.count == 0 {
      return 1
    } else {
      return locateResults.count
    }
  }
}

extension LocateVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if isLoading {
      let cell = tableView.dequeueReusableCell(withIdentifier:
        TableViewCellIdentifiers.loadingCell, for: indexPath)
      
      let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
      spinner.startAnimating()
      return cell
    } else if locateResults.count == 0 {
      return tableView.dequeueReusableCell(withIdentifier:
        TableViewCellIdentifiers.nothingFoundCell, for: indexPath)
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier:
        TableViewCellIdentifiers.locateResultCell, for: indexPath) as! LocateResultCell
      
      let locateResult = locateResults[indexPath.row]
      cell.nameLabel.text = locateResult.name
      
      if locateResult.artistName.isEmpty {
        cell.artistNameLabel.text = "Unknown"
      } else {
        cell.artistNameLabel.text = String(format: "%@ (%@)",
                                           locateResult.artistName, kindForDisplay(locateResult.kind))
      }
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    if locateResults.count == 0 || isLoading {
      return nil
    } else {
      return indexPath
    }
  }
  
  
}
