//
//  ObservableType+Extension.swift
//  JuiceMaker
//
//  Created by 서녕 on 2022/06/08.
//

import Foundation
import RxSwift

extension ObservableType {
    func mapToVoid() -> Observable<Void> {
        return map{ _ in }
    }
}
