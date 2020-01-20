//
//  HomeTableViewCell.swift
//  Homeworks
//
//  Created by Carlos Tlelo  on 1/17/20.
//  Copyright © 2020 Carlos Tlelo . All rights reserved.
//

import UIKit


// Archivo o clase, que nos hacer referencia con los componente del tableViewController, aqui solo referencias los objetos o componentes
// de la interfaz
class HomeTableViewCell: UITableViewCell {
    
    // Label referenciados para utilizarse en el TableViewController
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
