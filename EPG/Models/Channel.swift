//
//  Channel.swift
//  EPG
//
//  Created by Jerald Abille on 3/18/18.
//  Copyright © 2018 Jerald Abille. All rights reserved.
//

import Foundation

class Channel: CustomStringConvertible {
  var number: Int
  var name: String
  var programs: [Program]?

  init(number: Int, name: String) {
    self.number = number
    self.name = name
  }

  var description: String {
    return "Channel \(self.number) - \(self.name)"
  }
}
