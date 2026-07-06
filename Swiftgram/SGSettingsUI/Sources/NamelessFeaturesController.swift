// MARK: nameless
import SGSimpleSettings
import SGItemListUI
import ItemListUI
import Foundation
import UIKit
import Display
import SwiftSignalKit
import AccountContext
import TelegramPresentationData
import PresentationDataUtils
import UndoUI
import TelegramCore
import TelegramUIPreferences

// MARK: - Section

private enum NLSectionId: Int32, SGItemListSection {
    case search = 0
    case items = 1
    case actions = 2
}

// MARK: - Settings

private enum NLBoolSetting: String {
    case hidePhoneInSettings
    case showTabNames
    case wideTabBar
    case hideStories
    case compactChatList
    case hideRecordingButton
    case sendWithReturnKey
    case wideChannelPosts
    case compactMessagePreview
    case disableChatSwipeOptions
    case disableDeleteChatSwipeOption
    case secondsInMessages
    case hideReactions
    case hideChannelBottomButton
    case disableSnapDeletionEffect
    case disableSendAsButton
    case hideTabBar
    case tabBarSearchEnabled
    case allChatsHidden
    case compactFolderNames
    case forceEmojiTab
    case defaultEmojisFirst
    case messageDoubleTapActionOutgoingEdit
    case showProfileId
    case showDC
    case showCreationDate
    case showRegDate
    case confirmCalls
    case swipeForVideoPIP
    case sendLargePhotos
    case stickerTimestamp
    case forceBuiltInMic
    case rememberLastFolder
    case showDeletedMessages
    case saveDeletedMessagesMedia
    case saveEditHistory
    case enableLocalMessageEditing
    case scrollToTopButtonEnabled
    case enableSavingProtectedContent
    case enableSavingSelfDestructingMessages
    case disableScreenshotDetection
    case disableSecretChatBlurOnScreenshot
    case disableAllAds
    case hideProxySponsor
    case disableScrollToNextChannel2
    case disableScrollToNextTopic2
    case disableZalgoText
    case quickTranslateButton
    case enableLocalPremium
    case uploadSpeedBoost
    case unlimitedFavoriteStickers
    case storyStealthMode
    case warnOnStoriesOpen
    case disableSwipeToRecordStory
    case forceSystemSharing
    case startTelescopeWithRearCam
    case disableGalleryCamera
    case disableGalleryCameraPreview
    case disableOnlineStatus
    case disableTypingStatus
    case disableVCMessageRecordingStatus
    case disableUploadingFileStatus
    case disableUploadingPhotoStatus
    case disableUploadingVideoStatus
    case disableRecordingVideoStatus
    case disableChoosingLocationStatus
    case disableChoosingContactStatus
    case disablePlayingGameStatus
    case disableRecordingRoundVideoStatus
    case disableUploadingRoundVideoStatus
    case disableSpeakingInGroupCallStatus
    case disableChoosingStickerStatus
    case disableEmojiInteractionStatus
    case disableEmojiAcknowledgementStatus
    case disableMessageReadReceipt
    case disableStoryReadReceipt
    case enableOnlineStatusRecording
    case fakeLocationEnabled
    case ghostModeMessageSendDelay
    case liquidGlassEnabled
    case namelessLiquidGlassMessages
    case namelessLiquidGlassSettings
    case namelessLiquidGlassProfile
    case namelessLiquidGlassProfileGifts
    case namelessLiquidGlassInlineButtons
    case namelessLiquidGlassTinting
    case enableTelescope
    case emojiDownloaderEnabled
    case enableVideoToCircleOrVoice
    case namelessVideoBackgroundEnabled
    case namelessMusicCardStyle
    case namelessRoundProfileButtons
    case disableCompactNumbers
    case contextShowSaveToCloud
    case contextShowHideForwardName
    case contextShowSelectFromUser
    case contextShowRestrict
    case contextShowReport
    case contextShowReply
    case contextShowPin
    case contextShowSaveMedia
    case contextShowMessageReplies
    case contextShowJson
    case showRepostToStory
}

private enum NLSliderSetting: String {
    case outgoingPhotoQuality
    case stickerSize
    case accountColorsSaturation
}

private enum NLOneFromManySetting: String {
    case downloadSpeedBoost
}

private enum NLDisclosureLink: String {
    case none
}

private enum NLAction: Int, CaseIterable {
    case exportSettings
    case importSettings
    case saveKeychain
    case resetAll
}

// MARK: - State

private struct NLControllerState: Equatable {
    var searchQuery: String?
}

// MARK: - Entry type

