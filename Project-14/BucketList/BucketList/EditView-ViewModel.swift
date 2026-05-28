//
//  EditView-ViewModel.swift
//  BucketList
//
//  Created by Mylla Sasaki on 27/05/26.
//

import Foundation

extension EditView {
    enum LoadingState {
        case loading, loaded, failed
    }
    
    @Observable
    class ViewModel {
        var name: String
        var description: String
        var loadingState = LoadingState.loading
        var pages = [Page]()
        var location: Location
        
        init(location: Location) {
            self.location = location
            self.name = location.name
            self.description = location.description
        }
    }
}
