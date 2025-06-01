import SwiftUI

struct SportsListView: View {
    @StateObject private var viewModel = SportsViewModel()
    @State private var scrollOffset: CGFloat = 0
    @State private var timer: Timer?

    // 📌 建立無限輪播用的陣列（3 倍重複）
    var loopingGroups: [String] {
        Array(repeating: viewModel.availableGroups, count: 3).flatMap { $0 }
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color("DarkPurple").ignoresSafeArea()

                VStack(spacing: 0) {
                    // ✅ Header 區塊
                    VStack {
                        HStack {
                            Button(action: {
                                viewModel.fetchSports()
                            }) {
                                HStack {
                                    Image(systemName: "arrow.clockwise")
                                    Text("更新資料")
                                }
                                .foregroundColor(.blue)
                            }
                            .padding(.horizontal)

                            Spacer()

                            if let last = viewModel.lastUpdated {
                                Text("更新時間：\(last.formatted(date: .abbreviated, time: .shortened))")
                                    .font(.caption)
                                    .foregroundColor(.green)
                                    .padding(.trailing)
                            }
                        }
                        .padding(.top)

                        Divider().background(.white)
                    }

                    // ✅ 自動滾動的 Toggle 選單
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(loopingGroups, id: \.self) { group in
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
                                        .font(.subheadline.bold())
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 12)
                                        .foregroundColor(Color("RoseGold"))
                                        .background(Color.white.opacity(0.15))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color("RoseGold"), lineWidth: 1)
                                        )
                                        .cornerRadius(16)
                                }
                                .toggleStyle(.button)
                            }
                        }
                        .padding(.horizontal)
                        .offset(x: -scrollOffset)
                        .onAppear { startAutoScroll() }
                        .onDisappear { timer?.invalidate() }
                    }
                    .frame(height: 60)
                    .background(Color.black.opacity(0.3))

                    Divider().background(.white)

                    // ✅ 錯誤訊息
                    if let error = viewModel.fetchError {
                        Text("⚠️ \(error)")
                            .foregroundColor(.red)
                            .padding()
                    }

                    // ✅ Sports 列表
                    List(viewModel.filteredSports) { sport in
                        NavigationLink(destination: OddsDetailView(sport: sport)) {
                            SportRowView(sport: sport)
                                .foregroundColor(.white)
                                .font(.title3.bold()) // 字體更大
                                .frame(maxWidth: .infinity, alignment: .leading) // 寬度一致，靠左
                                .padding(.vertical, 12)
                                .padding(.horizontal, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color("RoseGold").opacity(0.1))
                                        .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                                )
                                .contentShape(Rectangle())
                        }
                        .tint(.white)
                        .frame(maxWidth: .infinity) // 外層 NavigationLink 滿寬
                        .alignmentGuide(.listRowSeparatorLeading) { _ in 0 } // 靠齊左邊
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                    .background(Color("DarkPurple"))
                }
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Sports")
                            .font(.title2.bold())
                            .foregroundColor(Color("RoseGold"))
                    }
                }
                .onAppear {
                    viewModel.fetchSports()
                }
            }
        }
    }

    // ✅ 平滑自動輪播效果
    func startAutoScroll() {
        let resetThreshold: CGFloat = 300 // 根據 toggle 數量微調
        scrollOffset = 0

        timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { _ in
            withAnimation(.linear(duration: 0.03)) {
                scrollOffset += 0.5
            }

            if scrollOffset >= resetThreshold {
                // 關掉動畫瞬間回跳
                withAnimation(.none) {
                    scrollOffset = 0
                }
            }
        }
    }
}
