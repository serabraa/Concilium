//
//  Message.swift
//  Concilium
//
//  Created by Sergey on 13.11.25.
//

import Foundation

struct Message : Identifiable, Codable, Hashable{
    let id: UUID
    let text: String
    var isSentByMe: Bool
    let timestamp: Date
}
