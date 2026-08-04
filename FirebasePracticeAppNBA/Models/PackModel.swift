//
//  PackModel.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/3/26.
//

import Foundation

struct PackModel: Identifiable, Hashable {
    let id: String
    let imageName: String
    let displayName: String
}

extension PackModel {
    static let allPacks: [PackModel] = [
        PackModel(id: "pack-1", imageName: "pack-1", displayName: "Pack One"),
        PackModel(id: "pack-2", imageName: "pack-2", displayName: "Pack Two"),
        PackModel(id: "pack-3", imageName: "pack-3", displayName: "Pack Three")
    ]
}
