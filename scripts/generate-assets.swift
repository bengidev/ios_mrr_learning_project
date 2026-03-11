import AppKit
import Foundation

struct Palette {
    let accent = NSColor(calibratedRed: 0.11, green: 0.39, blue: 0.96, alpha: 1.0)
    let canvas = NSColor(calibratedRed: 0.97, green: 0.98, blue: 1.0, alpha: 1.0)
    let card = NSColor(calibratedRed: 0.90, green: 0.94, blue: 1.0, alpha: 1.0)
    let primaryText = NSColor(calibratedRed: 0.10, green: 0.12, blue: 0.18, alpha: 1.0)
    let secondaryText = NSColor(calibratedRed: 0.36, green: 0.40, blue: 0.48, alpha: 1.0)
    let success = NSColor(calibratedRed: 0.16, green: 0.70, blue: 0.48, alpha: 1.0)
}

let palette = Palette()
let fileManager = FileManager.default
let rootURL = URL(fileURLWithPath: fileManager.currentDirectoryPath, isDirectory: true)
let assetsURL = rootURL.appendingPathComponent("MRR Project/Resources/Assets.xcassets", isDirectory: true)

func ensureDirectory(_ url: URL) throws {
    try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
}

func writeJSON(_ object: Any, to url: URL) throws {
    let data = try JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted, .sortedKeys])
    try data.write(to: url)
}

