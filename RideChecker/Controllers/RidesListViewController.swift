//
//  RidesListViewController.swift
//  RideChecker
//
//  Created by Raymond Donkemezuo on 8/12/21.
//

import UIKit

class RidesListViewController: UIViewController {
    private let dataManager = DataManager()
    private let ridesListView = RidesListView()
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubView()
        setupNavBarAttributes()
        registerDelegates()
        dataManager.fetchRides { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
                return;
            }
            DispatchQueue.main.async {
                self.ridesListView.ridesListTableView.reloadData()
            }
        }
    }
    
    /// - TAG: A method to setup navigation bar attributes 
    private func setupNavBarAttributes() {
        title = "My Rides"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .bold)
        ]
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0.2144741416, blue: 0.4250068963, alpha: 1)
    }
    /// - TAG: A method to add ride list view to view
    private func addSubView() {
        view.addSubview(ridesListView)
        NSLayoutConstraint.activate([ridesListView.topAnchor.constraint(equalTo: view.topAnchor),
                                     ridesListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     ridesListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     ridesListView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
    
    /// - TAG: A method to register ride list tableview delegate
    private func registerDelegates() {
        ridesListView.ridesListTableView.dataSource = self
        ridesListView.ridesListTableView.delegate = self
    }
    
}

/// - TAG: Ride list tableview Data source
extension RidesListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionName = dataManager.rideDaysForSectionHeaderTitles[section]
        let firstRide = dataManager.getDayFirstRideStartTime(_: section)
        let lastRide = dataManager.getDayLastRideEndTime(_: section)
        let totalEarned = dataManager.getDayRidesTotal(_: section)
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: RidesTableViewHeaderView.headerID) as? RidesTableViewHeaderView {
            let headerViewModel = RidesTableViewHeaderViewModel(rideDayName: sectionName, firstRideTime: firstRide, lastRideTime: lastRide, totalEarnings: totalEarned)
            headerView.viewModel = headerViewModel
            return headerView
        }
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataManager.rideDaysForSectionHeaderTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = dataManager.rideDaysForSectionHeaderTitles[section]
        let ridesForSection = dataManager.groupedRides[sectionTitle] ?? []
        return ridesForSection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionTitle = dataManager.rideDaysForSectionHeaderTitles[indexPath.section]
        let ridesForSection = dataManager.groupedRides[sectionTitle] ?? []
        let ride = ridesForSection[indexPath.row]
        guard let rideCell = tableView.dequeueReusableCell(withIdentifier: RidesTableViewCell.cellID, for: indexPath) as? RidesTableViewCell else {
            return UITableViewCell()
        }
        let viewModel = RidesTableViewCellViewModel(startTime: ride.rideStartTime, endTime: ride.rideEndTime, numberOfRiders: ride.totalNumberOfPassengers, numberOfBoosters: 2, cost: ride.dollarCost, stops: ride.wayPoints)
        
        rideCell.viewModel = viewModel
        return rideCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionTitle = dataManager.rideDaysForSectionHeaderTitles[indexPath.section]
        let ridesForSection = dataManager.groupedRides[sectionTitle] ?? []
        let ride = ridesForSection[indexPath.row]
        
        let detailsViewModel = RideDetailsViewModel(rideDayName: sectionTitle, startTime: ride.rideStartTime, endTime: ride.rideEndTime, startingLocationCoordinates: ride.startingPointCoordinates, destinationLocationCoordinates: ride.endingPointCoordinates, rideID: ride.rideID, rideCost: ride.dollarCost, distance: ride.estimated_ride_miles, rideDuration: ride.estimated_ride_minutes, rideIsSeries: ride.ride_in_series, rideWayPoints: ride.wayPoints)
        
        navigationController?.pushViewController(RideDetailsViewController(_: detailsViewModel), animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
}
