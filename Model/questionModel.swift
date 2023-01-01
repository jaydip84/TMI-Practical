//
//  AssingIssueModel.swift
//  Hygine
//
//  Created by jaydip kapadiya on 12/10/22.
//

import Foundation

struct questionModel : Codable
{
    var response_code : Int?
    var results : [resultData?]
}

struct resultData : Codable
{
    var category : String?
    var type : String?
    var difficulty : String?
    var question : String?
    var correct_answer : String?
    var incorrect_answers : [String?]
}
