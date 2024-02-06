//
//  CSVToJSONParser.swift
//  1GPS
//
//  Created by Дима Самойленко on 05.02.2024.
//

import Foundation

struct CSVToJSONParser {
    let csvString: String
    let delimiter: Character

    init(csvString: String, delimiter: Character = ";") {
        self.csvString = csvString
        self.delimiter = delimiter
    }
    
    func convertCSVtoJSON() -> Data? {
        let rows = csvString.components(separatedBy: "\n")
        
        var rowData = [String : Any]()

        guard let columnNames = rows.first?.components(separatedBy: String(delimiter)) else {
            print("Отсутствуют названия столбцов")
            return nil
        }

        for row in rows.dropFirst() {
            let columns = row.components(separatedBy: String(delimiter))
            
            guard columns.count == columnNames.count else {
                print("Некорректное количество столбцов в строке: \(row)")
                continue
            }

            
            for (index, column) in columns.enumerated() {
                let key = columnNames[index]
                rowData[key] = column
            }            
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: rowData, options: .prettyPrinted)
            return jsonData
        } catch {
            print("Ошибка при преобразовании в JSON: \(error.localizedDescription)")
            return nil
        }
    }
}

