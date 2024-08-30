//
//  Device+.swift
//  Utility
//
//  Created by 조용인 on 8/30/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

// MARK: Device

/// This enum is a value-type wrapper and extension of
/// [`UIDevice`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIDevice_Class/).
///
/// Usage:
///
///     let device = Device.current
///
///     print(device)     // prints, for example, "iPhone 6 Plus"
///
///     if device == .iPhone6Plus {
///         // Do something
///     } else {
///         // Do something else
///     }
///
///     ...
///
///     if device.batteryState == .full || device.batteryState >= .charging(75) {
///         print("Your battery is happy! 😊")
///     }
///
///     ...
///
///     if device.batteryLevel >= 50 {
///         install_iOS()
///     } else {
///         showError()
///     }
///
public enum Device {
  /// Device is an [iPod touch (5th generation)](https://support.apple.com/kb/SP657)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP657/sp657_ipod-touch_size.jpg)
  case iPodTouch5
  /// Device is an [iPod touch (6th generation)](https://support.apple.com/kb/SP720)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP720/SP720-ipod-touch-specs-color-sg-2015.jpg)
  case iPodTouch6
  /// Device is an [iPod touch (7th generation)](https://support.apple.com/kb/SP796)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP796/ipod-touch-7th-gen_2x.png)
  case iPodTouch7
  /// Device is an [iPhone 4](https://support.apple.com/kb/SP587)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP643/sp643_iphone4s_color_black.jpg)
  case iPhone4
  /// Device is an [iPhone 4s](https://support.apple.com/kb/SP643)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP643/sp643_iphone4s_color_black.jpg)
  case iPhone4s
  /// Device is an [iPhone 5](https://support.apple.com/kb/SP655)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP655/sp655_iphone5_color.jpg)
  case iPhone5
  /// Device is an [iPhone 5c](https://support.apple.com/kb/SP684)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP684/SP684-color_yellow.jpg)
  case iPhone5c
  /// Device is an [iPhone 5s](https://support.apple.com/kb/SP685)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP685/SP685-color_black.jpg)
  case iPhone5s
  /// Device is an [iPhone 6](https://support.apple.com/kb/SP705)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP705/SP705-iphone_6-mul.png)
  case iPhone6
  /// Device is an [iPhone 6 Plus](https://support.apple.com/kb/SP706)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP706/SP706-iphone_6_plus-mul.png)
  case iPhone6Plus
  /// Device is an [iPhone 6s](https://support.apple.com/kb/SP726)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP726/SP726-iphone6s-gray-select-2015.png)
  case iPhone6s
  /// Device is an [iPhone 6s Plus](https://support.apple.com/kb/SP727)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP727/SP727-iphone6s-plus-gray-select-2015.png)
  case iPhone6sPlus
  /// Device is an [iPhone 7](https://support.apple.com/kb/SP743)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP743/iphone7-black.png)
  case iPhone7
  /// Device is an [iPhone 7 Plus](https://support.apple.com/kb/SP744)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP744/iphone7-plus-black.png)
  case iPhone7Plus
  /// Device is an [iPhone SE](https://support.apple.com/kb/SP738)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP738/SP738.png)
  case iPhoneSE
  /// Device is an [iPhone 8](https://support.apple.com/kb/SP767)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP767/iphone8.png)
  case iPhone8
  /// Device is an [iPhone 8 Plus](https://support.apple.com/kb/SP768)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP768/iphone8plus.png)
  case iPhone8Plus
  /// Device is an [iPhone X](https://support.apple.com/kb/SP770)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP770/iphonex.png)
  case iPhoneX
  /// Device is an [iPhone Xs](https://support.apple.com/kb/SP779)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP779/SP779-iphone-xs.jpg)
  case iPhoneXS
  /// Device is an [iPhone Xs Max](https://support.apple.com/kb/SP780)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP780/SP780-iPhone-Xs-Max.jpg)
  case iPhoneXSMax
  /// Device is an [iPhone Xʀ](https://support.apple.com/kb/SP781)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP781/SP781-iPhone-xr.jpg)
  case iPhoneXR
  /// Device is an [iPhone 11](https://support.apple.com/kb/SP804)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP804/sp804-iphone11_2x.png)
  case iPhone11
  /// Device is an [iPhone 11 Pro](https://support.apple.com/kb/SP805)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP805/sp805-iphone11pro_2x.png)
  case iPhone11Pro
  /// Device is an [iPhone 11 Pro Max](https://support.apple.com/kb/SP806)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP806/sp806-iphone11pro-max_2x.png)
  case iPhone11ProMax
  /// Device is an [iPhone SE (2nd generation)](https://support.apple.com/kb/SP820)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP820/iphone-se-2nd-gen_2x.png)
  case iPhoneSE2
  /// Device is an [iPhone 12](https://support.apple.com/kb/SP830)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP830/sp830-iphone12-ios14_2x.png)
  case iPhone12
  /// Device is an [iPhone 12 mini](https://support.apple.com/kb/SP829)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP829/sp829-iphone12mini-ios14_2x.png)
  case iPhone12Mini
  /// Device is an [iPhone 12 Pro](https://support.apple.com/kb/SP831)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP831/iphone12pro-ios14_2x.png)
  case iPhone12Pro
  /// Device is an [iPhone 12 Pro Max](https://support.apple.com/kb/SP832)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP832/iphone12promax-ios14_2x.png)
  case iPhone12ProMax
  /// Device is an [iPhone 13](https://support.apple.com/kb/SP851)
  ///
  /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/1000/IM1092/en_US/iphone-13-240.png)
  case iPhone13
  /// Device is an [iPhone 13 mini](https://support.apple.com/kb/SP847)
  ///
  /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/1000/IM1091/en_US/iphone-13mini-240.png)
  case iPhone13Mini
  /// Device is an [iPhone 13 Pro](https://support.apple.com/kb/SP852)
  ///
  /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/1000/IM1093/en_US/iphone-13pro-240.png)
  case iPhone13Pro
  /// Device is an [iPhone 13 Pro Max](https://support.apple.com/kb/SP848)
  ///
  /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/1000/IM1095/en_US/iphone-13promax-240.png)
  case iPhone13ProMax
  /// Device is an [iPhone SE (3rd generation)](https://support.apple.com/kb/SP867)
  ///
  /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/1000/IM1136/en_US/iphone-se-3rd-gen-colors-240.png)
  case iPhoneSE3
  /// Device is an [iPhone 14](https://support.apple.com/kb/SP873)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP873/iphone-14_1_2x.png)
  case iPhone14
  /// Device is an [iPhone 14 Plus](https://support.apple.com/kb/SP874)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP873/iphone-14_1_2x.png)
  case iPhone14Plus
  /// Device is an [iPhone 14 Pro](https://support.apple.com/kb/SP875)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP875/sp875-sp876-iphone14-pro-promax_2x.png)
  case iPhone14Pro
  /// Device is an [iPhone 14 Pro Max](https://support.apple.com/kb/SP876)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP875/sp875-sp876-iphone14-pro-promax_2x.png)
  case iPhone14ProMax
  /// Device is an [iPhone 15]()
  ///
  /// ![Image]()
  case iPhone15
  /// Device is an [iPhone 15 Plus]()
  ///
  /// ![Image]()
  case iPhone15Plus
  /// Device is an [iPhone 15 Pro]()
  ///
  /// ![Image]()
  case iPhone15Pro
  /// Device is an [iPhone 15 Pro Max]()
  ///
  /// ![Image]()
  case iPhone15ProMax
  /// Device is [Simulator](https://developer.apple.com/library/ios/documentation/IDEs/Conceptual/iOS_Simulator_Guide/Introduction/Introduction.html)
  ///
  /// ![Image](https://developer.apple.com/assets/elements/icons/256x256/xcode-6.png)
  indirect case simulator(Device)
  
  /// Device is not yet known (implemented)
  /// You can still use this enum as before but the description equals the identifier (you can get multiple identifiers for the same product class
  /// (e.g. "iPhone6,1" or "iPhone 6,2" do both mean "iPhone 5s"))
  case unknown(String)
  
  /// Returns a `Device` representing the current device this software runs on.
  public static var current: Device {
    return Device.mapToDevice(identifier: Device.identifier)
  }
  
  /// Gets the identifier from the system, such as "iPhone7,1".
  public static var identifier: String = {
    var systemInfo = utsname()
    uname(&systemInfo)
    let mirror = Mirror(reflecting: systemInfo.machine)
    
    let identifier = mirror.children.reduce("") { identifier, element in
      guard let value = element.value as? Int8, value != 0 else { return identifier }
      return identifier + String(UnicodeScalar(UInt8(value)))
    }
    return identifier
  }()
  
  /// Maps an identifier to a Device. If the identifier can not be mapped to an existing device, `UnknownDevice(identifier)` is returned.
  ///
  /// - parameter identifier: The device identifier, e.g. "iPhone7,1". Can be obtained from `Device.identifier`.
  ///
  /// - returns: An initialized `Device`.
  public static func mapToDevice(identifier: String) -> Device { // swiftlint:disable:this cyclomatic_complexity function_body_length
    switch identifier {
    case "iPod5,1": return iPodTouch5
    case "iPod7,1": return iPodTouch6
    case "iPod9,1": return iPodTouch7
    case "iPhone3,1", "iPhone3,2", "iPhone3,3": return iPhone4
    case "iPhone4,1": return iPhone4s
    case "iPhone5,1", "iPhone5,2": return iPhone5
    case "iPhone5,3", "iPhone5,4": return iPhone5c
    case "iPhone6,1", "iPhone6,2": return iPhone5s
    case "iPhone7,2": return iPhone6
    case "iPhone7,1": return iPhone6Plus
    case "iPhone8,1": return iPhone6s
    case "iPhone8,2": return iPhone6sPlus
    case "iPhone9,1", "iPhone9,3": return iPhone7
    case "iPhone9,2", "iPhone9,4": return iPhone7Plus
    case "iPhone8,4": return iPhoneSE
    case "iPhone10,1", "iPhone10,4": return iPhone8
    case "iPhone10,2", "iPhone10,5": return iPhone8Plus
    case "iPhone10,3", "iPhone10,6": return iPhoneX
    case "iPhone11,2": return iPhoneXS
    case "iPhone11,4", "iPhone11,6": return iPhoneXSMax
    case "iPhone11,8": return iPhoneXR
    case "iPhone12,1": return iPhone11
    case "iPhone12,3": return iPhone11Pro
    case "iPhone12,5": return iPhone11ProMax
    case "iPhone12,8": return iPhoneSE2
    case "iPhone13,2": return iPhone12
    case "iPhone13,1": return iPhone12Mini
    case "iPhone13,3": return iPhone12Pro
    case "iPhone13,4": return iPhone12ProMax
    case "iPhone14,5": return iPhone13
    case "iPhone14,4": return iPhone13Mini
    case "iPhone14,2": return iPhone13Pro
    case "iPhone14,3": return iPhone13ProMax
    case "iPhone14,6": return iPhoneSE3
    case "iPhone14,7": return iPhone14
    case "iPhone14,8": return iPhone14Plus
    case "iPhone15,2": return iPhone14Pro
    case "iPhone15,3": return iPhone14ProMax
    case "iPhone15,4": return iPhone15
    case "iPhone15,5": return iPhone15Plus
    case "iPhone16,1": return iPhone15Pro
    case "iPhone16,2": return iPhone15ProMax
    default: return unknown(identifier)
    }
  }
  
  /// Get the real device from a device.
  /// If the device is a an iPhone8Plus simulator this function returns .iPhone8Plus (the real device).
  /// If the parameter is a real device, this function returns just that passed parameter.
  ///
  /// - parameter device: A device.
  ///
  /// - returns: the underlying device If the `device` is a `simulator`,
  /// otherwise return the `device`.
  public static func realDevice(from device: Device) -> Device {
    if case let .simulator(model) = device {
      return model
    }
    return device
  }
  
  /// Returns diagonal screen length in inches
  public var diagonal: Double {
    switch self {
    case .iPodTouch5: return 4
    case .iPodTouch6: return 4
    case .iPodTouch7: return 4
    case .iPhone4: return 3.5
    case .iPhone4s: return 3.5
    case .iPhone5: return 4
    case .iPhone5c: return 4
    case .iPhone5s: return 4
    case .iPhone6: return 4.7
    case .iPhone6Plus: return 5.5
    case .iPhone6s: return 4.7
    case .iPhone6sPlus: return 5.5
    case .iPhone7: return 4.7
    case .iPhone7Plus: return 5.5
    case .iPhoneSE: return 4
    case .iPhone8: return 4.7
    case .iPhone8Plus: return 5.5
    case .iPhoneX: return 5.8
    case .iPhoneXS: return 5.8
    case .iPhoneXSMax: return 6.5
    case .iPhoneXR: return 6.1
    case .iPhone11: return 6.1
    case .iPhone11Pro: return 5.8
    case .iPhone11ProMax: return 6.5
    case .iPhoneSE2: return 4.7
    case .iPhone12: return 6.1
    case .iPhone12Mini: return 5.4
    case .iPhone12Pro: return 6.1
    case .iPhone12ProMax: return 6.7
    case .iPhone13: return 6.1
    case .iPhone13Mini: return 5.4
    case .iPhone13Pro: return 6.1
    case .iPhone13ProMax: return 6.7
    case .iPhoneSE3: return 4.7
    case .iPhone14: return 6.1
    case .iPhone14Plus: return 6.7
    case .iPhone14Pro: return 6.1
    case .iPhone14ProMax: return 6.7
    case .iPhone15: return 6.1
    case .iPhone15Plus: return 6.7
    case .iPhone15Pro: return 6.1
    case .iPhone15ProMax: return 6.7
    case .simulator(let model): return model.diagonal
    case .unknown: return -1
    }
  }
  
  /// Returns screen ratio as a tuple
  public var screenRatio: (width: Double, height: Double) {
    switch self {
    case .iPodTouch5: return (width: 9, height: 16)
    case .iPodTouch6: return (width: 9, height: 16)
    case .iPodTouch7: return (width: 9, height: 16)
    case .iPhone4: return (width: 2, height: 3)
    case .iPhone4s: return (width: 2, height: 3)
    case .iPhone5: return (width: 9, height: 16)
    case .iPhone5c: return (width: 9, height: 16)
    case .iPhone5s: return (width: 9, height: 16)
    case .iPhone6: return (width: 9, height: 16)
    case .iPhone6Plus: return (width: 9, height: 16)
    case .iPhone6s: return (width: 9, height: 16)
    case .iPhone6sPlus: return (width: 9, height: 16)
    case .iPhone7: return (width: 9, height: 16)
    case .iPhone7Plus: return (width: 9, height: 16)
    case .iPhoneSE: return (width: 9, height: 16)
    case .iPhone8: return (width: 9, height: 16)
    case .iPhone8Plus: return (width: 9, height: 16)
    case .iPhoneX: return (width: 9, height: 19.5)
    case .iPhoneXS: return (width: 9, height: 19.5)
    case .iPhoneXSMax: return (width: 9, height: 19.5)
    case .iPhoneXR: return (width: 9, height: 19.5)
    case .iPhone11: return (width: 9, height: 19.5)
    case .iPhone11Pro: return (width: 9, height: 19.5)
    case .iPhone11ProMax: return (width: 9, height: 19.5)
    case .iPhoneSE2: return (width: 9, height: 16)
    case .iPhone12: return (width: 9, height: 19.5)
    case .iPhone12Mini: return (width: 9, height: 19.5)
    case .iPhone12Pro: return (width: 9, height: 19.5)
    case .iPhone12ProMax: return (width: 9, height: 19.5)
    case .iPhone13: return (width: 9, height: 19.5)
    case .iPhone13Mini: return (width: 9, height: 19.5)
    case .iPhone13Pro: return (width: 9, height: 19.5)
    case .iPhone13ProMax: return (width: 9, height: 19.5)
    case .iPhoneSE3: return (width: 9, height: 16)
    case .iPhone14: return (width: 9, height: 19.5)
    case .iPhone14Plus: return (width: 9, height: 19.5)
    case .iPhone14Pro: return (width: 9, height: 19.5)
    case .iPhone14ProMax: return (width: 9, height: 19.5)
    case .iPhone15: return (width: 9, height: 19.5)
    case .iPhone15Plus: return (width: 9, height: 19.5)
    case .iPhone15Pro: return (width: 9, height: 19.5)
    case .iPhone15ProMax: return (width: 9, height: 19.5)
    case .simulator(let model): return model.screenRatio
    case .unknown: return (width: -1, height: -1)
    }
  }
  
  /// All iPods
  public static var allPods: [Device] {
    return [.iPodTouch5, .iPodTouch6, .iPodTouch7]
  }
  
  /// All iPhones
  public static var allPhones: [Device] {
    return [.iPhone4, .iPhone4s, .iPhone5, .iPhone5c, .iPhone5s, .iPhone6, .iPhone6Plus, .iPhone6s, .iPhone6sPlus, .iPhone7, .iPhone7Plus, .iPhoneSE, .iPhone8, .iPhone8Plus, .iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhone11Pro, .iPhone11ProMax, .iPhoneSE2, .iPhone12, .iPhone12Mini, .iPhone12Pro, .iPhone12ProMax, .iPhone13, .iPhone13Mini, .iPhone13Pro, .iPhone13ProMax, .iPhoneSE3, .iPhone14, .iPhone14Plus, .iPhone14Pro, .iPhone14ProMax, .iPhone15, .iPhone15Plus, .iPhone15Pro, .iPhone15ProMax]
  }
  
  /// All X-Series Devices
  @available(*, deprecated, renamed: "allDevicesWithSensorHousing")
  public static var allXSeriesDevices: [Device] {
    return [.iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhone11Pro, .iPhone11ProMax, .iPhone12, .iPhone12Mini, .iPhone12Pro, .iPhone12ProMax, .iPhone13, .iPhone13Mini, .iPhone13Pro, .iPhone13ProMax, .iPhone14, .iPhone14Plus, .iPhone14Pro, .iPhone14ProMax, .iPhone15, .iPhone15Plus, .iPhone15Pro, .iPhone15ProMax]
  }
  
  /// All Plus and Max-Sized Devices
  public static var allPlusSizedDevices: [Device] {
    return [.iPhone6Plus, .iPhone6sPlus, .iPhone7Plus, .iPhone8Plus, .iPhoneXSMax, .iPhone11ProMax, .iPhone12ProMax, .iPhone13ProMax, .iPhone14Plus, .iPhone14ProMax, .iPhone15Plus, .iPhone15ProMax]
  }
  
  /// All Pro Devices
  public static var allProDevices: [Device] {
    return [.iPhone11Pro, .iPhone11ProMax, .iPhone12Pro, .iPhone12ProMax, .iPhone13Pro, .iPhone13ProMax, .iPhone14Pro, .iPhone14ProMax, .iPhone15Pro, .iPhone15ProMax]
  }
  
  /// All simulator iPods
  public static var allSimulatorPods: [Device] {
    return allPods.map(Device.simulator)
  }
  
  /// All simulator iPhones
  public static var allSimulatorPhones: [Device] {
    return allPhones.map(Device.simulator)
  }
  
  /// All simulator X series Devices
  @available(*, deprecated, renamed: "allSimulatorDevicesWithSensorHousing")
  public static var allSimulatorXSeriesDevices: [Device] {
    return allDevicesWithSensorHousing.map(Device.simulator)
  }
  
  /// All simulator Plus and Max-Sized Devices
  public static var allSimulatorPlusSizedDevices: [Device] {
    return allPlusSizedDevices.map(Device.simulator)
  }
  
  /// All simulator Pro Devices
  public static var allSimulatorProDevices: [Device] {
    return allProDevices.map(Device.simulator)
  }
  
  /// Returns whether the device is an iPod (real or simulator)
  public var isPod: Bool {
    return isOneOf(Device.allPods) || isOneOf(Device.allSimulatorPods)
  }
  
  /// If this device is a simulator return the underlying device,
  /// otherwise return `self`.
  public var realDevice: Device {
    return Device.realDevice(from: self)
  }
  
  public var isZoomed: Bool? {
    guard isCurrent else { return nil }
    if Int(UIScreen.main.scale.rounded()) == 3 {
      // Plus-sized
      return UIScreen.main.nativeScale > 2.7 && UIScreen.main.nativeScale < 3
    } else {
      return UIScreen.main.nativeScale > UIScreen.main.scale
    }
  }
  
  /// All Touch ID Capable Devices
  public static var allTouchIDCapableDevices: [Device] {
    return [.iPhone5s, .iPhone6, .iPhone6Plus, .iPhone6s, .iPhone6sPlus, .iPhone7, .iPhone7Plus, .iPhoneSE, .iPhone8, .iPhone8Plus, .iPhoneSE2, .iPhoneSE3]
  }
  
  /// All Face ID Capable Devices
  public static var allFaceIDCapableDevices: [Device] {
    return [.iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhone11Pro, .iPhone11ProMax, .iPhone12, .iPhone12Mini, .iPhone12Pro, .iPhone12ProMax, .iPhone13, .iPhone13Mini, .iPhone13Pro, .iPhone13ProMax, .iPhone14, .iPhone14Plus, .iPhone14Pro, .iPhone14ProMax, .iPhone15, .iPhone15Plus, .iPhone15Pro, .iPhone15ProMax]
  }
  
  /// All Devices with Touch ID or Face ID
  public static var allBiometricAuthenticationCapableDevices: [Device] {
    return [.iPhone5s, .iPhone6, .iPhone6Plus, .iPhone6s, .iPhone6sPlus, .iPhone7, .iPhone7Plus, .iPhoneSE, .iPhone8, .iPhone8Plus, .iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhone11Pro, .iPhone11ProMax, .iPhoneSE2, .iPhone12, .iPhone12Mini, .iPhone12Pro, .iPhone12ProMax, .iPhone13, .iPhone13Mini, .iPhone13Pro, .iPhone13ProMax, .iPhoneSE3, .iPhone14, .iPhone14Plus, .iPhone14Pro, .iPhone14ProMax, .iPhone15, .iPhone15Plus, .iPhone15Pro, .iPhone15ProMax]
  }
  
  /// Returns whether or not the device has Touch ID
  public var isTouchIDCapable: Bool {
    return isOneOf(Device.allTouchIDCapableDevices) || isOneOf(Device.allTouchIDCapableDevices.map(Device.simulator))
  }
  
  /// Returns whether or not the device has Face ID
  public var isFaceIDCapable: Bool {
    return isOneOf(Device.allFaceIDCapableDevices) || isOneOf(Device.allFaceIDCapableDevices.map(Device.simulator))
  }
  
  /// Returns whether or not the device has any biometric sensor (i.e. Touch ID or Face ID)
  public var hasBiometricSensor: Bool {
    return isTouchIDCapable || isFaceIDCapable
  }
  
  /// All devices that feature a sensor housing in the screen
  public static var allDevicesWithSensorHousing: [Device] {
    return [.iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhone11Pro, .iPhone11ProMax, .iPhone12, .iPhone12Mini, .iPhone12Pro, .iPhone12ProMax, .iPhone13, .iPhone13Mini, .iPhone13Pro, .iPhone13ProMax, .iPhone14, .iPhone14Plus, .iPhone14Pro, .iPhone14ProMax, .iPhone15, .iPhone15Plus, .iPhone15Pro, .iPhone15ProMax]
  }
  
  /// All simulator devices that feature a sensor housing in the screen
  public static var allSimulatorDevicesWithSensorHousing: [Device] {
    return allDevicesWithSensorHousing.map(Device.simulator)
  }
  
  /// Returns whether or not the device has a sensor housing
  public var hasSensorHousing: Bool {
    return isOneOf(Device.allDevicesWithSensorHousing) || isOneOf(Device.allDevicesWithSensorHousing.map(Device.simulator))
  }
  
  /// All devices that feature a screen with rounded corners.
  public static var allDevicesWithRoundedDisplayCorners: [Device] {
    return [.iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhone11Pro, .iPhone11ProMax, .iPhone12, .iPhone12Mini, .iPhone12Pro, .iPhone12ProMax, .iPhone13, .iPhone13Mini, .iPhone13Pro, .iPhone13ProMax, .iPhone14, .iPhone14Plus, .iPhone14Pro, .iPhone14ProMax, .iPhone15, .iPhone15Plus, .iPhone15Pro, .iPhone15ProMax]
  }
  
  /// Returns whether or not the device has a screen with rounded corners.
  public var hasRoundedDisplayCorners: Bool {
    return isOneOf(Device.allDevicesWithRoundedDisplayCorners) || isOneOf(Device.allDevicesWithRoundedDisplayCorners.map(Device.simulator))
  }
  
  /// All devices that have the Dynamic Island.
  public static var allDevicesWithDynamicIsland: [Device] {
    return [.iPhone14Pro, .iPhone14ProMax, .iPhone15, .iPhone15Plus, .iPhone15Pro, .iPhone15ProMax]
  }
  
  /// Returns whether or not the device has the Dynamic Island.
  public var hasDynamicIsland: Bool {
    return isOneOf(Device.allDevicesWithDynamicIsland) || isOneOf(Device.allDevicesWithDynamicIsland.map(Device.simulator))
  }
  
  /// All devices that have 3D Touch support.
  public static var allDevicesWith3dTouchSupport: [Device] {
    return [.iPhone6s, .iPhone6sPlus, .iPhone7, .iPhone7Plus, .iPhone8, .iPhone8Plus, .iPhoneX, .iPhoneXS, .iPhoneXSMax]
  }
  
  /// Returns whether or not the device has 3D Touch support.
  public var has3dTouchSupport: Bool {
    return isOneOf(Device.allDevicesWith3dTouchSupport) || isOneOf(Device.allDevicesWith3dTouchSupport.map(Device.simulator))
  }
  
  /// All devices that support wireless charging.
  public static var allDevicesWithWirelessChargingSupport: [Device] {
    return [.iPhone8, .iPhone8Plus, .iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhone11Pro, .iPhone11ProMax, .iPhoneSE2, .iPhone12, .iPhone12Mini, .iPhone12Pro, .iPhone12ProMax, .iPhone13, .iPhone13Mini, .iPhone13Pro, .iPhone13ProMax, .iPhoneSE3, .iPhone14, .iPhone14Plus, .iPhone14Pro, .iPhone14ProMax, .iPhone15, .iPhone15Plus, .iPhone15Pro, .iPhone15ProMax]
  }
  
  /// Returns whether or not the device supports wireless charging.
  public var supportsWirelessCharging: Bool {
    return isOneOf(Device.allDevicesWithWirelessChargingSupport) || isOneOf(Device.allDevicesWithWirelessChargingSupport.map(Device.simulator))
  }
  
  /// All devices that support 5G.
  public static var allDevicesWith5gSupport: [Device] {
    return [.iPhone12, .iPhone12Mini, .iPhone12Pro, .iPhone12ProMax, .iPhone13, .iPhone13Mini, .iPhone13Pro, .iPhone13ProMax, .iPhoneSE3, .iPhone14, .iPhone14Plus, .iPhone14Pro, .iPhone14ProMax, .iPhone15, .iPhone15Plus, .iPhone15Pro, .iPhone15ProMax]
  }
  
  /// Returns whether or not the device has 5G support.
  public var has5gSupport: Bool {
    return isOneOf(Device.allDevicesWith5gSupport) || isOneOf(Device.allDevicesWith5gSupport.map(Device.simulator))
  }
  
  /// All devices that have a LiDAR sensor.
  public static var allDevicesWithALidarSensor: [Device] {
    return [.iPhone12Pro, .iPhone12ProMax, .iPhone13Pro, .iPhone13ProMax, .iPhone14Pro, .iPhone14ProMax, .iPhone15Pro, .iPhone15ProMax]
  }
  
  /// Returns whether or not the device has a LiDAR sensor.
  public var hasLidarSensor: Bool {
    return isOneOf(Device.allDevicesWithALidarSensor) || isOneOf(Device.allDevicesWithALidarSensor.map(Device.simulator))
  }
  
  /// All devices that have a USB-C connectivity.
  public static var allDevicesWithUSBCConnectivity: [Device] {
    return [.iPhone15, .iPhone15Plus, .iPhone15Pro, .iPhone15ProMax]
  }
  
  /// Returns whether or not the device has a USB-C power supply.
  public var hasUSBCConnectivity: Bool {
    return isOneOf(Device.allDevicesWithUSBCConnectivity) || isOneOf(Device.allDevicesWithUSBCConnectivity.map(Device.simulator))
  }
  
  /// All real devices (i.e. all devices except for all simulators)
  public static var allRealDevices: [Device] {
    return allPods + allPhones
  }
  
  /// All simulators
  public static var allSimulators: [Device] {
    return allRealDevices.map(Device.simulator)
  }
  
  /// Returns whether the device is any of the simulator
  /// Useful when there is a need to check and skip running a portion of code (location request or others)
  public var isSimulator: Bool {
    return isOneOf(Device.allSimulators)
  }
  
  /**
   This method saves you in many cases from the need of updating your code with every new device.
   Most uses for an enum like this are the following:
   
   ```
   switch Device.current {
   case .iPodTouch5, .iPodTouch6: callMethodOnIPods()
   case .iPhone4, iPhone4s, .iPhone5, .iPhone5s, .iPhone6, .iPhone6Plus, .iPhone6s, .iPhone6sPlus, .iPhone7, .iPhone7Plus, .iPhoneSE, .iPhone8, .iPhone8Plus, .iPhoneX: callMethodOnIPhones()
   case .iPad2, .iPad3, .iPad4, .iPadAir, .iPadAir2, .iPadMini, .iPadMini2, .iPadMini3, .iPadMini4, .iPadPro: callMethodOnIPads()
   default: break
   }
   ```
   This code can now be replaced with
   
   ```
   let device = Device.current
   if device.isOneOf(Device.allPods) {
   callMethodOnIPods()
   } else if device.isOneOf(Device.allPhones) {
   callMethodOnIPhones()
   } else if device.isOneOf(Device.allPads) {
   callMethodOnIPads()
   }
   ```
   
   - parameter devices: An array of devices.
   
   - returns: Returns whether the current device is one of the passed in ones.
   */
  public func isOneOf(_ devices: [Device]) -> Bool {
    return devices.contains(self)
  }
  
  // MARK: Current Device
  
  /// Whether or not the current device is the current device.
  private var isCurrent: Bool {
    return self == Device.current
  }
  
  /// The name identifying the device (e.g. "Dennis' iPhone").
  /// As of iOS 16, this will return a generic String like "iPhone", unless your app has additional entitlements.
  /// See the follwing link for more information: https://developer.apple.com/documentation/uikit/uidevice/1620015-name
  public var name: String? {
    guard isCurrent else { return nil }
    return UIDevice.current.name
  }
  
  /// The name of the operating system running on the device represented by the receiver (e.g. "iOS" or "tvOS").
  public var systemName: String? {
    guard isCurrent else { return nil }
    return UIDevice.current.systemName
  }
  
  /// The current version of the operating system (e.g. 8.4 or 9.2).
  public var systemVersion: String? {
    guard isCurrent else { return nil }
    return UIDevice.current.systemVersion
  }
  
  /// The model of the device (e.g. "iPhone" or "iPod Touch").
  public var model: String? {
    guard isCurrent else { return nil }
    return UIDevice.current.model
  }
  
  /// The model of the device as a localized string.
  public var localizedModel: String? {
    guard isCurrent else { return nil }
    return UIDevice.current.localizedModel
  }
  
  /// PPI (Pixels per Inch) on the current device's screen (if applicable). When the device is not applicable this property returns nil.
  public var ppi: Int? {
    switch self {
    case .iPodTouch5: return 326
    case .iPodTouch6: return 326
    case .iPodTouch7: return 326
    case .iPhone4: return 326
    case .iPhone4s: return 326
    case .iPhone5: return 326
    case .iPhone5c: return 326
    case .iPhone5s: return 326
    case .iPhone6: return 326
    case .iPhone6Plus: return 401
    case .iPhone6s: return 326
    case .iPhone6sPlus: return 401
    case .iPhone7: return 326
    case .iPhone7Plus: return 401
    case .iPhoneSE: return 326
    case .iPhone8: return 326
    case .iPhone8Plus: return 401
    case .iPhoneX: return 458
    case .iPhoneXS: return 458
    case .iPhoneXSMax: return 458
    case .iPhoneXR: return 326
    case .iPhone11: return 326
    case .iPhone11Pro: return 458
    case .iPhone11ProMax: return 458
    case .iPhoneSE2: return 326
    case .iPhone12: return 460
    case .iPhone12Mini: return 476
    case .iPhone12Pro: return 460
    case .iPhone12ProMax: return 458
    case .iPhone13: return 460
    case .iPhone13Mini: return 476
    case .iPhone13Pro: return 460
    case .iPhone13ProMax: return 458
    case .iPhoneSE3: return 326
    case .iPhone14: return 460
    case .iPhone14Plus: return 476
    case .iPhone14Pro: return 460
    case .iPhone14ProMax: return 458
    case .iPhone15: return 460
    case .iPhone15Plus: return 476
    case .iPhone15Pro: return 460
    case .iPhone15ProMax: return 460
    case .simulator(let model): return model.ppi
    case .unknown: return nil
    }
  }
  
  /// True when a Guided Access session is currently active; otherwise, false.
  public var isGuidedAccessSessionActive: Bool {
    return UIAccessibility.isGuidedAccessEnabled
  }
  
  /// The brightness level of the screen.
  public var screenBrightness: Int {
    return Int(UIScreen.main.brightness * 100)
  }
}

