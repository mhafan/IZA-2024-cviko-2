//
//  MyNotifications.swift
//  IZA-2024-cviko-2
//
//  Created by Martin Hruby on 28.03.2024.
//

import Foundation

//
protocol MyNotifications: AnyObject {
    //
}


//
extension MyNotifications {
    //
    func notifyMyUpdate() {
        //
        NotificationCenter.default.post(name: .myObjectUpdated, object: self)
    }
}
