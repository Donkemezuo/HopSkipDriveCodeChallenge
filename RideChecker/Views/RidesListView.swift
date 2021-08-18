//
//  RidesListView.swift
//  RideChecker
//
//  Created by Raymond Donkemezuo on 8/14/21.
//

import UIKit

class RidesListView: UIView {
    lazy var ridesListTableView: UITableView = {
        let ridesListTableView = UITableView()
        ridesListTableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        ridesListTableView.translatesAutoresizingMaskIntoConstraints = false
        ridesListTableView.sectionHeaderHeight = 70
        ridesListTableView.separatorStyle = .none
        return ridesListTableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        setupRidesListTVConstraints()
        registerCells()
    }
    
    private func setupRidesListTVConstraints() {
        addSubview(ridesListTableView)
        NSLayoutConstraint.activate([ridesListTableView.topAnchor.constraint(equalTo: topAnchor),
                                     ridesListTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     ridesListTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
                                     ridesListTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func registerCells() {
        ridesListTableView.register(RidesTableViewCell.self, forCellReuseIdentifier: RidesTableViewCell.cellID)
        ridesListTableView.register(RidesTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: RidesTableViewHeaderView.headerID)
    }
}