// MARK: CustomStringConvertible
extension Device: CustomStringConvertible {
  
  /// A textual representation of the device.
  public var description: String {
    switch self {
    case .iPodTouch5: return "iPod touch (5th generation)"
    case .iPodTouch6: return "iPod touch (6th generation)"
    case .iPodTouch7: return "iPod touch (7th generation)"
    case .iPhone4: return "iPhone 4"
    case .iPhone4s: return "iPhone 4s"
    case .iPhone5: return "iPhone 5"
    case .iPhone5c: return "iPhone 5c"
    case .iPhone5s: return "iPhone 5s"
    case .iPhone6: return "iPhone 6"
    case .iPhone6Plus: return "iPhone 6 Plus"
    case .iPhone6s: return "iPhone 6s"
    case .iPhone6sPlus: return "iPhone 6s Plus"
    case .iPhone7: return "iPhone 7"
    case .iPhone7Plus: return "iPhone 7 Plus"
    case .iPhoneSE: return "iPhone SE"
    case .iPhone8: return "iPhone 8"
    case .iPhone8Plus: return "iPhone 8 Plus"
    case .iPhoneX: return "iPhone X"
    case .iPhoneXS: return "iPhone Xs"
    case .iPhoneXSMax: return "iPhone Xs Max"
    case .iPhoneXR: return "iPhone Xʀ"
    case .iPhone11: return "iPhone 11"
    case .iPhone11Pro: return "iPhone 11 Pro"
    case .iPhone11ProMax: return "iPhone 11 Pro Max"
    case .iPhoneSE2: return "iPhone SE (2nd generation)"
    case .iPhone12: return "iPhone 12"
    case .iPhone12Mini: return "iPhone 12 mini"
    case .iPhone12Pro: return "iPhone 12 Pro"
    case .iPhone12ProMax: return "iPhone 12 Pro Max"
    case .iPhone13: return "iPhone 13"
    case .iPhone13Mini: return "iPhone 13 mini"
    case .iPhone13Pro: return "iPhone 13 Pro"
    case .iPhone13ProMax: return "iPhone 13 Pro Max"
    case .iPhoneSE3: return "iPhone SE (3rd generation)"
    case .iPhone14: return "iPhone 14"
    case .iPhone14Plus: return "iPhone 14 Plus"
    case .iPhone14Pro: return "iPhone 14 Pro"
    case .iPhone14ProMax: return "iPhone 14 Pro Max"
    case .iPhone15: return "iPhone 15"
    case .iPhone15Plus: return "iPhone 15 Plus"
    case .iPhone15Pro: return "iPhone 15 Pro"
    case .iPhone15ProMax: return "iPhone 15 Pro Max"
    case .simulator(let model): return "Simulator (\(model.description))"
    case .unknown(let identifier): return identifier
    }
  }
  
