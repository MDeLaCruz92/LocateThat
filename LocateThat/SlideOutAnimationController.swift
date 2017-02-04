//
//  SlideOutAnimationController.swift
//  LocateThat
//
//  Created by Michael De La Cruz on 2/3/17.
//  Copyright © 2017 Michael De La Cruz. All rights reserved.
//

import UIKit

class SlideOutAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.3
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    if let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) {
      let containerView = transitionContext.containerView
      let duration = transitionDuration(using: transitionContext)
      UIView.animate(withDuration: duration, animations: {
        fromView.center.y -= containerView.bounds.size.height
        fromView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
      }, completion: { finished in
        transitionContext.completeTransition(finished)
      })
    }
  }
}
