//
//  UIImageView+DownloadImage.swift
//  LocateThat
//
//  Created by Michael De La Cruz on 1/31/17.
//  Copyright © 2017 Michael De La Cruz. All rights reserved.
//

import UIKit

extension UIImageView {
  func loadImage(url: URL) -> URLSessionDownloadTask {
    let session = URLSession.shared
    let downloadTask = session.downloadTask(with: url, completionHandler: { [weak self] url, response, error in
      if error == nil, let url = url,
                       let data = try? Data(contentsOf: url),
                       let image = UIImage(data: data) {
        DispatchQueue.main.async {
          if let strongSelf = self {
            strongSelf.image = image
          }
        }
      }
    })
    downloadTask.resume()
    return downloadTask
  }
}
