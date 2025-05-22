import Foundation
import CoreBluetooth
import SwiftUI

/// Basic Bluetooth manager that listens for readings from the Tramex ME5 meter.
/// Service/characteristic UUIDs are placeholders and should be updated to match
/// the device specifications.
final class BluetoothManager: NSObject, ObservableObject {
    static let shared = BluetoothManager()

    @Published var lastReading: Double?

    private var central: CBCentralManager!
    private var peripheral: CBPeripheral?

    private let serviceUUID = CBUUID(string: "FFF0")
    private let characteristicUUID = CBUUID(string: "FFF1")

    override init() {
        super.init()
        central = CBCentralManager(delegate: self, queue: nil)
    }
}

extension BluetoothManager: CBCentralManagerDelegate, CBPeripheralDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            central.scanForPeripherals(withServices: [serviceUUID])
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.peripheral = peripheral
        central.stopScan()
        peripheral.delegate = self
        central.connect(peripheral)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices([serviceUUID])
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let service = peripheral.services?.first(where: { $0.uuid == serviceUUID }) else { return }
        peripheral.discoverCharacteristics([characteristicUUID], for: service)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let char = service.characteristics?.first(where: { $0.uuid == characteristicUUID }) else { return }
        peripheral.setNotifyValue(true, for: char)
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard characteristic.uuid == characteristicUUID, let data = characteristic.value else { return }
        let value = parseValue(from: data)
        DispatchQueue.main.async { self.lastReading = value }
    }

    private func parseValue(from data: Data) -> Double {
        // Placeholder parsing logic – assumes single byte percentage
        return Double(data.first ?? 0)
    }
}
