//
//  ChatMessage.swift
//  ChatMessage
//
//  Created by Alexander Römer on 23.08.21.
//

import Foundation
import CloudKit

struct ChatMessage: Identifiable {
    let id: String
    let from: String
    let text: String
    let date: Date
}

//If you want both the memberwise initializer and your custom initializer, just move the custom one to an extension, like this:
extension ChatMessage {
    init(from record: CKRecord) {
        id = record.recordID.recordName
        from = record["from"] as? String ?? "No author"
        text = record["text"] as? String ?? "No text"
        date = record.creationDate ?? Date()
    }
}
