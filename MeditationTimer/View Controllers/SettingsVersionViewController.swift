//
//  SettingsVersionViewController.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 01.12.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit
import Haring

class SettingsVersionViewController: ThemedViewController {

    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var aboutTextView: UITextView! {
        didSet {
            aboutTextView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set version label
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "?"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] ?? "?"
        versionLabel.text = "Version \(version) (\(build))"
        
        // Set up text view
        let markdown = """
        Created by Stefan Peters
        - Blog: [exo.pm](https://exo.pm)
        - Twitter: [@NodokaApp](https://twitter.com/NodokaApp), [@StefanDesu](https://twitter.com/StefanDesu)
        - Instagram: [@StefanDesu](https://instagram.com/stefandesu)
        - Email: [stefandesu@exo.pm](mailto:stefandesu@exo.pm)

        [Privacy Policy](https://exo.pm/nodoka-privacy/)

        **Credits**
        - Owl by [Ana Pas from the Noun Project](https://thenounproject.com/term/owl/12773/), modified by my friend Salo and me
        - Sounds (Default, Soft, Strong) by [Omachronic on Freesound.org](https://freesound.org/people/Omachronic/packs/8156/)
        - Sound (Zen) by [Mike Koenig](http://soundbible.com/1491-Zen-Buddhist-Temple-Bell.html)
        - Sound (Metal) by [Mike Koenig](http://soundbible.com/128-Metal-Gong.html)
        - Font Awesome by [Dave Gandy](http://fontawesome.io) (via [FontAwesome.swift](https://github.com/thii/FontAwesome.swift))
        - Markdown parser for this text view: [Haring](https://github.com/davidlari/Haring)
        - Tooltip at first launch: [EasyTipView](https://github.com/teodorpatras/EasyTipView)
        - UIScreen extension for animated brightness change by [khaullen on StackOverflow](https://stackoverflow.com/questions/15840979/how-to-set-screen-brightness-with-fade-animations)
        - UIColor hex extension: [crunchybagel.com](https://crunchybagel.com/working-with-hex-colors-in-swift-3/)
        - Thanks for Igor, Salo, Matze, and Birte for beta testing!
        """
        let markdownParser = MarkdownParser(font: UIFont.systemFont(ofSize: 15), color: Theme.currentTheme.text)
        markdownParser.link.color = Theme.currentTheme.accent
        markdownParser.automaticLinkDetectionEnabled = false
        aboutTextView.linkTextAttributes = [ NSAttributedStringKey.foregroundColor.rawValue: Theme.currentTheme.accent ]
        aboutTextView.attributedText = markdownParser.parse(markdown)
        aboutTextView.backgroundColor = UIColor.clear
    }
    
    override func viewDidLayoutSubviews() {
        aboutTextView.setContentOffset(CGPoint.zero, animated: false)
    }

}

extension SettingsVersionViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL,
                  in characterRange: NSRange) -> Bool {
        UIApplication.shared.open(URL, options: [:], completionHandler: nil)
        return false
    }
    
}
