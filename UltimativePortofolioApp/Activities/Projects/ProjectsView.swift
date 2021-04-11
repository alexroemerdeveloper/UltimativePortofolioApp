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
            ForEach(viewModel.projects) { project in
                Section(header: ProjectHeaderView(project: project)) {
                    ForEach(project.projectItems(using: viewModel.sortOrder)) { item in
                        ItemRowView(project: project, item: item)
                    }
                    .onDelete { offsets in
                        viewModel.delete(offsets, from: project)
                    }
                    
                    if viewModel.showClosedProjects == false {
                        Button {
                            withAnimation {
                                viewModel.addItem(to: project)
                            }
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
            if viewModel.showClosedProjects == false {
                Button {
                    withAnimation {
                        viewModel.addProject()
                    }
                } label: {
                    
                    if UIAccessibility.isVoiceOverRunning {
                        // In iOS 14.3 VoiceOver has a glitch that reads the label
                        // "Add Project" as "Add" no matter what accessibility label
                        // we give this button when using a label. As a result, when
                        // VoiceOver is running we use a text view for the button instead,
                        // forcing a correct reading without losing the original layout.
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

    @StateObject var viewModel: ViewModel
    
    @State private var showingSortOrder = false
    static let openTag: String? = "Open"
    static let closedTag: String? = "Closed"
    
    //    let sortingKeyPaths = [
    //        \Item.itemTitle,
    //        \Item.itemCreationDate
    //    ]
    
    //    @State private var sortingKeyPath: PartialKeyPath<Item>?
    //    @State var sortDescriptor: NSSortDescriptor?
    init(dataController: DataController, showClosedProjects: Bool) {
        let viewModel = ViewModel(dataController: dataController, showClosedProjects: showClosedProjects)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.projects.isEmpty {
                    Text("There's nothing here right now.")
                        .foregroundColor(.secondary)
                } else {
                    projectsList
                }
            }
            .navigationTitle(viewModel.showClosedProjects ? "Closed Projects" : "Open Projects")
            .toolbar {
                addProjectToolbarItem
                sortOrderToolbarItem
            }
            .actionSheet(isPresented: $showingSortOrder) {
                
                ActionSheet(title: Text("Sort items"), message: nil, buttons: [
                    .default(Text("Optimized")) { viewModel.sortOrder = .optimized },
                    .default(Text("Creation Date")) { viewModel.sortOrder = .creationDate },
                    .default(Text("Title")) { viewModel.sortOrder = .title }
                ])
                
            }
            
            SelectSomethingView()
        }
        .sheet(isPresented: $viewModel.showingUnlockView) {
            UnlockView()
        }
    }
    
    
    
    
}

struct ProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsView(dataController: DataController.preview, showClosedProjects: false)
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
