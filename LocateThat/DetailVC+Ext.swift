//
//  DetailVC+Ext.swift
//  LocateThat
//
//  Created by Michael De La Cruz on 1/31/17.
//  Copyright © 2017 Michael De La Cruz. All rights reserved.
//

import UIKit

extension DetailVC: UIViewControllerTransitioningDelegate {
  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    return DimmingPresentationController(
      presentedViewController: presented, presenting: presenting)
  }
}

extension DetailVC: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    return (touch.view === self.view)
  }
}
