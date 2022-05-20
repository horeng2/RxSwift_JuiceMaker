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
    
    @IBOutlet weak var orderOfStrawberryBananaJuice: UIButton!
    @IBOutlet weak var orderOfMangoKiwiJuice: UIButton!
    @IBOutlet weak var orderOfStrawberryJuice: UIButton!
    @IBOutlet weak var orderOfBananaJuice: UIButton!
    @IBOutlet weak var orderOfPineappleJuice: UIButton!
    @IBOutlet weak var orderOfKiwiJuice: UIButton!
    @IBOutlet weak var orderOfMangoJuice: UIButton!
    
    var disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.binding()
    }
    
    private func binding() {
        let orderViewModel = OrderViewModel()

        let input = OrderViewModel.Input(
            viewWillAppear: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear(_:))).map{ _ in }
//            orderStrawberryBananaButtonTap: orderOfStrawberryBananaJuice.rx.tap.asObservable(),
//            orderOfMangoKiwiButtonTap: orderOfMangoKiwiJuice.rx.tap.asObservable(),
//            orderOfStrawberryButtonTap: orderOfStrawberryJuice.rx.tap.asObservable(),
//            orderOfBananaButtonTap: orderOfBananaJuice.rx.tap.asObservable(),
//            orderOfPineappleButtonTap: orderOfPineappleJuice.rx.tap.asObservable(),
//            orderOfKiwiButtonTap: orderOfKiwiJuice.rx.tap.asObservable(),
//            orderOfMangoButtonTap: orderOfMangoJuice.rx.tap.asObservable()
        )
        
        let output = orderViewModel.transform(input: input)
        
        output.currentStock
            .drive(onNext: { stock in
                self.strawberryStockLabel.text = String(stock[.strawberry] ?? 10)
                self.bananaStockLabel.text = String(stock[.banana] ?? 10)
                self.pineappleStockLabel.text = String(stock[.pineapple] ?? 10)
                self.kiwiStockLabel.text = String(stock[.kiwi] ?? 10)
                self.mangoStockLabel.text = String(stock[.mango] ?? 10)
            })
            .disposed(by: self.disposeBag)
            
        
    }
}