  /// A safe version of `description`.
  /// Example:
  /// Device.iPhoneXR.description:     iPhone Xʀ
  /// Device.iPhoneXR.safeDescription: iPhone XR
  public var safeDescription: String {
    switch self {
    case .iPodTouch5: return "iPod touch (5th generation)"
    case .iPodTouch6: return "iPod touch (6th generation)"
    case .iPodTouch7: return "iPod touch (7th generation)"
    case .iPhone4: return "iPhone 4"
    case .iPhone4s: return "iPhone 4s"
    case .iPhone5: return "iPhone 5"
    case .iPhone5c: return "iPhone 5c"
    case .iPhone5s: return "iPhone 5s"
    case .iPhone6: return "iPhone 6"
    case .iPhone6Plus: return "iPhone 6 Plus"
    case .iPhone6s: return "iPhone 6s"
    case .iPhone6sPlus: return "iPhone 6s Plus"
    case .iPhone7: return "iPhone 7"
    case .iPhone7Plus: return "iPhone 7 Plus"
    case .iPhoneSE: return "iPhone SE"
    case .iPhone8: return "iPhone 8"
    case .iPhone8Plus: return "iPhone 8 Plus"
    case .iPhoneX: return "iPhone X"
    case .iPhoneXS: return "iPhone XS"
    case .iPhoneXSMax: return "iPhone XS Max"
    case .iPhoneXR: return "iPhone XR"
    case .iPhone11: return "iPhone 11"
    case .iPhone11Pro: return "iPhone 11 Pro"
    case .iPhone11ProMax: return "iPhone 11 Pro Max"
    case .iPhoneSE2: return "iPhone SE (2nd generation)"
    case .iPhone12: return "iPhone 12"
    case .iPhone12Mini: return "iPhone 12 mini"
    case .iPhone12Pro: return "iPhone 12 Pro"
    case .iPhone12ProMax: return "iPhone 12 Pro Max"
    case .iPhone13: return "iPhone 13"
    case .iPhone13Mini: return "iPhone 13 mini"
    case .iPhone13Pro: return "iPhone 13 Pro"
    case .iPhone13ProMax: return "iPhone 13 Pro Max"
    case .iPhoneSE3: return "iPhone SE (3rd generation)"
    case .iPhone14: return "iPhone 14"
    case .iPhone14Plus: return "iPhone 14 Plus"
    case .iPhone14Pro: return "iPhone 14 Pro"
    case .iPhone14ProMax: return "iPhone 14 Pro Max"
    case .iPhone15: return "iPhone 15"
    case .iPhone15Plus: return "iPhone 15 Plus"
    case .iPhone15Pro: return "iPhone 15 Pro"
    case .iPhone15ProMax: return "iPhone 15 Pro Max"
    case .simulator(let model): return "Simulator (\(model.safeDescription))"
    case .unknown(let identifier): return identifier
    }
  }
  
}