private typealias NLEntry = SGItemListUIEntry<NLSectionId, NLBoolSetting, NLSliderSetting, NLOneFromManySetting, NLDisclosureLink, NLAction>

// MARK: - Build Entries

private func nlBuildEntries(presentationData: PresentationData, state: NLControllerState, simpleUpdated: Bool) -> [NLEntry] {
    let s = SGSimpleSettings.shared
    var entries: [NLEntry] = []
    let id = SGItemListCounter()

    entries.append(.searchInput(id: id.count, section: .search, title: NSAttributedString(string: "🔍"), text: state.searchQuery ?? "", placeholder: "Поиск настроек"))

    let sec: NLSectionId = .items

    // ВНЕШНИЙ ВИД
    entries.append(.header(id: id.count, section: sec, text: "ВНЕШНИЙ ВИД", badge: nil))
    entries.append(.toggle(id: id.count, section: sec, settingName: .hidePhoneInSettings, value: s.hidePhoneInSettings, text: "Скрыть номер телефона", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .showTabNames, value: s.showTabNames, text: "Подписи вкладок", enabled: !s.hideTabBar))
    entries.append(.toggle(id: id.count, section: sec, settingName: .wideTabBar, value: s.wideTabBar, text: "Широкая панель вкладок", enabled: !s.hideTabBar))
    entries.append(.toggle(id: id.count, section: sec, settingName: .hideTabBar, value: s.hideTabBar, text: "Скрыть нижний таббар", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .tabBarSearchEnabled, value: s.tabBarSearchEnabled, text: "Кнопка поиска в списке чатов", enabled: !s.hideTabBar))
    entries.append(.toggle(id: id.count, section: sec, settingName: .allChatsHidden, value: s.allChatsHidden, text: "Скрыть «Все чаты»", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .compactFolderNames, value: s.compactFolderNames, text: "Компактные имена папок", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .rememberLastFolder, value: s.rememberLastFolder, text: "Запоминать последнюю папку", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .hideStories, value: s.hideStories, text: "Скрыть истории", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .compactChatList, value: s.compactChatList, text: "Компактный список чатов", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .compactMessagePreview, value: s.chatListLines != SGSimpleSettings.ChatListLines.three.rawValue, text: "Компактный превью сообщений", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .disableChatSwipeOptions, value: !s.disableChatSwipeOptions, text: "Свайп-опции чатов", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .disableDeleteChatSwipeOption, value: !s.disableDeleteChatSwipeOption, text: "Свайп для удаления чата", enabled: !s.disableChatSwipeOptions))
    entries.append(.toggle(id: id.count, section: sec, settingName: .hideRecordingButton, value: !s.hideRecordingButton, text: "Кнопка записи голосовых", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .sendWithReturnKey, value: s.sendWithReturnKey, text: "Отправка по клавише Return", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .wideChannelPosts, value: s.wideChannelPosts, text: "Широкие посты в каналах", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .secondsInMessages, value: s.secondsInMessages, text: "Секунды в метке времени", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .hideReactions, value: s.hideReactions, text: "Скрыть реакции", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .hideChannelBottomButton, value: !s.hideChannelBottomButton, text: "Кнопка канала внизу", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .disableSnapDeletionEffect, value: !s.disableSnapDeletionEffect, text: "Эффект удаления", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .disableSendAsButton, value: !s.disableSendAsButton, text: "Кнопка «Send As»", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .disableGalleryCamera, value: !s.disableGalleryCamera, text: "Камера в галерее", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .disableGalleryCameraPreview, value: !s.disableGalleryCameraPreview, text: "Превью камеры в галерее", enabled: !s.disableGalleryCamera))
    entries.append(.toggle(id: id.count, section: sec, settingName: .messageDoubleTapActionOutgoingEdit, value: s.messageDoubleTapActionOutgoing == SGSimpleSettings.MessageDoubleTapAction.edit.rawValue, text: "Двойной тап = редактирование", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .forceEmojiTab, value: s.forceEmojiTab, text: "Вкладка эмодзи по умолчанию", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .defaultEmojisFirst, value: s.defaultEmojisFirst, text: "Стандартные эмодзи первыми", enabled: true))
    entries.append(.header(id: id.count, section: sec, text: "НАСЫЩЕННОСТЬ ЦВЕТОВ", badge: nil))
    entries.append(.percentageSlider(id: id.count, section: sec, settingName: .accountColorsSaturation, value: s.accountColorsSaturation))
    entries.append(.toggle(id: id.count, section: sec, settingName: .namelessMusicCardStyle, value: s.namelessMusicCardStyle, text: "Стиль карточки музыки", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .namelessRoundProfileButtons, value: s.namelessRoundProfileButtons, text: "Круглые кнопки в профиле", enabled: true))

    // УВЕДОМЛЕНИЯ
    entries.append(.header(id: id.count, section: sec, text: "УВЕДОМЛЕНИЯ", badge: nil))
    entries.append(.toggle(id: id.count, section: sec, settingName: .confirmCalls, value: s.confirmCalls, text: "Предупреждение при звонке", enabled: true))

    // LIQUID GLASS
    entries.append(.header(id: id.count, section: sec, text: "LIQUID GLASS", badge: nil))
    entries.append(.toggle(id: id.count, section: sec, settingName: .liquidGlassEnabled, value: s.liquidGlassEnabled, text: "Liquid Glass (общее)", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .namelessLiquidGlassMessages, value: s.namelessLiquidGlassMessages, text: "Liquid Glass сообщения", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .namelessLiquidGlassSettings, value: s.namelessLiquidGlassSettings, text: "Liquid Glass настройки", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .namelessLiquidGlassProfile, value: s.namelessLiquidGlassProfile, text: "Liquid Glass профиль", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .namelessLiquidGlassProfileGifts, value: s.namelessLiquidGlassProfileGifts, text: "Liquid Glass подарки", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .namelessLiquidGlassInlineButtons, value: s.namelessLiquidGlassInlineButtons, text: "Liquid Glass инлайн-кнопки", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .namelessLiquidGlassTinting, value: s.namelessLiquidGlassTinting, text: "Liquid Glass тонирование", enabled: true))

    // СООБЩЕНИЯ
    entries.append(.header(id: id.count, section: sec, text: "СООБЩЕНИЯ", badge: nil))
    entries.append(.toggle(id: id.count, section: sec, settingName: .showDeletedMessages, value: s.showDeletedMessages, text: "Показывать удалённые сообщения", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .saveDeletedMessagesMedia, value: s.saveDeletedMessagesMedia, text: "Сохранять медиа удалённых", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .saveEditHistory, value: s.saveEditHistory, text: "Сохранять историю редактирований", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .enableLocalMessageEditing, value: s.enableLocalMessageEditing, text: "Локальное редактирование сообщений", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .scrollToTopButtonEnabled, value: s.scrollToTopButtonEnabled, text: "Кнопка «Наверх»", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .disableScrollToNextChannel2, value: !s.disableScrollToNextChannel, text: "Скролл к следующему каналу", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .disableScrollToNextTopic2, value: !s.disableScrollToNextTopic, text: "Скролл к следующему топику", enabled: true))

    // КАМЕРА
    entries.append(.header(id: id.count, section: sec, text: "КАМЕРА", badge: nil))
    entries.append(.toggle(id: id.count, section: sec, settingName: .enableTelescope, value: s.enableTelescope, text: "Телескоп (зум камеры)", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .startTelescopeWithRearCam, value: s.startTelescopeWithRearCam, text: "Начинать с задней камеры", enabled: true))

    // РЕЖИМ ПРИЗРАКА
    entries.append(.header(id: id.count, section: sec, text: "РЕЖИМ ПРИЗРАКА", badge: nil))
    entries.append(.toggle(id: id.count, section: sec, settingName: .disableOnlineStatus, value: s.disableOnlineStatus, text: "Онлайн-статус", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .disableTypingStatus, value: s.disableTypingStatus, text: "Набор текста", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .disableVCMessageRecordingStatus, value: s.disableVCMessageRecordingStatus, text: "Запись голосового", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .disableUploadingFileStatus, value: s.disableUploadingFileStatus, text: "Загрузка файлов", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .disableUploadingPhotoStatus, value: s.disableUploadingPhotoStatus, text: "Отправка фото", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .disableUploadingVideoStatus, value: s.disableUploadingVideoStatus, text: "Отправка видео", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .disableRecordingVideoStatus, value: s.disableRecordingVideoStatus, text: "Запись видео", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .disableChoosingLocationStatus, value: s.disableChoosingLocationStatus, text: "Выбор локации", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .disableChoosingContactStatus, value: s.disableChoosingContactStatus, text: "Выбор контакта", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .disablePlayingGameStatus, value: s.disablePlayingGameStatus, text: "Статус игры", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .disableRecordingRoundVideoStatus, value: s.disableRecordingRoundVideoStatus, text: "Запись кружка", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .disableUploadingRoundVideoStatus, value: s.disableUploadingRoundVideoStatus, text: "Отправка кружка", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .disableSpeakingInGroupCallStatus, value: s.disableSpeakingInGroupCallStatus, text: "Говорение в групповом звонке", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .disableChoosingStickerStatus, value: s.disableChoosingStickerStatus, text: "Выбор стикера", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .disableEmojiInteractionStatus, value: s.disableEmojiInteractionStatus, text: "Эмодзи-взаимодействие", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .disableEmojiAcknowledgementStatus, value: s.disableEmojiAcknowledgementStatus, text: "Эмодзи-подтверждение", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .disableMessageReadReceipt, value: s.disableMessageReadReceipt, text: "Прочтение сообщений", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .disableStoryReadReceipt, value: s.disableStoryReadReceipt, text: "Просмотр сторис", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .enableOnlineStatusRecording, value: s.enableOnlineStatusRecording, text: "История онлайн", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .fakeLocationEnabled, value: s.fakeLocationEnabled, text: "Подмена геолокации", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .ghostModeMessageSendDelay, value: s.ghostModeMessageSendDelaySeconds > 0, text: "Задержка отправки (призрак)", enabled: true))

    // КОНФИДЕНЦИАЛЬНОСТЬ
    entries.append(.header(id: id.count, section: sec, text: "КОНФИДЕНЦИАЛЬНОСТЬ", badge: nil))
    entries.append(.toggle(id: id.count, section: sec, settingName: .disableAllAds, value: s.disableAllAds, text: "Отключить рекламу", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .enableSavingProtectedContent, value: s.enableSavingProtectedContent, text: "Сохранять защищённый контент", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .enableSavingSelfDestructingMessages, value: s.enableSavingSelfDestructingMessages, text: "Сохранять самоуничтожающиеся", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .disableScreenshotDetection, value: s.disableScreenshotDetection, text: "Отключить определение скриншотов", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .disableSecretChatBlurOnScreenshot, value: s.disableSecretChatBlurOnScreenshot, text: "Без размытия при скриншоте", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .hideProxySponsor, value: s.hideProxySponsor, text: "Скрыть спонсора прокси", enabled: true))

    // ИНФОРМАЦИЯ
    entries.append(.header(id: id.count, section: sec, text: "ИНФОРМАЦИЯ", badge: nil))
    entries.append(.toggle(id: id.count, section: sec, settingName: .showProfileId, value: s.showProfileId, text: "ID и DC в профиле", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .showDC, value: s.showDC, text: "Показывать DC", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .showCreationDate, value: s.showCreationDate, text: "Дата создания чата/канала", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .showRegDate, value: s.showRegDate, text: "Дата регистрации пользователя", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .disableCompactNumbers, value: !s.disableCompactNumbers, text: "Компактные числа", enabled: true))

    // КОНТЕКСТНОЕ МЕНЮ
    entries.append(.header(id: id.count, section: sec, text: "КОНТЕКСТНОЕ МЕНЮ", badge: nil))
    entries.append(.toggle(id: id.count, section: sec, settingName: .contextShowSaveToCloud, value: s.contextShowSaveToCloud, text: "Сохранить в облако", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .contextShowHideForwardName, value: s.contextShowHideForwardName, text: "Скрыть имя пересылки", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .contextShowSelectFromUser, value: s.contextShowSelectFromUser, text: "Выбрать от пользователя", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .contextShowRestrict, value: s.contextShowRestrict, text: "Ограничить", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .contextShowReport, value: s.contextShowReport, text: "Пожаловаться", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .contextShowReply, value: s.contextShowReply, text: "Ответить", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .contextShowPin, value: s.contextShowPin, text: "Закрепить", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .contextShowSaveMedia, value: s.contextShowSaveMedia, text: "Сохранить медиа", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .contextShowMessageReplies, value: s.contextShowMessageReplies, text: "Ответы на сообщение", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .contextShowJson, value: s.contextShowJson, text: "JSON", enabled: true))

    // ДОПОЛНИТЕЛЬНО
    entries.append(.header(id: id.count, section: sec, text: "ДОПОЛНИТЕЛЬНО", badge: nil))
    entries.append(.toggle(id: id.count, section: sec, settingName: .enableLocalPremium, value: s.enableLocalPremium, text: "Локальный премиум", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .quickTranslateButton, value: s.quickTranslateButton, text: "Кнопка «Перевести» видима", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .disableZalgoText, value: s.disableZalgoText, text: "Zalgo-фильтр", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .uploadSpeedBoost, value: s.uploadSpeedBoost, text: "Ускорение отправки", enabled: true))
    entries.append(.oneFromManySelector(id: id.count, section: sec, settingName: .downloadSpeedBoost, text: "Ускорение загрузки", value: s.downloadSpeedBoost, enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .unlimitedFavoriteStickers, value: s.unlimitedFavoriteStickers, text: "Безлимитные избранные стикеры", enabled: true))

    // СТИКЕРЫ
    entries.append(.header(id: id.count, section: sec, text: "СТИКЕРЫ", badge: nil))
    entries.append(.percentageSlider(id: id.count, section: sec, settingName: .stickerSize, value: s.stickerSize))
    entries.append(.toggle(id: id.count, section: sec, settingName: .stickerTimestamp, value: s.stickerTimestamp, text: "Временные метки на стикерах", enabled: true))

    // ФОТО
    entries.append(.header(id: id.count, section: sec, text: "ФОТО", badge: nil))
    entries.append(.percentageSlider(id: id.count, section: sec, settingName: .outgoingPhotoQuality, value: s.outgoingPhotoQuality))
    entries.append(.toggle(id: id.count, section: sec, settingName: .sendLargePhotos, value: s.sendLargePhotos, text: "Отправлять большие фото", enabled: true))

    // СТОРИС
    entries.append(.header(id: id.count, section: sec, text: "СТОРИС", badge: nil))
    entries.append(.toggle(id: id.count, section: sec, settingName: .disableSwipeToRecordStory, value: s.disableSwipeToRecordStory, text: "Скрыть свайп для записи сторис", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .warnOnStoriesOpen, value: s.warnOnStoriesOpen, text: "Предупреждение при открытии сторис", enabled: true))
    if s.canUseStealthMode {
        entries.append(.toggle(id: id.count, section: sec, settingName: .storyStealthMode, value: s.storyStealthMode, text: "Stealth-режим сторис", enabled: true))
    } else {
        id.increment(1)
    }
    entries.append(.toggle(id: id.count, section: sec, settingName: .showRepostToStory, value: s.showRepostToStoryV2, text: "Переслать в историю", enabled: true))

    // ПРОЧЕЕ
    entries.append(.header(id: id.count, section: sec, text: "ПРОЧЕЕ", badge: nil))
    entries.append(.toggle(id: id.count, section: sec, settingName: .forceSystemSharing, value: s.forceSystemSharing, text: "Системный шэринг", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .emojiDownloaderEnabled, value: s.emojiDownloaderEnabled, text: "Скачивание эмодзи", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .enableVideoToCircleOrVoice, value: s.enableVideoToCircleOrVoice, text: "Видео в кружок/голосовое", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .namelessVideoBackgroundEnabled, value: s.namelessVideoBackgroundEnabled, text: "Видео-фон чатов", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .swipeForVideoPIP, value: s.videoPIPSwipeDirection == SGSimpleSettings.VideoPIPSwipeDirection.up.rawValue, text: "Свайп для PiP видео", enabled: true))
    entries.append(.toggle(id: id.count, section: sec, settingName: .forceBuiltInMic, value: s.forceBuiltInMic, text: "Встроенный микрофон", enabled: true))

    // ЭКСПОРТ / ИМПОРТ
    let actSec: NLSectionId = .actions
    entries.append(.header(id: id.count, section: actSec, text: "ЭКСПОРТ / ИМПОРТ", badge: nil))
    entries.append(.action(id: id.count, section: actSec, actionType: .exportSettings, text: "Экспорт настроек в JSON", kind: .generic))
    entries.append(.action(id: id.count, section: actSec, actionType: .importSettings, text: "Импорт настроек из JSON", kind: .generic))
    entries.append(.action(id: id.count, section: actSec, actionType: .saveKeychain, text: "Сохранить настройки в Keychain", kind: .generic))
    entries.append(.action(id: id.count, section: actSec, actionType: .resetAll, text: "Сбросить все настройки nameless", kind: .destructive))

    return filterSGItemListUIEntrires(entries: entries, by: state.searchQuery)
}

