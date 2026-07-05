// MARK: nameless
import SGSimpleSettings
import Foundation
import UIKit
import Display
import SwiftSignalKit
import AccountContext
import ItemListUI
import TelegramPresentationData
import PresentationDataUtils
import UndoUI

// MARK: - Data Model

private struct NLToggle {
    let title: String
    let read: () -> Bool
    let write: (Bool) -> Void
}

private enum NLCategory: Int, CaseIterable {
    case appearance = 0
    case messages = 1
    case camera = 2
    case ghostMode = 3
    case liquidGlass = 4
    case privacy = 5
    case information = 6
    case additional = 7
    
    var title: String {
        switch self {
        case .appearance: return "Внешний вид"
        case .messages: return "Сообщения"
        case .camera: return "Камера"
        case .ghostMode: return "Режим призрака"
        case .liquidGlass: return "Жидкое стекло"
        case .privacy: return "Конфиденциальность"
        case .information: return "Информация"
        case .additional: return "Дополнительно"
        }
    }
    
    var toggles: [NLToggle] {
        let s = SGSimpleSettings.shared
        switch self {
        case .appearance:
            return [
                NLToggle("Скрыть номер телефона", read: { s.hidePhoneInSettings }, write: { s.hidePhoneInSettings = $0 }),
                NLToggle("Показывать имена вкладок", read: { s.showTabNames }, write: { s.showTabNames = $0 }),
                NLToggle("Широкая панель вкладок", read: { s.wideTabBar }, write: { s.wideTabBar = $0 }),
                NLToggle("Скрыть истории", read: { s.hideStories }, write: { s.hideStories = $0 }),
                NLToggle("Компактный список чатов", read: { s.compactChatList }, write: { s.compactChatList = $0 }),
                NLToggle("Скрыть кнопку записи в панели", read: { s.hideRecordingButton }, write: { s.hideRecordingButton = $0 }),
                NLToggle("Отправка по клавише Return", read: { s.sendWithReturnKey }, write: { s.sendWithReturnKey = $0 }),
                NLToggle("Широкие посты каналов", read: { s.wideChannelPosts }, write: { s.wideChannelPosts = $0 }),
            ]
        case .messages:
            return [
                NLToggle("Показывать удалённые сообщения", read: { s.showDeletedMessages }, write: { s.showDeletedMessages = $0 }),
                NLToggle("Сохранять медиа удалённых", read: { s.saveDeletedMessagesMedia }, write: { s.saveDeletedMessagesMedia = $0 }),
                NLToggle("Сохранять историю редактирований", read: { s.saveEditHistory }, write: { s.saveEditHistory = $0 }),
                NLToggle("Локальное редактирование сообщений", read: { s.enableLocalMessageEditing }, write: { s.enableLocalMessageEditing = $0 }),
                NLToggle("Кнопка «Наверх»", read: { s.scrollToTopButtonEnabled }, write: { s.scrollToTopButtonEnabled = $0 }),
                NLToggle("Скрыть реакции", read: { s.hideReactions }, write: { s.hideReactions = $0 }),
                NLToggle("Секунды в метке времени", read: { s.secondsInMessages }, write: { s.secondsInMessages = $0 }),
                NLToggle("Скрыть эффект удаления", read: { s.disableSnapDeletionEffect }, write: { s.disableSnapDeletionEffect = $0 }),
                NLToggle("Скрыть кнопку «Send As»", read: { s.disableSendAsButton }, write: { s.disableSendAsButton = $0 }),
                NLToggle("Скрыть кнопку канала внизу", read: { s.hideChannelBottomButton }, write: { s.hideChannelBottomButton = $0 }),
            ]
        case .camera:
            return [
                NLToggle("Телескоп (зум камеры)", read: { s.enableTelescope }, write: { s.enableTelescope = $0 }),
                NLToggle("Начинать с задней камеры", read: { s.startTelescopeWithRearCam }, write: { s.startTelescopeWithRearCam = $0 }),
                NLToggle("Скрыть камеру в галерее", read: { s.disableGalleryCamera }, write: { s.disableGalleryCamera = $0 }),
                NLToggle("Скрыть превью камеры в галерее", read: { s.disableGalleryCameraPreview }, write: { s.disableGalleryCameraPreview = $0 }),
                NLToggle("Видео-фон чатов", read: { s.namelessVideoBackgroundEnabled }, write: { s.namelessVideoBackgroundEnabled = $0 }),
                NLToggle("Скачивание эмодзи", read: { s.emojiDownloaderEnabled }, write: { s.emojiDownloaderEnabled = $0 }),
                NLToggle("Конвертировать видео в кружок/голосовое", read: { s.enableVideoToCircleOrVoice }, write: { s.enableVideoToCircleOrVoice = $0 }),
            ]
        case .ghostMode:
            return [
                NLToggle("Скрыть онлайн-статус", read: { s.disableOnlineStatus }, write: { s.disableOnlineStatus = $0 }),
                NLToggle("Скрыть статус набора текста", read: { s.disableTypingStatus }, write: { s.disableTypingStatus = $0 }),
                NLToggle("Скрыть статус записи голосового", read: { s.disableVCMessageRecordingStatus }, write: { s.disableVCMessageRecordingStatus = $0 }),
                NLToggle("Скрыть статус загрузки файлов", read: { s.disableUploadingFileStatus }, write: { s.disableUploadingFileStatus = $0 }),
                NLToggle("Скрыть отправку фото", read: { s.disableUploadingPhotoStatus }, write: { s.disableUploadingPhotoStatus = $0 }),
                NLToggle("Скрыть отправку видео", read: { s.disableUploadingVideoStatus }, write: { s.disableUploadingVideoStatus = $0 }),
                NLToggle("Скрыть запись видео", read: { s.disableRecordingVideoStatus }, write: { s.disableRecordingVideoStatus = $0 }),
                NLToggle("Скрыть выбор локации", read: { s.disableChoosingLocationStatus }, write: { s.disableChoosingLocationStatus = $0 }),
                NLToggle("Скрыть выбор контакта", read: { s.disableChoosingContactStatus }, write: { s.disableChoosingContactStatus = $0 }),
                NLToggle("Скрыть прочтение сообщений", read: { s.disableMessageReadReceipt }, write: { s.disableMessageReadReceipt = $0 }),
                NLToggle("Скрыть просмотр сторис", read: { s.disableStoryReadReceipt }, write: { s.disableStoryReadReceipt = $0 }),
                NLToggle("Скрыть статус записи круглого видео", read: { s.disableRecordingRoundVideoStatus }, write: { s.disableRecordingRoundVideoStatus = $0 }),
                NLToggle("Скрыть отправку круглого видео", read: { s.disableUploadingRoundVideoStatus }, write: { s.disableUploadingRoundVideoStatus = $0 }),
                NLToggle("Скрыть статус игры", read: { s.disablePlayingGameStatus }, write: { s.disablePlayingGameStatus = $0 }),
                NLToggle("Скрыть выбор стикера", read: { s.disableChoosingStickerStatus }, write: { s.disableChoosingStickerStatus = $0 }),
                NLToggle("Скрыть эмодзи-взаимодействие", read: { s.disableEmojiInteractionStatus }, write: { s.disableEmojiInteractionStatus = $0 }),
                NLToggle("Скрыть эмодзи-подтверждение", read: { s.disableEmojiAcknowledgementStatus }, write: { s.disableEmojiAcknowledgementStatus = $0 }),
                NLToggle("История онлайн", read: { s.enableOnlineStatusRecording }, write: { s.enableOnlineStatusRecording = $0 }),
                NLToggle("Подмена геолокации", read: { s.fakeLocationEnabled }, write: { s.fakeLocationEnabled = $0 }),
                NLToggle("Задержка отправки (призрак)", read: { s.ghostModeMessageSendDelaySeconds > 0 }, write: { s.ghostModeMessageSendDelaySeconds = $0 ? 12 : 0 }),
            ]
        case .liquidGlass:
            return [
                NLToggle("Жидкое стекло (общее)", read: { s.liquidGlassEnabled }, write: { v in s.liquidGlassEnabled = v; NotificationCenter.default.post(name: .luxgramLiquidGlassDidChange, object: nil) }),
                NLToggle("Сообщения", read: { s.namelessLiquidGlassMessages }, write: { s.namelessLiquidGlassMessages = $0; NotificationCenter.default.post(name: .luxgramLiquidGlassDidChange, object: nil) }),
                NLToggle("Настройки", read: { s.namelessLiquidGlassSettings }, write: { s.namelessLiquidGlassSettings = $0; NotificationCenter.default.post(name: .luxgramLiquidGlassDidChange, object: nil) }),
                NLToggle("Профиль", read: { s.namelessLiquidGlassProfile }, write: { s.namelessLiquidGlassProfile = $0; NotificationCenter.default.post(name: .luxgramLiquidGlassDidChange, object: nil) }),
                NLToggle("Подарки профиля", read: { s.namelessLiquidGlassProfileGifts }, write: { s.namelessLiquidGlassProfileGifts = $0; NotificationCenter.default.post(name: .luxgramLiquidGlassDidChange, object: nil) }),
                NLToggle("Инлайн-кнопки", read: { s.namelessLiquidGlassInlineButtons }, write: { s.namelessLiquidGlassInlineButtons = $0; NotificationCenter.default.post(name: .luxgramLiquidGlassDidChange, object: nil) }),
                NLToggle("Тонирование", read: { s.namelessLiquidGlassTinting }, write: { s.namelessLiquidGlassTinting = $0; NotificationCenter.default.post(name: .luxgramLiquidGlassDidChange, object: nil) }),
            ]
        case .privacy:
            return [
                NLToggle("Отключить рекламу", read: { s.disableAllAds }, write: { s.disableAllAds = $0 }),
                NLToggle("Сохранять защищённый контент", read: { s.enableSavingProtectedContent }, write: { s.enableSavingProtectedContent = $0 }),
                NLToggle("Сохранять самоуничтожающиеся сообщения", read: { s.enableSavingSelfDestructingMessages }, write: { s.enableSavingSelfDestructingMessages = $0 }),
                NLToggle("Отключить определение скриншотов", read: { s.disableScreenshotDetection }, write: { s.disableScreenshotDetection = $0 }),
                NLToggle("Отключить размытие при скриншоте (секретные чаты)", read: { s.disableSecretChatBlurOnScreenshot }, write: { s.disableSecretChatBlurOnScreenshot = $0 }),
                NLToggle("Скрыть статус отправки фото", read: { s.disableUploadingPhotoStatus }, write: { s.disableUploadingPhotoStatus = $0 }),
                NLToggle("Скрыть отправку видео", read: { s.disableUploadingVideoStatus }, write: { s.disableUploadingVideoStatus = $0 }),
                NLToggle("Скрыть запись видео", read: { s.disableRecordingVideoStatus }, write: { s.disableRecordingVideoStatus = $0 }),
                NLToggle("Скрыть выбор локации", read: { s.disableChoosingLocationStatus }, write: { s.disableChoosingLocationStatus = $0 }),
                NLToggle("Скрыть просмотр сторис", read: { s.disableStoryReadReceipt }, write: { s.disableStoryReadReceipt = $0 }),
                NLToggle("Скрыть прочтение сообщений", read: { s.disableMessageReadReceipt }, write: { s.disableMessageReadReceipt = $0 }),
                NLToggle("Не скроллить к следующему каналу", read: { s.disableScrollToNextChannel }, write: { s.disableScrollToNextChannel = $0 }),
                NLToggle("Не скроллить к следующему топику", read: { s.disableScrollToNextTopic }, write: { s.disableScrollToNextTopic = $0 }),
            ]
        case .information:
            return [
                NLToggle("ID и DC в профиле", read: { s.showProfileId }, write: { s.showProfileId = $0 }),
                NLToggle("Показывать DC", read: { s.showDC }, write: { s.showDC = $0 }),
                NLToggle("Дата создания чата/канала", read: { s.showCreationDate }, write: { s.showCreationDate = $0 }),
                NLToggle("Дата регистрации пользователя", read: { s.showRegDate }, write: { s.showRegDate = $0 }),
                NLToggle("Компактные числа", read: { !s.disableCompactNumbers }, write: { s.disableCompactNumbers = !$0 }),
            ]
        case .additional:
            return [
                NLToggle("Локальный премиум", read: { s.enableLocalPremium }, write: { s.enableLocalPremium = $0 }),
                NLToggle("Кнопка «Перевести» всегда видима", read: { s.quickTranslateButton }, write: { s.quickTranslateButton = $0 }),
                NLToggle("Zalgo-фильтр", read: { s.disableZalgoText }, write: { s.disableZalgoText = $0 }),
                NLToggle("Ускорение отправки", read: { s.uploadSpeedBoost }, write: { s.uploadSpeedBoost = $0 }),
                NLToggle("Ускорение загрузки", read: { s.downloadSpeedBoost != "none" }, write: { s.downloadSpeedBoost = $0 ? "6" : "none" }),
                NLToggle("Безлимитные избранные стикеры", read: { s.unlimitedFavoriteStickers }, write: { s.unlimitedFavoriteStickers = $0 }),
                NLToggle("Размер стикеров (%)", read: { s.stickerSize == 100 }, write: { s.stickerSize = $0 ? 100 : 120 }),
                NLToggle("Временные метки на стикерах", read: { s.stickerTimestamp }, write: { s.stickerTimestamp = $0 }),
                NLToggle("Скрыть свайп для записи сторис", read: { s.disableSwipeToRecordStory }, write: { s.disableSwipeToRecordStory = $0 }),
                NLToggle("Предупреждение при открытии сторис", read: { s.warnOnStoriesOpen }, write: { s.warnOnStoriesOpen = $0 }),
                NLToggle("Stealth-режим сторис", read: { s.storyStealthMode }, write: { s.storyStealthMode = $0 }),
                NLToggle("Подтверждение звонков", read: { s.confirmCalls }, write: { s.confirmCalls = $0 }),
                NLToggle("Запоминать последнюю папку", read: { s.rememberLastFolder }, write: { s.rememberLastFolder = $0 }),
                NLToggle("Системный шэринг", read: { s.forceSystemSharing }, write: { s.forceSystemSharing = $0 }),
                NLToggle("Качество исходящих фото (%)", read: { s.outgoingPhotoQuality == 70 }, write: { s.outgoingPhotoQuality = $0 ? 70 : 80 }),
            ]
        }
    }
}