// MARK: Equatable
extension Device: Equatable {
  
  /// Compares two devices
  ///
  /// - parameter lhs: A device.
  /// - parameter rhs: Another device.
  ///
  /// - returns: `true` iff the underlying identifier is the same.
  public static func == (lhs: Device, rhs: Device) -> Bool {
    return lhs.description == rhs.description
  }
  
}

// MARK: Battery
@available(iOS 8.0, watchOS 4.0, *)
extension Device {
  /**
   This enum describes the state of the battery.
   
   - Full:      The device is plugged into power and the battery is 100% charged or the device is the iOS Simulator.
   - Charging:  The device is plugged into power and the battery is less than 100% charged.
   - Unplugged: The device is not plugged into power; the battery is discharging.
   */
  public enum BatteryState: CustomStringConvertible, Equatable {
    /// The device is plugged into power and the battery is 100% charged or the device is the iOS Simulator.
    case full
    /// The device is plugged into power and the battery is less than 100% charged.
    /// The associated value is in percent (0-100).
    case charging(Int)
    /// The device is not plugged into power; the battery is discharging.
    /// The associated value is in percent (0-100).
    case unplugged(Int)
    
    fileprivate init() {
      let wasBatteryMonitoringEnabled = UIDevice.current.isBatteryMonitoringEnabled
      UIDevice.current.isBatteryMonitoringEnabled = true
      let batteryLevel = Int(round(UIDevice.current.batteryLevel * 100)) // round() is actually not needed anymore since -[batteryLevel] seems to always return a two-digit precision number
      // but maybe that changes in the future.
      switch UIDevice.current.batteryState {
      case .charging: self = .charging(batteryLevel)
      case .full: self = .full
      case .unplugged: self = .unplugged(batteryLevel)
      case .unknown: self = .full // Should never happen since `batteryMonitoring` is enabled.
      @unknown default:
        self = .full // To cover any future additions for which DeviceKit might not have updated yet.
      }
      UIDevice.current.isBatteryMonitoringEnabled = wasBatteryMonitoringEnabled
    }
    
