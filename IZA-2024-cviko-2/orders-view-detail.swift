//
//  orders-view-detail.swift
//  IZA-2024-cviko-2
//
//  Created by Martin Hruby on 28.03.2024.
//

import Foundation
import SwiftUI


// ---------------------------------------------------------------------------
// Order je @Observable
struct DetailOnOrderView: View {
    // ale tady budu chtit binding, coz mi dava @Bindable
    @Bindable var order: Order
    
    //
    let escapeAction: (MyNavigationDetail)->()
    
    //
    func odbavZakazku() {
        //
        MainDB.shared.switchToNextState(order: order);
        
        //
        escapeAction(.toOrder(order))
    }
    
    //
    func smazZakazku() {
        //
        MainDB.shared.delete(order: order)
        
        //
        escapeAction(.none)
    }
    
    //
    var body: some View {
        //
        Form {
            //
            Section("Customer") {
                //
                Text(order.customer.name)
            }
            
            Section("Poznamka") {
                //
                TextField("", text: $order.content)
            }
            
            //
            Section("Udalosti") {
                //
                TableRowOnOrderAttr(order: order, label: "Vytvoreni") { order.created.myFormat }
                TableRowOnOrderAttr(order: order, label: "Aktualizovano") { order.updated.myFormat }
            }
            
            //
            Section("Akce") {
                //
                Button(action: smazZakazku) { Text("Smazat") }
                Button(action: odbavZakazku) { Text("Odbavit")}
                
                //
                Text("\(order.citac)")
                Button(action: { order.citac += 1}) { Text("Klik")}
            }
        }
    }
}
