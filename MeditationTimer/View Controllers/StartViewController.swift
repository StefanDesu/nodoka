//
//  ViewController.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 27.11.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit
import FontAwesome
import EasyTipView

class StartViewController: ThemedViewController {
    
    let userDefaults = UserDefaults.standard
    
    var durationTipView: EasyTipView?
    
    @IBOutlet weak var preparationTimeLabel: UILabel!
    @IBOutlet weak var durationTimeLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var changeDurationButton: UIButton!
    @IBOutlet weak var preparationStackView: UIStackView!
    @IBOutlet weak var meditationStackView: UIStackView!
    
    override var owlImageVariant: ImageVariant { return .open }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Refresh duration label
        let meditationTime = userDefaults.integer(forKey: DefaultsKeys.duration)
        let preparationTime = userDefaults.integer(forKey: DefaultsKeys.preparation)
        let meditationTimeString = meditationTime == 0 ? "Open End" : "\(meditationTime) Minute" + (meditationTime == 1 ? "" : "s")
        let preparationTimeString = preparationTime == 0 ? "No Preparation" : "\(preparationTime) Second" + (preparationTime == 1 ? "" : "s")
        preparationTimeLabel.text = "\(preparationTimeString)"
        durationTimeLabel.text = "\(meditationTimeString)"
        
        // Set button labels
        settingsButton.setAttributedTitle(FontHelper.generate(icon: String.fontAwesomeIcon(name: .cog), withText: " Settings", ofSize: 17, andTextColor: Theme.currentTheme.accent, style: .solid), for: .normal)
        historyButton.setAttributedTitle(FontHelper.generate(icon: String.fontAwesomeIcon(name: .history), withText: " History", ofSize: 17, andTextColor: Theme.currentTheme.accent, style: .solid), for: .normal)
        changeDurationButton.setAttributedTitle(FontHelper.generate(icon: String.fontAwesomeIcon(name: .penSquare), withText: "", ofSize: 25, andTextColor: Theme.currentTheme.accent, style: .solid), for: .normal)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        // Put tab gesture recognizer on owl and stack views
        owlImage?.isUserInteractionEnabled = true
        var tapGesture = UITapGestureRecognizer(target: self, action: #selector(start))
        tapGesture.numberOfTapsRequired = 1
        owlImage?.addGestureRecognizer(tapGesture)
        preparationStackView.isUserInteractionEnabled = true
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(editDurations))
        tapGesture.numberOfTapsRequired = 1
        preparationStackView.addGestureRecognizer(tapGesture)
        meditationStackView.isUserInteractionEnabled = true
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(editDurations))
        tapGesture.numberOfTapsRequired = 1
        meditationStackView.addGestureRecognizer(tapGesture)
        
        if !userDefaults.bool(forKey: DefaultsKeys.hasLaunchedApp) {
            // Set up tooltips
            var preferences = EasyTipView.Preferences()
            preferences.drawing.font = UIFont.systemFont(ofSize: 13)
            preferences.drawing.foregroundColor = Theme.currentTheme.textLight
            preferences.drawing.backgroundColor = Theme.currentTheme.cell
            preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.bottom
            EasyTipView.globalPreferences = preferences
            
            // Prepare tooltip
            durationTipView = EasyTipView(text: "Tap this button to change preparation and meditation durations.")
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                self.durationTipView?.show(forView: self.changeDurationButton)
            }
            
            userDefaults.set(true, forKey: DefaultsKeys.hasLaunchedApp)
        }
        
    }
    
    // MARK: - Navigation
    @IBAction func unwindFromSettings(segue: UIStoryboardSegue) {
        
    }
    @IBAction func unwindFromEndscreen(segue: UIStoryboardSegue) {
        
    }
    
    @objc func start() {
        durationTipView?.dismiss()
        if let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: PropertyKeys.meditationStoryboard) as? MeditationViewController {
            // Prepare destination view controller
            let meditationMinutes = userDefaults.integer(forKey: DefaultsKeys.duration)
            let preparationSeconds = userDefaults.integer(forKey: DefaultsKeys.preparation)
            destination.remainingTime = Double(meditationMinutes*60)
            destination.isOpenEnd = meditationMinutes == 0 ? true : false
            destination.preparationTime = Double(preparationSeconds)
            // Prepare transition animation
            let transition = CATransition.init()
            transition.duration = 0.5
            transition.type = CATransitionType.fade
            // Push view controller
            navigationController?.view.layer.add(transition, forKey: kCATransition)
            navigationController?.pushViewController(destination, animated: false)
        }
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        start()
    }
    
    @objc func editDurations() {
        performSegue(withIdentifier: PropertyKeys.editDurationsSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        durationTipView?.dismiss()
    }
    
}

