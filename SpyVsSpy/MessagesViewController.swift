//
//  MessagesViewController.swift
//  SpyVsSpy
//
//  Created by Macbook on 12/5/17.
//  Copyright © 2017 Joseph Hinkle. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var sendButtonBottomConstraint: NSLayoutConstraint!
    var messages:[String] = []
    @IBOutlet weak var textfieldBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var messengerTableView: UITableView!
    @IBOutlet weak var textboxField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()


        //Listeners to move textbox (and send button) above/back down form keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        // Do any additional setup after loading the view.
        
        messages.append("Let's go to woodward to hack")
        
        messengerTableView.reloadData()
    }

    //    Move textbox above keyboard
    @objc func keyboardWillShow(notification: NSNotification) {
        if let info = notification.userInfo {
            let rect: CGRect = info["UIKeyboardFrameEndUserInfoKey"] as! CGRect
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
                self.textfieldBottomConstraint.constant = rect.height
                self.sendButtonBottomConstraint.constant = rect.height
            })
            
        }
    }
    
    //    Move textbox back down (prev. above keyboard)
    @objc func keyboardWillHide(notification: NSNotification) {
        if let info = notification.userInfo {
            let rect: CGRect = info["UIKeyboardFrameEndUserInfoKey"] as! CGRect
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
                self.textfieldBottomConstraint.constant = 8
                self.sendButtonBottomConstraint.constant = 8
            })
            
        }
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
