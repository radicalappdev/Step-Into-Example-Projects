import Foundation

func loadFigures() -> [HistoricalFigure] {
    guard let url = Bundle.main.url(forResource: "data", withExtension: "json"),
          let data = try? Data(contentsOf: url),
          let figures = try? JSONDecoder().decode([HistoricalFigure].self, from: data) else {
        return []
    }
    return figures
} 