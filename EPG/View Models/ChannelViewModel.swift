//
//  ChannelViewModel.swift
//  EPG
//
//  Created by Jerald Abille on 3/20/18.
//  Copyright © 2018 Jerald Abille. All rights reserved.
//

import UIKit

class ChannelViewModel {
  var channel: Channel
  var channelNumberText: String
  var nameText: String
  var image: UIImage?

  init(channel: Channel) {
    self.channel = channel
    self.channelNumberText = "Ch \(channel.number)"
    self.nameText = "Ch.\(channel.number)"
    self.image = UIImage(named: channel.name.lowercased())
  }
}
