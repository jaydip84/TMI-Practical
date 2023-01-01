//
//  ScoreVC.swift
//  TMIPractical
//
//  Created by jaydip kapadiya on 01/01/23.
//

import UIKit
import CoreData

class ScoreVC: UIViewController {
    @IBOutlet weak var lblCurrentscore: UILabel!
    @IBOutlet weak var lblOverallScore: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    var uuid  = UUID()
    var totalQuestion = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.retriveCurrentScore()
        self.retriveOverallQuestion()
    }
    
    //MARK: - Button touchup methods
    @IBAction func btnBack_Click(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: false)
    }

    //MARK: -  CoreData Store
    func retriveCurrentScore()
    {
        let managecontext =  AppDelegate.classInstance().persistentContainer.viewContext
        let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Answerhistory")
        fetchrequest.predicate = NSPredicate(format: "questionid == %@ && answer == %@", uuid as CVarArg, true as NSNumber)
        do
        {
            let result : NSArray =  try managecontext.fetch(fetchrequest) as NSArray
            self.lblCurrentscore.text = "\(result.count)/\(totalQuestion)"
        }
        catch let error as NSError{
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func retriveOverallQuestion()
    {
        let managecontext =  AppDelegate.classInstance().persistentContainer.viewContext
        let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Questionhistory")
        do
        {
            let result : NSArray =  try managecontext.fetch(fetchrequest) as NSArray
            var TotalQuestion = Int()
            for quizQuestion in result
            {
                let questioncount = (quizQuestion as! NSManagedObject).value(forKey: "totalQuestion") as? Int ?? 0
                TotalQuestion += questioncount
                
            }
            self.retriveOverallScore(totalQuestion: TotalQuestion)
            
        }
        catch let error as NSError{
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    
    func retriveOverallScore(totalQuestion : Int)
    {
        let managecontext =  AppDelegate.classInstance().persistentContainer.viewContext
        let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Answerhistory")
        fetchrequest.predicate = NSPredicate(format: "answer == %@",true as NSNumber)
        do
        {
            let result : NSArray =  try managecontext.fetch(fetchrequest) as NSArray
            self.lblOverallScore.text = "\(result.count)/\(totalQuestion)"
        }
        catch let error as NSError{
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
