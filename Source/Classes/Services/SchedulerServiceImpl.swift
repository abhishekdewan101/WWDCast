//
//  SchedulerServiceImpl.swift
//  WWDCast
//
//  Created by Maksym Shcheglov on 09/07/16.
//  Copyright © 2016 Maksym Shcheglov. All rights reserved.
//

import Foundation
import RxSwift

final class SchedulerServiceImpl: SchedulerService {

    lazy var backgroundWorkScheduler: ImmediateSchedulerType = {
        let operationQueue = NSOperationQueue()
        operationQueue.maxConcurrentOperationCount = 2
        operationQueue.qualityOfService = NSQualityOfService.UserInitiated
        return OperationQueueScheduler(operationQueue: operationQueue)
    }()

    let mainScheduler = MainScheduler.instance

}
