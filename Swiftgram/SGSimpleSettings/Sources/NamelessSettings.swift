import Foundation

private enum NamelessSettingsKey {
    static let showDeletedMessages = "nameless.showDeletedMessages"
    static let saveDeletedMessagesMedia = "nameless.saveDeletedMessagesMedia"
    static let saveDeletedMessagesReactions = "nameless.saveDeletedMessagesReactions"
    static let saveDeletedMessagesForBots = "nameless.saveDeletedMessagesForBots"
    static let saveEditHistory = "nameless.saveEditHistory"
    static let enableLocalMessageEditing = "nameless.enableLocalMessageEditing"
    static let keepRemovedChannels = "nameless.keepRemovedChannels"
    static let disableOnlineStatus = "nameless.disableOnlineStatus"
    static let disableTypingStatus = "nameless.disableTypingStatus"
    static let disableRecordingVideoStatus = "nameless.disableRecordingVideoStatus"
    static let disableUploadingVideoStatus = "nameless.disableUploadingVideoStatus"
    static let disableVCMessageRecordingStatus = "nameless.disableVCMessageRecordingStatus"
    static let disableVCMessageUploadingStatus = "nameless.disableVCMessageUploadingStatus"
    static let disableUploadingPhotoStatus = "nameless.disableUploadingPhotoStatus"
    static let disableUploadingFileStatus = "nameless.disableUploadingFileStatus"
    static let disableChoosingLocationStatus = "nameless.disableChoosingLocationStatus"
    static let disableChoosingContactStatus = "nameless.disableChoosingContactStatus"
    static let disablePlayingGameStatus = "nameless.disablePlayingGameStatus"
    static let disableRecordingRoundVideoStatus = "nameless.disableRecordingRoundVideoStatus"
    static let disableUploadingRoundVideoStatus = "nameless.disableUploadingRoundVideoStatus"
    static let disableSpeakingInGroupCallStatus = "nameless.disableSpeakingInGroupCallStatus"
    static let disableChoosingStickerStatus = "nameless.disableChoosingStickerStatus"
    static let disableEmojiInteractionStatus = "nameless.disableEmojiInteractionStatus"
    static let disableEmojiAcknowledgementStatus = "nameless.disableEmojiAcknowledgementStatus"
    static let disableMessageReadReceipt = "nameless.disableMessageReadReceipt"
    static let disableStoryReadReceipt = "nameless.disableStoryReadReceipt"
    static let disableAllAds = "nameless.disableAllAds"
    static let hideProxySponsor = "nameless.hideProxySponsor"
    static let enableSavingProtectedContent = "nameless.enableSavingProtectedContent"
    static let enableSavingSelfDestructingMessages = "nameless.enableSavingSelfDestructingMessages"
    static let disableScreenshotDetection = "nameless.disableScreenshotDetection"
    static let disableSecretChatBlurOnScreenshot = "nameless.disableSecretChatBlurOnScreenshot"
    static let enableLocalPremium = "nameless.enableLocalPremium"
    static let liquidGlassEnabled = "nameless.liquidGlassEnabled"
    static let disableCompactNumbers = "nameless.disableCompactNumbers"
    static let disableZalgoText = "nameless.disableZalgoText"
    static let chatExportEnabled = "nameless.chatExportEnabled"
    static let scrollToTopButtonEnabled = "nameless.scrollToTopButtonEnabled"
    static let unlimitedFavoriteStickers = "nameless.unlimitedFavoriteStickers"
    static let enableTelescope = "nameless.enableTelescope"
    static let enableVideoToCircleOrVoice = "nameless.enableVideoToCircleOrVoice"
    static let emojiDownloaderEnabled = "nameless.emojiDownloaderEnabled"
    static let feelRichEnabled = "nameless.feelRichEnabled"
    static let feelRichStarsAmount = "nameless.feelRichStarsAmount"
    static let fakeLocationEnabled = "nameless.fakeLocationEnabled"
    static let fakeLatitude = "nameless.fakeLatitude"
    static let fakeLongitude = "nameless.fakeLongitude"
    static let enableOnlineStatusRecording = "nameless.enableOnlineStatusRecording"
    static let onlineStatusRecordingIntervalMinutes = "nameless.onlineStatusRecordingIntervalMinutes"
    static let ghostModeMessageSendDelaySeconds = "nameless.ghostModeMessageSendDelaySeconds"
    static let giftIdEnabled = "nameless.giftIdEnabled"
    static let fakeProfileEnabled = "nameless.fakeProfileEnabled"
    static let fakeProfileTargetUserId = "nameless.fakeProfileTargetUserId"
    static let fakeProfileId = "nameless.fakeProfileId"
    static let fakeProfileFirstName = "nameless.fakeProfileFirstName"
    static let fakeProfileLastName = "nameless.fakeProfileLastName"
    static let fakeProfileUsername = "nameless.fakeProfileUsername"
    static let fakeProfilePhone = "nameless.fakeProfilePhone"
    static let fakeProfilePremium = "nameless.fakeProfilePremium"
    static let fakeProfileVerified = "nameless.fakeProfileVerified"
    static let fakeProfileScam = "nameless.fakeProfileScam"
    static let fakeProfileFake = "nameless.fakeProfileFake"
    static let fakeProfileSupport = "nameless.fakeProfileSupport"
    static let fakeProfileBot = "nameless.fakeProfileBot"
    static let enableFontReplacement = "nameless.enableFontReplacement"
    static let fontReplacementName = "nameless.fontReplacementName"
    static let fontReplacementFilePath = "nameless.fontReplacementFilePath"
    static let fontReplacementBoldName = "nameless.fontReplacementBoldName"
    static let fontReplacementBoldFilePath = "nameless.fontReplacementBoldFilePath"
    static let fontReplacementSizeMultiplier = "nameless.fontReplacementSizeMultiplier"
    static let profileCoverMediaPath = "nameless.profileCoverMediaPath"
    static let profileCoverIsVideo = "nameless.profileCoverIsVideo"
    static let pluginSystemEnabled = "nameless.pluginSystemEnabled"
    static let installedPluginsJson = "nameless.installedPluginsJson"
    static let doubleBottomEnabled = "nameless.doubleBottomEnabled"
    static let messageReadReceiptsSendToPeerIds = "nameless.messageReadReceiptsSendToPeerIds"
    static let currentAccountPeerId = "nameless.currentAccountPeerId"
    static let mutedAccountIds = "nameless.mutedAccountIds"
    static let gatedFeatureKeys = "nameless.gatedFeatureKeys"
    static let unlockedFeatureKeys = "nameless.unlockedFeatureKeys"

