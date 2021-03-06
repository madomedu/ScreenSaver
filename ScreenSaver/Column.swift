//
//  Column.swift
//  ScreenSaver
//
//  Created by madomedu on 2018-04-30.
//  Copyright © 2018 madomedu. All rights reserved.
//

import Foundation
import UIKit

class Column: UIView {
    private var active: Bool!
    private var nodes: [Node?]
    private var numOfRows: Int!
    private var speed: Double!
    private var fade_started: Bool!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Safe State initializers
    ///
    /// - Parameter frame: Frame of column
    override init(frame: CGRect) {
        active = false
        fade_started = false
        nodes = []
        super.init(frame: frame)
        numOfRows = Int(bounds.height / Util.Constant.SIZE)
    }
    
    deinit {
        print("column deinit")
    }

    /// Begin node rain
    public func startRain(speed: Util.Speed) {
        if !active {
            active = true
            
            self.speed = speed.rawValue
        
            let head = Node(on: true, value: -1, color: UIColor.green, prev: nil)
            nodes.append(head)
            addSubview(head)
            
            animateRain()
        }
    }
    
    /// Animate the node rain -- Add new node to the bottom of the last node until the bottom of the view
    ///
    /// - Parameter iterator: Used to keep track of how many iterations the function has gone through
    private func animateRain(_ iterator: CGFloat = 0) {
        if Util.Constant.SIZE * iterator <= bounds.height - Util.Constant.SIZE * 2 {
            delay(speed) { [weak self] in
                guard let strongSelf = self else { return }
                let node: Node? = Node(on: true, value: -1, color: UIColor.green, prev: strongSelf.nodes[strongSelf.nodes.count - 1])
                strongSelf.nodes[strongSelf.nodes.count - 1]!.changeColor()
                strongSelf.nodes.append(node)
                strongSelf.addSubview(node!)
                strongSelf.animateRain(iterator + 1.0)
                
                if !strongSelf.fade_started && strongSelf.nodes.count > strongSelf.numOfRows / 2 {
                    strongSelf.fade_started = true
                    strongSelf.fade()
                }
            }
        }
    }
    
    /// Sets a delay
    /// After the specified delay has been met, execute the closure
    ///
    /// - Parameters:
    ///   - delay: time until closure should be executed
    ///   - closure: function to be executeed aftere delay
    private func delay(_ delay: Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
        
    /// Begins to fade away the rain from the top down
    ///
    /// - Parameter iterator: Used to keep track of how many iterations the function has gone through
    private func fade(_ iterator: Int = 0) {
        delay(speed * 0.5) { [weak self] in
            guard let strongSelf = self else { return }
            if let _ = strongSelf.nodes[strongSelf.nodes.count - 1] {
                for i in 1..<4 {
                    if strongSelf.nodes.count - 1 >= iterator + i {
                        strongSelf.nodes[iterator + i]!.setAlpha(0.25 * CGFloat(i))
                    }
                }
                strongSelf.nodes[iterator]!.removeFromSuperview()
                strongSelf.nodes[iterator] = nil
                strongSelf.fade(iterator + 1)
            } else {
                strongSelf.cleanUp()
            }
        }
    }
    
    /// Sets the object to a safe state, ready to be reused
    private func cleanUp() {
        active = false
        fade_started = false
        nodes = []
    }
}
