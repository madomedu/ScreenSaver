//
//  Clock.swift
//  ScreenSaver
//
//  Created by madomedu on 2018-05-12.
//  Copyright © 2018 madomedu. All rights reserved.
//

import Foundation
import UIKit

class Clock: UIView {
    
    private var clockLabel: [UILabel]!
    private var cursors: [UIView]!
    private var cursorPosition: Int = 0
    private var displayedTime: String!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        let width = frame.width / 5
        let cursorHeight: CGFloat = 10
        let clockHeight = frame.height - cursorHeight
        
        clockLabel = []
        cursors = []
        
        for i in 0..<5 {
            clockLabel.append(createClockLabel(x: width * CGFloat(i), y: 0, width: width, height: clockHeight))
            addSubview(clockLabel[i])
        }
        
        displayedTime = ""
        
        for i in 0..<5 {
            cursors.append(UILabel(frame: CGRect(x: width * CGFloat(i), y: clockHeight, width: width, height: cursorHeight)))
            cursors[i].backgroundColor = UIColor.white
            cursors[i].isHidden = true
            addSubview(cursors[i])
        }
        
        cursorPosition = 0
        
        startClock()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createClockLabel(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> UILabel {
        let newLabel = UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
        newLabel.font = UIFont.monospacedDigitSystemFont(ofSize: height, weight: .heavy)
        newLabel.adjustsFontSizeToFitWidth = true
        newLabel.textAlignment = .center
        newLabel.baselineAdjustment = .alignCenters
        newLabel.textColor = UIColor.red
        return newLabel
    }
    // called betweenn------- changee
    private func changeTime() {
        let date = Date()
        let calendar = Calendar.current
        let hours = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let currentTime = String(format: "%02d:%02d", hours, minutes)
        
        
    }

    private func startClock() {
        /// Set to an empty state
        for label in clockLabel {
            label.text = ""
        }
        toggleBlinking(for: cursors[cursorPosition], blink: false)
        
        /// Populate
        let date = Date()
        let calendar = Calendar.current
        let hours = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        displayedTime = String(format: "%02d:%02d", hours, minutes)

        self.cursorPosition = 0
        self.cursors[cursorPosition].isHidden = false
//        self.toggleBlinking(for: self.cursors[self.cursorPosition], blink: true)
        
        delay(1) {
            self.beginTyping()
        }
        
    }
    
    func beginTyping(_ iterator: Int = 0) {
        if iterator < 5 {
            delay(keystrokeTime()) {
                self.clockLabel[iterator].text = String(self.displayedTime[self.displayedTime.index(self.displayedTime.startIndex, offsetBy: iterator)])
                self.moveCursorForwards()
                self.beginTyping(iterator + 1)
            }
        } else {
            toggleBlinking(for: cursors[cursorPosition], blink: true)
        }
    }
    
    func toggleBlinking(for cursor: UIView, blink: Bool) {
        if blink {
            self.blink(cursor)
            cursor.isHidden = false
        } else {
            cursor.isHidden = true
        }
    }
    
    func blink(_ cursor: UIView) {
        if cursors[cursorPosition] == cursor {
            delay(2) {
                cursor.isHidden = !cursor.isHidden
                self.blink(cursor)
            }
        } else {
            cursor.isHidden = true
        }
    }
    
    /// Simulates time to be used by delay function to simulate real keystrokes
    ///
    /// - Returns: Time between keystrokes
    func keystrokeTime() -> Double {
        if arc4random_uniform(2) == 0 {
            return Double(arc4random_uniform(10) + 1) / 10
        } else {
            return Double(arc4random_uniform(20) + 1) / 20
        }
    }
    
    func moveCursorForwards() {
        if cursorPosition < 4 {
            toggleBlinking(for: cursors[cursorPosition], blink: false)
            cursorPosition += 1
            toggleBlinking(for: cursors[cursorPosition], blink: true)
        }
    }
    
    func moveCursorBackwards() {
        if cursorPosition > 0 {
            toggleBlinking(for: cursors[cursorPosition], blink: false)
            cursorPosition -= 1
            toggleBlinking(for: cursors[cursorPosition], blink: true)
        }
    }
    
    /// Sets a delay
    /// After the specified delay has been met, execute the closure
    ///
    /// - Parameters:
    ///   - delay: time until closure should be executed
    ///   - closure: function to be executeed aftere delay
    func delay(_ delay: Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }

}