// MARK: - Main Category List

private enum MainSection: Int32 {
    case categories = 0
    case actions = 1
}

private enum MainEntry: ItemListNodeEntry {
    case categoryHeader
    case categoryItem(Int, String, String)
    case actionHeader
    case exportSettings
    case importSettings
    case saveKeychain
    case resetAll
    case rollbackInfo
    
    var section: ItemListSectionId {
        switch self {
        case .categoryHeader, .categoryItem: return MainSection.categories.rawValue
        case .actionHeader, .exportSettings, .importSettings, .saveKeychain, .resetAll, .rollbackInfo: return MainSection.actions.rawValue
        }
    }
    var stableId: Int32 {
        switch self {
        case .categoryHeader: return 0
        case let .categoryItem(i, _, _): return Int32(100 + i)
        case .actionHeader: return 200
        case .exportSettings: return 201
        case .importSettings: return 202
        case .saveKeychain: return 203
        case .resetAll: return 204
        case .rollbackInfo: return 205
        }
    }
    static func < (lhs: MainEntry, rhs: MainEntry) -> Bool { lhs.stableId < rhs.stableId }
    static func == (lhs: MainEntry, rhs: MainEntry) -> Bool {
        switch (lhs, rhs) {
        case (.categoryHeader, .categoryHeader): return true
        case let (.categoryItem(a,b,c), .categoryItem(d,e,f)): return a==d && b==e && c==f
        case (.actionHeader, .actionHeader): return true
        case (.exportSettings, .exportSettings): return true
        case (.importSettings, .importSettings): return true
        case (.saveKeychain, .saveKeychain): return true
        case (.resetAll, .resetAll): return true
        case (.rollbackInfo, .rollbackInfo): return true
        default: return false
        }
    }
    func item(presentationData: ItemListPresentationData, arguments: Any) -> ListViewItem {
        guard let args = arguments as? MainArguments else {
            return ItemListTextItem(presentationData: presentationData, text: .plain(""), sectionId: 0)
        }
        switch self {
        case .categoryHeader:
            return ItemListSectionHeaderItem(presentationData: presentationData, text: "ФУНКЦИИ NAMELESS", sectionId: self.section)
        case let .categoryItem(_, title, count):
            return ItemListDisclosureItem(presentationData: presentationData, title: title, label: "\(count)", sectionId: self.section, style: .blocks, action: { args.openCategory?(title) })
        case .actionHeader:
            return ItemListSectionHeaderItem(presentationData: presentationData, text: "НАСТРОЙКИ", sectionId: self.section)
        case .exportSettings:
            return ItemListActionItem(presentationData: presentationData, title: "Экспорт настроек в JSON", kind: .generic, alignment: .natural, sectionId: self.section, style: .blocks, action: { args.exportSettings?() })
        case .importSettings:
            return ItemListActionItem(presentationData: presentationData, title: "Импорт настроек из JSON", kind: .generic, alignment: .natural, sectionId: self.section, style: .blocks, action: { args.importSettings?() })
        case .saveKeychain:
            return ItemListActionItem(presentationData: presentationData, title: "Сохранить настройки в Keychain", kind: .generic, alignment: .natural, sectionId: self.section, style: .blocks, action: { args.saveKeychain?() })
        case .resetAll:
            return ItemListActionItem(presentationData: presentationData, title: "Сбросить все настройки nameless", kind: .destructive, alignment: .natural, sectionId: self.section, style: .blocks, action: { args.resetAll?() })
        case .rollbackInfo:
            return ItemListTextItem(presentationData: presentationData, text: .plain("Возвращает все настройки nameless к значениям по умолчанию. Требует перезапуск приложения."), sectionId: self.section)
        }
    }
}

