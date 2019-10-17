//
//  ViewController.swift
//  RxSwiftIn4Hours
//
//  Created by iamchiwon on 21/12/2018.
//  Copyright © 2018 n.code. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class ViewController: UIViewController {
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
    }

    // MARK: - IBOutler

    @IBOutlet var idField: UITextField!
    @IBOutlet var pwField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var idValidView: UIView!
    @IBOutlet var pwValidView: UIView!

    // MARK: - Bind UI

    private func bindUI() {
        // id input +--> check valid --> bullet
        //          |
        //          +--> button enable
        //          |
        // pw input +--> check valid --> bullet
        
        
        
        //
        // Type 1
        //
        
        
        //input - 아이디, 비번 입력
        let idInputOb: Observable<String> =  idField.rx.text.orEmpty.asObservable()
        let idValid = idInputOb.map(checkEmailValid)
        let pwInputOb: Observable<String> =  pwField.rx.text.orEmpty.asObservable()
        let pwValid = pwInputOb.map(checkPasswordValid)
    
        
        //output - 불린,로그인버튼 enable
        
        idValid.subscribe(onNext: { bool in self.idValidView.isHidden = bool })
            .disposed(by: disposeBag)
        
        pwValid.subscribe(onNext: { bool in self.pwValidView.isHidden = bool })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(idValid, pwValid, resultSelector: {s1,s2 in s1 && s2})
            .subscribe(onNext: { bool in self.loginButton.isEnabled = bool })
            .disposed(by: disposeBag)
        
        
        //
        // Type 2
        //
        
        
        
//        idField.rx.text.orEmpty//orEmpty???텍스트 있건 없건.. 옵셔널아니구 걍 string 내려옴
//            //            .filter { $0 != nil }
//            //            .map { $0! }
//            .map(checkEmailValid)
//            .subscribe(onNext: { (bool) in
//                self.idValidView.isHidden = bool
//            })
//            .disposed(by: disposeBag)
//
//        //password
//        pwField.rx.text.orEmpty//orEmpty???텍스트 있건 없건.. 옵셔널아니구 걍 string 내려옴
//            //            .filter { $0 != nil }
//            //            .map { $0! }
//            .map(checkPasswordValid)
//            .subscribe(onNext: { (bool) in
//                self.pwValidView.isHidden = bool
//            })
//            .disposed(by: disposeBag)
//
//        Observable.combineLatest(
//            idField.rx.text.orEmpty.map(checkEmailValid),
//            pwField.rx.text.orEmpty.map(checkPasswordValid),
//            resultSelector: { s1, s2 in s1 && s2 }
//        )
//        .subscribe(onNext: { (bool) in
//            self.loginButton.isEnabled = bool
//        })
//        .disposed(by: disposeBag)
    }

    // MARK: - Logic

    private func checkEmailValid(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }

    private func checkPasswordValid(_ password: String) -> Bool {
        return password.count > 5
    }
}
