<p align="center">
  <img src="docs/assets/namelessBadge.png" alt="nameless" width="560">
</p>

<h1 align="center">nameless</h1>

<p align="center">
  <b>Кастомный iOS-клиент с фирменным брендингом nameless, glass-интерфейсом и отдельным центром настроек.</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/iOS-26%2B-111111?style=for-the-badge&logo=apple&logoColor=white" alt="iOS">
  <img src="https://img.shields.io/badge/Swift-iOS-111111?style=for-the-badge&logo=swift&logoColor=white" alt="Swift">
  <img src="https://img.shields.io/badge/Liquid%20Glass-nameless-111111?style=for-the-badge" alt="Liquid Glass">
  <img src="https://img.shields.io/badge/status-active-111111?style=for-the-badge" alt="status">
</p>

<p align="center">
  <img src="docs/assets/nameless.png" alt="nameless app icon" width="180">
</p>

## О проекте

`nameless` — неофициальный iOS-клиент на базе upstream-кода Telegram с собственным брендингом, темным визуальным стилем, округленными элементами, glass-поверхностями и отдельным центром настроек nameless.

Название `nameless`, логотип, бейдж, оформление, скриншоты и все проектные доработки являются защищенными материалами проекта. Upstream-код и сторонние зависимости сохраняют свои оригинальные лицензии.

## Что уже работает

- Вкладка `nameless` в настройках с кастомной округленной иконкой.
- Центр настроек nameless: `Внешний вид`, `Режим призрака`, `О nameless`, `Функции nameless`, `Жидкое стекло`.
- Поиск по настройкам nameless.
- Каталог `Поиск настроек` открывает все функции и ведет в нужный раздел по тапу.
- Скрытые legacy-вкладки открываются долгим нажатием на `Возможности Telegram`.
- Ссылки `Канал nameless`, `Разработчик glswee`, `Stiven VPN` открываются внутри клиента.
- Переключатели Liquid Glass для сообщений, настроек, профиля, подарков, inline-кнопок и тонирования стекла.
- Видео на фоне чата: выбор, замена, удаление, включение и выключение зацикленного видео без звука.
- Круглые icon-only кнопки профиля без текстовых подписей, с сохраненными accessibility labels.
- Official developer профиль nameless: статус разработчика, карточка основателя и verification footer.
- В видимых селекторах иконок/бейджей оставлены только nameless-ассеты.
- Подключены модули nameless: ghost mode, local premium, chat export, fake location, chat password, double bottom, voice tools и supporters.

## Функции со `*`

Звездочка `*` в интерфейсе и README означает, что функция частично реализована или пока работает как заглушка:

- `Смена голоса *`

У таких пунктов уже есть экран или переключатель, но часть логики может быть подключена не полностью.

## Статус реализации

- Брендинг и видимые строки переведены на `nameless`.
- Логотип с черным персонажем подключен как app/settings icon.
- Горизонтальный `namelessBadge` подключен для README и badge UI.
- GitHub Actions собирает unsigned iOS artifact через Bazel на macOS runner.
- Liquid Glass покрытие расширяется постепенно: ключи и настройки уже подключены, часть поверхностей использует существующие glass/fallback-компоненты.

## Ссылки

- Канал: [t.me/hanmeta](https://t.me/hanmeta)
- Разработчик: [t.me/kreadwrite](https://t.me/kreadwrite)
- Stiven VPN: [t.me/stivenvpnbot](https://t.me/stivenvpnbot)

## Права

Copyright (c) 2026 nameless.

Запрещено копировать, продавать, переименовывать, перепаковывать или выдавать за свой проект бренд `nameless`, логотипы, бейджи, дизайн, скриншоты, пользовательские модули и проектные изменения без письменного разрешения владельца.

Telegram, upstream iOS-код и сторонние библиотеки принадлежат их правообладателям и используются согласно их лицензиям. `nameless` не является официальным продуктом Telegram.
