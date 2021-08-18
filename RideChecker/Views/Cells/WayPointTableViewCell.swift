//
//  WayPointTableViewCell.swift
//  RideChecker
//
//  Created by Raymond Donkemezuo on 8/16/21.
//

import UIKit

struct WayPointTableViewCellViewModel {
    var isDropOffLocation: Bool
    var iconImage: UIImage {
        let image = UIImage(systemName: isDropOffLocation ? "circle.fill" : "suit.diamond.fill") ?? UIImage()
        image.withTintColor(#colorLiteral(red: 0, green: 1, blue: 1, alpha: 1), renderingMode: .alwaysOriginal)
        return image
    }
    var wayPointAddress: String
    var wayPointType: String {
        return isDropOffLocation ? "Drop off" : "Pickup"
    }
}

class WayPointTableViewCell: UITableViewCell {
    var viewModel: WayPointTableViewCellViewModel? {
        didSet {
            guard let viewModel = viewModel else {return }
            wayPointTypeLabel.text = viewModel.wayPointType
            wayPointTypeAddressLabel.text = viewModel.wayPointAddress
            anchorTypeIndicatorImageView.image = viewModel.iconImage
        }
    }
    
    private lazy var anchorTypeIndicatorImageView: UIImageView = {
        let anchorTypeIndicatorImageView = UIImageView()
        anchorTypeIndicatorImageView.translatesAutoresizingMaskIntoConstraints = false
        return anchorTypeIndicatorImageView
    }()
    
    private lazy var wayPointTypeLabel: UILabel = {
        let wayPointTypeLabel = UILabel()
        wayPointTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        wayPointTypeLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        wayPointTypeLabel.textColor = #colorLiteral(red: 0, green: 0.2144741416, blue: 0.4250068963, alpha: 1)
        return wayPointTypeLabel
    }()
    
    private lazy var wayPointTypeAddressLabel: UILabel = {
        let wayPointTypeAddressLabel = UILabel()
        wayPointTypeAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        wayPointTypeAddressLabel.font = .systemFont(ofSize: 14)
        return wayPointTypeAddressLabel
    }()
    
    static let cellID = "WayPointTableViewCell"
    
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
    }
    /// - TAG: A method to setup constraints
    private func setupConstraints() {
        setupAnchorTypeIndicatorImageView()
        setupWayPointTypeLabelConstraints()
        setupWayPointTypeAddressLabelConstraints()
    }
    
    /// - TAG: A method to setup anchor type indicator imageview constraints
    private func setupAnchorTypeIndicatorImageView() {
        addSubview(anchorTypeIndicatorImageView)
        NSLayoutConstraint.activate([
            anchorTypeIndicatorImageView.topAnchor.constraint(equalTo: topAnchor, constant: ConstraintConstants.topPadding),
            anchorTypeIndicatorImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ConstraintConstants.leadingPadding),
            anchorTypeIndicatorImageView.heightAnchor.constraint(equalToConstant: 15),
            anchorTypeIndicatorImageView.widthAnchor.constraint(equalToConstant: 15)
        ])
    }
    
    /// - TAG: A method to setup waypoint type label constraints
    private func setupWayPointTypeLabelConstraints() {
        addSubview(wayPointTypeLabel)
        NSLayoutConstraint.activate([
            wayPointTypeLabel.topAnchor.constraint(equalTo: anchorTypeIndicatorImageView.topAnchor),
            wayPointTypeLabel.leadingAnchor.constraint(equalTo: anchorTypeIndicatorImageView.trailingAnchor, constant: ConstraintConstants.leadingPadding),
            wayPointTypeLabel.heightAnchor.constraint(equalToConstant: 15),
            wayPointTypeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: ConstraintConstants.trailingPadding)
        ])
    }
    
    /// - TAG: A method setup waypoint address lable constraints
    private func setupWayPointTypeAddressLabelConstraints() {
        addSubview(wayPointTypeAddressLabel)
        NSLayoutConstraint.activate([
            wayPointTypeAddressLabel.topAnchor.constraint(equalTo: wayPointTypeLabel.bottomAnchor, constant: ConstraintConstants.topPadding),
            wayPointTypeAddressLabel.leadingAnchor.constraint(equalTo: wayPointTypeLabel.leadingAnchor),
            wayPointTypeAddressLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: ConstraintConstants.trailingPadding),
            wayPointTypeAddressLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ConstraintConstants.bottomPadding)
        ])
    }
    
    
}
