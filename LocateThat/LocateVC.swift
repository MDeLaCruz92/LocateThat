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
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  
  var dataTask: URLSessionDataTask?
  var landscapeVC: LandscapeVC?
  var locateResults: [LocateResult] = []
  var hasLocated = false
  var isLoading = false
  
  @IBAction func segmentChanged(_ sender: UISegmentedControl) {
    performSearch()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    searchBar.becomeFirstResponder()
    tableView.rowHeight = 80
    tableView.contentInset = UIEdgeInsets(top: 108, left: 0, bottom: 0, right: 0)
    
    var cellNib = UINib(nibName: TableViewCellIdentifiers.locateResultCell, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.locateResultCell)
    
    cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
    
    cellNib = UINib(nibName: TableViewCellIdentifiers.loadingCell, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.loadingCell)
  }
  
  deinit {
    print("deinit \(self)")
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    performSearch()
  }
  
  // MARK: TableViewCell struct
  struct TableViewCellIdentifiers {
    static let locateResultCell = "LocateResultCell"
    static let nothingFoundCell = "NothingFoundCell"
    static let loadingCell = "LoadingCell"
  }
  
  // MARK: Landscape Methods
  override func willTransition(to newCollection: UITraitCollection,
                               with coordinator: UIViewControllerTransitionCoordinator) {
    super.willTransition(to: newCollection, with: coordinator)
    
    switch newCollection.verticalSizeClass {
    case .compact:
      showLandscape(with: coordinator)
    case .regular, .unspecified:
      hideLandscape(with: coordinator)
    }
  }
  
  func showLandscape(with coordinator: UIViewControllerTransitionCoordinator) {
    guard landscapeVC == nil else { return }
    landscapeVC = storyboard!.instantiateViewController(withIdentifier: "LandscapeVC") as? LandscapeVC
    
    if let controller = landscapeVC {
      controller.locateResults = locateResults
      controller.view.frame = view.bounds
      controller.view.alpha = 0
      
      view.addSubview(controller.view)
      addChildViewController(controller)
      coordinator.animate(alongsideTransition: { _ in
        controller.view.alpha = 1
        self.searchBar.resignFirstResponder()   // hides the keyboard
        if self.presentedViewController != nil {
          self.dismiss(animated: true, completion: nil)
        }
      }, completion: { _ in
        controller.didMove(toParentViewController: self)
      })
    }
  }
  
  func hideLandscape(with coordinator: UIViewControllerTransitionCoordinator) {
    if let controller = landscapeVC {
      controller.willMove(toParentViewController: nil)
      
      coordinator.animate(alongsideTransition: { _ in
        controller.view.alpha = 0
      }, completion: { _ in
      controller.view.removeFromSuperview()
      controller.removeFromParentViewController()
      self.landscapeVC = nil
      })
    }
  }
  
  // MARK: Parse Functions
  func iTunesURL(locateText: String, category: Int) -> URL {
    let entityName: String
    switch category {
    case 1: entityName = "musicTrack"
    case 2: entityName = "software"
    case 3: entityName = "ebook"
    default: entityName = ""
    }
    let escapedLocateText = locateText.addingPercentEncoding(
      withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    let urlString = String(format: "https://itunes.apple.com/search?term=%@&limit=200&entity=%@", escapedLocateText, entityName)
    let url = URL(string: urlString)
    return url!
  }
  
  func parse(json data: Data) -> [String: Any]? {
    do {
      return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    } catch {
      print("JSON Error: \(error)")
      return nil
    }
  }
  
  func parse(dictionary: [String: Any]) -> [LocateResult] {
    guard let array = dictionary["results"] as? [Any] else {
      print("Expected 'results' array")
      return []
    }
    
    var locateResults: [LocateResult] = []
    
    for resultDict in array {
      if let resultDict = resultDict as? [String: Any] {
        
        var locateResult: LocateResult?
        
        if let wrapperType = resultDict["wrapperType"] as? String {
          switch wrapperType {
          case "track":
            locateResult = parse(track: resultDict)
          case "audiobook":
            locateResult = parse(audiobook: resultDict)
          case "software":
            locateResult = parse(software: resultDict)
          default:
            break
          }
        } else if let kind = resultDict["kind"] as? String, kind == "ebook" {
          locateResult = parse(ebook: resultDict)
        }
        if let result = locateResult {
          locateResults.append(result)
        }
      }
    }
    return locateResults
  }
  
  func parse(track dictionary: [String: Any]) -> LocateResult {
    let locateResult = LocateResult()
    
    locateResult.name = dictionary["trackName"] as! String
    locateResult.artistName = dictionary["artistName"] as! String
    locateResult.artworkSmallURL = dictionary["artworkUrl60"] as! String
    locateResult.artworkLargeURL = dictionary["artworkUrl100"] as! String
    locateResult.storeURL = dictionary["trackViewUrl"] as! String
    locateResult.kind = dictionary["kind"] as! String
    locateResult.currency = dictionary["currency"] as! String
    
    if let price = dictionary["trackPrice"] as? Double {
      locateResult.price = price
    }
    if let genre = dictionary["primaryGenreName"] as? String {
      locateResult.genre = genre
    }
    return locateResult
  }
  
  func parse(audiobook dictionary: [String: Any]) -> LocateResult {
    let locateResult = LocateResult()
    locateResult.name = dictionary["collectionName"] as! String
    locateResult.artistName = dictionary["artistName"] as! String
    locateResult.artworkSmallURL = dictionary["artworkUrl60"] as! String
    locateResult.artworkLargeURL = dictionary["artworkUrl100"] as! String
    locateResult.storeURL = dictionary["collectionViewUrl"] as! String
    locateResult.kind = "audiobook"
    locateResult.currency = dictionary["currency"] as! String
    
    if let price = dictionary["collectionPrice"] as? Double {
      locateResult.price = price
    }
    if let genre = dictionary["primaryGenreName"] as? String {
      locateResult.genre = genre
    }
    return locateResult
  }
  
  func parse(software dictionary: [String: Any]) -> LocateResult {
    let locateResult = LocateResult()
    locateResult.name = dictionary["trackName"] as! String
    locateResult.artistName = dictionary["artistName"] as! String
    locateResult.artworkSmallURL = dictionary["artworkUrl60"] as! String
    locateResult.artworkLargeURL = dictionary["artworkUrl100"] as! String
    locateResult.storeURL = dictionary["trackViewUrl"] as! String
    locateResult.kind = dictionary["kind"] as! String
    locateResult.currency = dictionary["currency"] as! String
    
    if let price = dictionary["price"] as? Double {
      locateResult.price = price
    }
    if let genre = dictionary["primaryGenreName"] as? String {
      locateResult.genre = genre
    }
    return locateResult
  }
  
  func parse(ebook dictionary: [String: Any]) -> LocateResult {
    let locateResult = LocateResult()
    locateResult.name = dictionary["trackName"] as! String
    locateResult.artistName = dictionary["artistName"] as! String
    locateResult.artworkSmallURL = dictionary["artworkUrl60"] as! String
    locateResult.artworkLargeURL = dictionary["artworkUrl100"] as! String
    locateResult.storeURL = dictionary["trackViewUrl"] as! String
    locateResult.kind = dictionary["kind"] as! String
    locateResult.currency = dictionary["currency"] as! String
    
    if let price = dictionary["price"] as? Double {
      locateResult.price = price
    }
    if let genre = dictionary["genres"] as? String {
      locateResult.genre = genre
    }
    return locateResult
  }
  // MARK: NetworkError
  func showNetworkError() {
    let alert = UIAlertController(
      title: "Whoops...",
      message: "There was an error reading from the iTunes Store. Please try again.",
      preferredStyle: .alert)
    
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(action)
    
    present(alert, animated: true, completion: nil)
  }
  // MARK: Segue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowDetail" {
      let detailVC = segue.destination as! DetailVC
      let indexPath = sender as! IndexPath
      let locateResult = locateResults[indexPath.row]
      detailVC.locateResult = locateResult
    }
  }
}
