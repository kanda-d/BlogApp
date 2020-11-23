//
//  MessageViewCell.swift
//  TryHarder
//
//  Created by Akhil Chaudhary on 09/10/20.
//

import UIKit
protocol CellDelegate {
    func CallBtnTapped(tag: Int)
}

class MessageViewCell: UITableViewCell {

    @IBOutlet weak var labelSender: UILabel!
    
    var delegate: CellDelegate?
    var indexNo: Int = 0
    
    @IBOutlet weak var DescriptionLabel: UILabel!
    
    @IBOutlet weak var blogImage: UIImageView!
    
    @IBAction func ViewBtn(_ sender: UIButton) {
        
        delegate?.CallBtnTapped(tag: indexNo)
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
