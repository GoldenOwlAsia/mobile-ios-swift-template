//
//  GoLogger.swift
//  mobile-ios-swift-template
//
//  Created by Ping9 on 23/03/2023.
//

import Foundation
import UIKit

public class GoLogger {
    
    //MARK: - Properties
    public var isProduction: Bool = false
    public var maxLogFileSize: Double = 5
    var logFile: URL? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileName = "ConsumerLog.log"
        return documentsDirectory.appendingPathComponent(fileName)
    }
    
    //MARK: - Life cycle
    public init(){
        guard let logFile = logFile else { return }
        if !isProduction {
            print("Logger Location : \(logFile)")
            let currentLogFileSize = checkFileSize(fileURL: logFile)
            print("Logger Current Size: \(currentLogFileSize) MB")
        }
    }
    
    
    //MARK: - Helper functions
    public func log(_ message: String) {
        guard let logFile = logFile else { return }
        let currentLogFileSize = checkFileSize(fileURL: logFile)
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        let timestamp = formatter.string(from: Date())
        guard let data = (timestamp + " : " + message + "\n").data(using: String.Encoding.utf8) else { return }
        
        // if file size is less than 5MB
        if currentLogFileSize < maxLogFileSize {
            writeToFile(data: data, fileURL: logFile)
        } else {
            deleteFileAndWrite(data: data, fileURL: logFile)
        }
    }
    
    func writeToFile(data: Data, fileURL: URL) {
        if FileManager.default.fileExists(atPath: fileURL.path) {
            if let fileHandle = try? FileHandle(forWritingTo: fileURL) {
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
                fileHandle.closeFile()
            }
        } else {
            try? data.write(to: fileURL, options: .atomicWrite)
        }
    }
    
    func deleteFileAndWrite(data: Data, fileURL: URL) {
        do {
            try FileManager.default.removeItem(at: fileURL)
            writeToFile(data: data, fileURL: fileURL)
        } catch {
            print("DEBUG: Unable to delete logger file \(error)")
        }
    }
    
    func checkFileSize(fileURL: URL?) -> Double {
        guard let filePath = fileURL else { return 0.0 }
        do {
            let attribute = try FileManager.default.attributesOfItem(atPath: filePath.path)
            if let size = attribute[FileAttributeKey.size] as? NSNumber {
                return size.doubleValue / 1000000.0
            }
        } catch {
            print("DEBUG: Unable to write to logger file \(error)")
        }
        return 0.0
    }
    
    public func getLoggerLocation() -> URL? {
        guard let logFile = logFile else { return nil }
        return logFile
    }
    
}