    static let liquidGlassMessages = "nameless.liquidGlass.messages"
    static let liquidGlassSettings = "nameless.liquidGlass.settings"
    static let liquidGlassProfile = "nameless.liquidGlass.profile"
    static let liquidGlassProfileGifts = "nameless.liquidGlass.profileGifts"
    static let liquidGlassInlineButtons = "nameless.liquidGlass.inlineButtons"
    static let liquidGlassTinting = "nameless.liquidGlass.tinting"
    static let videoBackgroundEnabled = "nameless.videoBackground.enabled"
    static let videoBackgroundPath = "nameless.videoBackground.path"
    static let musicCardStyle = "nameless.musicCardStyle"
    static let roundProfileButtons = "nameless.roundProfileButtons"
}

private enum NamelessRollbackStorage {
    static let snapshotKey = "nameless.rollback.snapshot.v1"
    static let managedPrefixes = ["nameless.", "VoiceMorpher."]
}

private extension UserDefaults {
    func namelessBool(_ key: String, default defaultValue: Bool = false) -> Bool {
        if self.object(forKey: key) == nil {
            return defaultValue
        }
        return self.bool(forKey: key)
    }

    func namelessInt32(_ key: String, default defaultValue: Int32 = 0) -> Int32 {
        if self.object(forKey: key) == nil {
            return defaultValue
        }
        return Int32(self.integer(forKey: key))
    }

