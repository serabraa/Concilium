//
//  MessageBubble.swift
//  Concilium
//
//  Created by Sergey on 13.11.25.
//
import SwiftUI


struct MessageBubble: View {
    
    let message: Message
    
    var body: some View {
        HStack{
            if message.isSentByMe {
                Spacer()
                VStack(alignment: .trailing,spacing: 5)
                {
                    Text(message.text)
                        .padding(10)
                        .background(Color.brown)
                        .cornerRadius(15)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    Text(message.timestamp, style: .time)
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.7))
                }
                    
//                    .frame(maxWidth: 250,alignment: .leading)
            }else{
                VStack(alignment: .leading, spacing: 5){
                    Text(message.text)
                        .padding(10)
                        .background(Color .gray.opacity(0.3))
                        .cornerRadius(15)
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity,alignment: .leading)
                    Text(message.timestamp, style: .time)
                        .font(.caption2)
                        .foregroundColor(.gray)
                    
                }
//                    .frame(maxWidth: 250,alignment: .leading)
                Spacer()
            }
            
        }
        .padding(.horizontal)
        .padding(.vertical,2)
    }
}

#Preview {
    MessageBubble(
        message: Message(
            id: UUID(),
            text: "all work and no play makes sergo a dull boy",
            isSentByMe: true,
            timestamp: Date()
        )
    )
    .preferredColorScheme(.dark)
    
}

