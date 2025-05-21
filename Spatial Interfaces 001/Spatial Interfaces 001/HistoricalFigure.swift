import Foundation

struct HistoricalFigure: Identifiable, Codable {
    let id: Int
    let name: String
    let born: String
    let died: String
    let nationality: String
    let education: String
    let occupation: String
    let knownFor: String
    let activeYears: String
    let shortDescription: String
    let longDescription: String
    let imageUrl: String
    let imageAttribution: String
} 