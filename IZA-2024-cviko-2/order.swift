//
//  order.swift
//  IZA-2024-cviko-2
//
//  Created by Martin Hruby on 28.03.2024.
//

import Foundation

// ---------------------------------------------------------------------------
// Stav zakazky -> raw value je INT pro pripadnou lepsi integraci na ulozeni do DB
enum OrderState: Int, CaseIterable {
    //
    case new
    case started
    case finished
    case dispatched
}

// ---------------------------------------------------------------------------
// vylepseni enum
extension OrderState {
    // pro prezentaci v UI
    var asLabel: String {
        //
        switch self {
        case .new: return "Nova"
        case .started: return "Zahajena"
        case .finished: return "Dokoncena"
        case .dispatched: return "Odeslana"
        }
    }
    
    // dalsi stav zakazky
    // kde po .dispatched uz nic nenasleduje
    var nextState: OrderState? {
        //
        switch self {
        case .new: return .started
        case .started: return .finished
        case .finished: return .dispatched
        case .dispatched: return nil
        }
    }
}


// ---------------------------------------------------------------------------
// Datovy model Zakazky
// ---------------------------------------------------------------------------
// Objekt ma byt ucastnikem/prvkem ViewModelu, tj mel by byt bud
// 1) : ObservableObject
// 2) @Observable
@Observable class Order: Identifiable, MyNotifications {
    // ponecham na konstrukci v init()
    // (pro integraci s DB)
    let id: UUID
    
    // ...
    var state: OrderState = .new
    
    //
    let created: Date
    var updated: Date
    let customer: Customer
    var content: String {
        //
        didSet { notifyMyUpdate() }
    }
    
    // debug
    var citac = 0 {
        //
        didSet { notifyMyUpdate() }
    }
    
    //
    init(customer: Customer, content: String) {
        //
        self.id = UUID()
        self.created = .now
        self.updated = .now
        
        //
        self.customer = customer
        self.content = content
    }
}

// ---------------------------------------------------------------------------
//
extension Array where Element == Order {
    //
    var basicSorted: [Order] {
        //
        self.sorted { $0.updated > $1.updated }
    }
}


// ---------------------------------------------------------------------------
//
extension Order: Hashable, Equatable {
    //
    static func == (lhs: Order, rhs: Order) -> Bool {
        //
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    //
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
