//
//  ViewController.swift
//  EPG
//
//  Created by Jerald Abille on 3/17/18.
//  Copyright © 2018 Jerald Abille. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var collectionView: UICollectionView!
  // @IBOutlet weak var currentTimeIndicator: UIView!

  var channels: [Channel]?
  var timer: Timer?
  var timeIntervals: [String] {
    return [
      "", "00:00", "01:00", "02:00", "03:00", "04:00", "05:00", "06:00", "07:00", "08:00", "09:00", "10:00", "11:00", "12:00",
      "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00"
    ]
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.title = "TV Guide"
    self.navigationController?.navigationBar.prefersLargeTitles = false

    // collectionView.register(EPGCollectionViewCell.self, forCellWithReuseIdentifier: "epgCell")
    let epgNib = UINib(nibName: "EPGCollectionViewCell", bundle: Bundle.main)
    collectionView.register(epgNib, forCellWithReuseIdentifier: "epgCell")

    let timeNib = UINib(nibName: "TimeCollectionViewCell", bundle: Bundle.main)
    collectionView.register(timeNib, forCellWithReuseIdentifier: "timeCell")

    let channelNib = UINib(nibName: "ChannelCollectionViewCell", bundle: Bundle.main)
    collectionView.register(channelNib, forCellWithReuseIdentifier: "channelCell")

    let programNib = UINib(nibName: "ProgramCollectionViewCell", bundle: Bundle.main)
    collectionView.register(programNib, forCellWithReuseIdentifier: "programCell")

    loadData()

    collectionView.backgroundColor = UIColor.lightGray
    let layout = EPGCollectionViewLayout()
    layout.channels = self.channels
    collectionView.setCollectionViewLayout(layout, animated: false)
    collectionView.dataSource = self
    collectionView.delegate = self
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    startTimer()
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    invalidateTimer()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func loadData() {
    if let jsonFile = Bundle.main.path(forResource: "Schedule", ofType: "json") {
      do {
        let data = try Data(contentsOf: URL(fileURLWithPath: jsonFile), options: .dataReadingMapped)
        let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        if let jsonDictionary = json as? [String:Any] {
          if let channelsArray = jsonDictionary["Channels"] as? [[String:Any]] {
            self.channels = [Channel]()
            for channelItem in channelsArray {
              let number = channelItem["number"] as! Int
              let name = channelItem["name"] as! String
              let channel = Channel(number: number, name: name)
              self.channels?.append(channel)

              if let programsArray = channelItem["programs"] as? [[String:Any]] {
                channel.programs = [Program]()
                for programItem in programsArray {
                  let title = programItem["title"] as! String
                  var start = programItem["start"] as! Int
                  var end = programItem["end"] as! Int

                  let program = Program(title: title, schedule: Schedule(start: TimeInterval(start), end: TimeInterval(end)))
                  channel.programs?.append(program)
                }
              }
            }
            if let _ = self.channels {
              print(self.channels!)
            }
          }
        }
      } catch  {
        print(error)
      }
    }
    collectionView.reloadData()
  }
}

// MARK: - Timer

extension ViewController {
  func startTimer() {
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
      // Update the current time indicator here.

    }
  }

  func invalidateTimer() {
    if let _ = timer {
      timer!.invalidate()
      timer = nil
    }
  }
}

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    if let count = channels?.count {
      return count + 1 // Number of channels + Time headers
    }
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if section == 0 {
      return timeIntervals.count
    } else {
      if let count = self.channels?[section - 1].programs?.count {
        return count + 1
      }
    }
    return 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: EPGCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "epgCell", for: indexPath) as! EPGCollectionViewCell
    cell.titleLabel.text = ""

    if indexPath.section == 0 { // Time
      let timeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "timeCell", for: indexPath) as! TimeCollectionViewCell
      let time = self.timeIntervals[indexPath.row]
      timeCell.timeLabel.text = time
      return timeCell
    } else if indexPath.row == 0 { // Channels
      let channelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "channelCell", for: indexPath) as! ChannelCollectionViewCell
      if let channel = self.channels?[indexPath.section - 1] {
        channelCell.configureWith(channel: channel)
        return channelCell
      }
      cell.backgroundColor = UIColor.orange
    } else {
      if let channel = self.channels?[indexPath.section - 1] {
        if let program = channel.programs?[indexPath.row - 1] {
          let programCell = collectionView.dequeueReusableCell(withReuseIdentifier: "programCell", for: indexPath) as! ProgramCollectionViewCell
          programCell.configureWith(program: program)
          return programCell
        }
      }
    }
    return cell
  }
}

// MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if indexPath.section == 0 {
      // Do nothing.
    }
    else if indexPath.row == 0 { // Channels
      if let channel = self.channels?[indexPath.section - 1] {
        print(channel)
      }
    } else { // Programs
      if let channel = self.channels?[indexPath.section - 1] {
        if let program = channel.programs?[indexPath.row - 1] {
          print(program)
        }
      }
    }
  }
}
