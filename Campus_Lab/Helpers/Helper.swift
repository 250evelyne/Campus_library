//
//  Helper.swift
//  Campus_Lab
//
//  Created by eve on 2026-02-10.
//

import Foundation

extension Date {
    func asShortDate() -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        return f.string(from: self)
    }
    
    var isOverdue: Bool {
        self < Date()
    }
}
