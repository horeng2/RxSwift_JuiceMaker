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
        self.configure()
        self.binding()
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
            })
            .disposed(by: disposeBag)
    }
    
    private func updateCurrentValue(of fruit: Fruit) {
        let updateTarget: (UILabel, UIStepper) = {
            switch fruit {
            case .strawberry:
                return (self.strawberryStockLabel, self.strawberryStepper)
            case .banana:
                return (self.bananaStockLabel, self.bananaStepper)
            case .pineapple:
                return (self.pineappleStockLabel, self.pineappleStepper)
            case .kiwi:
                return (self.kiwiStockLabel, self.kiwiStepper)
            case .mango:
                return (self.mangoStockLabel, self.mangoStepper)
            }
        }()
        
        editViewModel.fruitStockObservable(of: fruit)
            .subscribe(onNext: { stock in
                updateTarget.0.text = stock
                updateTarget.1.value = Double(stock) ?? 0
            })
            .disposed(by: disposeBag)
    }
    
    private func configure(){
        self.strawberryStepper.minimumValue = .zero
        self.bananaStepper.minimumValue = .zero
        self.pineappleStepper.minimumValue = .zero
        self.kiwiStepper.minimumValue = .zero
        self.mangoStepper.minimumValue = .zero
        
        self.strawberryStepper.maximumValue = Double(FruitRepository.maximumStock)
        self.bananaStepper.maximumValue = Double(FruitRepository.maximumStock)
        self.pineappleStepper.maximumValue = Double(FruitRepository.maximumStock)
        self.kiwiStepper.maximumValue = Double(FruitRepository.maximumStock)
        self.mangoStepper.maximumValue = Double(FruitRepository.maximumStock)
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
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true)
    }
}
