//
//  RidesDataModel.swift
//  RideChecker
//
//  Created by Raymond Donkemezuo on 8/12/21.
//

import Foundation
import UIKit
import CoreLocation

struct RidesDataModel: Codable {
    var rides: [Ride]
}
struct Ride: Codable {
    var rideID: Int
    var ride_start_at: String
    var ride_end_at: String
    var ride_cost_in_cent: Int
    var ride_in_series: Bool
    var wayPoints: [WayPoint]
    var estimated_ride_minutes: Int
    var estimated_ride_miles: Double
    enum CodingKeys: String, CodingKey {
        case rideID = "trip_id"
        case ride_start_at = "starts_at"
        case ride_end_at = "ends_at"
        case wayPoints = "ordered_waypoints"
        case ride_cost_in_cent = "estimated_earnings_cents"
        case ride_in_series = "in_series"
        case estimated_ride_miles
        case estimated_ride_minutes
    }
}

struct WayPoint: Codable {
    var id: Int
    var anchor: Bool
    var passengers: [WayPointPassenger]
    var location: WayPointLocationInfo
    var locationCoordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: location.lat, longitude: location.long)
    }
}

struct WayPointPassenger: Codable {
    var passengerID: Int
    var booster_seat: Bool
    var name: String
    enum CodingKeys: String, CodingKey {
        case passengerID = "id"
        case booster_seat
        case name = "first_name"
    }
}
struct WayPointLocationInfo: Codable {
    var address: String
    var lat: Double
    var long: Double
    enum CodingKeys: String, CodingKey {
        case address
        case lat
        case long = "lng"
    }
}


extension RidesDataModel {
    var groupedRides: [String: [Ride]] {
        var groupedRides = [String: [Ride]]()
        for ride in rides {
            if groupedRides[ride.rideGroupTitle] == nil {
                groupedRides[ride.rideGroupTitle] = [ride]
            } else {
                groupedRides[ride.rideGroupTitle]?.append(ride)
            }
        }
        return groupedRides
    }
}


extension Ride {
    var rideStartTime: String {
        return ride_start_at.formattedTime
    }
    
    var rideEndTime: String {
        return ride_end_at.formattedTime
    }
    
    var rideGroupTitle: String {
        return ride_start_at.formattedDateForHeaderviewTitle
    }
    
    var dollarCost: Double {
        return Double(ride_cost_in_cent / 100)
    }
    var totalNumberOfPassengers: Int {
        return wayPoints.map{$0.numberOfPassengers}.reduce(0, +)
    }
    
    var totalNumberOfBoosters: Int {
        return wayPoints.map{$0.numberOfBoosters}.reduce(0, +)
    }
    
    var startingPointCoordinates: CLLocationCoordinate2D {
        guard let firstWayPoint = wayPoints.first else {return CLLocationCoordinate2D(latitude: 0, longitude: 0)}
        return firstWayPoint.locationCoordinate
    }
    
    var endingPointCoordinates: CLLocationCoordinate2D {
        guard let endingWayPoint = wayPoints.last else {return CLLocationCoordinate2D(latitude: 0, longitude: 0)}
        return endingWayPoint.locationCoordinate
    }
}

extension WayPoint {
    var numberOfPassengers: Int {
        return passengers.count
    }
    var numberOfBoosters: Int {
        return passengers.map{$0.booster_seat == true }.count
    }
}
