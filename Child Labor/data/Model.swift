//
//  TopicItemViewModel.swift
//  MSHA-Miners
//
//  Created by Greg Gruse on 4/20/22.
//

import Foundation
import SwiftUI

public class Model {
    
    private static var singletonModelData: Model = {
        let model = Model()
        return model
    }()
    
    // MARK: - Accessors
    class func shared() -> Model {
        return singletonModelData
    }
    
    var goods: [Good]
    var countries: [Country]
    var suggestedActions: [SuggestedActions]
    
    init() {
        print("GGG: Starting Data Load \(Date().description(with: Locale.current))")
        let goods = Model.readData(fileName: "goods", ofType: GoodsData.self).data.sorted(by: { $1.good > $0.good })
        let countries = Model.readData(fileName: "countries", ofType: CountryData.self).data.sorted(by: { $1.country > $0.country })
        let suggestedActions = Model.readData(fileName: "suggested_actions", ofType: SuggestedActionsData.self).data.sorted(by: { $1.country > $0.country })
        
        let updatedCountries = countries.map { country in
            var countryCopy = country
            let fullGoodsList = goods.filter { $0.country == country.country }
//          TODO: BUGBUG - Need to flatten Goods to one unique record parsing the exploitation_type into unique fields
//            let uniqueGoods = fullGoodsList.map
        
            countryCopy.goods = fullGoodsList
            countryCopy.suggestedActions = suggestedActions.filter { $0.country == country.country }
            return countryCopy
        }
        
        self.countries = updatedCountries
        self.suggestedActions = suggestedActions
        self.goods = goods
        
    }
    
    static func readData<T: Decodable>(fileName: String, ofType type: T.Type) -> T {
        print("GGG: Processing file: \(fileName)")
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: "json") else {
            fatalError("File '\(fileName)' not found.")
        }