    func namelessInt64(_ key: String, default defaultValue: Int64 = 0) -> Int64 {
        if self.object(forKey: key) == nil {
            return defaultValue
        }
        return Int64(self.integer(forKey: key))
    }

    func namelessDouble(_ key: String, default defaultValue: Double = 0.0) -> Double {
        if self.object(forKey: key) == nil {
            return defaultValue
        }
        return self.double(forKey: key)
    }

    func namelessString(_ key: String, default defaultValue: String = "") -> String {
        return self.string(forKey: key) ?? defaultValue
    }

    func namelessStringArray(_ key: String) -> [String] {
        return self.stringArray(forKey: key) ?? []
    }
}

public extension Notification.Name {
    static let luxgramLiquidGlassDidChange = Notification.Name("nameless.liquidGlassDidChange")
    static let namelessVideoBackgroundDidChange = Notification.Name("nameless.videoBackgroundDidChange")
    static let sgHideProxySponsorDidChange = Notification.Name("nameless.hideProxySponsorDidChange")
}

public extension SGSimpleSettings {
    private var storage: UserDefaults {
        return .standard
    }

    func beginNamelessRollbackSnapshot() {
        let values = storage.dictionaryRepresentation().filter { key, _ in
            for prefix in NamelessRollbackStorage.managedPrefixes {
                if key.hasPrefix(prefix) {
                    return true
                }
            }
            return false
        }

        if let data = try? JSONSerialization.data(withJSONObject: values, options: []) {
            storage.set(data, forKey: NamelessRollbackStorage.snapshotKey)
        }
    }

    @discardableResult
    func restoreNamelessRollbackSnapshot() -> Bool {
        guard let data = storage.data(forKey: NamelessRollbackStorage.snapshotKey),
              let values = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return false
        }

        let existing = storage.dictionaryRepresentation()
        for key in existing.keys {
            for prefix in NamelessRollbackStorage.managedPrefixes {
                if key.hasPrefix(prefix) {
                    storage.removeObject(forKey: key)
                    break
                }
            }
        }

        for (key, value) in values {
            storage.set(value, forKey: key)
        }

