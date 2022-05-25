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
        output.modifyStockSuccess
            .subscribe(onNext: { _ in
                Fruit.allCases.forEach { fruit in
                    self.updateStockLabel(of: fruit)
                }
            }).disposed(by: disposeBag)
    }
    
    private func updateStockLabel(of fruit: Fruit) {
        var label: UILabel?
        switch fruit {
        case .strawberry:
            label = self.strawberryStockLabel
        case .banana:
            label = self.bananaStockLabel
        case .pineapple:
            label = self.pineappleStockLabel
        case .kiwi:
            label = self.kiwiStockLabel
        case .mango:
            label = self.mangoStockLabel
        }
        editViewModel.fruitStockObservable(of: fruit)
            .map{ String($0) }
            .subscribe(onNext: { stock in
                label?.text = stock
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
}
