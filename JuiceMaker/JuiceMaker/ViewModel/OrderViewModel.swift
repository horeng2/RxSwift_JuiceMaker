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
        let orderResultMessage: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        let strawBananaJuiceMakingResult = input.strawBananaJuiceButtonDidTap
            .flatMap{ self.juiceMaker.juiceMakingResult(.strawberryBananaJuice) }
            .share()
        
        let mangoKiwiJuiceMakingResult = input.mangoKiwiJuiceButtonDidTap
            .flatMap{ self.juiceMaker.juiceMakingResult(.mangoKiwiJuice) }
            .share()
        
        let strawberryJuiceMakingResult = input.strawberryJuiceButtonDidTap
            .flatMap{ self.juiceMaker.juiceMakingResult(.strawberryJuice) }
            .share()
        
        let bananaJuiceMakingResult = input.bananaJuiceButtonDidTap
            .flatMap{ self.juiceMaker.juiceMakingResult(.bananaJuice) }
            .share()
        
        let pineappleJuiceMakingResult = input.pineappleJuiceButtonDidTap
            .flatMap{ self.juiceMaker.juiceMakingResult(.pineappleJuice) }
            .share()
        
        let kiwiJuiceMakingResult = input.kiwiJuiceButtonDidTap
            .flatMap{ self.juiceMaker.juiceMakingResult(.kiwiJuice) }
            .share()
        
        let mangoJuiceMakingResult = input.mangoJuiceButtonDidTap
            .flatMap{ self.juiceMaker.juiceMakingResult(.mangoJuice) }
            .share()
        
        let orderResultMessage = Observable.merge(
            strawBananaJuiceMakingResult,
            mangoKiwiJuiceMakingResult,
            strawberryJuiceMakingResult,
            bananaJuiceMakingResult,
            pineappleJuiceMakingResult,
            kiwiJuiceMakingResult,
            mangoJuiceMakingResult
        )
            .map{ makeJuiceResult in
                OrderResult(makeJuiceResult).message
            }
        
        let fetchStock = Observable.merge(
            input.viewWillAppear,
            strawBananaJuiceMakingResult.mapToVoid(),
            mangoKiwiJuiceMakingResult.mapToVoid(),
            strawberryJuiceMakingResult.mapToVoid(),
            bananaJuiceMakingResult.mapToVoid(),
            pineappleJuiceMakingResult.mapToVoid(),
            kiwiJuiceMakingResult.mapToVoid(),
            mangoJuiceMakingResult.mapToVoid()
        )
            .flatMap{ self.juiceMaker.fetchFruitStock() }
            .share()
        
        let strawberryStock = fetchStock
            .compactMap{ $0[.strawberry] }
            .map(String.init)
        
        let bananaStock = fetchStock
            .compactMap{ $0[.banana] }
            .map(String.init)
        
        let pineappleStock = fetchStock
            .compactMap{ $0[.pineapple] }
            .map(String.init)
        
        let kiwiStock = fetchStock
            .compactMap{ $0[.kiwi] }
            .map(String.init)
        
        let mangoStock = fetchStock
            .compactMap{ $0[.mango] }
            .map(String.init)
        
        return Output(strawberryStock: strawberryStock,
                      bananaStock: bananaStock,
                      pineappleStock: pineappleStock,
                      kiwiStock: kiwiStock,
                      mangoStock: mangoStock,
                      orderResultMessage: orderResultMessage)
    }
}
