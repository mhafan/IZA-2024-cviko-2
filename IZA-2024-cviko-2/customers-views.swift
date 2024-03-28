//
//  customers-views.swift
//  IZA-2024-cviko-2
//
//  Created by Martin Hruby on 28.03.2024.
//

import Foundation
import SwiftUI

// ---------------------------------------------------------------------------
// Detail pohledu na Customer
struct CustomerDetailView: View {
    // ... observing
    @Bindable var customer: Customer
    
    // -----------------------------------------------------------------------
    //
    var body: some View {
        //
        Form {
            //
            Section("Name") {
                //
                TextField("Jmeno:", text: $customer.name)
            }
            
            //
            Section("Zakazky") {
                //
                ListOfOrdersPlainView(vm: QueryOnOrders(predicate: { $0.customer.id == customer.id })) {
                    //
                    TableRowOnOrderStructured(order: $0)
                }
            }
        }
    }
}

// ---------------------------------------------------------------------------
// Navigation klic
enum MyNavigationDetail: Hashable {
    //
    case toCustomer(Customer)
    case toOrder(Order)
}

// ---------------------------------------------------------------------------
//
struct AllCustomersPage: View {
    // -----------------------------------------------------------------------
    //
    @ObservedObject var db = MainDB.shared
    
    // -----------------------------------------------------------------------
    //
    @State var navigationStack: [MyNavigationDetail] = []
    
    // -----------------------------------------------------------------------
    //
    func addNew() {
        //
        let nc = Customer(name: "newOne")
        
        //
        db.add(newCustomer: nc)
        navigationStack.append(.toCustomer(nc))
    }
    
    // -----------------------------------------------------------------------
    //
    var body: some View {
        //
        NavigationStack(path: $navigationStack) {
            //
            List {
                //
                ForEach(db.allCustomers) { customer in
                    //
                    NavigationLink(value: MyNavigationDetail.toCustomer(customer)) {
                        Text(customer.name)
                    }
                }
            }
            
            //
            .navigationTitle("Prehled zakazniku")
            .toolbar {
                //
                Button(action: addNew) { Image(systemName: "plus")}
            }
            
            //
            .navigationDestination(for: MyNavigationDetail.self) { value in
                //
                switch value {
                case let .toCustomer(whatCustomer):
                    CustomerDetailView(customer: whatCustomer)
                default:
                    EmptyView()
                }
            }
        }
    }
}
