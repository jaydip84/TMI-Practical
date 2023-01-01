//
//  quizCell.swift
//  TMIPractical
//
//  Created by jaydip kapadiya on 31/12/22.
//

import UIKit

class quizCell: UITableViewCell {

    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var lblAnswer: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
