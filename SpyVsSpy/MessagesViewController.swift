//
//  MessagesViewController.swift
//  SpyVsSpy
//
//  Created by Macbook on 12/5/17.
//  Copyright © 2017 Joseph Hinkle. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController, UITableViewDataSource {
    
    var messages:[String] = []
    @IBOutlet weak var messengerTableView: UITableView!
    @IBOutlet weak var textboxField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        messages.append("Let's go to woodward to hack")
        
        messengerTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
//
//        let cellIdentifier = "MessageTableViewCell"
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MessageTableViewCell
        cell.textLabel?.textAlignment = NSTextAlignment.center
        cell.textLabel?.text = messages[indexPath.row]
//        cell?.messageLabel?.text = messages[indexPath.row]
//        cell?.nameLabel?.text = "Joseph Hinkle"
        
        return cell
    }
    @IBAction func sendButtonClicked(_ sender: Any) {
        if textboxField.text != "" {
            messages.append(textboxField.text!)
            textboxField.text = ""
            messengerTableView.reloadData()
        }
        view.endEditing(true)
    }
    
}