// MARK: - Public API

public func namelessFeaturesController(context: AccountContext) -> ViewController {
    var presentControllerImpl: ((ViewController, ViewControllerPresentationArguments?) -> Void)?
    var askForRestart: (() -> Void)?

    let initialState = NLControllerState()
    let statePromise = ValuePromise(initialState, ignoreRepeated: true)
    let stateValue = Atomic(value: initialState)
    let updateState: ((NLControllerState) -> NLControllerState) -> Void = { f in
        statePromise.set(stateValue.modify { f($0) })
    }

    let simplePromise = ValuePromise(true, ignoreRepeated: false)

    let arguments = SGItemListArguments<NLBoolSetting, NLSliderSetting, NLOneFromManySetting, NLDisclosureLink, NLAction>(
        context: context,
        setBoolValue: { setting, value in
            let s = SGSimpleSettings.shared
            switch setting {
            case .hidePhoneInSettings: s.hidePhoneInSettings = value; askForRestart?()
            case .showTabNames: s.showTabNames = value; askForRestart?()
            case .wideTabBar: s.wideTabBar = value; askForRestart?()
            case .hideStories: s.hideStories = value
            case .compactChatList: s.compactChatList = value; askForRestart?()
            case .hideRecordingButton: s.hideRecordingButton = !value
            case .sendWithReturnKey: s.sendWithReturnKey = value
            case .wideChannelPosts: s.wideChannelPosts = value
            case .compactMessagePreview: s.chatListLines = value ? SGSimpleSettings.ChatListLines.two.rawValue : SGSimpleSettings.ChatListLines.three.rawValue; askForRestart?()
            case .disableChatSwipeOptions: s.disableChatSwipeOptions = !value; simplePromise.set(true); askForRestart?()
            case .disableDeleteChatSwipeOption: s.disableDeleteChatSwipeOption = !value; askForRestart?()
            case .secondsInMessages: s.secondsInMessages = value
            case .hideReactions: s.hideReactions = value
            case .hideChannelBottomButton: s.hideChannelBottomButton = !value
            case .disableSnapDeletionEffect: s.disableSnapDeletionEffect = !value
            case .disableSendAsButton: s.disableSendAsButton = !value
            case .hideTabBar: s.hideTabBar = value; simplePromise.set(true); askForRestart?()
            case .tabBarSearchEnabled: s.tabBarSearchEnabled = value
            case .allChatsHidden: s.allChatsHidden = value; askForRestart?()
            case .compactFolderNames: s.compactFolderNames = value; askForRestart?()
            case .forceEmojiTab: s.forceEmojiTab = value
            case .defaultEmojisFirst: s.defaultEmojisFirst = value
            case .messageDoubleTapActionOutgoingEdit: s.messageDoubleTapActionOutgoing = value ? SGSimpleSettings.MessageDoubleTapAction.edit.rawValue : SGSimpleSettings.MessageDoubleTapAction.default.rawValue
            case .showProfileId: s.showProfileId = value
            case .showDC: s.showDC = value
            case .showCreationDate: s.showCreationDate = value
            case .showRegDate: s.showRegDate = value
            case .confirmCalls: s.confirmCalls = value
            case .swipeForVideoPIP: s.videoPIPSwipeDirection = value ? SGSimpleSettings.VideoPIPSwipeDirection.up.rawValue : SGSimpleSettings.VideoPIPSwipeDirection.none.rawValue
            case .sendLargePhotos: s.sendLargePhotos = value
            case .stickerTimestamp: s.stickerTimestamp = value
            case .forceBuiltInMic: s.forceBuiltInMic = value
            case .rememberLastFolder: s.rememberLastFolder = value
            case .showDeletedMessages: s.showDeletedMessages = value
            case .saveDeletedMessagesMedia: s.saveDeletedMessagesMedia = value
            case .saveEditHistory: s.saveEditHistory = value
            case .enableLocalMessageEditing: s.enableLocalMessageEditing = value
            case .scrollToTopButtonEnabled: s.scrollToTopButtonEnabled = value
            case .enableSavingProtectedContent: s.enableSavingProtectedContent = value
            case .enableSavingSelfDestructingMessages: s.enableSavingSelfDestructingMessages = value
            case .disableScreenshotDetection: s.disableScreenshotDetection = value
            case .disableSecretChatBlurOnScreenshot: s.disableSecretChatBlurOnScreenshot = value
            case .disableAllAds: s.disableAllAds = value
            case .hideProxySponsor: s.hideProxySponsor = value
            case .disableScrollToNextChannel2: s.disableScrollToNextChannel = !value
            case .disableScrollToNextTopic2: s.disableScrollToNextTopic = !value
            case .disableZalgoText: s.disableZalgoText = value
            case .quickTranslateButton: s.quickTranslateButton = value
            case .enableLocalPremium: s.enableLocalPremium = value
            case .uploadSpeedBoost: s.uploadSpeedBoost = value
            case .unlimitedFavoriteStickers: s.unlimitedFavoriteStickers = value
            case .storyStealthMode: s.storyStealthMode = value
            case .warnOnStoriesOpen: s.warnOnStoriesOpen = value
            case .disableSwipeToRecordStory: s.disableSwipeToRecordStory = value
            case .forceSystemSharing: s.forceSystemSharing = value
            case .startTelescopeWithRearCam: s.startTelescopeWithRearCam = value
            case .disableGalleryCamera: s.disableGalleryCamera = !value; simplePromise.set(true)
            case .disableGalleryCameraPreview: s.disableGalleryCameraPreview = !value
            case .disableOnlineStatus: s.disableOnlineStatus = value
            case .disableTypingStatus: s.disableTypingStatus = value
            case .disableVCMessageRecordingStatus: s.disableVCMessageRecordingStatus = value
            case .disableUploadingFileStatus: s.disableUploadingFileStatus = value
            case .disableUploadingPhotoStatus: s.disableUploadingPhotoStatus = value
            case .disableUploadingVideoStatus: s.disableUploadingVideoStatus = value
            case .disableRecordingVideoStatus: s.disableRecordingVideoStatus = value
            case .disableChoosingLocationStatus: s.disableChoosingLocationStatus = value
            case .disableChoosingContactStatus: s.disableChoosingContactStatus = value
            case .disablePlayingGameStatus: s.disablePlayingGameStatus = value
            case .disableRecordingRoundVideoStatus: s.disableRecordingRoundVideoStatus = value
            case .disableUploadingRoundVideoStatus: s.disableUploadingRoundVideoStatus = value
            case .disableSpeakingInGroupCallStatus: s.disableSpeakingInGroupCallStatus = value
            case .disableChoosingStickerStatus: s.disableChoosingStickerStatus = value
            case .disableEmojiInteractionStatus: s.disableEmojiInteractionStatus = value
            case .disableEmojiAcknowledgementStatus: s.disableEmojiAcknowledgementStatus = value
            case .disableMessageReadReceipt: s.disableMessageReadReceipt = value
            case .disableStoryReadReceipt: s.disableStoryReadReceipt = value
            case .enableOnlineStatusRecording: s.enableOnlineStatusRecording = value
            case .fakeLocationEnabled: s.fakeLocationEnabled = value
            case .ghostModeMessageSendDelay: s.ghostModeMessageSendDelaySeconds = value ? 12 : 0
            case .liquidGlassEnabled: s.liquidGlassEnabled = value; NotificationCenter.default.post(name: .luxgramLiquidGlassDidChange, object: nil)
            case .namelessLiquidGlassMessages: s.namelessLiquidGlassMessages = value; NotificationCenter.default.post(name: .luxgramLiquidGlassDidChange, object: nil)
            case .namelessLiquidGlassSettings: s.namelessLiquidGlassSettings = value; NotificationCenter.default.post(name: .luxgramLiquidGlassDidChange, object: nil)
            case .namelessLiquidGlassProfile: s.namelessLiquidGlassProfile = value; NotificationCenter.default.post(name: .luxgramLiquidGlassDidChange, object: nil)
            case .namelessLiquidGlassProfileGifts: s.namelessLiquidGlassProfileGifts = value; NotificationCenter.default.post(name: .luxgramLiquidGlassDidChange, object: nil)
            case .namelessLiquidGlassInlineButtons: s.namelessLiquidGlassInlineButtons = value; NotificationCenter.default.post(name: .luxgramLiquidGlassDidChange, object: nil)
            case .namelessLiquidGlassTinting: s.namelessLiquidGlassTinting = value; NotificationCenter.default.post(name: .luxgramLiquidGlassDidChange, object: nil)
            case .enableTelescope: s.enableTelescope = value
            case .emojiDownloaderEnabled: s.emojiDownloaderEnabled = value
            case .enableVideoToCircleOrVoice: s.enableVideoToCircleOrVoice = value
            case .namelessVideoBackgroundEnabled: s.namelessVideoBackgroundEnabled = value
            case .namelessMusicCardStyle: s.namelessMusicCardStyle = value
            case .namelessRoundProfileButtons: s.namelessRoundProfileButtons = value
            case .disableCompactNumbers: s.disableCompactNumbers = !value
            case .contextShowSaveToCloud: s.contextShowSaveToCloud = value
            case .contextShowHideForwardName: s.contextShowHideForwardName = value
            case .contextShowSelectFromUser: s.contextShowSelectFromUser = value
            case .contextShowRestrict: s.contextShowRestrict = value
            case .contextShowReport: s.contextShowReport = value
            case .contextShowReply: s.contextShowReply = value
            case .contextShowPin: s.contextShowPin = value
            case .contextShowSaveMedia: s.contextShowSaveMedia = value
            case .contextShowMessageReplies: s.contextShowMessageReplies = value
            case .contextShowJson: s.contextShowJson = value
            case .showRepostToStory: s.showRepostToStoryV2 = value
            }
        },
        updateSliderValue: { slider, value in
            let s = SGSimpleSettings.shared
            switch slider {
            case .outgoingPhotoQuality: if s.outgoingPhotoQuality != value { s.outgoingPhotoQuality = value; simplePromise.set(true) }
            case .stickerSize: if s.stickerSize != value { s.stickerSize = value; simplePromise.set(true) }
            case .accountColorsSaturation: if s.accountColorsSaturation != value { s.accountColorsSaturation = value; simplePromise.set(true) }
            }
        },
        setOneFromManyValue: { setting in
            let presentationData = context.sharedContext.currentPresentationData.with { $0 }
            let actionSheet = ActionSheetController(presentationData: presentationData)
            var items: [ActionSheetItem] = []

            switch setting {
            case .downloadSpeedBoost:
                let setAction: (String) -> Void = { value in
                    SGSimpleSettings.shared.downloadSpeedBoost = value
                    simplePromise.set(true)
                    let enableDownloadX: Bool = value != SGSimpleSettings.DownloadSpeedBoostValues.none.rawValue
                    let _ = updateNetworkSettingsInteractively(postbox: context.account.postbox, network: context.account.network, { settings in
                        var settings = settings
                        settings.useExperimentalDownload = enableDownloadX
                        return settings
                    }).start(completed: {
                        Queue.mainQueue().async { askForRestart?() }
                    })
                }
                for value in SGSimpleSettings.DownloadSpeedBoostValues.allCases {
                    items.append(ActionSheetButtonItem(title: value.rawValue, color: .accent, action: { [weak actionSheet] in
                        actionSheet?.dismissAnimated()
                        setAction(value.rawValue)
                    }))
                }
            }
            actionSheet.setItemGroups([ActionSheetItemGroup(items: items), ActionSheetItemGroup(items: [
                ActionSheetButtonItem(title: presentationData.strings.Common_Cancel, color: .accent, font: .bold, action: { [weak actionSheet] in
                    actionSheet?.dismissAnimated()
                })
            ])])
            presentControllerImpl?(actionSheet, ViewControllerPresentationArguments(presentationAnimation: .modalSheet))
        },
        openDisclosureLink: { _ in },
        action: { actionType in
            switch actionType {
            case .exportSettings:
                var dict: [String: Any] = [:]
                for key in UserDefaults.standard.dictionaryRepresentation().keys where key.hasPrefix("nameless.") || key.hasPrefix("VoiceMorpher.") { dict[key] = UserDefaults.standard.object(forKey: key) }
                if let d = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted), let s = String(data: d, encoding: .utf8) { UIPasteboard.general.string = s }
            case .importSettings:
                if let s = UIPasteboard.general.string, let d = s.data(using: .utf8), let dict = try? JSONSerialization.jsonObject(with: d) as? [String: Any] {
                    for (k, v) in dict where k.hasPrefix("nameless.") || k.hasPrefix("VoiceMorpher.") { UserDefaults.standard.set(v, forKey: k) }
                }
                simplePromise.set(true)
            case .saveKeychain:
                SGSimpleSettings.shared.beginNamelessRollbackSnapshot()
            case .resetAll:
                SGSimpleSettings.shared.restoreNamelessRollbackSnapshot()
                for key in UserDefaults.standard.dictionaryRepresentation().keys where key.hasPrefix("nameless.") { UserDefaults.standard.removeObject(forKey: key) }
                simplePromise.set(true)
            }
        },
        searchInput: { query in
            updateState { state in
                var updated = state
                updated.searchQuery = query
                return updated
            }
        }
    )

    let signal = combineLatest(simplePromise.get(), statePromise.get(), context.sharedContext.presentationData)
    |> map { _, state, presentationData -> (ItemListControllerState, (ItemListNodeState, Any)) in
        let entries = nlBuildEntries(presentationData: presentationData, state: state, simpleUpdated: true)
        let cs = ItemListControllerState(presentationData: ItemListPresentationData(presentationData), title: .text("Функции nameless"), leftNavigationButton: nil, rightNavigationButton: nil, backNavigationButton: ItemListBackButton(title: presentationData.strings.Common_Back))
        let ls = ItemListNodeState(presentationData: ItemListPresentationData(presentationData), entries: entries, style: .blocks)
        return (cs, (ls, arguments))
    }

    let controller = ItemListController(context: context, state: signal)
    presentControllerImpl = { [weak controller] c, a in
        controller?.present(c, in: .window(.root), with: a)
    }
    askForRestart = { [weak context] in
        guard let context = context else { return }
        let pd = context.sharedContext.currentPresentationData.with { $0 }
        presentControllerImpl?(
            UndoOverlayController(presentationData: pd, content: .info(title: nil, text: "Пожалуйста, перезапустите приложение", timeout: nil, customUndoText: "Перезапустить"), elevatedLayout: false, action: { action in if action == .undo { exit(0) }; return true }),
            nil
        )
    }
    return controller
}