private final class MainArguments {
    let openCategory: ((String) -> Void)?
    let exportSettings: (() -> Void)?
    let importSettings: (() -> Void)?
    let saveKeychain: (() -> Void)?
    let resetAll: (() -> Void)?
    init(openCategory: ((String) -> Void)?, exportSettings: (() -> Void)?, importSettings: (() -> Void)?, saveKeychain: (() -> Void)?, resetAll: (() -> Void)?) {
        self.openCategory = openCategory; self.exportSettings = exportSettings; self.importSettings = importSettings; self.saveKeychain = saveKeychain; self.resetAll = resetAll
    }
}

private func mainEntries() -> [MainEntry] {
    var e: [MainEntry] = [.categoryHeader]
    for cat in NLCategory.allCases { e.append(.categoryItem(cat.rawValue, cat.title, String(cat.toggles.count))) }
    e.append(.actionHeader); e.append(.exportSettings); e.append(.importSettings); e.append(.saveKeychain); e.append(.resetAll); e.append(.rollbackInfo)
    return e
}

// MARK: - Category Detail (toggles)

private enum CatSection: Int32 { case toggles = 0, info = 1 }

private enum CatEntry: ItemListNodeEntry {
    case toggleHeader(String)
    case toggleItem(Int, String, Bool, (Bool) -> Void)
    case infoText(String)
    var section: ItemListSectionId {
        switch self { case .toggleHeader, .toggleItem: return CatSection.toggles.rawValue; case .infoText: return CatSection.info.rawValue }
    }
    var stableId: Int32 {
        switch self { case .toggleHeader: return 0; case let .toggleItem(i,_,_,_): return Int32(100+i); case .infoText: return 500 }
    }
    static func < (lhs: CatEntry, rhs: CatEntry) -> Bool { lhs.stableId < rhs.stableId }
    static func == (lhs: CatEntry, rhs: CatEntry) -> Bool {
        switch (lhs, rhs) {
        case let (.toggleHeader(a), .toggleHeader(b)): return a==b
        case let (.toggleItem(a,b,c,_), .toggleItem(d,e,f,_)): return a==d && b==e && c==f
        case let (.infoText(a), .infoText(b)): return a==b
        default: return false
        }
    }
    func item(presentationData: ItemListPresentationData, arguments: Any) -> ListViewItem {
        switch self {
        case let .toggleHeader(t): return ItemListSectionHeaderItem(presentationData: presentationData, text: t.uppercased(), sectionId: self.section)
        case let .toggleItem(_, title, value, write): return ItemListSwitchItem(presentationData: presentationData, title: title, value: value, sectionId: self.section, style: .blocks, updated: write)
        case let .infoText(t): return ItemListTextItem(presentationData: presentationData, text: .plain(t), sectionId: self.section)
        }
    }
}

