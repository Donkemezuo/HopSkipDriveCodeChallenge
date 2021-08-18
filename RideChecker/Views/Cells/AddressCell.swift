//
//  AddressCell.swift
//  RideChecker
//
//  Created by Raymond Donkemezuo on 8/17/21.
//

import UIKit

struct AddressCellViewModel {
    var address: String
    var number: Int
    var addressText: String {
        return "\(number). \(address)"
    }
}

/// - TAG: UITableViewCell class for WayPointAddress table view cell
class AddressCell: UITableViewCell {
    var viewModel: AddressCellViewModel? {
        didSet {
            guard let viewModel = viewModel else {return}
            addressLabel.text = viewModel.addressText
        }
    }
    private lazy var addressLabel: UILabel = {
        let addressLabel = UILabel()
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.font = .systemFont(ofSize: 12, weight: .regular)
        addressLabel.numberOfLines = 0
        return addressLabel
    }()
    static let cellID = "AddressCell"
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit() {
        setupConstraints()
    }
    private func setupConstraints() {
        addSubview(addressLabel)
        NSLayoutConstraint.activate([
            addressLabel.topAnchor.constraint(equalTo: topAnchor, constant: ConstraintConstants.topPadding),
            addressLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ConstraintConstants.leadingPadding),
            addressLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: ConstraintConstants.trailingPadding),
            addressLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ConstraintConstants.bottomPadding)
        ])
    }
    
}

