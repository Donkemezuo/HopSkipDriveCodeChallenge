//
//  DataManager.swift
//  RideChecker
//
//  Created by Raymond Donkemezuo on 8/12/21.
//

import Foundation
import UIKit
/// - TAG: A class that handles the data manipulation 
class DataManager {
    var groupedRides = [String: [Ride]]()
    
    func fetchRides(completionHandler: @escaping(Error?) -> ()) {
        RideCheckerApiClient.fetchData { (error, data) in
            if let error = error {
                completionHandler(error)
            } else if let remoteData = data {
                do {
                    let ridesDataModel = try JSONDecoder().decode(RidesDataModel.self, from: remoteData)
                    self.groupedRides = ridesDataModel.groupedRides
                    completionHandler(nil)
                } catch {
                    completionHandler(error)
                }
            }
        }
    }
}

extension DataManager {
    
    var rideDaysForSectionHeaderTitles: [String] {
        let groupedRideKeys = Array(groupedRides.keys)
        return groupedRideKeys.sorted{$0.formatedDateFromStringWithoutTimeComponent < $1.formatedDateFromStringWithoutTimeComponent}
    }
    
    func getRidesForSelectedDay(_ dayIndex: Int) -> [Ride] {
        let day = rideDaysForSectionHeaderTitles[dayIndex]
        guard let ridesForDay = groupedRides[day] else { return [] }
        return ridesForDay
    }
    
    func getNumberOfRidesForSelectedDay(_ dayIndex: Int) -> Int {
        return getRidesForSelectedDay(_: dayIndex).count
    }
    func getNameOfSelectedRideDay(_ dayIndex: Int) -> String {
        return rideDaysForSectionHeaderTitles[dayIndex]
    }
    
    func getDayFirstRideStartTime(_ dayIndex: Int) -> String {
        let ridesForSelectedDay = getRidesForSelectedDay(_: dayIndex).sorted(by: {$0.ride_start_at.timeComponentOnlyFromDateString < $1.ride_start_at.timeComponentOnlyFromDateString})
        guard let firstRide = ridesForSelectedDay.first else {return ""}
        return firstRide.rideStartTime.lowercased()
    }
    
    func getDayLastRideEndTime(_ dayIndex: Int) -> String {
        let ridesForSelectedDay = getRidesForSelectedDay(_: dayIndex).sorted(by: {$0.ride_start_at.timeComponentOnlyFromDateString < $1.ride_start_at.timeComponentOnlyFromDateString})
        guard let firstRide = ridesForSelectedDay.last else {return ""}
        return firstRide.rideEndTime.lowercased()
    }
    func getDayRidesTotal(_ dayIndex: Int) -> Double {
        let ridesForSelectedDay = getRidesForSelectedDay(_: dayIndex)
        return ridesForSelectedDay.map{$0.dollarCost}.reduce(0, +)
    }
}
