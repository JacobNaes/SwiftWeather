//
//  LocationSearchView.swift
//  SwiftWeather
//
//  Created by Jacob Naes on 3/30/22.
//

import SwiftUI

struct LocationSearchView: View {
   @Environment(\.dismissSearch) private var dismissSearch
   @Environment(\.dismiss) private var dismiss
   @StateObject private var viewModel: LocationSearchViewModel
   
   init(saveAction: @escaping (LocationData) -> ()) {
      let locationSearchViewModel = LocationSearchViewModel(saveAction: saveAction)
      _viewModel = StateObject(wrappedValue: locationSearchViewModel)
   }
   
   var body: some View {
      NavigationView {
         ZStack {
            LinearGradient(
               colors: [.blueBackground, .lightBackground],
               startPoint: .top,
               endPoint: .bottom
            )
            .edgesIgnoringSafeArea([.top, .bottom])
            
            ScrollView {
               ForEach(viewModel.locations) { location in
                  Button {
                     dismiss()
                     viewModel.save(location: location)
                  } label: {
                     LocationSearchRow(location: location)
                  }
                  .foregroundColor(.primary)
                  .padding(.horizontal)
               }
            }
         }
         .navigationBarTitleDisplayMode(.inline)
      }
      .searchable(
         text: $viewModel.searchText,
         placement: .navigationBarDrawer(displayMode: .always),
         prompt: nil
      )
      .onSubmit(of: .search) {
         viewModel.getLocations {
            dismissSearch()
         }
      }
   }
}

fileprivate
struct LocationSearchRow: View {
   let location: LocationData
   
   var body: some View {
      VStack(alignment: .leading, spacing: nil) {
         Group {
            if location.region.isEmpty {
               Text("\(location.name)")
                  .bold()
            } else {
               Text("\(location.name), \(location.region)")
                  .bold()
                  .lineLimit(1)
            }
         }
         .font(.system(.title3, design: .rounded))
         Text(location.country)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(15)
      .background(
         RoundedRectangle(cornerRadius: 12, style: .continuous)
            .foregroundStyle(.thinMaterial)
      )
   }
}


struct LocationSearchView_Previews: PreviewProvider {
   static var previews: some View {
      LocationSearchView { _ in }
   }
}
