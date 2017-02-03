//
//  LocateResult.swift
//  LocateThat
//
//  Created by Michael De La Cruz on 1/21/17.
//  Copyright © 2017 Michael De La Cruz. All rights reserved.
//

import Foundation

class LocateResult {
  var name = ""
  var artistName = ""
  var artworkSmallURL = ""
  var artworkLargeURL = ""
  var storeURL = ""
  var kind = ""
  var currency = ""
  var price = 0.0
  var genre = ""
  
  func kindForDisplay() -> String {
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

func < (lhs: LocateResult, rhs: LocateResult) -> Bool {
  return lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
}
