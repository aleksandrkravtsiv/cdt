# 🔵 BLE Peripheral with Custom UUID

This project demonstrates how to use a **custom CBUUID** for BLE communication on iOS, based on the configuration described in the [*“Emulate BLE device using nRF Connect for Mobile app”*](https://citrusdev.com.ua/emulate-ble-device-using-nrf-connect-for-mobile-app/) guide by CitrusDev.

---

## 📘 Overview

Instead of using the default UUIDs, the project defines a custom BLE service identifier:

```swift
CBUUID(string: Constants.serviceUUID)
```

This approach allows developers to:

- 🧩 Control and test BLE services with fixed, custom UUIDs  
- 🔗 Easily connect the client app to an emulated peripheral  
- ⚙️ Use the **nRF Connect** configuration as the base for GATT server emulation  

---

## 🛠 Usage

### 1. Configure in nRF Connect
Follow the [CitrusDev guide](https://citrusdev.com.ua/emulate-ble-device-using-nrf-connect-for-mobile-app/) to set up your BLE service and characteristics in the **nRF Connect** mobile app.

### 2. Use in your client app
In your iOS client, specify the service identifier:
```swift
CBUUID(string: "3333")
```

### 3. Connect and interact
- Scan and connect to your emulated peripheral  
- Read, write, or subscribe to characteristics notifications  
- Validate communication flow between your app and the BLE service  

---

## 🧠 Example Flow

1. Launch nRF Connect and emulate your BLE device  
2. Run this project on your iOS device  
3. Observe connection logs, data exchange, and characteristic updates  

---

## 📦 Requirements

- Xcode 15+  
- iOS 16+  
- Swift 5.9+  
- Bluetooth permissions enabled  

---

## 🧰 Tech Stack

- **Swift / CoreBluetooth**  
- **nRF Connect for Mobile**  
- **Custom Service UUID for handling interactions**

---

## 🧑‍💻 Author

Developed by [Oleksandr Kravtsiv](https://github.com/oleksandrkravtsiv)  
Based on CitrusDev’s BLE configuration guide.

---

## 🪪 License

This project is distributed under the MIT License.  
See [`LICENSE`](LICENSE) for details.
