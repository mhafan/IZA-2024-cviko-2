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
    let label: String
    
    //
    func action() { citac += 1 }
    
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
            Button(action: { model.action() }) { Text("klik")}
        }
    }
}


//
@Observable class PokusPageEntireModel {
    //
    var list: [PokusModel] = [PokusModel(label: "a"), PokusModel(label: "b")]
    var counter = 0
    var cosi = ""
    
    //
    @ObservationIgnored var _subs: AnyCancellable?
    
    //
    init() {
        //
        _subs = self.list.publisher.sink { v in
            //
            print(v.label)
        }
    }
}

//
struct PokusPage: View {
    //
    @State var list = PokusPageEntireModel()
    
    //
    var body: some View {
        //
        NavigationView {
            //
            List {
                //
                Button(action: { list.list.append(PokusModel(label: "dalsi")) }) {
                    //
                    Text("Dalsi")
                }
                
                //
                Text("Udalosti: \(list.counter)")
                
                //
                ForEach(list.list) { l in
                    //
                    NavigationLink(destination: PokusRow(model: l)) {
                        Text("\(l.label): \(l.citac)")
                    }
                }
            }
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
