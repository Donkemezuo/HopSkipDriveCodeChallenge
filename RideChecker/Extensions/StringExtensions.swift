//
//  StringExtensions.swift
//  RideChecker
//
//  Created by Raymond Donkemezuo on 8/13/21.
//

import Foundation
import UIKit


extension String {
    private var convertFromCurrentDateFormat: Date {
        let currentDateFormatter = DateFormatter()
        currentDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let dateInExistingFormat = currentDateFormatter.date(from: self) else
        {
            return Date()
        }
        return dateInExistingFormat
    }
    var formatedDateFromStringWithoutTimeComponent: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy"
        let stringDate = dateFormatter.string(from: convertFromCurrentDateFormat)
        guard let formattedDate = dateFormatter.date(from: stringDate) else
        {
            return Date()
        }
        return formattedDate
    }
    
    var timeComponentOnlyFromDateString: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let stringDate = dateFormatter.string(from: convertFromCurrentDateFormat)
        guard let formattedDate = dateFormatter.date(from: stringDate) else
        {
            return Date()
        }
        return formattedDate
    }
    
    var formattedDateForHeaderviewTitle: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        return dateFormatter.string(from: formatedDateFromStringWithoutTimeComponent)
    }
    var formattedTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm a"
        let time = dateFormatter.string(from: convertFromCurrentDateFormat)
        return time
    }
    
}
