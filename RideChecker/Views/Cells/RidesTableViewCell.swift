//
//  RidesTableViewCell.swift
//  RideChecker
//
//  Created by Raymond Donkemezuo on 8/14/21.
//

import UIKit

struct RidesTableViewCellViewModel {
    var startTime: String
    var endTime: String
    var numberOfRiders: Int
    var numberOfBoosters: Int?
    var cost: Double
    var timeText: String {
        return "\(startTime) - \(endTime)".lowercased()
    }
    var stops: [WayPoint]
    
    private var numberOfRidesText: String {
        return numberOfRiders > 1 ? "\(numberOfRiders) riders" : "\(numberOfRiders) rider"
    }
    
    private var numberOfBoostersText: String {
        if let numberOfBoosters = numberOfBoosters {
            return numberOfBoosters > 1 ? "\(numberOfBoosters) boosters" : "\(numberOfBoosters) booster"
        }
        return ""
    }
    
    var numberOfRidersLabelText: String {
        return numberOfBoostersText.isEmpty ? numberOfRidesText : numberOfRidesText + " * " + numberOfBoostersText
    }
    
    var rideCostText: String {
        return "$\(cost)"
    }
}


/// - TAG: A UITableViewCell class for RidesTableViewCell
class RidesTableViewCell: UITableViewCell {
    var viewModel: RidesTableViewCellViewModel? {
        didSet {
            guard let viewModel = viewModel else {return}
            timeLabel.text = viewModel.timeText
            numberOfRidesLabel.text = viewModel.numberOfRidersLabelText
            rideCostLabel.text = viewModel.rideCostText
        }
    }
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        containerView.layer.cornerRadius = 5
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    private lazy var numberOfRidesLabel: UILabel = {
        let numberOfRidesLabel = UILabel()
        numberOfRidesLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfRidesLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        numberOfRidesLabel.textAlignment = .center
        return numberOfRidesLabel
    }()
    
    private lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        return timeLabel
    }()
    
    private lazy var wayPointsListTableView: UITableView = {
        let stopsListTableView = UITableView()
        stopsListTableView.translatesAutoresizingMaskIntoConstraints = false
        stopsListTableView.backgroundColor = .clear
        stopsListTableView.separatorStyle = .none
        stopsListTableView.register(AddressCell.self, forCellReuseIdentifier: AddressCell.cellID)
        return stopsListTableView
    }()
    
    private lazy var rideCostLabel: UILabel = {
        let rideCostLabel = UILabel()
        rideCostLabel.translatesAutoresizingMaskIntoConstraints = false
        rideCostLabel.textAlignment = .center
        rideCostLabel.font = .systemFont(ofSize: 14, weight: .medium)
        return rideCostLabel
    }()
    
    static let cellID = "RidesTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        setupConstraints()
        registerDelegate()
    }
    private func setupConstraints() {
        setupContainerViewConstraints()
        setupTimeLabelConstraints()
        setupnumberOfRiderLabelConstraints()
        setupWayPointsListTableViewConstraints()
        setupRideCostLabel()
    }
    
    /// - TAG: A method to setup container view constraints
    private func setupContainerViewConstraints() {
        addSubview(containerView)
        NSLayoutConstraint.activate([containerView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
                                     containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
                                     containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
                                     containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
    
    /// - TAG: A method to setup timeInfo Label view constraints
    private func setupTimeLabelConstraints() {
        containerView.addSubview(timeLabel)
        NSLayoutConstraint.activate([timeLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: ConstraintConstants.topPadding),
                                     timeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: ConstraintConstants.leadingPadding),
                                     timeLabel.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.3),
                                     timeLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5)
        ])
    }
    
    /// - TAG: A method to setup numberOfRidersInfo Label constraints
    private func setupnumberOfRiderLabelConstraints() {
        containerView.addSubview(numberOfRidesLabel)
        NSLayoutConstraint.activate([
            numberOfRidesLabel.topAnchor.constraint(equalTo: timeLabel.topAnchor),
            numberOfRidesLabel.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: ConstraintConstants.leadingPadding),
            numberOfRidesLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: ConstraintConstants.trailingPadding),
            numberOfRidesLabel.heightAnchor.constraint(equalTo: timeLabel.heightAnchor)
        ])
    }
    
    /// - TAG: A method to setup waypoints List tableView constraints
    private func setupWayPointsListTableViewConstraints() {
        containerView.addSubview(wayPointsListTableView)
        NSLayoutConstraint.activate([
            wayPointsListTableView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: ConstraintConstants.topPadding),
            wayPointsListTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: ConstraintConstants.leadingPadding),
            wayPointsListTableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: ConstraintConstants.bottomPadding),
            wayPointsListTableView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.7)
        ])
    }
    /// - TAG: A method to setup ride cost label constraints
    private func setupRideCostLabel() {
        containerView.addSubview(rideCostLabel)
        NSLayoutConstraint.activate([
            rideCostLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: ConstraintConstants.trailingPadding),
            rideCostLabel.leadingAnchor.constraint(equalTo: wayPointsListTableView.trailingAnchor, constant: ConstraintConstants.leadingPadding),
            rideCostLabel.topAnchor.constraint(equalTo: numberOfRidesLabel.bottomAnchor, constant: ConstraintConstants.topPadding),
            rideCostLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: ConstraintConstants.bottomPadding)
        ])
    }
    
    /// - TAG: A method to registerDelegate
    private func registerDelegate() {
        wayPointsListTableView.dataSource = self
        wayPointsListTableView.delegate = self
    }
}

/// - TAG: Datasource
extension RidesTableViewCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel?.stops.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let addressCell = tableView.dequeueReusableCell(withIdentifier: AddressCell.cellID, for: indexPath) as? AddressCell else
        {
            return UITableViewCell()
        }
        let wayPoint = (viewModel?.stops ?? [])[indexPath.row]
        let viewModel = AddressCellViewModel(address: wayPoint.location.address, number: indexPath.row + 1)
        addressCell.viewModel = viewModel
        return addressCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20
    }
}
