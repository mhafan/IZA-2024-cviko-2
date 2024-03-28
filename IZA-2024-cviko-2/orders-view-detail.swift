//
//  orders-view-detail.swift
//  IZA-2024-cviko-2
//
//  Created by Martin Hruby on 28.03.2024.
//

import Foundation
import SwiftUI


// ---------------------------------------------------------------------------
//
struct DetailOnOrderView: View {
    //
    @Bindable var order: Order
    
    //
    let escapeAction: ()->()
    
    //
    func odbavZakazku() {
        //
        MainDB.shared.switchToNextState(order: order);
        
        //
        escapeAction()
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
                Button(action: {}) { Text("Smazat") }
                Button(action: odbavZakazku) { Text("Odbavit")}
                
                //
                Text("\(order.citac)")
                Button(action: { order.citac += 1}) { Text("Klik")}
            }
        }
    }
}
