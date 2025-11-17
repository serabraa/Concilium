//
//  ConciliumApp.swift
//  Concilium
//
//  Created by Sergey on 13.11.25.
//

import SwiftUI

@main
struct ConciliumApp: App {
    @StateObject private var peerService = PeerConnectionService()
    
    var body: some Scene {
        WindowGroup {
            EntryView()
                .preferredColorScheme(.dark)
        }
    }
}