    /// The user enabled Low Power mode
    public var lowPowerMode: Bool {
      return ProcessInfo.processInfo.isLowPowerModeEnabled
    }
    
    /// Provides a textual representation of the battery state.
    /// Examples:
    /// ```
    /// Battery level: 90%, device is plugged in.
    /// Battery level: 100 % (Full), device is plugged in.
    /// Battery level: \(batteryLevel)%, device is unplugged.
    /// ```
    public var description: String {
      switch self {
      case .charging(let batteryLevel): return "Battery level: \(batteryLevel)%, device is plugged in."
      case .full: return "Battery level: 100 % (Full), device is plugged in."
      case .unplugged(let batteryLevel): return "Battery level: \(batteryLevel)%, device is unplugged."
      }
    }
    
  }
  
  /// The state of the battery
  public var batteryState: BatteryState? {
    guard isCurrent else { return nil }
    return BatteryState()
  }
  
  /// Battery level ranges from 0 (fully discharged) to 100 (100% charged).
  public var batteryLevel: Int? {
    guard isCurrent else { return nil }
    switch BatteryState() {
    case .charging(let value): return value
    case .full: return 100
    case .unplugged(let value): return value
    }
  }
  
}

// MARK: Device.Batterystate: Comparable
@available(iOS 8.0, watchOS 4.0, *)
extension Device.BatteryState: Comparable {
  /// Tells if two battery states are equal.
  ///
  /// - parameter lhs: A battery state.
  /// - parameter rhs: Another battery state.
  ///
  /// - returns: `true` iff they are equal, otherwise `false`
  public static func == (lhs: Device.BatteryState, rhs: Device.BatteryState) -> Bool {
    return lhs.description == rhs.description
  }
  
