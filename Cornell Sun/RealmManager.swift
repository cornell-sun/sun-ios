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
        guard let obj = object as? PostObject else {
            return
        }
        let realm = getRealm()
        try! realm.write {
            obj.fakeDelete = true
        }
    }

    func get() -> Results<PostObject> {
        let realm = getRealm()
        let objects = realm.objects(PostObject.self).filter("fakeDelete = false")
        return objects
    }
}
