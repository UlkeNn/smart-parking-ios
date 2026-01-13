# 📱 Smart Parking iOS App  
SwiftUI + MVVM + Clean Architecture ile geliştirilen akıllı otopark mobil uygulaması.

Bu proje, kullanıcıların otoparkları harita üzerinden görüntüleyip rezervasyon yapabilmesini sağlayan bir mobil uygulamadır. Backend tarafı Spring Boot ile geliştirilmiş olup uygulama REST API üzerinden haberleşir.

---

## 🚀 Özellikler
- 🔐 **Kullanıcı Girişi (Auth)**
- 🗺️ **Harita Üzerinde Otopark Gösterimi**
- 📄 **Otopark Listeleme**
- 🅿️ **Rezervasyon Oluşturma**
- 📋 **Kullanıcının Rezervasyonlarını Görüntüleme**
- 🎨 Modern SwiftUI tasarımı
---

## 🖼️ Ekran Görüntüleri

<table>
  <tr>
    <td><img src="screenshots/home.png" width="200"></td>
    <td><img src="screenshots/login.png" width="200"></td>
    <td><img src="screenshots/map.png" width="200"></td>
    <td><img src="screenshots/profile.png" width="200"></td>
    <td><img src="screenshots/ReservationDate.png" width="200"></td>
    <td><img src="screenshots/ReservationPage.png" width="200"></td>
    <td><img src="screenshots/reservations.png" width="200"></td>
    <td><img src="screenshots/VehicleAdd.png" width="200"></td>
    <td><img src="screenshots/VehiscleSelected.png" width="200"></td>
  </tr>
</table>

---

## 🏗️ Mimarî Yapı

Uygulama **MVVM + Clean Architecture + Feature-Based** yapıdadır.

### ⭐ Katmanlar
1. **App**  
   Uygulamanın giriş noktası ve global appearance yönetimi.

2. **Core**  
   - **Models** (DTO, domain modelleri)  
   - **Repositories** (Protocol tanımları)  
   - **Services** (Network, Session, Storage, Default repository implementasyonları)

3. **Presentation**  
   - SwiftUI View’lar  
   - ViewModel’ler  
   - Feature bazlı klasörleme: `Auth`, `ParkingMap`, `Reservations`, `Home`

---
## 🔌 API İletişimi

Tüm ağ istekleri **URLSession** tabanlı **APIClient** üzerinden yönetilir.

- `APIClient` → HTTP katmanı  
- `AuthRepository`, `ParkingRepository`, `ReservationRepository` → protokoller  
- `DefaultAuthRepository`, `DefaultParkingRepository` → implementasyon  

---
## 📡 Backend

Backend Spring Boot ile geliştirilmiştir:
https://github.com/MAErd4141/SmartParkingPrototype

---
## 🛠️ Kurulum

1. Repoyu klonlayın:
   ```bash
   git clone https://github.com/UlkeNn/smart-parking-ios.git
   cd smart-parking-ios
2. Xcode ile açın:
   ```bash
   open OtoparkDeneme1.xcodeproj
3. Backend base URL’ini APIConfig.swift içinde yapılandırın:
   ```bash
   static let baseURL = "http://192.168.1.xxx:8080"
   
4. Uygulamayı çalıştırın:

    iPhone Simulator
    veya gerçek cihaz
