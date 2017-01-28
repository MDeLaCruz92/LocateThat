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
}

func < (lhs: LocateResult, rhs: LocateResult) -> Bool {
  return lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
}
