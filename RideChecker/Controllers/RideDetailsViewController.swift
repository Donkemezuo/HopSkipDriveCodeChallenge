//
//  RideDetailsViewController.swift
//  RideChecker
//
//  Created by Raymond Donkemezuo on 8/15/21.
//

import UIKit

class RideDetailsViewController: UIViewController {
    private var rideDetailsView = RideDetailsView()
    init(_ viewModel: RideDetailsViewModel) {
        rideDetailsView.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubView()
        setupNavBarAttributes()
        registerDelegates()
    }
    
    /// - TAG: A method to add ride details view to view
    private func addSubView() {
        view.addSubview(rideDetailsView)
        NSLayoutConstraint.activate([rideDetailsView.topAnchor.constraint(equalTo: view.topAnchor),
                                     rideDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     rideDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     rideDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
    /// - TAG: A method to setup navigation bar attributes
    private func setupNavBarAttributes() {
        title = "Ride Details"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .bold)
        ]
        navigationController?.navigationBar.tintColor = .white
    }
    /// - TAG: A method to register delegates
    private func registerDelegates() {
        rideDetailsView.wayPointsTableView.dataSource = self
    }
}

/// - TAG: Data source for wayPoints table view
extension RideDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (rideDetailsView.viewModel?.rideWayPoints ?? []).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let wayPointCell = tableView.dequeueReusableCell(withIdentifier: WayPointTableViewCell.cellID, for: indexPath) as? WayPointTableViewCell else {
            return UITableViewCell()
        }
        let allwayPoint = (rideDetailsView.viewModel?.rideWayPoints ?? [])
        let wayPoint = allwayPoint[indexPath.row]
        let isLastStop = indexPath.row == (allwayPoint.count - 1)
        let viewModel = WayPointTableViewCellViewModel(isDropOffLocation: isLastStop, wayPointAddress: wayPoint.location.address)
        wayPointCell.viewModel = viewModel
        return wayPointCell
    }
    
    
}
