# ๐ฑSeed

## ๐ฑScreens

| ๐ | ๐ |
|:--:|:--:|
|<img src='./Images/light.png' width=300>|<img src='./Images/dark.png' width=300>|
## ๐Architecture

[The Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture)

### Projects

* `Debug.xcodeproj`, `Production.xcodeproj`็ฐๅขใๅใใฆใใ
* ๅใใผใธใฎๆฉ่ฝใใขใธใฅใผใซๅใใฆ[Package.swift](./Package.swift)ใซใฆ็ฎก็

```
Seed
โโโ Seed
|   |   // Debug Configuration project
โย ย  โโโ Debug.xcodeproj/
|   |   // App Sources
โย ย  โโโ iOS/
โย ย  โโโ Package.swift
|   |   // Production Configuration project
โย ย  โโโ Production.xcodeproj/
โโโ Seed.xcworkspace
โโโ Mintfile
โโโ Package.swift
โโโ README.md
|   // Swift Pacakge Sources
โโโ Sources
|   // Swift Pacakge Tests
โโโ Tests

```

## ๐ฅDB

[Firebase](https://github.com/firebase/firebase-ios-sdk/tree/master/Firestore)

## Reference

* [isowords](https://github.com/pointfreeco/isowords)
* [DoroidKaigi-iOSApp](https://github.com/DroidKaigi/conference-app-2021)