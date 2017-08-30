<p align="center">
  <img align="right" src="https://raw.githubusercontent.com/mrousavy/SwiftySockets/master/Images/swift_icon.png" height="120" />
  <h1 align="left">SwiftySockets</h3>
  <p align="left">Fancy sockets for servers and clients for swift</p>
  <p align="left">
    <a href="http://nuget.org/packages/Morph/"><img src="https://img.shields.io/badge/nuget-Morph-blue.svg" alt="Morph on NuGet"></a>
    <a href="https://ci.appveyor.com/project/mrousavy/morph"><img src="https://ci.appveyor.com/api/projects/status/k6dd0rtskfjxrw4o?svg=true" alt="Morph build status"></a>
  </p>
</p>

## Install

CocaPods:
```
TODO
```

Swift Package Manager:
```
TODO
```

## Usage

Open a new Socket:
```swift
//TODO
var client = SwiftySocket(...)
```

Writing Data:
```swift
// Write String:
client.write(data: "Hello SwiftySockets!")

// Write Data:
var data = Data()
client.write(data: data)

// Write NSMutableData:
var mdata = NSMutableData()
client.write(data: mdata)
```

Reading Data:
```swift
// Read String:
var text = try client.readString()

// Read Data:
var data = Data()
client.read(data: &data)

// Read NSMutableData:
var mdata = NSMutableData()
client.read(data: &mdata)
```
