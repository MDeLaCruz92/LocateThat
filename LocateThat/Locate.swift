//
//  Locate.swift
//  LocateThat
//
//  Created by Michael De La Cruz on 2/28/17.
//  Copyright © 2017 Michael De La Cruz. All rights reserved.
//

import Foundation
import UIKit

class Locate {
  
  private var dataTask: URLSessionDataTask? = nil
  private(set) var state: State = .notLocatedYet
  
  typealias LocateComplete = (Bool) -> Void
  
  enum State {
    case notLocatedYet
    case loading
    case noResults
    case results([LocateResult])
  }
  
  enum Category: Int {
    case all = 0
    case music = 1
    case software = 2
    case ebooks = 3
    
    var entityName: String {
      switch self {
      case .all: return ""
      case .music: return "musicTrack"
      case .software: return "software"
      case .ebooks: return "ebook"
      }
    }
  }
  
  //MARK: Parse Functions
  private func iTunesURL(locateText: String, category: Category) -> URL {
    let entityName = category.entityName
    let escapedLocateText = locateText.addingPercentEncoding(
      withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    let urlString = String(format: "https://itunes.apple.com/search?term=%@&limit=200&entity=%@", escapedLocateText, entityName)
    let url = URL(string: urlString)
    return url!
  }
  
  private func parse(json data: Data) -> [String: Any]? {
    do {
      return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    } catch {
      print("JSON Error: \(error)")
      return nil
    }
  }
  
  private func parse(dictionary: [String: Any]) -> [LocateResult] {
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
  
  private func parse(track dictionary: [String: Any]) -> LocateResult {
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
  
  private func parse(audiobook dictionary: [String: Any]) -> LocateResult {
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
  
  private func parse(software dictionary: [String: Any]) -> LocateResult {
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
  
  private func parse(ebook dictionary: [String: Any]) -> LocateResult {
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
  // MARK: Search method
  func performSearch(for text: String, category: Category,
                     completion: @escaping LocateComplete) {
    if !text.isEmpty {
      dataTask?.cancel()
      UIApplication.shared.isNetworkActivityIndicatorVisible = true
      
      state = .loading
      
      let url = iTunesURL(locateText: text, category: category)
      
      let session = URLSession.shared
      dataTask = session.dataTask(with: url, completionHandler: {
        data, response, error in
        
        self.state = .notLocatedYet
        var success = false
        
        if let error = error as? NSError, error.code == -999 {
          return // Search was cancelled
        }
        
        if let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200,
          let jsonData = data,
          let jsonDictionary = self.parse(json: jsonData) {
          
          var locateResults = self.parse(dictionary: jsonDictionary)
          if locateResults.isEmpty {
            self.state = .noResults
          } else {
            locateResults.sort(by: <)
            self.state = .results(locateResults)
          }
          success = true
        }
        
        DispatchQueue.main.async {
          UIApplication.shared.isNetworkActivityIndicatorVisible = false
          completion(success)
        }
      })
      dataTask?.resume()
    }
  }


}
