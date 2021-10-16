`≈ german word for vinyl record`
# Schallplatte

Is a SwiftUI experiment for rendering vinyl records. Below you can view an example:
| Lightmode | Darkmode |
:------:|:------:
| ![lightmode](./example-light.png) | ![darkmode](./example-dark.png) |

Based on the `vinylColor`, other shades for a realistic appearance are automatically calculated. As a result, all colors should more or less automatically generate a nice record.

```swift
import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack {
            Schallplatte(
              vinylColor: Color(
                red: 0.49, green: 0, blue: 0, opacity: 1
              ), 
              imgUrl: "https://images-na.ssl-images-amazon.com/images/I/71GtacY5FQL._SL1400_.jpg",
              gradationIntensity: .strong, 
              showCenter: false
            )
        }
    }
}
```