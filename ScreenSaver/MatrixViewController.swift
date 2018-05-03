//
//  MatrixViewController.swift
//  ScreenSaver
//
//  Created by madomedu on 2018-04-30.
//  Copyright © 2018 madomedu. All rights reserved.
//

import UIKit

class MatrixViewController: UIViewController {

    /// Array of columns that the nodes fall on
    var columns: [Column] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        
        /// Set columns
        let numOfColumns = Int(view.bounds.width / Util.Constant.SIZE)
        let margin = (view.bounds.width - Util.Constant.SIZE * CGFloat(numOfColumns)) / 2
        
        for i in 0..<numOfColumns {

            let newColumn = Column(frame: CGRect(x: CGFloat(i) * Util.Constant.SIZE + margin, y: 0.0, width: Util.Constant.SIZE, height: view.bounds.height))
            
            columns.append(newColumn)
            view.addSubview(newColumn)
            
        }

        begin()
        begin()
        begin()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func begin() {
        delay(1) {
            let num = arc4random_uniform(6)
            var speed: Util.Speed!
            if num == 0 {
                speed = Util.Speed.FAST
            } else if num == 1 {
                speed = Util.Speed.SLOW
            } else {
                speed = Util.Speed.NORMAL
            }
            self.columns[Int(arc4random_uniform(UInt32(self.columns.count - 1)))].startRain(speed: speed)
            self.begin()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
