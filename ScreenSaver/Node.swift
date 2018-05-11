//
//  Node.swift
//  ScreenSaver
//
//  Created by madomedu on 2018-04-30.
//  Copyright © 2018 madomedu. All rights reserved.
//

import Foundation
import UIKit

class Node: UITextField {
    
    private let kata: [String] = ["ア", "イ", "ウ", "エ", "オ", "カ", "キ", "ク", "ケ", "コ", "サ", "シ", "ス", "セ", "ソ", "タ", "チ", "ツ", "テ", "ト", "ナ", "ニ", "ヌ", "ネ", "ノ", "ハ", "ヒ", "フ", "ヘ", "ホ", "マ", "ミ", "ム", "メ", "モ", "ヤ", "ユ", "ヨ", "ラ", "リ", "ル", "レ", "ロ", "ワ", "ヰ", "ヱ", "ヲ", "ン"] // 48 characters
    
    private var on: Bool! {
        didSet {
            isHidden = !on
        }
    }
    private var value: Int! {
        didSet {
            text = kata[value]
        }
    }
    private var color: UIColor!
    
    private weak var prev: Node?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Initialize Node Object
    ///
    /// - Parameters:
    ///   - on: Whether or not the node should be displayed
    ///   - value: Index of katakana character (0 - 47) [assigns random if out of bounds]
    ///   - color: Color of the displayed value
    ///   - prev: Previous node in column; nil if current node is the tail node
    init(on: Bool, value: Int, color: UIColor, prev: Node?) {
        if let node = prev {
            let offset = node.frame.offsetBy(dx: 0, dy: Util.Constant.SIZE)
            super.init(frame: offset)
        } else {
            super.init(frame: CGRect(x: 0, y: 0, width: Util.Constant.SIZE, height: Util.Constant.SIZE))
        }
        isUserInteractionEnabled = false
        
        // self.self.x used for self to trigger the didSet
        self.self.on = on
        if value < 0 || value > 47 {
            changeKata()
        } else {
            self.self.value = value
        }
        textColor = UIColor.white
        self.color = color
        self.prev = prev
        font = UIFont.monospacedDigitSystemFont(ofSize: Util.Constant.SIZE, weight: .semibold)
        textAlignment = .center
        
//        mutate()
    }
    
    deinit {
        print("node deinit")
    }
    
    /// Assign the node a random katakana character
    func changeKata() {
        self.value = Int(arc4random_uniform(48))
    }
    
    /// Change the node's katakana character color
    func changeColor() {
        textColor = color
    }
    
    /// Changes the alpha value of the node
    ///
    /// - Parameter by: value should be between 0 to 1 -- amount to remove from current alpha
    func changeAlpha(_ by: CGFloat) {
        alpha = alpha - by
        if alpha <= 0 {
            on = false
        }
    }
    
    /// Changes the alpha of the node's textColor
    ///
    /// - Parameter to: node's new alpha value
    func setAlpha(_ to: CGFloat) {
        alpha = to
        if alpha <= 0 {
            on = false
        }
    }
    
    /// Changes a random node in the column to a random katakana character
    func mutate() {
        delay(1) {
            if arc4random_uniform(10) == 0 {
                self.changeKata()
            }
            self.mutate()
        }
    }
}
