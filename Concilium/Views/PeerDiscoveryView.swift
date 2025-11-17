//
//  PeerDiscoveryView.swift
//  Concilium
//
//  Created by Sergey on 17.11.25.
//

import SwiftUI

struct PeerDiscoveryView: View {
    
    let dummyPeers = ["Mister Sergius", "Sergilion","chundra Mistir","Aspriantus Maxus", "Bakalavr Yoda","Magistr Palpatine","Mister Sdsdergius", "Sergsdsdsdilion","chundsdsdradsds Mistir","Aspriadsdsntus Maxus", "Bakalavdsdr Yoddsdsa","Magistr Padsslpatine"]
    var body: some View {
        VStack(spacing: 4){
            VStack(spacing: 4){
                Text("Nearby Devices")
                    .fontWeight(.bold)
                    .font(.title)
                Text("Tap a device to connect")
                    .fontWeight(.bold)
                    .font(.subheadline)
            }
            .frame(maxWidth: .infinity,minHeight: 100)
            .background(.white.opacity(0.35))
            .clipShape(.rect(cornerRadius: 25))
            .padding(.top,20)

        ScrollView{
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150),spacing: 20)]){
                ForEach(dummyPeers, id:\.self){ peer in
                    Button{
                        print("Tapped on \(peer)")
                    } label: {
                        VStack(spacing: 10){
                            Image(systemName: "iphone")
                                .font(.system(size: 40))
                                .foregroundStyle(.white)
                            Text(peer)
                                .font(.headline)
                                .multilineTextAlignment(.center)
                            }
                        .frame(maxWidth: .infinity,minHeight: 100)
                        .padding()
                        .background(.white.opacity(0.25))
                        .clipShape(.rect(cornerRadius: 20))
                        }
                    .buttonStyle(PressableButtonStyle())
                    }
                }
            
            }
        .padding(.vertical)
        .scrollIndicators(.hidden)
            Text("Searching nearby…")
                .font(.footnote)
                .foregroundStyle(.gray.opacity(0.8))
                .padding(.bottom, 10)

        }
        .padding(.horizontal)
    }
}

struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { oldValue, newValue in
                if newValue {
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                }
            }

    }
}


#Preview {
    PeerDiscoveryView()
}
