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
        let strawberryStepperDidTap: Observable<Double>
        let bananaStepperDidTap: Observable<Double>
        let pineappleStepperDidTap: Observable<Double>
        let kiwiStepperDidTap: Observable<Double>
        let mangoStepperDidTap: Observable<Double>
    }
    
    struct Output {
        let strawberryStock: Observable<Int>
        let bananaStock: Observable<Int>
        let pineappleStock: Observable<Int>
        let kiwiStock: Observable<Int>
        let mangoStock: Observable<Int>
        let alertMessage: PublishSubject<String?>
    }
    
    func transform(input: Input) -> Output {
        let alertMessage = PublishSubject<String?>()
        
        let strawberryStock = input.strawberryStepperDidTap
            .map{ stepperValue in
                let newValue = Int(stepperValue)
                alertMessage.onNext(self.limitStockAlertMessage(newValue))
                self.juiceMaker.updateFruitStock(for: .strawberry, newQuantity: newValue)
            }
            .flatMap{ self.juiceMaker.fruitStockObservable(of: .strawberry) }
         
        let bananaStock = input.bananaStepperDidTap
            .map{ stepperValue in
                let newValue = Int(stepperValue)
                alertMessage.onNext(self.limitStockAlertMessage(newValue))
                self.juiceMaker.updateFruitStock(for: .banana, newQuantity: newValue)
            }
            .flatMap{ self.juiceMaker.fruitStockObservable(of: .banana) }
        
        let pineappleStock = input.pineappleStepperDidTap
            .map{ stepperValue in
                let newValue = Int(stepperValue)
                alertMessage.onNext(self.limitStockAlertMessage(newValue))
                self.juiceMaker.updateFruitStock(for: .pineapple, newQuantity: newValue)
            }
            .flatMap{ self.juiceMaker.fruitStockObservable(of: .pineapple) }
        
        let kiwiStock = input.kiwiStepperDidTap
            .map{ stepperValue in
                let newValue = Int(stepperValue)
                alertMessage.onNext(self.limitStockAlertMessage(newValue))
                self.juiceMaker.updateFruitStock(for: .kiwi, newQuantity: newValue)
            }
            .flatMap{ self.juiceMaker.fruitStockObservable(of: .kiwi) }
        
        let mangoStock = input.mangoStepperDidTap
            .map{ stepperValue in
                let newValue = Int(stepperValue)
                alertMessage.onNext(self.limitStockAlertMessage(newValue))
                self.juiceMaker.updateFruitStock(for: .mango, newQuantity: newValue)
            }
            .flatMap{ self.juiceMaker.fruitStockObservable(of: .mango) }
        
        return Output(strawberryStock: strawberryStock,
                      bananaStock: bananaStock,
                      pineappleStock: pineappleStock,
                      kiwiStock: kiwiStock,
                      mangoStock: mangoStock,
                      alertMessage: alertMessage)
    }
    
    func fruitStockObservable(of fruit: Fruit) -> Observable<Int> {
        return self.juiceMaker.fruitStockObservable(of: fruit)
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
