//
//  EditViewController.swift
//  PPackMemo
//
//  Created by Hansub Yoo on 2022/04/30.
//

import UIKit
import Hero
import SnapKit

class EditViewController: BasicViewController {
    /// 비밀메모 활성화 버튼이 들어가는 공간
    let secretView = UIView().then { sv in
        sv.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let secretLabel = UILabel().then { sl in
        sl.text = "비밀메모"
        sl.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let secretSwitch = UISwitch().then { st in
        st.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let countLabel = UILabel().then { cl in
        cl.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let memoView = UITextView().then { mv in
        mv.backgroundColor = .systemYellow
        
        mv.font = UIFont.FunStory(type: .Bold, size: 16)
        
        mv.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var memo = Memo.emptyMemo   // 메모
    var password: String?       // 비밀번호

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.memoView.isHeroEnabled = true
        self.memoView.hero.id = "edit"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func setViewFoundations() {
        self.title = "편집"
        
        self.view.backgroundColor = .white
        
        self.secretSwitch.isOn = self.memo.isSecret
        self.memoView.text = self.memo.memo
        self.countLabel.text = "글자 수 \(self.memoView.text.count)"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.circle"),
                                                                 style: .done,
                                                                 target: self,
                                                                 action: #selector(self.save(_:)))
        
        self.memoView.delegate = self
    }
    
    override func setAddSubViews() {
        self.view.addSubview(self.secretView)
        self.secretView.addSubview(self.secretLabel)
        self.secretView.addSubview(self.secretSwitch)
        self.view.addSubview(self.countLabel)
        self.view.addSubview(self.memoView)
    }
    
    override func setLayouts() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        self.secretView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeArea)
            make.height.equalTo(80)
        }
        
        self.secretLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.secretView).offset(16)
            make.centerY.equalTo(self.secretView)
        }
        self.secretLabel.sizeToFit()
        
        self.secretSwitch.snp.makeConstraints { make in
            make.trailing.equalTo(self.secretView).offset(-16)
            make.centerY.equalTo(self.secretView)
        }
        
        self.countLabel.snp.makeConstraints { make in
            make.top.equalTo(self.secretView.snp.bottom).offset(8)
            make.leading.equalTo(safeArea).offset(16)
        }
        self.countLabel.sizeToFit()
        
        self.memoView.snp.makeConstraints { make in
            make.top.equalTo(self.countLabel.snp.bottom).offset(8)
            make.leading.equalTo(safeArea).offset(16)
            make.trailing.equalTo(safeArea).offset(-16)
            make.bottom.equalTo(safeArea).offset(-16)
        }
    }
    
    override func setAddTargets() {
        self.secretSwitch.addTarget(self, action: #selector(self.secretSwitchOn(_:)), for: .valueChanged)
    }
}

extension EditViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        self.countLabel.text = "글자 수 \(changedText.count)"
        return true
    }
}
