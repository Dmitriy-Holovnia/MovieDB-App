//
//  RatingView.swift
//  MovieDB App
//
//  Created by Dima Golovnya on 30.07.2021.
//

import UIKit

final class RatingView: UIView {
    
    var rating: Double = 0.0 {
        didSet {
            ratingLabel.text = "\(rating)"
        }
    }
    
    private var shapeLayer: CAShapeLayer!
    
    lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    override func draw(_ rect: CGRect) {
        shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(ovalIn: rect).cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.green.cgColor
        shapeLayer.strokeEnd = 0
        shapeLayer.strokeStart = 0
        shapeLayer.position.y = rect.height
        shapeLayer.transform = CATransform3DMakeRotation(CGFloat(90 * Double.pi / 180), 0, 0, -1)
        layer.addSublayer(shapeLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setup
    private func configureUI() {
        addSubview(ratingLabel)
        
        ratingLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        ratingLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    func animate() {
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.fromValue = 0
        strokeAnimation.toValue = (rating / 10)
        strokeAnimation.duration = (2 * (rating / 10))
        strokeAnimation.fillMode = .forwards
        strokeAnimation.isRemovedOnCompletion = false
        
        let colorAnimation = CABasicAnimation(keyPath: "strokeColor")
        colorAnimation.fromValue = UIColor.red.cgColor
        colorAnimation.toValue = UIColor.green.cgColor
        colorAnimation.duration = 2
        colorAnimation.fillMode = .both
        colorAnimation.fillMode = .forwards
        colorAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(strokeAnimation, forKey: nil)
        shapeLayer.add(colorAnimation, forKey: nil)
    }
}
