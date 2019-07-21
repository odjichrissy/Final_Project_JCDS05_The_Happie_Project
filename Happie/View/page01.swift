//
//  page01.swift
//  Happie
//
//  Created by Chrissy Satyananda on 08/07/19.
//  Copyright © 2019 Odjichrissy. All rights reserved.
//

import UIKit

class page01: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var questionView: UITextView!
    
    @IBOutlet weak var genderValue: UITextField!
    @IBOutlet weak var ageValue: UITextField!
    @IBOutlet weak var jobValue: UITextField!
    @IBOutlet weak var economicValue: UITextField!
    @IBOutlet weak var livingValue: UITextField!
    @IBOutlet weak var healthValue: UITextField!
    @IBOutlet weak var mentalValue: UITextField!
    @IBOutlet weak var socialValue: UITextField!
    @IBOutlet weak var quotesView: UITextView!
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var calculateButton: UIButton!
    
    @IBOutlet weak var scroll: UIScrollView!
    
    var questionNumber: Int = 0
    
    let quotes = QuoteBanks()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formView.layer.cornerRadius = 25
        calculateButton.layer.cornerRadius = 10
        
        let quoteRandom = Int.random(in: 1..<quotes.list.count)
        quotesView.text = quotes.list[quoteRandom].quoteText
        
        questionView.text = """
        The Happie Project is a system
        which predict the level of
        individual happiness based on
        the variety of life aspects
        """
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scroll.setContentOffset(CGPoint(x: 0, y: 140) , animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scroll.setContentOffset(CGPoint(x: 0, y: 0) , animated: true)
    }
    
    
    @IBAction func nextPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToPageResult", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPageResult" {
            
            var enteredGender : Double = 0
            if  genderValue.text?.lowercased() == "male"{
                enteredGender = 1
            }
            else if genderValue.text?.lowercased() == "female" {
                enteredGender = 0
            }
            
            let destinationVC = segue.destination as! pageResult
            destinationVC.genderPassed = enteredGender
            destinationVC.agePassed = Double(ageValue.text!)
            destinationVC.jobPassed = Double(jobValue.text!)
            destinationVC.economicPassed = Double(economicValue.text!)
            destinationVC.livingPassed = Double(livingValue.text!)
            destinationVC.healthPassed = Double(healthValue.text!)
            destinationVC.mentalPassed = Double(mentalValue.text!)
            destinationVC.socialPassed = Double(socialValue.text!)
        }
    }
    
    @IBAction func unwindToOne(_ sender: UIStoryboardSegue){
        scroll.setContentOffset(CGPoint(x: 0, y: 0) , animated: true)
        genderValue.text = ""
        ageValue.text = ""
        jobValue.text = ""
        economicValue.text = ""
        livingValue.text = ""
        healthValue.text = ""
        mentalValue.text = ""
        socialValue.text = ""
    }
    
}
