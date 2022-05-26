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
    
    private let editViewModel = EditViewModel()
    private lazy var input = EditViewModel.Input(stockChange: PublishSubject<(Fruit, Int)>())
    private lazy var output = editViewModel.transform(input: input)

    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
    }
    
    private func binding() {
        self.output.modifyStockSuccess
            .subscribe(onNext: { _ in
                Fruit.allCases.forEach { fruit in
                    self.updateCurrentValue(of: fruit)
                }
            }).disposed(by: disposeBag)
        
        self.output.alertMessage
            .subscribe(onNext: { message in
                guard let message = message else {
                    return
                }
                self.showAlert(title: "알림", message: message)
            }).disposed(by: disposeBag)
    }
    
    private func updateCurrentValue(of fruit: Fruit) {
        var label: UILabel?
        var stepper: UIStepper?
        switch fruit {
        case .strawberry:
            label = self.strawberryStockLabel
            stepper = self.strawberryStepper
        case .banana:
            label = self.bananaStockLabel
            stepper = self.bananaStepper
        case .pineapple:
            label = self.pineappleStockLabel
            stepper = self.pineappleStepper
        case .kiwi:
            label = self.kiwiStockLabel
            stepper = self.kiwiStepper
        case .mango:
            label = self.mangoStockLabel
            stepper = self.mangoStepper
        }
        stepper?.minimumValue = .zero
        stepper?.maximumValue = Double(FruitRepository.maximumStock)
        
        editViewModel.fruitStockObservable(of: fruit)
            .subscribe(onNext: { stock in
                label?.text = String(stock)
                stepper?.value = Double(stock)
            }).disposed(by: disposeBag)
    }

    @IBAction func tapStrawberryStepper(_ sender: Any) {
        self.input.stockChange.onNext((.strawberry, Int(strawberryStepper.value)))
    }
    
    @IBAction func tapBananaStepper(_ sender: Any) {
        self.input.stockChange.onNext((.banana, Int(bananaStepper.value)))
    }
    
    @IBAction func tapPineappleStepper(_ sender: Any) {
        self.input.stockChange.onNext((.pineapple, Int(pineappleStepper.value)))
    }
    
    @IBAction func tapKiwiStepper(_ sender: Any) {
        self.input.stockChange.onNext((.kiwi, Int(kiwiStepper.value)))
    }
    
    @IBAction func tapMangoStepper(_ sender: Any) {
        self.input.stockChange.onNext((.mango, Int(mangoStepper.value)))
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}
