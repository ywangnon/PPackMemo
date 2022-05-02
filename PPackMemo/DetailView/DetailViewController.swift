//
//  DetailViewController.swift
//  PPackMemo
//
//  Created by Hansub Yoo on 2022/04/30.
//

import UIKit
import SnapKit
import Hero

class DetailViewController: BasicViewController {
    var memo = Memo.emptyMemo
    
    let memoView = MemoView().then { mv in
        mv.memoLabel.numberOfLines = 0
        mv.memoLabel.font = UIFont.FunStory(type: .Bold, size: 32)
        mv.translatesAutoresizingMaskIntoConstraints = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setViewFoundations() {
        self.title = "메모"
        
        // 우측 바버튼 아이템
        let editButton = UIBarButtonItem(image: UIImage(systemName: "pencil.circle"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(self.pushEditView(_:)))
        let deleteButton = UIBarButtonItem(image: UIImage(systemName: "trash.circle"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(self.deleteMemo(_:)))
        
        self.navigationItem.rightBarButtonItems = [deleteButton, editButton]
        self.view.backgroundColor = .white
        
        // 애니메이션 설정
        memoView.isHeroEnabled = true
        memoView.hero.id = "memo"
        
        // 데이터 설정
        let memoModel = MemoViewModel(memo: self.memo)
        memoModel.configure(self.memoView, isDetail: true)
    }
    
    override func setAddSubViews() {
        self.view.addSubview(self.memoView)
    }
    
    override func setLayouts() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        self.memoView.snp.makeConstraints { make in
            make.top.leading.equalTo(safeArea).offset(8)
            make.bottom.trailing.equalTo(safeArea).offset(-8)
        }
    }
}
