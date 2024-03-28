//
//  orders-views.swift
//  IZA-2024-cviko-2
//
//  Created by Martin Hruby on 28.03.2024.
//

import Foundation
import SwiftUI


// ---------------------------------------------------------------------------
//
class OrdersPageModel: ObservableObject {
    //
    @Published var selectedOrderState: OrderState = .new
    @Published var navigationPath: [MyNavigationDetail] = []
}

// ---------------------------------------------------------------------------
// Primitivni LIST nad selekci zakazek
// ---------------------------------------------------------------------------
// Predpoklada kontext NavigationView
struct ListOfOrdersPlainView<RowContent:View>: View {
    // -----------------------------------------------------------------------
    // zdroj dat
    @ObservedObject var list: QueryOnOrders
    
    // -----------------------------------------------------------------------
    //
    let rowView: (Order) -> RowContent
    
    // -----------------------------------------------------------------------
    // ...
    init(vm: QueryOnOrders, @ViewBuilder rowView: @escaping (Order) -> RowContent)  {
        //
        self._list = ObservedObject(initialValue: vm)
        self.rowView = rowView
    }
    
    // -----------------------------------------------------------------------
    //
    var body: some View {
        // -------------------------------------------------------------------
        // zakladni podoba View
        List {
            //
            ForEach(list.content) { order in
                //
                NavigationLink(value: MyNavigationDetail.toOrder(order)) {
                    //
                    rowView(order)
                }
            }
        }
    }
}

// ---------------------------------------------------------------------------
// Primitivni LIST nad selekci zakazek
// ---------------------------------------------------------------------------
// Predpoklada kontext NavigationView
struct ListOfOrdersView: View {
    // -----------------------------------------------------------------------
    // zdroj dat
    @ObservedObject var list: QueryOnOrders
    @ObservedObject var vm: OrdersPageModel
    
    // -----------------------------------------------------------------------
    // ...
    init(vm: OrdersPageModel) {
        //
        self._list = ObservedObject(initialValue: QueryOnOrders {
            //
            $0.state == vm.selectedOrderState
        })
        
        //
        self._vm = ObservedObject(initialValue: vm)
    }
    
    // -----------------------------------------------------------------------
    //
    var body: some View {
        // -------------------------------------------------------------------
        //
        ListOfOrdersPlainView(vm: list) { order in
            //
            TableRowOnOrderPlain(order: order)
        }
        
        // -------------------------------------------------------------------
        // ...
        .navigationTitle("Zakazky \(vm.selectedOrderState.asLabel)")
        
        // -------------------------------------------------------------------
        // Popis navigace na detail
        .navigationDestination(for: MyNavigationDetail.self) { navItem in
            // vnoreny destination + escape akce
            if case let .toOrder(order) = navItem {
                //
                DetailOnOrderView(order: order) {
                    //
                    if order.state != .dispatched {
                        // navigation-pop
                        let _ = vm.navigationPath.popLast()
                        
                        // zmenim pohled na novy selected-state
                        vm.selectedOrderState = order.state
                        
                        // a volam navigaci na detail
                        vm.navigationPath.append(.toOrder(order))
                    }
                }
            } else {
                //
                EmptyView()
            }
        }
    }
}

// ---------------------------------------------------------------------------
// Prvek TabView
struct OrdersPage: View {
    // -----------------------------------------------------------------------
    // StateObject je v podstate singleton v aplikaci
    @StateObject var vm = OrdersPageModel()
    
    // -----------------------------------------------------------------------
    //
    var body: some View {
        //
        NavigationStack(path: $vm.navigationPath) {
            //
            Picker("Stav zakazky", selection: $vm.selectedOrderState) {
                //
                ForEach(OrderState.allCases, id: \.self) { state in
                    //
                    Text(state.asLabel).tag(state)
                }
            }.pickerStyle(SegmentedPickerStyle())
            
            //
            ListOfOrdersView(vm: vm)
        }
    }
}
