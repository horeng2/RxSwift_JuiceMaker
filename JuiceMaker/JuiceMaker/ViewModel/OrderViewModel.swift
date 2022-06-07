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
        let strawberryStock: Observable<String>
        let bananaStock: Observable<String>
        let pineappleStock: Observable<String>
        let kiwiStock: Observable<String>
        let mangoStock: Observable<String>
        let alertMessage: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        let strawBananaJuiceOrderResult = input.strawBananaJuiceButtonDidTap
            .flatMap { self.juiceMaker.juiceMakingResult(.strawberryBananaJuice) }
            .share()
        
        let mangoKiwiJuiceOrderResult = input.mangoKiwiJuiceButtonDidTap
            .flatMap { self.juiceMaker.juiceMakingResult(.mangoKiwiJuice) }
            .share()
        
        let strawberryJuiceOrderResult = input.strawberryJuiceButtonDidTap
            .flatMap { self.juiceMaker.juiceMakingResult(.strawberryJuice) }
            .share()
        
        let bananaJuiceOrderResult = input.bananaJuiceButtonDidTap
            .flatMap { self.juiceMaker.juiceMakingResult(.bananaJuice) }
            .share()
        
        let pineappleJuiceOrderResult = input.pineappleJuiceButtonDidTap
            .flatMap { self.juiceMaker.juiceMakingResult(.pineappleJuice) }
            .share()
        
        let kiwiJuiceOrderResult = input.kiwiJuiceButtonDidTap
            .flatMap { self.juiceMaker.juiceMakingResult(.kiwiJuice) }
            .share()

        let mangoJuiceOrderResult = input.mangoJuiceButtonDidTap
            .flatMap { self.juiceMaker.juiceMakingResult(.mangoJuice) }
            .share()

        let alertMessage = Observable.merge(
            strawBananaJuiceOrderResult,
            mangoKiwiJuiceOrderResult,
            strawberryJuiceOrderResult,
            bananaJuiceOrderResult,
            pineappleJuiceOrderResult,
            kiwiJuiceOrderResult,
            mangoJuiceOrderResult
        )
            .map { OrderResult.init(orderResult:$0).message }

        let fetchStock = Observable.merge(
            input.viewWillAppear,
            strawberryJuiceOrderResult.mapToVoid(),
            strawBananaJuiceOrderResult.mapToVoid(),
            bananaJuiceOrderResult.mapToVoid(),
            pineappleJuiceOrderResult.mapToVoid(),
            kiwiJuiceOrderResult.mapToVoid(),
            mangoKiwiJuiceOrderResult.mapToVoid(),
            mangoJuiceOrderResult.mapToVoid()
        )
            .flatMap { self.juiceMaker.fetchFruitStock() }
            .share()

        let strawberryStock = fetchStock
            .compactMap { $0[.strawberry] }
            .map(String.init)


        let bananaStock = fetchStock
            .compactMap { $0[.banana] }
            .map(String.init)

        let pineappleStock = fetchStock
            .compactMap { $0[.pineapple] }
            .map(String.init)

        let kiwiStock = fetchStock
            .compactMap { $0[.kiwi] }
            .map(String.init)

        let mangoStock = fetchStock
            .compactMap { $0[.mango] }
            .map(String.init)

        return Output(strawberryStock: strawberryStock,
                      bananaStock: bananaStock,
                      pineappleStock: pineappleStock,
                      kiwiStock: kiwiStock,
                      mangoStock: mangoStock,
                      alertMessage: alertMessage)
    }
}

extension ObservableType {

    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}
