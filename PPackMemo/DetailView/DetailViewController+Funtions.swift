//
//  DetailViewController+Funtions.swift
//  PPackMemo
//
//  Created by Hansub Yoo on 2022/05/01.
//

import Foundation
import UIKit

extension DetailViewController {
    @objc func pushEditView(_ barButton: UIBarButtonItem) {
        let editView = EditViewController()
        editView.memo = self.memo
        self.memoView.hero.id = "edit"
        self.navigationController?.pushViewController(editView, animated: true)
    }
    
    @objc func deleteMemo(_ barButton: UIBarButtonItem) {
        DatabaseManager.shared.delete(self.memo)
        self.navigationController?.popToRootViewController(animated: true)
    }
}
