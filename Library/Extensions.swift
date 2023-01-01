//
//  Extensions.swift
//  Meal Planner
//
//  Created by silversky on 11/05/22.
//

import Foundation
import UIKit
import AVFoundation

extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }

        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            // Change `Int` in the next line to `IndexDistance` in < Swift 4.1
            let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}

extension String {
    
    var utfData: Data {
        return Data(utf8)
    }
    
    var attributedHtmlString: NSAttributedString? {
        do {
            let attributeString =  try NSAttributedString(data: utfData, options: [
              .documentType: NSAttributedString.DocumentType.html,
              .characterEncoding: String.Encoding.utf8.rawValue,
            ],
            documentAttributes: nil)
            return NSAttributedString(string: attributeString.string,
                                      attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0)])
        } catch {
            print("Error:", error)
            return nil
        }
    }
}
