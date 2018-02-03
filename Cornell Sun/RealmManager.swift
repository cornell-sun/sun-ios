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
        //attempting to save object to realm for bookmarks
        guard let obj = object as? PostObject else { return }
        let realm = getRealm()
        try! realm.write {
            obj.didSave = true
            obj.bookmarkDate = Date()
            obj.softDelete = false
            if !obj.bookmarkedThisSession {
                obj.bookmarkedThisSession = true
                realm.add(obj)
            }
        }
    }

    func update(object: PostObject, to: Bool) {
        let realm = getRealm()
        try! realm.write {
            object.didSave = to
        }
    }

    func delete(object: Object) {
        guard let obj = object as? PostObject else {
            return
        }
        let realm = getRealm()
        try! realm.write {
            obj.softDelete = true
            obj.didSave = false
            obj.bookmarkDate = nil
        }
    }

    func clearOldBookmarks() {
        let realm = getRealm()
        let objects = realm.objects(PostObject.self).filter("didSave = false")
        try! realm.write {
        realm.delete(objects)
        }
    }

    func get() -> Results<PostObject> {
        let realm = getRealm()
        let objects = realm.objects(PostObject.self).filter("softDelete = false")
        return objects
    }
}
