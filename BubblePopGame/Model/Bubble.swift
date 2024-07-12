//
//  Bubbles.swift
//  BubblePopGame
//
//  Created by Xueying Zou on 2022/4/22.
//

import UIKit

class Bubble: UIButton {
    
    var value: Int = 0
    let xPosition = CGFloat(10 + arc4random_uniform(UInt32(UIScreen.main.bounds.width) - 2 * UInt32(UIScreen.main.bounds.width / 12) - 20))
    let yPosition = CGFloat(160 + arc4random_uniform(UInt32(UIScreen.main.bounds.height) - 2 * UInt32(UIScreen.main.bounds.width / 12) - 180))
    

    override init(frame: CGRect){
        super.init(frame: frame)
        self.frame = CGRect(x: xPosition, y: yPosition, width: 120, height: 120)
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        
        // game points
        // probability of appearance
        let probability = arc4random_uniform(100)
        
        if probability < 40 {
            self.setBackgroundImage(UIImage(named: "red.png"), for: .normal)
            self.value = 1
        }else if probability < 70 {
            self.setBackgroundImage(UIImage(named: "pink.png"), for: .normal)
            self.value = 2
        }else if probability < 85 {
            self.setBackgroundImage(UIImage(named: "green.png"), for: .normal)
            self.value = 5
        }else if probability < 95 {
            self.setBackgroundImage(UIImage(named: "blue.png"), for: .normal)
            self.value = 8
        }else {
            self.setBackgroundImage(UIImage(named: "black.png"), for: .normal)
            self.value = 10
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animation() {
        let springAnimation = CASpringAnimation(keyPath: "transform.scale")
        springAnimation.duration = 0.6
        springAnimation.fromValue = 1
        springAnimation.toValue = 0.8
        springAnimation.repeatCount = 1
        springAnimation.initialVelocity = 0.5
        springAnimation.damping = 1
        
        layer.add(springAnimation, forKey: nil)
    }
}

