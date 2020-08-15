// This file was automatically generated and should not be edited.

enum Secrets {
    private static let salt: [UInt8] = [
        0xe7, 0xf0, 0x9b, 0xf7, 0x1c, 0x1f, 0x6e, 0x6a,
        0x95, 0x1e, 0xeb, 0xad, 0x04, 0xcb, 0x0a, 0x62,
        0x64, 0xa4, 0xca, 0x89, 0xe1, 0x8f, 0x2c, 0x82,
        0xd2, 0x48, 0x47, 0x23, 0xa7, 0x10, 0x96, 0xfa,
        0x2a, 0x50, 0xa5, 0x06, 0xd7, 0x58, 0xe6, 0xf5,
        0x14, 0xee, 0xa9, 0xdc, 0x19, 0x36, 0x85, 0x9a,
        0x8a, 0x2b, 0xb9, 0xeb, 0x65, 0x7f, 0x9f, 0x51,
        0xcf, 0x48, 0x4a, 0xc5, 0xcd, 0xfe, 0x11, 0x55,
    ]

    static var appCenterAppSecret: String {
        let encoded: [UInt8] = [
        ]

        return decode(encoded, cipher: salt)
    }

    static func decode(_ encoded: [UInt8], cipher: [UInt8]) -> String {
        String(decoding: encoded.enumerated().map { (offset, element) in
            element ^ cipher[offset % cipher.count]
        }, as: UTF8.self)
    }
}