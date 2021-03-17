//
//  HomeView.swift
//  UltimativePortofolioApp
//
//  Created by Alexander Römer on 23.10.20.
//

import SwiftUI
import CoreData

struct HomeView: View {
    
    @StateObject var viewModel: ViewModel
    static let tag: String? = "Home"
    
    var projectRows: [GridItem] {
        [GridItem(.fixed(100))]
    }
    
    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: projectRows) {
                            ForEach(viewModel.projects, content: ProjectSummaryView.init)
                        }
                        .padding([.horizontal, .top])
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    VStack(alignment: .leading) {
                        ItemListView(title: "Up next", items: viewModel.upNext)
                        ItemListView(title: "More to explore", items: viewModel.moreToExplore)
                    }
                    .padding(.horizontal)
                    
                }
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("Home")
            .toolbar {
                Button("Add Data", action: viewModel.addSampleData)
            }
        }
    }
    
    
    //    @ViewBuilder func list(_ title: LocalizedStringKey, for items: FetchedResults<Item>.SubSequence) -> some View {
    //        if items.isEmpty {
    //            EmptyView()
    //        } else {
    //            Text(title)
    //                .font(.headline)
    //                .foregroundColor(.secondary)
    //                .padding(.top)
    //
    //            ForEach(items) { item in
    //                NavigationLink(destination: EditItemView(item: item)) {
    //                    HStack(spacing: 20) {
    //                        Circle()
    //                            .stroke(Color(item.project?.projectColor ?? "Light Blue"), lineWidth: 3)
    //                            .frame(width: 44, height: 44)
    //
    //                        VStack(alignment: .leading) {
    //                            Text(item.itemTitle)
    //                                .font(.title2)
    //                                .foregroundColor(.primary)
    //                                .frame(maxWidth: .infinity, alignment: .leading)
    //
    //                            if item.itemDetail.isEmpty == false {
    //                                Text(item.itemDetail)
    //                                    .foregroundColor(.secondary)
    //                            }
    //                        }
    //                    }
    //                    .padding()
    //                    .background(Color.secondarySystemGroupedBackground)
    //                    .cornerRadius(10)
    //                    .shadow(color: Color.black.opacity(0.2), radius: 5)
    //                }
    //
    //            }
    //        }
    //    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(dataController: .preview)
    }
}
