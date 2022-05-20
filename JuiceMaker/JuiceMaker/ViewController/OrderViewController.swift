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
    
    var orderViewModel: OrderViewModel?
    var disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindOrderButtons()
    }
    
    private func bindOrderButtons() {
        guard let orderViewModel = orderViewModel else {
            return
        }

        let input = OrderViewModel.Input(
            orderStrawberryBananaButtonTap: orderOfStrawberryBananaJuice.rx.tap.asObservable(),
            orderOfMangoKiwiButtonTap: orderOfMangoKiwiJuice.rx.tap.asObservable(),
            orderOfStrawberryButtonTap: orderOfStrawberryJuice.rx.tap.asObservable(),
            orderOfBananaButtonTap: orderOfBananaJuice.rx.tap.asObservable(),
            orderOfPineappleButtonTap: orderOfPineappleJuice.rx.tap.asObservable(),
            orderOfKiwiButtonTap: orderOfKiwiJuice.rx.tap.asObservable(),
            orderOfMangoButtonTap: orderOfMangoJuice.rx.tap.asObservable()
        )
        
    }
}

