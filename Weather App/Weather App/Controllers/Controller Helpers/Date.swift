//
//  Date.swift
//  Weather App
//
//  Created by Andrew CP Markham on 25/9/20.
//

import Foundation

extension Date{
    //Date Formatter object
    static let dateFormatter: DateFormatter = {
        ///Function for default date and tiem format in program
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    static let dateOnlyFormatter: DateFormatter = {
        ///Function for default date and tiem format in program
        
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("EEEE MMM d")
        return formatter
    }()

    static func dateFromUTCInt(UTCTimeStamp: Int) -> Date{
        return Date(timeIntervalSince1970: Double(UTCTimeStamp))
    }
}
