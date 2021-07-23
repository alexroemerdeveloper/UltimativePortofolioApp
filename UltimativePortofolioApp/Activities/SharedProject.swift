//
//  SharedProject.swift
//  UltimativePortofolioApp
//
//  Created by Alexander Römer on 23.07.21.
//

import Foundation

struct SharedProject: Identifiable {
    let id: String
    let title: String
    let detail: String
    let owner: String
    let closed: Bool

    static let example = SharedProject(id: "1", title: "Example", detail: "Detail", owner: "TwoStraws", closed: false)
}

struct SharedItem: Identifiable {
    let id: String
    let title: String
    let detail: String
    let completed: Bool
}

enum LoadState {
    case inactive, loading, success, noResults
}
