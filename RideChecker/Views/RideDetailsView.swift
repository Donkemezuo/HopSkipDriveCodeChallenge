//
//  RideDetailsView.swift
//  RideChecker
//
//  Created by Raymond Donkemezuo on 8/15/21.
//

import UIKit
import MapKit

struct RideDetailsViewModel {
    var rideDayName: String
    var startTime: String
    var endTime: String
    var startingLocationCoordinates: CLLocationCoordinate2D
    var destinationLocationCoordinates: CLLocationCoordinate2D
    var rideID: Int
    var rideCost: Double
    var distance: Double
    var rideIDText: String {
        return String(rideID)
    }
    var rideDuration: Int
    var rideDurationText: String {
        return String(rideDuration)
    }
    var rideIsSeries: Bool
    var seriesText: String {
        return rideIsSeries ? "This ride is part of a series" : ""
    }
    var rideCostText: String {
        return "$" + String(rideCost)
    }
    var distanceText: String {
        return String(distance) + "miles"
    }
    var rideWayPoints: [WayPoint]
}

struct ConstraintConstants {
    static var leadingPadding = CGFloat(5)
    static var trailingPadding = CGFloat(-5)
    static var topPadding = CGFloat(5)
    static var bottomPadding = CGFloat(-5)
}


class RideDetailsView: UIView {
    var viewModel: RideDetailsViewModel? {
        didSet {
            guard let viewModel = viewModel else {return}
            rideDayNameLabel.text = viewModel.rideDayName
            startTime.text = viewModel.startTime.lowercased()
            endTime.text = viewModel.endTime.lowercased()
            seriesTextLabel.isHidden = !viewModel.rideIsSeries
            seriesTextLabel.text = viewModel.seriesText
            rideIDTextLabel.text = viewModel.rideIDText
            rideDurationTextLabel.text = viewModel.rideDurationText
            rideCostLabel.text = viewModel.rideCostText
            rideDistanceTextLabel.text = viewModel.distanceText
            resetSeriesLabelHeight()
            showAnnotations()
            DrawRidePath()
        }
    }
    private var seriesTextLabelHeightConstraints: NSLayoutConstraint?
    private var seriesTextLabel: UILabel = {
        let seriesTextLabel = UILabel()
        seriesTextLabel.font = .italicSystemFont(ofSize: 12)
        seriesTextLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        seriesTextLabel.translatesAutoresizingMaskIntoConstraints = false
        return seriesTextLabel
    }()
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        mapView.layer.cornerRadius = 5
        return mapView
    }()
    private lazy var rideInfoContainerView: UIView = {
        let rideInfoContainerView = UIView()
        rideInfoContainerView.translatesAutoresizingMaskIntoConstraints = false
        rideInfoContainerView.layer.cornerRadius = 5
        rideInfoContainerView.backgroundColor = #colorLiteral(red: 0, green: 0.2144741416, blue: 0.4250068963, alpha: 1).withAlphaComponent(0.1)
        return rideInfoContainerView
    }()
    private lazy var rideDayNameLabel: UILabel = {
        let rideDayNameLabel = UILabel()
        rideDayNameLabel.translatesAutoresizingMaskIntoConstraints = false
        rideDayNameLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        rideDayNameLabel.textColor = #colorLiteral(red: 0, green: 0.2144741416, blue: 0.4250068963, alpha: 1)
        return rideDayNameLabel
    }()
    private lazy var timeInfoStack: UIStackView = {
        let timeInfoStack = UIStackView(arrangedSubviews: [startTimeStack, endTimeStack])
        timeInfoStack.translatesAutoresizingMaskIntoConstraints = false
        timeInfoStack.distribution = .fillEqually
        timeInfoStack.axis = .horizontal
        return timeInfoStack
    }()
    
    private lazy var rideCostLabel: UILabel = {
        let rideCostLabel = UILabel()
        rideCostLabel.font = .systemFont(ofSize: 30, weight: .semibold)
        rideCostLabel.translatesAutoresizingMaskIntoConstraints = false
        rideCostLabel.textAlignment = .center
        rideCostLabel.textColor = #colorLiteral(red: 0, green: 0.2144741416, blue: 0.4250068963, alpha: 1)
        return rideCostLabel
    }()
    
    private lazy var startTimeLabel: UILabel = {
        let startTimeLabel = UILabel()
        startTimeLabel.text = "Start at"
        startTimeLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        startTimeLabel.textColor = UIColor.gray.withAlphaComponent(0.8)
        return startTimeLabel
    }()
    
    private lazy var endTimeLabel: UILabel = {
        let endTimeLabel = UILabel()
        endTimeLabel.text = "End at"
        endTimeLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        endTimeLabel.textColor =  UIColor.gray.withAlphaComponent(0.8)
        return endTimeLabel
    }()
    
    private var estimatedLabel: UILabel = {
        let estimatedLabel = UILabel()
        estimatedLabel.text = "est. Cost"
        estimatedLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        estimatedLabel.textAlignment = .center
        estimatedLabel.textColor = UIColor.gray.withAlphaComponent(0.8)
        estimatedLabel.translatesAutoresizingMaskIntoConstraints = false
        return estimatedLabel
    }()
    
    private lazy var endTime: UILabel = {
        let endTime = UILabel()
        endTime.font = .systemFont(ofSize: 12, weight: .semibold)
        return endTime
    }()
    
    private lazy var startTime: UILabel = {
        let startTime = UILabel()
        startTime.font = .systemFont(ofSize: 12, weight: .semibold)
        return startTime
    }()
    
    private lazy var startTimeStack: UIStackView = {
        let startTimeStack = UIStackView(arrangedSubviews: [startTimeLabel, startTime])
        startTimeStack.distribution = .fillEqually
        startTimeStack.spacing = 10
        startTimeStack.axis = .vertical
        return startTimeStack
    }()
    
    private lazy var endTimeStack: UIStackView = {
        let endTimeStack = UIStackView(arrangedSubviews: [endTimeLabel, endTime])
        endTimeStack.spacing = 10
        endTimeStack.distribution = .fillEqually
        endTimeStack.axis = .vertical
        return endTimeStack
    }()
    
    private lazy var rideInfoStack: UIStackView = {
        let rideInfoStack = UIStackView(arrangedSubviews: [rideIDInfoStack, rideDistanceInfoStack])
        rideInfoStack.spacing = 10
        rideInfoStack.distribution = .fillEqually
        rideInfoStack.axis = .horizontal
        rideInfoStack.translatesAutoresizingMaskIntoConstraints = false
        return rideInfoStack
    }()
    
    private lazy var rideIDInfoStack: UIStackView = {
        let rideIDInfoStack = UIStackView(arrangedSubviews: [rideIDLabel, rideIDTextLabel])
        rideIDInfoStack.spacing = 10
        rideIDInfoStack.distribution = .fillEqually
        rideIDInfoStack.axis = .vertical
        return rideIDInfoStack
    }()
    
    private lazy var rideDistanceInfoStack: UIStackView = {
        let rideDistanceInfoStack = UIStackView(arrangedSubviews: [distanceLabel, rideDistanceTextLabel])
        rideDistanceInfoStack.spacing = 10
        rideDistanceInfoStack.distribution = .fillEqually
        rideDistanceInfoStack.axis = .vertical
        return rideDistanceInfoStack
    }()
    
    private lazy var rideIDLabel: UILabel = {
        let rideIDLabel = UILabel()
        rideIDLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        rideIDLabel.textColor = UIColor.gray.withAlphaComponent(0.8)
        rideIDLabel.text = "Ride ID"
        return rideIDLabel
    }()
    
    private lazy var rideIDTextLabel: UILabel = {
        let rideIDTextLabel = UILabel()
        rideIDTextLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        return rideIDTextLabel
    }()
    
    private lazy var rideDurationLabel: UILabel = {
        let rideDurationLabel = UILabel()
        rideDurationLabel.textAlignment = .center
        rideDurationLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        rideDurationLabel.textColor = UIColor.gray.withAlphaComponent(0.8)
        rideDurationLabel.text = "Minutes"
        rideDurationLabel.translatesAutoresizingMaskIntoConstraints = false
        return rideDurationLabel
    }()
    
    private lazy var costInfoContainerView: UIView = {
        let costInfoContainerView = UIView()
        return costInfoContainerView
    }()
    
    private lazy var durationInfoContainerView: UIView = {
        let durationInfoContainerView = UIView()
        return durationInfoContainerView
    }()
    
    private lazy var rideDurationTextLabel: UILabel = {
        let rideDurationTextLabel = UILabel()
        rideDurationTextLabel.font = .systemFont(ofSize: 30, weight: .semibold)
        rideDurationTextLabel.translatesAutoresizingMaskIntoConstraints = false
        rideDurationTextLabel.textAlignment = .center
        rideDurationTextLabel.textColor = #colorLiteral(red: 0, green: 0.2144741416, blue: 0.4250068963, alpha: 1)
        return rideDurationTextLabel
    }()
    
    private lazy var rideCostInfoStack: UIStackView = {
        let rideCostInfoStack = UIStackView(arrangedSubviews: [costInfoContainerView, durationInfoContainerView])
        rideCostInfoStack.distribution = .fillEqually
        rideCostInfoStack.spacing = 10
        rideCostInfoStack.axis = .vertical
        rideCostInfoStack.translatesAutoresizingMaskIntoConstraints = false 
        return rideCostInfoStack
    }()
    
    private lazy var distanceLabel: UILabel = {
        let distanceLabel = UILabel()
        distanceLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        distanceLabel.textColor = UIColor.gray.withAlphaComponent(0.8)
        distanceLabel.text = "Distance"
        return distanceLabel
    }()
    
    private lazy var rideDistanceTextLabel: UILabel = {
        let rideDistanceTextLabel = UILabel()
        rideDistanceTextLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        return rideDistanceTextLabel
    }()
    
    private lazy var wayPointsTextLabel: UILabel = {
        let wayPointsTextLabel = UILabel()
        wayPointsTextLabel.font = .systemFont(ofSize: 14, weight: .medium)
        wayPointsTextLabel.text = "Stops in Route"
        wayPointsTextLabel.translatesAutoresizingMaskIntoConstraints = false
        return wayPointsTextLabel
    }()
    
    lazy var wayPointsTableView: UITableView = {
        let wayPointsTableView = UITableView()
        wayPointsTableView.translatesAutoresizingMaskIntoConstraints = false
        wayPointsTableView.register(WayPointTableViewCell.self, forCellReuseIdentifier: WayPointTableViewCell.cellID)
        return wayPointsTableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        commonInit()
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        setupConstraints()
    }
    private func setupConstraints() {
        setupSeriesTextLabelConstraints()
        setupMapViewConstraints()
        setupRideInfoContainerViewConstraints()
        setupRideDayNameLabelConstraints()
        setupTimeInfoStackConstraints()
        setuprideCostInfoStackConstraints()
        setupRideInfoStackConstraints()
        setupCostLabelConstraints()
        setupEstimatedLabelConstraints()
        setupRideDurationLabelConstraints()
        setupMinutesLabelConstraints()
        setupWayPointsTextLabelConstraints()
        setupWayPointsTableViewConstraints()
    }
    
    /// - TAG: A method to show annotations on the map
    private func showAnnotations() {
        guard let viewModel = viewModel else {return}
        let startingLocationAnnotation = MKPointAnnotation()
        let endingLocationAnnotation = MKPointAnnotation()
        startingLocationAnnotation.coordinate = viewModel.startingLocationCoordinates
        endingLocationAnnotation.coordinate = viewModel.destinationLocationCoordinates
        startingLocationAnnotation.title = "Pick up"
        endingLocationAnnotation.title = "Drop Off"
        mapView.showAnnotations([startingLocationAnnotation, endingLocationAnnotation], animated: true)
    }
    
    /// - TAG: A method to draw a path between the pickup and destination locations
    private func DrawRidePath() {
        guard let viewModel = viewModel else {return}
        let startingLocationPlaceMark = MKPlacemark(coordinate: viewModel.startingLocationCoordinates)
        let endingLocationPlaceMark = MKPlacemark(coordinate: viewModel.destinationLocationCoordinates)
        let directionRequest = MKDirections.Request()
        directionRequest.transportType = .automobile
        let startingLocationMapItem = MKMapItem(placemark: startingLocationPlaceMark)
        let endingLocationMapItem = MKMapItem(placemark: endingLocationPlaceMark)
        directionRequest.destination = endingLocationMapItem
        directionRequest.source = startingLocationMapItem
        let directions = MKDirections(request: directionRequest)
        directions.calculate {[weak self] (response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let response = response {
                guard let self = self else {return}
                let route = response.routes[0]
                self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            }
        }
    }
    
    /// - TAG: A method to setup mapview constraints
    private func setupMapViewConstraints() {
        addSubview(mapView)
        NSLayoutConstraint.activate([mapView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: ConstraintConstants.topPadding),
                                     mapView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ConstraintConstants.leadingPadding),
                                     mapView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: ConstraintConstants.trailingPadding),
                                     mapView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.45)
        ])
    }
    
    /// - TAG: A method to setup rideInfoContainerView constraints
    private func setupRideInfoContainerViewConstraints() {
        addSubview(rideInfoContainerView)
        NSLayoutConstraint.activate([
            rideInfoContainerView.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: ConstraintConstants.topPadding),
            rideInfoContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ConstraintConstants.leadingPadding),
            rideInfoContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: ConstraintConstants.trailingPadding),
            rideInfoContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2)
        ])
    }
    
    /// - TAG: A method to setup rideDayName label constraints
    private func setupRideDayNameLabelConstraints() {
        rideInfoContainerView.addSubview(rideDayNameLabel)
        NSLayoutConstraint.activate([
            rideDayNameLabel.topAnchor.constraint(equalTo: seriesTextLabel.bottomAnchor, constant: ConstraintConstants.topPadding),
            rideDayNameLabel.leadingAnchor.constraint(equalTo: rideInfoContainerView.leadingAnchor, constant: ConstraintConstants.leadingPadding),
            rideDayNameLabel.widthAnchor.constraint(equalTo: rideInfoContainerView.widthAnchor, multiplier: 0.5),
            rideDayNameLabel.heightAnchor.constraint(equalTo: rideInfoContainerView.heightAnchor, multiplier: 0.2)
        ])
    }
    /// - TAG: A method to setup ride time info stackView constraints
    private func setupTimeInfoStackConstraints() {
        rideInfoContainerView.addSubview(timeInfoStack)
        NSLayoutConstraint.activate([
            timeInfoStack.topAnchor.constraint(equalTo: rideDayNameLabel.bottomAnchor, constant: ConstraintConstants.topPadding),
            timeInfoStack.leadingAnchor.constraint(equalTo: rideDayNameLabel.leadingAnchor),
            timeInfoStack.trailingAnchor.constraint(equalTo: rideDayNameLabel.trailingAnchor),
            timeInfoStack.heightAnchor.constraint(equalTo: rideInfoContainerView.heightAnchor, multiplier: 0.3)
        ])
    }
    
    /// - TAG: A method to setup ride info stackView constraints
    private func setupRideInfoStackConstraints() {
        rideInfoContainerView.addSubview(rideInfoStack)
        NSLayoutConstraint.activate([
            rideInfoStack.topAnchor.constraint(equalTo: timeInfoStack.bottomAnchor, constant: ConstraintConstants.topPadding),
            rideInfoStack.leadingAnchor.constraint(equalTo: rideDayNameLabel.leadingAnchor),
            rideInfoStack.trailingAnchor.constraint(equalTo: rideDayNameLabel.trailingAnchor),
            rideInfoStack.bottomAnchor.constraint(equalTo: rideInfoContainerView.bottomAnchor, constant: ConstraintConstants.bottomPadding)
        ])
    }
    
    /// - TAG: A method to setup ride cost info stack view constraints
    private func setuprideCostInfoStackConstraints() {
        rideInfoContainerView.addSubview(rideCostInfoStack)
        NSLayoutConstraint.activate([
            rideCostInfoStack.topAnchor.constraint(equalTo: rideInfoContainerView.topAnchor, constant: ConstraintConstants.topPadding),
            rideCostInfoStack.trailingAnchor.constraint(equalTo: rideInfoContainerView.trailingAnchor, constant: ConstraintConstants.trailingPadding),
            rideCostInfoStack.widthAnchor.constraint(equalTo: rideInfoContainerView.widthAnchor, multiplier: 0.3),
            rideCostInfoStack.bottomAnchor.constraint(equalTo: rideInfoContainerView.bottomAnchor, constant: ConstraintConstants.bottomPadding)
        ])
    }
    /// - TAG: A method to setup cost label constraints
    private func setupCostLabelConstraints() {
        costInfoContainerView.addSubview(rideCostLabel)
        NSLayoutConstraint.activate([
            rideCostLabel.topAnchor.constraint(equalTo: costInfoContainerView.topAnchor),
            rideCostLabel.leadingAnchor.constraint(equalTo: costInfoContainerView.leadingAnchor),
            rideCostLabel.trailingAnchor.constraint(equalTo: costInfoContainerView.trailingAnchor),
            rideCostLabel.heightAnchor.constraint(equalTo: costInfoContainerView.heightAnchor, multiplier: 0.6)
        ])
    }
    
    /// - TAG: A method to setup estimated text label constraints
    private func setupEstimatedLabelConstraints() {
        costInfoContainerView.addSubview(estimatedLabel)
        NSLayoutConstraint.activate([
            estimatedLabel.topAnchor.constraint(equalTo: rideCostLabel.bottomAnchor),
            estimatedLabel.leadingAnchor.constraint(equalTo: rideCostLabel.leadingAnchor),
            estimatedLabel.trailingAnchor.constraint(equalTo: rideCostLabel.trailingAnchor),
            estimatedLabel.bottomAnchor.constraint(equalTo: costInfoContainerView.bottomAnchor, constant: ConstraintConstants.bottomPadding)
        ])
    }
    
    /// - TAG: A method to setup series text label constraints
    private func setupSeriesTextLabelConstraints() {
        rideInfoContainerView.addSubview(seriesTextLabel)
        NSLayoutConstraint.activate([
            seriesTextLabel.topAnchor.constraint(equalTo: rideInfoContainerView.topAnchor, constant: ConstraintConstants.topPadding),
            seriesTextLabel.leadingAnchor.constraint(equalTo: rideInfoContainerView.leadingAnchor, constant: ConstraintConstants.leadingPadding),
            seriesTextLabel.trailingAnchor.constraint(equalTo: rideInfoContainerView.trailingAnchor, constant: ConstraintConstants.trailingPadding)
        ])
        seriesTextLabelHeightConstraints?.isActive = false
        seriesTextLabelHeightConstraints = seriesTextLabel.heightAnchor.constraint(equalToConstant: 15)
        seriesTextLabelHeightConstraints?.isActive = true
    }
    
    /// - TAG: A method to setup ride duration label constraints
    private func setupRideDurationLabelConstraints() {
        durationInfoContainerView.addSubview(rideDurationTextLabel)
        NSLayoutConstraint.activate([
            rideDurationTextLabel.topAnchor.constraint(equalTo: durationInfoContainerView.topAnchor),
            rideDurationTextLabel.leadingAnchor.constraint(equalTo: durationInfoContainerView.leadingAnchor),
            rideDurationTextLabel.trailingAnchor.constraint(equalTo: durationInfoContainerView.trailingAnchor),
            rideDurationTextLabel.heightAnchor.constraint(equalTo: durationInfoContainerView.heightAnchor, multiplier: 0.6)
        ])
    }
    
    /// - TAG: A method to setup ride minutes label constraints
    private func setupMinutesLabelConstraints() {
        durationInfoContainerView.addSubview(rideDurationLabel)
        NSLayoutConstraint.activate([
            rideDurationLabel.topAnchor.constraint(equalTo: rideDurationTextLabel.bottomAnchor),
            rideDurationLabel.leadingAnchor.constraint(equalTo: rideDurationTextLabel.leadingAnchor),
            rideDurationLabel.trailingAnchor.constraint(equalTo: rideDurationTextLabel.trailingAnchor),
            rideDurationLabel.bottomAnchor.constraint(equalTo: durationInfoContainerView.bottomAnchor, constant: ConstraintConstants.bottomPadding)
        ])
    }
    /// - TAG: A method to setup way points label constraints
    private func setupWayPointsTextLabelConstraints() {
        addSubview(wayPointsTextLabel)
        NSLayoutConstraint.activate([
            wayPointsTextLabel.topAnchor.constraint(equalTo: rideInfoContainerView.bottomAnchor, constant: ConstraintConstants.topPadding),
            wayPointsTextLabel.leadingAnchor.constraint(equalTo: rideInfoContainerView.leadingAnchor),
            wayPointsTextLabel.trailingAnchor.constraint(equalTo: rideInfoContainerView.trailingAnchor)
        ])
    }
    /// - TAG: A method to setup waypoints tableview constraints
    private func setupWayPointsTableViewConstraints() {
        addSubview(wayPointsTableView)
        NSLayoutConstraint.activate([
            wayPointsTableView.topAnchor.constraint(equalTo: wayPointsTextLabel.bottomAnchor, constant: ConstraintConstants.topPadding),
            wayPointsTableView.leadingAnchor.constraint(equalTo: rideInfoContainerView.leadingAnchor),
            wayPointsTableView.trailingAnchor.constraint(equalTo: rideInfoContainerView.trailingAnchor),
            wayPointsTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: ConstraintConstants.bottomPadding)
        ])
    }
    
    /// - TAG: A method to reset series label height constraints 
    private func resetSeriesLabelHeight() {
        guard let viewModel = viewModel,
              !viewModel.rideIsSeries else { return }
        seriesTextLabelHeightConstraints?.isActive = false
        seriesTextLabelHeightConstraints = seriesTextLabel.heightAnchor.constraint(equalToConstant: 0)
        seriesTextLabelHeightConstraints?.isActive = true
    }
}

extension RideDetailsView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .systemBlue
        renderer.lineWidth = 6.0
        return renderer
    }
}
