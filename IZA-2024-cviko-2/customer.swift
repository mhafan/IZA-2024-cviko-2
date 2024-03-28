//
//  customer.swift
//  IZA-2024-cviko-2
//
//  Created by Martin Hruby on 28.03.2024.
//

import Foundation

// ---------------------------------------------------------------------------
//
class Customer: Identifiable, MyNotifications, ObservableObject {
    //
    let id: UUID
    
    //
    @Published var name: String {
        //
        willSet {
            //
            notifyMyUpdate()
        }
    }
    
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
