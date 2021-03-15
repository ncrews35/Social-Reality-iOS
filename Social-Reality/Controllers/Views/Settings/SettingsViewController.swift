//
//  SettingsViewController.swift
//  Social-Reality
//
//  Created by Nick Crews on 2/27/21.
//

import UIKit
import Amplify
import AmplifyPlugins

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    struct CellTitles {
        
        static func title(_ index: Int) -> String {
            switch index {
            case 0:
                return "Information"
            case 1:
                return "Accessibility"
            case 2:
                return "Contact"
            case 3:
                return "Security"
            case 4:
                return "Payment"
            case 5:
                return "Sign Out"
            default:
                return ""
            }
        }
        
    }
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    @IBAction func tapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Cells.settingsCell.rawValue) as? settingsCell {
            cell.configureCell(title: CellTitles.title(indexPath.row))
            return cell
        } else {
            return settingsCell()
        }
    }
    
    
}
