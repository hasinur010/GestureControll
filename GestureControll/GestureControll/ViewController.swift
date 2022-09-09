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
    private var touchPoint: CGPoint = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isInitialized == false{
            self.addIndicatorView()
            self.addGestures()
            self.addPerframeRefresher()
            //self.rotateInAnchorAnimate()
            isInitialized = true
        }
    }
    
    private func rotateInAnchorAnimate(){
        let box = UIView(frame: CGRect(x: 50, y: 50, width: 256, height: 256))
        box.backgroundColor = .blue
        view.addSubview(box)

        box.setAnchorPoint(CGPoint(x: 1, y: 1))

        UIView.animate(withDuration: 3) {
            box.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }
    }
    
    @IBAction func sliderValueChanged(_ slider: UISlider){
        self.scale = CGFloat(slider.value)
        if slider.value == 1.0{
            slider.thumbTintColor = .green
        }else{
            slider.thumbTintColor = .red
        }
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
        self.anchorPoint = CGPoint(x: self.indicatorView.bounds.width/2.0, y: self.indicatorView.bounds.height/2.0)
        self.touchPoint = self.anchorPoint
    }
    private func addGestures(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.gestureView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(gesture: UITapGestureRecognizer){
        self.anchorPoint = gesture.location(in: gestureView)
        let tappedPoint = gesture.location(in: self.indicatorView)
        self.touchPoint = tappedPoint
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
        let normalizedAnchorPoint: CGPoint = CGPoint(x: self.touchPoint.x/self.indicatorView.bounds.width, y: self.touchPoint.y/self.indicatorView.bounds.height)
        self.indicatorView.setAnchorPoint(normalizedAnchorPoint)
        self.indicatorView.transform = CGAffineTransform(scaleX: self.scale, y: self.scale)
    }
}

extension UIView {
    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y);

        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)

        var position = layer.position

        position.x -= oldPoint.x
        position.x += newPoint.x

        position.y -= oldPoint.y
        position.y += newPoint.y

        layer.position = position
        layer.anchorPoint = point
    }
}
