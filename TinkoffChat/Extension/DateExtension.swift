//
//  DateExtension.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 08.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation

public extension Date {
    // MARK: Convert to String
    func toHhMmString() -> String {
        let dateformatter = DateFormatter()
        
        if (self.dateBeforeToday()) {
            
            dateformatter.dateFormat = "dd MMM"
            return dateformatter.string(from: self)
        } else {
            
            dateformatter.dateFormat = "hh:mm"
            return dateformatter.string(from: self)
        }
    }
    
    private func dateBeforeToday() -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        let beginDate = Calendar.current.startOfDay(for: self)
        
        return beginDate < today
    }
        
}
