//
//  RidesTableViewHeaderView.swift
//  RideChecker
//
//  Created by Raymond Donkemezuo on 8/14/21.
//

import UIKit

struct RidesTableViewHeaderViewModel {
    var rideDayName: String
    var firstRideTime: String
    var lastRideTime: String
    var totalEarnings: Double
}

/// - TAG: A UITableViewHeaderFooterView class for RidesTableview headerview
class RidesTableViewHeaderView: UITableViewHeaderFooterView {
    var viewModel: RidesTableViewHeaderViewModel? {
        didSet {
            guard let viewModel = viewModel else {return;}
            dayNameLabel.text = viewModel.rideDayName
            firstRideTimeLabel.text = "Start at: \(viewModel.firstRideTime)"
            lastRideTimeLabel.text = "End at: \(viewModel.lastRideTime)"
            earningsLabel.text = "$\(viewModel.totalEarnings)"
        }
    }
    static let headerID = "RidesTableViewHeaderView"
    
    lazy var dayNameLabel: UILabel = {
        let dayNameLabel = UILabel()
        dayNameLabel.translatesAutoresizingMaskIntoConstraints = false
        dayNameLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        dayNameLabel.textColor = #colorLiteral(red: 0, green: 0.2144741416, blue: 0.4250068963, alpha: 1)
        return dayNameLabel
    }()
    
    lazy var firstRideTimeLabel: UILabel = {
        let firstRideTimeLabel = UILabel()
        firstRideTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        firstRideTimeLabel.font = .systemFont(ofSize: 12)
        return firstRideTimeLabel
    }()
    
    lazy var lastRideTimeLabel: UILabel = {
        let lastRideTimeLabel = UILabel()
        lastRideTimeLabel.font = .systemFont(ofSize: 12)
        lastRideTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        return lastRideTimeLabel
    }()
    
    lazy var estimatedEarningsLabel: UILabel = {
        let estimatedEarningsLabel = UILabel()
        estimatedEarningsLabel.font = .systemFont(ofSize: 12, weight: .medium)
        estimatedEarningsLabel.translatesAutoresizingMaskIntoConstraints = false
        estimatedEarningsLabel.text = "Estimated"
        estimatedEarningsLabel.textColor = #colorLiteral(red: 0, green: 0.2144741416, blue: 0.4250068963, alpha: 1)
        estimatedEarningsLabel.textAlignment = .right
        return estimatedEarningsLabel
    }()
    
    lazy var earningsLabel: UILabel = {
        let earningsLabel = UILabel()
        earningsLabel.font = .systemFont(ofSize: 15, weight: .bold)
        earningsLabel.translatesAutoresizingMaskIntoConstraints = false
        earningsLabel.textAlignment = .right
        return earningsLabel
    }()
    
    lazy var dateStackView: UIStackView = {
        let dateStackView = UIStackView(arrangedSubviews: [firstRideTimeLabel, lastRideTimeLabel])
        dateStackView.axis = .horizontal
        dateStackView.spacing = 10
        dateStackView.translatesAutoresizingMaskIntoConstraints = false
        dateStackView.distribution = .fillEqually
        return dateStackView
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        commonInit()
        contentView.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1).withAlphaComponent(0.2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        setupConstraints()
    }
    
    private func setupConstraints() {
        setupNameLabelConstraints()
        setupDateStackViewConstraints()
        setupEarningsLabelConstraints()
        setupEstimatedEarningsLabelConstraints()
    }
    /// - TAG: A method to setup name label constraints
    private func setupNameLabelConstraints() {
        addSubview(dayNameLabel)
        NSLayoutConstraint.activate([dayNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
                                     dayNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
                                     dayNameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
                                     dayNameLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5)
        ])
    }
    /// - TAG: A method to setup date stackview constraints
    private func setupDateStackViewConstraints() {
        addSubview(dateStackView)
        NSLayoutConstraint.activate([
            dateStackView.topAnchor.constraint(equalTo: dayNameLabel.bottomAnchor, constant: 5),
            dateStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            dateStackView.leadingAnchor.constraint(equalTo: dayNameLabel.leadingAnchor),
            dateStackView.trailingAnchor.constraint(equalTo: dayNameLabel.trailingAnchor)
        ])
    }
    
    /// - TAG: A method to setup earnings label constraints
    private func setupEarningsLabelConstraints() {
        addSubview(earningsLabel)
        NSLayoutConstraint.activate([
            earningsLabel.topAnchor.constraint(equalTo: dayNameLabel.topAnchor),
            earningsLabel.leadingAnchor.constraint(equalTo: dayNameLabel.trailingAnchor, constant: 5),
            earningsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            earningsLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5)
        ])
    }
    
    /// - TAG: A method to setup estimated earnings label constraints
    private func setupEstimatedEarningsLabelConstraints() {
        addSubview(estimatedEarningsLabel)
        NSLayoutConstraint.activate([
            estimatedEarningsLabel.topAnchor.constraint(equalTo: earningsLabel.bottomAnchor, constant: 5),
            estimatedEarningsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            estimatedEarningsLabel.leadingAnchor.constraint(equalTo: earningsLabel.leadingAnchor),
            estimatedEarningsLabel.trailingAnchor.constraint(equalTo: earningsLabel.trailingAnchor)
        ])
    }
    
}
