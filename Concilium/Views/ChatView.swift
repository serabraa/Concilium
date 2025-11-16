//
//  ChatView.swift
//  Concilium
//
//  Created by Sergey on 13.11.25.
//

import SwiftUI

struct ChatView: View {
    
    @FocusState private var isTextFieldFocused: Bool

    @State var messages: [Message] = []
    @State var inputText = ""
    
    @StateObject private var peerService = PeerConnectionService()

    
    
    private func sendMessage(){
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let newMessage = Message(id: UUID(),
                                 text: inputText,
                                 isSentByMe: true,
                                 timestamp: Date())
        messages.append(newMessage)
        peerService.send(newMessage)
        inputText = ""
    }
    
    
    var body: some View {
        VStack{
            ScrollViewReader{ proxy in
                ScrollView{
                    ForEach(messages) { message in
                        MessageBubble(message: message)
                    }
                }
                .onChange(of: messages.count){
                    if let lastID = messages.last?.id{
                        withAnimation{
                            proxy.scrollTo(lastID,anchor: .bottom)
                        }
                    }
                }
            }
            
            
            HStack{
                TextField("Typa a secret...", text: $inputText,axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(1...5)
                    .focused($isTextFieldFocused)
                
                Button
                {
                    sendMessage()
                }label:{
                    Image(systemName: "paperplane.fill")
                        .foregroundStyle(.black)
                        .font(.title2)
                        .padding(10)
                        .background(.brown)
                        .clipShape(.rect(cornerRadius: 12))
                }
                .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .padding()
            .background(.white.opacity(0.1))
        }
        
        .onTapGesture {
            isTextFieldFocused = false
        }

        .onAppear{
            peerService.startAdvertising()
            peerService.startBrowsing()
            
            peerService.onMessageReceived = { message in
                messages.append(message)
            }
            
            peerService.onPeerConnected = { peerName in
                print("Connected with \(peerName)")
            }
        }
        .onDisappear {
            peerService.stop()
        }
    }
}



#Preview {
    ChatView()
        .preferredColorScheme(.dark)
}
