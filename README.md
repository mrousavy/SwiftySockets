<p align="center">
  <img align="right" src="https://github.com/mrousavy/SwiftySockets/raw/master/Images/swift_icon.png" height="120" />
  <h1 align="left">SwiftySockets</h3>
  <p align="left">Fancy sockets for servers and clients for swift</p>
  <p align="left">
    <a href="https://ci.appveyor.com/project/mrousavy/SwiftySockets"><img src="https://ci.appveyor.com/api/projects/status/_________?svg=true" alt="SwiftySockets AppVeyor build status"></a>
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
