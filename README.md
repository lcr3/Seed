# 🌱Seed

## 📱Screens

| 🌞 | 🌙 |
|:--:|:--:|
|<img src='./Images/light.png' width=300>|<img src='./Images/dark.png' width=300>|
## 🏗Architecture

[The Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture)

### Projects

* `Debug.xcodeproj`, `Production.xcodeproj`環境を分けている
* 各ページの機能をモジュール化して[Package.swift](./Package.swift)にて管理

```
Seed
├── Seed
|   |   // Debug Configuration project
│   ├── Debug.xcodeproj/
|   |   // App Sources
│   ├── iOS/
│   ├── Package.swift
|   |   // Production Configuration project
│   └── Production.xcodeproj/
├── Seed.xcworkspace
├── Mintfile
├── Package.swift
├── README.md
|   // Swift Pacakge Sources
├── Sources
|   // Swift Pacakge Tests
└── Tests

```

## 🥞DB

[Firebase](https://github.com/firebase/firebase-ios-sdk/tree/master/Firestore)

## Reference

* [isowords](https://github.com/pointfreeco/isowords)
* [DoroidKaigi-iOSApp](https://github.com/DroidKaigi/conference-app-2021)