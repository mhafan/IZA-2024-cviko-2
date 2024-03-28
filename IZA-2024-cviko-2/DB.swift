//
//  DB.swift
//  IZA-2024-cviko-2
//
//  Created by Martin Hruby on 28.03.2024.
//

import Foundation
import Combine
import SwiftUI

// ---------------------------------------------------------------------------
//
extension Notification.Name {
    //
    static let myObjectUpdated = Notification.Name("myObjectUpdated")
}

// ---------------------------------------------------------------------------
//
extension Array where Element:AnyObject {
    //
    mutating func selfUpdate(from: Element) {
        //
        if let _idx = firstIndex(where: { $0 === from }) {
            //
            self[_idx] = self[_idx]
        }
    }
}

// ---------------------------------------------------------------------------
//
class MainDB: ObservableObject {
    // -----------------------------------------------------------------------
    // Pametova varianta obsahu "tabulek"
    @Published var allOrders: [Order] = []
    @Published var allCustomers: [Customer] = []
    
    // -----------------------------------------------------------------------
    // tradicni singleton
    static let shared = MainDB()
    
    // -----------------------------------------------------------------------
    //
    private var _myNotificationsSubs: AnyCancellable?
    
    // -----------------------------------------------------------------------
    // operace ovlivnujici primo allOrders -> generuje na @Published udalost
    func add(newCustomer: Customer) {
        //
        allCustomers.append(newCustomer)
    }
    
    // -----------------------------------------------------------------------
    // operace zapisujici do interniho atributu objektu, kterou vsak NEzaznamena
    // allOrders, nebot Array neni observerem svych prvku
    // --> Observing si musime nasimulovat trikem
    func switchToNextState(order: Order) {
        // overeni vstupnich okolnosti
        guard
            // lze prejit na dalsi stav
            let _newState = order.state.nextState,
            // objekt je prvkem me databaze, a je pritomen na indexu
            // ... porovnavam IDENTITU, tj ===
            // ekvivalent je $0.id == order.id, kde ocekavam unikatnost ID
            let _idx = allOrders.firstIndex(where: { $0 === order })
        else {
            //
            return ;
        }
        
        // provedeni primitivni operace
        order.state = _newState
        order.updated = .now
        
        // timto trikem generuji udalost na @Published
        allOrders[_idx] = allOrders[_idx]
    }
    
    // -----------------------------------------------------------------------
    // ... to same jinak
    func switchToNextStateAlternative(order: Order) {
        // overeni vstupnich okolnosti
        guard
            // lze prejit na dalsi stav
            let _newState = order.state.nextState
        else {
            //
            return ;
        }
        
        // provedeni primitivni operace
        order.state = _newState
        order.updated = .now
        order.notifyMyUpdate()
    }
    
    // -----------------------------------------------------------------------
    // Kdyz se nejaky muj objekt modelu zmeni
    func someMyObjectUpdated(notif: Notification) {
        // pak chci generovat udalost na @Published poli
        if let _order = notif.object as? Order {
            //
            allOrders.selfUpdate(from: _order)
        }
        
        if let _customer = notif.object as? Customer {
            //
            allCustomers.selfUpdate(from: _customer)
        }
    }
    
    // -----------------------------------------------------------------------
    // ... akce na perzistentim ulozistit....
    init() {
        // -------------------------------------------------------------------
        // registruju odposlech na Notifikacnim centru
        _myNotificationsSubs = NotificationCenter.default
            // publisher na tomto kanale
            .publisher(for: Notification.Name.myObjectUpdated)
            .sink { notif in
                //
                self.someMyObjectUpdated(notif: notif)
            }
    }
}


// ---------------------------------------------------------------------------
// vytvoreni demo-dat
extension MainDB {
    //
    static func demoContent() {
        //
        let c1 = Customer(name: "pepa")
        let c2 = Customer(name: "honza")
        
        //
        MainDB.shared.allCustomers = [c1, c2]
        MainDB.shared.allOrders.append(Order(customer: c1, content: "oprava kol"))
        MainDB.shared.allOrders.append(Order(customer: c2, content: "prelakovat auto"))
    }
}


// ---------------------------------------------------------------------------
// "zivy" dotaz nad DB
class QueryOnOrders: ObservableObject {
    // -----------------------------------------------------------------------
    // vysledek dotazu
    @Published var content: [Order] = []
    
    // -----------------------------------------------------------------------
    // ulozeny predikate WHERE
    let predicate: (Order) -> (Bool)
    var _subscription: AnyCancellable?
    
    // -----------------------------------------------------------------------
    // provedeni aktualizace meho selektu
    func update(with: [Order]) {
        //
        content = with
            .filter { self.predicate($0) }
            .basicSorted
    }
    
    // -----------------------------------------------------------------------
    //
    init(predicate: @escaping (Order) -> Bool) {
        //
        self.predicate = predicate
        
        // registruju si SUBS na allOrders, tj prijimam kazdou zpravu
        // o zmene hodnoty
        self._subscription = MainDB.shared.$allOrders.sink { newValueOfArray in
            // ... ktera vsak ma charakter "willChange", tj v tomto okamziku
            // ma @Published allOrders zatim jeste puvodni hodnotu
            self.update(with: newValueOfArray)
        }
        
        // implicitni
        update(with: MainDB.shared.allOrders)
    }
}
