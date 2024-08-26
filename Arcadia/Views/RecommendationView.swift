//
//  RecommendationView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 24/07/24.
//

import SwiftUI
import SQLite3
import TabularData
import Accelerate
import NaturalLanguage

enum ArcadiaRecommendationLoadingState: String {
    case loading = "Loading"
    case retrievingGames = "Retrieving your games"
    case queryingDatabase = "Retrieving the console games"
    case generatingEmbeddings = "Generating embeddings"
    case calculatingSimilarity = "Calculating similarity"
    case retrievingRecommendations = "Retrieving recommendations"
    case completed = "Completed"
}

struct ArcadiaRecommendationGameInfo: Hashable {
    public var md5: String
    public var name: String
    public var description: String
    public var releaseCover: URL?
    public var releaseDate: String
    public var releaseDeveloper: String
    
    init(md5: String, name: String, description: String, releaseCover: String, releaseDate: String, releaseDeveloper: String) {
        self.md5 = md5
        self.name = name
        self.description = description
        self.releaseCover = URL(string: releaseCover)
        self.releaseDate = releaseDate
        self.releaseDeveloper = releaseDeveloper
    }
}

struct RecommendationView: View {
    @Environment(\.dismiss) var dismiss
    @State private var loadingState = ArcadiaRecommendationLoadingState.loading
    @State private var recommendations = [ArcadiaRecommendationGameInfo]()
    @State private var gameSystem: ArcadiaGameType
    
    init(gameSystem: ArcadiaGameType) {
        self.gameSystem = gameSystem
    }
    
