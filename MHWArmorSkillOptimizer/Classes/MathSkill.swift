//
//  SkillsClass.swift
//  MHW Armor Skill Optimizer
//
//  Created by Russell Boley on 3/9/18.
//  Copyright © 2018 Russell Boley. All rights reserved.
//

import Foundation
import UIKit

public struct MathSkill{
    var name: String
    var value: Int
    
    public init(name: String, value: Int ){
        self.name = name
        self.value = value
    }
    
    public static func initWithRawValue(name: String, rawValue: String ) -> MathSkill {
        let intMatches = matches(for: "[0-9]", in: rawValue) //.matches(for: "[0-9]", in: rawValue)
        guard let intMatch = Int(intMatches.first!) else {return MathSkill(name: "Error", value: 0)}
        
        return MathSkill(name: name, value: intMatch)
    }
    
    
}
