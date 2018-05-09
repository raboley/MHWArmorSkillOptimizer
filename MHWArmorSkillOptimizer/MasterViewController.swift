//
//  MasterViewController.swift
//  MHWArmorSkillOptimizer
//
//  Created by Russell Boley on 3/12/18.
//  Copyright © 2018 Russell Boley. All rights reserved.
//

// TODO: fix skill up button, create skill down button

import UIKit

class MasterViewController: UITableViewController {
    // for the split view.  This is what shows in the detail part of the split view
    var detailViewController: BuildsTableViewController? = nil
    
    var skills = [Skill]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem
        // Split view setup
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? BuildsTableViewController
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // split view segue
        if segue.identifier == "showBuilds" {
                let controller = (segue.destination as! UINavigationController).topViewController as! BuildsTableViewController
                //let controller = segue.destination as! BuildsTableViewController
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                
                let armorEngine = ArmorEngine()
                var mathSkills = [MathSkill]()
                for object in skills {
                    let mathSkill = MathSkill(name: object.skillName, value: object.currentLevel)
                    mathSkills.append(mathSkill)
                }
                let builds = armorEngine.ScoreBuilds(desiredSkills: mathSkills)
                controller.bestBuilds = builds
                controller.tableView.reloadData()
            
        }
        if segue.identifier == "calculate" {
            let controller = segue.destination as! BuildsTableViewController

            let armorEngine = ArmorEngine()
            var mathSkills = [MathSkill]()
            for object in skills {
                let mathSkill = MathSkill(name: object.skillName, value: object.currentLevel)
                mathSkills.append(mathSkill)
            }
            let builds = armorEngine.ScoreBuilds(desiredSkills: mathSkills)
            controller.bestBuilds = builds
            controller.tableView.reloadData()
        }
        if segue.identifier == "addSkills" {
            let controller = segue.destination as! SkillViewController
            controller.desiredSkills = skills
        }

    }
    // this is for the skill selector, to allow you to go back to the desired skills table view
    @IBAction func unwindToMaster(segue: UIStoryboardSegue) {}
    
    @IBAction func calculateBuild(_ sender: Any) {
        for object in skills {
            print(object.skillName)
        }
        tableView.reloadData()
    }
    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return skills.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DesiredSkillTableViewCell
        let skill = skills[indexPath.row]
        // cell building is handled in cell class
        cell.setSkill(skill: skill)
        // cell delegate helps determine which cell the buttons belong to
        cell.delegate = self
                return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            skills.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}

extension MasterViewController: CurrentLevelDelegate {
    func didTapIncreaseLevel(skill: Skill) {
        skill.increaseLevel()
        tableView.reloadData()
    }
    
    func didTapDecreaseLevel(skill: Skill) {
        skill.decreaseLevel()
        tableView.reloadData()
    }
}

