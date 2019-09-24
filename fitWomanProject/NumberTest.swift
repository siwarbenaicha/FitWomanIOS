//
//  NumberTest.swift
//  fitWomanProject
//
//  Created by marwa on 12/11/2018.
//  Copyright © 2018 marwa. All rights reserved.
//

import Foundation
import UIKit
extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
