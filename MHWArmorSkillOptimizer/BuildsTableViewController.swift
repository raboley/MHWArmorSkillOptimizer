//
//  BuildsTableViewController.swift
//  MHWArmorSkillOptimizer
//
//  Created by Russell Boley on 3/16/18.
//  Copyright © 2018 Russell Boley. All rights reserved.
//

import UIKit

class BuildsTableViewController: UITableViewController {

    var bestBuilds = [Build]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // post loading processing
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bestBuilds.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "buildList", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = bestBuilds[indexPath.item].name
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBuild" {
            if let indexPath = tableView.indexPathForSelectedRow {
                // handling segue with a tab view controller is a little different.  the destination is a tab control, then you set the first view controller data, and the second.
                let tabVc = segue.destination as! UITabBarController
                let controller = tabVc.viewControllers?.first as! DetailBuildTableViewController
                let controllerTwo = tabVc.viewControllers?[1] as! DetailBuildSkillTableViewController
                
                let object = bestBuilds[indexPath.row]
                let armors = object.getArmors()
                
                let skills = object.flattenSkills()
                var skillsArray = [[String: Int]]()
                for skill in skills {
                    skillsArray.append([skill.key:skill.value])
                }
                
                controllerTwo.skills = skillsArray
                controller.armors = armors
            }
        }
    }
}
