//
//  DesiredSkillTableViewCell.swift
//  MHWArmorSkillOptimizer
//
//  Created by Russell Boley on 3/18/18.
//  Copyright © 2018 Russell Boley. All rights reserved.
//

import UIKit

//protocol for buttons
protocol CurrentLevelDelegate {
    func didTapIncreaseLevel(skill: Skill)
    func didTapDecreaseLevel(skill: Skill)
}

class DesiredSkillTableViewCell: UITableViewCell {
    var delegate: CurrentLevelDelegate?
    var skillItem: Skill!
    
    @IBOutlet weak var skillName: UILabel!
    @IBOutlet weak var currentLevel: UILabel!
    
    func setSkill(skill: Skill){
        skillItem = skill
        skillName.text = skill.skillName
        currentLevel.text = String(skill.currentLevel)
    }
    
    @IBAction func increaseLevel(_ sender: Any) {
        delegate?.didTapIncreaseLevel(skill: skillItem)
    }
    
    @IBAction func decreaseLevel(_ sender: Any) {
        delegate?.didTapDecreaseLevel(skill: skillItem)
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
