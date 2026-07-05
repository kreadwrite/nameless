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
import WebKit

private enum NLSection: Int32, CaseIterable {
    case ghostMode
    case liquidGlass
    case features
    case about
    case rollback
}

private struct NLState: Equatable {
    var searchQuery: String?
}

private func nlEntries(presentationData: PresentationData, state: NLState) -> [ItemListControllerEntry] {
    var entries: [ItemListControllerEntry] = []
    let pd = ItemListPresentationData(presentationData)

    // MARK: - Ghost Mode
    entries.append(ItemListSectionHeaderItem(presentationData: pd, text: "РЕЖИМ ПРИЗРАКА", sectionId: ItemListSectionId(rawValue: NLSection.ghostMode.rawValue)))
    entries.append(ItemListSwitchItem(presentationData: pd, title: "Скрыть онлайн-статус", value: UserDefaults.standard.bool(forKey: "nameless.disableOnlineStatus"), sectionId: ItemListSectionId(rawValue: NLSection.ghostMode.rawValue), style: .blocks, updated: { _ in
        let v = !UserDefaults.standard.bool(forKey: "nameless.disableOnlineStatus")
        UserDefaults.standard.set(v, forKey: "nameless.disableOnlineStatus")
    }))
    entries.append(ItemListSwitchItem(presentationData: pd, title: "Скрыть статус набора", value: UserDefaults.standard.bool(forKey: "nameless.disableTypingStatus"), sectionId: ItemListSectionId(rawValue: NLSection.ghostMode.rawValue), style: .blocks, updated: { _ in
        let v = !UserDefaults.standard.bool(forKey: "nameless.disableTypingStatus")
        UserDefaults.standard.set(v, forKey: "nameless.disableTypingStatus")
    }))
    entries.append(ItemListSwitchItem(presentationData: pd, title: "Скрыть отправку фото", value: UserDefaults.standard.bool(forKey: "nameless.disableUploadingPhotoStatus"), sectionId: ItemListSectionId(rawValue: NLSection.ghostMode.rawValue), style: .blocks, updated: { _ in
        let v = !UserDefaults.standard.bool(forKey: "nameless.disableUploadingPhotoStatus")
        UserDefaults.standard.set(v, forKey: "nameless.disableUploadingPhotoStatus")
    }))
    entries.append(ItemListSwitchItem(presentationData: pd, title: "Скрыть отправку файла", value: UserDefaults.standard.bool(forKey: "nameless.disableUploadingFileStatus"), sectionId: ItemListSectionId(rawValue: NLSection.ghostMode.rawValue), style: .blocks, updated: { _ in
        let v = !UserDefaults.standard.bool(forKey: "nameless.disableUploadingFileStatus")
        UserDefaults.standard.set(v, forKey: "nameless.disableUploadingFileStatus")
    }))
    entries.append(ItemListSwitchItem(presentationData: pd, title: "Скрыть отправку видео", value: UserDefaults.standard.bool(forKey: "nameless.disableUploadingVideoStatus"), sectionId: ItemListSectionId(rawValue: NLSection.ghostMode.rawValue), style: .blocks, updated: { _ in
        let v = !UserDefaults.standard.bool(forKey: "nameless.disableUploadingVideoStatus")
        UserDefaults.standard.set(v, forKey: "nameless.disableUploadingVideoStatus")
    }))
    entries.append(ItemListSwitchItem(presentationData: pd, title: "Скрыть запись видео", value: UserDefaults.standard.bool(forKey: "nameless.disableRecordingVideoStatus"), sectionId: ItemListSectionId(rawValue: NLSection.ghostMode.rawValue), style: .blocks, updated: { _ in
        let v = !UserDefaults.standard.bool(forKey: "nameless.disableRecordingVideoStatus")
        UserDefaults.standard.set(v, forKey: "nameless.disableRecordingVideoStatus")
    }))
    entries.append(ItemListSwitchItem(presentationData: pd, title: "Скрыть выбор локации", value: UserDefaults.standard.bool(forKey: "nameless.disableChoosingLocationStatus"), sectionId: ItemListSectionId(rawValue: NLSection.ghostMode.rawValue), style: .blocks, updated: { _ in
        let v = !UserDefaults.standard.bool(forKey: "nameless.disableChoosingLocationStatus")
        UserDefaults.standard.set(v, forKey: "nameless.disableChoosingLocationStatus")
    }))
    entries.append(ItemListSwitchItem(presentationData: pd, title: "Скрыть чтение сообщений", value: UserDefaults.standard.bool(forKey: "nameless.disableMessageReadReceipt"), sectionId: ItemListSectionId(rawValue: NLSection.ghostMode.rawValue), style: .blocks, updated: { _ in
        let v = !UserDefaults.standard.bool(forKey: "nameless.disableMessageReadReceipt")
        UserDefaults.standard.set(v, forKey: "nameless.disableMessageReadReceipt")
    }))
    entries.append(ItemListSwitchItem(presentationData: pd, title: "Скрыть чтение историй", value: UserDefaults.standard.bool(forKey: "nameless.disableStoryReadReceipt"), sectionId: ItemListSectionId(rawValue: NLSection.ghostMode.rawValue), style: .blocks, updated: { _ in
        let v = !UserDefaults.standard.bool(forKey: "nameless.disableStoryReadReceipt")
        UserDefaults.standard.set(v, forKey: "nameless.disableStoryReadReceipt")
    }))
    entries.append(ItemListTextItem(presentationData: pd, text: .plain("Включённые пункты скрывают ваши действия от других пользователей."), sectionId: ItemListSectionId(rawValue: NLSection.ghostMode.rawValue), style: .blocks))

    // MARK: - Liquid Glass
    entries.append(ItemListSectionHeaderItem(presentationData: pd, text: "ЖИДКОЕ СТЕКЛО", sectionId: ItemListSectionId(rawValue: NLSection.liquidGlass.rawValue)))
    let lgKeys: [(String, String)] = [
        ("nameless.liquidGlass.messages", "Сообщения"),
        ("nameless.liquidGlass.settings", "Настройки"),
        ("nameless.liquidGlass.profile", "Профиль"),
        ("nameless.liquidGlass.profileGifts", "Подарки профиля"),
        ("nameless.liquidGlass.inlineButtons", "Инлайн-кнопки"),
        ("nameless.liquidGlass.tinting", "Тонирование"),
    ]
    for (key, label) in lgKeys {
        entries.append(ItemListSwitchItem(presentationData: pd, title: label, value: UserDefaults.standard.bool(forKey: key), sectionId: ItemListSectionId(rawValue: NLSection.liquidGlass.rawValue), style: .blocks, updated: { _ in
            let v = !UserDefaults.standard.bool(forKey: key)
            UserDefaults.standard.set(v, forKey: key)
        }))
    }
    entries.append(ItemListTextItem(presentationData: pd, text: .plain("Управление Liquid Glass-поверхностями по отдельным зонам."), sectionId: ItemListSectionId(rawValue: NLSection.liquidGlass.rawValue), style: .blocks))

    // MARK: - Features
    entries.append(ItemListSectionHeaderItem(presentationData: pd, text: "ФУНКЦИИ NAMELESS", sectionId: ItemListSectionId(rawValue: NLSection.features.rawValue)))
    let featureItems: [(String, String)] = [
        ("nameless.showDeletedMessages", "Сохранять удалённые сообщения"),
        ("nameless.saveDeletedMessagesMedia", "Сохранять медиа удалённых"),
        ("nameless.saveEditHistory", "Сохранять историю редактирований"),
        ("nameless.enableLocalMessageEditing", "Локальное редактирование сообщений"),
        ("nameless.disableAllAds", "Отключить всю рекламу"),
        ("nameless.enableSavingProtectedContent", "Сохранять защищённый контент"),
        ("nameless.disableScreenshotDetection", "Отключить определение скриншотов"),
        ("nameless.scrollToTopButtonEnabled", "Кнопка «Наверх»"),
        ("nameless.unlimitedFavoriteStickers", "Безлимитные избранные стикеры"),
        ("nameless.enableTelescope", "Телескоп (зум камеры)"),
        ("nameless.emojiDownloaderEnabled", "Скачивание эмодзи"),
        ("nameless.videoBackgroundEnabled", "Видео-фон чатов"),
    ]
    for (key, label) in featureItems {
        entries.append(ItemListSwitchItem(presentationData: pd, title: label, value: UserDefaults.standard.bool(forKey: key), sectionId: ItemListSectionId(rawValue: NLSection.features.rawValue), style: .blocks, updated: { _ in
            let v = !UserDefaults.standard.bool(forKey: key)
            UserDefaults.standard.set(v, forKey: key)
        }))
    }

    // MARK: - About
    entries.append(ItemListSectionHeaderItem(presentationData: pd, text: "О NAMELESS", sectionId: ItemListSectionId(rawValue: NLSection.about.rawValue)))
    entries.append(ItemListActionItem(presentationData: pd, title: "GitHub", kind: .generic, alignment: .natural, sectionId: ItemListSectionId(rawValue: NLSection.about.rawValue), style: .blocks, action: {
        if let url = URL(string: "https://github.com/kreadwrite/nameless") {
            UIApplication.shared.open(url)
        }
    }))
    entries.append(ItemListTextItem(presentationData: pd, text: .plain("nameless — кастомный Telegram-клиент на базе Swiftgram с расширенными функциями приватности и кастомизации."), sectionId: ItemListSectionId(rawValue: NLSection.about.rawValue), style: .blocks))

    // MARK: - Rollback
    entries.append(ItemListSectionHeaderItem(presentationData: pd, text: "МГНОВЕННЫЙ ОТКАТ НАСТРОЕК", sectionId: ItemListSectionId(rawValue: NLSection.rollback.rawValue)))
    entries.append(ItemListActionItem(presentationData: pd, title: "Сбросить все настройки nameless", kind: .destructive, alignment: .natural, sectionId: ItemListSectionId(rawValue: NLSection.rollback.rawValue), style: .blocks, action: {
        let defaults = UserDefaults.standard
        for key in defaults.dictionaryRepresentation().keys where key.hasPrefix("nameless.") {
            defaults.removeObject(forKey: key)
        }
    }))
    entries.append(ItemListTextItem(presentationData: pd, text: .plain("Возвращает все настройки nameless к значениям по умолчанию. Требует перезапуск приложения."), sectionId: ItemListSectionId(rawValue: NLSection.rollback.rawValue), style: .blocks))

    return entries
}

public func namelessFeaturesController(context: AccountContext) -> ViewController {
    let statePromise = ValuePromise(NLState(), ignoreRepeated: true)
    let stateValue = Atomic(value: NLState())
    let updateState: ((NLState) -> NLState) -> Void = { f in
        statePromise.set(stateValue.modify { f($0) })
    }

    let simplePromise = ValuePromise(true, ignoreRepeated: false)

    let signal = combineLatest(simplePromise.get(), statePromise.get(), context.sharedContext.presentationData)
        |> map { _, state, presentationData -> (ItemListControllerState, (ItemListNodeState, Any)) in
            let controllerState = ItemListControllerState(
                presentationData: ItemListPresentationData(presentationData),
                title: .text("nameless"),
                leftNavigationButton: nil,
                rightNavigationButton: nil,
                backNavigationButton: ItemListBackButton(title: presentationData.strings.Common_Back)
            )
            let entries = nlEntries(presentationData: presentationData, state: state)
            let listState = ItemListNodeState(
                presentationData: ItemListPresentationData(presentationData),
                entries: entries,
                style: .blocks
            )
            return (controllerState, (listState, Any.self as Any))
    }

    let controller: ViewController = ItemListController(context: context, state: signal)
    return controller
}