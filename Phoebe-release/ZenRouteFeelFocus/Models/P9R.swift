import Foundation

enum K7M: String, Codable {
    case v1
    case v2
    case v3
    case v4
}

struct P9R: Codable {
    var m1: K7M
    var s1: String?
    var s2: String?
    var s3: String?
    var s4: String?
    var d1: Date?
    var b1: Bool
    var b2: Bool
    var n1: Int
    
    static let e5 = P9R(
        m1: .v1,
        s1: nil,
        s2: nil,
        s3: nil,
        s4: nil,
        d1: nil,
        b1: false,
        b2: false,
        n1: 0
    )
}
