//
//  ViewController.swift
//  GestureControll
//
//  Created by Hasinur Rahman on 7/9/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var gestureView: UIView!
    private var indicatorView: UIView = UIView()
    private var redDot: UIView = UIView()
    
    private var isInitialized: Bool = false
    private var scale: CGFloat = 1.0
    private var anchorPoint: CGPoint = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isInitialized == false{
            self.addIndicatorView()
            self.addGestures()
            self.addPerframeRefresher()
            isInitialized = true
        }
    }
    
    @IBAction func sliderValueChanged(_ slider: UISlider){
        self.scale = CGFloat(slider.value)
    }
}

extension ViewController{
    private func addIndicatorView(){
        self.indicatorView = UIView(frame: self.gestureView.bounds)
        self.indicatorView.layer.borderColor = UIColor.red.cgColor
        self.indicatorView.layer.borderWidth = 3.0
        
        let imageView = UIImageView(frame: self.indicatorView.bounds)
        imageView.image = UIImage(named: "abcd")
        self.indicatorView.addSubview(imageView)
        
        self.indicatorView.addSubview(self.redDot)
        self.gestureView.addSubview(self.indicatorView)
        //self.anchorPoint = CGPoint(x: self.indicatorView.bounds.width/2.0, y: self.indicatorView.bounds.width/2.0)
    }
    private func addGestures(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.gestureView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(gesture: UITapGestureRecognizer){
        let tappedPoint = gesture.location(in: self.indicatorView)
        self.showRedDot(tappedPoint: tappedPoint)
    }
    
    private func showRedDot(tappedPoint: CGPoint){
        let redDotFrame = CGRect(x: tappedPoint.x - 10.0, y: tappedPoint.y - 10.0, width: 20.0, height: 20.0)
        self.redDot.frame = redDotFrame
        self.redDot.backgroundColor = .red
    }
    
    private func addPerframeRefresher(){
        let displayLink = CADisplayLink(target: self, selector: #selector(refreshView))
        displayLink.add(to: .current, forMode: .common)
    }
    
    @objc private func refreshView(){
        let moveAnchorTransform = CGAffineTransform(translationX: self.anchorPoint.x, y: self.anchorPoint.y)
        let moveAnchorTransformBack = CGAffineTransform(translationX: -self.anchorPoint.x, y: -self.anchorPoint.y)
        let scaleTransform = CGAffineTransform(scaleX: self.scale, y: self.scale)
        let transform = moveAnchorTransform.concatenating(scaleTransform).concatenating(moveAnchorTransformBack)
        self.indicatorView.transform = transform
    }
}

