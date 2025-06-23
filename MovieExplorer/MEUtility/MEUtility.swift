//
//  MEUtility.swift
//  MovieExplorer
//
//  Created by Amogh Raut   on 23/06/25.
//

import Foundation

 class MEUtility {
    static func getImageURL(path: String?) -> URL? {
        guard let path = path else {
            return nil
        }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
    
     static func getHoursMins(minutes: Int?) -> String {
         guard let minutes = minutes else {
             return ""
         }
         let hours = minutes / 60
         let mins = minutes % 60
         return "\(hours)h \(mins)m"
     }
    
}
