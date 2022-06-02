//
//  FixtureStructs.swift
//

import CodableCSV
import Foundation

let fixtureURL = URL(fileURLWithPath: #file)
    .deletingLastPathComponent() // FixtureStructs.swift
    .deletingLastPathComponent() // ExampleChartViews directory
    .appendingPathComponent("chartrender-benchmark")
    .appendingPathComponent("fixtures")

struct Athletes: Codable {
    let id: Int
    let name: String
    let nationality: String
    let sex: String
    let date_of_birth: Date // Date
    let height: Double?
    let weight: Double?
    let sport: String
    let gold: Int
    let silver: Int
    let bronze: Int
    let info: String?

    static var dateformatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }

    static var url: URL {
        fixtureURL
            .appendingPathComponent("athletes", conformingTo: .commaSeparatedText)
    }

    static func provideData() -> [Athletes] {
        let athleteDecoder = CSVDecoder {
            $0.headerStrategy = .firstLine
            $0.dateStrategy = .formatted(Athletes.dateformatter)
        }

        do {
            return try athleteDecoder.decode([Athletes].self, from: Athletes.url)
        } catch {
            return []
        }
    }
}

// athletes.csv
// id,name,nationality,sex,date_of_birth,height,weight,sport,gold,silver,bronze,info
// 736041664,A Jesus Garcia,ESP,male,1969-10-17,1.72,64,athletics,0,0,0,
// 532037425,A Lam Shin,KOR,female,1986-09-23,1.68,56,fencing,0,0,0,

struct SFTemps: Codable {
    let date: Date
    let high: Double
    let low: Double

    static var dateformatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }

    static var url: URL {
        fixtureURL
            .appendingPathComponent("sf-temperatures", conformingTo: .commaSeparatedText)
    }

    static func provideData() -> [SFTemps] {
        let temperatureDecoder = CSVDecoder {
            $0.headerStrategy = .firstLine
            $0.dateStrategy = .formatted(SFTemps.dateformatter)
        }

        do {
            return try temperatureDecoder.decode([SFTemps].self, from: SFTemps.url)
        } catch {
            return []
        }
    }
}

// sf-temperatures.csv
// date,high,low
// 2010-10-01,59.5,57
// 2010-10-02,59.5,53.4
// 2010-10-03,59,53.4
// 2010-10-04,59.4,54.7
