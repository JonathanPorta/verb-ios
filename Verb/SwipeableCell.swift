//
//  SwipeableCell.swift
//  Verb
//
//  Created by Jonathan Porta on 11/10/14.
//  Copyright (c) 2014 Jonathan Porta. All rights reserved.
//

import Foundation
import UIKit

class SwipeableCell: UITableViewCell, UIGestureRecognizerDelegate {

  let bounceValue: CGFloat = 20.0

  var swipeableModel: SwipeableModel!
  var onCompletedSwipe: ((Void) -> ())?
  var backgroundColorPrompt = UIColor.whiteColor()
  var backgroundColorWorking = UIColor.greenColor()

  @IBOutlet var	contentUIView: UIView!

  @IBOutlet var	foregroundUIView: UIView!
  @IBOutlet var foregroundLabel: UILabel!

  @IBOutlet var	backgroundUIView: UIView!
  @IBOutlet var backgroundLabel: UILabel!

  var panRecognizer: UIPanGestureRecognizer!
  var panStartPoint: CGPoint!
  var startingRightLayoutConstant: CGFloat!

  @IBOutlet var foregroundViewLeftConstraint: NSLayoutConstraint!
  @IBOutlet var foregroundViewRightConstraint: NSLayoutConstraint!

  override func awakeFromNib() {
    super.awakeFromNib()

    panRecognizer = UIPanGestureRecognizer(target: self, action: Selector("panThisCell:"))
    panRecognizer.delegate = self
    foregroundUIView.addGestureRecognizer(panRecognizer)
  }

  func panThisCell(recognizer: UIPanGestureRecognizer) {
    // Bail if model isn't swipeable.
    if !swipeableModel.isSwipeable() { return }

    switch (recognizer.state) {
      case UIGestureRecognizerState.Began:
        panStartPoint = recognizer.translationInView(foregroundUIView)
        startingRightLayoutConstant = foregroundViewRightConstraint.constant
        NSLog("Pan Began at \(NSStringFromCGPoint(panStartPoint))")
        updateBackgroundLabelIfNeeded(foregroundViewRightConstraint.constant)
        break

      case UIGestureRecognizerState.Changed:
        var currentPoint = recognizer.translationInView(foregroundUIView)
        var deltaX = currentPoint.x - panStartPoint.x
        NSLog("Pan Moved \(deltaX)")

        var panningLeft = false
        if (currentPoint.x < panStartPoint.x) {
          panningLeft = true
        }

        if (startingRightLayoutConstant == 0) {
          // The cell was closed and is now opening
          if (!panningLeft) {
            var constant = max(-deltaX, 0)
            if (constant == 0) {
              NSLog("CLOSED!")
              resetConstraints(true, notifyDelegateDidClose: false)
            }
            else {
              foregroundViewRightConstraint.constant = constant
            }
          }
          else {
            var constant = min(-deltaX, getSnapPoint())
            if (constant == getSnapPoint()) {
              setConstraintsToShowAll(true, notifyDelegateDidOpen: true)
              NSLog("WINNER!!!!!!!!!!")
            }
            else {
              foregroundViewRightConstraint.constant = constant
            }
          }
        }
        else {
          //The cell was at least partially open.
          var adjustment = startingRightLayoutConstant - deltaX
          if (!panningLeft) {
            var constant = max(adjustment, 0)
            if (constant == 0) {
              resetConstraints(true, notifyDelegateDidClose: false)
            }
            else {
              foregroundViewRightConstraint.constant = constant
            }
          }
          else {
            var constant = min(adjustment, getSnapPoint())
            if (constant == getSnapPoint()) {
              setConstraintsToShowAll(true, notifyDelegateDidOpen: false)
            }
            else {
              foregroundViewRightConstraint.constant = constant
            }
          }
        }
        
        foregroundViewLeftConstraint.constant = -foregroundViewRightConstraint.constant
        updateBackgroundLabelIfNeeded(foregroundViewRightConstraint.constant)
        break

      case UIGestureRecognizerState.Ended:
        NSLog("Pan Ended")
        if (startingRightLayoutConstant == 0) {
          //Cell was opening
          if (foregroundViewRightConstraint.constant >= getSnapPoint()) {
            //Open all the way
            setConstraintsToShowAll(true, notifyDelegateDidOpen: true)
          }
          else {
            //Re-close
            resetConstraints(true, notifyDelegateDidClose: true)
          }
        }
        else {
          //Cell was closing
          if (foregroundViewRightConstraint.constant >= getSnapPoint()) {
            //Re-open all the way
            setConstraintsToShowAll(true, notifyDelegateDidOpen: true)
          }
          else {
            //Close
            resetConstraints(true, notifyDelegateDidClose: true)
          }
        }
        updateBackgroundLabelIfNeeded(foregroundViewRightConstraint.constant)
        break

      case UIGestureRecognizerState.Cancelled:
        NSLog("Pan Cancelled")
        if (startingRightLayoutConstant == 0) {
          //Cell was closed - reset everything to 0
          resetConstraints(true, notifyDelegateDidClose: true)
        }
        else {
          //Cell was open - reset to the open state
          setConstraintsToShowAll(true, notifyDelegateDidOpen: true)
        }
        updateBackgroundLabelIfNeeded(foregroundViewRightConstraint.constant)
        break

      default:
        break
    }
  }

