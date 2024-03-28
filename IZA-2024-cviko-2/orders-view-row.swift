//
//  orders-view-row.swift
//  IZA-2024-cviko-2
//
//  Created by Martin Hruby on 28.03.2024.
//


import Foundation
import SwiftUI


// ---------------------------------------------------------------------------
//
struct TableRowOnOrderAttr: View {
    //
    @Bindable var order: Order
    let label: String
    let value: () -> String
    
    //
    var body: some View {
        //
        HStack {
            //
            Text(label); Spacer()
            Text(value())
        }
    }
}

// ---------------------------------------------------------------------------
//
struct TableRowOnOrderPlain: View {
    //
    @Bindable var order: Order
    
    //
    var body: some View {
        //
        VStack(alignment: .leading) {
            //
            Text(order.customer.name).font(.largeTitle)
            Text(order.content)
        }
    }
}

// ---------------------------------------------------------------------------
//
struct TableRowOnOrderStructured: View {
    //
    @Bindable var order: Order
    
    //
    var body: some View {
        //
        VStack {
            //
            TableRowOnOrderAttr(order: order, label: "Stav") { order.state.asLabel }
            TableRowOnOrderAttr(order: order, label: "Prijato") { order.created.myFormat }
            TableRowOnOrderAttr(order: order, label: "Zmena") { order.updated.myFormat }
        }
    }
}


// ---------------------------------------------------------------------------
//
extension Date {
    //
    var myFormat: String {
        //
        self.formatted(date: .numeric, time: .shortened)
    }
}
