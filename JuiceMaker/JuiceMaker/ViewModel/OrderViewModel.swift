//
//  OrderJuiceViewModel.swift
//  JuiceMaker
//
//  Created by 서녕 on 2022/05/17.
//

import Foundation
import RxSwift

class OrderViewModel {
    private let juiceMaker = JuiceMaker()
    private let disposeBag = DisposeBag()

    struct Input {
        let orderJuice: PublishSubject<Juice>
    }
    
    struct Output {
        let orderSuccess: PublishSubject<Bool>
        let resultMessage: PublishSubject<String>
    }
    
    func transform(input: Input) -> Output {
        let orderSuccess = PublishSubject<Bool>()
        let resultMessage = PublishSubject<String>()
        
        input.orderJuice
            .map{ juice in
            self.juiceMaker.makeJuice(juice)
            }.subscribe(onNext: { juiceObservable in
                juiceObservable
                    .subscribe(onNext: { juice in
                        if juice == nil {
                            orderSuccess.onNext(false)
                            resultMessage.onNext(OrderResult.orderFailure.message)
                        } else {
                            orderSuccess.onNext(true)
                            resultMessage.onNext(OrderResult.orderSuccess.message)
                        }
                    }).disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
        
        return Output(
            orderSuccess: orderSuccess,
            resultMessage: resultMessage
        )
    }
    
    func fruitStockObservable(of fruit: Fruit) -> Observable<Int> {
        return juiceMaker.fruitStockObservable(of: fruit)
    }
}
