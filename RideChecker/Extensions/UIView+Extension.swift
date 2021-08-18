//
//  UIView+Extension.swift
//  RideChecker
//
//  Created by Raymond Donkemezuo on 8/16/21.
//

import Foundation
import UIKit

extension UIView {
    func makeRound() {
        self.layer.cornerRadius = self.bounds.width / 2
        self.clipsToBounds = true
    }
}
