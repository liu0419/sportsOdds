//
//   SportsListView.swift
//  SportOdds
//
//  Created by 劉丞晏 on 2025/5/19.
//

import SwiftUI

struct SportsListView: View {
    @StateObject private var viewModel = SportsViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // 更新按鈕
                HStack {
                    Button(action: {
                        viewModel.fetchSports()
                    }) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("更新資料")
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // 最後更新時間
                    if let last = viewModel.lastUpdated {
                        Text("更新時間：\(last.formatted(date: .abbreviated, time: .shortened))")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.trailing)
                    }
                }
                .padding(.top)
                
                Divider()
                
                // Checkbox filter 區塊
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.availableGroups, id: \.self) { group in
                            Toggle(isOn: Binding(
                                get: { viewModel.selectedGroups.contains(group) },
                                set: { isOn in
                                    if isOn {
                                        viewModel.selectedGroups.insert(group)
                                    } else {
                                        viewModel.selectedGroups.remove(group)
                                    }
                                }
                            )) {
                                Text(group)
                            }
                            .toggleStyle(.button)
                            .padding(.horizontal, 4)
                        }
                    }
                    .padding(.horizontal)
                }
                
                Divider()
                
                if let error = viewModel.fetchError {
                    Text("⚠️ \(error)")
                        .foregroundColor(.red)
                        .padding()
                }
                
                List(viewModel.filteredSports) { sport in
                    NavigationLink(destination: OddsDetailView(sport: sport)) {
                        SportRowView(sport: sport)
                    }
                }
                .navigationTitle("Sports")
            }
            .onAppear {
                viewModel.fetchSports()
            }
        }
    }
}
