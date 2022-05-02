//
//  Memo.swift
//  PPackMemo
//
//  Created by Hansub Yoo on 2022/04/29.
//

import Foundation
import RealmSwift

// Realm과 구조체 변환 프로토콜
public protocol Persistable {
    associatedtype ManagedObject: RealmSwift.Object
    
    // RealmObject -> Struct
    init(managedObject: ManagedObject)
    
    // Struct -> RealmSwift
    func managedObject() -> ManagedObject
}

// 메모 DB구조
class RealmMemo: Object {
    @Persisted var id: Int              // 키값
    @Persisted var memo: String         // 메모내용
    @Persisted var password: String?    // 패스워드
    @Persisted var isSecret: Bool       // 비밀메모
    
    convenience init(id: Int, content: String, password: String? = nil, isSecret: Bool = false) {
        self.init()
        self.id = id
        self.memo = content
        self.password = password
        self.isSecret = isSecret
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

/// 메모 모델
struct Memo {
    var id: Int             // 키값
    var password: String?   // 암호
    var memo: String        // 내용
    var isSecret: Bool      // 타입
    
    init(id: Int, memo: String, password: String? = nil, isSecret: Bool = false) {
        self.id = id
        self.memo = memo
        self.isSecret = isSecret
        self.password = password
    }
}

extension Memo {
    static let emptyMemo = Memo(id: -1, memo: "")
}

extension Memo: Persistable {
    public init(managedObject: RealmMemo) {
        self.id = managedObject.id
        self.memo = managedObject.memo
        self.password = managedObject.password
        self.isSecret = managedObject.isSecret
    }
    
    public func managedObject() -> RealmMemo {
        let memo = RealmMemo(id: self.id,
                             content: self.memo,
                             password: self.password,
                             isSecret: self.isSecret)
        return memo
    }
    
}
