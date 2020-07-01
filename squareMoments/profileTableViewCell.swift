//
//  profileTableViewCell.swift
//  squareMoments
//
//  Created by MEHMET ONUR ÜSTÜNEL on 29.06.2020.
//  Copyright © 2020 MEHMET ONUR ÜSTÜNEL. All rights reserved.
//

import UIKit
import Firebase

class profileTableViewCell: UITableViewCell {
    
    var likeCounter = 0
    var saveCounter = 0
    
    @IBOutlet weak var likeClick: UIButton!
    @IBOutlet weak var saveClick: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmaiLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func likeClicked(_ sender: Any) {
        if likeCounter == 0 {
            likeClick.setBackgroundImage(UIImage(named: "liked.png"), for: .normal)
            likeCounter += 1
        } else {
            likeClick.setBackgroundImage(UIImage(named: "likedClick.png"), for: .normal)
            likeCounter -= 1
            
        }
        
    }
    
    
    @IBAction func saveClicked(_ sender: Any) {
        
        if saveCounter == 0 {
            saveClick.setBackgroundImage(UIImage(named: "savedButton.png"), for: .normal)
            saveCounter += 1
        } else {
            saveClick.setBackgroundImage(UIImage(named: "saveButton.png"), for: .normal)
            saveCounter -= 1
            
        }
    }
    
    @IBAction func translateClicked(_ sender: Any) {
        
        let newTranslatedText = commentLabel.text
        
        // Create an English-Turkish translator:
        let options = TranslatorOptions(sourceLanguage: .en, targetLanguage: .tr)
        let englishTurkishTranslator = NaturalLanguage.naturalLanguage().translator(options: options)
        
        let conditions = ModelDownloadConditions(
            allowsCellularAccess: false,
            allowsBackgroundDownloading: true
        )
        englishTurkishTranslator.downloadModelIfNeeded(with: conditions) { error in
            guard error == nil else { return }
            
            // Model downloaded successfully. Okay to start translating.
        }
        
        englishTurkishTranslator.translate(newTranslatedText!) { translatedText, error in
            guard error == nil, let translatedText = translatedText else { return }
            
            // Translation succeeded.
            self.commentLabel.text = translatedText
            
        }
       
    }
    
}