  func getSnapPoint() -> CGFloat {
    return 0.8 * CGRectGetWidth(frame)
  }

  func getWarnPoint() -> CGFloat {
    return 0.5 * CGRectGetWidth(frame)
  }

  func updateBackgroundLabelIfNeeded(position: CGFloat) {
    if position < getWarnPoint() {
      backgroundLabel.text = swipeableModel.promptMessage()
      backgroundUIView.backgroundColor = backgroundColorPrompt
    }
    //else if position >= getWarnPoint() && position < getSnapPoint() {
    //  backgroundLabel.text = swipeableModel.confirmMessage()
    //}
    else if position >= getSnapPoint() {
      backgroundLabel.text = swipeableModel.workingMessage()
      backgroundUIView.backgroundColor = backgroundColorWorking
    }
  }

  func updateConstraintsIfNeeded(animated: Bool, completion: ((Bool) -> Void)?) {
    var duration: NSTimeInterval = 0
    if (animated) {
      duration = 0.1
    }

    UIView.animateWithDuration(duration, delay: NSTimeInterval(0), options: UIViewAnimationOptions.CurveEaseOut, animations:{
      self.layoutIfNeeded()
    }, completion: completion)
  }

  func setConstraintsToShowAll(animated: Bool, notifyDelegateDidOpen: Bool) {
    //TODO: Notify delegate.

    if (startingRightLayoutConstant == getSnapPoint() && foregroundViewRightConstraint.constant == getSnapPoint()) {
      return
    }

    foregroundViewLeftConstraint.constant = -getSnapPoint() - bounceValue
    foregroundViewRightConstraint.constant = getSnapPoint() + bounceValue

    updateConstraintsIfNeeded(animated, completion: { finished in
      self.foregroundViewLeftConstraint.constant = -self.getSnapPoint()
      self.foregroundViewRightConstraint.constant = self.getSnapPoint()

      self.updateConstraintsIfNeeded(animated, completion: { finished in
        self.startingRightLayoutConstant = self.foregroundViewRightConstraint.constant
      })
    })

    if notifyDelegateDidOpen {
      NSLog("notifyDelegateDidOpen")
      resetConstraints(true, notifyDelegateDidClose: false)
      if onCompletedSwipe != nil {
        NSLog("onCompletedSwipe")
        onCompletedSwipe!()
      }
    }
  }

  func resetConstraints(animated: Bool, notifyDelegateDidClose: Bool) {
    //TODO: Notify delegate.

    if (startingRightLayoutConstant == 0 && foregroundViewRightConstraint.constant == 0) {
      //Already all the way closed, no bounce necessary
      return
    }

    foregroundViewRightConstraint.constant = -bounceValue
    foregroundViewLeftConstraint.constant = bounceValue

    updateConstraintsIfNeeded(animated, completion: { finished in
      self.foregroundViewRightConstraint.constant = 0
      self.foregroundViewLeftConstraint.constant = 0

      self.updateConstraintsIfNeeded(animated, completion: { finished in
        self.startingRightLayoutConstant = self.foregroundViewRightConstraint.constant
      })
    })
  }
}