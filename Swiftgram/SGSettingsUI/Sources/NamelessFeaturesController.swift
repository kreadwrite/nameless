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

private enum NLSection: Int32 {
    case ghostMode = 0
    case liquidGlass = 1
    case features = 2
    case about = 3
    case rollback = 4
}

private enum NLEntry: ItemListNodeEntry {
    // Ghost mode
    case ghostHeader
    case hideOnline(Bool)
    case hideTyping(Bool)
    case hideUploadPhoto(Bool)
    case hideUploadFile(Bool)
    case hideUploadVideo(Bool)
    case hideRecordVideo(Bool)
    case hideChooseLocation(Bool)
    case hideReadReceipts(Bool)
    case hideStoryReadReceipts(Bool)
    case ghostInfo
    // Liquid glass
    case liquidGlassHeader
    case lgMessages(Bool)
    case lgSettings(Bool)
    case lgProfile(Bool)
    case lgProfileGifts(Bool)
    case lgInlineButtons(Bool)
    case lgTinting(Bool)
    case liquidGlassInfo
    // Features
    case featuresHeader
    case showDeletedMessages(Bool)
    case saveDeletedMedia(Bool)
    case saveEditHistory(Bool)
    case localMessageEditing(Bool)
    case disableAllAds(Bool)
    case saveProtectedContent(Bool)
    case disableScreenshotDetection(Bool)
    case scrollToTopButton(Bool)
    case unlimitedFavoriteStickers(Bool)
    case enableTelescope(Bool)
    case emojiDownloader(Bool)
    case videoBackground(Bool)
    // About
    case aboutHeader
    case githubLink
    case aboutInfo
    // Rollback
    case rollbackHeader
    case resetAll
    case rollbackInfo

    var section: ItemListSectionId {
        switch self {
        case .ghostHeader, .hideOnline, .hideTyping, .hideUploadPhoto, .hideUploadFile,
             .hideUploadVideo, .hideRecordVideo, .hideChooseLocation, .hideReadReceipts,
             .hideStoryReadReceipts, .ghostInfo:
            return NLSection.ghostMode.rawValue
        case .liquidGlassHeader, .lgMessages, .lgSettings, .lgProfile, .lgProfileGifts,
             .lgInlineButtons, .lgTinting, .liquidGlassInfo:
            return NLSection.liquidGlass.rawValue
        case .featuresHeader, .showDeletedMessages, .saveDeletedMedia, .saveEditHistory,
             .localMessageEditing, .disableAllAds, .saveProtectedContent, .disableScreenshotDetection,
             .scrollToTopButton, .unlimitedFavoriteStickers, .enableTelescope, .emojiDownloader,
             .videoBackground:
            return NLSection.features.rawValue
        case .aboutHeader, .githubLink, .aboutInfo:
            return NLSection.about.rawValue
        case .rollbackHeader, .resetAll, .rollbackInfo:
            return NLSection.rollback.rawValue
        }
    }

    var stableId: Int32 {
        switch self {
        case .ghostHeader: return 0
        case .hideOnline: return 1
        case .hideTyping: return 2
        case .hideUploadPhoto: return 3
        case .hideUploadFile: return 4
        case .hideUploadVideo: return 5
        case .hideRecordVideo: return 6
        case .hideChooseLocation: return 7
        case .hideReadReceipts: return 8
        case .hideStoryReadReceipts: return 9
        case .ghostInfo: return 10
        case .liquidGlassHeader: return 100
        case .lgMessages: return 101
        case .lgSettings: return 102
        case .lgProfile: return 103
        case .lgProfileGifts: return 104
        case .lgInlineButtons: return 105
        case .lgTinting: return 106
        case .liquidGlassInfo: return 107
        case .featuresHeader: return 200
        case .showDeletedMessages: return 201
        case .saveDeletedMedia: return 202
        case .saveEditHistory: return 203
        case .localMessageEditing: return 204
        case .disableAllAds: return 205
        case .saveProtectedContent: return 206
        case .disableScreenshotDetection: return 207
        case .scrollToTopButton: return 208
        case .unlimitedFavoriteStickers: return 209
        case .enableTelescope: return 210
        case .emojiDownloader: return 211
        case .videoBackground: return 212
        case .aboutHeader: return 300
        case .githubLink: return 301
        case .aboutInfo: return 302
        case .rollbackHeader: return 400
        case .resetAll: return 401
        case .rollbackInfo: return 402
        }
    }

