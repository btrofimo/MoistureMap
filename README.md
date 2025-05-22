# MoistureMap Starter Code

This repository contains SwiftUI components for a simple moisture mapping app.
The code is not a standalone Xcode project. To run it on your iOS device:

1. Open **Xcode** and create a new **iOS App** project.
2. Delete the boilerplate Swift files that Xcode creates.
3. Drag the contents of `MoistureMapperStarter/` into your new project.
4. Add the provided `Info.plist` and `MoistureMapper.entitlements` files to the
   project if your build settings reference them.
5. Select a simulator or a connected device and build/run.

`BluetoothManager` includes placeholder UUIDs for the Tramex ME5 meter. Update
the service and characteristic UUIDs to match your hardware.
