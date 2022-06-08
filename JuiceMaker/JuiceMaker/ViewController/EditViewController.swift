//
//  EditViewController.swift
//  JuiceMaker
//
//  Created by 서녕 on 2022/05/23.
//

import UIKit
import RxSwift

class EditViewController: UIViewController {
    @IBOutlet weak var strawberryStockLabel: UILabel!
    @IBOutlet weak var bananaStockLabel: UILabel!
    @IBOutlet weak var pineappleStockLabel: UILabel!
    @IBOutlet weak var kiwiStockLabel: UILabel!
    @IBOutlet weak var mangoStockLabel: UILabel!
    
    @IBOutlet weak var strawberryStepper: UIStepper!
    @IBOutlet weak var bananaStepper: UIStepper!
    @IBOutlet weak var pineappleStepper: UIStepper!
    @IBOutlet weak var kiwiStepper: UIStepper!
    @IBOutlet weak var mangoStepper: UIStepper!
        
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.binding()
    }
    
    private func binding() {
        let editViewModel = EditViewModel()
        let input = EditViewModel.Input(
            viewWillAppear: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear(_:))).map{ _ in },
            strawberryStepperDidTap: self.strawberryStepper.rx.value.asObservable(),
            bananaStepperDidTap: self.bananaStepper.rx.value.asObservable(),
            pineappleStepperDidTap: self.pineappleStepper.rx.value.asObservable(),
            kiwiStepperDidTap: self.kiwiStepper.rx.value.asObservable(),
            mangoStepperDidTap: self.mangoStepper.rx.value.asObservable()
        )
        let output = editViewModel.transform(input: input)
        
        output.strawberryStock
            .bind(onNext: { stock in
                self.strawberryStockLabel.text = String(stock)
                self.strawberryStepper.value = Double(stock)
            })
            .disposed(by: self.disposeBag)

        output.bananaStock
            .bind(onNext: { stock in
                self.bananaStockLabel.text = String(stock)
                self.bananaStepper.value = Double(stock)
            })
            .disposed(by: self.disposeBag)
        
        output.pineappleStock
            .bind(onNext: { stock in
                self.pineappleStockLabel.text = String(stock)
                self.pineappleStepper.value = Double(stock)
            })
            .disposed(by: self.disposeBag)
        
        output.kiwiStock
            .bind(onNext: { stock in
                self.kiwiStockLabel.text = String(stock)
                self.kiwiStepper.value = Double(stock)
            })
            .disposed(by: self.disposeBag)
        
        output.mangoStock
            .bind(onNext: { stock in
                self.mangoStockLabel.text = String(stock)
                self.mangoStepper.value = Double(stock)
            })
            .disposed(by: self.disposeBag)
        
        output.limitStockAlertMessage
            .subscribe(onNext: { message in
                self.showAlert(title: "알림", message: message)
            })
            .disposed(by: self.disposeBag)
        
        output.stepperMinimumValue
            .bind(to: self.strawberryStepper.rx.minimumValue,
                  self.bananaStepper.rx.minimumValue,
                  self.pineappleStepper.rx.minimumValue,
                  self.kiwiStepper.rx.minimumValue,
                  self.mangoStepper.rx.minimumValue)
            .disposed(by: self.disposeBag)
        
        output.stepperMaximumValue
            .bind(to: self.strawberryStepper.rx.maximumValue,
                  self.bananaStepper.rx.maximumValue,
                  self.pineappleStepper.rx.maximumValue,
                  self.kiwiStepper.rx.maximumValue,
                  self.mangoStepper.rx.maximumValue)
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
}