    static func < (lhs: NLEntry, rhs: NLEntry) -> Bool {
        lhs.stableId < rhs.stableId
    }

    static func == (lhs: NLEntry, rhs: NLEntry) -> Bool {
        switch (lhs, rhs) {
        case (.ghostHeader, .ghostHeader): return true
        case (let .hideOnline(a), let .hideOnline(b)): return a == b
        case (let .hideTyping(a), let .hideTyping(b)): return a == b
        case (let .hideUploadPhoto(a), let .hideUploadPhoto(b)): return a == b
        case (let .hideUploadFile(a), let .hideUploadFile(b)): return a == b
        case (let .hideUploadVideo(a), let .hideUploadVideo(b)): return a == b
        case (let .hideRecordVideo(a), let .hideRecordVideo(b)): return a == b
        case (let .hideChooseLocation(a), let .hideChooseLocation(b)): return a == b
        case (let .hideReadReceipts(a), let .hideReadReceipts(b)): return a == b
        case (let .hideStoryReadReceipts(a), let .hideStoryReadReceipts(b)): return a == b
        case (.ghostInfo, .ghostInfo): return true
        case (.liquidGlassHeader, .liquidGlassHeader): return true
        case (let .lgMessages(a), let .lgMessages(b)): return a == b
        case (let .lgSettings(a), let .lgSettings(b)): return a == b
        case (let .lgProfile(a), let .lgProfile(b)): return a == b
        case (let .lgProfileGifts(a), let .lgProfileGifts(b)): return a == b
        case (let .lgInlineButtons(a), let .lgInlineButtons(b)): return a == b
        case (let .lgTinting(a), let .lgTinting(b)): return a == b
        case (.liquidGlassInfo, .liquidGlassInfo): return true
        case (.featuresHeader, .featuresHeader): return true
        case (let .showDeletedMessages(a), let .showDeletedMessages(b)): return a == b
        case (let .saveDeletedMedia(a), let .saveDeletedMedia(b)): return a == b
        case (let .saveEditHistory(a), let .saveEditHistory(b)): return a == b
        case (let .localMessageEditing(a), let .localMessageEditing(b)): return a == b
        case (let .disableAllAds(a), let .disableAllAds(b)): return a == b
        case (let .saveProtectedContent(a), let .saveProtectedContent(b)): return a == b
        case (let .disableScreenshotDetection(a), let .disableScreenshotDetection(b)): return a == b
        case (let .scrollToTopButton(a), let .scrollToTopButton(b)): return a == b
        case (let .unlimitedFavoriteStickers(a), let .unlimitedFavoriteStickers(b)): return a == b
        case (let .enableTelescope(a), let .enableTelescope(b)): return a == b
        case (let .emojiDownloader(a), let .emojiDownloader(b)): return a == b
        case (let .videoBackground(a), let .videoBackground(b)): return a == b
        case (.aboutHeader, .aboutHeader): return true
        case (.githubLink, .githubLink): return true
        case (.aboutInfo, .aboutInfo): return true
        case (.rollbackHeader, .rollbackHeader): return true
        case (.resetAll, .resetAll): return true
        case (.rollbackInfo, .rollbackInfo): return true
        default: return false
        }
    }

