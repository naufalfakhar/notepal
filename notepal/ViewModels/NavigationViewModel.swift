//
//  NavigatorViewModel.swift
//  notes
//
//  Created by Dason Tiovino on 12/07/24.
//

import Foundation
import SwiftUI
import Combine

class NavigationViewModel: ObservableObject {
    enum Destination {
        case home
        case chart
        case detail(id: String)
    }
    
    @Published var currentDestination: Destination = .home
    
    func navigateToHome() {
        currentDestination = .home
    }
    
    func navigateToDetail(with id: String) {
        currentDestination = .detail(id: id)
    }
    
    func navigateToChart(){
        currentDestination = .chart
    }
}