        storage.synchronize()
        return true
    }

    var showDeletedMessages: Bool { get { storage.namelessBool(NamelessSettingsKey.showDeletedMessages) } set { storage.set(newValue, forKey: NamelessSettingsKey.showDeletedMessages) } }
    var saveDeletedMessagesMedia: Bool { get { storage.namelessBool(NamelessSettingsKey.saveDeletedMessagesMedia) } set { storage.set(newValue, forKey: NamelessSettingsKey.saveDeletedMessagesMedia) } }
    var saveDeletedMessagesReactions: Bool { get { storage.namelessBool(NamelessSettingsKey.saveDeletedMessagesReactions) } set { storage.set(newValue, forKey: NamelessSettingsKey.saveDeletedMessagesReactions) } }
    var saveDeletedMessagesForBots: Bool { get { storage.namelessBool(NamelessSettingsKey.saveDeletedMessagesForBots) } set { storage.set(newValue, forKey: NamelessSettingsKey.saveDeletedMessagesForBots) } }
    var saveEditHistory: Bool { get { storage.namelessBool(NamelessSettingsKey.saveEditHistory) } set { storage.set(newValue, forKey: NamelessSettingsKey.saveEditHistory) } }
    var enableLocalMessageEditing: Bool { get { storage.namelessBool(NamelessSettingsKey.enableLocalMessageEditing) } set { storage.set(newValue, forKey: NamelessSettingsKey.enableLocalMessageEditing) } }
    var keepRemovedChannels: Bool { get { storage.namelessBool(NamelessSettingsKey.keepRemovedChannels) } set { storage.set(newValue, forKey: NamelessSettingsKey.keepRemovedChannels) } }
    var disableOnlineStatus: Bool { get { storage.namelessBool(NamelessSettingsKey.disableOnlineStatus) } set { storage.set(newValue, forKey: NamelessSettingsKey.disableOnlineStatus) } }
    var disableTypingStatus: Bool { get { storage.namelessBool(NamelessSettingsKey.disableTypingStatus) } set { storage.set(newValue, forKey: NamelessSettingsKey.disableTypingStatus) } }
    var disableRecordingVideoStatus: Bool { get { storage.namelessBool(NamelessSettingsKey.disableRecordingVideoStatus) } set { storage.set(newValue, forKey: NamelessSettingsKey.disableRecordingVideoStatus) } }
    var disableUploadingVideoStatus: Bool { get { storage.namelessBool(NamelessSettingsKey.disableUploadingVideoStatus) } set { storage.set(newValue, forKey: NamelessSettingsKey.disableUploadingVideoStatus) } }
    var disableVCMessageRecordingStatus: Bool { get { storage.namelessBool(NamelessSettingsKey.disableVCMessageRecordingStatus) } set { storage.set(newValue, forKey: NamelessSettingsKey.disableVCMessageRecordingStatus) } }
    var disableVCMessageUploadingStatus: Bool { get { storage.namelessBool(NamelessSettingsKey.disableVCMessageUploadingStatus) } set { storage.set(newValue, forKey: NamelessSettingsKey.disableVCMessageUploadingStatus) } }
    var disableUploadingPhotoStatus: Bool { get { storage.namelessBool(NamelessSettingsKey.disableUploadingPhotoStatus) } set { storage.set(newValue, forKey: NamelessSettingsKey.disableUploadingPhotoStatus) } }
    var disableUploadingFileStatus: Bool { get { storage.namelessBool(NamelessSettingsKey.disableUploadingFileStatus) } set { storage.set(newValue, forKey: NamelessSettingsKey.disableUploadingFileStatus) } }
    var disableChoosingLocationStatus: Bool { get { storage.namelessBool(NamelessSettingsKey.disableChoosingLocationStatus) } set { storage.set(newValue, forKey: NamelessSettingsKey.disableChoosingLocationStatus) } }
    var disableChoosingContactStatus: Bool { get { storage.namelessBool(NamelessSettingsKey.disableChoosingContactStatus) } set { storage.set(newValue, forKey: NamelessSettingsKey.disableChoosingContactStatus) } }
    var disablePlayingGameStatus: Bool { get { storage.namelessBool(NamelessSettingsKey.disablePlayingGameStatus) } set { storage.set(newValue, forKey: NamelessSettingsKey.disablePlayingGameStatus) } }
    var disableRecordingRoundVideoStatus: Bool { get { storage.namelessBool(NamelessSettingsKey.disableRecordingRoundVideoStatus) } set { storage.set(newValue, forKey: NamelessSettingsKey.disableRecordingRoundVideoStatus) } }
    var disableUploadingRoundVideoStatus: Bool { get { storage.namelessBool(NamelessSettingsKey.disableUploadingRoundVideoStatus) } set { storage.set(newValue, forKey: NamelessSettingsKey.disableUploadingRoundVideoStatus) } }
    var disableSpeakingInGroupCallStatus: Bool { get { storage.namelessBool(NamelessSettingsKey.disableSpeakingInGroupCallStatus) } set { storage.set(newValue, forKey: NamelessSettingsKey.disableSpeakingInGroupCallStatus) } }
    var disableChoosingStickerStatus: Bool { get { storage.namelessBool(NamelessSettingsKey.disableChoosingStickerStatus) } set { storage.set(newValue, forKey: NamelessSettingsKey.disableChoosingStickerStatus) } }
    var disableEmojiInteractionStatus: Bool { get { storage.namelessBool(NamelessSettingsKey.disableEmojiInteractionStatus) } set { storage.set(newValue, forKey: NamelessSettingsKey.disableEmojiInteractionStatus) } }
    var disableEmojiAcknowledgementStatus: Bool { get { storage.namelessBool(NamelessSettingsKey.disableEmojiAcknowledgementStatus) } set { storage.set(newValue, forKey: NamelessSettingsKey.disableEmojiAcknowledgementStatus) } }
    var disableMessageReadReceipt: Bool { get { storage.namelessBool(NamelessSettingsKey.disableMessageReadReceipt) } set { storage.set(newValue, forKey: NamelessSettingsKey.disableMessageReadReceipt) } }
    var disableStoryReadReceipt: Bool { get { storage.namelessBool(NamelessSettingsKey.disableStoryReadReceipt) } set { storage.set(newValue, forKey: NamelessSettingsKey.disableStoryReadReceipt) } }
    var disableAllAds: Bool { get { storage.namelessBool(NamelessSettingsKey.disableAllAds) } set { storage.set(newValue, forKey: NamelessSettingsKey.disableAllAds) } }
    var hideProxySponsor: Bool { get { storage.namelessBool(NamelessSettingsKey.hideProxySponsor) } set { storage.set(newValue, forKey: NamelessSettingsKey.hideProxySponsor) } }
    var enableSavingProtectedContent: Bool { get { storage.namelessBool(NamelessSettingsKey.enableSavingProtectedContent) } set { storage.set(newValue, forKey: NamelessSettingsKey.enableSavingProtectedContent) } }
    var enableSavingSelfDestructingMessages: Bool { get { storage.namelessBool(NamelessSettingsKey.enableSavingSelfDestructingMessages) } set { storage.set(newValue, forKey: NamelessSettingsKey.enableSavingSelfDestructingMessages) } }
    var disableScreenshotDetection: Bool { get { storage.namelessBool(NamelessSettingsKey.disableScreenshotDetection) } set { storage.set(newValue, forKey: NamelessSettingsKey.disableScreenshotDetection) } }
    var disableSecretChatBlurOnScreenshot: Bool { get { storage.namelessBool(NamelessSettingsKey.disableSecretChatBlurOnScreenshot) } set { storage.set(newValue, forKey: NamelessSettingsKey.disableSecretChatBlurOnScreenshot) } }
    var enableLocalPremium: Bool { get { storage.namelessBool(NamelessSettingsKey.enableLocalPremium) } set { storage.set(newValue, forKey: NamelessSettingsKey.enableLocalPremium) } }
    var liquidGlassEnabled: Bool { get { storage.namelessBool(NamelessSettingsKey.liquidGlassEnabled, default: true) } set { storage.set(newValue, forKey: NamelessSettingsKey.liquidGlassEnabled) } }
    var disableCompactNumbers: Bool { get { storage.namelessBool(NamelessSettingsKey.disableCompactNumbers) } set { storage.set(newValue, forKey: NamelessSettingsKey.disableCompactNumbers) } }
    var disableZalgoText: Bool { get { storage.namelessBool(NamelessSettingsKey.disableZalgoText) } set { storage.set(newValue, forKey: NamelessSettingsKey.disableZalgoText) } }
    var chatExportEnabled: Bool { get { storage.namelessBool(NamelessSettingsKey.chatExportEnabled) } set { storage.set(newValue, forKey: NamelessSettingsKey.chatExportEnabled) } }
    var scrollToTopButtonEnabled: Bool { get { storage.namelessBool(NamelessSettingsKey.scrollToTopButtonEnabled) } set { storage.set(newValue, forKey: NamelessSettingsKey.scrollToTopButtonEnabled) } }
    var unlimitedFavoriteStickers: Bool { get { storage.namelessBool(NamelessSettingsKey.unlimitedFavoriteStickers) } set { storage.set(newValue, forKey: NamelessSettingsKey.unlimitedFavoriteStickers) } }
    var enableTelescope: Bool { get { storage.namelessBool(NamelessSettingsKey.enableTelescope) } set { storage.set(newValue, forKey: NamelessSettingsKey.enableTelescope) } }
    var enableVideoToCircleOrVoice: Bool { get { storage.namelessBool(NamelessSettingsKey.enableVideoToCircleOrVoice) } set { storage.set(newValue, forKey: NamelessSettingsKey.enableVideoToCircleOrVoice) } }
    var emojiDownloaderEnabled: Bool { get { storage.namelessBool(NamelessSettingsKey.emojiDownloaderEnabled) } set { storage.set(newValue, forKey: NamelessSettingsKey.emojiDownloaderEnabled) } }
    var feelRichEnabled: Bool { get { storage.namelessBool(NamelessSettingsKey.feelRichEnabled) } set { storage.set(newValue, forKey: NamelessSettingsKey.feelRichEnabled) } }
    var feelRichStarsAmount: String { get { storage.namelessString(NamelessSettingsKey.feelRichStarsAmount, default: "1000") } set { storage.set(newValue, forKey: NamelessSettingsKey.feelRichStarsAmount) } }
    var fakeLocationEnabled: Bool { get { storage.namelessBool(NamelessSettingsKey.fakeLocationEnabled) } set { storage.set(newValue, forKey: NamelessSettingsKey.fakeLocationEnabled) } }
    var fakeLatitude: Double { get { storage.namelessDouble(NamelessSettingsKey.fakeLatitude) } set { storage.set(newValue, forKey: NamelessSettingsKey.fakeLatitude) } }
    var fakeLongitude: Double { get { storage.namelessDouble(NamelessSettingsKey.fakeLongitude) } set { storage.set(newValue, forKey: NamelessSettingsKey.fakeLongitude) } }
    var enableOnlineStatusRecording: Bool { get { storage.namelessBool(NamelessSettingsKey.enableOnlineStatusRecording) } set { storage.set(newValue, forKey: NamelessSettingsKey.enableOnlineStatusRecording) } }
    var onlineStatusRecordingIntervalMinutes: Int32 { get { storage.namelessInt32(NamelessSettingsKey.onlineStatusRecordingIntervalMinutes, default: 10) } set { storage.set(Int(newValue), forKey: NamelessSettingsKey.onlineStatusRecordingIntervalMinutes) } }
    var ghostModeMessageSendDelaySeconds: Int32 { get { storage.namelessInt32(NamelessSettingsKey.ghostModeMessageSendDelaySeconds) } set { storage.set(Int(newValue), forKey: NamelessSettingsKey.ghostModeMessageSendDelaySeconds) } }
    var giftIdEnabled: Bool { get { storage.namelessBool(NamelessSettingsKey.giftIdEnabled) } set { storage.set(newValue, forKey: NamelessSettingsKey.giftIdEnabled) } }
    var fakeProfileEnabled: Bool { get { storage.namelessBool(NamelessSettingsKey.fakeProfileEnabled) } set { storage.set(newValue, forKey: NamelessSettingsKey.fakeProfileEnabled) } }
    var fakeProfileTargetUserId: Int64 { get { storage.namelessInt64(NamelessSettingsKey.fakeProfileTargetUserId) } set { storage.set(Int(newValue), forKey: NamelessSettingsKey.fakeProfileTargetUserId) } }
    var fakeProfileId: Int64 { get { storage.namelessInt64(NamelessSettingsKey.fakeProfileId) } set { storage.set(Int(newValue), forKey: NamelessSettingsKey.fakeProfileId) } }
    var fakeProfileFirstName: String { get { storage.namelessString(NamelessSettingsKey.fakeProfileFirstName) } set { storage.set(newValue, forKey: NamelessSettingsKey.fakeProfileFirstName) } }
    var fakeProfileLastName: String { get { storage.namelessString(NamelessSettingsKey.fakeProfileLastName) } set { storage.set(newValue, forKey: NamelessSettingsKey.fakeProfileLastName) } }
    var fakeProfileUsername: String { get { storage.namelessString(NamelessSettingsKey.fakeProfileUsername) } set { storage.set(newValue, forKey: NamelessSettingsKey.fakeProfileUsername) } }
    var fakeProfilePhone: String { get { storage.namelessString(NamelessSettingsKey.fakeProfilePhone) } set { storage.set(newValue, forKey: NamelessSettingsKey.fakeProfilePhone) } }
    var fakeProfilePremium: Bool { get { storage.namelessBool(NamelessSettingsKey.fakeProfilePremium) } set { storage.set(newValue, forKey: NamelessSettingsKey.fakeProfilePremium) } }
    var fakeProfileVerified: Bool { get { storage.namelessBool(NamelessSettingsKey.fakeProfileVerified) } set { storage.set(newValue, forKey: NamelessSettingsKey.fakeProfileVerified) } }
    var fakeProfileScam: Bool { get { storage.namelessBool(NamelessSettingsKey.fakeProfileScam) } set { storage.set(newValue, forKey: NamelessSettingsKey.fakeProfileScam) } }
    var fakeProfileFake: Bool { get { storage.namelessBool(NamelessSettingsKey.fakeProfileFake) } set { storage.set(newValue, forKey: NamelessSettingsKey.fakeProfileFake) } }
    var fakeProfileSupport: Bool { get { storage.namelessBool(NamelessSettingsKey.fakeProfileSupport) } set { storage.set(newValue, forKey: NamelessSettingsKey.fakeProfileSupport) } }
    var fakeProfileBot: Bool { get { storage.namelessBool(NamelessSettingsKey.fakeProfileBot) } set { storage.set(newValue, forKey: NamelessSettingsKey.fakeProfileBot) } }
    var enableFontReplacement: Bool { get { storage.namelessBool(NamelessSettingsKey.enableFontReplacement) } set { storage.set(newValue, forKey: NamelessSettingsKey.enableFontReplacement) } }
    var fontReplacementName: String { get { storage.namelessString(NamelessSettingsKey.fontReplacementName) } set { storage.set(newValue, forKey: NamelessSettingsKey.fontReplacementName) } }
    var fontReplacementFilePath: String { get { storage.namelessString(NamelessSettingsKey.fontReplacementFilePath) } set { storage.set(newValue, forKey: NamelessSettingsKey.fontReplacementFilePath) } }
    var fontReplacementBoldName: String { get { storage.namelessString(NamelessSettingsKey.fontReplacementBoldName) } set { storage.set(newValue, forKey: NamelessSettingsKey.fontReplacementBoldName) } }
    var fontReplacementBoldFilePath: String { get { storage.namelessString(NamelessSettingsKey.fontReplacementBoldFilePath) } set { storage.set(newValue, forKey: NamelessSettingsKey.fontReplacementBoldFilePath) } }
    var fontReplacementSizeMultiplier: Int32 { get { storage.namelessInt32(NamelessSettingsKey.fontReplacementSizeMultiplier, default: 100) } set { storage.set(Int(newValue), forKey: NamelessSettingsKey.fontReplacementSizeMultiplier) } }
    var profileCoverMediaPath: String { get { storage.namelessString(NamelessSettingsKey.profileCoverMediaPath) } set { storage.set(newValue, forKey: NamelessSettingsKey.profileCoverMediaPath) } }
    var profileCoverIsVideo: Bool { get { storage.namelessBool(NamelessSettingsKey.profileCoverIsVideo) } set { storage.set(newValue, forKey: NamelessSettingsKey.profileCoverIsVideo) } }
    var pluginSystemEnabled: Bool { get { storage.namelessBool(NamelessSettingsKey.pluginSystemEnabled) } set { storage.set(newValue, forKey: NamelessSettingsKey.pluginSystemEnabled) } }
    var installedPluginsJson: String { get { storage.namelessString(NamelessSettingsKey.installedPluginsJson, default: "[]") } set { storage.set(newValue, forKey: NamelessSettingsKey.installedPluginsJson) } }
    var doubleBottomEnabled: Bool { get { storage.namelessBool(NamelessSettingsKey.doubleBottomEnabled) } set { storage.set(newValue, forKey: NamelessSettingsKey.doubleBottomEnabled) } }
    var messageReadReceiptsSendToPeerIds: [String] { get { storage.namelessStringArray(NamelessSettingsKey.messageReadReceiptsSendToPeerIds) } set { storage.set(newValue, forKey: NamelessSettingsKey.messageReadReceiptsSendToPeerIds) } }
    var unlockedFeatureKeys: [String] { get { storage.namelessStringArray(NamelessSettingsKey.unlockedFeatureKeys) } set { storage.set(newValue, forKey: NamelessSettingsKey.unlockedFeatureKeys) } }

    var currentAccountPeerId: String { get { storage.namelessString(NamelessSettingsKey.currentAccountPeerId) } set { storage.set(newValue, forKey: NamelessSettingsKey.currentAccountPeerId) } }

    var namelessLiquidGlassMessages: Bool { get { storage.namelessBool(NamelessSettingsKey.liquidGlassMessages, default: true) } set { storage.set(newValue, forKey: NamelessSettingsKey.liquidGlassMessages) } }
    var namelessLiquidGlassSettings: Bool { get { storage.namelessBool(NamelessSettingsKey.liquidGlassSettings, default: true) } set { storage.set(newValue, forKey: NamelessSettingsKey.liquidGlassSettings) } }
    var namelessLiquidGlassProfile: Bool { get { storage.namelessBool(NamelessSettingsKey.liquidGlassProfile, default: true) } set { storage.set(newValue, forKey: NamelessSettingsKey.liquidGlassProfile) } }
    var namelessLiquidGlassProfileGifts: Bool { get { storage.namelessBool(NamelessSettingsKey.liquidGlassProfileGifts, default: true) } set { storage.set(newValue, forKey: NamelessSettingsKey.liquidGlassProfileGifts) } }
    var namelessLiquidGlassInlineButtons: Bool { get { storage.namelessBool(NamelessSettingsKey.liquidGlassInlineButtons, default: true) } set { storage.set(newValue, forKey: NamelessSettingsKey.liquidGlassInlineButtons) } }
    var namelessLiquidGlassTinting: Bool { get { storage.namelessBool(NamelessSettingsKey.liquidGlassTinting) } set { storage.set(newValue, forKey: NamelessSettingsKey.liquidGlassTinting) } }
    var namelessVideoBackgroundEnabled: Bool { get { storage.namelessBool(NamelessSettingsKey.videoBackgroundEnabled) } set { storage.set(newValue, forKey: NamelessSettingsKey.videoBackgroundEnabled) } }
    var namelessVideoBackgroundPath: String { get { storage.namelessString(NamelessSettingsKey.videoBackgroundPath) } set { storage.set(newValue, forKey: NamelessSettingsKey.videoBackgroundPath) } }
    var namelessMusicCardStyle: Bool { get { storage.namelessBool(NamelessSettingsKey.musicCardStyle) } set { storage.set(newValue, forKey: NamelessSettingsKey.musicCardStyle) } }
    var namelessRoundProfileButtons: Bool { get { storage.namelessBool(NamelessSettingsKey.roundProfileButtons) } set { storage.set(newValue, forKey: NamelessSettingsKey.roundProfileButtons) } }

    func updateGatedFeatures(_ features: [(key: String, deeplinkPath: String)]) {
        storage.set(features.map(\.key), forKey: NamelessSettingsKey.gatedFeatureKeys)
    }

    func isFeatureVisible(_ key: String) -> Bool {
        let gated = Set(storage.namelessStringArray(NamelessSettingsKey.gatedFeatureKeys))
        if !gated.contains(key) {
            return true
        }
        return Set(self.unlockedFeatureKeys).contains(key)
    }

    func isAccountNotificationMuted(recordId: Int64) -> Bool {
        return Set(storage.namelessStringArray(NamelessSettingsKey.mutedAccountIds)).contains(String(recordId))
    }

    func setAccountNotificationMuted(recordId: Int64, muted: Bool) {
        var ids = Set(storage.namelessStringArray(NamelessSettingsKey.mutedAccountIds))
        if muted {
            ids.insert(String(recordId))
        } else {
            ids.remove(String(recordId))
        }
        storage.set(Array(ids).sorted(), forKey: NamelessSettingsKey.mutedAccountIds)
    }
}
