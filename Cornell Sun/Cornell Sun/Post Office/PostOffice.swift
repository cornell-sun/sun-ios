//
//  PostOffice.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 11/14/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import Foundation

//Called PostOffice because it handles PostObjects
final class PostOffice: NSObject {

    static let instance = PostOffice()
    @objc dynamic var packages: [PostObject]
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private let packagesKey = "packages" //key for saving post objects

    override init() {
        self.packages = []
        super.init()
        self.packages = get() ?? []
    }

    func get() -> [PostObject]? {
        guard let packageData = UserDefaults.standard.data(forKey: packagesKey) else { return nil }
        let packages = try? decoder.decode([PostObject].self, from: packageData)
        return packages
    }

    /// attempts to store the object
    /// - Returns: true if store is successful else false
    func store(object: PostObject) -> Bool {
        object.storeDate = Date()
        object.didSave = true
        packages.append(object)
        let success = shipToStorage(packages: packages)
        return success
    }

    /// attempts to remove the object
    /// - Returns: true if remove is successful else false
    func remove(object: PostObject) -> Bool {
        object.storeDate = nil
        object.didSave = false
        packages = packages.filter { $0.id != object.id }
        let success = shipToStorage(packages: packages)
        return success
    }

    /// attempts to store the new list of objects
    /// - Returns: true if storage is successful else false
    private func shipToStorage(packages: [PostObject]) -> Bool {
        guard let encodedPackages = try? encoder.encode(packages) else { return false }
        UserDefaults.standard.set(encodedPackages, forKey: packagesKey)
        return true
    }
}