    func item(presentationData: ItemListPresentationData, arguments: Any) -> ListViewItem {
        switch self {
        case .ghostHeader:
            return ItemListSectionHeaderItem(presentationData: presentationData, text: "РЕЖИМ ПРИЗРАКА", sectionId: self.section)
        case let .hideOnline(value):
            return ItemListSwitchItem(presentationData: presentationData, title: "Скрыть онлайн-статус", value: value, sectionId: self.section, style: .blocks, updated: { v in
                UserDefaults.standard.set(v, forKey: "nameless.disableOnlineStatus")
            })
        case let .hideTyping(value):
            return ItemListSwitchItem(presentationData: presentationData, title: "Скрыть статус набора", value: value, sectionId: self.section, style: .blocks, updated: { v in
                UserDefaults.standard.set(v, forKey: "nameless.disableTypingStatus")
            })
        case let .hideUploadPhoto(value):
            return ItemListSwitchItem(presentationData: presentationData, title: "Скрыть отправку фото", value: value, sectionId: self.section, style: .blocks, updated: { v in
                UserDefaults.standard.set(v, forKey: "nameless.disableUploadingPhotoStatus")
            })
        case let .hideUploadFile(value):
            return ItemListSwitchItem(presentationData: presentationData, title: "Скрыть отправку файла", value: value, sectionId: self.section, style: .blocks, updated: { v in
                UserDefaults.standard.set(v, forKey: "nameless.disableUploadingFileStatus")
            })
        case let .hideUploadVideo(value):
            return ItemListSwitchItem(presentationData: presentationData, title: "Скрыть отправку видео", value: value, sectionId: self.section, style: .blocks, updated: { v in
                UserDefaults.standard.set(v, forKey: "nameless.disableUploadingVideoStatus")
            })
        case let .hideRecordVideo(value):
            return ItemListSwitchItem(presentationData: presentationData, title: "Скрыть запись видео", value: value, sectionId: self.section, style: .blocks, updated: { v in
                UserDefaults.standard.set(v, forKey: "nameless.disableRecordingVideoStatus")
            })
        case let .hideChooseLocation(value):
            return ItemListSwitchItem(presentationData: presentationData, title: "Скрыть выбор локации", value: value, sectionId: self.section, style: .blocks, updated: { v in
                UserDefaults.standard.set(v, forKey: "nameless.disableChoosingLocationStatus")
            })
        case let .hideReadReceipts(value):
            return ItemListSwitchItem(presentationData: presentationData, title: "Скрыть чтение сообщений", value: value, sectionId: self.section, style: .blocks, updated: { v in
                UserDefaults.standard.set(v, forKey: "nameless.disableMessageReadReceipt")
            })
        case let .hideStoryReadReceipts(value):
            return ItemListSwitchItem(presentationData: presentationData, title: "Скрыть чтение историй", value: value, sectionId: self.section, style: .blocks, updated: { v in
                UserDefaults.standard.set(v, forKey: "nameless.disableStoryReadReceipt")
            })
        case .ghostInfo:
            return ItemListTextItem(presentationData: presentationData, text: .plain("Включённые пункты скрывают ваши действия от других пользователей."), sectionId: self.section)

        case .liquidGlassHeader:
            return ItemListSectionHeaderItem(presentationData: presentationData, text: "ЖИДКОЕ СТЕКЛО", sectionId: self.section)
        case let .lgMessages(value):
            return ItemListSwitchItem(presentationData: presentationData, title: "Сообщения", value: value, sectionId: self.section, style: .blocks, updated: { v in
                UserDefaults.standard.set(v, forKey: "nameless.liquidGlass.messages")
            })
        case let .lgSettings(value):
            return ItemListSwitchItem(presentationData: presentationData, title: "Настройки", value: value, sectionId: self.section, style: .blocks, updated: { v in
                UserDefaults.standard.set(v, forKey: "nameless.liquidGlass.settings")
            })
        case let .lgProfile(value):
            return ItemListSwitchItem(presentationData: presentationData, title: "Профиль", value: value, sectionId: self.section, style: .blocks, updated: { v in
                UserDefaults.standard.set(v, forKey: "nameless.liquidGlass.profile")
            })
        case let .lgProfileGifts(value):
            return ItemListSwitchItem(presentationData: presentationData, title: "Подарки профиля", value: value, sectionId: self.section, style: .blocks, updated: { v in
                UserDefaults.standard.set(v, forKey: "nameless.liquidGlass.profileGifts")
            })
        case let .lgInlineButtons(value):
            return ItemListSwitchItem(presentationData: presentationData, title: "Инлайн-кнопки", value: value, sectionId: self.section, style: .blocks, updated: { v in
                UserDefaults.standard.set(v, forKey: "nameless.liquidGlass.inlineButtons")
            })
        case let .lgTinting(value):
            return ItemListSwitchItem(presentationData: presentationData, title: "Тонирование", value: value, sectionId: self.section, style: .blocks, updated: { v in
                UserDefaults.standard.set(v, forKey: "nameless.liquidGlass.tinting")
            })
        case .liquidGlassInfo:
            return ItemListTextItem(presentationData: presentationData, text: .plain("Управление Liquid Glass-поверхностями по отдельным зонам."), sectionId: self.section)

        case .featuresHeader:
            return ItemListSectionHeaderItem(presentationData: presentationData, text: "ФУНКЦИИ NAMELESS", sectionId: self.section)
        case let .showDeletedMessages(value):
            return ItemListSwitchItem(presentationData: presentationData, title: "Сохранять удалённые сообщения", value: value, sectionId: self.section, style: .blocks, updated: { v in
                UserDefaults.standard.set(v, forKey: "nameless.showDeletedMessages")
            })
        case let .saveDeletedMedia(value):
            return ItemListSwitchItem(presentationData: presentationData, title: "Сохранять медиа удалённых", value: value, sectionId: self.section, style: .blocks, updated: { v in
                UserDefaults.standard.set(v, forKey: "nameless.saveDeletedMessagesMedia")
            })
        case let .saveEditHistory(value):
            return ItemListSwitchItem(presentationData: presentationData, title: "Сохранять историю редактирований", value: value, sectionId: self.section, style: .blocks, updated: { v in
                UserDefaults.standard.set(v, forKey: "nameless.saveEditHistory")
            })
        case let .localMessageEditing(value):
            return ItemListSwitchItem(presentationData: presentationData, title: "Локальное редактирование сообщений", value: value, sectionId: self.section, style: .blocks, updated: { v in
                UserDefaults.standard.set(v, forKey: "nameless.enableLocalMessageEditing")
            })
        case let .disableAllAds(value):
            return ItemListSwitchItem(presentationData: presentationData, title: "Отключить всю рекламу", value: value, sectionId: self.section, style: .blocks, updated: { v in
                UserDefaults.standard.set(v, forKey: "nameless.disableAllAds")
            })
        case let .saveProtectedContent(value):
            return ItemListSwitchItem(presentationData: presentationData, title: "Сохранять защищённый контент", value: value, sectionId: self.section, style: .blocks, updated: { v in
                UserDefaults.standard.set(v, forKey: "nameless.enableSavingProtectedContent")
            })
        case let .disableScreenshotDetection(value):
            return ItemListSwitchItem(presentationData: presentationData, title: "Отключить определение скриншотов", value: value, sectionId: self.section, style: .blocks, updated: { v in
                UserDefaults.standard.set(v, forKey: "nameless.disableScreenshotDetection")
            })
        case let .scrollToTopButton(value):
            return ItemListSwitchItem(presentationData: presentationData, title: "Кнопка «Наверх»", value: value, sectionId: self.section, style: .blocks, updated: { v in
                UserDefaults.standard.set(v, forKey: "nameless.scrollToTopButtonEnabled")
            })
        case let .unlimitedFavoriteStickers(value):
            return ItemListSwitchItem(presentationData: presentationData, title: "Безлимитные избранные стикеры", value: value, sectionId: self.section, style: .blocks, updated: { v in
                UserDefaults.standard.set(v, forKey: "nameless.unlimitedFavoriteStickers")
            })
        case let .enableTelescope(value):
            return ItemListSwitchItem(presentationData: presentationData, title: "Телескоп (зум камеры)", value: value, sectionId: self.section, style: .blocks, updated: { v in
                UserDefaults.standard.set(v, forKey: "nameless.enableTelescope")
            })
        case let .emojiDownloader(value):
            return ItemListSwitchItem(presentationData: presentationData, title: "Скачивание эмодзи", value: value, sectionId: self.section, style: .blocks, updated: { v in
                UserDefaults.standard.set(v, forKey: "nameless.emojiDownloaderEnabled")
            })
        case let .videoBackground(value):
            return ItemListSwitchItem(presentationData: presentationData, title: "Видео-фон чатов", value: value, sectionId: self.section, style: .blocks, updated: { v in
                UserDefaults.standard.set(v, forKey: "nameless.videoBackgroundEnabled")
            })

        case .aboutHeader:
            return ItemListSectionHeaderItem(presentationData: presentationData, text: "О NAMELESS", sectionId: self.section)
        case .githubLink:
            return ItemListActionItem(presentationData: presentationData, title: "GitHub", kind: .generic, alignment: .natural, sectionId: self.section, style: .blocks, action: {
                if let url = URL(string: "https://github.com/kreadwrite/nameless") {
                    UIApplication.shared.open(url)
                }
            })
        case .aboutInfo:
            return ItemListTextItem(presentationData: presentationData, text: .plain("nameless — кастомный Telegram-клиент на базе Swiftgram с расширенными функциями приватности и кастомизации."), sectionId: self.section)

        case .rollbackHeader:
            return ItemListSectionHeaderItem(presentationData: presentationData, text: "МГНОВЕННЫЙ ОТКАТ НАСТРОЕК", sectionId: self.section)
        case .resetAll:
            return ItemListActionItem(presentationData: presentationData, title: "Сбросить все настройки nameless", kind: .destructive, alignment: .natural, sectionId: self.section, style: .blocks, action: {
                let defaults = UserDefaults.standard
                for key in defaults.dictionaryRepresentation().keys where key.hasPrefix("nameless.") {
                    defaults.removeObject(forKey: key)
                }
            })
        case .rollbackInfo:
            return ItemListTextItem(presentationData: presentationData, text: .plain("Возвращает все настройки nameless к значениям по умолчанию. Требует перезапуск приложения."), sectionId: self.section)
        }
    }
}

