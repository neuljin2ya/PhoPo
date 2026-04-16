import SwiftUI

enum Field: Hashable {
    case givenName
    case familyName
}

let imageMap: [String: String] = [
    "영일대": "sticker",
]

struct CalendarView: View {
    @Binding var date: Date
    var body: some View {
        DatePicker("Start Date", selection: $date, displayedComponents: [.date])
            .datePickerStyle(.graphical)
    }
}

struct HourView: View {
    @Binding var date: Date
    var body: some View {
        DatePicker("Start Time", selection: $date, displayedComponents: [.hourAndMinute])
            .datePickerStyle(.wheel)
            .labelsHidden()
    }
}

struct MainView: View {
    @State private var date = Date()
    @State private var isCalendarViewPresented = false
    @State private var isHourViewPresented = false
    @State private var givenName: String = ""
    @State private var familyName: String = ""
    @State private var people: [String] = []
    @FocusState private var focus: Field?
    @State private var stackedImages: [String] = []

    var body: some View {
        VStack(spacing: 20) {
            Button {
                isCalendarViewPresented = true
            } label: {
                Text(date, style: .date)
                    .foregroundStyle(.black)
            }
            .sheet(isPresented: $isCalendarViewPresented) {
                CalendarView(date: $date)
                    .presentationDetents([.height(520)])
            }

            Button {
                isHourViewPresented = true
            } label: {
                Text(date, style: .time)
                    .foregroundStyle(.black)
            }
            .sheet(isPresented: $isHourViewPresented) {
                HourView(date: $date)
                    .presentationDetents([.height(300)])
            }

            ZStack(alignment: .bottomTrailing) {
                Image("phopopicture")
                    .resizable()
                    .frame(width: 300, height: 400)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .overlay(alignment: .topLeading) {
                        Button {
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundStyle(.white, .black)
                        }
                        .offset(x: -8, y: -8)
                    }

                ForEach(stackedImages, id: \.self) { imageName in
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .padding(8)
                }
            }

            VStack(alignment: .leading, spacing: 12) {

                // 함께한 사람
                Text("함께한 사람")
                    .bold()

                HStack(spacing: 6) {
                    ForEach(people, id: \.self) { person in
                        HStack(spacing: 4) {
                            Text(person)
                                .font(.subheadline)
                            Button {
                                people.removeAll { $0 == person }
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.caption2)
                                    .foregroundStyle(.gray)
                            }
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(.systemGray5))
                        .clipShape(Capsule())
                    }

                    TextField("", text: $givenName)
                        .disableAutocorrection(true)
                        .textContentType(.oneTimeCode)
                        .focused($focus, equals: .givenName)
                        .submitLabel(.next)
                        .onSubmit {
                            let trimmed = givenName.trimmingCharacters(in: .whitespaces)
                            if !trimmed.isEmpty {
                                people.append(trimmed)
                                givenName = ""
                            }
                            focus = .givenName
                        }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .frame(width: 300, alignment: .leading)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray3), lineWidth: 0.5)
                )

                // 함께한 장소
                Text("함께한 장소")
                    .bold()

                TextField("", text: $familyName)
                    .disableAutocorrection(true)
                    .textContentType(.oneTimeCode)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 300, height: 44)
                    .focused($focus, equals: .familyName)
                    .submitLabel(.done)
                    .onSubmit {
                        if let imageName = imageMap[familyName] {
                            stackedImages.append(imageName)
                        }
                        focus = nil
                    }
                    .onChange(of: familyName) {
                        if imageMap[familyName] == nil {
                            stackedImages.removeAll()
                        }
                    }
            }
            .padding()
            .onAppear { focus = .givenName }
        }
    }
}

#Preview {
    MainView()
}
