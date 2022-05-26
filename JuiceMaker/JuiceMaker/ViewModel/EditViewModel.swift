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
    }
    
    func transform(input: Input) -> Output {
        let modifyStockSuccess = BehaviorSubject<Bool>(value: true)
        let newFruitStock = PublishSubject<(Fruit, Int)>()
        
        input.stockChange
            .subscribe(onNext: { (fruit, quantity) in
                self.juiceMaker.fruitStockObservable(of: fruit)
                    .subscribe(onNext: { currentStock in
                        newFruitStock.onNext((fruit, quantity + currentStock))
                    }).disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
        
        newFruitStock
            .map{ (fruit, quantity) in
                self.juiceMaker.modifyFruitStock(for: fruit, newQuantity: quantity)
            }.subscribe(onNext: { modifyResult in
                modifyResult
                    .subscribe(onNext: { result in
                        if result == true {
                            modifyStockSuccess.onNext(true)
                        } else {
                            modifyStockSuccess.onNext(false)
                        }
                    }).disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
        
        
        
        return Output(modifyStockSuccess: modifyStockSuccess)
    }
    
    func fruitStockObservable(of fruit: Fruit) -> Observable<Int> {
        return juiceMaker.fruitStockObservable(of: fruit)
    }
}