  /// Compares two battery states.
  ///
  /// - parameter lhs: A battery state.
  /// - parameter rhs: Another battery state.
  ///
  /// - returns: `true` if rhs is `.Full`, `false` when lhs is `.Full` otherwise their battery level is compared.
  public static func < (lhs: Device.BatteryState, rhs: Device.BatteryState) -> Bool {
    switch (lhs, rhs) {
    case (.full, _): return false // return false (even if both are `.Full` -> they are equal)
    case (_, .full): return true // lhs is *not* `.Full`, rhs is
    case let (.charging(lhsLevel), .charging(rhsLevel)): return lhsLevel < rhsLevel
    case let (.charging(lhsLevel), .unplugged(rhsLevel)): return lhsLevel < rhsLevel
    case let (.unplugged(lhsLevel), .charging(rhsLevel)): return lhsLevel < rhsLevel
    case let (.unplugged(lhsLevel), .unplugged(rhsLevel)): return lhsLevel < rhsLevel
    default: return false // compiler won't compile without it, though it cannot happen
    }
  }
}

extension Device {
  // MARK: Orientation
  /**
   This enum describes the state of the orientation.
   - Landscape: The device is in Landscape Orientation
   - Portrait:  The device is in Portrait Orientation
   - Unknown:   The device orientation is unknown.
   */
  public enum Orientation {
    case landscape
    case portrait
    case unknown
  }
  
