//
//  DetailVC.swift
//  LocateThat
//
//  Created by Michael De La Cruz on 1/31/17.
//  Copyright © 2017 Michael De La Cruz. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
  
  @IBOutlet weak var popupView: UIView!
  @IBOutlet weak var artworkImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var artistNameLabel: UILabel!
  @IBOutlet weak var kindLabel: UILabel!
  @IBOutlet weak var genreLabel: UILabel!
  @IBOutlet weak var priceButton: UIButton!
  
  var locateResult: LocateResult!
  var downloadTask: URLSessionDownloadTask?
  
  @IBAction func close() {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func openInStore() {
    if let url = URL(string: locateResult.storeURL) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.tintColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 1)
    popupView.layer.cornerRadius = 10
    
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(close))
    gestureRecognizer.cancelsTouchesInView = false
    gestureRecognizer.delegate = self
    view.addGestureRecognizer(gestureRecognizer)
    
    if locateResult != nil {
      updateUI()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    modalPresentationStyle = .custom
    transitioningDelegate = self
  }
  
  func updateUI() {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = locateResult.currency
    
    let priceText: String
    if locateResult.price == 0 {
      priceText = "Free"
    } else if let text = formatter.string(from: locateResult.price as NSNumber) {
      
      priceText = text
    } else {
      priceText = ""
    }
    
    priceButton.setTitle(priceText, for: .normal)
    
    nameLabel.text = locateResult.name
    
    if locateResult.artistName.isEmpty {
      artistNameLabel.text = "Unknown"
    } else {
      artistNameLabel.text = locateResult.artistName
    }
    
    kindLabel.text = locateResult.kindForDisplay()
    genreLabel.text = locateResult.genre
    
    if let largeURL = URL(string: locateResult.artworkLargeURL) {
      downloadTask = artworkImageView.loadImage(url: largeURL)
    }
  }
  
  deinit {
    print("deinit \(self)")
    downloadTask?.cancel()
  }
  
}