private final class CatEmptyArguments { init() {} }

private func categoryEntries(category: NLCategory) -> [CatEntry] {
    var entries: [CatEntry] = [.toggleHeader(category.title)]
    for (idx, toggle) in category.toggles.enumerated() {
        let val = toggle.read()
        entries.append(.toggleItem(idx, toggle.title, val, toggle.write))
    }
    switch category {
    case .ghostMode: entries.append(.infoText("Включённые пункты скрывают ваши действия от других пользователей."))
    case .liquidGlass: entries.append(.infoText("Управление Liquid Glass-поверхностями по отдельным зонам."))
    case .additional: entries.append(.infoText("Локальный премиум убирает ограничения premium-функций на устройстве."))
    case .privacy: entries.append(.infoText("Настройки конфиденциальности и защиты контента."))
    default: break
    }
    return entries
}

// MARK: - Public API

public func namelessFeaturesController(context: AccountContext) -> ViewController {
    let openCategory: (String) -> Void = { name in
        guard let nav = context.sharedContext.mainWindow?.viewController as? NavigationController else { return }
        for cat in NLCategory.allCases where cat.title == name { nav.pushViewController(categoryDetailController(context: context, category: cat)); return }
    }
    let exportAction: () -> Void = {
        var dict: [String: Any] = [:]
        for key in UserDefaults.standard.dictionaryRepresentation().keys where key.hasPrefix("nameless.") || key.hasPrefix("VoiceMorpher.") { dict[key] = UserDefaults.standard.object(forKey: key) }
        if let d = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted), let s = String(data: d, encoding: .utf8) { UIPasteboard.general.string = s }
    }
    let importAction: () -> Void = {
        if let s = UIPasteboard.general.string, let d = s.data(using: .utf8), let dict = try? JSONSerialization.jsonObject(with: d) as? [String: Any] {
            for (k,v) in dict where k.hasPrefix("nameless.") || k.hasPrefix("VoiceMorpher.") { UserDefaults.standard.set(v, forKey: k) }
        }
    }
    let saveKeychainAction: () -> Void = { SGSimpleSettings.shared.beginNamelessRollbackSnapshot() }
    let resetAction: () -> Void = {
        SGSimpleSettings.shared.restoreNamelessRollbackSnapshot()
        let defaults = UserDefaults.standard
        for key in defaults.dictionaryRepresentation().keys where key.hasPrefix("nameless.") { defaults.removeObject(forKey: key) }
    }
    let args = MainArguments(openCategory: openCategory, exportSettings: exportAction, importSettings: importAction, saveKeychain: saveKeychainAction, resetAll: resetAction)
    let signal: Signal<(ItemListControllerState, (ItemListNodeState, MainArguments)), NoError> = context.sharedContext.presentationData
        |> map { pd -> (ItemListControllerState, (ItemListNodeState, MainArguments)) in
            let cs = ItemListControllerState(presentationData: ItemListPresentationData(pd), title: .text("Функции nameless"), leftNavigationButton: nil, rightNavigationButton: nil, backNavigationButton: ItemListBackButton(title: pd.strings.Common_Back))
            let ls = ItemListNodeState(presentationData: ItemListPresentationData(pd), entries: mainEntries(), style: .blocks)
            return (cs, (ls, args))
    }
    return ItemListController(context: context, state: signal)
}

private func categoryDetailController(context: AccountContext, category: NLCategory) -> ViewController {
    let signal: Signal<(ItemListControllerState, (ItemListNodeState, CatEmptyArguments)), NoError> = context.sharedContext.presentationData
        |> map { pd -> (ItemListControllerState, (ItemListNodeState, CatEmptyArguments)) in
            let cs = ItemListControllerState(presentationData: ItemListPresentationData(pd), title: .text(category.title), leftNavigationButton: nil, rightNavigationButton: nil, backNavigationButton: ItemListBackButton(title: pd.strings.Common_Back))
            let ls = ItemListNodeState(presentationData: ItemListPresentationData(pd), entries: categoryEntries(category: category), style: .blocks)
            return (cs, (ls, CatEmptyArguments()))
        }
    return ItemListController(context: context, state: signal)
}