        var body: some View {
            NavigationStack {
                Group {
                    if loadingState != .completed {
                        VStack {
                            ProgressView()
                            Text(loadingState.rawValue)
                        }
                    } else {
                        if !recommendations.isEmpty {
                            List(recommendations, id: \.self) { recommendation in
                                HStack {
                                    AsyncImage(url: recommendation.releaseCover) { phase in
                                        switch phase {
                                            case .empty:
                                                gameSystem.defaultCollectionImage
                                                .frame(maxWidth: 40, maxHeight: 40)
                                            case .success(let image):
                                                image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(maxWidth: 40, maxHeight: 40)
                                            case .failure:
                                                gameSystem.defaultCollectionImage
                                                .frame(maxWidth: 40, maxHeight: 40)
                                            @unknown default:
                                                EmptyView()
                                        }
                                    }
                                    Text(recommendation.name)
                                }
                            }
                            
                        } else {
                            Text("No recommendation found. Keep in mind that for recommendations to be found your games have to match the internal database, this won't work with homebrew games unfortunately.")
                        }
                    }
                }
                .frame(minWidth: 300, minHeight: 300)
                .navigationTitle("Recommendation")
                .toolbar() {
                    ToolbarItem(placement: .automatic) {
                        Button(role: .cancel, action: {
                            dismiss()
                        }, label: {
                            Label("Dismiss", systemImage: "xmark")
                        })
                    }
                   
                }
                #if os(iOS)
                    .navigationBarTitleDisplayMode(.inline)
                #endif
            }
            .onAppear {
                DispatchQueue.global(qos: .userInteractive).async {
                    loadingState = .retrievingGames
                    let matchingFiles = queryMatchingFiles()
                    if matchingFiles.isEmpty {
                        loadingState = .completed
                        return
                    }
                    loadingState = .queryingDatabase
                    let dataFrame = queryAllRoms()
                    
                    guard var dataFrame = dataFrame else { return }
                    
                    loadingState = .generatingEmbeddings
                    var descriptionEmbeddings = Column<[Double]>(name: "descriptionEmbeddings", contents: Array(repeating: [Double](), count: dataFrame.rows.count))
                    var genresEmbedding = Column<[Double]>(name: "genresEmbedding", contents: Array(repeating: [Double](), count: dataFrame.rows.count))
                    
                    let embedding = try! NLEmbedding.init(contentsOf: Bundle.main.url(forResource: "WordEmbedding", withExtension: "mlmodelc")!)
                    
                    DispatchQueue.concurrentPerform(iterations: dataFrame.rows.count) { index in
                        
                            if let value = dataFrame["releaseDescription"][index] as? String {
                                    if let vector = embedding.vector(for: value) {
                                        descriptionEmbeddings[index] = vector
                                    }
                            }
                            
                            if let value = dataFrame["releaseGenre"][index] as? String {
                                    if let vector = embedding.vector(for: value) {
                                        genresEmbedding[index] = vector
                                    }
                            }
                        
                    }
                    
                    dataFrame.append(column: genresEmbedding)
                    dataFrame.append(column: descriptionEmbeddings)
                    //dataFrame.removeColumn(ColumnID("releaseGenre", String.self))
                    //dataFrame.removeColumn(ColumnID("releaseDescription", String.self))

                    let matchingFrameSlice = dataFrame.filter{ row in
                        if let md5 = row["romhashmd5"] as? String, let titleName = row["releastTitleName"] as? String {
                            for file in matchingFiles {
                                if file.md5 == md5 || file.name == titleName {
                                    return true
                                }
                            }
                        }
                        return false
                    }
                                        
                    let filteredFrameSlice = dataFrame.filter { row in
                        if let md5 = row["romhashmd5"] as? String, let titleName = row["releastTitleName"] as? String {
                            for file in matchingFiles {
                                if file.md5 == md5 || file.name == titleName {
                                    return false
                                }
                            }
                        }
                        return true
                    }
                    
                    
                    let matchingFrame = DataFrame(matchingFrameSlice)
                    var filteredFrame = DataFrame(filteredFrameSlice)
                    filteredFrame = removeDuplicates(from: filteredFrame, basedOn: "releastTitleName")
                    
                    let distance = Column<Double>(name: "similarityColumn", contents: Array(repeating: 0.0, count: filteredFrame.rows.count))
                    filteredFrame.append(column: distance)
                    
                    loadingState = .calculatingSimilarity
                    for row in matchingFrame.rows {
                        
                        if let mainGenre = row["releaseGenre"] as? String, let mainDescription = row["releaseDescription"] as? String {
                            for index in 0..<filteredFrame.rows.count {
                                if let filteredGenre = filteredFrame["releaseGenre"][index] as? String, let filteredDescription = filteredFrame["releaseDescription"][index] as? String {
                                    
                                    let genreDistance = embedding.distance(between: mainGenre, and: filteredGenre)
                                    let descriptionDistance = embedding.distance(between: mainDescription, and: filteredDescription)
                                    
                                    let averageDistance = (genreDistance + descriptionDistance) / 2.0
                                    
                                    // Add the averageDistance to the current sum in similarityColumn
                                    filteredFrame["similarityColumn"][index] = (filteredFrame["similarityColumn"][index] as! Double) + averageDistance
                                }
                            }
                        }
                    }

                    // Calculate the average of the averages
                    let totalIterations = matchingFrame.rows.count

                    for index in 0..<filteredFrame.rows.count {
                        if totalIterations > 0 {
                            filteredFrame["similarityColumn"][index] = (filteredFrame["similarityColumn"][index] as! Double) / Double(totalIterations)
                        }
                    }

                    
                    let sortedFrame = filteredFrame.sorted(on: ColumnID("similarityColumn", Double.self)) { firstElement, secondElement in
                        secondElement > firstElement
                        
                    }
                    
                    let similarHashes = sortedFrame["romhashmd5"].map { $0 as! String }
                    loadingState = .retrievingRecommendations
                    recommendations = queryMatchingInfos(matchingMD5: Array(similarHashes[0..<10]))
                    loadingState = .completed
                }
                
                
                
            }
    }
    
