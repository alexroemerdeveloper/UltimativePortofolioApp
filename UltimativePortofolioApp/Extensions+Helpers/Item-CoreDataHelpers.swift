//
//  Item-CoreDataHelpers.swift
//  UltimativePortofolioApp
//
//  Created by Alexander Römer on 24.10.20.
//
import Foundation
import CloudKit

extension Item {
    
    enum SortOrder {
        case optimized,
             title,
             creationDate
    }
    
    var itemTitle: String {
        title ?? NSLocalizedString("New Item", comment: "Create a new item")
    }
    
    var itemDetail: String {
        detail ?? ""
    }
    
    var itemCreationDate: Date {
        creationDate ?? Date()
    }
    
    static var example: Item {
        let controller = DataController.preview //DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        let item = Item(context: viewContext)
        item.title = "Example Item"
        item.detail = "This is an example item"
        item.priority = 3
        item.creationDate = Date()
        return item
    }
    
}
