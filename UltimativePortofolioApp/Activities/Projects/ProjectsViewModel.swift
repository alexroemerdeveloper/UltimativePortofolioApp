//
//  ProjectsViewModel.swift
//  UltimativePortofolioApp
//
//  Created by Alexander Römer on 27.02.21.
//

import CoreData
import Foundation
import SwiftUI
    
extension ProjectsView {
    
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        
        @Published var showingUnlockView = false

        @Published var projects = [Project]()
        
        var sortOrder           = Item.SortOrder.optimized
        let showClosedProjects  : Bool
        let dataController      : DataController
        
        private let projectsController: NSFetchedResultsController<Project>
        
        init(dataController: DataController, showClosedProjects: Bool) {
            self.dataController     = dataController
            self.showClosedProjects = showClosedProjects
            
            let request: NSFetchRequest<Project> = Project.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)]
            request.predicate = NSPredicate(format: "closed = %d", showClosedProjects)
            
            projectsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            super.init()
            projectsController.delegate = self
            
            do {
                try projectsController.performFetch()
                projects = projectsController.fetchedObjects ?? []
            } catch {
                print("Failed to fetch projects")
            }
        }
        
        func addItem(to project: Project) {
            let item = Item(context: dataController.container.viewContext)
            item.project = project
            item.creationDate = Date()
            item.priority = 2
            item.completed = false
            dataController.save()
        }
        
        func delete(_ offsets: IndexSet, from project: Project) {
            let allItems = project.projectItems(using: sortOrder)
            
            for offset in offsets {
                let item = allItems[offset]
                dataController.delete(item)
            }
            
            dataController.save()
        }
        
//        func addProject() {
//            let canCreate = dataController.fullVersionUnlocked || dataController.count(for: Project.fetchRequest()) < 3
//
//            if canCreate {
//                let project = Project(context: dataController.container.viewContext)
//                project.closed = false
//                project.creationDate = Date()
//                dataController.save()
//            } else {
//                showingUnlockView.toggle()
//            }
//        }
        func addProject() {
            if dataController.addProject() == false {
                showingUnlockView.toggle()
            }
        }
        
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newProjects = controller.fetchedObjects as? [Project] {
                projects = newProjects
            }
        }
        
        
        
    }
}
