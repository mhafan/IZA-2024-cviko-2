//
//  ContentView.swift
//  IZA-2024-cviko-2
//
//  Created by Martin Hruby on 28.03.2024.
//

import SwiftUI

//
class PokusModel: ObservableObject {
    //
    @Published var citac = 0
    
    //
    func action() { citac += 1 }
}

//
struct PokusRow: View {
    //
    let label: String
    @StateObject var model = PokusModel()
    
    //
    var body: some View {
        //
        VStack {
            //
            Text(label)
            Text("\(model.citac)")
            Button(action: { model.action() }) { Text("klik")}
        }
    }
}


//
struct PokusPage: View {
    //
    @State var list = ["a", "b", "c"]
    
    //
    var body: some View {
        //
        List {
            //
            Button(action: { list.append("dalsi") }) {
                //
                Text("Dalsi")
            }
            
            //
            ForEach(list, id: \.self) { l in
                //
                PokusRow(label: l)
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
