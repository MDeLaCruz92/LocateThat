//
//  LocateResultCell.swift
//  LocateThat
//
//  Created by Michael De La Cruz on 1/24/17.
//  Copyright © 2017 Michael De La Cruz. All rights reserved.
//

import UIKit

class LocateResultCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var artistNameLabel: UILabel!
  @IBOutlet weak var artworkImageView: UIImageView!
  
  var downloadTask: URLSessionDownloadTask?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    let selectedView = UIView(frame: CGRect.zero)
    selectedView.backgroundColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 0.5)
    selectedBackgroundView = selectedView
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    downloadTask?.cancel()
    downloadTask = nil
  }
  
  func configure(for locateResult: LocateResult) {
    nameLabel.text = locateResult.name
    
    if locateResult.artistName.isEmpty {
      artistNameLabel.text = "Unknown"
    } else {
      artistNameLabel.text = String(format: "%@ (%@)", locateResult.artistName, kindForDisplay(locateResult.kind))
    }
    
    artworkImageView.image = UIImage(named: "Placeholder")
    if let smallURL = URL(string: locateResult.artworkSmallURL) {
      downloadTask = artworkImageView.loadImage(url: smallURL)
    }
  }
  
  func kindForDisplay(_ kind: String) -> String {
    switch kind {
    case "album": return "Album"
    case "audiobook": return "Audio Book"
    case "book": return "Book"
    case "ebook": return "E-Book"
    case "feature-move": return "Movie"
    case "music-video": return "Music Video"
    case "podcast": return "Podcast"
    case "software": return "App"
    case "tv-episode": return "TV Episode"
    default: return kind
    }
  }
  
}
