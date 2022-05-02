//
//  ViewController.swift
//  PPackMemo
//
//  Created by Hansub Yoo on 2022/04/29.
//

import UIKit
import Then
import ViewAnimator
import SnapKit
import Lottie
import Hero
import SwiftUI

class ViewController: BasicViewController {
    let searchBar = UISearchBar().then { sb in
        sb.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let memoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then { cv in
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        cv.collectionViewLayout = layout
        cv.register(MemoCollectionViewCell.self, forCellWithReuseIdentifier: MemoCollectionViewCell.registerID)
        cv.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var memoViewModels: [MemoViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for family in UIFont.familyNames {
          print(family)

          for sub in UIFont.fontNames(forFamilyName: family) {
            print("====> \(sub)")
          }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 데이터 베이스 읽어옴
        self.memoViewModels = DatabaseManager.shared.getAllMemos().map({
            return MemoViewModel(memo: Memo.init(managedObject: $0))
        })
        
        // 애니메이션
        let cells = memoCollectionView.visibleCells(in: 0)
        let animations = [AnimationType.vector(CGVector(dx: 0, dy: 30))]
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.memoCollectionView.reloadData()
            self.memoCollectionView.performBatchUpdates({
                UIView.animate(views: cells, animations: animations)
            }, completion: nil)
        }
    }
    
    override func setViewFoundations() {
        self.title = "빡메모"
        
        // 타이틀 설정
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.red,
            .font: UIFont.BM(type: .Regular, size: 32)
        ]
        
        // 우측 바버튼 아이템
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "pencil.circle"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(self.pushEditView(_:)))
        self.navigationController?.navigationBar.tintColor = .black
        // 애니메이션 활성화
        self.navigationController?.isHeroEnabled = true
        
        // 기능을 누가 사용하는지?
        self.memoCollectionView.delegate = self
        // 데이터 제공자는 누구인지?
        self.memoCollectionView.dataSource = self
        // 기능을 누가 사용하는지?
        self.searchBar.delegate = self
        
        self.searchBar.addDoneButton()
    }
    
    override func setAddSubViews() {
        self.view.addSubview(self.searchBar)
        self.view.addSubview(self.memoCollectionView)
    }
    
    override func setLayouts() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        self.searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeArea).offset(8)
            make.leading.equalTo(safeArea).offset(8)
            make.trailing.equalTo(safeArea).offset(-8)
//            make.height.equalTo(safeArea).offset(48)
        }
        
        self.memoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.searchBar.snp.bottom).offset(8)
            make.bottom.leading.trailing.equalTo(safeArea)
        }
    }
    
//    override func setAddTargets() {
//        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(self.keyboardDismissTap))
//        self.searchBar.addGestureRecognizer(dismissTap)
//    }
}

// 기능 설정
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        
        let memoViewModel = self.memoViewModels[indexPath.row]
        guard let cell = collectionView.cellForItem(at: indexPath) as? MemoCollectionViewCell else { return }
        print("선택한 인덱스", indexPath)
        cell.memoView.isHeroEnabled = true
        cell.memoView.heroID = "memo"
        
        if memoViewModel.isSecret {
            // 비밀메모
            self.checkPassword(memoViewModel.memo)
        } else {
            // 일반메모
            let vc = DetailViewController()
            vc.memo = memoViewModel.memo
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}

// 데이터 설정
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memoViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemoCollectionViewCell.registerID, for: indexPath) as? MemoCollectionViewCell else {
            return UICollectionViewCell()
        }
        self.memoViewModels[indexPath.row].configure(cell.memoView)
        cell.memoView.heroID = nil
        print("셀 생성 \(indexPath), heroID \(cell.memoView.memoLabel.heroID)")
        return cell
    }
}

// 진행방향 설정
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.safeAreaLayoutGuide.layoutFrame.size.width - (3 * 4)) / 3
        
        let size = CGSize(width: width, height: width)
        
        return size
    }
}

// Funtions
extension ViewController {
    @objc func pushEditView(_ barButton: UIBarButtonItem) {
        let editView = EditViewController()
        self.navigationController?.pushViewController(editView, animated: true)
    }
    
    func checkPassword(_ memo: Memo) {
        let alert = UIAlertController(title: "비밀메모",
                                      message: "비밀번호를 입력해주세요",
                                      preferredStyle: .alert)
        alert.addTextField { alertTextField in
            alertTextField.layer.cornerRadius = 10
        }
        
        let ok = UIAlertAction(title: "OK", style: .default) { action in
            if let inputPassword = alert.textFields?[0].text,
               let memoPassword = memo.password,
               inputPassword == memoPassword {
                let vc = DetailViewController()
                vc.memo = memo
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                alert.textFields?[0].textColor = .systemRed
            }
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
//    @objc func keyboardDismissTap() {
//        print("Tap")
//        if self.searchBar.isFirstResponder {
//            print("responder")
//            self.searchBar.endEditing(true)
//        }
//    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 데이터 베이스 읽어옴
        if searchText != "" {
            self.memoViewModels = DatabaseManager.shared.search(searchText).map({
                return MemoViewModel(memo: Memo.init(managedObject: $0))
            })
        } else {
            self.memoViewModels = DatabaseManager.shared.getAllMemos().map({
                return MemoViewModel(memo: Memo.init(managedObject: $0))
            })
        }
        self.memoCollectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
}
