//
//  ContentView.swift
//  IZA-2024-cviko-2
//
//  Created by Martin Hruby on 28.03.2024.
//

import SwiftUI
import Observation
import Combine

//
@Observable class PokusModel : Identifiable {
    //
    let id = UUID()
    var citac = 0
    var label: String
    
    //
    func action() { citac += 1 }
    
    //
    init(label: String) {
        self.label = label
    }
}

//
struct PokusRow: View {
    //
    @Bindable var model: PokusModel
    
    //
    var body: some View {
        //
        VStack {
            //
            Text(model.label)
            Text("\(model.citac)")
            TextField("dddjd", text: $model.label)
            Button(action: { model.action() }) { Text("klik")}
        }
    }
}


//
@Observable class PokusPageEntireModel {
    //
    var list: [PokusModel] = [PokusModel(label: "a"), PokusModel(label: "bb")]
    var found: [PokusModel] = []
    var counter = 0
    var cosi = ""
    var search = ""
    
    //
    func update() {
        //
        found = list.filter { $0.label.count <= search.count }
    }
    
    //
    init() {
    
    }
}

//
struct Subp: View {
    //
    @Environment(PokusPageEntireModel.self) var model
    
    //
    var body: some View {
        //
        List(model.found) { i in Text(i.label) }
    }
}

//
struct PokusPage: View {
    //
    @State var list = PokusPageEntireModel()
    
    //
    var body: some View {
        //
        VStack {
            //
            TextField("search", text: $list.search)
                .onChange(of: list.search) {
                    //
                    list.update()
                }
            
            ///
            Subp().environment(list)
        }
    }
}

//
struct ContentView: View {
    var body: some View {
        //
        TabView {
            //
            OrdersPage().tabItem {
                //
                Text("Orders")
            }
            
            //
            AllCustomersPage().tabItem {
                //
                Text("Customers")
            }
            
            //
            PokusPage().tabItem {
                //
                Text("Pokusy")
            }
        }
    }
}

#Preview {
    ContentView()
}
