//
//  QuizVC.swift
//  TMIPractical
//
//  Created by jaydip kapadiya on 31/12/22.
//

import UIKit
import CoreData
class QuizVC: UIViewController {

    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblAttendQuestion: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var tblAnswer: UITableView!
    var question : [resultData?] = []
    var questionCount = Int()
    var arrAnswer : [String] = []
    var answerId : Int = -1
    var uuid  = UUID()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    func setupUI()
    {
        answerId = -1
        arrAnswer.removeAll()
        lblAttendQuestion.text = "Attend Question : \(questionCount+1)/\(question.count)"
        lblQuestion.attributedText = question[questionCount]?.question?.attributedHtmlString
        lblQuestion.attributedText = question[questionCount]?.question?.attributedHtmlString
        arrAnswer =  question[questionCount]?.incorrect_answers as! [String]
        arrAnswer.append(question[questionCount]?.correct_answer ?? "")
        arrAnswer.shuffle()
        tblAnswer.reloadData()
    }
    
    //MARK: - Button touchup methods
    @IBAction func btnNext_Click(_ sender: UIButton) {
        if answerId == -1
        {
            Utility.DisplayAlertWithTitle("Alert", Body: "Please select answer.", onViewcontriller: self)
            return
        }
        questionCount += 1
        if question.count - 1 < questionCount
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScoreVC")as! ScoreVC
            vc.uuid = uuid
            vc.totalQuestion = self.question.count
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            if question.count - 1 == questionCount
            {
                btnNext.setTitle("Finish", for: .normal)
            }
            self.setupUI()
        }
    }
    
    @objc func btnCheck_Click(_ sender : UIButton)
    {
        sender.isSelected = true
        if arrAnswer[sender.tag].attributedHtmlString == (question[questionCount]?.correct_answer ?? "").attributedHtmlString
        {
            sender.tintColor = .green
            self.saveAnswerData(answer: true)
        }
        else
        {
            sender.tintColor = .red
            self.saveAnswerData(answer: false)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.answerId = sender.tag
            self.tblAnswer.reloadData()
        })
    }
    
    //MARK: - CoreData Store
    func saveAnswerData(answer : Bool)
    {
        let auuid = UUID()
        let managecontext =  AppDelegate.classInstance().persistentContainer.viewContext
        guard let sessionsave = NSEntityDescription.entity(forEntityName: "Answerhistory", in: managecontext) else { return }
        let user = NSManagedObject(entity: sessionsave, insertInto: managecontext)
        user.setValue(answer, forKey: "answer")
        user.setValue(uuid, forKey: "questionid")
        user.setValue(auuid, forKey: "answerid")
        do
        {
            try managecontext.save()
        }
        catch let error as NSError{
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

//MARK: - Tableview delegate methods
extension QuizVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAnswer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: quizCell = tableView.dequeueReusableCell(withIdentifier: "quizCell", for: indexPath)as! quizCell
        cell.selectionStyle = .none
        cell.lblAnswer.attributedText = arrAnswer[indexPath.row].attributedHtmlString
        cell.btnCheck.isSelected = false
        cell.btnCheck.isUserInteractionEnabled = true
        cell.btnCheck.tag = indexPath.row
        cell.btnCheck.addTarget(self, action: #selector(btnCheck_Click), for: .touchUpInside)
        if self.answerId != -1
        {
            cell.btnCheck.isUserInteractionEnabled = false
            if answerId == indexPath.row
            {
                cell.btnCheck.isSelected = true
                cell.btnCheck.tintColor = .red
            }
            if arrAnswer[indexPath.row].attributedHtmlString == (question[questionCount]?.correct_answer ?? "").attributedHtmlString
            {
                cell.btnCheck.isSelected = true
                cell.btnCheck.tintColor = .green
            }
           
        }
        return cell
    }
}