    func cosineSimilarity(rowA: [Double], rowB: [Double]) -> Double {
        // Ensure both vectors have the same length
        if rowA.count != rowB.count {
            return 0
        }
        
        var dotProduct: Double = 0
        var magnitudeA: Double = 0
        var magnitudeB: Double = 0
        
        // Calculate dot product and magnitudes
        for i in 0..<rowA.count {
            dotProduct += rowA[i] * rowB[i]
            magnitudeA += rowA[i] * rowA[i]
            magnitudeB += rowB[i] * rowB[i]
        }
        
        // Take square root of magnitudes
        magnitudeA = sqrt(magnitudeA)
        magnitudeB = sqrt(magnitudeB)
        
        // Handle case where one of the magnitudes is zero to avoid division by zero
        guard magnitudeA != 0 && magnitudeB != 0 else {
            return 0 // Or handle as needed
        }
        
        // Return cosine similarity
        return dotProduct / (magnitudeA * magnitudeB)
    }
        
    func openDatabase() -> OpaquePointer? {
        guard let fileURL = Bundle.main.url(forResource: "openvgdb", withExtension: "sqlite") else {
            print("Database file not found in bundle.")
            return nil
        }
        print("Database file path: \(fileURL.path)")
        
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            debugPrint("Cannot open DB. Error: \(String(cString: sqlite3_errmsg(db)))")
            return nil
        } else {
            print("DB successfully opened.")
            return db
        }
    }
    
    func queryAllRoms() -> DataFrame? {
        guard let db = openDatabase() else { return nil }
        defer { sqlite3_close(db) }
        
        
        let queryStatementString = """
        WITH results AS (
            SELECT
                roms.romid,
                roms.romhashmd5,
                systems.systemid,
                systems.systemshortname,
                releasetitlename,
                releaseDescription,
                UPPER(releaseGenre) AS releaseGenre,
                ROW_NUMBER() OVER (PARTITION BY roms.romID ORDER BY releases.regionLocalizedId) AS row_number
            FROM roms
            LEFT JOIN releases ON roms.romID = releases.romID
            LEFT JOIN systems ON roms.systemID = systems.systemID
            WHERE systems.systemID IN (\(gameSystem.dbSystemId.joined(separator: ", ")))
        )
        SELECT
            romhashmd5,
            systemshortname,
            releaseGenre,
            releaseDescription,
            releasetitlename
        FROM results
        WHERE row_number = 1
        """
        
        var queryStatement: OpaquePointer? = nil
        var rows = [[String]]()
        var romhashmd5Column = Column<String>(name: "romhashmd5", capacity: 0)
        var systemshortnameColumn = Column<String>(name: "systemshortname", capacity: 0)
        var releaseGenreColumn = Column<String>(name: "releaseGenre", capacity: 0)
        var releaseDescriptionColumn = Column<String>(name: "releaseDescription", capacity: 0)
        var releastTitleNameColumn = Column<String>(name: "releastTitleName", capacity: 0)
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let romhashmd5 = sqlite3_column_text(queryStatement, 0) != nil ? String(cString: sqlite3_column_text(queryStatement, 0)) : ""
                let systemshortname = sqlite3_column_text(queryStatement, 1) != nil ? String(cString: sqlite3_column_text(queryStatement, 1)) : ""
                let releaseGenre = sqlite3_column_text(queryStatement, 2) != nil ? String(cString: sqlite3_column_text(queryStatement, 2)) : ""
                let releaseDescription = sqlite3_column_text(queryStatement, 3) != nil ? String(cString: sqlite3_column_text(queryStatement, 3)) : ""
                let releasetitlename = sqlite3_column_text(queryStatement, 4) != nil ? String(cString: sqlite3_column_text(queryStatement, 4)) : ""
                
                rows.append([romhashmd5, systemshortname, releaseGenre, releaseDescription])
                romhashmd5Column.append(romhashmd5)
                systemshortnameColumn.append(systemshortname)
                releaseGenreColumn.append(releaseGenre)
                releaseDescriptionColumn.append(releaseDescription)
                releastTitleNameColumn.append(releasetitlename)
            }
            sqlite3_finalize(queryStatement)
            
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Error preparing SELECT statement: \(errmsg)")
        }
        
        let dataFrame = DataFrame(columns: [romhashmd5Column.eraseToAnyColumn(), systemshortnameColumn.eraseToAnyColumn(), releaseGenreColumn.eraseToAnyColumn(), releaseDescriptionColumn.eraseToAnyColumn(), releastTitleNameColumn.eraseToAnyColumn()])

        
        return dataFrame
    }
    
    func queryMatchingFiles() -> [ArcadiaRecommendationGameInfo] {
        let games = ArcadiaFileManager.shared.currentGames
        var matchingmd5s: [String] = []
        for game in games {
            if let matchingmd5 = ArcadiaFileManager.shared.md5OfMatchingGame(gameURL: game) {
                matchingmd5s.append(matchingmd5)
            }
        }
        
        return queryMatchingInfos(matchingMD5: matchingmd5s)
    }
    
    func queryMatchingInfos(matchingMD5: [String]) -> [ArcadiaRecommendationGameInfo] {
        guard let db = openDatabase() else { return [] }
        defer { sqlite3_close(db) }
        
        let queryStatementString = """
        WITH results AS (
            SELECT
                romhashmd5,
                releasetitlename,
                releaseDescription,
                releaseCoverFront,
                releaseDate,
                releaseDeveloper,
                UPPER(releaseGenre) AS releaseGenre,
                ROW_NUMBER() OVER (PARTITION BY roms.romID ORDER BY releases.regionLocalizedId) AS row_number
            FROM roms
            LEFT JOIN releases ON roms.romID = releases.romID
            LEFT JOIN systems ON roms.systemID = systems.systemID
            WHERE systems.systemID IN (\(gameSystem.dbSystemId.joined(separator: ", ")))
            AND roms.romhashmd5 IN ('\(matchingMD5.joined(separator: "', '"))')
        )
        SELECT
            releasetitlename,
            releaseDescription,
            releaseCoverFront,
            releaseDate,
            releaseDeveloper,
            releaseGenre,
            romhashmd5
        FROM results
        WHERE row_number = 1
        """
        
        var queryStatement: OpaquePointer? = nil
        var rows = [ArcadiaRecommendationGameInfo]()
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let releasetitlename = sqlite3_column_text(queryStatement, 0) != nil ? String(cString: sqlite3_column_text(queryStatement, 0)) : ""
                let releaseDescription = sqlite3_column_text(queryStatement, 1) != nil ? String(cString: sqlite3_column_text(queryStatement, 1)) : ""
                let releaseCoverFront = sqlite3_column_text(queryStatement, 2) != nil ? String(cString: sqlite3_column_text(queryStatement, 2)) : ""
                let releaseDate = sqlite3_column_text(queryStatement, 3) != nil ? String(cString: sqlite3_column_text(queryStatement, 3)) : ""
                let releaseDeveloper = sqlite3_column_text(queryStatement, 4) != nil ? String(cString: sqlite3_column_text(queryStatement, 4)) : ""
                let releaseGenre = sqlite3_column_text(queryStatement, 5) != nil ? String(cString: sqlite3_column_text(queryStatement, 5)) : ""
                let romhashmd5 = sqlite3_column_text(queryStatement, 6) != nil ? String(cString: sqlite3_column_text(queryStatement, 6)) : ""
                
                rows.append(ArcadiaRecommendationGameInfo(md5: romhashmd5, name: releasetitlename, description: releaseDescription, releaseCover: releaseCoverFront, releaseDate: releaseDate, releaseDeveloper: releaseDeveloper))
            }
            sqlite3_finalize(queryStatement)
            
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Error preparing SELECT statement: \(errmsg)")
        }
        
        return rows
    }
    
    
    func removeDuplicates(from dataFrame: DataFrame, basedOn column: String) -> DataFrame {
        var seen = Set<AnyHashable>()
        var dataFrame = dataFrame
        var indicesToRemove = [Int]()
        
        for row in dataFrame.rows {
            if let value = row[column] as? AnyHashable, !seen.contains(value) {
                seen.insert(value)
            } else {
                indicesToRemove.append(row.index)
            }
        }
        
        for index in indicesToRemove.sorted(by: >) {
            dataFrame.removeRow(at: index)
        }
        
        return dataFrame
    }




    
}

#Preview {
    RecommendationView(gameSystem: .atari2600Game)
}


