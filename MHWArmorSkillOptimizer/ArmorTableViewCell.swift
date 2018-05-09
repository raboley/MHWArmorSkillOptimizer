//
//  ArmorTableViewCell.swift
//  MHWArmorSkillOptimizer
//
//  Created by Russell Boley on 4/22/18.
//  Copyright © 2018 Russell Boley. All rights reserved.
//

import UIKit

class ArmorTableViewCell: UITableViewCell {
    var armorItem: Armor!
    
    @IBOutlet weak var armorName: UILabel!
    @IBOutlet weak var skills: UILabel!
    @IBOutlet weak var slots: UILabel!
    @IBOutlet var armorImage: UIImageView!
    
    func setArmor(armor: Armor){
        armorItem = armor
        armorName.text = armor.armorName
        // slots
        var slotText: String = "Slots:"
        for slot in armor.jewelSlots {
            if slot > 0{
                slotText = slotText + " \(slot)"
            }
        }
        if slotText == "Slots:"{
            slotText = "Slots: None"
        }
        slots.text = slotText
        
        // Skills
        var skillText: String = ""
        for skill in armor.armorSkills {
            skillText = "\(skill.name): \(String(skill.value))\n"
        }
        skills.text = skillText
        
        armorImage.image = armor.image
        //skillName.text = skill.skillName
        //currentLevel.text = String(skill.currentLevel)
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
