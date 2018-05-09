//
//  BuildScoreEngine.swift
//  MHW Armor Skill Optimizer
//
//  Created by Russell Boley on 4/20/18.
//  Copyright © 2018 Russell Boley. All rights reserved.
//

import UIKit
import Foundation

// This page is to test the optimization engine since it takes forever to work.
/* Todo:
 1. add charms to the build
 2. figure out how to regulate skill maximums... maybe in readJSON function match the skill name with a skill and make MathSkill inherit from the Skill class.
 */

// --------- functions ---------------- //
// Think this is required for filter to work
extension Array where Element == Armor.Filter {
    func atLeastOneMatch(_ a: Armor) -> Bool {
        for filter in self where filter.matches(a) {return true}
        return false
    }
}

public class ArmorEngine {
    
    public func ScoreBuilds (desiredSkills: [MathSkill]) -> [Build]{
        
        var desiredSkillNames: Array<String> = []
        for skill in desiredSkills {
            desiredSkillNames.append(skill.name)
        }
        
        
        let desiredSkillFilters: [Armor.Filter] = [
            .skills(is: .one(of: desiredSkillNames)),
            ]
        
        // ---------  Loading the armors ------------------- //
        let JSONReader = ReadJSON()
        var armorList = JSONReader.readJSONObjectArmor(forResource: "RAW_Armor_JSON", withExtension: "json")
        
        
        // ---------  Filtering out armors that do not have the skills ------------------- //
        let armorsDesired = armorList.filter(desiredSkillFilters.atLeastOneMatch)
        
        
        
        // ---------  Score the armors ------------------- //
        // this will be based on armor skills, then slots.
        var scoresAndSkills:  [Int:Armor] = [0:Armor.init()]
        for armor in armorsDesired {
            var score:Int = 0
            // jewel slots get 30,20,10 per level and slot
            for slot in armor.jewelSlots {
                score = score + slot*10
            }
            //skill score, 1000 per lvl, multiplied by the number of desired skills of a desired skill, 5 for undesired skill level
            for skill in armor.armorSkills {
                // figure out how to match to the desired skills and weight them by reverse index
                if desiredSkillNames.contains(skill.name) {
                    score = score + (skill.value * 1000 - (100 * skill.value * (desiredSkills.index(where: {$0.name == skill.name})!)))
                }
                else {
                    score = score + 5
                }
            }
            scoresAndSkills[score] = armor
        }
        
        // ---------  Seperate them out into arrays by slot and only pick top 1 per skill per slot and max score ------------------- //
        // define slots so that I can do for each and grab only of the slot type
        
        // --------- split armors by equip slot ---------- //
        // initialize each array
        var armorHead = [Int:Armor]()
        var armorChest = [Int:Armor]()
        var armorGloves = [Int:Armor]()
        var armorWaist = [Int:Armor]()
        var armorBoots = [Int:Armor]()
        
        // get the top 1 score per slot and top 1 per skill desired
        
        func addBestArmorsByEquipType(armors: [(key:Int, value:Armor)],equipType: String, desiredSkills: [String]) -> [Armor] {
            let allArmors = armors
            var returnArmors: [Armor] = []
            var armorsOfType = allArmors.filter { $0.value.equipType == equipType }
            armorsOfType = armorsOfType.sorted(by: {$0.key > $1.key})
            // Crazy teting ~~~~~~~~~~~
            // returnArmors.append(contentsOf: armorsOfType.flatMap{$0.value})
            // end crazy testing ~~~~~~
            // ~~~~~~~~~~~~~~~~~~~~~~ Start: Multiple Desired Skills ~~~~~~~~~~~~~~~~
            // should also try to get all the ones that have multiple desired skills.
            // only do this if there are more than 1 desired skills
            if desiredSkills.count > 1 {
                //getting the desired skills in set form
                var setDesiredSkills = Set<String>()
                for skill in desiredSkills {
                    setDesiredSkills.insert(skill)
                }
                
                // Maybe map will work
                //armorsOfType.filter({$0.value.skills })
                
                // good old for each loop...
                for armor in armorsOfType {
                    var setArmorSkills = Set<String>()
                    for skill in armor.value.skills {
                        setArmorSkills.insert(skill)
                    }
                    
                    // now doing intersection to get the skills that both have in common. if greater than 1 add to armors to check
                    let common = setDesiredSkills.intersection(setArmorSkills)
                    
                    if common.count > 1 {
                        if (returnArmors.filter({$0.armorName == armor.value.armorName}).isEmpty) {
                            returnArmors.append(armor.value)
                        }
                        
                        // testing the intersection
                        print("\(armor.value.armorName) has skills: \(armor.value.readSkills())" )
                        print("Common is: \(common), with count \(common.count)")
                    }
                }
            }
            
            
            // ~~~~~~~~~~~~~~~~~~~~~~ End: Multiple Desired Skills ~~~~~~~~~~~~~~~~
            
            // ~~~~~~~~~~~~~~~~~~~~~~ Start: 1 & 2 level per skill ~~~~~~~~~~~~~~~~
            for skill in desiredSkillNames {
                // getting the best armor with lvl 1 of the skill
                let lvlOneSkillArmors = armorsOfType.filter({ $0.value.armorSkills.filter({$0.name == skill}).first?.value == 1})
                
                if let bestArmor = lvlOneSkillArmors.max(by: { a, b in a.key < b.key }) {
                    print("slot: \(equipType) skill: \(skill) score: \(bestArmor.key) slotbestArmor: \(bestArmor.value.readSkills())")
                    if (returnArmors.filter({$0.armorName == bestArmor.value.armorName}).isEmpty) {
                        returnArmors.append(bestArmor.value)
                    }
                }
                // getting the best armor with lvl 2 of the skill
                let lvlTwoSkillArmors = armorsOfType.filter({ $0.value.armorSkills.filter({$0.name == skill}).first?.value == 2})
                
                if let bestArmor = lvlTwoSkillArmors.max(by: { a, b in a.key < b.key }) {
                    print("slot: \(equipType) skill: \(skill) score: \(bestArmor.key) slotbestArmor: \(bestArmor.value.readSkills())")
                    if (returnArmors.filter({$0.armorName == bestArmor.value.armorName}).isEmpty) {
                        returnArmors.append(bestArmor.value)
                    }
                }
            }
            
            
            // ~~~~~~~~~~~~~~~~~~~~~~ End: 1 & 2 level per skill ~~~~~~~~~~~~~~~~
            
            // now get per skill the best armor
            var unScoredArmorsOfType = [Armor]()
            for armor in armorsOfType {
                unScoredArmorsOfType.append(armor.value)
            }
            for skill in desiredSkillNames {
                let filter: [Armor.Filter] = [
                    .skills(is: .one(of: [skill])),
                    ]
                let armorsWithSkill = unScoredArmorsOfType.filter(filter.atLeastOneMatch)
                // now get the one with the highest modifier
                //armorsWithSkill.max { a, b in a.armorSkills < b.key }
                //armorsWithSkill.first?.armorSkills.first(where: {$0.name == skill})
                
                // getting the armor with the highest modifier.  done by max function, and inside that pulling out the record of MathSkill type that has the correct name for the skill, and then comparing the value of it against other armors that have the same skill.
                // WIP - would like to pick the armor with the most jewel slots if there is a tie
                let bestArmorForSkill = armorsWithSkill.max {a, b in a.armorSkills.first(where: {$0.name == skill})!.value < b.armorSkills.first(where: {$0.name == skill})!.value}
                
                //just continue if there are no armors with that skill
                guard let armor = bestArmorForSkill else {continue}
                if (returnArmors.filter({$0.armorName == armor.armorName}).isEmpty) {
                    returnArmors.append(armor)
                }
                // ~~~~~~ remove the one just added
                //guard let index = armorsOfType.index(where: {$0.value.armorName == armor.armorName }) else {continue}
                //print("index for:\(armor.armorName) is :\(index)")
                //armorsOfType.remove(at: index)
                // ~~~~~~~~~~~~~~~~~~~~~~~ testing, how to do this better, to get highest score of skill ~~~~~~~~~~~~~~~ //
                let scoredArmorsWithSkill = armorsOfType.filter({$0.value.skills.contains(skill)})
                print("slot:\(equipType) for skill:\(skill) scored armors with skills count:\(scoredArmorsWithSkill.count)")
                let bestScoredArmorWithSkill = scoredArmorsWithSkill.max {a,b in a.key > b.key }
                guard let scoredArmor = bestScoredArmorWithSkill else {return returnArmors}
                print("score: \(scoredArmor.key) for armor \(scoredArmor.value.armorName)")
                // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //
                
            }
            // end skills
            
            
            // getting the best points one.
            let bestArmor = armorsOfType.max { a, b in a.key < b.key }
            guard let armor = bestArmor else{print("no armors with equipType of \(equipType)"); returnArmors.append(Armor.init()); return returnArmors}
            //Only adding a best points armor if it isn't already a best skill armor
            if (returnArmors.filter({$0.armorName == armor.value.armorName}).isEmpty) {
                returnArmors.append(armor.value)
            }
            
            
            return returnArmors
        }
        
        // sorting by score to have highest score first
        let scored = scoresAndSkills.sorted(by: {$0.key > $1.key})
        // creating the array of armors per each slot
        let headArmors = addBestArmorsByEquipType(armors: scored, equipType: "Head",desiredSkills: desiredSkillNames)
        let chestArmors = addBestArmorsByEquipType(armors: scored, equipType: "Chest",desiredSkills: desiredSkillNames)
        let gloveArmors = addBestArmorsByEquipType(armors: scored, equipType: "Gloves",desiredSkills: desiredSkillNames)
        let waistArmors = addBestArmorsByEquipType(armors: scored, equipType: "Waist",desiredSkills: desiredSkillNames)
        let bootsArmors = addBestArmorsByEquipType(armors: scored, equipType: "Boots",desiredSkills: desiredSkillNames)
        print(headArmors.count + chestArmors.count + gloveArmors.count + waistArmors.count + bootsArmors.count)
        
        /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ BEGIN Build Playground ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
        
        
        /*
         var testBuild = Build.init(name: "Test")
         testBuild.equip(armor: headArmors.first!)
         testBuild.equip(armor: chestArmors.first!)
         testBuild.equip(armor: gloveArmors.first!)
         testBuild.equip(armor: waistArmors.first!)
         testBuild.equip(armor: bootsArmors.first!)
         
         testBuild.calculateBuildScore(desiredSkills: desiredSkills)
         testBuild.score
         testBuild.printBuildDetails()
         */
        
        
        
        /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ END Build Playground ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
        
        // --------- Run through each armor combination and score build ------------ //
        var scoredBuilds = [Build]()
        var build = Build(name:"Best")
        
        
        // score all builds and return the best one
        for head in headArmors {
            build.equip(armor: head)
            for chest in chestArmors {
                build.equip(armor: chest)
                for gloves in gloveArmors {
                    build.equip(armor: gloves)
                    for waist in waistArmors {
                        build.equip(armor: waist)
                        for boot in bootsArmors {
                            build.equip(armor: boot)
                            build.calculateBuildScore(desiredSkills: desiredSkills)
                            let buildName: String = String(build.score)
                            build.rename(name: buildName)
                            scoredBuilds.append(build)
                        }
                    }
                }
            }
        }
        
        // calculate a build score
        let bestBuilds = scoredBuilds.sorted(by: {$0.score > $1.score})
        // ---------- Spit out best build ------------ //
        let bestBuild = bestBuilds.max { a, b in a.score < b.score }
        let worstBuild = bestBuilds.min { a, b in a.score < b.score }
        print(bestBuild!.printBuildDetails())
        print(worstBuild!.printBuildDetails())
        // my scoring is screwed up, bazel helm beta should have beat out bazel helm alpha...
        return bestBuilds
    }
}



