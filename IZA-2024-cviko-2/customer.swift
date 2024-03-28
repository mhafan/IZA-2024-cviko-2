//
//  customer.swift
//  IZA-2024-cviko-2
//
//  Created by Martin Hruby on 28.03.2024.
//

import Foundation

// ---------------------------------------------------------------------------
//
@Observable class Customer: Identifiable, MyNotifications {
    //
    let id: UUID
    var name: String
    
    //
    init(name: String) {
        //
        self.id = UUID()
        self.name = name
    }
}

// ---------------------------------------------------------------------------
//
extension Customer: Hashable, Equatable {
    //
    static func == (lhs: Customer, rhs: Customer) -> Bool {
        //
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    //
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
