//
//  Closures.swift
//  DevoeQuakeLocator
//
//  Created by Dana Devoe on 5/11/20.
//  Copyright © 2020 Dana Devoe. All rights reserved.
//

import Foundation

typealias Closure = () -> Void
typealias ClosureWithFeatures = ( _ featureCollection: FeatureCollection ) -> Void
typealias ClosureWithError = ( _ error: QuakeErrors ) -> Void
typealias ClosureWithBool = ( _ success: Bool ) -> Void
typealias ClosureWithAny = ( _ sender: Any? ) -> Void

