//
//  MovieCell.swift
//  TechflixAndChill
//
//  Created by Scott Higgins on 4/21/16.
//  Copyright © 2016 Scott Higgins. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var synopsisLabel: UILabel!
    
    @IBOutlet weak var moviePosterImage: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
