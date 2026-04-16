import SwiftUI

struct CardData {
    let imageName: String?
    let title: String
    let date: String
    let place: String
    let highlightMap: String?
}

let cardDataList: [CardData] = [
    CardData(imageName: nil, title: "", date: "", place: "", highlightMap: nil),
    CardData(imageName: "phopopicture", title: "오랜만에 포항여행", date: "2026.01.30.", place: "호미곶에서 @구봉이들과", highlightMap: "map3_1"),
    CardData(imageName: "youngildae", title: "맛있는 물회", date: "2026.04.09.", place: "영일대에서 @Team1과", highlightMap: "map11_1"),
    CardData(imageName: "appleacademy", title: "애플이 버터떡 사줬다 ~~", date: "2026.04.13.", place: "C5에서 @러너들과", highlightMap: "map10_1"),
]

struct mapView: View {
    var highlightMap: String?
    @State private var selectedIndex = 0

    let users = ["@유루카", "@클로이", "@크로인", "@월튼"]

    var body: some View {
        VStack {
            HStack {
                Menu {
                    ForEach(users.indices, id: \.self) { index in
                        Button(users[index]) {
                            selectedIndex = index
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(users[selectedIndex]).bold()
                        Image(systemName: "chevron.down")
                            .font(.caption)
                            .bold()
                    }
                    .foregroundStyle(.black)
                }

                Text("의 지도").bold()
            }
            .padding(.bottom, 10)

            ZStack {
                Image("map")
                    .resizable()
                    .scaledToFit()
                    .opacity(highlightMap != nil ? 0.3 : 1.0)

                if let highlight = highlightMap {
                    Image(highlight)
                        .resizable()
                        .scaledToFit()
                        .blendMode(.multiply)
                }

                HStack {
                    Button {
                        selectedIndex = (selectedIndex - 1 + users.count) % users.count
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundStyle(.gray)
                    }
                    .padding(.leading, 8)

                    Spacer()

                    Button {
                        selectedIndex = (selectedIndex + 1) % users.count
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.title2)
                            .foregroundStyle(.gray)
                    }
                    .padding(.trailing, 8)
                }
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .frame(height: 280)
        }
    }
}

struct CarouselView: View {
    let repeatCount = 999
    @State private var selection: Int? = nil
    @State private var currentHighlight: String? = nil

    var startIndex: Int { (repeatCount / 2) - ((repeatCount / 2) % cardDataList.count) }

    var body: some View {
        VStack(spacing: 0) {
            mapView(highlightMap: currentHighlight)
                .padding(.bottom, 15)


            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<repeatCount, id: \.self) { index in
                        let card = cardDataList[index % cardDataList.count]
                        CardView(data: card)
                            .frame(width: 280)
                            .scrollTransition { content, phase in
                                content
                                    .scaleEffect(phase.isIdentity ? 1 : 0.88)
                                    .opacity(phase.isIdentity ? 1 : 0.55)
                            }
                            .id(index)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .contentMargins(.horizontal, 50)
            .scrollPosition(id: $selection)
            .onAppear { selection = startIndex }
            .onChange(of: selection) {
                if let sel = selection {
                    currentHighlight = cardDataList[sel % cardDataList.count].highlightMap
                }
            }
        }
    }
}

struct CardView: View {
    let data: CardData
    @State private var isImagePickerPresented = false

    var body: some View {
        VStack(spacing: 16) {
            if let imageName = data.imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 180, height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                Text(data.title)
                    .font(.title2).bold()

                Text("\(data.date)\n\(data.place)")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)

                if data.imageName == "phopopicture" {
                    NavigationLink(destination: MainView()) {
                        Text("추억 보러 가기")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.black)
                            .clipShape(Capsule())
                    }
                    .padding(.horizontal)
                } else {
                    Button {
                    } label: {
                        Text("추억 보러 가기")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.black)
                            .clipShape(Capsule())
                    }
                    .padding(.horizontal)
                }

            } else {
                Button {
                    isImagePickerPresented = true
                } label: {
                    VStack(spacing: 12) {
                        Image(systemName: "camera")
                            .font(.system(size: 40))
                            .foregroundStyle(.black)
                        Text("당신의 추억을\nPhopo에\n기록해보세요!")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .padding()
        .frame(width: 280, height: 380)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .shadow(radius: 5)
        .fullScreenCover(isPresented: $isImagePickerPresented) {
            ImagePicker()
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) { self.parent = parent }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            parent.dismiss()
        }
    }
}

struct hereView: View {
    var body: some View {
        NavigationStack {
            CarouselView()
                .ignoresSafeArea(edges: .bottom)
        }
    }
}

#Preview {
    hereView()
}
