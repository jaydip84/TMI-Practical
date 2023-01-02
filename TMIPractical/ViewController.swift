//
//  ViewController.swift
//  TMIPractical
//
//  Created by jaydip kapadiya on 31/12/22.
//

import UIKit
import DropDown
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var txtNumberOfQuestion: UITextField!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var txtDifficulty: UITextField!
    @IBOutlet weak var txtType: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var arrtrivia_categories : [categoryData] = []
    var arrcategory : [String] = []
    var categroyID = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCategories()
    }

    //MARK: - Button touchup methods
    @IBAction func btnCategory_Click(_ sender: UIButton) {
        let dropDown = DropDown()
        dropDown.anchorView = sender as  AnchorView
        dropDown.dataSource = arrcategory
        dropDown.selectionAction = { (index: Int, item: String) in
            self.txtCategory.text = item
            if item != "Any Category"
            {
                self.categroyID = self.arrtrivia_categories[index-1].id ?? 0
            }
            
            dropDown.hide()
        }
        dropDown.show()
    }
    
    @IBAction func btnDifficulty_Click(_ sender: UIButton) {
        let dropDown = DropDown()
        dropDown.anchorView = sender as  AnchorView
        dropDown.dataSource = ["Any Difficulty", "Easy", "Medium","Hard"]
        dropDown.selectionAction = { (index: Int, item: String) in
            self.txtDifficulty.text = item
            dropDown.hide()
        }
        dropDown.show()
    }
    
    @IBAction func btnType_Click(_ sender: UIButton) {
        let dropDown = DropDown()
        dropDown.anchorView = sender as  AnchorView
        dropDown.dataSource = ["Any Type", "Multiple Choice", "True / False"]
        dropDown.selectionAction = { (index: Int, item: String) in
            self.txtType.text = item
            dropDown.hide()
        }
        dropDown.show()
    }
    
    @IBAction func btnSubmit_Click(_ sender: UIButton) {
        if txtNumberOfQuestion.text == "0" || txtNumberOfQuestion.text == ""
        {
            Utility.DisplayAlertWithTitle("Alert", Body: "Please enter number of question", onViewcontriller: self)
            return
        }
        var BaseUrl : String = "https://opentdb.com/api.php?amount=\(self.txtNumberOfQuestion.text!)"
        if txtCategory.text != "Any Category"
        {
            BaseUrl = BaseUrl + "&category=\(categroyID)"
        }
        
        if txtDifficulty.text != "Any Difficulty"
        {
            BaseUrl = BaseUrl + "&difficulty=\(self.txtDifficulty.text!.lowercased())"
        }
        
        if txtType.text != "Any Type"
        {
            let param = self.txtType.text == "Multiple Choice" ? "multiple" : "boolean"
            BaseUrl = BaseUrl + "&type=\(param)"
        }
        self.getQuestions(BaseUrl: BaseUrl)
    }
    
    //MARK: - CoreData Store
    func saveQuestionData(questiondata : questionModel)
    {
        let uuid = UUID()
        let managecontext =  AppDelegate.classInstance().persistentContainer.viewContext
        guard let sessionsave = NSEntityDescription.entity(forEntityName: "Questionhistory", in: managecontext) else { return }
        let user = NSManagedObject(entity: sessionsave, insertInto: managecontext)
        user.setValue(questiondata.results.count , forKey: "totalQuestion")
        user.setValue(uuid, forKey: "uid")
        do
        {
            try managecontext.save()
            self.txtCategory.text = "Any Category"
            self.txtNumberOfQuestion.text = "10"
            self.txtDifficulty.text = "Any Difficulty"
            self.txtType.text = "Any Type"
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "QuizVC")as! QuizVC
            vc.question = questiondata.results
            vc.uuid = uuid
            self.navigationController?.pushViewController(vc, animated: true)
        }
        catch let error as NSError{
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    //MARK: - Api Call Functions
    
    func getCategories()
    {
        self.spinner.startAnimating()
        MVCServer().serviceRequestWithURL(reqMethod: .get,
                                          withUrl: "https://opentdb.com/api_category.php",
                                          withParam: [:],
                                          expecting: categoryModel.self) { responseCode, responseData in
            self.spinner.stopAnimating()
            if responseCode == 1
            {
                self.arrtrivia_categories = responseData?.trivia_categories ?? []
                self.arrcategory.append("Any Category")
                for categorydata in self.arrtrivia_categories
                {
                    self.arrcategory.append(categorydata.name ?? "")
                }
            }else
            {
                
            }
        }
    }
    
    func getQuestions(BaseUrl : String)
    {
        self.spinner.startAnimating()
        self.view.isUserInteractionEnabled = false
        MVCServer().serviceRequestWithURL(reqMethod: .get,
                                          withUrl: BaseUrl,
                                          withParam: [:],
                                          expecting: questionModel.self) { responseCode, responseData in
            self.spinner.stopAnimating()
            self.view.isUserInteractionEnabled = true
            if responseCode == 1
            {
                if responseData?.results.count  != 0
                {
                    self.saveQuestionData(questiondata: responseData!)
                }
                else
                {
                    Utility.DisplayAlertWithTitle("Alert", Body: "Question not available. Please try again.", onViewcontriller: self)
                }
            }else
            {
                
            }
        }
    }
}

