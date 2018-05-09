//
//  Skill.swift
//  MHW Armor Skill Optimizer
//
//  Created by Russell Boley on 3/10/18.
//  Copyright © 2018 Russell Boley. All rights reserved.
//

import Foundation
import UIKit


public class Skill {
    public var skillName: String
    public var skillLevels: Array<[Int:String]>
    public var jewel: String?
    public var maxLevel: Int
    public var currentLevel: Int
    
    
    public init(skillName: String, skillLevels: Array<[Int:String]>, jewel: String?){
        self.skillName = skillName
        self.skillLevels = skillLevels
        self.jewel = jewel
        self.maxLevel = skillLevels.count
        self.currentLevel = 1
    }
    
    public func readLevels() -> String{
        var string = ""
        var integer = 0
        for skill in self.skillLevels {
            integer += 1
            let description = skill[integer]!
            if integer > 1 {
                string += "\nLevel \(String(integer)): \(description)"
            } else {
                string += "Level \(String(integer)): \(description)"
            }
        }
        return string
    }
    // Current Level methods
    public func increaseLevel(){
        if currentLevel < maxLevel {
            self.currentLevel = currentLevel + 1
        }
    }
    
    public func decreaseLevel(){
        if currentLevel > 1 {
            self.currentLevel = currentLevel - 1
        }
    }
    
    public func setLevel(level: Int) {
        if 1 ... maxLevel ~= level {
            self.currentLevel = level
        }
    }
}
