//
//  ReadJSONArmor.swift
//  MHW Armor Skill Optimizer
//
//  Created by Russell Boley on 3/10/18.
//  Copyright © 2018 Russell Boley. All rights reserved.
//

import Foundation

public class ReadJSON {
    public init() {
        
    }
    
    public func loadJSON(forResource: String, withExtension: String) -> [String: AnyObject]{
        let url = Bundle.main.url(forResource: forResource, withExtension: withExtension)
        let data = NSData(contentsOf: url!)
        do {
            let object = try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments)
            return object as! [String: AnyObject]
        }
        catch let error {
            print("invalid JSON format: \(error.localizedDescription)")
            return ["Error":error.localizedDescription as AnyObject]
        }
        
    }
    
    public func matches(for regex: String, in text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    public func readJSONObjectArmor(forResource: String, withExtension: String) -> Array<Armor>{
        // this function should read the json object and return an array full of Armor class objects
        var object = loadJSON(forResource: forResource,withExtension: withExtension)
        var armorsClass: [Armor] = []
        
        guard let armors = object["Armor"] as? [[String: AnyObject]] else { print("Error object passed in is not a [String: AnyObject] dictionary type.  Pass in correct type and try again"); return armorsClass}
        
        for armor in armors {
            guard let name = armor["ArmorName"] as? String else {print("ArmorName is null, breaking"); break}
            
            var skills: [MathSkill] = []
            guard let skillList = armor["ArmorSkills"] as? [[String: AnyObject]] else { print("Armor[\(name) has no skills???"); return armorsClass }
            for skill in skillList {
                skills.append(MathSkill.initWithRawValue(name:skill["Skill"] as! String, rawValue:skill["SkillModifier"] as! String ))
            }
            var slots = Array<Int>()
            // get the slots in order
            if (armor["Slot1"] as? String) != nil {
                //add slot method
                slots.append(1)
            }
            if (armor["Slot2"] as? String) != nil {
                //add slot method
                slots.append(2)
            }
            if (armor["Slot3"] as? String) != nil {
                //add slot method
                slots.append(3)
            }
            // add this armor to armorsClass
            armorsClass.append(Armor(armorName: name, armorSkills: skills, jewelSlots: slots))
        }
        return armorsClass
    }
    
    public func readJSONObjectSkill(forResource: String, withExtension: String) -> Array<Skill>{
        
        let object = loadJSON(forResource: forResource, withExtension: withExtension)
        // this function should read the json object and return an array full of Armor class objects
        var skillsClass: [Skill] = []
        
        guard let skills = object["Skill"] as? [[String: AnyObject]] else { print("Error object passed in is not a [String: AnyObject] dictionary type.  Pass in correct type and try again"); return skillsClass}
        
        for skill in skills{
            // Getting the skill names
            guard let name = skill["skillName"] as? String else {print("skillName is null, Breaking"); break}
            // Getting the skill levels so we can see how many skill levels they are
            guard let skillLevels = skill["levels"] as? [[String: AnyObject]] else { print("skill[\(name) has no levels???"); return skillsClass }
            
            // Don't care if there is a jewel or not so making that optional
            let jewel = skill["jewelName"] as! String?
            
            var levels: Array<[Int: String]> = []
            var maxLevel:Int = 0
            for skillLevel in skillLevels {
                //skillLevel["levelName"]
                //skillLevel["levelDescription"]
                
                let levelIntMatches = matches(for: "[0-9]", in: skillLevel["levelName"] as! String)
                let levelInt = Int(levelIntMatches.first!)
                let levelDescription = skillLevel["levelDescription"] as! String
                levels.append([levelInt!: levelDescription])
                maxLevel = maxLevel + 1
            }
            
            // final add to skillsClass array
            skillsClass.append(Skill(skillName: name, skillLevels: levels, jewel: jewel))
        }
        
        return skillsClass
    }
}
