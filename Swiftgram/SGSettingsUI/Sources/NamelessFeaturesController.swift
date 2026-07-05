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

// MARK: - Data Models

private struct NLToggle {
    let title: String
    let key: String
    let description: String?
    
    init(_ title: String, _ key: String, _ description: String? = nil) {
        self.title = title
        self.key = key
        self.description = description
    }
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
        switch self {
        case .appearance:
            return [
                NLToggle("Скрыть номер телефона", "nameless.hidePhoneInSettings"),
                NLToggle("Показывать имена вкладок", "nameless.showTabNames"),
                NLToggle("Широкая панель вкладок", "nameless.wideTabBar"),
                NLToggle("Панель форматирования", "nameless.formattingPanel"),
            ]
        case .messages:
            return [
                NLToggle("Показывать удалённые сообщения", "nameless.showDeletedMessages"),
                NLToggle("Сохранять медиа удалённых", "nameless.saveDeletedMessagesMedia"),
                NLToggle("Сохранять историю редактирований", "nameless.saveEditHistory"),
                NLToggle("Локальное редактирование сообщений", "nameless.enableLocalMessageEditing"),
                NLToggle("Кнопка «Наверх»", "nameless.scrollToTopButtonEnabled"),
                NLToggle("Кнопка «В избранное» в меню", "nameless.bookmarkInMenu"),
                NLToggle("Скрыть реакции", "nameless.hideReactions"),
                NLToggle("Показывать время у действий", "nameless.showActionTimestamps"),
                NLToggle("Авто-форматирование текста", "nameless.autoTextFormatting"),
                NLToggle("Скрыть подарки", "nameless.hideGifts"),
            ]
        case .camera:
            return [
                NLToggle("Телескоп (зум камеры)", "nameless.enableTelescope"),
                NLToggle("Начинать с задней камеры", "nameless.startTelescopeWithRearCam"),
                NLToggle("Скрыть камеру в галерее", "nameless.hideGalleryCamera"),
                NLToggle("Видео-фон чатов", "nameless.videoBackgroundEnabled"),
                NLToggle("Скачивание эмодзи", "nameless.emojiDownloaderEnabled"),
            ]
        case .ghostMode:
            return [
                NLToggle("Всегда онлайн", "nameless.ghost.alwaysOnline"),
                NLToggle("Скрыть онлайн-статус", "nameless.disableOnlineStatus"),
                NLToggle("Скрыть статус набора текста", "nameless.disableTypingStatus"),
                NLToggle("Скрыть статус записи голосового", "nameless.disableRecordingVoiceStatus"),
                NLToggle("Скрыть статус загрузки файлов", "nameless.disableUploadingFileStatus"),
                NLToggle("Скрыть прочтение сообщений", "nameless.disableMessageReadReceipt"),
                NLToggle("Скрыть просмотр сторис", "nameless.disableStoryReadReceipt"),
                NLToggle("Читать при действиях", "nameless.ghost.readOnAction"),
                NLToggle("Отложенная отправка", "nameless.ghost.delayedSend", "12 сек"),
                NLToggle("Имя устройства", "nameless.ghost.deviceName"),
                NLToggle("Подмена геолокации", "nameless.ghost.fakeGeo"),
                NLToggle("Автоматически отправлять записи одноразово", "nameless.ghost.autoOneTime"),
                NLToggle("История онлайн", "nameless.ghost.onlineHistory"),
            ]
        case .liquidGlass:
            return [
                NLToggle("Сообщения", "nameless.liquidGlass.messages"),
                NLToggle("Настройки", "nameless.liquidGlass.settings"),
                NLToggle("Профиль", "nameless.liquidGlass.profile"),
                NLToggle("Подарки профиля", "nameless.liquidGlass.profileGifts"),
                NLToggle("Инлайн-кнопки", "nameless.liquidGlass.inlineButtons"),
                NLToggle("Тонирование", "nameless.liquidGlass.tinting"),
            ]
        case .privacy:
            return [
                NLToggle("Отключить рекламу в каналах", "nameless.disableAllAds"),
                NLToggle("Сохранять защищённый контент", "nameless.enableSavingProtectedContent"),
                NLToggle("Отключить определение скриншотов", "nameless.disableScreenshotDetection"),
                NLToggle("Скрыть статус отправки фото", "nameless.disableUploadingPhotoStatus"),
                NLToggle("Скрыть отправку видео", "nameless.disableUploadingVideoStatus"),
                NLToggle("Скрыть запись видео", "nameless.disableRecordingVideoStatus"),
                NLToggle("Скрыть выбор локации", "nameless.disableChoosingLocationStatus"),
                NLToggle("Скрыть чтение историй", "nameless.ghost.hideStoryRead"),
                NLToggle("Без переключения каналов", "nameless.noChannelSwitch"),
            ]
        case .information:
            return [
                NLToggle("ID и DC в профиле", "nameless.showProfileId"),
                NLToggle("Секунды в метке времени", "nameless.secondsInTimestamp"),
                NLToggle("Полные просмотры", "nameless.fullViews"),
                NLToggle("Скрыть номер телефона", "nameless.hidePhoneNumber"),
                NLToggle("Дата создания чата/канала", "nameless.showChatCreationDate"),
                NLToggle("Визуальный юзернейм", "nameless.visualUsername"),
                NLToggle("В контактах", "nameless.showMutualContacts"),
                NLToggle("Приблизительная дата регистрации", "nameless.showRegistrationDate"),
            ]
        case .additional:
            return [
                NLToggle("Локальный премиум", "nameless.localPremium"),
                NLToggle("Кнопка «Перевести» всегда видима", "nameless.alwaysShowTranslate"),
                NLToggle("Zalgo-фильтр", "nameless.zalgoFilter"),
                NLToggle("Вибрация в приложении", "nameless.appVibration"),
                NLToggle("Бесконечные стикеры", "nameless.unlimitedStickers"),
                NLToggle("Бесконечные избранные стикеры", "nameless.unlimitedFavoriteStickers"),
                NLToggle("Ускорение отправки", "nameless.uploadSpeedBoost"),
                NLToggle("Ускорение загрузки", "nameless.downloadSpeedBoost"),
            ]
        }
    }
}

