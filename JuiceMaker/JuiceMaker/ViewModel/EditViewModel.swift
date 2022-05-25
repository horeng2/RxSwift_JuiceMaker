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
        let stockChange: PublishSubject<(Fruit, StockChangeOperator)>
    }
    
    struct Output {
        let modifyStockSuccess: PublishSubject<Bool>
    }
    
    func transform(input: Input) -> Output {
        let modifyStockSuccess = PublishSubject<Bool>()
        
        input.stockChange
            .map{ changing in
                self.juiceMaker.modifyFruitStock(changing.1, for: changing.0)
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

enum StockChangeOperator {
    case up
    case down
}
