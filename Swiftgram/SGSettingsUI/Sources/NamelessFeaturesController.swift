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
    let strings = presentationData.strings
    
    // MARK: - Ghost Mode
    entries.append(ItemListSectionHeaderItem(text: "РЕЖИМ ПРИЗРАКА"))
    entries.append(ItemListSwitchItem(title: "Скрыть онлайн-статус", value: UserDefaults.standard.bool(forKey: "nameless.disableOnlineStatus"), style: .blocks, action: { _ in
        let v = !UserDefaults.standard.bool(forKey: "nameless.disableOnlineStatus")
        UserDefaults.standard.set(v, forKey: "nameless.disableOnlineStatus")
    }))
    entries.append(ItemListSwitchItem(title: "Скрыть статус набора", value: UserDefaults.standard.bool(forKey: "nameless.disableTypingStatus"), style: .blocks, action: { _ in
        let v = !UserDefaults.standard.bool(forKey: "nameless.disableTypingStatus")
        UserDefaults.standard.set(v, forKey: "nameless.disableTypingStatus")
    }))
    entries.append(ItemListSwitchItem(title: "Скрыть отправку фото", value: UserDefaults.standard.bool(forKey: "nameless.disableUploadingPhotoStatus"), style: .blocks, action: { _ in
        let v = !UserDefaults.standard.bool(forKey: "nameless.disableUploadingPhotoStatus")
        UserDefaults.standard.set(v, forKey: "nameless.disableUploadingPhotoStatus")
    }))
    entries.append(ItemListSwitchItem(title: "Скрыть отправку файла", value: UserDefaults.standard.bool(forKey: "nameless.disableUploadingFileStatus"), style: .blocks, action: { _ in
        let v = !UserDefaults.standard.bool(forKey: "nameless.disableUploadingFileStatus")
        UserDefaults.standard.set(v, forKey: "nameless.disableUploadingFileStatus")
    }))
    entries.append(ItemListSwitchItem(title: "Скрыть отправку видео", value: UserDefaults.standard.bool(forKey: "nameless.disableUploadingVideoStatus"), style: .blocks, action: { _ in
        let v = !UserDefaults.standard.bool(forKey: "nameless.disableUploadingVideoStatus")
        UserDefaults.standard.set(v, forKey: "nameless.disableUploadingVideoStatus")
    }))
    entries.append(ItemListSwitchItem(title: "Скрыть запись видео", value: UserDefaults.standard.bool(forKey: "nameless.disableRecordingVideoStatus"), style: .blocks, action: { _ in
        let v = !UserDefaults.standard.bool(forKey: "nameless.disableRecordingVideoStatus")
        UserDefaults.standard.set(v, forKey: "nameless.disableRecordingVideoStatus")
    }))
    entries.append(ItemListSwitchItem(title: "Скрыть выбор локации", value: UserDefaults.standard.bool(forKey: "nameless.disableChoosingLocationStatus"), style: .blocks, action: { _ in
        let v = !UserDefaults.standard.bool(forKey: "nameless.disableChoosingLocationStatus")
        UserDefaults.standard.set(v, forKey: "nameless.disableChoosingLocationStatus")
    }))
    entries.append(ItemListSwitchItem(title: "Скрыть чтение сообщений", value: UserDefaults.standard.bool(forKey: "nameless.disableMessageReadReceipt"), style: .blocks, action: { _ in
        let v = !UserDefaults.standard.bool(forKey: "nameless.disableMessageReadReceipt")
        UserDefaults.standard.set(v, forKey: "nameless.disableMessageReadReceipt")
    }))
    entries.append(ItemListSwitchItem(title: "Скрыть чтение историй", value: UserDefaults.standard.bool(forKey: "nameless.disableStoryReadReceipt"), style: .blocks, action: { _ in
        let v = !UserDefaults.standard.bool(forKey: "nameless.disableStoryReadReceipt")
        UserDefaults.standard.set(v, forKey: "nameless.disableStoryReadReceipt")
    }))
    entries.append(ItemListTextItem(text: "Включённые пункты скрывают ваши действия от других пользователей.", style: .blocks))
    
    // MARK: - Liquid Glass
    entries.append(ItemListSectionHeaderItem(text: "ЖИДКОЕ СТЕКЛО"))
    let lgKeys: [(String, String)] = [
        ("nameless.liquidGlass.messages", "Сообщения"),
        ("nameless.liquidGlass.settings", "Настройки"),
        ("nameless.liquidGlass.profile", "Профиль"),
        ("nameless.liquidGlass.profileGifts", "Подарки профиля"),
        ("nameless.liquidGlass.inlineButtons", "Инлайн-кнопки"),
        ("nameless.liquidGlass.tinting", "Тонирование"),
    ]
    for (key, label) in lgKeys {
        entries.append(ItemListSwitchItem(title: label, value: UserDefaults.standard.bool(forKey: key), style: .blocks, action: { _ in
            let v = !UserDefaults.standard.bool(forKey: key)
            UserDefaults.standard.set(v, forKey: key)
        }))
    }
    entries.append(ItemListTextItem(text: "Управление Liquid Glass-поверхностями по отдельным зонам.", style: .blocks))
    
    // MARK: - Features
    entries.append(ItemListSectionHeaderItem(text: "ФУНКЦИИ NAMELESS"))
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
        entries.append(ItemListSwitchItem(title: label, value: UserDefaults.standard.bool(forKey: key), style: .blocks, action: { _ in
            let v = !UserDefaults.standard.bool(forKey: key)
            UserDefaults.standard.set(v, forKey: key)
        }))
    }
    
    // MARK: - About
    entries.append(ItemListSectionHeaderItem(text: "О NAMELESS"))
    entries.append(ItemListActionItem(title: "GitHub", style: .blocks, action: {
        if let url = URL(string: "https://github.com/kreadwrite/nameless") {
            UIApplication.shared.open(url)
        }
    }))
    entries.append(ItemListTextItem(text: "nameless — кастомный Telegram-клиент на базе Swiftgram с расширенными функциями приватности и кастомизации.", style: .blocks))
    
    // MARK: - Rollback
    entries.append(ItemListSectionHeaderItem(text: "МГНОВЕННЫЙ ОТКАТ"))
    entries.append(ItemListActionItem(title: "Сбросить все настройки nameless", style: .blocks, color: .destructive, action: {
        let defaults = UserDefaults.standard
        for key in defaults.dictionaryRepresentation().keys where key.hasPrefix("nameless.") {
            defaults.removeObject(forKey: key)
        }
    }))
    entries.append(ItemListTextItem(text: "Возвращает все настройки nameless к значениям по умолчанию. Требует перезапуск приложения.", style: .blocks))
    
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
        |> map { _, state, presentationData -> (ItemListControllerState, ItemListNodeState) in
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
            return (controllerState, listState)
    }
    
    let controller = ItemListController(context: context, state: signal)
    return controller
}
