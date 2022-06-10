//
//  ViewController.swift
//  JuiceMaker
//
//  Created by 서녕 on 2022/05/16.
//

import UIKit
import RxSwift
import RxCocoa

class OrderViewController: UIViewController {
    @IBOutlet weak var strawberryStockLabel: UILabel!
    @IBOutlet weak var bananaStockLabel: UILabel!
    @IBOutlet weak var pineappleStockLabel: UILabel!
    @IBOutlet weak var kiwiStockLabel: UILabel!
    @IBOutlet weak var mangoStockLabel: UILabel!
    
    @IBOutlet weak var strawBananaJuiceButton: UIButton!
    @IBOutlet weak var strawKiwiJuiceButton: UIButton!
    @IBOutlet weak var strawberryJuiceButton: UIButton!
    @IBOutlet weak var bananaJuiceButton: UIButton!
    @IBOutlet weak var pineappleJuiceButton: UIButton!
    @IBOutlet weak var kiwiJuiceButton: UIButton!
    @IBOutlet weak var mangoJuiceButton: UIButton!
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.binding()
    }
    
    private func binding() {
        let orderViewModel = OrderViewModel()
        let input = OrderViewModel.Input(
            viewWillAppear: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear(_:))).map{ _ in },
            strawBananaJuiceButtonDidTap: self.strawBananaJuiceButton.rx.tap.asObservable(),
            mangoKiwiJuiceButtonDidTap: self.strawKiwiJuiceButton.rx.tap.asObservable(),
            strawberryJuiceButtonDidTap: self.strawberryJuiceButton.rx.tap.asObservable(),
            bananaJuiceButtonDidTap: self.bananaJuiceButton.rx.tap.asObservable(),
            pineappleJuiceButtonDidTap: self.pineappleJuiceButton.rx.tap.asObservable(),
            kiwiJuiceButtonDidTap: self.kiwiJuiceButton.rx.tap.asObservable(),
            mangoJuiceButtonDidTap: self.mangoJuiceButton.rx.tap.asObservable()
        )
        let output = orderViewModel.transform(input: input)

        output.strawberryStock
            .bind(to: self.strawberryStockLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        output.bananaStock
            .bind(to: self.bananaStockLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        output.pineappleStock
            .bind(to: self.pineappleStockLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        output.kiwiStock
            .bind(to: self.kiwiStockLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        output.mangoStock
            .bind(to: self.mangoStockLabel.rx.text)
            .disposed(by: self.disposeBag)

        output.orderButtonBind
            .subscribe()
            .disposed(by: self.disposeBag)
        
        output.resultMessage
            .bind(onNext: { message in
                self.showAlert(title: "주문 결과", message: message)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true)
    }
    
    @IBAction func moveToEditViewController(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(identifier: "EditViewController") else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}



