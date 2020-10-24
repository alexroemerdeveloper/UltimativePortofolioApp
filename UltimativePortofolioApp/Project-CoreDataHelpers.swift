//
//  Project-CoreDataHelpers.swift
//  UltimativePortofolioApp
//
//  Created by Alexander Römer on 24.10.20.
//

import Foundation

extension Project {
    
    var projectItems: [Item] {
        let itemsArray = items?.allObjects as? [Item] ?? []

        return itemsArray.sorted {
            
            //First filter condition
            if $0.completed == false {
                if $1.completed == true {
                    return true
                }
            } else if $0.completed == true {
                if $1.completed == false {
                    return false
                }
            }

            //Second filter condition
            if $0.priority > $1.priority {
                return true
            } else if $0.priority < $1.priority {
                return false
            }

            //Last filter condition
            return $0.itemCreationDate < $1.itemCreationDate
        }
    }
    
    var completionAmount: Double {
        let originalItems = items?.allObjects as? [Item] ?? []
        guard originalItems.isEmpty == false else { return 0 }
        let completedItems = originalItems.filter(\.completed)
        return Double(completedItems.count) / Double(originalItems.count)
    }
    
    var projectTitle: String {
        title ?? "New Project"
    }

    var projectDetail: String {
        detail ?? ""
    }

    var projectColor: String {
        color ?? "Light Blue"
    }
    
    static var example: Project {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        let project = Project(context: viewContext)
        project.title = "Example Project"
        project.detail = "This is an example project"
        project.closed = true
        project.creationDate = Date()
        return project
    }
}