func colorContents(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> [String: Any] {
    func component(_ value: CGFloat) -> String {
        String(format: "%.3f", value)
    }

    return [
        "colors": [
            [
                "color": [
                    "color-space": "srgb",
                    "components": [
                        "alpha": component(alpha),
                        "blue": component(blue),
                        "green": component(green),
                        "red": component(red),
                    ],
                ],
                "idiom": "universal",
            ],
        ],
        "info": [
            "author": "xcode",
            "version": 1,
        ],
    ]
}

func savePNG(to url: URL, size: CGSize, opaque: Bool = false, draw: (NSRect) -> Void) throws {
    let image = NSImage(size: size)
    image.lockFocus()
    let rect = NSRect(origin: .zero, size: size)
    if !opaque {
        NSColor.clear.setFill()
        rect.fill()
    }
    draw(rect)
    image.unlockFocus()

    guard
        let tiffData = image.tiffRepresentation,
        let bitmap = NSBitmapImageRep(data: tiffData),
        let pngData = bitmap.representation(using: .png, properties: [:])
    else {
        throw NSError(domain: "GenerateAssets", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode PNG at \(url.path)"])
    }

    try pngData.write(to: url)
}

func roundedRect(_ rect: NSRect, radius: CGFloat, color: NSColor) {
    color.setFill()
    NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius).fill()
}

func line(_ rect: NSRect, radius: CGFloat, color: NSColor) {
    roundedRect(rect, radius: radius, color: color)
}

func drawCheckmark(in rect: NSRect, color: NSColor, lineWidth: CGFloat) {
    let path = NSBezierPath()
    path.lineWidth = lineWidth
    path.lineCapStyle = .round
    path.lineJoinStyle = .round
    path.move(to: NSPoint(x: rect.minX + rect.width * 0.18, y: rect.midY))
    path.line(to: NSPoint(x: rect.minX + rect.width * 0.42, y: rect.minY + rect.height * 0.24))
    path.line(to: NSPoint(x: rect.maxX - rect.width * 0.14, y: rect.maxY - rect.height * 0.22))
    color.setStroke()
    path.stroke()
}

func drawAppIcon(in rect: NSRect) {
    roundedRect(rect, radius: rect.width * 0.22, color: palette.accent)

    let panelRect = rect.insetBy(dx: rect.width * 0.16, dy: rect.height * 0.16)
    roundedRect(panelRect, radius: rect.width * 0.09, color: NSColor.white)

    let topLine = NSRect(x: panelRect.minX + rect.width * 0.11,
                         y: panelRect.maxY - rect.height * 0.23,
                         width: panelRect.width * 0.54,
                         height: rect.height * 0.055)
    line(topLine, radius: topLine.height / 2.0, color: palette.primaryText)

    let secondLine = NSRect(x: topLine.minX,
                            y: topLine.minY - rect.height * 0.08,
                            width: panelRect.width * 0.42,
                            height: rect.height * 0.04)
    line(secondLine, radius: secondLine.height / 2.0, color: palette.secondaryText)

    let cardWidth = panelRect.width * 0.22
    let cardHeight = panelRect.height * 0.24
    let cardY = panelRect.minY + panelRect.height * 0.22

    let firstCard = NSRect(x: panelRect.minX + panelRect.width * 0.10, y: cardY, width: cardWidth, height: cardHeight)
    let secondCard = NSRect(x: firstCard.maxX + panelRect.width * 0.06, y: cardY, width: cardWidth, height: cardHeight)
    let thirdCard = NSRect(x: secondCard.maxX + panelRect.width * 0.06, y: cardY, width: cardWidth, height: cardHeight)

    roundedRect(firstCard, radius: rect.width * 0.04, color: palette.card)
    roundedRect(secondCard, radius: rect.width * 0.04, color: palette.canvas)
    roundedRect(thirdCard, radius: rect.width * 0.04, color: palette.card)

    let badgeSize = rect.width * 0.19
    let badgeRect = NSRect(x: panelRect.maxX - badgeSize - rect.width * 0.08,
                           y: panelRect.minY + rect.height * 0.10,
                           width: badgeSize,
                           height: badgeSize)
    roundedRect(badgeRect, radius: badgeSize / 2.0, color: palette.success)
    drawCheckmark(in: badgeRect.insetBy(dx: badgeSize * 0.20, dy: badgeSize * 0.20),
                  color: NSColor.white,
                  lineWidth: badgeSize * 0.12)
}

func drawIllustration(in rect: NSRect) {
    let backdropRect = NSRect(x: rect.minX + rect.width * 0.12,
                              y: rect.minY + rect.height * 0.18,
                              width: rect.width * 0.76,
                              height: rect.height * 0.76)
    roundedRect(backdropRect, radius: rect.width * 0.18, color: palette.card)

    let panelRect = NSRect(x: rect.minX + rect.width * 0.18,
                           y: rect.minY + rect.height * 0.24,
                           width: rect.width * 0.64,
                           height: rect.height * 0.52)
    roundedRect(panelRect, radius: rect.width * 0.08, color: NSColor.white)

    let accentBubble = NSRect(x: panelRect.minX + rect.width * 0.06,
                              y: panelRect.maxY - rect.height * 0.12,
                              width: rect.width * 0.16,
                              height: rect.height * 0.16)
    roundedRect(accentBubble, radius: accentBubble.width / 2.0, color: palette.accent)

    let titleLine = NSRect(x: panelRect.minX + rect.width * 0.18,
                           y: panelRect.maxY - rect.height * 0.12,
                           width: rect.width * 0.30,
                           height: rect.height * 0.04)
    line(titleLine, radius: titleLine.height / 2.0, color: palette.primaryText)

    let subtitleLine = NSRect(x: titleLine.minX,
                              y: titleLine.minY - rect.height * 0.07,
                              width: rect.width * 0.24,
                              height: rect.height * 0.03)
    line(subtitleLine, radius: subtitleLine.height / 2.0, color: palette.secondaryText)

    let checklistBox = NSRect(x: panelRect.minX + rect.width * 0.08,
                              y: panelRect.minY + rect.height * 0.17,
                              width: rect.width * 0.14,
                              height: rect.width * 0.14)
    roundedRect(checklistBox, radius: rect.width * 0.03, color: palette.canvas)
    drawCheckmark(in: checklistBox.insetBy(dx: checklistBox.width * 0.20, dy: checklistBox.height * 0.20),
                  color: palette.success,
                  lineWidth: checklistBox.width * 0.10)

    let detailLineTop = NSRect(x: checklistBox.maxX + rect.width * 0.05,
                               y: checklistBox.maxY - rect.height * 0.04,
                               width: rect.width * 0.28,
                               height: rect.height * 0.03)
    let detailLineBottom = NSRect(x: detailLineTop.minX,
                                  y: detailLineTop.minY - rect.height * 0.06,
                                  width: rect.width * 0.20,
                                  height: rect.height * 0.025)
    line(detailLineTop, radius: detailLineTop.height / 2.0, color: palette.primaryText)
    line(detailLineBottom, radius: detailLineBottom.height / 2.0, color: palette.secondaryText)
}

func createRootContents() throws {
    try ensureDirectory(assetsURL)
    try writeJSON(
        [
            "info": [
                "author": "xcode",
                "version": 1,
            ],
        ],
        to: assetsURL.appendingPathComponent("Contents.json")
    )
}

func createColorSet(name: String, color: NSColor) throws {
    let colorURL = assetsURL.appendingPathComponent("\(name).colorset", isDirectory: true)
    try ensureDirectory(colorURL)
    try writeJSON(
        colorContents(red: color.redComponent, green: color.greenComponent, blue: color.blueComponent, alpha: color.alphaComponent),
        to: colorURL.appendingPathComponent("Contents.json")
    )
}

func createIllustration() throws {
    let imageSetURL = assetsURL.appendingPathComponent("OnboardingIllustration.imageset", isDirectory: true)
    try ensureDirectory(imageSetURL)

    let filename = "onboarding-illustration.png"
    try savePNG(to: imageSetURL.appendingPathComponent(filename), size: CGSize(width: 560.0, height: 560.0)) { rect in
        drawIllustration(in: rect)
    }

    try writeJSON(
        [
            "images": [
                [
                    "filename": filename,
                    "idiom": "universal",
                    "scale": "1x",
                ],
            ],
            "info": [
                "author": "xcode",
                "version": 1,
            ],
            "properties": [
                "preserves-vector-representation": false,
            ],
        ],
        to: imageSetURL.appendingPathComponent("Contents.json")
    )
}

func createAppIconSet() throws {
    let appIconURL = assetsURL.appendingPathComponent("AppIcon.appiconset", isDirectory: true)
    try ensureDirectory(appIconURL)

    let iconSpecs: [[String: String]] = [
        ["filename": "app-icon-20.png", "idiom": "iphone", "scale": "2x", "size": "20x20"],
        ["filename": "app-icon-20@3x.png", "idiom": "iphone", "scale": "3x", "size": "20x20"],
        ["filename": "app-icon-29@2x.png", "idiom": "iphone", "scale": "2x", "size": "29x29"],
        ["filename": "app-icon-29@3x.png", "idiom": "iphone", "scale": "3x", "size": "29x29"],
        ["filename": "app-icon-40@2x.png", "idiom": "iphone", "scale": "2x", "size": "40x40"],
        ["filename": "app-icon-40@3x.png", "idiom": "iphone", "scale": "3x", "size": "40x40"],
        ["filename": "app-icon-60@2x.png", "idiom": "iphone", "scale": "2x", "size": "60x60"],
        ["filename": "app-icon-60@3x.png", "idiom": "iphone", "scale": "3x", "size": "60x60"],
        ["filename": "app-icon-20-ipad.png", "idiom": "ipad", "scale": "1x", "size": "20x20"],
        ["filename": "app-icon-20@2x-ipad.png", "idiom": "ipad", "scale": "2x", "size": "20x20"],
        ["filename": "app-icon-29-ipad.png", "idiom": "ipad", "scale": "1x", "size": "29x29"],
        ["filename": "app-icon-29@2x-ipad.png", "idiom": "ipad", "scale": "2x", "size": "29x29"],
        ["filename": "app-icon-40-ipad.png", "idiom": "ipad", "scale": "1x", "size": "40x40"],
        ["filename": "app-icon-40@2x-ipad.png", "idiom": "ipad", "scale": "2x", "size": "40x40"],
        ["filename": "app-icon-76-ipad.png", "idiom": "ipad", "scale": "1x", "size": "76x76"],
        ["filename": "app-icon-76@2x-ipad.png", "idiom": "ipad", "scale": "2x", "size": "76x76"],
        ["filename": "app-icon-83.5@2x-ipad.png", "idiom": "ipad", "scale": "2x", "size": "83.5x83.5"],
        ["filename": "app-icon-1024.png", "idiom": "ios-marketing", "scale": "1x", "size": "1024x1024"],
    ]

    for spec in iconSpecs {
        guard
            let sizeText = spec["size"],
            let scaleText = spec["scale"],
            let filename = spec["filename"]
        else {
            continue
        }

        let pointSize = sizeText
            .split(separator: "x")
            .first
            .flatMap { Double($0) } ?? 0.0
        let scaleValue = Double(scaleText.replacingOccurrences(of: "x", with: "")) ?? 1.0
        let pixelSize = CGFloat(pointSize * scaleValue)

        try savePNG(to: appIconURL.appendingPathComponent(filename), size: CGSize(width: pixelSize, height: pixelSize), opaque: true) { rect in
            drawAppIcon(in: rect)
        }
    }

    try writeJSON(
        [
            "images": iconSpecs,
            "info": [
                "author": "xcode",
                "version": 1,
            ],
        ],
        to: appIconURL.appendingPathComponent("Contents.json")
    )
}

do {
    try createRootContents()
    try createColorSet(name: "AccentColor", color: palette.accent)
    try createColorSet(name: "CanvasBackground", color: palette.canvas)
    try createColorSet(name: "CardBackground", color: palette.card)
    try createColorSet(name: "PrimaryAction", color: palette.accent)
    try createColorSet(name: "PrimaryText", color: palette.primaryText)
    try createColorSet(name: "SecondaryText", color: palette.secondaryText)
    try createIllustration()
    try createAppIconSet()
} catch {
    fputs("error: \(error.localizedDescription)\n", stderr)
    exit(1)
}
