//
//  ViewController.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 27.11.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit

class StartViewController: ThemedViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let userDefaults = UserDefaults.standard
    var pickerHidden = false
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var durationPicker: UIPickerView!
    @IBOutlet weak var hidePickerButton: UIButton!
    
    var durationList: [String] {
        var list = ["Open End"]
        for minutes in 1...45 {
            list.append("\(minutes) \(minutes == 1 ? "minute" : "minutes")")
        }
        return list
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up UIPickerView
        durationPicker.dataSource = self
        durationPicker.delegate = self
        durationPicker.selectRow(userDefaults.integer(forKey: DefaultsKeys.duration), inComponent: 0, animated: false)
        pickerHidden = userDefaults.bool(forKey: DefaultsKeys.durationPickerHidden)
        updatePickerDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        durationPicker.reloadAllComponents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hidePickerPressed(_ sender: UIButton) {
        if pickerHidden {
            pickerHidden = false
        } else {
            pickerHidden = true
        }
        updatePickerDisplay()
        userDefaults.set(pickerHidden, forKey: DefaultsKeys.durationPickerHidden)
    }
    
    func updatePickerDisplay() {
        if !pickerHidden {
            durationPicker.isHidden = false
            durationLabel.text = "How long do you want to meditate?"
            hidePickerButton.setTitle("▲", for: .normal)
        } else {
            durationPicker.isHidden = true
            let duration = userDefaults.integer(forKey: DefaultsKeys.duration)
            durationLabel.text = duration == 0 ? "Open End" : "\(duration) minute" + (duration > 1 ? "s" : "")
            hidePickerButton.setTitle("▼", for: .normal)
        }
    }
    
    
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return durationList.count
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: durationList[row], attributes: [NSAttributedStringKey.foregroundColor: Theme.currentTheme.text])
    }
    
    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        userDefaults.set(row, forKey: DefaultsKeys.duration)
    }
    
    // MARK: - Navigation
    @IBAction func unwindFromSettings(segue: UIStoryboardSegue) {
        
    }
    @IBAction func unwindFromEndscreen(segue: UIStoryboardSegue) {
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        if identifier == PropertyKeys.startMeditationSegue, let destination = segue.destination as? MeditationViewController {
            let minutes = durationPicker.selectedRow(inComponent: 0)
            destination.remainingTime = Double(minutes*60) // TODO: * 60 for minutes (seconds for testing)
            destination.isOpenEnd = minutes == 0 ? true : false
        }
    }
}

