//
//  RidesListViewController.swift
//  RideChecker
//
//  Created by Raymond Donkemezuo on 8/12/21.
//

import UIKit

class RidesListViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        setupNavBarAttributes()
    }
    
    private func setupNavBarAttributes() {
        title = "My Rides"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .bold)
        ]
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0.2144741416, blue: 0.4250068963, alpha: 1)
    }
}
