//
//  MemoDatabase.swift
//  PPackMemo
//
//  Created by Hansub Yoo on 2022/04/30.
//

import Foundation
import RealmSwift

class DatabaseManager {
    static let shared = DatabaseManager()
    
    func getAllMemos() -> Results<RealmMemo> {
        let realm = try! Realm()
        
        let memos = realm.objects(RealmMemo.self)
        
        return memos
    }
    
    func add(_ memo: Memo, update: Bool = true) {
        let realm = try! Realm()
        realm.refresh()
        
        let realmMemo = memo.managedObject()
        
        if realm.isInWriteTransaction {
            realm.add(realmMemo, update: .modified)
        } else {
            try? realm.write({
                realm.add(realmMemo, update: .modified)
            })
        }
    }
    
    func add(_ memos: [Memo], update: Bool = true) {
        let realm = try! Realm()
        realm.refresh()
        
        let realmMemos = memos.map { memo in
            memo.managedObject()
        }
        
        if realm.isInWriteTransaction {
            realm.add(realmMemos, update: .modified)
        } else {
            try? realm.write({
                realm.add(realmMemos, update: .modified)
            })
        }
    }
    
    func delete(_ memo: Memo) {
        let realm = try! Realm()
        realm.refresh()
        let realmMemo = realm.objects(RealmMemo.self).filter("id == \(memo.id)")
        
        try? realm.write({
            realm.delete(realmMemo)
        })
    }
    
    func search(_ word: String) -> Results<RealmMemo> {
        let realm = try! Realm()
        realm.refresh()
        
        let memos = realm.objects(RealmMemo.self).filter("memo CONTAINS[c] '\(word)'")
        
        return memos
    }
    
    func getID() -> Int {
        let realm = try! Realm()
        let memos = realm.objects(RealmMemo.self).sorted(byKeyPath: "id")
        return memos.last?.id ?? 0
    }
}
