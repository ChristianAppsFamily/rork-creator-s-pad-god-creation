import Foundation

nonisolated struct ScriptureVerse: Identifiable, Hashable, Sendable {
    let id: String
    let reference: String
    let text: String

    init(reference: String, text: String) {
        self.id = reference
        self.reference = reference
        self.text = text
    }

    static let allVerses: [ScriptureVerse] = [
        ScriptureVerse(reference: "GENESIS 1:1", text: "In the beginning God created the heavens and the earth."),
        ScriptureVerse(reference: "GENESIS 1:3", text: "And God said, Let there be light: and there was light."),
        ScriptureVerse(reference: "GENESIS 1:27", text: "So God created man in his own image."),
        ScriptureVerse(reference: "GENESIS 9:13", text: "I have set my rainbow in the clouds."),
        ScriptureVerse(reference: "PSALM 8:3", text: "When I consider your heavens, the work of your fingers."),
        ScriptureVerse(reference: "PSALM 19:1", text: "The heavens declare the glory of God."),
        ScriptureVerse(reference: "PSALM 23:1", text: "The Lord is my shepherd; I shall not want."),
        ScriptureVerse(reference: "PSALM 23:4", text: "Even though I walk through the darkest valley, I will fear no evil."),
        ScriptureVerse(reference: "PSALM 27:1", text: "The Lord is my light and my salvation."),
        ScriptureVerse(reference: "PSALM 46:10", text: "Be still, and know that I am God."),
        ScriptureVerse(reference: "PSALM 100:3", text: "Know that the Lord is God. It is he who made us."),
        ScriptureVerse(reference: "PSALM 104:24", text: "How many are your works, Lord! In wisdom you made them all."),
        ScriptureVerse(reference: "PSALM 119:105", text: "Your word is a lamp for my feet, a light on my path."),
        ScriptureVerse(reference: "PSALM 136:1", text: "Give thanks to the Lord, for he is good."),
        ScriptureVerse(reference: "PSALM 139:14", text: "I praise you because I am fearfully and wonderfully made."),
        ScriptureVerse(reference: "PSALM 145:9", text: "The Lord is good to all; he has compassion on all he has made."),
        ScriptureVerse(reference: "PSALM 150:6", text: "Let everything that has breath praise the Lord."),
        ScriptureVerse(reference: "PROVERBS 3:5", text: "Trust in the Lord with all your heart."),
        ScriptureVerse(reference: "PROVERBS 22:6", text: "Start children off on the way they should go."),
        ScriptureVerse(reference: "ISAIAH 40:31", text: "But those who hope in the Lord will renew their strength."),
        ScriptureVerse(reference: "ISAIAH 41:10", text: "So do not fear, for I am with you."),
        ScriptureVerse(reference: "ISAIAH 43:1", text: "Fear not, for I have redeemed you; I have called you by name."),
        ScriptureVerse(reference: "JEREMIAH 29:11", text: "For I know the plans I have for you, declares the Lord."),
        ScriptureVerse(reference: "JEREMIAH 33:3", text: "Call to me and I will answer you."),
        ScriptureVerse(reference: "MATTHEW 5:14", text: "You are the light of the world."),
        ScriptureVerse(reference: "MATTHEW 5:16", text: "Let your light shine before others."),
        ScriptureVerse(reference: "MATTHEW 6:26", text: "Look at the birds of the air; they do not sow or reap."),
        ScriptureVerse(reference: "MATTHEW 19:14", text: "Let the little children come to me."),
        ScriptureVerse(reference: "MATTHEW 19:26", text: "With God all things are possible."),
        ScriptureVerse(reference: "MATTHEW 28:20", text: "And surely I am with you always, to the very end of the age."),
        ScriptureVerse(reference: "MARK 10:27", text: "All things are possible with God."),
        ScriptureVerse(reference: "LUKE 1:37", text: "For nothing will be impossible with God."),
        ScriptureVerse(reference: "JOHN 1:1", text: "In the beginning was the Word."),
        ScriptureVerse(reference: "JOHN 3:16", text: "For God so loved the world that he gave his one and only Son."),
        ScriptureVerse(reference: "JOHN 8:12", text: "I am the light of the world."),
        ScriptureVerse(reference: "JOHN 13:34", text: "A new command I give you: Love one another."),
        ScriptureVerse(reference: "JOHN 14:6", text: "I am the way and the truth and the life."),
        ScriptureVerse(reference: "JOHN 15:12", text: "Love each other as I have loved you."),
        ScriptureVerse(reference: "ROMANS 8:28", text: "All things work together for good."),
        ScriptureVerse(reference: "ROMANS 8:38", text: "Nothing can separate us from the love of God."),
        ScriptureVerse(reference: "1 CORINTHIANS 13:4", text: "Love is patient, love is kind."),
        ScriptureVerse(reference: "1 CORINTHIANS 13:13", text: "And now these three remain: faith, hope and love."),
        ScriptureVerse(reference: "GALATIANS 5:22", text: "The fruit of the Spirit is love, joy, peace."),
        ScriptureVerse(reference: "EPHESIANS 2:10", text: "For we are God's handiwork, created in Christ Jesus."),
        ScriptureVerse(reference: "PHILIPPIANS 4:6", text: "Do not be anxious about anything."),
        ScriptureVerse(reference: "PHILIPPIANS 4:13", text: "I can do all this through him who gives me strength."),
        ScriptureVerse(reference: "COLOSSIANS 3:23", text: "Whatever you do, work at it with all your heart."),
        ScriptureVerse(reference: "HEBREWS 11:1", text: "Now faith is confidence in what we hope for."),
        ScriptureVerse(reference: "1 JOHN 4:8", text: "God is love."),
        ScriptureVerse(reference: "REVELATION 21:5", text: "I am making everything new!")
    ]
}