  public var orientation: Orientation {
    if UIDevice.current.orientation.isLandscape {
      return .landscape
    } else if UIDevice.current.orientation.isPortrait {
      return .portrait
    } else {
      return .unknown
    }
  }
}

// MARK: DiskSpace
extension Device {
  
  /// Return the root url
  ///
  /// - returns: the NSHomeDirectory() url
  private static let rootURL = URL(fileURLWithPath: NSHomeDirectory())
  
  /// The volume’s total capacity in bytes.
  public static var volumeTotalCapacity: Int? {
    return (try? Device.rootURL.resourceValues(forKeys: [.volumeTotalCapacityKey]))?.volumeTotalCapacity
  }
  
  /// The volume’s available capacity in bytes.
  public static var volumeAvailableCapacity: Int? {
    return (try? rootURL.resourceValues(forKeys: [.volumeAvailableCapacityKey]))?.volumeAvailableCapacity
  }
  
  /// The volume’s available capacity in bytes for storing important resources.
  @available(iOS 11.0, *)
  public static var volumeAvailableCapacityForImportantUsage: Int64? {
    return (try? rootURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey]))?.volumeAvailableCapacityForImportantUsage
  }
  
  /// The volume’s available capacity in bytes for storing nonessential resources.
  @available(iOS 11.0, *)
  public static var volumeAvailableCapacityForOpportunisticUsage: Int64? { //swiftlint:disable:this identifier_name
    return (try? rootURL.resourceValues(forKeys: [.volumeAvailableCapacityForOpportunisticUsageKey]))?.volumeAvailableCapacityForOpportunisticUsage
  }
  
  /// All volumes capacity information in bytes.
  @available(iOS 11.0, *)
  public static var volumes: [URLResourceKey: Int64]? {
    do {
      let values = try rootURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey,
                                                        .volumeAvailableCapacityKey,
                                                        .volumeAvailableCapacityForOpportunisticUsageKey,
                                                        .volumeTotalCapacityKey
      ])
      return values.allValues.mapValues {
        if let int = $0 as? Int64 {
          return int
        }
        if let int = $0 as? Int {
          return Int64(int)
        }
        return 0
      }
    } catch {
      return nil
    }
  }
}

// MARK: Cameras
extension Device {
  
  public enum CameraType {
    @available(*, deprecated, renamed: "wide")
    case normal
    
    case wide
    case telephoto
    case ultraWide
  }
  
  /// Returns an array of the types of cameras the device has
  public var cameras: [CameraType] {
    switch self {
    case .iPodTouch5: return [.wide]
    case .iPodTouch6: return [.wide]
    case .iPodTouch7: return [.wide]
    case .iPhone4: return [.wide]
    case .iPhone4s: return [.wide]
    case .iPhone5: return [.wide]
    case .iPhone5c: return [.wide]
    case .iPhone5s: return [.wide]
    case .iPhone6: return [.wide]
    case .iPhone6Plus: return [.wide]
    case .iPhone6s: return [.wide]
    case .iPhone6sPlus: return [.wide]
    case .iPhone7: return [.wide]
    case .iPhoneSE: return [.wide]
    case .iPhone8: return [.wide]
    case .iPhoneXR: return [.wide]
    case .iPhoneSE2: return [.wide]
    case .iPhoneSE3: return [.wide]
    case .iPhone7Plus: return [.wide, .telephoto]
    case .iPhone8Plus: return [.wide, .telephoto]
    case .iPhoneX: return [.wide, .telephoto]
    case .iPhoneXS: return [.wide, .telephoto]
    case .iPhoneXSMax: return [.wide, .telephoto]
    case .iPhone11: return [.wide, .ultraWide]
    case .iPhone12: return [.wide, .ultraWide]
    case .iPhone12Mini: return [.wide, .ultraWide]
    case .iPhone13: return [.wide, .ultraWide]
    case .iPhone13Mini: return [.wide, .ultraWide]
    case .iPhone14: return [.wide, .ultraWide]
    case .iPhone14Plus: return [.wide, .ultraWide]
    case .iPhone15: return [.wide, .ultraWide]
    case .iPhone15Plus: return [.wide, .ultraWide]
    case .iPhone11Pro: return [.wide, .telephoto, .ultraWide]
    case .iPhone11ProMax: return [.wide, .telephoto, .ultraWide]
    case .iPhone12Pro: return [.wide, .telephoto, .ultraWide]
    case .iPhone12ProMax: return [.wide, .telephoto, .ultraWide]
    case .iPhone13Pro: return [.wide, .telephoto, .ultraWide]
    case .iPhone13ProMax: return [.wide, .telephoto, .ultraWide]
    case .iPhone14Pro: return [.wide, .telephoto, .ultraWide]
    case .iPhone14ProMax: return [.wide, .telephoto, .ultraWide]
    case .iPhone15Pro: return [.wide, .telephoto, .ultraWide]
    case .iPhone15ProMax: return [.wide, .telephoto, .ultraWide]
    default: return []
    }
  }
  
  /// All devices that feature a camera
  public static var allDevicesWithCamera: [Device] {
    return [.iPodTouch5, .iPodTouch6, .iPodTouch7, .iPhone4, .iPhone4s, .iPhone5, .iPhone5c, .iPhone5s, .iPhone6, .iPhone6Plus, .iPhone6s, .iPhone6sPlus, .iPhone7, .iPhone7Plus, .iPhoneSE, .iPhone8, .iPhone8Plus, .iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhone11Pro, .iPhone11ProMax, .iPhoneSE2, .iPhone12, .iPhone12Mini, .iPhone12Pro, .iPhone12ProMax, .iPhone13, .iPhone13Mini, .iPhone13Pro, .iPhone13ProMax, .iPhoneSE3, .iPhone14, .iPhone14Plus, .iPhone14Pro, .iPhone14ProMax, .iPhone15, .iPhone15Plus, .iPhone15Pro, .iPhone15ProMax]
  }
  
  /// All devices that feature a normal camera
  @available(*, deprecated, renamed: "allDevicesWithWideCamera")
  public static var allDevicesWithNormalCamera: [Device] {
    return Device.allDevicesWithWideCamera
  }
  
