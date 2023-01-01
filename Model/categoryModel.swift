//
//  StaffMonitorDetailModel.swift
//  Hygine
//
//  Created by jaydip kapadiya on 12/10/22.
//

import Foundation
struct categoryModel : Codable
{
    var trivia_categories : [categoryData]
}

struct categoryData : Codable
{
    var id : Int?
    var name : String?
}