        do {
            let jsonString = try String(contentsOfFile: filePath)
            let jsonData = Data(jsonString.utf8)
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: jsonData)
        } catch DecodingError.dataCorrupted(let context) {
            print("Data corrupted: \(context)")
        } catch DecodingError.keyNotFound(let key, let context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch DecodingError.valueNotFound(let value, let context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch DecodingError.typeMismatch(let type, let context) {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print("Error during decoding:", error.localizedDescription)
        }

        // If any decoding error occurs or if the catch block is triggered, return an empty data
        if T.self == GoodsData.self {
            return GoodsData(data: []) as! T
        } else if T.self == CountryData.self {
            return CountryData(data: []) as! T
        } else if T.self == SuggestedActionsData.self {
            return SuggestedActionsData(data: []) as! T
        } else {
            fatalError("Unhandled data type: \(T.self)")
        }
    }
    
    public struct GoodsData: Codable {
        var data: [Good]
    }
    
    public struct Good: Codable {
        var country_numeric_iso_code: String
        var country_iso_code: String
        var country: String
        var sector: String
        var good: String
        var exploitation_type: String
        var year_added: String
        var year_removed: String?
        var childLabor: String = "No"
        var forcedLabor: String = "No"
        var forcedChildLabor: String = "No"
        var derivedLaborExploitation: String = "No"
    }
    
    public struct CountryData: Codable {
        var data: [Country]
    }
    
    struct Country: Codable {
        let year: Int
        let country: String
        let region: String
        let assessmentLevel: String
        let summaryParagraph: String
        let working: String
        let workingAge: String
        let workingBoys: String
        let workingGirls: String
        let workingRural: String
        let hazardousWorkChildren: String
        let hazardousWorkChildrenAge: String
        let hazardousWorkChildrenBoys: String
        let hazardousWorkChildrenGirls: String
        let hazardousWorkChildrenUrban: String
        let hazardousWorkChildrenRural: String
        let attendingSchool: String
        let attendinSchoolAge: String
        let combiningWorkSchool: String
        let combiningWorkSchoolAge: String
        let workingChildrenAgriculture: String
        let workingChildrenIndustry: String
        let workingChildrenServices: String
        let iloC138: String
        let iloC182: String
        let unCrc: String
        let unCrcAc: String
        let unCrcCsec: String
        let palermoProtocol: String
        let minimumAgeWork: String
        let minimumAgeWorkAge: String
        let minimumAgeHazardouswork: String
        let minimumAgeHazardousworkAge: String
        let hazardousWorkList: String
        let prohibitionFl: String
        let prohibitionChildTrafficking: String
        let prohibitionCsec: String
        let prohibitionIllicitActivities: String
        let prohibitionCompulsoryMilitaryRecruitment: String
        let minimumAgeVoluntaryMilitaryRecruitment: String
        let minimumAgeVoluntaryMilitaryRecruitmentAge: String
        let prohibitionNonstateArmedGroupsRecruitment: String
        let compulsoryEducationAge: String
        let compulsoryEducationAgeAge: String
        let freePublicEducation: String
        let hasLaborInspectorate: String
        let ableAssessCivilpenalties: String
        let routineWorksiteInspections: String
        let unannouncedInspectionsPermitted: String
        let complaintMechanism: String
        let imposedPenaltiesChildlaborViolations: String
        let criminalInvestigationsWfcl: String
        let imposedPenaltiesWfcl: String
        let numberLaborInspectors: Int
        let adequateNumberLaborInspectors: String
        let mechanismCoordinateClEfforts: String
        let nationalPolicyCl: String
        let nationalProgramCl: String
        let workingUrban: String?
        var goods: [Good] = []
        var suggestedActions: [SuggestedActions] = []

        enum CodingKeys: String, CodingKey {
            case year, country, region
            case assessmentLevel = "assessment_level"
            case summaryParagraph = "summary_paragraph"
            case working = "working"
            case workingAge = "working_age"
            case workingBoys = "working_boys"
            case workingGirls = "working_girls"
            case workingRural = "working_rural"
            case hazardousWorkChildren = "hazardous_work_children"
            case hazardousWorkChildrenAge = "hazardous_work_children_age"
            case hazardousWorkChildrenBoys = "hazardous_work_children_boys"
            case hazardousWorkChildrenGirls = "hazardous_work_children_girls"
            case hazardousWorkChildrenUrban = "hazardous_work_children_urban"
            case hazardousWorkChildrenRural = "hazardous_work_children_rural"
            case attendingSchool = "attending_school"
            case attendinSchoolAge = "attendin_school_age"
            case combiningWorkSchool = "combining_work_school"
            case combiningWorkSchoolAge = "combining_work_school_age"
            case workingChildrenAgriculture = "working_children_agriculture"
            case workingChildrenIndustry = "working_children_industry"
            case workingChildrenServices = "working_children_services"
            case iloC138 = "ilo_c_138"
            case iloC182 = "ilo_c_182"
            case unCrc = "un_crc"
            case unCrcAc = "un_crc_ac"
            case unCrcCsec = "un_crc_csec"
            case palermoProtocol = "palermo_protocol"
            case minimumAgeWork = "minimum_age_work"
            case minimumAgeWorkAge = "minimum_age_work_age"
            case minimumAgeHazardouswork = "minimum_age_hazardouswork"
            case minimumAgeHazardousworkAge = "minimum_age_hazardouswork_age"
            case hazardousWorkList = "hazardous_work_list"
            case prohibitionFl = "prohibition_fl"
            case prohibitionChildTrafficking = "prohibition_child_trafficking"
            case prohibitionCsec = "prohibition_csec"
            case prohibitionIllicitActivities = "prohibition_illicit_activities"
            case prohibitionCompulsoryMilitaryRecruitment = "prohibition_compulsory_military_recruitment"
            case minimumAgeVoluntaryMilitaryRecruitment = "minimum_age_voluntary_military_recruitment"
            case minimumAgeVoluntaryMilitaryRecruitmentAge = "minimum_age_voluntary_military_recruitment_age"
            case prohibitionNonstateArmedGroupsRecruitment = "prohibition_nonstate_armed_groups_recruitment"
            case compulsoryEducationAge = "compulsory_education_age"
            case compulsoryEducationAgeAge = "compulsory_education_age_age"
            case freePublicEducation = "free_public_education"
            case hasLaborInspectorate = "has_labor_inspectorate"
            case ableAssessCivilpenalties = "able_assess_civilpenalties"
            case routineWorksiteInspections = "routine_worksite_inspections"
            case unannouncedInspectionsPermitted = "unannounced_inspections_permitted"
            case complaintMechanism = "complaint_mechanism"
            case imposedPenaltiesChildlaborViolations = "imposed_penalties_childlabor_violations"
            case criminalInvestigationsWfcl = "criminal_investigations_wfcl"
            case imposedPenaltiesWfcl = "imposed_penalties_wfcl"
            case numberLaborInspectors = "number_labor_inspectors"
            case adequateNumberLaborInspectors = "adequate_number_labor_inspectors"
            case mechanismCoordinateClEfforts = "mechanism_coordinate_cl_efforts"
            case nationalPolicyCl = "national_policy_cl"
            case nationalProgramCl = "national_program_cl"
            case workingUrban = "working_urban"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            // Decode other properties...
            year = try container.decode(Int.self, forKey: .year)
            country = try container.decode(String.self, forKey: .country)
            region = try container.decode(String.self, forKey: .region)
            assessmentLevel = try container.decode(String.self, forKey: .assessmentLevel)
            summaryParagraph = try container.decode(String.self, forKey: .summaryParagraph)
            working = try container.decode(String.self, forKey: .working)
            workingAge = try container.decode(String.self, forKey: .workingAge)
            workingBoys = (try? container.decode(String.self, forKey: .workingBoys)) ?? ""
            workingGirls = (try? container.decode(String.self, forKey: .workingGirls)) ?? ""
            workingRural = (try? container.decode(String.self, forKey: .workingRural)) ?? ""
            hazardousWorkChildren = try container.decode(String.self, forKey: .hazardousWorkChildren)
            hazardousWorkChildrenAge = try container.decode(String.self, forKey: .hazardousWorkChildrenAge)
            hazardousWorkChildrenBoys = try container.decode(String.self, forKey: .hazardousWorkChildrenBoys)
            hazardousWorkChildrenGirls = try container.decode(String.self, forKey: .hazardousWorkChildrenGirls)
            hazardousWorkChildrenUrban = try container.decode(String.self, forKey: .hazardousWorkChildrenUrban)
            hazardousWorkChildrenRural = try container.decode(String.self, forKey: .hazardousWorkChildrenRural)
            attendingSchool = try container.decode(String.self, forKey: .attendingSchool)
            attendinSchoolAge = try container.decode(String.self, forKey: .attendinSchoolAge)
            combiningWorkSchool = try container.decode(String.self, forKey: .combiningWorkSchool)
            combiningWorkSchoolAge = try container.decode(String.self, forKey: .combiningWorkSchoolAge)
            workingChildrenAgriculture = try container.decode(String.self, forKey: .workingChildrenAgriculture)
            workingChildrenIndustry = try container.decode(String.self, forKey: .workingChildrenIndustry)
            workingChildrenServices = try container.decode(String.self, forKey: .workingChildrenServices)
            iloC138 = try container.decode(String.self, forKey: .iloC138)
            iloC182 = try container.decode(String.self, forKey: .iloC182)
            unCrc = try container.decode(String.self, forKey: .unCrc)
            unCrcAc = try container.decode(String.self, forKey: .unCrcAc)
            unCrcCsec = try container.decode(String.self, forKey: .unCrcCsec)
            palermoProtocol = try container.decode(String.self, forKey: .palermoProtocol)
            minimumAgeWork = try container.decode(String.self, forKey: .minimumAgeWork)
            minimumAgeWorkAge = try container.decode(String.self, forKey: .minimumAgeWorkAge)
            minimumAgeHazardouswork = try container.decode(String.self, forKey: .minimumAgeHazardouswork)
            minimumAgeHazardousworkAge = try container.decode(String.self, forKey: .minimumAgeHazardousworkAge)
            hazardousWorkList = try container.decode(String.self, forKey: .hazardousWorkList)
            prohibitionFl = try container.decode(String.self, forKey: .prohibitionFl)
            prohibitionChildTrafficking = try container.decode(String.self, forKey: .prohibitionChildTrafficking)
            prohibitionCsec = try container.decode(String.self, forKey: .prohibitionCsec)
            prohibitionIllicitActivities = try container.decode(String.self, forKey: .prohibitionIllicitActivities)
            prohibitionCompulsoryMilitaryRecruitment = try container.decode(String.self, forKey: .prohibitionCompulsoryMilitaryRecruitment)
            minimumAgeVoluntaryMilitaryRecruitment = try container.decode(String.self, forKey: .minimumAgeVoluntaryMilitaryRecruitment)
            minimumAgeVoluntaryMilitaryRecruitmentAge = try container.decode(String.self, forKey: .minimumAgeVoluntaryMilitaryRecruitmentAge)
            prohibitionNonstateArmedGroupsRecruitment = try container.decode(String.self, forKey: .prohibitionNonstateArmedGroupsRecruitment)
            compulsoryEducationAge = try container.decode(String.self, forKey: .compulsoryEducationAge)
            compulsoryEducationAgeAge = try container.decode(String.self, forKey: .compulsoryEducationAgeAge)
            freePublicEducation = try container.decode(String.self, forKey: .freePublicEducation)
            hasLaborInspectorate = try container.decode(String.self, forKey: .hasLaborInspectorate)
            ableAssessCivilpenalties = try container.decode(String.self, forKey: .ableAssessCivilpenalties)
            routineWorksiteInspections = try container.decode(String.self, forKey: .routineWorksiteInspections)
            unannouncedInspectionsPermitted = try container.decode(String.self, forKey: .unannouncedInspectionsPermitted)
            complaintMechanism = try container.decode(String.self, forKey: .complaintMechanism)
            imposedPenaltiesChildlaborViolations = try container.decode(String.self, forKey: .imposedPenaltiesChildlaborViolations)
            criminalInvestigationsWfcl = try container.decode(String.self, forKey: .criminalInvestigationsWfcl)
            imposedPenaltiesWfcl = try container.decode(String.self, forKey: .imposedPenaltiesWfcl)
            numberLaborInspectors = try container.decode(Int.self, forKey: .numberLaborInspectors)
            adequateNumberLaborInspectors = try container.decode(String.self, forKey: .adequateNumberLaborInspectors)
            mechanismCoordinateClEfforts = try container.decode(String.self, forKey: .mechanismCoordinateClEfforts)
            nationalPolicyCl = try container.decode(String.self, forKey: .nationalPolicyCl)
            nationalProgramCl = try container.decode(String.self, forKey: .nationalProgramCl)
            workingUrban = try container.decodeIfPresent(String.self, forKey: .workingUrban)
        }

    }
    
    private static func convertWorkingAge(_ workingAgeRange: String) -> String {
            // Modify the logic based on the actual format of the workingAge in your JSON data
            // For example, if the workingAge is "14-May", extract the range "5-14"
            let components = workingAgeRange.components(separatedBy: "-")
            if components.count == 2 {
                return components.joined(separator: "-")
            } else {
                return workingAgeRange
            }
        }
    
    public struct SuggestedActionsData: Codable {
        var data: [SuggestedActions]
    }
    
    struct SuggestedActions: Codable {
        let country: String
        let year: Int
        let area: String
        let suggestedAction: String

        enum CodingKeys: String, CodingKey {
            case country, year, area
            case suggestedAction = "suggested_action"
        }
    }
}
