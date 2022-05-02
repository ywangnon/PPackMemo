//
//  MemoLabel.swift
//  PPackMemo
//
//  Created by Hansub Yoo on 2022/04/29.
//

import UIKit
import SnapKit
import Hero

class MemoView: UIView {
    let memoLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .black
        $0.backgroundColor = .systemYellow
        $0.layer.cornerRadius = 20
        
        // 그림자
        $0.layer.shadowOffset = CGSize(width: 10, height: 10)
        $0.layer.shadowRadius = 5
        $0.layer.shadowOpacity = 0.3
        
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.memoLabel)
        
        let safeArea = self.safeAreaLayoutGuide
        
        self.memoLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(safeArea).offset(8)
            make.bottom.trailing.equalTo(safeArea).offset(-8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
