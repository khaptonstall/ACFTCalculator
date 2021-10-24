//
//  CSVReader.swift
//  
//
//  Created by Kyle Haptonstall on 10/24/21.
//

import Foundation

struct CSVReader {
    // MARK: Properties

    /// The entire contents of the CSV file in a single `String`.
    private let csvContents: String

    // MARK: Initialization

    /// Creates a new instance of `CSVReader` capable of operating on the given CSV file.
    /// - Parameter csvFileName: The name of the CSV file to read from. Do not include the ".csv" extension.
    init(csvFileName: String) throws {
        guard let csvPath = Bundle.module.path(forResource: csvFileName, ofType: "csv") else {
            throw ACFTCalculatorError.csvReadingFailure(reason: .fileNotFound(fileName: csvFileName))
        }

        self.csvContents = try String(contentsOfFile: csvPath)
    }

    // MARK: Reading Data

    /// Reads each row of the CSV file, using "," as a delimeter between columns in a row.
    /// - Parameter removeHeaders: Whether or not the first row, which commonly contains headers, should be removed. Defaults to `true`.
    /// - Returns: An array which each sub-array represents a single row separated by columns.
    ///
    /// As an example:
    /// ```
    ///  // The CSV "firstName,lastName,age\nsanta,clause,100" would return:
    /// [["firstName", "lastName", "age"], ["santa", "claus", "100"]]
    /// ```
    func readRows(removeHeaders: Bool = true) -> [[String]] {
        var rows = self.csvContents.components(separatedBy: "\n")

        if removeHeaders {
            rows.removeFirst()
        }

        return rows.map { $0.components(separatedBy: ",") }
    }

    /// Reads an individual column of the CSV.
    /// - Parameters:
    ///   - index: The index of the column to read.
    ///   - removeHeader: Whether or not the first row, which commonly contains headers, should be removed. Defaults to `true`.
    /// - Returns: An arrray containing each element in the column.
    func readColumn(atIndex index: Int, removeHeader: Bool = true) throws -> [String] {
        return try self.readRows(removeHeaders: removeHeader)
            .map { row in
            guard row.indices.contains(index) else {
                throw ACFTCalculatorError.csvReadingFailure(reason: .columnOutOfBounds(index: index))
            }
            return row[index]
        }
    }

}
