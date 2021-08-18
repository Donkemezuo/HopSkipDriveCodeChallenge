//
//  RideCheckerApiClient.swift
//  RideChecker
//
//  Created by Raymond Donkemezuo on 8/12/21.
//

import Foundation
import UIKit


/// - TAG: A method that handles the network request 
final class RideCheckerApiClient {
    static func fetchData(completionHandler: @escaping(Error?, Data?) -> ()) {
        guard let endPointURL = URL(string: "https://storage.googleapis.com/hsd-interview-resources/simplified_my_rides_response.json") else { return;}
        let urlRequest = URLRequest(url: endPointURL)
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (responseData, response, error) in
            if let error = error {
                completionHandler(error, nil)
            } else if let _ = response {
                if let data = responseData {
                    completionHandler(nil, data)
                }
            }
        }
        dataTask.resume()
    }
}