// MARK: - Main Category List Controller

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
        case .categoryHeader, .categoryItem:
            return MainSection.categories.rawValue
        case .actionHeader, .exportSettings, .importSettings, .saveKeychain, .resetAll, .rollbackInfo:
            return MainSection.actions.rawValue
        }
    }
    
    var stableId: Int32 {
        switch self {
        case .categoryHeader: return 0
        case let .categoryItem(idx, _, _): return Int32(100 + idx)
        case .actionHeader: return 200
        case .exportSettings: return 201
        case .importSettings: return 202
        case .saveKeychain: return 203
        case .resetAll: return 204
        case .rollbackInfo: return 205
        }
    }
    
    static func < (lhs: MainEntry, rhs: MainEntry) -> Bool {
        lhs.stableId < rhs.stableId
    }
    
    static func == (lhs: MainEntry, rhs: MainEntry) -> Bool {
        switch (lhs, rhs) {
        case (.categoryHeader, .categoryHeader): return true
        case let (.categoryItem(a, b, c), .categoryItem(d, e, f)): return a == d && b == e && c == f
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
            return ItemListDisclosureItem(
                presentationData: presentationData,
                title: title,
                label: "\(count) функций",
                sectionId: self.section,
                style: .blocks,
                action: {
                    args.openCategory?(title)
                }
            )
        case .actionHeader:
            return ItemListSectionHeaderItem(presentationData: presentationData, text: "НАСТРОЙКИ", sectionId: self.section)
        case .exportSettings:
            return ItemListActionItem(presentationData: presentationData, title: "Экспорт настроек в JSON", kind: .generic, alignment: .natural, sectionId: self.section, style: .blocks, action: {
                args.exportSettings?()
            })
        case .importSettings:
            return ItemListActionItem(presentationData: presentationData, title: "Импорт настроек из JSON", kind: .generic, alignment: .natural, sectionId: self.section, style: .blocks, action: {
                args.importSettings?()
            })
        case .saveKeychain:
            return ItemListActionItem(presentationData: presentationData, title: "Сохранить настройки в Keychain", kind: .generic, alignment: .natural, sectionId: self.section, style: .blocks, action: {
                args.saveKeychain?()
            })
        case .resetAll:
            return ItemListActionItem(presentationData: presentationData, title: "Сбросить все настройки nameless", kind: .destructive, alignment: .natural, sectionId: self.section, style: .blocks, action: {
                args.resetAll?()
            })
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
    
    init(
        openCategory: ((String) -> Void)?,
        exportSettings: (() -> Void)?,
        importSettings: (() -> Void)?,
        saveKeychain: (() -> Void)?,
        resetAll: (() -> Void)?
    ) {
        self.openCategory = openCategory
        self.exportSettings = exportSettings
        self.importSettings = importSettings
        self.saveKeychain = saveKeychain
        self.resetAll = resetAll
    }
}

private func mainEntries() -> [MainEntry] {
    var entries: [MainEntry] = [.categoryHeader]
    
    for cat in NLCategory.allCases {
        entries.append(.categoryItem(cat.rawValue, cat.title, String(cat.toggles.count)))
    }
    
    entries.append(.actionHeader)
    entries.append(.exportSettings)
    entries.append(.importSettings)
    entries.append(.saveKeychain)
    entries.append(.resetAll)
    entries.append(.rollbackInfo)
    
    return entries
}

// MARK: - Category Detail Controller (toggles)

private enum CatSection: Int32 {
    case toggles = 0
    case info = 1
}

private enum CatEntry: ItemListNodeEntry {
    case toggleHeader(String)
    case toggleItem(Int, String, String, Bool)
    case infoText(String)
    
    var section: ItemListSectionId {
        switch self {
        case .toggleHeader, .toggleItem:
            return CatSection.toggles.rawValue
        case .infoText:
            return CatSection.info.rawValue
        }
    }
    
    var stableId: Int32 {
        switch self {
        case .toggleHeader: return 0
        case let .toggleItem(idx, _, _, _): return Int32(100 + idx)
        case .infoText: return 500
        }
    }
    
    static func < (lhs: CatEntry, rhs: CatEntry) -> Bool {
        lhs.stableId < rhs.stableId
    }
    
    static func == (lhs: CatEntry, rhs: CatEntry) -> Bool {
        switch (lhs, rhs) {
        case let (.toggleHeader(a), .toggleHeader(b)): return a == b
        case let (.toggleItem(a, b, c, d), .toggleItem(e, f, g, h)): return a == e && b == f && c == g && d == h
        case let (.infoText(a), .infoText(b)): return a == b
        default: return false
        }
    }
    
    func item(presentationData: ItemListPresentationData, arguments: Any) -> ListViewItem {
        switch self {
        case let .toggleHeader(title):
            return ItemListSectionHeaderItem(presentationData: presentationData, text: title.uppercased(), sectionId: self.section)
        case let .toggleItem(_, title, key, value):
            return ItemListSwitchItem(presentationData: presentationData, title: title, value: value, sectionId: self.section, style: .blocks, updated: { v in
                UserDefaults.standard.set(v, forKey: key)
            })
        case let .infoText(text):
            return ItemListTextItem(presentationData: presentationData, text: .plain(text), sectionId: self.section)
        }
    }
}

private final class CatEmptyArguments {
    init() {}
}

private func categoryEntries(category: NLCategory) -> [CatEntry] {
    var entries: [CatEntry] = []
    entries.append(.toggleHeader(category.title))
    
    let ud = UserDefaults.standard
    for (idx, toggle) in category.toggles.enumerated() {
        entries.append(.toggleItem(idx, toggle.title, toggle.key, ud.bool(forKey: toggle.key)))
    }
    
    switch category {
    case .ghostMode:
        entries.append(.infoText("Включённые пункты скрывают ваши действия от других пользователей."))
    case .liquidGlass:
        entries.append(.infoText("Управление Liquid Glass-поверхностями по отдельным зонам."))
    case .additional:
        entries.append(.infoText("Локальный премиум убирает ограничения premium-функций на устройстве."))
    default:
        break
    }
    
    return entries
}

// MARK: - Public API

public func namelessFeaturesController(context: AccountContext) -> ViewController {
    let openCategory: (String) -> Void = { categoryName in
        guard let navigationController = context.sharedContext.mainWindow?.viewController as? NavigationController else { return }
        for cat in NLCategory.allCases where cat.title == categoryName {
            navigationController.pushViewController(categoryDetailController(context: context, category: cat))
            return
        }
    }
    
    let exportAction: () -> Void = {
        let defaults = UserDefaults.standard
        var dict: [String: Any] = [:]
        for key in defaults.dictionaryRepresentation().keys where key.hasPrefix("nameless.") {
            dict[key] = defaults.object(forKey: key)
        }
        if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
           let str = String(data: data, encoding: .utf8) {
            UIPasteboard.general.string = str
        }
    }
    
    let importAction: () -> Void = {
        if let str = UIPasteboard.general.string,
           let data = str.data(using: .utf8),
           let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            let defaults = UserDefaults.standard
            for (key, value) in dict where key.hasPrefix("nameless.") {
                defaults.set(value, forKey: key)
            }
        }
    }
    
    let saveKeychainAction: () -> Void = {
        let defaults = UserDefaults.standard
        for key in defaults.dictionaryRepresentation().keys where key.hasPrefix("nameless.") {
            if let value = defaults.object(forKey: key) {
                let data = try? NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
                if let data = data {
                    let query: [String: Any] = [
                        kSecClass as String: kSecClassGenericPassword,
                        kSecAttrAccount as String: key,
                        kSecValueData as String: data
                    ]
                    SecItemDelete(query as CFDictionary)
                    SecItemAdd(query as CFDictionary, nil)
                }
            }
        }
    }
    
    let resetAction: () -> Void = {
        let defaults = UserDefaults.standard
        for key in defaults.dictionaryRepresentation().keys where key.hasPrefix("nameless.") {
            defaults.removeObject(forKey: key)
        }
    }
    
    let arguments = MainArguments(
        openCategory: openCategory,
        exportSettings: exportAction,
        importSettings: importAction,
        saveKeychain: saveKeychainAction,
        resetAll: resetAction
    )
    
    let signal: Signal<(ItemListControllerState, (ItemListNodeState, MainArguments)), NoError> = context.sharedContext.presentationData
        |> map { presentationData -> (ItemListControllerState, (ItemListNodeState, MainArguments)) in
            let controllerState = ItemListControllerState(
                presentationData: ItemListPresentationData(presentationData),
                title: .text("Функции nameless"),
                leftNavigationButton: nil,
                rightNavigationButton: nil,
                backNavigationButton: ItemListBackButton(title: presentationData.strings.Common_Back)
            )
            let listState = ItemListNodeState(
                presentationData: ItemListPresentationData(presentationData),
                entries: mainEntries(),
                style: .blocks
            )
            return (controllerState, (listState, arguments))
    }

    let controller: ViewController = ItemListController(context: context, state: signal)
    return controller
}

private func categoryDetailController(context: AccountContext, category: NLCategory) -> ViewController {
    let signal: Signal<(ItemListControllerState, (ItemListNodeState, CatEmptyArguments)), NoError> = context.sharedContext.presentationData
        |> map { presentationData -> (ItemListControllerState, (ItemListNodeState, CatEmptyArguments)) in
            let controllerState = ItemListControllerState(
                presentationData: ItemListPresentationData(presentationData),
                title: .text(category.title),
                leftNavigationButton: nil,
                rightNavigationButton: nil,
                backNavigationButton: ItemListBackButton(title: presentationData.strings.Common_Back)
            )
            let listState = ItemListNodeState(
                presentationData: ItemListPresentationData(presentationData),
                entries: categoryEntries(category: category),
                style: .blocks
            )
            return (controllerState, (listState, CatEmptyArguments()))
    }

    let controller: ViewController = ItemListController(context: context, state: signal)
    return controller
}