import UIKit

public struct Armor {

    public var armorName: String
    public var armorSkills: [MathSkill]
    public var skills: [String]
    public var equipType: String
    public var jewelSlots: Array<Int>
    public var image: UIImage
    
    // var emptyArmor = Armor()
    public init() {
        self.armorName = "Empty"
        self.armorSkills = [MathSkill(name: "Empty",value: 0)]
        self.skills = ["Skill"]
        self.equipType = "Empty"
        self.jewelSlots = [0,0,0]
        self.image = UIImage(named: "Armor_Boots_Purple.png")!
    }
    
    public init(armorName: String,armorSkills: [MathSkill], jewelSlots: Array<Int>){
        self.armorName = armorName
        self.armorSkills = armorSkills
        
        // want to create an array of just skill names
        var skills: Array<String> = []
        for skill in armorSkills {
            skills.append((skill.name))
        }
        self.skills = skills
        //Now I want to determine what slot this gear is for... words that can identify what slot it should be:
        let head = ["helm","head","mask","hood","goggles","hat","circlet","gorget","shades","eyepatch","crown","brain","horn","glare","spectacles","faux felyne","lobos","vertex"]
        let chest = ["mail","jacket","suit","hide","cista","muscle","thorax"]
        let gloves = ["vambrace","guards","braces","grip","claw","longarm","grip","brachia"]
        let waist = ["coil","belt","hoop","spine","cocoon","bowels","elytra"]
        let boots = ["greaves","boots","pants","spurs","heel","crus ","crura"]
        
        switch armorName.lowercased() {
        case let x where (!(head.filter{x.contains($0)}.isEmpty)) :
            equipType = "Head"
            self.image = UIImage(named: "Armor_Head_Purple.png")!
        case let x where (!(gloves.filter{x.contains($0)}.isEmpty)):
            equipType = "Gloves"
            self.image = UIImage(named: "Armor_Gloves_Purple.png")!
        case let x where (!(chest.filter{x.contains($0)}.isEmpty)):
            equipType = "Chest"
            self.image = UIImage(named: "Armor_Chest_Purple.png")!
        case let x where (!(waist.filter{x.contains($0)}.isEmpty)):
            equipType = "Waist"
            self.image = UIImage(named: "Armor_Waist_Purple.png")!
        case let x where (!(boots.filter{x.contains($0)}.isEmpty)):
            equipType = "Boots"
            self.image = UIImage(named: "Armor_Boots_Purple.png")!
        default:
            equipType = "ERROR"
            self.image = UIImage(named: "Armor_Boots_Purple.png")!
        }
        //handling the jewel slots
        self.jewelSlots = jewelSlots
        
    }
    // add jewels
    //I want to print the skills this armor has
    public func readSkills() -> String{
        var string = "[\(self.armorName)] has the skills: "
        var integer = 0
        for skill in self.armorSkills {
            let name = skill.name
            let modifier = skill.value
            if integer > 0 {
                string += " & [\(name) \(modifier)]"
            } else {
                string += "[\(name) \(modifier)]"
            }
            integer += 1
        }
        return string
    }
    
    // I want to return if this armor contains a particular skill
    public enum Filter {
       public enum FilterType<T: Hashable> {
            case one(of: [T])
            case all(of: [T])
            
            //Match against the property that is a single value
            public func matches(_ value: T) -> Bool {
                switch self {
                case .one(let filterValues): return filterValues.contains(value)
                case .all(let filterValues): return filterValues.count == 1 && filterValues[0] == value
                }
            }
            //Match against a property that is a list of values
            public func matches(_ values: [T]) -> Bool {
                switch self {
                case .one(let filterValues): return !Set(filterValues).intersection(values).isEmpty
                case .all(let filterValues): return Set(filterValues).isSuperset(of: values)
                }
            }
        }
        // cases
        case skills(is: FilterType<String>)
        case armorName(is: FilterType<String>)
        
        public func matches(_ a: Armor) -> Bool {
            switch self {
            case .skills(let filterValues): return filterValues.matches(a.skills)
            case .armorName(let filterValues): return filterValues.matches(a.armorName)
            }
        }
    }
}




