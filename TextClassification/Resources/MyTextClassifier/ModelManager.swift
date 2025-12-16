//
//  ModelManager.swift
//  TextClassification
//
//  Created by Vinicius Silva Moreira on 16/12/25.
//

import CoreML
import Foundation

struct ClassificationResult {
    let label: String
    let confidenceFake: Double
    let confidenceReal: Double
}

class ClassifierManager {
    static let shared = ClassifierManager()
    private var model: MyTextClassifier?
    
    private init() {
        do {
            let config = MLModelConfiguration()
            self.model = try MyTextClassifier(configuration: config)
        } catch {
            print(error)
        }
    }
    
    func predict(_ text: String) -> ClassificationResult? {
        guard let model = model else { return nil }
        
        do {
            // Pede a previsão simples
            let output = try model.prediction(text: text)
            let label = output.label
            
            let fakeScore = (label.lowercased() == "fake") ? 1.0 : 0.0
            let realScore = (label.lowercased() == "real") ? 1.0 : 0.0
            
            return ClassificationResult(
                label: label,
                confidenceFake: fakeScore,
                confidenceReal: realScore
            )
            
        } catch {
            print(error)
            return nil
        }
    }
}
