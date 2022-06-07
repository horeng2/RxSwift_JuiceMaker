//
//  EditViewModel.swift
//  JuiceMaker
//
//  Created by 서녕 on 2022/05/25.
//

import Foundation
import RxSwift
import UIKit

class EditViewModel {
    private let juiceMaker = JuiceMaker()
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let strawberryStepperValueChanged: Observable<Double>
        let bananaStepperValueChanged: Observable<Double>
        let pineappleStepperValueChanged: Observable<Double>
        let kiwiStepperValueChanged: Observable<Double>
        let mangoStepperValueChanged: Observable<Double>
    }
    
    struct Output {
        let strawberryStock: Observable<Int>
        let bananaStock: Observable<Int>
        let pineappleStock: Observable<Int>
        let kiwiStock: Observable<Int>
        let mangoStock: Observable<Int>
        let minimumStepperValue: Observable<Double>
        let maximumStepperValue: Observable<Double>
        let alertMessage: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        let fetchStock = input.viewWillAppear
            .flatMap { self.juiceMaker.fetchFruitStock() }
            .share()

        let modifiedstrawberryStock = input.strawberryStepperValueChanged
            .skip(1)
            .map(Int.init)
            .do(onNext: {
                self.juiceMaker.updateFruitStock(for: .strawberry, newQuantity: $0)
            })
            .share()

        let modifiedBananaStock = input.bananaStepperValueChanged
            .skip(1)
            .map(Int.init)
            .do(onNext: {
                self.juiceMaker.updateFruitStock(for: .banana, newQuantity: $0)
            })
            .share()

        let modifiedPineappleStock = input.pineappleStepperValueChanged
            .skip(1)
            .map(Int.init)
            .do(onNext: {
                self.juiceMaker.updateFruitStock(for: .pineapple, newQuantity: $0)
            })
            .share()

        let modifiedKiwiStock = input.kiwiStepperValueChanged
            .skip(1)
            .map(Int.init)
            .do(onNext: {
                self.juiceMaker.updateFruitStock(for: .kiwi, newQuantity: $0)
            })
            .share()

        let modifiedMangoStock = input.mangoStepperValueChanged
            .skip(1)
            .map(Int.init)
            .do(onNext: {
                self.juiceMaker.updateFruitStock(for: .mango, newQuantity: $0)
            })
            .share()

        let strawberryStock = Observable.merge(
            fetchStock.compactMap { $0[.strawberry] },
            modifiedstrawberryStock
        )
        let bananaStock = Observable.merge(
            fetchStock.compactMap { $0[.banana] },
            modifiedBananaStock
        )
        let pineappleStock = Observable.merge(
            fetchStock.compactMap { $0[.pineapple] },
            modifiedPineappleStock
        )
        let kiwiStock = Observable.merge(
            fetchStock.compactMap { $0[.kiwi] },
            modifiedKiwiStock
        )
        let mangoStock = Observable.merge(
            fetchStock.compactMap { $0[.mango] },
            modifiedMangoStock
        )

        let minimumStepperValue = Observable.of(Double.zero)
        let maximumStepperValue = Observable.of(FruitRepository.maximumStock).map(Double.init)

        let alertMessage = Observable.merge(
            modifiedstrawberryStock,
            modifiedBananaStock,
            modifiedPineappleStock,
            modifiedKiwiStock,
            modifiedMangoStock
        )
            .compactMap(self.limitStockAlertMessage)

        return Output(strawberryStock: strawberryStock,
                      bananaStock: bananaStock,
                      pineappleStock: pineappleStock,
                      kiwiStock: kiwiStock,
                      mangoStock: mangoStock,
                      minimumStepperValue: minimumStepperValue,
                      maximumStepperValue: maximumStepperValue,
                      alertMessage: alertMessage)
    }
    
    private func limitStockAlertMessage(_ quantity: Int) -> String? {
        var limitAlert: String? = nil
        
        if quantity == FruitRepository.maximumStock {
            limitAlert = ModifyStockAlert.maximumStock.message
        } else if quantity == .zero {
            limitAlert = ModifyStockAlert.minimumStock.message
        }
        
        return limitAlert
    }
}
