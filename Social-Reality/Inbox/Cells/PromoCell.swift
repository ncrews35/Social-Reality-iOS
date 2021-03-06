//
//  PromoCell.swift
//  Social-Reality
//
//  Created by Nick Crews on 2/27/21.
//

import UIKit

// MARK: - Promo Cell

class PromoCell: UITableViewCell {
    
    // MARK: - Identifiers
    
    enum identifiers: String {
        case promoCell
    }

    // MARK: - Outlets
    
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    // MARK: - Cell Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - Configure Methods
    
    func configureCell() {
        
    }
    
}