private final class NLEmptyArguments {
    init() {}
}

private func nlEntries() -> [NLEntry] {
    let ud = UserDefaults.standard
    return [
        // Ghost Mode
        .ghostHeader,
        .hideOnline(ud.bool(forKey: "nameless.disableOnlineStatus")),
        .hideTyping(ud.bool(forKey: "nameless.disableTypingStatus")),
        .hideUploadPhoto(ud.bool(forKey: "nameless.disableUploadingPhotoStatus")),
        .hideUploadFile(ud.bool(forKey: "nameless.disableUploadingFileStatus")),
        .hideUploadVideo(ud.bool(forKey: "nameless.disableUploadingVideoStatus")),
        .hideRecordVideo(ud.bool(forKey: "nameless.disableRecordingVideoStatus")),
        .hideChooseLocation(ud.bool(forKey: "nameless.disableChoosingLocationStatus")),
        .hideReadReceipts(ud.bool(forKey: "nameless.disableMessageReadReceipt")),
        .hideStoryReadReceipts(ud.bool(forKey: "nameless.disableStoryReadReceipt")),
        .ghostInfo,
        // Liquid Glass
        .liquidGlassHeader,
        .lgMessages(ud.bool(forKey: "nameless.liquidGlass.messages")),
        .lgSettings(ud.bool(forKey: "nameless.liquidGlass.settings")),
        .lgProfile(ud.bool(forKey: "nameless.liquidGlass.profile")),
        .lgProfileGifts(ud.bool(forKey: "nameless.liquidGlass.profileGifts")),
        .lgInlineButtons(ud.bool(forKey: "nameless.liquidGlass.inlineButtons")),
        .lgTinting(ud.bool(forKey: "nameless.liquidGlass.tinting")),
        .liquidGlassInfo,
        // Features
        .featuresHeader,
        .showDeletedMessages(ud.bool(forKey: "nameless.showDeletedMessages")),
        .saveDeletedMedia(ud.bool(forKey: "nameless.saveDeletedMessagesMedia")),
        .saveEditHistory(ud.bool(forKey: "nameless.saveEditHistory")),
        .localMessageEditing(ud.bool(forKey: "nameless.enableLocalMessageEditing")),
        .disableAllAds(ud.bool(forKey: "nameless.disableAllAds")),
        .saveProtectedContent(ud.bool(forKey: "nameless.enableSavingProtectedContent")),
        .disableScreenshotDetection(ud.bool(forKey: "nameless.disableScreenshotDetection")),
        .scrollToTopButton(ud.bool(forKey: "nameless.scrollToTopButtonEnabled")),
        .unlimitedFavoriteStickers(ud.bool(forKey: "nameless.unlimitedFavoriteStickers")),
        .enableTelescope(ud.bool(forKey: "nameless.enableTelescope")),
        .emojiDownloader(ud.bool(forKey: "nameless.emojiDownloaderEnabled")),
        .videoBackground(ud.bool(forKey: "nameless.videoBackgroundEnabled")),
        // About
        .aboutHeader,
        .githubLink,
        .aboutInfo,
        // Rollback
        .rollbackHeader,
        .resetAll,
        .rollbackInfo,
    ]
}

public func namelessFeaturesController(context: AccountContext) -> ViewController {
    let signal: Signal<(ItemListControllerState, (ItemListNodeState, NLEmptyArguments)), NoError> = context.sharedContext.presentationData
        |> map { presentationData -> (ItemListControllerState, (ItemListNodeState, NLEmptyArguments)) in
            let controllerState = ItemListControllerState(
                presentationData: ItemListPresentationData(presentationData),
                title: .text("nameless"),
                leftNavigationButton: nil,
                rightNavigationButton: nil,
                backNavigationButton: ItemListBackButton(title: presentationData.strings.Common_Back)
            )
            let listState = ItemListNodeState(
                presentationData: ItemListPresentationData(presentationData),
                entries: nlEntries(),
                style: .blocks
            )
            return (controllerState, (listState, NLEmptyArguments()))
    }

    let controller: ViewController = ItemListController(context: context, state: signal)
    return controller
}