//
//  OrderJuiceViewModel.swift
//  JuiceMaker
//
//  Created by 서녕 on 2022/05/17.
//

import Foundation
import RxSwift
import RxCocoa

class OrderViewModel {
    private let juiceMaker = JuiceMaker()
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let strawBananaJuiceButtonDidTap: Observable<Void>
        let mangoKiwiJuiceButtonDidTap: Observable<Void>
        let strawberryJuiceButtonDidTap: Observable<Void>
        let bananaJuiceButtonDidTap: Observable<Void>
        let pineappleJuiceButtonDidTap: Observable<Void>
        let kiwiJuiceButtonDidTap: Observable<Void>
        let mangoJuiceButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let strawberryStock: PublishSubject<String>
        let bananaStock: PublishSubject<String>
        let pineappleStock: PublishSubject<String>
        let kiwiStock: PublishSubject<String>
        let mangoStock: PublishSubject<String>
        let orderButtonBind: Observable<Void>
        let resultMessage: PublishSubject<String>
    }
    
    func transform(input: Input) -> Output {
        let resultMessage = PublishSubject<String>()
        let strawberryStock = PublishSubject<String>()
        let bananaStock = PublishSubject<String>()
        let pineappleStock = PublishSubject<String>()
        let kiwiStock = PublishSubject<String>()
        let mangoStock = PublishSubject<String>()
        
        let strawBananaJuiceTap = input.strawBananaJuiceButtonDidTap
            .flatMap{ self.juiceMaker.makeJuice(.strawberryBananaJuice) }
            .do(onNext: { canMakeJuice in
                if canMakeJuice {
                    resultMessage.onNext(OrderResult.orderSuccess.message)
                } else {
                    resultMessage.onNext(OrderResult.orderFailure.message)
                }
            })
            .map{ _ in }
        
        let mangoKiwiJuiceTap = input.mangoKiwiJuiceButtonDidTap
            .flatMap{ self.juiceMaker.makeJuice(.mangoKiwiJuice) }
            .do(onNext: { canMakeJuice in
                if canMakeJuice {
                    resultMessage.onNext(OrderResult.orderSuccess.message)
                } else {
                    resultMessage.onNext(OrderResult.orderFailure.message)
                }
            })
                .map{ _ in }
        
        let strawberryJuiceTap = input.strawberryJuiceButtonDidTap
            .flatMap{ self.juiceMaker.makeJuice(.strawberryJuice) }
            .do(onNext: { canMakeJuice in
                if canMakeJuice {
                    resultMessage.onNext(OrderResult.orderSuccess.message)
                } else {
                    resultMessage.onNext(OrderResult.orderFailure.message)
                }
            })
                .map{ _ in }
        
        let bananaJuiceTap = input.bananaJuiceButtonDidTap
            .flatMap{ self.juiceMaker.makeJuice(.bananaJuice) }
            .do(onNext: { canMakeJuice in
                if canMakeJuice {
                    resultMessage.onNext(OrderResult.orderSuccess.message)
                } else {
                    resultMessage.onNext(OrderResult.orderFailure.message)
                }
            })
                .map{ _ in }
        
        let pineappleJuiceTap = input.pineappleJuiceButtonDidTap
            .flatMap{ self.juiceMaker.makeJuice(.pineappleJuice) }
            .do(onNext: { canMakeJuice in
                if canMakeJuice {
                    resultMessage.onNext(OrderResult.orderSuccess.message)
                } else {
                    resultMessage.onNext(OrderResult.orderFailure.message)
                }
            })
                .map{ _ in }
        
        let kiwiJuiceTap = input.kiwiJuiceButtonDidTap
            .flatMap{ self.juiceMaker.makeJuice(.kiwiJuice) }
            .do(onNext: { canMakeJuice in
                if canMakeJuice {
                    resultMessage.onNext(OrderResult.orderSuccess.message)
                } else {
                    resultMessage.onNext(OrderResult.orderFailure.message)
                }
            })
                .map{ _ in }
        
        let mangoJuiceTap = input.mangoJuiceButtonDidTap
            .flatMap{ self.juiceMaker.makeJuice(.mangoJuice) }
            .do(onNext: { canMakeJuice in
                if canMakeJuice {
                    resultMessage.onNext(OrderResult.orderSuccess.message)
                } else {
                    resultMessage.onNext(OrderResult.orderFailure.message)
                }
            })
                .map{ _ in }
        
        let orderButtonBind = Observable.merge(input.viewWillAppear,
                                               strawBananaJuiceTap,
                                               mangoKiwiJuiceTap,
                                               strawberryJuiceTap,
                                               bananaJuiceTap,
                                               pineappleJuiceTap,
                                               kiwiJuiceTap,
                                               mangoJuiceTap)
            .do(onNext: {
                self.juiceMaker.fruitStockObservable(of: .strawberry)
                    .bind{ stock in
                        strawberryStock.onNext(String(stock))
                    }.dispose()
                self.juiceMaker.fruitStockObservable(of: .banana)
                    .bind{ stock in
                        bananaStock.onNext(String(stock))
                    }.dispose()
                self.juiceMaker.fruitStockObservable(of: .pineapple)
                    .bind{ stock in
                        pineappleStock.onNext(String(stock))
                    }.dispose()
                self.juiceMaker.fruitStockObservable(of: .kiwi)
                    .bind{ stock in
                        kiwiStock.onNext(String(stock))
                    }.dispose()
                self.juiceMaker.fruitStockObservable(of: .mango)
                    .bind{ stock in
                        mangoStock.onNext(String(stock))
                    }.dispose()
            })
                
                return Output(strawberryStock: strawberryStock,
                              bananaStock: bananaStock,
                              pineappleStock: pineappleStock,
                              kiwiStock: kiwiStock,
                              mangoStock: mangoStock,
                              orderButtonBind: orderButtonBind,
                              resultMessage: resultMessage)
                }
}
