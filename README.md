# 📸 Phopo

포항의 추억을 지도 위에 기록하는 iOS 앱. 사진·장소·사람을 카드로 저장하고, 지도 하이라이트로 한눈에 돌아봅니다.

![Swift](https://img.shields.io/badge/Swift-5.9+-F05138?style=flat&logo=swift&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-17+-000000?style=flat&logo=apple)
![SwiftUI](https://img.shields.io/badge/SwiftUI-teal?style=flat)

---

## 기술 스택

| 항목 | 내용 |
|---|---|
| UI Framework | SwiftUI |
| Navigation | NavigationStack |
| Camera | UIImagePickerController (UIKit bridge) |
| Modal | `.sheet` / `.fullScreenCover` |
| Minimum Target | iOS 17+ |

---

## 주요 구현

- **무한 캐러셀** — `repeatCount 999` + startIndex 중앙 정렬로 양방향 무한 스크롤 구현
- **카드 전환 애니메이션** — `scrollTransition`으로 scaleEffect + opacity 처리
- **페이징 스냅** — `.scrollTargetBehavior(.viewAligned)` + `.contentMargins`
- **지도 하이라이트** — `onChange(of: selection)` → `highlightMap` 갱신 → `.blendMode(.multiply)` 오버레이
- **날짜·시간 입력** — `@Binding` 기반 `CalendarView` / `HourView` sheet 분리
- **장소→스티커 매핑** — `imageMap: [String: String]` 딕셔너리 룩업
- **카메라 브릿지** — `UIViewControllerRepresentable` + Coordinator 패턴

---

## 화면 구성
hereView<br> 
└── NavigationStack<br> 
└── CarouselView<br> 
├── mapView          # 지도 + 유저 선택 Menu<br> 
└── ScrollView (horizontal)<br> 
└── CardView     # 추억 카드<br> 
└── MainView # 날짜·장소·사람 입력 (NavigationLink)<br> 