  /// All devices that feature a wide camera
  public static var allDevicesWithWideCamera: [Device] {
    return [.iPodTouch5, .iPodTouch6, .iPodTouch7, .iPhone4, .iPhone4s, .iPhone5, .iPhone5c, .iPhone5s, .iPhone6, .iPhone6Plus, .iPhone6s, .iPhone6sPlus, .iPhone7, .iPhone7Plus, .iPhoneSE, .iPhone8, .iPhone8Plus, .iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhone11Pro, .iPhone11ProMax, .iPhoneSE2, .iPhone12, .iPhone12Mini, .iPhone12Pro, .iPhone12ProMax, .iPhone13, .iPhone13Mini, .iPhone13Pro, .iPhone13ProMax, .iPhoneSE3, .iPhone14, .iPhone14Plus, .iPhone14Pro, .iPhone14ProMax, .iPhone15, .iPhone15Plus, .iPhone15Pro, .iPhone15ProMax]
  }
  
  /// All devices that feature a telephoto camera
  public static var allDevicesWithTelephotoCamera: [Device] {
    return [.iPhone7Plus, .iPhone8Plus, .iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhone11Pro, .iPhone11ProMax, .iPhone12Pro, .iPhone12ProMax, .iPhone13Pro, .iPhone13ProMax, .iPhone14Pro, .iPhone14ProMax, .iPhone15Pro, .iPhone15ProMax]
  }
  
  /// All devices that feature an ultra wide camera
  public static var allDevicesWithUltraWideCamera: [Device] {
    return [.iPhone11, .iPhone11Pro, .iPhone11ProMax, .iPhone12, .iPhone12Mini, .iPhone12Pro, .iPhone12ProMax, .iPhone13, .iPhone13Mini, .iPhone13Pro, .iPhone13ProMax, .iPhone14, .iPhone14Plus, .iPhone14Pro, .iPhone14ProMax, .iPhone15, .iPhone15Plus, .iPhone15Pro, .iPhone15ProMax]
  }
  
  /// Returns whether or not the current device has a camera
  public var hasCamera: Bool {
    return !self.cameras.isEmpty
  }
  
  /// Returns whether or not the current device has a normal camera
  @available(*, deprecated, renamed: "hasWideCamera")
  public var hasNormalCamera: Bool {
    return self.hasWideCamera
  }
  
  /// Returns whether or not the current device has a wide camera
  public var hasWideCamera: Bool {
    return self.cameras.contains(.wide)
  }
  
  /// Returns whether or not the current device has a telephoto camera
  public var hasTelephotoCamera: Bool {
    return self.cameras.contains(.telephoto)
  }
  
  /// Returns whether or not the current device has an ultra wide camera
  public var hasUltraWideCamera: Bool {
    return self.cameras.contains(.ultraWide)
  }
}

// MARK: ThermalState
@available(iOS 11.0, watchOS 4.0, macOS 10.10.3, tvOS 11.0, *)
extension Device {
  /// The thermal state of the system.
  public enum ThermalState {
    /// The thermal state is within normal limits.
    case nominal
    /// The thermal state is slightly elevated.
    case fair
    /// The thermal state is high.
    case serious
    /// The thermal state is significantly impacting the performance of the system and the device needs to cool down.
    case critical
  }
  
  /// Returns the current thermal state of the system (or nil if not called against the `current` device)
  public var thermalState: ThermalState? {
    guard isCurrent else { return nil }
    switch ProcessInfo().thermalState {
    case .nominal:
      return .nominal
    case .fair:
      return .fair
    case .serious:
      return .serious
    case .critical:
      return .critical
    @unknown default:
      return .nominal
    }
  }
}

// MARK: CPU

extension Device {
  
  public enum CPU: Comparable {
    case a4
    case a5
    case a5X
    case a6
    case a6X
    case a7
    case a8
    case a8X
    case a9
    case a9X
    case a10Fusion
    case a10XFusion
    case a11Bionic
    case a12Bionic
    case a12XBionic
    case a12ZBionic
    case a13Bionic
    case a14Bionic
    case a15Bionic
    case a16Bionic
    case a17Pro
    case m1
    case m2
    case m3
    case m4
    case unknown
  }
  
  /// Returns the cpu (SoC) that the device uses
  public var cpu: CPU {
    switch self {
    case .iPodTouch5: return .a5
    case .iPodTouch6: return .a8
    case .iPodTouch7: return .a10Fusion
    case .iPhone4: return .a4
    case .iPhone4s: return .a5
    case .iPhone5: return .a6
    case .iPhone5c: return .a6
    case .iPhone5s: return .a7
    case .iPhone6: return .a8
    case .iPhone6Plus: return .a8
    case .iPhone6s: return .a9
    case .iPhone6sPlus: return .a9
    case .iPhone7: return .a10Fusion
    case .iPhone7Plus: return .a10Fusion
    case .iPhoneSE: return .a9
    case .iPhone8: return .a11Bionic
    case .iPhone8Plus: return .a11Bionic
    case .iPhoneX: return .a11Bionic
    case .iPhoneXS: return .a12Bionic
    case .iPhoneXSMax: return .a12Bionic
    case .iPhoneXR: return .a12Bionic
    case .iPhone11: return .a13Bionic
    case .iPhone11Pro: return .a13Bionic
    case .iPhone11ProMax: return .a13Bionic
    case .iPhoneSE2: return .a13Bionic
    case .iPhone12: return .a14Bionic
    case .iPhone12Mini: return .a14Bionic
    case .iPhone12Pro: return .a14Bionic
    case .iPhone12ProMax: return .a14Bionic
    case .iPhone13: return .a15Bionic
    case .iPhone13Mini: return .a15Bionic
    case .iPhone13Pro: return .a15Bionic
    case .iPhone13ProMax: return .a15Bionic
    case .iPhoneSE3: return .a15Bionic
    case .iPhone14: return .a15Bionic
    case .iPhone14Plus: return .a15Bionic
    case .iPhone14Pro: return .a16Bionic
    case .iPhone14ProMax: return .a16Bionic
    case .iPhone15: return .a16Bionic
    case .iPhone15Plus: return .a16Bionic
    case .iPhone15Pro: return .a17Pro
    case .iPhone15ProMax: return .a17Pro
    case .simulator(let model): return model.cpu
    case .unknown: return .unknown
    }
  }
}

extension Device.CPU: CustomStringConvertible {
  
  /// A textual representation of the device.
  public var description: String {
    switch self {
    case .a4: return "A4"
    case .a5: return "A5"
    case .a5X: return "A5X"
    case .a6: return "A6"
    case .a6X: return "A6X"
    case .a7: return "A7"
    case .a8: return "A8"
    case .a8X: return "A8X"
    case .a9: return "A9"
    case .a9X: return "A9X"
    case .a10Fusion: return "A10 Fusion"
    case .a10XFusion: return "A10X Fusion"
    case .a11Bionic: return "A11 Bionic"
    case .a12Bionic: return "A12 Bionic"
    case .a12XBionic: return "A12X Bionic"
    case .a12ZBionic: return "A12Z Bionic"
    case .a13Bionic: return "A13 Bionic"
    case .a14Bionic: return "A14 Bionic"
    case .a15Bionic: return "A15 Bionic"
    case .a16Bionic: return "A16 Bionic"
    case .a17Pro: return "A17 Pro"
    case .m1: return "M1"
    case .m2: return "M2"
    case .m3: return "M3"
    case .m4: return "M4"
    case .unknown: return "unknown"
    }
  }
}
