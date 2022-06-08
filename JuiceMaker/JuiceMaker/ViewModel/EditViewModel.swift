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
        let limitStockAlertMessage: Observable<String>
        let stepperMinimumValue: Observable<Double>
        let stepperMaximumValue: Observable<Double>
    }
    
    func transform(input: Input) -> Output {
        let presetCurrentStock = input.viewWillAppear
            .flatMap{ self.juiceMaker.fetchFruitStock() }
            .share()
        
        let changedStrawberryStock = input.strawberryStepperValueChanged
            .skip(1)
            .map(Int.init)
            .do(onNext: { stepperValue in
                self.juiceMaker.updateFruitStock(for: .strawberry, newQuantity: stepperValue)
            })
            .share()
        
        let changedBananaStock = input.bananaStepperValueChanged
            .skip(1)
            .map(Int.init)
            .do(onNext: { stepperValue in
                self.juiceMaker.updateFruitStock(for: .banana, newQuantity: stepperValue)
            })
            .share()
        
        let changedPineappleStock = input.pineappleStepperValueChanged
            .skip(1)
            .map(Int.init)
            .do(onNext: { stepperValue in
                self.juiceMaker.updateFruitStock(for: .pineapple, newQuantity: stepperValue)
            })
            .share()
                    
        let changedKiwiStock = input.kiwiStepperValueChanged
            .skip(1)
            .map(Int.init)
            .do(onNext: { stepperValue in
                self.juiceMaker.updateFruitStock(for: .kiwi, newQuantity: stepperValue)
            })
            .share()
                        
        let changedMangoStock = input.mangoStepperValueChanged
            .skip(1)
            .map(Int.init)
            .do(onNext: { stepperValue in
                self.juiceMaker.updateFruitStock(for: .mango, newQuantity: stepperValue)
            })
            .share()
                            
        let strawberryStock = Observable.merge(
            presetCurrentStock.compactMap{ $0[.strawberry] },
            changedStrawberryStock
        )
                    
        let bananaStock = Observable.merge(
            presetCurrentStock.compactMap{ $0[.banana] },
            changedBananaStock
        )
        let pineappleStock = Observable.merge(
            presetCurrentStock.compactMap{ $0[.pineapple] },
            changedPineappleStock
        )
                    
        let kiwiStock = Observable.merge(
            presetCurrentStock.compactMap{ $0[.kiwi] },
            changedKiwiStock
        )
                    
        let mangoStock = Observable.merge(
            presetCurrentStock.compactMap{ $0[.mango] },
            changedMangoStock
        )
                            
        let limitStockAlertMessage = Observable.merge(
            changedStrawberryStock,
            changedBananaStock,
            changedPineappleStock,
            changedKiwiStock,
            changedMangoStock
        )
            .compactMap(self.limitStockAlertMessage)
            
        let stepperMinimumValue = Observable.just(Double.zero)
        let stepperMaximumValue = Observable.just(FruitRepository.maximumStock).map(Double.init)
                
        return Output(strawberryStock: strawberryStock,
                      bananaStock: bananaStock,
                      pineappleStock: pineappleStock,
                      kiwiStock: kiwiStock,
                      mangoStock: mangoStock,
                      limitStockAlertMessage: limitStockAlertMessage,
                      stepperMinimumValue: stepperMinimumValue,
                      stepperMaximumValue: stepperMaximumValue)
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
