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
        let orderSuccess: BehaviorSubject<Bool>
    }
    
    func transform(input: Input) -> Output {
        let orderSuccess = BehaviorSubject<Bool>(value: true)
        
        input.orderJuice
            .map{ juice in
            self.juiceMaker.makeJuice(juice)
            }.subscribe(onNext: { juiceObservable in
                juiceObservable
                    .subscribe(onNext: { juice in
                        if juice == nil {
                            orderSuccess.onNext(false)
                        }
                    }).disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
 
        return Output(orderSuccess: orderSuccess)
    }
    
    func fruitStockObservable(of fruit: Fruit) -> Observable<Int> {
        return juiceMaker.fruitStockObservable(of: fruit)
    }
}

enum OrderResult {
    var message: String {
        switch self {
        case .orderSuccess:
            return "주스 주문 완료"
        case .orderFailure:
            return "주문 실패"
        }
    }
    
    case orderSuccess
    case orderFailure
}
