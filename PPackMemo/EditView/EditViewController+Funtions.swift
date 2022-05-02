//
//  EditViewController+Funtions.swift
//  PPackMemo
//
//  Created by Hansub Yoo on 2022/04/30.
//

import Foundation
import UIKit

extension EditViewController {
    @objc func secretSwitchOn(_ sender: UISwitch) {
        if sender.isOn {
            self.setPassword()
        } else {
            self.password = nil
        }
    }
    
    func setPassword() {
        let alert = UIAlertController(title: "비밀메모",
                                      message: "비밀번호를 입력해주세요",
                                      preferredStyle: .alert)
        alert.addTextField { alertTextField in
            alertTextField.layer.cornerRadius = 10
        }
        let ok = UIAlertAction(title: "OK", style: .default) { action in
            if let password = alert.textFields?[0].text {
                self.password = password
            }
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func save(_ barButton: UIBarButtonItem) {
        // 새로 생성한 메모인지 판단
        let id = self.memo.id == -1 ? DatabaseManager.shared.getID() + 1 : self.memo.id
        let memo = Memo(id: id,
                        memo: self.memoView.text,
                        password: self.password,
                        isSecret: self.secretSwitch.isOn)
        DatabaseManager.shared.add(memo)
        self.navigationController?.popToRootViewController(animated: true)
    }
}
