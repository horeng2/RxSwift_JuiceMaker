//
//  EditViewModel.swift
//  JuiceMaker
//
//  Created by 서녕 on 2022/05/25.
//

import Foundation
import RxSwift

class EditViewModel {
    private let juiceMaker = JuiceMaker()
    private let disposeBag = DisposeBag()
    
    struct Input {
        let stockChange: PublishSubject<(Fruit, Int)>
    }
    
    struct Output {
        let modifyStockSuccess: BehaviorSubject<Bool>
        let alartMessage: PublishSubject<String?>
    }
    
    func transform(input: Input) -> Output {
        let modifyStockSuccess = BehaviorSubject<Bool>(value: true)
        let alartMessage = PublishSubject<String?>()
        
        input.stockChange
            .subscribe(onNext: { (fruit, quantity) in
                if let failureMessage = self.modifyFailureMessage(quantity) {
                    alartMessage.onNext(failureMessage)
                    return
                }
                self.juiceMaker.modifyFruitStock(for: fruit, newQuantity: quantity)
                    .subscribe(onNext: { result in
                        if result == true {
                            modifyStockSuccess.onNext(true)
                        } else {
                            modifyStockSuccess.onNext(false)
                        }
                    }).disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)

        return Output(modifyStockSuccess: modifyStockSuccess, alartMessage: alartMessage)
    }
    
    func fruitStockObservable(of fruit: Fruit) -> Observable<Int> {
        return juiceMaker.fruitStockObservable(of: fruit)
    }
    
    func modifyFailureMessage(_ quantity: Int) -> String? {
        var modifyAlert: String? = nil
        
        if quantity > 100 {
            modifyAlert = ModifyStockAlert.maximumStock.message
        } else if quantity < 0 {
            modifyAlert = ModifyStockAlert.minimumStock.message
        }
        
        return modifyAlert
    }
}
