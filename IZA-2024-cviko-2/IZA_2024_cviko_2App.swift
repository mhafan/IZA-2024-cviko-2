//
//  IZA_2024_cviko_2App.swift
//  IZA-2024-cviko-2
//
//  Created by Martin Hruby on 28.03.2024.
//

import SwiftUI

@main
struct IZA_2024_cviko_2App: App {
    //
    init() {
        //
        DispatchQueue.main.async {
            //
            MainDB.demoContent()
        }
    }
    
    //
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
