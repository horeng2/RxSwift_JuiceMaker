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
    
    private let orderViewModel = OrderViewModel()

    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.binding()
    }
    
    private func binding() {
        let input = OrderViewModel.Input(
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
            .map{ String($0) }
            .drive(self.strawberryStockLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.bananaStock
            .map{ String($0) }
            .drive(self.bananaStockLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.pineappleStock
            .map{ String($0) }
            .drive(self.pineappleStockLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.kiwiStock
            .map{ String($0) }
            .drive(self.kiwiStockLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.mangoStock
            .map{ String($0) }
            .drive(self.mangoStockLabel.rx.text)
            .disposed(by: disposeBag)

        output.resultMessage
            .subscribe(onNext: { message in
                self.showAlert(title: "주문 결과", message: message)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateStockLabel(of fruit: Fruit) {
        let updateTarget: UILabel = {
            switch fruit {
            case .strawberry:
                return self.strawberryStockLabel
            case .banana:
                return self.bananaStockLabel
            case .pineapple:
                return self.pineappleStockLabel
            case .kiwi:
                return self.kiwiStockLabel
            case .mango:
                return self.mangoStockLabel
            }
        }()
        
        orderViewModel.fruitStockObservable(of: fruit)
            .map{ String($0) }
            .subscribe(onNext: { stock in
                updateTarget.text = stock
            })
            .disposed(by: disposeBag)
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



