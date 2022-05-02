//
//  MemoCollectionViewCell.swift
//  PPackMemo
//
//  Created by Hansub Yoo on 2022/04/29.
//

import UIKit
import SnapKit
import Hero
import RealmSwift

class MemoCollectionViewCell: UICollectionViewCell {
    static let registerID = "\(MemoCollectionViewCell.self)"
    
    // 뷰
    let memoView = MemoView().then { mv in
        // 폰트
        mv.memoLabel.font = UIFont.FunStory(type: .Bold, size: 16)
        
        mv.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell() {
        // 생성
        self.contentView.addSubview(memoView)
        
        let safeArea = self.contentView.safeAreaLayoutGuide
        
        memoView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(safeArea)
        }
    }
}
