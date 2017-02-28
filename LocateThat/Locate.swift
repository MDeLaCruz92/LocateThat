//
//  Locate.swift
//  LocateThat
//
//  Created by Michael De La Cruz on 2/28/17.
//  Copyright © 2017 Michael De La Cruz. All rights reserved.
//

import Foundation

class Locate {
  var locateResults: [LocateResult] = []
  var hasLocated = false
  var isLoading = false
  
  private var dataTask: URLSessionDataTask? = nil
}
