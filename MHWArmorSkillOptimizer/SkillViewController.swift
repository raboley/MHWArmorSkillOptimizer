//
//  ViewController.swift
//  MHW Armor Skill Optimizer
//
//  Created by Russell Boley on 3/9/18.
//  Copyright © 2018 Russell Boley. All rights reserved.
//

import UIKit

extension SkillViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

class SkillViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {

    // Search logic
    var filteredSkills = [Skill]()
    let searchController = UISearchController(searchResultsController: nil)
    // end search logic
    var skills = [Skill]()
    var desiredSkills = [Skill]()
    
    // MARK: - Private instance methods
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredSkills = skills.filter({( skill : Skill) -> Bool in
            return skill.skillName.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //self.filterContentForSearchText(searchText: text)
        return true
    }
   
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredSkills.count
        }
        return skills.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "desiredSkillCell", for: indexPath)
        let skill: Skill
        if isFiltering() {
            skill = filteredSkills[indexPath.row]
        } else {
            skill = skills[indexPath.row]
        }
        
        cell.textLabel?.text = skill.skillName
        return cell
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let skill: Skill
        if isFiltering() {
            skill = filteredSkills[indexPath.row]
        } else {
            skill = skills[indexPath.row]
        }
        
        print("de-selected\(skill.skillName)")
        let deselectName = skill.skillName
        if let index = desiredSkills.index(where: {$0.skillName == deselectName}) {
            desiredSkills.remove(at: index)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let skill: Skill
        if isFiltering() {
            skill = filteredSkills[indexPath.row]
        } else {
            skill = skills[indexPath.row]
        }
        
        print("selected\(skill.skillName)")
        desiredSkills.append(skill)
        print(desiredSkills)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @IBAction func add(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToMaster", sender: self)
    }
    // do segue
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Doing segue... have (\(desiredSkills.count)) objects in desired skills array")
        
        let controller = segue.destination as! MasterViewController
/*
        for object in desiredSkills {
            print("appending \(object.skillName) in master skills")
            controller.skills.append(object)
        }
 */
        controller.skills = desiredSkills
        controller.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        // importing Skills into Skills class objects
        let jsonReader = ReadJSON.init()
        let skillsList = jsonReader.readJSONObjectSkill(forResource: "SkillsData", withExtension: "json")
        skills = skillsList
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Skills"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // Keeping the selections from previous previous additions so that users can unselect, and ensure there are no duplicate skills added to the array.
        for skill in desiredSkills {
            if let index = skills.index(where: {$0.skillName == skill.skillName}) {
                let indexPath = IndexPath(row: index, section: 0)
                self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.none)
            }
            
        }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

