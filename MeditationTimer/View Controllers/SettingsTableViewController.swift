//
//  SettingsTableViewController.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 28.11.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit
import HealthKit

class SettingsTableViewController: ThemedTableViewController, HealthKitHelperDelegate {
    
    func healthKitCheckComplete(authorizationStatus: HKAuthorizationStatus) {
        var statusText = ""
        var enabled = self.healthKitEnabled
        switch authorizationStatus {
        case .sharingAuthorized:
            if !enabled {
                statusText = "Health app integration authorized, but not enabled."
            } else {
                statusText = "Health app integration enabled."
            }
        case .sharingDenied:
            statusText = "To allow this app to write mindfulness data to the Health app, please go to the privacy section of your iPhone settings."
            enabled = false
        case .notDetermined:
            statusText = "Nodoka can write mindfulness data to the Health app. Enabling Health app integration will ask you for system permission."
            enabled = false
        @unknown default:
            fatalError("Unknown HealthKit authorization status.")
        }
        DispatchQueue.main.async {
            self.setHealth(enabled: enabled, status: statusText)
        }
    }
    
    func healthKitWriteComplete(status: Bool) {
        
    }
    
    func healthKitAuthorizeComplete(status: Bool) {
        DispatchQueue.main.async {
            self.isCurrentlyAuthorizingHealthKit = false
            self.checkHealthKitAndRefresh()
        }
        // Retrospectively write unwritten sessions
        if status {
            for session in MeditationSession.getAllSessions() {
                if !session.savedToHealth {
                    HealthKitHelper.shared.writeMindfulnessData(delegate: nil, session: session)
                }
            }
        }
    }
    
    
    let userDefaults = UserDefaults.standard
    
    var startGong: Int = 0
    var endGong: Int = 0
    var intervalGong: Int = 0
    var theme: String = ""
    var healthKitEnabled = false
    var healthKitStatus = ""
    var isCurrentlyAuthorizingHealthKit = false
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var healthSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self,
              name: UIApplication.didBecomeActiveNotification,
              object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(applicationDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil)
        
        refreshView()
    }
    
    func refreshView() {
        // Load current settings from defaults
        startGong = userDefaults.integer(forKey: DefaultsKeys.startGong)
        endGong = userDefaults.integer(forKey: DefaultsKeys.endGong)
        intervalGong = userDefaults.integer(forKey: DefaultsKeys.intervalGong)
        theme = userDefaults.string(forKey: DefaultsKeys.theme)!
        
        checkHealthKitAndRefresh()
    }
    
    func checkHealthKitAndRefresh() {
        if !isCurrentlyAuthorizingHealthKit {
            healthKitEnabled = userDefaults.bool(forKey: DefaultsKeys.healthKitEnabled)
            HealthKitHelper.healthQueue.async {
                _ = HealthKitHelper.shared.checkAuthorizationStatus(delegate: self)
            }
        }
        updateLabels()
    }
    
    @objc func applicationDidBecomeActive() {
        refreshView()
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return healthKitStatus
        } else if section == 2 {
            return nil
            // return "Recorded \(MeditationSession.index.count) meditation sessions."
        }
        return nil
    }
    
    func updateLabels() {
        // Theme label
        themeLabel.text = theme
        // Health Kit
        healthSwitch.isOn = healthKitEnabled
    }
    
    @IBAction func healthSwitchChanged(_ sender: Any) {
        if healthSwitch.isOn {
            setHealth(enabled: true, status: nil)
            isCurrentlyAuthorizingHealthKit = true
            HealthKitHelper.healthQueue.async {
                HealthKitHelper.shared.authorizeHealthKit(delegate: self)
            }
        } else {
            setHealth(enabled: false, status: nil)
            checkHealthKitAndRefresh()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        guard let identifier = segue.identifier else { return }
        if identifier == PropertyKeys.settingsGongStartSegue {
            if let destination = segue.destination as? SettingsGongTableViewController {
                destination.currentStartGong = startGong
                destination.currentEndGong = endGong
                destination.currentIntervalGong = intervalGong
                destination.delegate = self
            }
        }
        if identifier == PropertyKeys.settingsThemeSegue {
            if let destination = segue.destination as? SettingsThemeTableViewController {
                destination.delegate = self
                destination.currentThemeName = theme
            }
        }
        if identifier == PropertyKeys.settingsDurationSegue {
            if let _ = segue.destination as? SettingsDurationTableViewController {
                
            }
        }
    }
    
    func setGong(_ gong: Int, for identifier: String) {
        if identifier == PropertyKeys.settingsGongStartSegue {
            startGong = gong
            userDefaults.set(gong, forKey: DefaultsKeys.startGong)
        } else if identifier == PropertyKeys.settingsGongEndSegue {
            endGong = gong
            userDefaults.set(gong, forKey: DefaultsKeys.endGong)
        } else {
            intervalGong = gong
            userDefaults.set(gong, forKey: DefaultsKeys.intervalGong)
        }
        updateLabels()
    }
    func setTheme(_ theme: String) {
        userDefaults.set(theme, forKey: DefaultsKeys.theme)
        updateLabels()
        setNeedsStatusBarAppearanceUpdate()
    }
    func setHealth(enabled: Bool, status: String?) {
        healthKitEnabled = enabled
        healthKitStatus = status ?? healthKitStatus
        userDefaults.set(enabled, forKey: DefaultsKeys.healthKitEnabled)
        updateLabels()
        tableView.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.currentTheme.statusBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
