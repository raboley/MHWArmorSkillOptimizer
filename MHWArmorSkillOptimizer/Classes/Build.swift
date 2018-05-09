import UIKit
import Foundation

//make a class of type Build
public struct Build {
    public var name: String
    var head: Armor = Armor()
    var chest: Armor = Armor()
    var gloves: Armor = Armor()
    var waist: Armor = Armor()
    var boots: Armor = Armor()
    public var score: Int = 1
    
    public init (name:String) {
        self.name = name
        self.head = Armor()
        self.chest = Armor()
        self.gloves = Armor()
        self.waist = Armor()
        self.boots = Armor()
        self.score = 0
    }
    
    public func getSkillArray() -> [[MathSkill]] {
        var skillArray: [[MathSkill]] = []
        // getting all the skills arrays into an arrayf
        skillArray.append(head.armorSkills)
        skillArray.append(chest.armorSkills)
        skillArray.append(gloves.armorSkills)
        skillArray.append(waist.armorSkills)
        skillArray.append(boots.armorSkills)
        
        return skillArray
    }
    // get slots
    public func getJewelSlots() -> [Int] {
        var jewelSlotArray = [[Int]]()
        // getting all the skills arrays into an arrayf
        jewelSlotArray.append(head.jewelSlots)
        jewelSlotArray.append(chest.jewelSlots)
        jewelSlotArray.append(gloves.jewelSlots)
        jewelSlotArray.append(waist.jewelSlots)
        jewelSlotArray.append(boots.jewelSlots)
        let returnArray = jewelSlotArray.flatMap {$0}
        return returnArray
    }
    
    public func getArmors() -> [Armor] {
        var returnArmor = [Armor]()
        returnArmor.append(self.head)
        returnArmor.append(self.chest)
        returnArmor.append(self.gloves)
        returnArmor.append(self.waist)
        returnArmor.append(self.boots)
        return returnArmor
    }
    
    public mutating func rename (name: String){
        self.name = name
    }
    
    public mutating func equip (armor: Armor){
        
        switch armor.equipType {
        case "Head":
            self.head = armor
        case "Chest":
            self.chest = armor
        case "Gloves":
            self.gloves = armor
        case "Waist":
            self.waist = armor
        case "Boots":
            self.boots = armor
        default:
            print("no equiptype for:\(armor)")
        }
    }
    
    //Flatten skill list for build
    public func flattenSkills() -> [String : Int] {
        let skillArrayArray = self.getSkillArray()
        // trying to do this the flatmap way
        let flat = skillArrayArray.flatMap {$0}
        // Might need to add maximum to build skill or something like that.
        let buildSkillTotals = flat.reduce(([String : Int]())) { accumulator, value in
            var currentData = accumulator
            if value.name != "Empty" {
                // if we already have an entry for name then sum it with this one
                if accumulator.keys.contains(value.name) {
                    currentData[value.name] = accumulator[value.name]! + value.value
                    return currentData
                    // if we don't have an entry for it, then add it to the accumulator
                } else {
                    currentData[value.name] = value.value
                    return currentData
                }
            }
            else {
                return currentData
            }
            
        }
        return buildSkillTotals
    }
    

    //function for reading out the skills in a way I can see
    public func printBuildDetails() {
        let skills = self.flattenSkills()
        let map = skills.map {"\($0.key):\($0.value)"}
        let slots = self.getJewelSlots().filter{$0 != 0}
        print(
            """
            Build: \(self.name)
            Score: \(self.score)
            slots: \(slots)
            skills: \(map)
            head: \(self.head.readSkills())
            chest:\(self.chest.readSkills())
            gloves:\(self.gloves.readSkills())
            waist:\(self.waist.readSkills())
            boots:\(self.boots.readSkills())
            """)
        
    }
    
    // function to calculate score based on desired skills vs build skills
    public mutating func calculateBuildScore (desiredSkills: [MathSkill]) {
        
        let skillArrayArray = self.getSkillArray()
        /*
         var skillArray: [MathSkill] = []
         
         // getting the Int of each skill level and name dict, and storing it in MathSkill
         for skills in skillArrayArray {
         for skill in skills {
         skillArray.append(skill)
         }
         }
         
         //getting all the skill names
         var resultArray = [MathSkill]()
         let allKeys = Set<String>(skillArray.filter({!$0.name.isEmpty}).map{$0.name})
         for key in allKeys {
         let sum = skillArray.filter({$0.name == key}).map({$0.value}).reduce(0, +)
         resultArray.append(MathSkill(name:key, value:sum))
         }
         
         resultArray = resultArray.sorted(by: {$0.value < $1.value})
         */
        // trying to do this the flatmap way
        let flat = skillArrayArray.flatMap {$0}
        // Might need to add maximum to build skill or something like that.
        let buildSkillTotals = flat.reduce(([String : Int]())) { accumulator, value in
            var currentData = accumulator
            // if we already have an entry for name then sum it with this one
            if accumulator.keys.contains(value.name) {
                currentData[value.name] = accumulator[value.name]! + value.value
                return currentData
                // if we don't have an entry for it, then add it to the accumulator
            } else {
                currentData[value.name] = value.value
                return currentData
            }
        }
        
        // for scoring, want first one to be worth way more then next
        var skillDiff = [MathSkill]()
        var i = desiredSkills.count + 1
        var totalScore = 1
        for skill in desiredSkills {
            //let desiredValue = skill.value
            // get the value in result array that matches the skill name of this
            for result in buildSkillTotals {
                if result.key == skill.name {
                    // I want to be able to score this.  Higher score for builds that have more of the required skill up to cap.
                    //should be i * skill that have up to cap
                    let have = result.value - skill.value
                    if have >= 0 {
                        // if this is positve then build has more of required skill than needed.  only give the amount required the boosted score, then give the extras the normal score
                        totalScore = totalScore + (skill.value * i * 1000) + (have * 5 )
                        
                    }
                    else {
                        // this means the build doesn't have all the level of the skill required.
                        totalScore = totalScore + (result.value * 1000)
                    }
                    
                    let diff = skill.value - result.value
                    skillDiff.append(MathSkill(name: skill.name, value: diff))
                    // this makes the first item in the array worth way more than second.  Might have to change it actually because it would take 5 tier two skills to outrank 1 tier 1
                    //var score = Double(diff)/i
                    //totalScore = totalScore + score
                    //print(totalScore)
                }
                else {
                    totalScore = totalScore + (result.value * 5)
                }
            }
            //let buildValue =
            i = i - 1
        }
        //if totalScore == 1.00 {build.score = 99} else{
        //build.score = totalScore
        //}
        /*
         i = 1
         var score = 0
         totalScore = 1
         for skill in skillDiff {
         if (skill.value > 0) {
         print("\(skill.name) is \(skill.value) away from desired value")
         score = skill.value/i
         print(score)
         totalScore = totalScore + score
         
         } else {
         print("\(skill.name) has the desired value")
         }
         }
         */
        //Now doing it for slots
        let jewelSlots = getJewelSlots()
        // each jewel gets 10 points per level, then summing them with reduce
        let jewelsScore = jewelSlots.map{$0 * 10}.reduce(0, +)
        totalScore = totalScore + jewelsScore
        
        self.score = totalScore
    }
}
/* `````````` END build struct definition ``````````` */
