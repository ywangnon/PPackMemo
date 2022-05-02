//
//  MemoViewModel.swift
//  PPackMemo
//
//  Created by Hansub Yoo on 2022/04/29.
//

import UIKit

class MemoViewModel {
    let memo: Memo
    
    init(memo: Memo) {
        self.memo = memo
    }
    
    var content: String {
        return memo.memo
    }
    
    var isSecret: Bool {
        return memo.isSecret
    }
    
    var password: String? {
        return memo.password
    }
}

extension MemoViewModel {
    func configure(_ view: MemoView, isDetail: Bool = false) {
        // 메모 타입에 따라 보이는 글
        if self.isSecret, !isDetail {
            view.memoLabel.text = "비밀메모입니다."
        } else {
            view.memoLabel.text = content
        }
    }
}
