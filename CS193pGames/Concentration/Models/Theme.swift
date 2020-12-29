//
//  Theme.swift
//  Concentration
//
//  Created by Źmicier Fiedčanka on 17.12.20.
//

import UIKit

struct Theme {
    let name:           String
    var emojiChoices:   String
    let backgroudColor: UIColor
    let cardBackColor:  UIColor
    
    static let samples = [
        Theme(name: "Halloween", emojiChoices: "👻🎃🍭👹☠️😱🦇💀🧙‍♀️🪦", backgroudColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1), cardBackColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
        Theme(name: "Animals",  emojiChoices: "🐶🐱🦊🐹🐮🐻‍❄️🐸🐴🐠🦋", backgroudColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), cardBackColor: #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)),
        Theme(name: "Fruits",   emojiChoices: "🍏🍊🍋🍉🍇🥕🥨🍟🌭🧀", backgroudColor: #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), cardBackColor: #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)),
        Theme(name: "Sports",   emojiChoices: "⚽️🏀🏈⚾️⛳️🎱🏓⛸🥊🪃", backgroudColor: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), cardBackColor: #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)),
        Theme(name: "Flags",    emojiChoices: "🇲🇽🇦🇺🇨🇮🇫🇮🇯🇵🇪🇸🇺🇸🇧🇪🇬🇧🇷🇺", backgroudColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), cardBackColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)),
        Theme(name: "Emoji",    emojiChoices: "🥳😏🤓😎🥸😋🤯😥😳🤔", backgroudColor: #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), cardBackColor: #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1))
    ]
    
    
    static func themeSample(named name: String) -> Theme? {
        return Theme.samples.filter { $0.name == name }.first
    }
}
