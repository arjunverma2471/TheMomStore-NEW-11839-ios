//
//  UIView+Animations.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 08/02/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation
import AudioToolbox
extension UIButton {

    func flash() {

        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3

        layer.add(flash, forKey: nil)
    }
}


public extension UIButton {
  func blink(duration: TimeInterval) {
    let initialAlpha: CGFloat = 1
    let finalAlpha: CGFloat = 0.2
    
    alpha = initialAlpha
    
    UIView.animateKeyframes(withDuration: duration, delay: 0, options: .beginFromCurrentState) {
      UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
        self.alpha = finalAlpha
      }
      
      UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
        self.alpha = initialAlpha
      }
    }
  }
    func animateRippleEffect(animationCount:Int=0){
       // animationCounter++
        self.transform = CGAffineTransformMakeScale(0.2, 0.2)
        UIView.animate(withDuration: 0.25, delay: 0,
                       options: UIView.AnimationOptions.curveLinear,
            animations: {
                self.transform = CGAffineTransformMakeScale(1.0, 1.0)
            }, completion: { finished in
//                for _ in 0..<animationCount {
//                    self.animateRippleEffect()
//                }
        })
    }
    
    func addCircleEffect() {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - 10)/2, startAngle: 0.0, endAngle: CGFloat(Double.pi * 2.0), clockwise: true)
            
            // Setup the CAShapeLayer with the path, colors, and line width
            let circleLayer = CAShapeLayer()
            circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.AppTheme().cgColor
            circleLayer.lineWidth = 5.0;
            
            // Don't draw the circle initially
            circleLayer.strokeEnd = 0.0
            
            // Add the circleLayer to the view's layer's sublayers
            layer.addSublayer(circleLayer)
    }
    
    
    func setNewTitlewithAnimation() {
        UIView.transition(with: self.titleLabel!, duration: 0.25, options: .transitionFlipFromBottom, animations: {
            self.setTitle("  "+"Go To Bag".localized + "  ", for: .normal)
            Vibration.success.vibrate()
        }, completion: nil)
    }
}

enum Vibration {
        case error
        case success
        case warning
        case light
        case medium
        case heavy
        @available(iOS 13.0, *)
        case soft
        @available(iOS 13.0, *)
        case rigid
        case selection
        case oldSchool

        public func vibrate() {
            switch self {
            case .error:
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            case .success:
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            case .warning:
                UINotificationFeedbackGenerator().notificationOccurred(.warning)
            case .light:
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            case .medium:
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            case .heavy:
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            case .soft:
                if #available(iOS 13.0, *) {
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                }
            case .rigid:
                if #available(iOS 13.0, *) {
                    UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                }
            case .selection:
                UISelectionFeedbackGenerator().selectionChanged()
            case .oldSchool:
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
        }
    }
