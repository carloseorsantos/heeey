import XCTest
@testable import Heeey

final class HeeeyTests: XCTestCase {
    func testTickerMessageHeadlineFormatting() {
        let msg = TickerMessage(
            text: "Bora codar!",
            sender: "Carlos",
            emoji: "🚀",
            theme: .ledGreen
        )

        XCTAssertEqual(msg.formattedHeadline, "🚀 [Carlos]: Bora codar!")
    }

    func testTickerMessageWithoutSenderOrEmoji() {
        let msg = TickerMessage(
            text: "Apenas uma mensagem",
            sender: nil,
            emoji: nil,
            theme: .cyberpunkNeon
        )

        XCTAssertEqual(msg.formattedHeadline, "Apenas uma mensagem")
    }

    func testTickerMessageJSONSerialization() throws {
        let original = TickerMessage(
            text: "Hello World",
            sender: "Alice",
            emoji: "👋",
            theme: .liquidGlass
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(original)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(TickerMessage.self, from: data)

        XCTAssertEqual(original.id, decoded.id)
        XCTAssertEqual(original.text, decoded.text)
        XCTAssertEqual(original.sender, decoded.sender)
        XCTAssertEqual(original.emoji, decoded.emoji)
        XCTAssertEqual(original.theme, decoded.theme)
    }

    func testFocusDurationTimeIntervals() {
        XCTAssertEqual(FocusDuration.fifteenMinutes.timeInterval, 15 * 60)
        XCTAssertEqual(FocusDuration.thirtyMinutes.timeInterval, 30 * 60)
        XCTAssertEqual(FocusDuration.oneHour.timeInterval, 60 * 60)
        XCTAssertNil(FocusDuration.indefinite.timeInterval)
    }

    @MainActor
    func testFocusManagerActivation() {
        let focus = FocusManager.shared
        focus.startFocus(duration: .thirtyMinutes)

        XCTAssertTrue(focus.isFocusActive)
        XCTAssertEqual(focus.activeDuration, .thirtyMinutes)
        XCTAssertEqual(focus.remainingSeconds, 30 * 60)

        focus.stopFocus()
        XCTAssertFalse(focus.isFocusActive)
        XCTAssertNil(focus.activeDuration)
        XCTAssertEqual(focus.remainingSeconds, 0)
    }
}
