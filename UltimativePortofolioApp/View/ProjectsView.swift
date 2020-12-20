//
//  ProjectsView.swift
//  UltimativePortofolioApp
//
//  Created by Alexander Römer on 23.10.20.
//

import SwiftUI

extension ProjectsView {
    var projectsList: some View {
        List {
            ForEach(projects.wrappedValue) { project in
                Section(header: ProjectHeaderView(project: project)) {
                    ForEach(project.projectItems(using: sortOrder)) { item in
                        ItemRowView(project: project, item: item)
                    }
                    .onDelete { offsets in
                        delete(offsets, from: project)
                    }
                    
                    if showClosedProjects == false {
                        Button {
                            addItem(to: project)
                        } label: {
                            Label("Add New Item", systemImage: "plus")
                        }
                    }
                    //ForEach(project.projectItems, content: ItemRowView.init)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    var addProjectToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if showClosedProjects == false {
                Button(action: addProject) {
                    if UIAccessibility.isVoiceOverRunning {
                        Text("Add Project")
                    } else {
                        Label("Add Project", systemImage: "plus")
                    }
                }
            }
        }
    }
    
    var sortOrderToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                showingSortOrder.toggle()
            } label: {
                Label("Sort", systemImage: "arrow.up.arrow.down")
            }
        }
    }
}

struct ProjectsView: View {
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var showingSortOrder = false
    @State private var sortOrder = Item.SortOrder.optimized
    
    let showClosedProjects: Bool
    let projects: FetchRequest<Project>
    static let openTag: String? = "Open"
    static let closedTag: String? = "Closed"
    
    //    let sortingKeyPaths = [
    //        \Item.itemTitle,
    //        \Item.itemCreationDate
    //    ]
    
    //    @State private var sortingKeyPath: PartialKeyPath<Item>?
    //    @State var sortDescriptor: NSSortDescriptor?
    
    init(showClosedProjects: Bool) {
        self.showClosedProjects = showClosedProjects
        projects = FetchRequest<Project>(entity: Project.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)
        ], predicate: NSPredicate(format: "closed = %d", showClosedProjects))
    }
    
    var body: some View {
        NavigationView {
            Group {
                if projects.wrappedValue.count == 0 {
                    Text("There's nothing here right now.")
                        .foregroundColor(.secondary)
                } else {
                    projectsList
                }
            }
            .navigationTitle(showClosedProjects ? "Closed Projects" : "Open Projects")
            .toolbar {
                addProjectToolbarItem
                sortOrderToolbarItem
            }
            .actionSheet(isPresented: $showingSortOrder) {
                
                ActionSheet(title: Text("Sort items"), message: nil, buttons: [
                    .default(Text("Optimized")) { sortOrder = .optimized },
                    .default(Text("Creation Date")) { sortOrder = .creationDate },
                    .default(Text("Title")) { sortOrder = .title }
                ])
                
            }
            
            SelectSomethingView()
        }
    }
    
    
    func addItem(to project: Project) {
        withAnimation {
            let item = Item(context: managedObjectContext)
            item.project = project
            item.creationDate = Date()
            dataController.save()
        }
    }
    
    func delete(_ offsets: IndexSet, from project: Project) {
        let allItems = project.projectItems(using: sortOrder)
        
        for offset in offsets {
            let item = allItems[offset]
            dataController.delete(item)
        }
        
        dataController.save()
    }
    
    func addProject() {
        withAnimation {
            let project = Project(context: managedObjectContext)
            project.closed = false
            project.creationDate = Date()
            dataController.save()
        }
    }
    
    
}

struct ProjectsView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        ProjectsView(showClosedProjects: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}





//                ActionSheet(title: Text("Sort items"), message: nil, buttons: [
//                    .default(Text("Optimized"))     { sortDescriptor = nil },
//                    .default(Text("Creation Date")) { sortDescriptor = NSSortDescriptor(keyPath: \Item.creationDate, ascending: true) },
//                    .default(Text("Title"))         { sortDescriptor = NSSortDescriptor(keyPath: \Item.title, ascending: true) },
//                ])

//                ActionSheet(title: Text("Sort items"), message: nil, buttons: [
//                    .default(Text("Optimized"))     { sortingKeyPath = nil },
//                    .default(Text("Creation Date")) { sortingKeyPath = \Item.itemCreationDate },
//                    .default(Text("Title"))         { sortingKeyPath = \Item.itemTitle }
//                ])

//                ActionSheet(title: Text("Sort items"), message: nil, buttons: [
//                    .default(Text("Optimized")) { sortDescriptor = nil },
//                    .default(Text("Creation Date")) { sortDescriptor = NSSortDescriptor(keyPath: \Item.creationDate, ascending: true) },
//                    .default(Text("Title")) { sortDescriptor = NSSortDescriptor(keyPath: \Item.title, ascending: true) },
//                ])
//    func items(for project: Project) -> [Item] {
//        guard let sortingKeyPath = sortingKeyPath else {
//            return project.projectItemsDefaultSorted
//        }
//
//        return project.projectItems.sorted(by: sortingKeyPath)
//    }

//    func items(for project: Project) -> [Item] {
//        if let sortingKeyPath = sortingKeyPath {
//            if sortingKeyPath == \Item.itemTitle {
//                return project.projectItems.sorted(by: sortingKeyPath, as: String.self)
//            } else if sortingKeyPath == \Item.itemCreationDate {
//                return project.projectItems.sorted(by: sortingKeyPath, as: Date.self)
//            }
//        }
//
//        return project.projectItemsDefaultSorted
//    }

//    func items(for project: Project) -> [Item] {
//        guard let sortDescriptor = sortDescriptor else { return project.projectItemsDefaultSorted }
//        return project.projectItems.sorted(by: sortDescriptor)
//    }

//    func items(for project: Project) -> [Item] {
//        switch sortOrder {
//        case .title:
//            return project.projectItems.sorted { $0.itemTitle < $1.itemTitle }
//        case .creationDate:
//            return project.projectItems.sorted { $0.itemCreationDate < $1.itemCreationDate }
//        case .optimized:
//            return project.projectItemsDefaultSorted
//        }
//    }

//    func projectItems<Value: Comparable>(sortedBy keyPath: KeyPath<Item, Value>) -> [Item] {
//        projectItems.sorted {
//            $0[keyPath: keyPath] < $1[keyPath: keyPath]
//        }
//    }
//
//    func items(for project: Project) -> [Item] {
//        switch sortOrder {
//        case .title:
//            return project.projectItems.sorted(by: \Item.itemTitle)
//        case .creationDate:
//            return project.projectItems.sorted(by: \Item.itemCreationDate)
//        case .optimized:
//            return project.projectItemsDefaultSorted
//        }
//    }
