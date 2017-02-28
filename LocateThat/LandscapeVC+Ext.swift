//
//  LandscapeVC+Ext.swift
//  LocateThat
//
//  Created by Michael De La Cruz on 2/26/17.
//  Copyright © 2017 Michael De La Cruz. All rights reserved.
//

import UIKit

extension LandscapeVC: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let width = scrollView.bounds.size.width
    let currentPage = Int((scrollView.contentOffset.x + width/2)/width)
    pageControl.currentPage = currentPage
  }
}
