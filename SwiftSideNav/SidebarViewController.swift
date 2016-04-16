/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit

class SidebarViewController: UIViewController {
  var leftViewController: UIViewController!
  var mainViewController: UIViewController!
  var overlap: CGFloat!
  var scrollView: UIScrollView!
    var firstTime = true

  required init?(coder aDecoder: NSCoder) {
    assert(false, "Use init(leftViewController:mainViewController:overlap:)")
    super.init(coder: aDecoder)
  }

  init(leftViewController: UIViewController, mainViewController: UIViewController, overlap: CGFloat) {
    self.leftViewController = leftViewController
    self.mainViewController = mainViewController
    self.overlap = overlap

    super.init(nibName: nil, bundle: nil)

    self.view.backgroundColor = UIColor.blackColor()

    setupScrollView()
    setupViewControllers()
  }

  func setupScrollView() {
    scrollView = UIScrollView()
    scrollView.pagingEnabled = true
    scrollView.bounces = false
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(scrollView)

    let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[scrollView]|", options: [], metrics: nil, views: ["scrollView": scrollView])
    let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[scrollView]|", options: [], metrics: nil, views: ["scrollView": scrollView])
    NSLayoutConstraint.activateConstraints(horizontalConstraints + verticalConstraints)
  }

  func setupViewControllers() {
    addViewController(leftViewController)
    addViewController(mainViewController)
    addShadowToView(mainViewController.view)

    let views = ["left": leftViewController.view, "main": mainViewController.view, "outer": view]
    let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
      "|[left][main(==outer)]|", options: [.AlignAllTop, .AlignAllBottom], metrics: nil, views: views)
    let leftWidthConstraint = NSLayoutConstraint(
      item: leftViewController.view,
      attribute: .Width,
      relatedBy: .Equal,
      toItem: view,
      attribute: .Width,
      multiplier: 1.0, constant: -overlap)
    let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|[main(==outer)]|", options: [], metrics: nil, views: views)
    NSLayoutConstraint.activateConstraints(horizontalConstraints + verticalConstraints + [leftWidthConstraint])

  }

  private func addViewController(viewController: UIViewController) {
    viewController.view.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(viewController.view)
    addChildViewController(viewController)
    viewController.didMoveToParentViewController(self)
  }
    
    private func addShadowToView(destView: UIView) {
        destView.layer.shadowPath = UIBezierPath(
            rect: destView.bounds).CGPath
        destView.layer.shadowRadius = 2.5
        destView.layer.shadowOffset = CGSize(width: 0, height: 0)
        destView.layer.shadowOpacity = 1.0
        destView.layer.shadowColor = UIColor.blackColor().CGColor
    }
    
    func closeMenuAnimated(animated: Bool) {
        scrollView.setContentOffset(
            CGPoint(x: CGRectGetWidth(leftViewController.view.frame),
                y: 0),
            animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        if firstTime {
            firstTime = false
            closeMenuAnimated(false)
        }
    }
}









