//
//  APIClient.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 30.11.2025.
//
import Foundation

protocol APIClient {
    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse)
}
