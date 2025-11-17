//
//  EntryView.swift
//  Concilium
//
//  Created by Sergey on 17.11.25.
//

import SwiftUI

struct EntryView: View {
    @State private var name = ""
    @State private var proceed = false
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(colors: [.brown.opacity(0.3), .black],
                               startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Spacer()
                    
                    Text("CONCILIUM")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.brown)
                    
                    Image(.mistertwister)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 240)
                        .clipShape(.rect(cornerRadius: 12))
                        .shadow(radius: 8)
                    
                    VStack(spacing: 12) {
                        Text("Enter your name")
                            .font(.headline)
                            .foregroundStyle(.brown)
                        
                        TextField("Some name...", text: $name)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 60)
                            .focused($isTextFieldFocused)
                    }
                    
                    Button {
                        proceed = true
                    } label: {
                        Text("Continue")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(name.trimmingCharacters(in: .whitespaces).isEmpty ? Color.gray.opacity(0.4) : Color.brown)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.horizontal, 80)
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                    
                    Spacer()
                }
                .navigationDestination(isPresented: $proceed) {
                    PeerDiscoveryView(peerService: PeerConnectionService(displayName: name))
                }
            }
        }
    }
}


#Preview {
    EntryView()
}
