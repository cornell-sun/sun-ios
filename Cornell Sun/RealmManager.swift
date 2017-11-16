//
//  RealmManager.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 11/14/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

final class RealmManager {

    static let instance = RealmManager()

    private func getRealm() -> Realm {
        return try! Realm()
    }

    func save(object: Object) {
        let realm = getRealm()
        try! realm.write {
            realm.add(object)
        }
    }

    func delete(object: Object) {
        let realm = getRealm()
        try! realm.write {
            realm.delete(object)
        }
    }

    func get() -> Results<PostObject> {
        let realm = getRealm()
        let objects = realm.objects(PostObject.self)
        return objects
    }
}
