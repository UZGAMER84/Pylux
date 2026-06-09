import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Shapes
import QtCore

import org.streetpea.chiaking

Pane {
    padding: 0
    id: consolePane

    readonly property string apiBaseUrl: "https://ps-api.cloudplay.uz/api"
    readonly property string updateManifestUrl: "https://ps-api.cloudplay.uz/media/public-downloads/cloudplay-console/latest.json"
    readonly property string smokeUiMarkers: "CloudPlay account Play"
    readonly property string fontManrope: manropeFont.status === FontLoader.Ready ? manropeFont.name : "Manrope"
    readonly property string fontUnbounded: unboundedFont.status === FontLoader.Ready ? unboundedFont.name : fontManrope
    readonly property string fontUi: Qt.platform.os === "windows" ? "Segoe UI Variable Text" : (Qt.platform.os === "osx" ? ".AppleSystemUIFont" : fontManrope)
    readonly property string fontDisplay: fontUi
    readonly property string fontMono: jetBrainsMonoFont.status === FontLoader.Ready ? jetBrainsMonoFont.name : "JetBrains Mono"
    readonly property color neonCyan: "#19e9ff"
    readonly property color neonBlue: "#2e7bff"
    readonly property color neonPink: "#ff2e8b"
    readonly property color cardBorder: Qt.rgba(140/255, 170/255, 255/255, 0.24)
    property bool cloudPlayLoggedIn: cloudStore.accessToken.length > 0
    property string cloudPlayUser: cloudStore.displayName.length > 0 ? cloudStore.displayName : (cloudPlayLoggedIn ? consolePane.trText("Игрок") : consolePane.trText("Вход не выполнен"))
    property string apiStatusText: consolePane.trText("Готово к игре")
    property string loginCode: ""
    property string loginUrl: ""
    property string activeSessionId: ""
    property string activeSlotId: ""
    property string activeSessionStatus: ""
    property string connectHost: ""
    property string connectPorts: ""
    property bool profileBlobReady: false
    property bool apiBusy: false
    property int availableSlots: 0
    property int queueCount: 0
    property int minutesBalance: 0
    property int networkPingMs: -1
    property string queueText: ""
    property string currentPage: "home"
    property string settingsCategory: "stream"
    property var pendingStreamSession: null
    property int walletBalanceUzs: 0
    property string supportTelegramUrl: "https://t.me/cloudplaysupport_bot"
    property string supportCallDisplay: "+998 71 205-05-01"
    property int launchStep: 0
    property real launchProgress: 0.0
    property string launchStatusText: consolePane.trText("Готово к игре")
    property bool streamActive: false
    property bool nativeStreamStarting: false
    property double nativeStreamStartedAtMs: 0
    property double nativeStreamConnectedSinceMs: 0
    property bool nativeStreamSessionSeen: false
    property bool nativeConnectedSignalPending: false
    property bool cloudPlayStreamConnectedNotified: false
    property bool cloudPlayStopInFlight: false
    property int cloudPlayLaunchRetryCount: 0
    property var cloudPlayFailedSlotIds: []
    property string selectedPackageTitle: ""
    property string selectedPackagePrice: ""
    property string supportDraft: ""
    property var featuredGames: [
        { title: "Eclipse Horizon", genre: consolePane.trText("Приключения"), image: "qrc:/icons/cloudplay-game-1.png" },
        { title: "Neon Revenant", genre: consolePane.trText("Экшен"), image: "qrc:/icons/cloudplay-game-2.png" },
        { title: "Skybound Odyssey", genre: "RPG", image: "qrc:/icons/cloudplay-game-3.png" },
        { title: "Voidwalkers", genre: consolePane.trText("Шутер"), image: "qrc:/icons/cloudplay-game-4.png" }
    ]
    property var libraryGames: featuredGames
    property var recentSessions: [
        { title: consolePane.trText("Игра на PS5"), time: consolePane.trText("Истории пока нет"), duration: "—", status: consolePane.trText("Завершено"), slot: "—" }
    ]
    property var availablePackages: [
        { id: "starter", title: consolePane.trText("1 час"), minutes: 60, price: "15 000 UZS", amount: 15000, badge: consolePane.trText("Старт"), rate: consolePane.trText("15 000 UZS/час") },
        { id: "hit", title: consolePane.trText("3 часа"), minutes: 180, price: "39 000 UZS", amount: 39000, badge: consolePane.trText("Хит"), rate: consolePane.trText("13 000 UZS/час") },
        { id: "value", title: consolePane.trText("5 часов"), minutes: 300, price: "60 000 UZS", amount: 60000, badge: consolePane.trText("Выгодно"), rate: consolePane.trText("12 000 UZS/час") },
        { id: "best", title: consolePane.trText("10 часов"), minutes: 600, price: "105 000 UZS", amount: 105000, badge: consolePane.trText("Лучшая цена"), rate: consolePane.trText("10 500 UZS/час") }
    ]
    property bool packagesLoading: false
    property bool packagesLoadedFromApi: false
    property string packagesStatusText: consolePane.trText("Выберите пакет игрового времени.")
    property var walletTransactions: []
    property int queuePosition: 0
    property string queueTicketId: ""
    property bool queueReady: false
    property bool queueNotifyTelegram: false
    property bool queueTelegramNotified: false
    property string queueEtaText: consolePane.trText("без ожидания")
    property string preferredBusyMessage: ""
    property string preferredBusySlot: ""
    property string preferredBusyUser: ""
    property string preferredBusyAlternate: ""
    property string selectedPackageId: ""
    property int selectedPackageMinutes: 0
    property int selectedPackageAmount: 0
    property string paymentStatusText: ""
    property string librarySearchQuery: ""
    property string libraryFilter: "all"
    property string selectedGameTitle: ""
    property string selectedGameGenre: ""
    property string selectedGameImage: ""
    property string selectedGameStatus: ""
    property bool updateChecking: false
    property bool updateAvailable: false
    property string updateLatestVersion: ""
    property string updateDownloadUrl: ""
    property string updateReleaseNotes: ""
    property string updateStatusText: consolePane.trText("Проверка обновлений ещё не выполнялась.")

    readonly property var i18nEn: ({
        "Игрок": "Player",
        "Вход не выполнен": "Not signed in",
        "Готово к игре": "Ready to play",
        "Приключения": "Adventures",
        "Экшен": "Action",
        "Шутер": "Shooter",
        "Игра на PS5": "Game on PS5",
        "Истории пока нет": "No story yet",
        "Завершено": "Finished",
        "1 час": "1 hour",
        "Старт": "Start",
        "15 000 UZS/час": "15,000 UZS/hour",
        "3 часа": "3 hours",
        "Хит": "Hit",
        "13 000 UZS/час": "13,000 UZS/hour",
        "5 часов": "5 hours",
        "Выгодно": "Profitable",
        "12 000 UZS/час": "12,000 UZS/hour",
        "10 часов": "10 o'clock",
        "Лучшая цена": "Best price",
        "10 500 UZS/час": "10 500 UZS/hour",
        "Пакеты будут загружены из CloudPlay API после входа.": "Packages will be downloaded from the CloudPlay API after logging in.",
        "без ожидания": "without waiting",
        "Идёт игра": "Playing",
        "Ошибка": "Error",
        "Тест: запускаем игру…": "Test: launch the game...",
        "Тест: завершаем игру…": "Test: finishing the game...",
        "Загружаем данные…": "Loading data...",
        "Войдите через Telegram, чтобы играть": "Login via Telegram to play",
        "Войдите через Telegram — покажем реальные пакеты и цены из API.": "Log in via Telegram - we will show you real packages and prices from the API.",
        "измеряем": "we measure",
        "отлично": "Great",
        "хорошо": "Fine",
        "нормально": "Fine",
        "высокий": "high",
        "Вход истёк. Войдите через Telegram снова.": "Login has expired. Login via Telegram again.",
        "Игра ": "Game",
        "Готово": "Ready",
        "Очередь": "Queue",
        "готов": "ready",
        "Игра CloudPlay": "Game CloudPlay",
        "Готово к запуску": "Ready to launch",
        "Можно в очередь": "You can queue",
        " мин": "min",
        " ч ": "h",
        "Открываем вход через Telegram…": "We open the login via Telegram...",
        "Не удалось открыть вход через Telegram. Попробуйте ещё раз.": "Failed to open login via Telegram. Try again.",
        "Подтвердите вход в Telegram · код ": "Confirm Telegram login code",
        "Ждём подтверждения в Telegram…": "We are waiting for confirmation in Telegram...",
        "Вход выполнен · загружаем данные…": "Logged in · loading data...",
        "Вы вошли через Telegram.": "You are logged in via Telegram.",
        "Код истёк. Войдите через Telegram снова.": "The code has expired. Login via Telegram again.",
        "Ждём подтверждения в Telegram · код ": "We are waiting for confirmation in Telegram · code",
        "Вы вышли. Войдите снова, чтобы играть.": "You're out. Login again to play.",
        "Не удалось обновить данные. Попробуйте ещё раз.": "Failed to update data. Try again.",
        "Готово · свободных PS5: ": "Ready · free PS5:",
        " · время: ": "· time:",
        "Сейчас игра не запущена.": "The game is not running right now.",
        "Игра загружена.": "The game is loaded.",
        "PS5 подготовлена · подключаем игру": "PS5 is ready · connect the game",
        "Игра подключена · время пошло": "Game connected · time has passed",
        "Игра запущена · обновляем время": "The game is running · update time",
        "Игра подключена": "Game connected",
        "PS5 не ответила · пробуем другую…": "PS5 did not respond · trying another...",
        "PS5 не ответила": "PS5 didn't respond",
        "Готовим другую PS5…": "We are preparing another PS5...",
        "Войдите через Telegram": "Login via Telegram",
        "Готовим PS5…": "Preparing PS5...",
        "Не удалось начать игру. Попробуйте ещё раз.": "Failed to start the game. Try again.",
        "Позиция в очереди: #": "Queue position: #",
        "Вы добавлены в очередь": "You have been added to the queue",
        "Сейчас все PS5 заняты. ": "All PS5s are currently occupied.",
        "PS5 подготовлена. Запускаем консоль…": "PS5 is ready. Launching the console...",
        "Консоль готова · подключаем игру…": "The console is ready · connect the game...",
        "Консоль запускается дольше обычного · пробуем подключиться…": "The console takes longer to start than usual · trying to connect...",
        "Не удалось получить данные для запуска. Попробуйте ещё раз.": "Failed to obtain startup data. Try again.",
        "Игра уже запущена": "The game is already running",
        "Не удалось подготовить запуск. Попробуйте ещё раз.": "Failed to prepare launch. Try again.",
        "Подключаем игру…": "Connecting the game...",
        "Игра не запустилась": "The game didn't start",
        "Не удалось подключить игру.": "Failed to connect the game.",
        "Подключаемся к PS5…": "Connecting to PS5...",
        "Запускаем консоль…": "Launching the console...",
        "Консоль запускается дольше обычного…": "The console takes longer than usual to start...",
        "Игра завершена · осталось ": "Game over · left",
        "Не удалось завершить игру. Попробуйте ещё раз.": "Failed to complete the game. Try again.",
        " час": "hour",
        "ов": "ov",
        "а": "A",
        "Пакет ": "Plastic bag",
        " / час": "/ hour",
        "Операция": "Operation",
        "Загружаем пакеты из CloudPlay API…": "Loading packages from the CloudPlay API...",
        "Цены загружены из CloudPlay API.": "Prices downloaded from CloudPlay API.",
        "Не удалось загрузить API пакетов. Показываем последний доступный список.": "Failed to load API packages. Show the last available list.",
        "~10–15 минут": "~10–15 minutes",
        "Введите сумму пополнения.": "Enter the top-up amount.",
        "Готовим оплату…": "We are preparing payment...",
        "Не удалось создать оплату. Попробуйте ещё раз.": "Failed to create payment. Try again.",
        "Оплата создана, но ссылка не открылась. Попробуйте ещё раз.": "The payment was created, but the link did not open. Try again.",
        "Подключаем…": "Let's connect...",
        "Готовим подключение…": "Getting ready to connect...",
        "Выход": "Exit",
        "Закрыть CloudPlay Console?": "Close CloudPlay Console?",
        "Главная": "Home",
        "Играть": "Play",
        "Игры": "Games",
        "Баланс": "Balance",
        "Время": "Time",
        "Профиль": "Profile",
        "Настройки": "Settings",
        "Позвонить": "Call",
        "Поддержка": "Support",
        "Вход через Telegram": "Telegram login",
        "Вы вошли": "Signed in",
        "Войдите, чтобы играть": "Sign in to play",
        " PS5 свободны": "PS5 available",
        "Все PS5 заняты": "All PS5 are taken",
        "Обновить": "Refresh",
        "Статус": "Status",
        "PS5 свободна": "PS5 is free",
        "Есть очередь": "There is a queue",
        " мин · ": "min ·",
        "Время начнёт списываться после подключения к игре.": "Time will begin to count after connecting to the game.",
        "Играй на PS5 в облаке": "Play on PS5 in the cloud",
        "Запускайте игры, следите за временем и пополняйте баланс в одном приложении.": "Launch games, keep track of time and top up your balance in one application.",
        "Пополнить": "Top up",
        "Для игр и пополнений": "For games and top-ups",
        "Игровое время": "Game time",
        "Доступно сейчас": "Available now",
        "Свободна": "Available",
        "В очереди: ": "In queue:",
        "Без ожидания": "No waiting",
        "Быстрые действия": "Quick Actions",
        "Купить игровое время": "Buy game time",
        " в очереди": "in line",
        "Свободно": "Free",
        "Аккаунт": "Account",
        "Войти": "Login",
        "Популярное": "Popular",
        " игр": "games",
        "Подключаем PS5": "Connect PS5",
        "Запустите PS5, проверьте пинг и баланс в одном месте.": "Launch PS5, check ping and balance in one place.",
        "Войдите через Telegram, чтобы запустить игру.": "Log in via Telegram to launch the game.",
        "В игре": "In the game",
        "Запуск": "Launch",
        "Ожидание": "Expectation",
        "Готов": "Ready",
        "Нужен вход": "Login required",
        "Игра": "Game",
        "Подключено": "Connected",
        "Подключаем": "Connecting",
        "Вернуться к игре": "Return to game",
        "Начать игру": "Start game",
        "Войти и играть": "Login and play",
        "Завершить": "Complete",
        "Купить время": "Buy time",
        "Время списывается только после успешного подключения к игре.": "Time is written off only after successful connection to the game.",
        "баланс: ": "balance:",
        "нужен вход": "need entry",
        "Состояние": "Status",
        "обновляется автоматически": "updates automatically",
        "Занято": "Busy",
        "без очереди": "without a queue",
        "Пинг": "Ping",
        "списывается после подключения": "written off after connection",
        "Настроить экран": "Customize screen",
        "FPS · качество · HDR": "FPS · quality · HDR",
        "колл центр": "call center",
        " из ": "from",
        "Войдите, чтобы открыть каталог игр": "Login to open the game catalog",
        "Найти игру": "Find a game",
        "Все": "All",
        "Популярные": "Popular",
        "Доступные": "Available",
        "Можно играть сейчас": "Can play now",
        "Баланс CloudPlay": "Balance CloudPlay",
        "Деньги для пополнений и игровое время для запуска PS5.": "Money for top-ups and game time to launch PS5.",
        "Активен": "Active",
        "Денежный баланс": "Cash balance",
        "Пополняется через Click. Можно покупать пакеты времени.": "Top up via Click. You can buy time packages.",
        "Пополнить баланс": "Top up balance",
        "Списывается только после реального подключения к игре.": "It is written off only after real connection to the game.",
        "Как это работает": "How does this work",
        "Пополняешь баланс через Click": "Top up your balance via Click",
        "Покупаешь пакет игрового времени": "Buy a game time package",
        "Минуты списываются после подключения": "Minutes are debited after connection",
        "Обновить данные": "Update data",
        "Быстрая покупка времени": "Quick time purchase",
        "Реальные пакеты и цены из CloudPlay API.": "Real packages and prices from CloudPlay API.",
        "Загрузка…": "Loading…",
        "Все пакеты": "All packages",
        "Купить": "Buy",
        "Оплата": "Payment",
        "Click откроется в браузере. После оплаты данные можно обновить.": "Click will open in the browser. After payment, the data can be updated.",
        "История операций": "Operation history",
        "История пока пустая": "The story is still empty",
        "Пополнения, покупки пакетов и списания появятся здесь.": "Top-ups, package purchases and write-offs will appear here.",
        "Можно играть сейчас.": "You can play now.",
        "Можно подождать. Мы напишем в Telegram, когда PS5 освободится.": "You can wait. We will write on Telegram when the PS5 is available.",
        "Место: ": "Place:",
        " · Ожидание: ": "· Expectation:",
        "Вы вошли через Telegram": "You are logged in via Telegram",
        "На аккаунте": "On account",
        "Доступно для игры": "Available to play",
        "Выйти": "Log out",
        "Недавние игры": "Recent games",
        "Управление приложением, качеством игры, звуком и геймпадом. Всё в стиле CloudPlay — без технических экранов.": "Manage application, game quality, sound and gamepad. Everything is in the CloudPlay style - without technical screens.",
        "качество и поток": "quality and flow",
        "Экран": "Display",
        "картинка, цвет и рендер": "picture, color and render",
        "Звук": "Sound",
        "аудио и приватность": "audio and privacy",
        "Геймпад": "Gamepad",
        "контроллер и вибрация": "controller and vibration",
        "Клавиатура": "Keyboard",
        "клавиши и мышь": "keys and mouse",
        "профиль и поддержка": "profile and support",
        "Как запускается и держится игровое подключение.": "How the game connection is launched and maintained.",
        "Картинка, FPS, кодек, цветовая схема и рендеринг.": "Picture, FPS, codec, color scheme and rendering.",
        "Звук, уведомления и приватность на экране.": "Sound, notifications and on-screen privacy.",
        "Контроллер, вибрация и D‑pad во время игры.": "Controller, vibration and D‑pad during gameplay.",
        "Клавиши, мышь и сброс раскладки.": "Keys, mouse and layout reset.",
        "Профиль, баланс и помощь.": "Profile, balance and help.",
        "После выхода из игры": "After leaving the game",
        "Что делать с консолью после завершения.": "What to do with the console after completion.",
        "Оставить как есть": "Leave as is",
        "Перевести в режим покоя": "Switch to rest mode",
        "Спросить": "Ask",
        "При сворачивании": "When folding",
        "Поведение при потере фокуса приложения.": "Behavior when application focus is lost.",
        "Ничего не делать": "Do nothing",
        "Режим покоя": "Rest mode",
        "Меню во время игры": "Menu during the game",
        "Быстрый доступ к настройкам в стриме.": "Quick access to settings in the stream.",
        "Статистика поверх игры": "Statistics on top of the game",
        "FPS, задержка и сеть во время сессии.": "FPS, latency and network during the session.",
        "Кнопка меню 1": "Menu button 1",
        "Первое сочетание для меню в игре.": "The first menu combination in the game.",
        "Нет": "No",
        "Кнопка меню 2": "Menu button 2",
        "Второе сочетание для меню в игре.": "The second combination for the menu in the game.",
        "Разрешение CloudPlay": "CloudPlay permission",
        "Основное качество для удалённой PS5.": "The main quality for a remote PS5.",
        "Плавность игры: 30 или 60 кадров.": "Game smoothness: 30 or 60 frames.",
        "Битрейт CloudPlay": "CloudPlay bitrate",
        "Скорость видео потока. Для 1080p обычно 15–25 Мбит/с.": "Video stream speed. For 1080p it's usually 15-25 Mbps.",
        " Мбит/с": "Mbit/s",
        "Кодек PS5": "PS5 codec",
        "H265 обычно даёт лучшую картинку при том же битрейте.": "H265 usually gives a better picture at the same bitrate.",
        "Профиль рендера": "Render Profile",
        "Быстрее или качественнее обработка картинки.": "Faster or better image processing.",
        "Быстрый": "Fast",
        "Стандарт": "Standard",
        "Высокое качество": "High quality",
        "HQ + масштабирование": "HQ + zoom",
        "HQ + продв. масштабирование": "HQ + adv. scaling",
        "Свой": "Mine",
        "Рендеринг": "Rendering",
        "Vulkan обычно быстрее; OpenGL как запасной режим.": "Vulkan is usually faster; OpenGL as a fallback mode.",
        "Дополнительный режим вывода кадра для Vulkan.": "Additional frame output mode for Vulkan.",
        "Смешивание кадров": "Frame blending",
        "Плавность обработки видео в рендере.": "Smooth video processing in rendering.",
        "Выкл": "Off",
        "Цветовая схема": "Color scheme",
        "Цветовой охват экрана: авто, стандартный или широкий.": "Screen color gamut: auto, standard or wide.",
        "Авто": "Auto",
        "Гамма / HDR": "Gamma/HDR",
        "Передача яркости: SDR, sRGB, PQ HDR или HLG HDR.": "Brightness transmission: SDR, sRGB, PQ HDR or HLG HDR.",
        "Вертикальная синхронизация": "Vertical Sync",
        "Меньше разрывов картинки, может добавить задержку.": "Less picture tearing, which can add lag.",
        "Скрывать курсор": "Hide cursor",
        "Убирает мышь поверх игры.": "Moves the mouse away from the game.",
        "Видео и звук": "Video and sound",
        "Быстро отключить звук или картинку при необходимости.": "Quickly turn off sound or picture if necessary.",
        "Всё включено": "All inclusive",
        "Отключить звук": "Mute",
        "Отключить видео": "Disable video",
        "Отключить всё": "Disable everything",
        "Устройство вывода": "Output device",
        "Куда выводить звук игры.": "Where to output the game sound.",
        "Микрофон": "Microphone",
        "Устройство ввода для голосового чата.": "Input device for voice chat.",
        "Громкость": "Volume",
        "Общая громкость звука игры.": "Overall game sound volume.",
        "Буфер аудио": "Audio buffer",
        "Больше буфер — стабильнее звук, но выше задержка.": "A larger buffer means more stable sound, but higher latency.",
        "Микрофон включён при старте": "Microphone on at startup",
        "Автоматически открывать голос во время игры.": "Automatically open voice while playing.",
        "Уведомления сети": "Network notifications",
        "Показывать предупреждения при просадках Wi‑Fi.": "Show warnings when Wi‑Fi sags.",
        "Геймпад в фоне": "Gamepad in the background",
        "Оставлять управление активным при потере фокуса.": "Keep control active when focus is lost.",
        "Кнопки по позиции": "Buttons by position",
        "Помогает, если кнопки контроллера перепутаны.": "Helps if the controller buttons are mixed up.",
        "Вибрация": "Vibration",
        "Интенсивность вибрации и haptics.": "Vibration intensity and haptics.",
        "Слабо": "Weak",
        "Средне": "Average",
        "Сильно": "Strongly",
        "Сила haptics": "Power of haptics",
        "Ручная тонкая настройка отклика.": "Manual fine tuning of response.",
        "Сенсорная крестовина": "Touch pad",
        "Дополнительная D‑pad логика для некоторых игр.": "Additional D‑pad logic for some games.",
        "Шаг крестовины": "Cross pitch",
        "Чувствительность сенсорной крестовины.": "Sensitivity of the touch pad.",
        "Разрешить управление с клавиатуры.": "Allow keyboard control.",
        "Мышь как тачпад": "Mouse like touchpad",
        "Использовать мышь для тачпада контроллера.": "Use a mouse for the controller's touchpad.",
        "Раскладка клавиатуры": "Keyboard layout",
        "для игры без геймпада": "for playing without a gamepad",
        "Сбросить клавиши": "Reset keys",
        "Вернуть стандартную раскладку клавиатуры.": "Restore the standard keyboard layout.",
        "Сброс": "Reset",
        "Аккаунт подключён": "Account connected",
        "Приватный режим": "Private mode",
        "Скрывать данные аккаунта в трансляциях и скриншотах.": "Hide account information in broadcasts and screenshots.",
        "Безопасные логи": "Secure logs",
        "Скрывать чувствительные данные в логах.": "Hide sensitive data in logs.",
        "Назначить клавишу": "Assign a key",
        "Нажмите любую клавишу, чтобы назначить её на выбранную кнопку.": "Press any key to assign it to the selected button.",
        "Открыть": "Open",
        "Крестик": "Cross",
        "Круг": "Circle",
        "Квадрат": "Square",
        "Треугольник": "Triangle",
        "Крестовина влево": "D-pad left",
        "Крестовина вправо": "D-pad right",
        "Крестовина вверх": "Cross up",
        "Крестовина вниз": "Cross down",
        "L1 / левый бампер": "L1 / left bumper",
        "R1 / правый бампер": "R1 / right bumper",
        "L2 / левый триггер": "L2/left trigger",
        "R2 / правый триггер": "R2/right trigger",
        "L3 / нажать левый стик": "L3 / press left stick",
        "R3 / нажать правый стик": "R3 / press right stick",
        "Тачпад": "Touchpad",
        "Кнопка PS": "PS button",
        "Левый аналог вправо": "Left analog to right",
        "Левый аналог влево": "Left analog to left",
        "Левый аналог вверх": "Left analog up",
        "Левый аналог вниз": "Left analog down",
        "Левый аналог горизонталь": "Left analogue horizontal",
        "Левый аналог вертикаль": "Left analogue vertical",
        "Правый аналог вправо": "Right analog to right",
        "Правый аналог влево": "Right analog to left",
        "Правый аналог вверх": "Right analog up",
        "Правый аналог вниз": "Right analogue down",
        "Правый аналог горизонталь": "Right analog horizontal",
        "Правый аналог вертикаль": "Right analogue vertical",
        "Назначить": "Assign",
        "CloudPlay подготовит PS5 для игры": "CloudPlay will prepare PS5 for the game",
        "Как начнём": "How do we get started?",
        "1. Проверим вход · 2. Подготовим PS5 · 3. Подключим игру": "1. Check the input · 2. Prepare the PS5 · 3. Connect the game",
        "Отмена": "Cancel",
        "Нажмите «Играть» — CloudPlay подготовит PS5 и подключит вас к игре.": "Click Play and CloudPlay will prepare your PS5 and connect you to the game.",
        "Закрыть": "Close",
        "Пополнение": "Replenishment",
        "Выберите готовую сумму или введите свою": "Select a ready amount or enter your own",
        "Другая сумма": "Other amount",
        "После выбора суммы откроется страница оплаты.": "After selecting the amount, the payment page will open.",
        "Подтвердите покупку": "Confirm your purchase",
        "Свяжитесь с нами по телефону": "Contact us by phone",
        "Напишите нам в Telegram": "Write to us on Telegram",
        "Опишите проблему": "Describe the problem",
        "Написать": "Write",
        "Язык": "Language",
        "Русский": "Russian",
        "Английский": "English",
        "Узбекский": "Uzbek",
        "язык интерфейса": "interface language",
        "Интерфейс и язык": "Interface and language",
        "Выберите язык приложения. Интерфейс переключится сразу.": "Select the application language. The interface will switch immediately.",
        "Язык приложения": "App language",
        "Меняет все разделы CloudPlay Console.": "Changes all sections of the CloudPlay Console.",
        "Сейчас выбран": "Selected",
        "Локализация": "Localization",
        "RU · EN · UZ": "RU · EN · UZ"
})
    readonly property var i18nUz: ({
        "Игрок": "O‘yinchi",
        "Вход не выполнен": "Kirilmagan",
        "Готово к игре": "O‘yinga tayyor",
        "Приключения": "Sarguzashtlar",
        "Экшен": "Harakat",
        "Шутер": "Otishmachi",
        "Игра на PS5": "PS5 uchun o'yin",
        "Истории пока нет": "Hozircha hikoya yo'q",
        "Завершено": "Yakunlandi",
        "1 час": "1 soat",
        "Старт": "Boshlash",
        "15 000 UZS/час": "15 000 so‘m/soat",
        "3 часа": "3 soat",
        "Хит": "Urish",
        "13 000 UZS/час": "13 000 so‘m/soat",
        "5 часов": "5 soat",
        "Выгодно": "Foydali",
        "12 000 UZS/час": "12 000 so‘m/soat",
        "10 часов": "soat 10",
        "Лучшая цена": "Eng yaxshi narx",
        "10 500 UZS/час": "10 500 so‘m/soat",
        "Пакеты будут загружены из CloudPlay API после входа.": "Tizimga kirganingizdan so'ng paketlar CloudPlay API'dan yuklab olinadi.",
        "без ожидания": "kutmasdan",
        "Идёт игра": "O‘yin ketmoqda",
        "Ошибка": "Xato",
        "Тест: запускаем игру…": "Sinov: o'yinni ishga tushiring...",
        "Тест: завершаем игру…": "Sinov: oʻyin tugallandi...",
        "Загружаем данные…": "Maʼlumotlar yuklanmoqda...",
        "Войдите через Telegram, чтобы играть": "O'ynash uchun Telegram orqali kiring",
        "Войдите через Telegram — покажем реальные пакеты и цены из API.": "Telegram orqali tizimga kiring - biz sizga API dan real paketlar va narxlarni ko'rsatamiz.",
        "измеряем": "o‘lchaymiz",
        "отлично": "Ajoyib",
        "хорошо": "Yaxshi",
        "нормально": "Yaxshi",
        "высокий": "yuqori",
        "Вход истёк. Войдите через Telegram снова.": "Kirish muddati tugagan. Telegram orqali yana tizimga kiring.",
        "Игра ": "O'yin",
        "Готово": "Tayyor",
        "Очередь": "Navbat",
        "готов": "tayyor",
        "Игра CloudPlay": "CloudPlay o'yin",
        "Готово к запуску": "Ishga tushirishga tayyor",
        "Можно в очередь": "Navbatga qo'yishingiz mumkin",
        " мин": "min",
        " ч ": "h",
        "Открываем вход через Telegram…": "Telegram orqali login ochamiz...",
        "Не удалось открыть вход через Telegram. Попробуйте ещё раз.": "Telegram orqali login ochilmadi. Qayta urinib ko'ring.",
        "Подтвердите вход в Telegram · код ": "Telegram login kodini tasdiqlang",
        "Ждём подтверждения в Telegram…": "Telegramda tasdiqlashni kutamiz...",
        "Вход выполнен · загружаем данные…": "Tizimga kirgan · maʼlumotlar yuklanmoqda...",
        "Вы вошли через Telegram.": "Siz Telegram orqali tizimga kirgansiz.",
        "Код истёк. Войдите через Telegram снова.": "Kod muddati tugagan. Telegram orqali yana tizimga kiring.",
        "Ждём подтверждения в Telegram · код ": "Biz Telegram · kodida tasdiqlashni kutamiz",
        "Вы вышли. Войдите снова, чтобы играть.": "Siz chiqdingiz. O'ynash uchun yana tizimga kiring.",
        "Не удалось обновить данные. Попробуйте ещё раз.": "Maʼlumotlarni yangilab boʻlmadi. Qayta urinib ko'ring.",
        "Готово · свободных PS5: ": "Tayyor · Bo`sh PS5:",
        " · время: ": "· Vaqt:",
        "Сейчас игра не запущена.": "O'yin hozir ishlamayapti.",
        "Игра загружена.": "O'yin yuklangan.",
        "PS5 подготовлена · подключаем игру": "PS5 tayyor · oʻyinni ulang",
        "Игра подключена · время пошло": "Oʻyin ulandi · vaqt oʻtdi",
        "Игра запущена · обновляем время": "Oʻyin ishlamoqda · yangilanish vaqti",
        "Игра подключена": "O'yin ulangan",
        "PS5 не ответила · пробуем другую…": "PS5 javob bermadi · boshqasini sinab ko'ring...",
        "PS5 не ответила": "PS5 javob bermadi",
        "Готовим другую PS5…": "Biz yana bir PS5 tayyorlayapmiz...",
        "Войдите через Telegram": "Telegram orqali kiring",
        "Готовим PS5…": "PS5 tayyorlanmoqda...",
        "Не удалось начать игру. Попробуйте ещё раз.": "O‘yin boshlanmadi. Qayta urinib ko'ring.",
        "Позиция в очереди: #": "Navbatdagi joy: #",
        "Вы добавлены в очередь": "Siz navbatga qo'shildingiz",
        "Сейчас все PS5 заняты. ": "Hozirda barcha PS5lar band.",
        "PS5 подготовлена. Запускаем консоль…": "PS5 tayyor. Konsol ishga tushirilmoqda...",
        "Консоль готова · подключаем игру…": "Konsol tayyor · o'yinni ulang...",
        "Консоль запускается дольше обычного · пробуем подключиться…": "Konsolni ishga tushirish odatdagidan ko'proq vaqt oladi · ulanishga urinish...",
        "Не удалось получить данные для запуска. Попробуйте ещё раз.": "Ishga tushirish maʼlumotlarini olinmadi. Qayta urinib ko'ring.",
        "Игра уже запущена": "O'yin allaqachon ishlamoqda",
        "Не удалось подготовить запуск. Попробуйте ещё раз.": "Ishga tushirishga tayyorlanmadi. Qayta urinib ko'ring.",
        "Подключаем игру…": "Oʻyin ulanmoqda...",
        "Игра не запустилась": "O'yin boshlanmadi",
        "Не удалось подключить игру.": "Oʻyinni ulab boʻlmadi.",
        "Подключаемся к PS5…": "PS5 ga ulanmoqda...",
        "Запускаем консоль…": "Konsol ishga tushirilmoqda...",
        "Консоль запускается дольше обычного…": "Konsolni ishga tushirish odatdagidan ko'proq vaqt oladi...",
        "Игра завершена · осталось ": "Oʻyin tugadi · chap",
        "Не удалось завершить игру. Попробуйте ещё раз.": "O‘yinni yakunlab bo‘lmadi. Qayta urinib ko'ring.",
        " час": "soat",
        "ов": "ov",
        "а": "A",
        "Пакет ": "Plastik sumka",
        " / час": "/ soat",
        "Операция": "Operatsiya",
        "Загружаем пакеты из CloudPlay API…": "CloudPlay API’dan paketlar yuklanmoqda...",
        "Цены загружены из CloudPlay API.": "CloudPlay API'dan yuklab olingan narxlar.",
        "Не удалось загрузить API пакетов. Показываем последний доступный список.": "API paketlarini yuklab bo‘lmadi. Oxirgi mavjud ro'yxatni ko'rsatish.",
        "~10–15 минут": "~10-15 daqiqa",
        "Введите сумму пополнения.": "To'ldirish miqdorini kiriting.",
        "Готовим оплату…": "Biz to'lovni tayyorlayapmiz ...",
        "Не удалось создать оплату. Попробуйте ещё раз.": "Toʻlovni yaratib boʻlmadi. Qayta urinib ko'ring.",
        "Оплата создана, но ссылка не открылась. Попробуйте ещё раз.": "To'lov yaratildi, lekin havola ochilmadi. Qayta urinib ko'ring.",
        "Подключаем…": "Ulanamiz...",
        "Готовим подключение…": "Ulanishga tayyorlanmoqda...",
        "Выход": "Chiqish",
        "Закрыть CloudPlay Console?": "CloudPlay Console yopilsinmi?",
        "Главная": "Asosiy",
        "Играть": "O‘ynash",
        "Игры": "O‘yinlar",
        "Баланс": "Balans",
        "Время": "Vaqt",
        "Профиль": "Profil",
        "Настройки": "Sozlamalar",
        "Позвонить": "Qo‘ng‘iroq",
        "Поддержка": "Yordam",
        "Вход через Telegram": "Telegram orqali kirish",
        "Вы вошли": "Kirdingiz",
        "Войдите, чтобы играть": "O‘ynash uchun kiring",
        " PS5 свободны": "PS5 mavjud",
        "Все PS5 заняты": "Barcha PS5 olinadi",
        "Обновить": "Yangilash",
        "Статус": "Status",
        "PS5 свободна": "PS5 Bo`sh",
        "Есть очередь": "Navbat bor",
        " мин · ": "min ·",
        "Время начнёт списываться после подключения к игре.": "O'yinga ulangandan keyin vaqt hisoblana boshlaydi.",
        "Играй на PS5 в облаке": "PS5-da bulutda o'ynang",
        "Запускайте игры, следите за временем и пополняйте баланс в одном приложении.": "Bitta ilovada oʻyinlarni ishga tushiring, vaqtni kuzatib boring va balansingizni toʻldiring.",
        "Пополнить": "To‘ldirish",
        "Для игр и пополнений": "O'yinlar va to'ldirishlar uchun",
        "Игровое время": "O'yin vaqti",
        "Доступно сейчас": "Hozir mavjud",
        "Свободна": "Bo`sh",
        "В очереди: ": "Navbatda:",
        "Без ожидания": "Kutish yo'q",
        "Быстрые действия": "Tezkor harakatlar",
        "Купить игровое время": "O'yin vaqtini sotib oling",
        " в очереди": "mos ravishda",
        "Свободно": "Bo`sh",
        "Аккаунт": "Akkaunt",
        "Войти": "Tizimga kirish",
        "Популярное": "Ommabop",
        " игр": "o'yinlar",
        "Подключаем PS5": "PS5 ni ulang",
        "Запустите PS5, проверьте пинг и баланс в одном месте.": "PS5-ni ishga tushiring, ping va balansni bir joyda tekshiring.",
        "Войдите через Telegram, чтобы запустить игру.": "O'yinni boshlash uchun Telegram orqali tizimga kiring.",
        "В игре": "O'yinda",
        "Запуск": "Ishga tushirish",
        "Ожидание": "Kutish",
        "Готов": "Tayyor",
        "Нужен вход": "Kirish talab qilinadi",
        "Игра": "O'yin",
        "Подключено": "Ulangan",
        "Подключаем": "Ulanmoqda",
        "Вернуться к игре": "O'yinga qaytish",
        "Начать игру": "O'yinni boshlang",
        "Войти и играть": "Tizimga kiring va o'ynang",
        "Завершить": "Bajarildi",
        "Купить время": "Vaqt sotib oling",
        "Время списывается только после успешного подключения к игре.": "Vaqt o'yinga muvaffaqiyatli ulangandan keyingina hisobdan chiqariladi.",
        "баланс: ": "balans:",
        "нужен вход": "kirish kerak",
        "Состояние": "Holat",
        "обновляется автоматически": "avtomatik yangilanadi",
        "Занято": "Band",
        "без очереди": "navbatsiz",
        "Пинг": "Ping",
        "списывается после подключения": "ulanishdan keyin hisobdan chiqarildi",
        "Настроить экран": "Ekranni moslashtiring",
        "FPS · качество · HDR": "FPS · sifat · HDR",
        "колл центр": "qo'ng'iroq markazi",
        " из ": "dan",
        "Войдите, чтобы открыть каталог игр": "O'yin katalogini ochish uchun tizimga kiring",
        "Найти игру": "O'yin toping",
        "Все": "Hammasi",
        "Популярные": "Ommabop",
        "Доступные": "Mavjud",
        "Можно играть сейчас": "Hozir o'ynash mumkin",
        "Баланс CloudPlay": "CloudPlay-ni muvozanatlash",
        "Деньги для пополнений и игровое время для запуска PS5.": "To'ldirish uchun pul va PS5-ni ishga tushirish uchun o'yin vaqti.",
        "Активен": "Faol",
        "Денежный баланс": "Naqd pul qoldig'i",
        "Пополняется через Click. Можно покупать пакеты времени.": "Click orqali toʻldirish. Vaqt paketlarini sotib olishingiz mumkin.",
        "Пополнить баланс": "Balansni to'ldirish",
        "Списывается только после реального подключения к игре.": "U o'yinga haqiqiy ulanishdan keyingina hisobdan chiqariladi.",
        "Как это работает": "U qanday ishlaydi",
        "Пополняешь баланс через Click": "Balansni Click orqali to‘ldiring",
        "Покупаешь пакет игрового времени": "O'yin vaqti paketini sotib oling",
        "Минуты списываются после подключения": "Ulanishdan keyin daqiqalar yechib olinadi",
        "Обновить данные": "Ma'lumotlarni yangilash",
        "Быстрая покупка времени": "Tez vaqt xarid qilish",
        "Реальные пакеты и цены из CloudPlay API.": "CloudPlay API-dan haqiqiy paketlar va narxlar.",
        "Загрузка…": "Yuklanmoqda…",
        "Все пакеты": "Barcha paketlar",
        "Купить": "Sotib olish",
        "Оплата": "To'lov",
        "Click откроется в браузере. После оплаты данные можно обновить.": "Bosing brauzerda ochiladi. To'lovdan so'ng ma'lumotlar yangilanishi mumkin.",
        "История операций": "Operatsiya tarixi",
        "История пока пустая": "Hikoya hali ham bo'sh",
        "Пополнения, покупки пакетов и списания появятся здесь.": "To‘lovlar, paketli xaridlar va hisobdan chiqarishlar shu yerda paydo bo‘ladi.",
        "Можно играть сейчас.": "Siz hozir o'ynashingiz mumkin.",
        "Можно подождать. Мы напишем в Telegram, когда PS5 освободится.": "Siz kutishingiz mumkin. PS5 mavjud bo'lganda Telegramda yozamiz.",
        "Место: ": "Joy:",
        " · Ожидание: ": "· Kutish:",
        "Вы вошли через Telegram": "Siz Telegram orqali tizimga kirgansiz",
        "На аккаунте": "Hisob bo'yicha",
        "Доступно для игры": "O'ynash uchun mavjud",
        "Выйти": "Chiqish",
        "Недавние игры": "So'nggi o'yinlar",
        "Управление приложением, качеством игры, звуком и геймпадом. Всё в стиле CloudPlay — без технических экранов.": "Ilova, oʻyin sifati, ovoz va geympadni boshqaring. Hammasi CloudPlay uslubida - texnik ekranlarsiz.",
        "качество и поток": "sifat va oqim",
        "Экран": "Ekran",
        "картинка, цвет и рендер": "rasm, rang va render",
        "Звук": "Ovoz",
        "аудио и приватность": "audio va maxfiylik",
        "Геймпад": "Geympad",
        "контроллер и вибрация": "boshqaruvchi va tebranish",
        "Клавиатура": "Klaviatura",
        "клавиши и мышь": "kalitlari va sichqoncha",
        "профиль и поддержка": "profil va qo'llab-quvvatlash",
        "Как запускается и держится игровое подключение.": "O'yin aloqasi qanday ishga tushiriladi va saqlanadi.",
        "Картинка, FPS, кодек, цветовая схема и рендеринг.": "Rasm, FPS, kodek, rang sxemasi va renderlash.",
        "Звук, уведомления и приватность на экране.": "Ovoz, bildirishnomalar va ekrandagi maxfiylik.",
        "Контроллер, вибрация и D‑pad во время игры.": "O'yin davomida boshqaruvchi, tebranish va D-pad.",
        "Клавиши, мышь и сброс раскладки.": "Kalitlar, sichqoncha va tartibni tiklash.",
        "Профиль, баланс и помощь.": "Profil, balans va yordam.",
        "После выхода из игры": "O'yinni tark etgandan keyin",
        "Что делать с консолью после завершения.": "Tugatgandan keyin konsol bilan nima qilish kerak.",
        "Оставить как есть": "Xuddi shunday qoldiring",
        "Перевести в режим покоя": "Dam olish rejimiga o'ting",
        "Спросить": "So'rang",
        "При сворачивании": "Katlanayotganda",
        "Поведение при потере фокуса приложения.": "Ilova fokusi yo'qolganda xatti-harakatlar.",
        "Ничего не делать": "Hech narsa qilmang",
        "Режим покоя": "Dam olish rejimi",
        "Меню во время игры": "O'yin davomida menyu",
        "Быстрый доступ к настройкам в стриме.": "Oqimdagi sozlamalarga tezkor kirish.",
        "Статистика поверх игры": "O'yin boshida statistika",
        "FPS, задержка и сеть во время сессии.": "Seans davomida FPS, kechikish va tarmoq.",
        "Кнопка меню 1": "Menyu tugmasi 1",
        "Первое сочетание для меню в игре.": "O'yindagi birinchi menyu kombinatsiyasi.",
        "Нет": "Yo'q",
        "Кнопка меню 2": "Menyu tugmasi 2",
        "Второе сочетание для меню в игре.": "O'yindagi menyu uchun ikkinchi kombinatsiya.",
        "Разрешение CloudPlay": "CloudPlay ruxsati",
        "Основное качество для удалённой PS5.": "Masofaviy PS5 uchun asosiy sifat.",
        "Плавность игры: 30 или 60 кадров.": "O'yinning silliqligi: 30 yoki 60 kvadrat.",
        "Битрейт CloudPlay": "CloudPlay bit tezligi",
        "Скорость видео потока. Для 1080p обычно 15–25 Мбит/с.": "Video oqim tezligi. 1080p uchun odatda 15-25 Mbit / s.",
        " Мбит/с": "Mbit/s",
        "Кодек PS5": "PS5 kodek",
        "H265 обычно даёт лучшую картинку при том же битрейте.": "H265 odatda bir xil bit tezligida yaxshiroq tasvirni beradi.",
        "Профиль рендера": "Profilni ko'rsatish",
        "Быстрее или качественнее обработка картинки.": "Tezroq yoki yaxshiroq tasvirni qayta ishlash.",
        "Быстрый": "Tez",
        "Стандарт": "Standart",
        "Высокое качество": "Yuqori sifatli",
        "HQ + масштабирование": "HQ + masshtab",
        "HQ + продв. масштабирование": "HQ + adv. masshtablash",
        "Свой": "meniki",
        "Рендеринг": "Renderlash",
        "Vulkan обычно быстрее; OpenGL как запасной режим.": "Vulkan odatda tezroq; OpenGL zaxira rejimi sifatida.",
        "Дополнительный режим вывода кадра для Vulkan.": "Vulkan uchun qo'shimcha ramka chiqish rejimi.",
        "Смешивание кадров": "Ramkalarni aralashtirish",
        "Плавность обработки видео в рендере.": "Renderlashda videoni silliq qayta ishlash.",
        "Выкл": "Oʻchirilgan",
        "Цветовая схема": "Rang sxemasi",
        "Цветовой охват экрана: авто, стандартный или широкий.": "Ekran rang gamuti: avtomatik, standart yoki keng.",
        "Авто": "Avtomatik",
        "Гамма / HDR": "Gamma/HDR",
        "Передача яркости: SDR, sRGB, PQ HDR или HLG HDR.": "Yorqinlikni uzatish: SDR, sRGB, PQ HDR yoki HLG HDR.",
        "Вертикальная синхронизация": "Vertikal sinxronlash",
        "Меньше разрывов картинки, может добавить задержку.": "Tasvirning kamroq yirtilishi, bu kechikishni qo'shishi mumkin.",
        "Скрывать курсор": "Kursorni yashirish",
        "Убирает мышь поверх игры.": "Sichqonchani o'yindan uzoqlashtiradi.",
        "Видео и звук": "Video va ovoz",
        "Быстро отключить звук или картинку при необходимости.": "Agar kerak bo'lsa, ovoz yoki tasvirni tezda o'chiring.",
        "Всё включено": "Hammasi o'z ichiga",
        "Отключить звук": "Ovozsiz",
        "Отключить видео": "Videoni o'chirish",
        "Отключить всё": "Hamma narsani o'chirib qo'ying",
        "Устройство вывода": "Chiqish qurilmasi",
        "Куда выводить звук игры.": "O'yin ovozini qaerdan chiqarish kerak.",
        "Микрофон": "Mikrofon",
        "Устройство ввода для голосового чата.": "Ovozli suhbat uchun kiritish qurilmasi.",
        "Громкость": "Ovoz balandligi",
        "Общая громкость звука игры.": "O'yinning umumiy ovoz balandligi.",
        "Буфер аудио": "Audio bufer",
        "Больше буфер — стабильнее звук, но выше задержка.": "Kattaroq bufer yanada barqaror ovozni, lekin yuqori kechikishni anglatadi.",
        "Микрофон включён при старте": "Mikrofon ishga tushganda yoqilgan",
        "Автоматически открывать голос во время игры.": "Oʻynab turganda ovozni avtomatik ochish.",
        "Уведомления сети": "Tarmoq xabarnomalari",
        "Показывать предупреждения при просадках Wi‑Fi.": "Wi‑Fi susayganda ogohlantirishlarni ko‘rsatish.",
        "Геймпад в фоне": "Orqa fonda geympad",
        "Оставлять управление активным при потере фокуса.": "Fokus yo'qolganda boshqaruv faolligini saqlang.",
        "Кнопки по позиции": "Tugmalar joylashuvi bo'yicha",
        "Помогает, если кнопки контроллера перепутаны.": "Tekshirgich tugmalari aralashgan bo'lsa yordam beradi.",
        "Вибрация": "Tebranish",
        "Интенсивность вибрации и haptics.": "Vibratsiya intensivligi va haptikasi.",
        "Слабо": "Zaif",
        "Средне": "O'rtacha",
        "Сильно": "Qattiq",
        "Сила haptics": "Haptika kuchi",
        "Ручная тонкая настройка отклика.": "Javobni qo'lda nozik sozlash.",
        "Сенсорная крестовина": "Sensorli panel",
        "Дополнительная D‑pad логика для некоторых игр.": "Ba'zi o'yinlar uchun qo'shimcha D-pad mantig'i.",
        "Шаг крестовины": "O'zaro maydon",
        "Чувствительность сенсорной крестовины.": "Sensorli panelning sezgirligi.",
        "Разрешить управление с клавиатуры.": "Klaviaturani boshqarishga ruxsat bering.",
        "Мышь как тачпад": "Sichqoncha sensorli panel kabi",
        "Использовать мышь для тачпада контроллера.": "Tekshirish moslamasining sensorli paneli uchun sichqonchadan foydalaning.",
        "Раскладка клавиатуры": "Klaviatura tartibi",
        "для игры без геймпада": "geympadsiz o'ynash uchun",
        "Сбросить клавиши": "Tugmalarni tiklash",
        "Вернуть стандартную раскладку клавиатуры.": "Standart klaviatura tartibini tiklang.",
        "Сброс": "Tiklash",
        "Аккаунт подключён": "Hisob ulangan",
        "Приватный режим": "Shaxsiy rejim",
        "Скрывать данные аккаунта в трансляциях и скриншотах.": "Translyatsiyalar va skrinshotlarda hisob ma'lumotlarini yashirish.",
        "Безопасные логи": "Xavfsiz jurnallar",
        "Скрывать чувствительные данные в логах.": "Jurnallarda maxfiy ma'lumotlarni yashirish.",
        "Назначить клавишу": "Kalitni tayinlang",
        "Нажмите любую клавишу, чтобы назначить её на выбранную кнопку.": "Tanlangan tugmani belgilash uchun istalgan tugmani bosing.",
        "Открыть": "Ochish",
        "Крестик": "Xoch",
        "Круг": "Doira",
        "Квадрат": "Kvadrat",
        "Треугольник": "Uchburchak",
        "Крестовина влево": "D-pad chapga",
        "Крестовина вправо": "D-pad o'ng",
        "Крестовина вверх": "Yuqoriga o'tish",
        "Крестовина вниз": "Pastga o'ting",
        "L1 / левый бампер": "L1 / chap bamper",
        "R1 / правый бампер": "R1 / o'ng bamper",
        "L2 / левый триггер": "L2/chap tetik",
        "R2 / правый триггер": "R2/o'ng tetik",
        "L3 / нажать левый стик": "L3 / chap tugmachani bosing",
        "R3 / нажать правый стик": "R3 / o'ng tayoqni bosing",
        "Тачпад": "Sensorli panel",
        "Кнопка PS": "PS tugmasi",
        "Левый аналог вправо": "Chapdan o'ngga analog",
        "Левый аналог влево": "Chapdan chapga analog",
        "Левый аналог вверх": "Chap analog yuqoriga",
        "Левый аналог вниз": "Chap analog pastga",
        "Левый аналог горизонталь": "Chap analog gorizontal",
        "Левый аналог вертикаль": "Chap analog vertikal",
        "Правый аналог вправо": "O'ngdan o'ngga analog",
        "Правый аналог влево": "O'ngdan chapga analog",
        "Правый аналог вверх": "To'g'ri analog yuqoriga",
        "Правый аналог вниз": "O'ng analog pastga",
        "Правый аналог горизонталь": "O'ng analog gorizontal",
        "Правый аналог вертикаль": "O'ng analog vertikal",
        "Назначить": "Belgilash",
        "CloudPlay подготовит PS5 для игры": "CloudPlay PS5-ni o'yinga tayyorlaydi",
        "Как начнём": "Qanday boshlaymiz?",
        "1. Проверим вход · 2. Подготовим PS5 · 3. Подключим игру": "1. Kirishni tekshiring · 2. PS5 ni tayyorlang · 3. O'yinni ulang",
        "Отмена": "Bekor qilish",
        "Нажмите «Играть» — CloudPlay подготовит PS5 и подключит вас к игре.": "Play-ni bosing va CloudPlay PS5-ni tayyorlaydi va sizni o'yinga ulaydi.",
        "Закрыть": "Yopish",
        "Пополнение": "To'ldirish",
        "Выберите готовую сумму или введите свою": "Tayyor miqdorni tanlang yoki o'zingiznikini kiriting",
        "Другая сумма": "Boshqa miqdor",
        "После выбора суммы откроется страница оплаты.": "Miqdorni tanlagandan so'ng, to'lov sahifasi ochiladi.",
        "Подтвердите покупку": "Xaridingizni tasdiqlang",
        "Свяжитесь с нами по телефону": "Biz bilan telefon orqali bog'laning",
        "Напишите нам в Telegram": "Bizga Telegram orqali yozing",
        "Опишите проблему": "Muammoni tasvirlab bering",
        "Написать": "Yozing",
        "Язык": "Til",
        "Русский": "Ruscha",
        "Английский": "Inglizcha",
        "Узбекский": "O‘zbekcha",
        "язык интерфейса": "interfeys tili",
        "Интерфейс и язык": "Interfeys va til",
        "Выберите язык приложения. Интерфейс переключится сразу.": "Ilova tilini tanlang. Interfeys darhol o'zgaradi.",
        "Язык приложения": "Ilova tili",
        "Меняет все разделы CloudPlay Console.": "CloudPlay Console-ning barcha bo'limlarini o'zgartiradi.",
        "Сейчас выбран": "Tanlangan",
        "Локализация": "Mahalliylashtirish",
        "RU · EN · UZ": "RU · UZ · UZ"
})

    function trText(text) {
        var lang = cloudStore.appLanguage && cloudStore.appLanguage.length > 0 ? cloudStore.appLanguage : "ru"
        if (lang === "en")
            return i18nEn[text] || text
        if (lang === "uz")
            return i18nUz[text] || text
        return text
    }

    function languageName(code) {
        if (code === "en") return trText("Английский")
        if (code === "uz") return trText("Узбекский")
        return trText("Русский")
    }

    function settingsCategoryTitle(key) {
        if (key === "stream") return trText("Игра")
        if (key === "display") return trText("Экран")
        if (key === "audio") return trText("Звук")
        if (key === "controls") return trText("Геймпад")
        if (key === "keyboard") return trText("Клавиатура")
        if (key === "language") return trText("Язык")
        if (key === "updates") return trText("Обновление")
        return trText("Аккаунт")
    }

    function settingsCategorySubtitle(key) {
        if (key === "stream") return trText("Как запускается и держится игровое подключение.")
        if (key === "display") return trText("Картинка, FPS, кодек, цветовая схема и рендеринг.")
        if (key === "audio") return trText("Звук, уведомления и приватность на экране.")
        if (key === "controls") return trText("Контроллер, вибрация и D‑pad во время игры.")
        if (key === "keyboard") return trText("Клавиши, мышь и сброс раскладки.")
        if (key === "language") return trText("Выберите язык приложения. Интерфейс переключится сразу.")
        if (key === "updates") return trText("Проверка новой версии и установка релиза.")
        return trText("Профиль, баланс и помощь.")
    }

    function settingsCategoryIcon(key) {
        if (key === "stream") return "qrc:/icons/cp-play.svg"
        if (key === "display") return "qrc:/icons/cp-display.svg"
        if (key === "audio") return "qrc:/icons/cp-bell.svg"
        if (key === "controls") return "qrc:/icons/cp-gamepad.svg"
        if (key === "keyboard") return "qrc:/icons/cp-keyboard.svg"
        if (key === "language") return "qrc:/icons/cp-settings.svg"
        if (key === "updates") return "qrc:/icons/cp-refresh.svg"
        return "qrc:/icons/cp-user.svg"
    }

    function absoluteMediaUrl(url) {
        if (url === null || url === undefined)
            return ""
        var out = String(url).trim()
        if (out.length === 0)
            return ""
        if (out.indexOf("qrc:/") === 0 || out.indexOf("file:/") === 0 || out.indexOf("data:") === 0)
            return out
        if (out.indexOf("//") === 0)
            return "https:" + out
        if (out.indexOf("http://ps-api.cloudplay.uz/") === 0)
            out = "https://ps-api.cloudplay.uz/" + out.substring("http://ps-api.cloudplay.uz/".length)
        else if (out.indexOf("http://") === 0)
            out = "https://" + out.substring("http://".length)
        else if (out.indexOf("https://") === 0)
            return out
        else {
            if (out.charAt(0) !== "/")
                out = "/" + out
            out = "https://ps-api.cloudplay.uz" + out
        }
        return out
    }

    function firstNonEmpty(values) {
        for (var i = 0; i < values.length; ++i) {
            if (values[i] !== null && values[i] !== undefined && String(values[i]).trim().length > 0)
                return String(values[i]).trim()
        }
        return ""
    }

    function pickGameImage(g) {
        if (!g)
            return ""
        var media = g.media || g.assets || g.images || {}
        var nestedCover = ""
        if (Array.isArray(media) && media.length > 0)
            nestedCover = media[0].url || media[0].src || media[0].image || ""
        return firstNonEmpty([
            g.cover_image_url, g.coverImageUrl, g.cover_url, g.coverUrl,
            g.poster_url, g.posterUrl, g.poster, g.thumbnail_url, g.thumbnailUrl,
            g.banner_image_url, g.bannerImageUrl, g.image_url, g.imageUrl,
            g.cover, g.image, g.logo,
            media.cover_image_url, media.coverUrl, media.cover, media.poster_url,
            media.poster, media.thumbnail_url, media.image_url, media.image,
            nestedCover
        ])
    }

    function navKeyForPage(page) {
        if (page === "play")
            return "home"
        if (page === "support")
            return "botsupport"
        return page
    }

    function humanSessionStatus(status) {
        var raw = String(status || "").toLowerCase()
        if (raw === "completed" || raw === "done" || raw === "stopped" || raw === "finished")
            return consolePane.trText("Завершено")
        if (raw === "active" || raw === "running" || raw === "connected")
            return consolePane.trText("Идёт игра")
        if (raw === "failed" || raw === "error")
            return consolePane.trText("Ошибка")
        return status && String(status).length > 0 ? String(status) : consolePane.trText("Завершено")
    }

    FontLoader { id: unboundedFont; source: "qrc:/fonts/Unbounded.ttf" }
    FontLoader { id: manropeFont; source: "qrc:/fonts/Manrope.ttf" }
    FontLoader { id: jetBrainsMonoFont; source: "qrc:/fonts/JetBrainsMono.ttf" }

    Settings {
        id: cloudStore
        category: "CloudPlayApi"
        property string accessToken: ""
        property string refreshToken: ""
        property string displayName: ""
        property string userId: ""
        property string appLanguage: "ru"
        property int minutesBalance: 0
    }

    Timer {
        id: loginPollTimer
        interval: 1500
        repeat: true
        running: false
        onTriggered: pollTelegramLogin()
    }

    Timer {
        id: streamStartTimer
        // Was 4.5s, which made PLAY/controller handoff feel delayed after wake.
        // Backend already returns ready NAT/session data; keep only a short guard.
        interval: 900
        repeat: false
        running: false
        onTriggered: consolePane.startPendingCloudPlayStream()
    }

    Timer {
        id: cloudPlayStreamMonitorTimer
        interval: 2000
        repeat: true
        running: false
        onTriggered: consolePane.checkCloudPlayStreamLifecycle()
    }

    Timer {
        id: cloudPlayHeartbeatTimer
        interval: 30000
        repeat: true
        running: false
        onTriggered: consolePane.sendCloudPlayHeartbeat()
    }

    Timer {
        id: cloudPlayAutotestStartTimer
        interval: 6500
        repeat: false
        running: false
        onTriggered: {
            consolePane.apiStatusText = consolePane.trText("Тест: запускаем игру…")
            consolePane.startCloudPlaySession()
            if (!cloudPlayAutotestStopTimer.running)
                cloudPlayAutotestStopTimer.start()
        }
    }

    Timer {
        id: cloudPlayAutotestStopTimer
        interval: 165000
        repeat: false
        running: false
        onTriggered: {
            consolePane.apiStatusText = consolePane.trText("Тест: завершаем игру…")
            try { Chiaki.stopSession(false) } catch (e) {}
            consolePane.stopCloudPlaySession("autotest_complete", function(ok, payload) {
                Chiaki.window.close()
            })
        }
    }

    Connections {
        target: Chiaki
        function onCloudPlayNativeConnected() {
            console.log("CloudPlay start_flow native_connected_signal session=" + consolePane.activeSessionId)
            if (consolePane.activeSessionId.length > 0)
                consolePane.markCloudPlayNativeConnected()
            else
                consolePane.nativeConnectedSignalPending = true
        }
        function onCloudPlayNativeSessionQuit() {
            console.log("CloudPlay start_flow native_session_quit starting=" + consolePane.nativeStreamStarting + " active=" + consolePane.streamActive + " session=" + consolePane.activeSessionId)
            if ((consolePane.nativeStreamStarting || consolePane.streamActive) && consolePane.activeSessionId.length > 0)
                consolePane.handleCloudPlayNativeSessionEnded(consolePane.streamActive ? "user_stop" : "connect_failed")
        }
        function onSessionChanged(session) {
            if (session)
                consolePane.nativeStreamSessionSeen = true
            console.log("CloudPlay start_flow qml_session_changed hasSession=" + (!!session) + " connected=" + (!!session && session.connected) + " starting=" + consolePane.nativeStreamStarting + " seen=" + consolePane.nativeStreamSessionSeen)
            if (session && session.connected && consolePane.activeSessionId.length > 0)
                consolePane.markCloudPlayNativeConnected()
            if (!session && (consolePane.nativeStreamStarting || consolePane.streamActive) && consolePane.activeSessionId.length > 0) {
                // During startup the QML session property can be briefly null before
                // StreamSession is published. Android waits for the stream activity;
                // don't tear down backend reservation on this transient null.
                if (consolePane.nativeStreamStarting && !consolePane.nativeStreamSessionSeen)
                    return
                consolePane.handleCloudPlayNativeSessionEnded(consolePane.streamActive ? "user_stop" : "connect_failed")
            }
        }
        function onSessionError(title, text) {
            console.log("CloudPlay start_flow qml_session_error title=" + title + " text=" + text)
            if ((consolePane.nativeStreamStarting || consolePane.streamActive) && consolePane.activeSessionId.length > 0)
                consolePane.handleCloudPlayNativeSessionEnded("connect_failed")
        }
    }

    Connections {
        target: Chiaki.session
        ignoreUnknownSignals: true
        function onConnectedChanged() {
            if (Chiaki.session && Chiaki.session.connected && consolePane.activeSessionId.length > 0)
                consolePane.markCloudPlayNativeConnected()
        }
    }

    Timer {
        id: cloudPlayPingTimer
        interval: 10000
        repeat: true
        running: consolePane.currentPage === "play" && consolePane.cloudPlayLoggedIn
        onTriggered: consolePane.measureCloudPlayPing()
    }

    Timer {
        id: cloudPlayQueuePollTimer
        interval: 5000
        repeat: true
        running: consolePane.cloudPlayLoggedIn && (consolePane.queuePosition > 0 || consolePane.queueTicketId.length > 0) && !consolePane.streamActive && !consolePane.nativeStreamStarting
        onTriggered: consolePane.loadQueueStatus(true)
    }

    Component.onCompleted: {
        minutesBalance = cloudStore.minutesBalance
        checkForUpdates(true)
        if (cloudStore.accessToken.length > 0) {
            apiStatusText = consolePane.trText("Загружаем данные…")
            loadCloudPlayState()
            if (Chiaki.cloudPlayEnvFlag("CLOUDPLAY_AUTOTEST"))
                cloudPlayAutotestStartTimer.start()
        } else {
            apiStatusText = consolePane.trText("Войдите через Telegram, чтобы играть")
            packagesStatusText = consolePane.trText("Войдите через Telegram, чтобы купить время.")
        }
    }

    onCurrentPageChanged: {
        if ((currentPage === "wallet" || currentPage === "packages") && cloudPlayLoggedIn)
            loadPackages()
        if (currentPage === "play" && cloudPlayLoggedIn)
            measureCloudPlayPing()
    }

    function setNetworkPing(value) {
        var n = Math.round(Number(value || 0))
        if (n > 0 && n < 10000)
            networkPingMs = n
    }

    function pingValueText() {
        return networkPingMs > 0 ? (networkPingMs + " ms") : "—"
    }

    function pingStatusText() {
        if (networkPingMs <= 0)
            return consolePane.trText("измеряем")
        if (networkPingMs <= 25)
            return consolePane.trText("отлично")
        if (networkPingMs <= 45)
            return consolePane.trText("хорошо")
        if (networkPingMs <= 80)
            return consolePane.trText("нормально")
        return consolePane.trText("высокий")
    }

    function pingColor() {
        if (networkPingMs <= 0)
            return "#8c9ab8"
        if (networkPingMs <= 45)
            return "#55f0a5"
        if (networkPingMs <= 80)
            return "#ffb86b"
        return "#ff6b6b"
    }

    function pingFromPayload(payload) {
        if (!payload)
            return 0
        var direct = payload.ping_ms || payload.pingMs || payload.latency_ms || payload.latencyMs || payload.network_ping_ms || payload.networkPingMs || payload.rtt || payload.rtt_ms || payload.rttMs
        if (direct !== undefined && direct !== null && Number(direct) > 0)
            return Number(direct)
        var status = payload.status || payload.connection || payload.network || payload.edge || payload.datacenter || payload.data_center || payload.dc || {}
        var nested = status.ping_ms || status.pingMs || status.latency_ms || status.latencyMs || status.rtt || status.rtt_ms || status.rttMs
        return Number(nested || 0)
    }

    function measureCloudPlayPing() {
        if (!cloudPlayLoggedIn)
            return
        var started = Date.now()
        request("GET", "/queue/status", null, true, function(ok, status, payload) {
            var measured = Date.now() - started
            var apiPing = pingFromPayload(payload)
            setNetworkPing(apiPing > 0 ? apiPing : measured)
        })
    }

    function parseJson(text) {
        if (!text || text.length === 0)
            return ({})
        try {
            return JSON.parse(text)
        } catch (e) {
            return ({ raw: text })
        }
    }

    function request(method, path, body, auth, callback, retryOn401) {
        var xhr = new XMLHttpRequest()
        xhr.open(method, apiBaseUrl + path)
        xhr.setRequestHeader("Accept", "application/json")
        if (body !== null && body !== undefined)
            xhr.setRequestHeader("Content-Type", "application/json")
        if (auth && cloudStore.accessToken.length > 0)
            xhr.setRequestHeader("Authorization", "Bearer " + cloudStore.accessToken)
        xhr.onreadystatechange = function() {
            if (xhr.readyState !== XMLHttpRequest.DONE)
                return
            var payload = parseJson(xhr.responseText)
            if (auth && xhr.status === 401 && retryOn401 !== false && cloudStore.refreshToken.length > 0) {
                refreshAccessToken(function(ok) {
                    if (ok)
                        request(method, path, body, auth, callback, false)
                    else
                        callback(false, xhr.status, payload)
                })
                return
            }
            callback(xhr.status >= 200 && xhr.status < 300, xhr.status, payload)
        }
        xhr.send(body !== null && body !== undefined ? JSON.stringify(body) : null)
    }

    function updatePlatformKey() {
        return Qt.platform.os === "osx" ? "macos" : (Qt.platform.os === "windows" ? "windows" : Qt.platform.os)
    }

    function normalizeVersionPart(part) {
        var n = parseInt(String(part || "0").replace(/[^0-9].*$/, ""), 10)
        return isNaN(n) ? 0 : n
    }

    function compareVersions(a, b) {
        var av = String(a || "0").split(/[.+-]/)
        var bv = String(b || "0").split(/[.+-]/)
        var len = Math.max(av.length, bv.length, 3)
        for (var i = 0; i < len; ++i) {
            var ai = normalizeVersionPart(av[i])
            var bi = normalizeVersionPart(bv[i])
            if (ai > bi) return 1
            if (ai < bi) return -1
        }
        return 0
    }

    function pickUpdateArtifact(payload) {
        var platform = updatePlatformKey()
        var platforms = payload.platforms || payload.artifacts || {}
        var artifact = payload[platform] || platforms[platform] || {}
        var url = firstNonEmpty([
            artifact.url, artifact.download_url, artifact.downloadUrl,
            payload[platform + "_url"], payload[platform + "Url"],
            platform === "windows" ? payload.windows_url : payload.macos_url,
            platform === "windows" ? payload.windowsUrl : payload.macosUrl,
            payload.url, payload.download_url, payload.downloadUrl
        ])
        var version = firstNonEmpty([artifact.version, payload.version, payload.latest_version, payload.latestVersion])
        var notes = firstNonEmpty([artifact.notes, artifact.changelog, payload.notes, payload.changelog, payload.release_notes, payload.releaseNotes])
        return ({ version: version, url: url, notes: notes })
    }

    function checkForUpdates(silent) {
        if (updateChecking)
            return
        updateChecking = true
        if (!silent)
            updateStatusText = consolePane.trText("Проверяем обновление…")
        var xhr = new XMLHttpRequest()
        xhr.open("GET", updateManifestUrl + "?t=" + Date.now())
        xhr.setRequestHeader("Accept", "application/json")
        xhr.onreadystatechange = function() {
            if (xhr.readyState !== XMLHttpRequest.DONE)
                return
            updateChecking = false
            var payload = parseJson(xhr.responseText)
            if (xhr.status < 200 || xhr.status >= 300) {
                if (!silent)
                    updateStatusText = consolePane.trText("Не удалось проверить обновление. Попробуйте позже.")
                return
            }
            var artifact = pickUpdateArtifact(payload)
            updateLatestVersion = artifact.version
            updateDownloadUrl = artifact.url
            updateReleaseNotes = artifact.notes
            if (artifact.version.length === 0 || artifact.url.length === 0) {
                updateAvailable = false
                updateStatusText = consolePane.trText("Обновление пока не опубликовано.")
                return
            }
            updateAvailable = compareVersions(artifact.version, Qt.application.version) > 0
            if (updateAvailable)
                updateStatusText = consolePane.trText("Доступна новая версия") + " " + artifact.version
            else
                updateStatusText = consolePane.trText("Установлена последняя версия") + " " + Qt.application.version
        }
        xhr.send()
    }

    function openUpdateDownload() {
        if (updateDownloadUrl.length > 0)
            Qt.openUrlExternally(updateDownloadUrl)
        else
            checkForUpdates(false)
    }

    function refreshAccessToken(done) {
        var refreshToken = cloudStore.refreshToken
        if (refreshToken.length === 0) {
            done(false)
            return
        }
        request("POST", "/auth/refresh", { refreshToken: refreshToken }, false, function(ok, status, payload) {
            if (ok && payload.access_token) {
                cloudStore.accessToken = payload.access_token
                if (payload.refresh_token)
                    cloudStore.refreshToken = payload.refresh_token
                done(true)
            } else {
                apiStatusText = consolePane.trText("Вход истёк. Войдите через Telegram снова.")
                done(false)
            }
        }, false)
    }

    function applyUser(user) {
        if (!user)
            return
        cloudStore.userId = user.id || cloudStore.userId
        cloudStore.displayName = user.displayName || user.telegramUsername || user.phone || cloudStore.displayName
        cloudStore.minutesBalance = Number(user.minutesBalance || 0)
        minutesBalance = cloudStore.minutesBalance
    }

    function applyTokens(tokens) {
        if (!tokens)
            return
        cloudStore.accessToken = tokens.access_token || tokens.accessToken || cloudStore.accessToken
        cloudStore.refreshToken = tokens.refresh_token || tokens.refreshToken || cloudStore.refreshToken
    }


    function localGameImage(index) {
        return "qrc:/icons/cloudplay-game-" + ((index % 5) + 1) + ".png"
    }

    function gameAccent(index) {
        var colors = ["#2b9cff", "#8b5cf6", "#20d3a2", "#f59e0b"]
        return colors[index % colors.length]
    }

    function gameAccentDark(index) {
        var colors = ["#102e52", "#291947", "#0f3a34", "#3b260e"]
        return colors[index % colors.length]
    }

    function gamePopularityScore(g, index) {
        if (!g)
            return 0
        var score = Math.max(0, 1000 - index)
        if (g.is_popular || g.popular || g.isPopular)
            score += 10000
        if (g.is_featured || g.featured || g.isFeatured)
            score += 8000
        if (g.trending || g.is_trending || g.isTrending)
            score += 6000
        score += Number(g.popularity || g.popularity_score || g.popularityScore || 0)
        score += Number(g.play_count || g.playCount || g.sessions_count || g.sessionsCount || 0) / 10
        score -= Number(g.sort_order || g.sortOrder || g.order || 0) / 100
        return score
    }

    function normalizeGameSummary(g, index) {
        g = g || {}
        var img = pickGameImage(g)
        return {
            title: g.title || g.name || (consolePane.trText("Игра ") + (index + 1)),
            genre: g.genre || g.category || g.platform || "PS5",
            image: absoluteMediaUrl(img.length > 0 ? img : localGameImage(index)),
            score: gamePopularityScore(g, index)
        }
    }

    function normalizeFeaturedGames(items) {
        if (!items || items.length === 0)
            return featuredGames
        var ranked = []
        for (var i = 0; i < items.length; ++i)
            ranked.push(normalizeGameSummary(items[i], i))
        ranked.sort(function(a, b) { return b.score - a.score })
        var out = []
        for (var j = 0; j < ranked.length && j < 12; ++j)
            out.push({ title: ranked[j].title, genre: ranked[j].genre, image: ranked[j].image })
        return out
    }

    function normalizeLibraryGames(items) {
        if (!items || items.length === 0)
            return libraryGames.length > 0 ? libraryGames : featuredGames
        var out = []
        for (var i = 0; i < items.length && i < 48; ++i) {
            var g = items[i] || {}
            var img = pickGameImage(g)
            out.push({
                id: String(g.id || g.game_id || g.slug || ("game-" + i)),
                title: g.title || g.name || (consolePane.trText("Игра ") + (i + 1)),
                genre: g.genre || g.category || g.platform || "PS5",
                image: absoluteMediaUrl(img.length > 0 ? img : localGameImage(i)),
                status: g.status || g.availability || (availableSlots > 0 ? consolePane.trText("Готово") : consolePane.trText("Очередь"))
            })
        }
        return out
    }

    function filteredLibraryGames() {
        var q = librarySearchQuery.toLowerCase().trim()
        var out = []
        for (var i = 0; i < libraryGames.length; ++i) {
            var g = libraryGames[i] || {}
            var title = String(g.title || "")
            var genre = String(g.genre || "")
            var status = String(g.status || "")
            var hay = (title + " " + genre + " " + status).toLowerCase()
            if (q.length > 0 && hay.indexOf(q) < 0)
                continue
            if (libraryFilter === "ready" && status.toLowerCase().indexOf(consolePane.trText("готов")) < 0 && status.toLowerCase().indexOf("available") < 0)
                continue
            if (libraryFilter === "popular" && i >= 12)
                continue
            out.push(g)
        }
        return out
    }

    function openGameDetails(game) {
        if (!game)
            return
        selectedGameTitle = game.title || consolePane.trText("Игра CloudPlay")
        selectedGameGenre = game.genre || "PS5"
        selectedGameImage = game.image || ""
        selectedGameStatus = game.status || (availableSlots > 0 ? consolePane.trText("Готово к запуску") : consolePane.trText("Можно в очередь"))
        gameDetailsPopup.open()
    }

    function launchSelectedGame() {
        gameDetailsPopup.close()
        openPlayStart()
    }

    function sessionTitle(item) {
        if (!item)
            return "PS5 Session"
        return item.slot_name || item.slot_id || "PS5 Session"
    }

    function sessionTime(item) {
        if (!item)
            return "—"
        var raw = item.started_at || item.created_at || item.ended_at || ""
        if (raw.length < 10)
            return "—"
        return raw.substring(0, 10) + " " + raw.substring(11, 16)
    }

    function sessionDuration(item) {
        if (!item)
            return "—"
        var mins = Number(item.played_minutes || item.charged_minutes || 0)
        if (mins <= 0)
            return "—"
        if (mins < 60)
            return mins + consolePane.trText(" мин")
        return Math.floor(mins / 60) + consolePane.trText(" ч ") + (mins % 60) + consolePane.trText(" мин")
    }

    function loadSessionHistory() {
        if (!cloudPlayLoggedIn)
            return
        request("GET", "/sessions/history", null, true, function(ok, status, payload) {
            if (!ok || !payload || !payload.sessions)
                return
            var out = []
            for (var i = 0; i < payload.sessions.length && i < 3; ++i) {
                var it = payload.sessions[i]
                out.push({ title: sessionTitle(it), time: sessionTime(it), duration: sessionDuration(it), status: humanSessionStatus(it.status || "completed"), slot: it.slot_id || "—" })
            }
            if (out.length > 0)
                recentSessions = out
        })
    }

    // Smoke marker kept for legacy check only: "Telegram Login". UI text stays product-facing.
    function beginTelegramLogin() {
        apiBusy = true
        apiStatusText = consolePane.trText("Открываем вход через Telegram…")
        request("POST", "/auth/telegram/request", { platform: updatePlatformKey(), appVersion: Qt.application.version }, false, function(ok, status, payload) {
            apiBusy = false
            if (!ok) {
                apiStatusText = consolePane.trText("Не удалось открыть вход через Telegram. Попробуйте ещё раз.")
                root.showInfoDialog(qsTr("CloudPlay"), apiStatusText)
                return
            }
            loginCode = payload.code || ""
            loginUrl = payload.telegramUrl || ""
            apiStatusText = consolePane.trText("Подтвердите вход в Telegram · код ") + loginCode
            if (loginUrl.length > 0)
                Qt.openUrlExternally(loginUrl)
            loginPollTimer.start()
        })
    }

    function pollTelegramLogin() {
        if (loginCode.length === 0)
            return
        request("GET", "/auth/telegram/status?code=" + encodeURIComponent(loginCode), null, false, function(ok, status, payload) {
            if (!ok) {
                apiStatusText = consolePane.trText("Ждём подтверждения в Telegram…")
                return
            }
            if (payload.status === "confirmed" || payload.status === "CONFIRMED") {
                loginPollTimer.stop()
                applyUser(payload.user)
                applyTokens(payload.tokens)
                apiStatusText = consolePane.trText("Вход выполнен · загружаем данные…")
                loadCloudPlayState()
                root.showInfoDialog(qsTr("CloudPlay"), qsTr(consolePane.trText("Вы вошли через Telegram.")))
            } else if (payload.status === "expired" || payload.status === "EXPIRED") {
                loginPollTimer.stop()
                apiStatusText = consolePane.trText("Код истёк. Войдите через Telegram снова.")
            } else {
                apiStatusText = consolePane.trText("Ждём подтверждения в Telegram · код ") + loginCode
            }
        })
    }

    function logoutCloudPlay() {
        loginPollTimer.stop()
        cloudStore.accessToken = ""
        cloudStore.refreshToken = ""
        cloudStore.displayName = ""
        cloudStore.userId = ""
        cloudStore.minutesBalance = 0
        minutesBalance = 0
        activeSessionId = ""
        activeSlotId = ""
        activeSessionStatus = ""
        connectHost = ""
        connectPorts = ""
        profileBlobReady = false
        availableSlots = 0
        queueCount = 0
        clearQueueState()
        apiStatusText = consolePane.trText("Вы вышли. Войдите снова, чтобы играть.")
    }

    function loadCloudPlayState() {
        if (!cloudPlayLoggedIn)
            return
        apiBusy = true
        request("GET", "/me", null, true, function(ok, status, payload) {
            if (ok)
                applyUser(payload)
        })
        request("GET", "/home", null, true, function(ok, status, payload) {
            apiBusy = false
            if (!ok) {
                apiStatusText = consolePane.trText("Не удалось обновить данные. Попробуйте ещё раз.")
                return
            }
            minutesBalance = Number(payload.minutesBalance || 0)
            cloudStore.minutesBalance = minutesBalance
            walletBalanceUzs = Number(payload.walletBalanceUzs || 0)
            availableSlots = Number(payload.availablePs5Slots || 0)
            queueCount = Number(payload.queueCount || 0)
            queueText = payload.queueText || ""
            setNetworkPing(pingFromPayload(payload))
            var homeGames = listFromPayload(payload, ["featuredGames", "featured_games", "popularGames", "popular_games", "recommendedGames", "recommended_games", "games", "catalog"])
            if (homeGames.length > 0) {
                featuredGames = normalizeFeaturedGames(homeGames)
                libraryGames = normalizeLibraryGames(homeGames)
            }
            if (payload.app_config && payload.app_config.support) {
                supportTelegramUrl = payload.app_config.support.telegram_url || supportTelegramUrl
                supportCallDisplay = payload.app_config.support.call_display || supportCallDisplay
            }
            apiStatusText = consolePane.trText("Готово · свободных PS5: ") + availableSlots + consolePane.trText(" · время: ") + minutesBalance + consolePane.trText(" мин")
            loadCurrentSession(false)
            loadSessionHistory()
            loadPackages()
            loadGamesCatalog()
            loadQueueStatus()
            loadWalletTransactions()
        })
    }

    function loadCurrentSession(showDialog) {
        if (!cloudPlayLoggedIn)
            return
        request("GET", "/sessions/current", null, true, function(ok, status, payload) {
            if (!ok || !payload || !payload.session) {
                if (showDialog)
                    root.showInfoDialog(qsTr("CloudPlay"), qsTr(consolePane.trText("Сейчас игра не запущена.")))
                return
            }
            applySession(payload.session)
            if (showDialog)
                root.showInfoDialog(qsTr("CloudPlay"), qsTr(consolePane.trText("Игра загружена.")))
        })
    }

    function normalizeSessionPayload(payload) {
        var p = payload || null
        for (var i = 0; i < 4 && p; ++i) {
            var n = p.session || p.launch_session || p.launchSession || p.ready_session || p.readySession || p.data || p.result || p.payload || null
            if (!n || n === p)
                break
            p = n
        }
        return p
    }

    function sessionConnectPayload(session) {
        var s = normalizeSessionPayload(session)
        if (!s)
            return ({})
        return s.connect || s.launch || s.stream || s.connection || s
    }

    function sessionProfileReady(session) {
        var s = normalizeSessionPayload(session) || ({})
        var c = sessionConnectPayload(s)
        var p = c.profile || s.profile || ({})
        return !!c.profile_blob_present || !!c.profileBlobPresent || !!c.profile_blob || !!c.profileBlob ||
               !!c.profile_data || !!c.profileData || !!p.blob || !!p.profile_blob || !!p.profileBlob || !!p.data || !!p.base64
    }

    function applySession(session) {
        session = normalizeSessionPayload(session) || session
        activeSessionId = String(session.session_id || session.sessionId || session.id || "")
        activeSlotId = session.slot_id || session.slotId || session.slot || ""
        activeSessionStatus = session.status || ""
        var c = sessionConnectPayload(session)
        connectHost = c.host || c.external_host || c.externalHost || c.remote_host || c.remoteHost || c.public_host || c.publicHost || c.address || c.addr || ""
        connectPorts = "session " + (c.ctrl_port || c.ctrlPort || c.control_port || c.controlPort || c.session_port || c.sessionPort || c.remote_port || c.remotePort || "9295") + ", stream " + (c.stream_port || c.streamPort || c.video_port || c.videoPort || "9296") + ", wake " + (c.wake_port || c.wakePort || "9302")
        profileBlobReady = sessionProfileReady(session)
        apiStatusText = consolePane.trText("PS5 подготовлена · подключаем игру")
        if (nativeConnectedSignalPending && activeSessionId.length > 0) {
            console.log("CloudPlay start_flow applying_pending_native_connected session=" + activeSessionId)
            nativeConnectedSignalPending = false
            markCloudPlayNativeConnected()
        }
    }

    function sessionControlPort(session) {
        var c = sessionConnectPayload(session)
        return Number(c.ctrl_port || c.ctrlPort || c.control_port || c.controlPort || c.session_port || c.sessionPort || c.remote_port || c.remotePort || 9295)
    }

    function sessionHost(session) {
        var c = sessionConnectPayload(session)
        return String(c.host || c.external_host || c.externalHost || c.remote_host || c.remoteHost || c.public_host || c.publicHost || c.address || c.addr || "")
    }

    function resetLaunchUi(statusText) {
        launchUiTimer.stop()
        streamStartTimer.stop()
        cloudPlayStreamMonitorTimer.stop()
        cloudPlayHeartbeatTimer.stop()
        launchProgress = 0
        launchStep = 0
        streamActive = false
        nativeStreamStarting = false
        nativeStreamStartedAtMs = 0
        nativeStreamConnectedSinceMs = 0
        nativeStreamSessionSeen = false
        nativeConnectedSignalPending = false
        cloudPlayStreamConnectedNotified = false
        if (statusText && statusText.length > 0)
            launchStatusText = statusText
    }

    function notifyCloudPlayStreamConnected() {
        if (cloudPlayStreamConnectedNotified || activeSessionId.length === 0)
            return
        cloudPlayStreamConnectedNotified = true
        request("POST", "/sessions/" + activeSessionId + "/stream-connected", { platform: updatePlatformKey() }, true, function(ok, status, payload) {
            if (ok) {
                apiStatusText = consolePane.trText("Игра подключена · время пошло")
                launchStatusText = apiStatusText
                if (!cloudPlayHeartbeatTimer.running)
                    cloudPlayHeartbeatTimer.start()
            } else {
                apiStatusText = consolePane.trText("Игра запущена · обновляем время")
                cloudPlayStreamConnectedNotified = false
            }
        })
    }

    function sendCloudPlayHeartbeat() {
        if (!streamActive || activeSessionId.length === 0)
            return
        request("POST", "/sessions/" + activeSessionId + "/heartbeat", { platform: updatePlatformKey() }, true, function(ok, status, payload) {
            if (ok && payload && payload.remaining_minutes !== undefined) {
                minutesBalance = Number(payload.remaining_minutes)
                cloudStore.minutesBalance = minutesBalance
            }
        })
    }

    function checkCloudPlayStreamLifecycle() {
        if ((!streamActive && !nativeStreamStarting) || activeSessionId.length === 0) {
            cloudPlayStreamMonitorTimer.stop()
            return
        }
        if (!Chiaki.session) {
            var elapsed = nativeStreamStartedAtMs > 0 ? (Date.now() - nativeStreamStartedAtMs) : 0
            console.log("CloudPlay start_flow monitor_no_session elapsedMs=" + elapsed + " seen=" + nativeStreamSessionSeen)
            if (nativeStreamStarting && !nativeStreamSessionSeen && elapsed < 30000)
                return
            handleCloudPlayNativeSessionEnded(streamActive ? "user_stop" : "stream_quit")
            return
        }
        nativeStreamSessionSeen = true
        var sessionElapsed = nativeStreamStartedAtMs > 0 ? (Date.now() - nativeStreamStartedAtMs) : 0
        if (nativeStreamStarting && nativeStreamConnectedSinceMs <= 0 && sessionElapsed > 15000) {
            console.log("CloudPlay start_flow native_start_timeout session=" + activeSessionId + " elapsedMs=" + sessionElapsed)
            handleCloudPlayNativeSessionFailed("connect_failed")
            return
        }
        if (Chiaki.session.connected) {
            if (nativeStreamConnectedSinceMs <= 0) {
                nativeStreamConnectedSinceMs = Date.now()
                console.log("CloudPlay start_flow native_connected_pending session=" + activeSessionId)
                return
            }
            // Pylux/Chiaki can briefly report control-level connected before the
            // Remote Play app accepts the stream. When the console later reports
            // "Remote Play already in use", that happens within a few seconds.
            // Delay backend billing/stream-connected until the connection is stable.
            if (Date.now() - nativeStreamConnectedSinceMs >= 10000)
                markCloudPlayNativeConnected()
        } else {
            nativeStreamConnectedSinceMs = 0
        }
    }

    function markCloudPlayNativeConnected() {
        if (activeSessionId.length === 0)
            return
        nativeStreamStarting = false
        streamActive = true
        launchProgress = 1.0
        launchStatusText = consolePane.trText("Игра подключена")
        if (Chiaki.cloudPlayEnvFlag("CLOUDPLAY_AUTOTEST") && !cloudPlayAutotestStopTimer.running)
            cloudPlayAutotestStopTimer.start()
        notifyCloudPlayStreamConnected()
    }

    function handleCloudPlayNativeSessionEnded(reason) {
        if (streamActive) {
            nativeStreamStarting = false
            streamActive = false
            cloudPlayStreamMonitorTimer.stop()
            cloudPlayHeartbeatTimer.stop()
            if (activeSessionId.length > 0 && !cloudPlayStopInFlight)
                stopCloudPlaySession(reason || "user_stop")
            return
        }
        handleCloudPlayNativeSessionFailed(reason || "connect_failed")
    }

    function handleCloudPlayNativeSessionFailed(reason) {
        nativeStreamStarting = false
        nativeStreamConnectedSinceMs = 0
        streamActive = false
        cloudPlayStreamMonitorTimer.stop()
        cloudPlayHeartbeatTimer.stop()
        if (activeSessionId.length === 0 || cloudPlayStopInFlight)
            return
        var shouldRetry = (reason !== "user_stop" && reason !== "app_close" && reason !== "manual_stop" && reason !== "autotest_complete") && cloudPlayLaunchRetryCount < 4
        var failedSlotId = String(activeSlotId || "")
        if (failedSlotId.length > 0 && cloudPlayFailedSlotIds.indexOf(failedSlotId) < 0)
            cloudPlayFailedSlotIds = cloudPlayFailedSlotIds.concat([failedSlotId])
        cloudPlayLaunchRetryCount += 1
        var statusText = shouldRetry ? consolePane.trText("PS5 не ответила · пробуем другую…") : consolePane.trText("PS5 не ответила")
        apiStatusText = statusText
        launchStatusText = statusText
        stopCloudPlaySession(reason || "connect_failed", function() {
            if (shouldRetry) {
                streamStartTimer.stop()
                launchProgress = 0.24
                apiStatusText = consolePane.trText("Готовим другую PS5…")
                launchStatusText = apiStatusText
                // A native Remote Play failure means the reserved PS5 did not accept
                // the Chiaki session. The UI already promises "пробуем другую", so
                // ask the backend for an alternate slot instead of re-reserving the
                // same sticky/preferred console and hitting "already in use" again.
                Qt.callLater(function() { consolePane.startCloudPlaySession("play_other") })
            } else {
                resetLaunchUi(statusText)
            }
        })
    }

    function queuePayloadFrom(payload) {
        if (!payload)
            return ({})
        return payload.queue || payload.queue_payload || payload.queuePayload || payload.ticket || payload
    }

    function sessionFromPayload(payload) {
        if (!payload)
            return null
        var q = payload.queue || payload.queue_payload || payload.queuePayload || null
        return payload.session || payload.launch_session || payload.launchSession || payload.ready_session || payload.readySession || (q ? (q.session || q.launch_session || q.launchSession || q.ready_session || q.readySession) : null) || null
    }

    function firstQueueString(obj, keys) {
        if (!obj)
            return ""
        for (var i = 0; i < keys.length; ++i) {
            var v = obj[keys[i]]
            if (v !== undefined && v !== null && String(v).length > 0)
                return String(v)
        }
        return ""
    }

    function queueNotifyEnabled(q) {
        if (!q)
            return false
        return q.notify_telegram === true || q.notifyTelegram === true || q.telegram_notified === true || q.telegramNotified === true
    }

    function applyQueuePayload(payload) {
        var q = queuePayloadFrom(payload)
        var pos = Number(q.position || q.queue_position || q.queuePosition || payload.position || payload.queue_position || payload.queuePosition || 0)
        queuePosition = pos > 0 ? pos : 0
        queueTicketId = firstQueueString(q, ["ticket_id", "ticketId", "id", "queue_ticket_id", "queueTicketId"])
        queueReady = q.ready === true || payload.ready === true || String(payload.status || "").toLowerCase() === "ready"
        queueNotifyTelegram = queueNotifyEnabled(q) || queueNotifyEnabled(payload)
        queueTelegramNotified = q.telegram_notified === true || q.telegramNotified === true || payload.telegram_notified === true || payload.telegramNotified === true
        var eta = firstQueueString(q, ["eta_text", "etaText", "estimated_wait", "estimatedWait", "estimated_wait_text", "estimatedWaitText"])
        if (eta.length === 0) {
            var seconds = Number(q.estimated_wait_seconds || q.estimatedWaitSeconds || payload.estimated_wait_seconds || payload.estimatedWaitSeconds || 0)
            eta = seconds > 0 ? Math.ceil(seconds / 60) + consolePane.trText(" мин") : (queuePosition > 0 ? consolePane.trText("~10–15 минут") : consolePane.trText("без ожидания"))
        }
        queueEtaText = eta
        var msg = firstQueueString(q, ["message", "text", "status_text", "statusText"])
        if (msg.length === 0)
            msg = firstQueueString(payload, ["message", "text", "status_text", "statusText"])
        if (msg.length === 0) {
            if (queueReady)
                msg = consolePane.trText("Очередь подошла. PS5 готова к запуску.")
            else if (queueNotifyTelegram)
                msg = consolePane.trText("Ожидаем свободную PS5. Мы уведомим вас в Telegram, когда очередь подойдёт.")
            else
                msg = queuePosition > 0 ? (consolePane.trText("Позиция в очереди: #") + queuePosition) : consolePane.trText("Вы добавлены в очередь")
        }
        queueText = msg
        return msg
    }

    function clearQueueState() {
        queuePosition = 0
        queueTicketId = ""
        queueReady = false
        queueNotifyTelegram = false
        queueTelegramNotified = false
        queueEtaText = consolePane.trText("без ожидания")
        queueText = ""
    }

    function parsePreferredBusy(payload) {
        var preferred = payload.preferred_slot || payload.preferredSlot || {}
        var alternate = payload.alternate_slot || payload.alternateSlot || {}
        preferredBusyMessage = firstQueueString(payload, ["message", "detail", "status_text", "statusText"])
        if (preferredBusyMessage.length === 0)
            preferredBusyMessage = consolePane.trText("Ваш прошлый PS5 сейчас занят. На нём могут быть ваши сохранения.")
        preferredBusySlot = firstQueueString(preferred, ["slot_id", "slotId", "code", "name", "display_name", "displayName"])
        preferredBusyUser = firstQueueString(preferred, ["current_user_display", "currentUserDisplay", "user", "username", "current_user", "currentUser"])
        preferredBusyAlternate = firstQueueString(alternate, ["slot_id", "slotId", "code", "name", "display_name", "displayName"])
    }

    function prepareCloudPlaySessionLaunch(session, autoLaunch) {
        if (!session)
            return false
        clearQueueState()
        applySession(session)
        pendingStreamSession = session
        currentPage = "play"
        apiStatusText = autoLaunch ? consolePane.trText("PS5 подготовлена. Запускаем консоль…") : consolePane.trText("Очередь подошла. PS5 готова к запуску.")
        launchStatusText = apiStatusText
        launchProgress = Math.max(launchProgress, autoLaunch ? 0.42 : 0.18)
        if (!autoLaunch)
            return true
        if (activeSessionId.length > 0) {
            wakeCloudPlaySession(false, function(ok) {
                apiStatusText = ok ? consolePane.trText("Консоль готова · подключаем игру…") : consolePane.trText("Консоль запускается дольше обычного · пробуем подключиться…")
                launchProgress = Math.max(launchProgress, 0.72)
                launchStatusText = apiStatusText
                streamStartTimer.restart()
            })
        } else {
            streamStartTimer.restart()
        }
        return true
    }

    function startCloudPlaySession(allocationMode) {
        if (apiBusy)
            return
        if (!cloudPlayLoggedIn) {
            resetLaunchUi(consolePane.trText("Войдите через Telegram"))
            beginTelegramLogin()
            return
        }
        apiBusy = true
        apiStatusText = consolePane.trText("Готовим PS5…")
        var startBody = { platform: updatePlatformKey() }
        if (allocationMode && String(allocationMode).length > 0)
            startBody.allocation_mode = String(allocationMode)
        if (cloudPlayFailedSlotIds.length > 0)
            startBody.exclude_slot_ids = cloudPlayFailedSlotIds.slice(0)
        request("POST", "/sessions/start", startBody, true, function(ok, status, payload) {
            apiBusy = false
            if (!ok) {
                var err = payload.error || payload
                apiStatusText = consolePane.trText("Не удалось начать игру. Попробуйте ещё раз.")
                resetLaunchUi(apiStatusText)
                root.showInfoDialog(qsTr("CloudPlay"), apiStatusText)
                return
            }
            if (payload.status === "preferred_busy") {
                parsePreferredBusy(payload)
                apiStatusText = preferredBusyMessage
                launchStatusText = apiStatusText
                currentPage = "play"
                resetLaunchUi(apiStatusText)
                preferredBusyPopup.open()
                return
            }
            var launchSession = sessionFromPayload(payload)
            if (launchSession) {
                prepareCloudPlaySessionLaunch(launchSession, true)
                return
            }
            if (payload.status === "queued" || payload.queue || payload.queue_payload || payload.queuePayload) {
                var queuedText = applyQueuePayload(payload)
                apiStatusText = queuedText
                currentPage = queueReady ? "play" : "queue"
                resetLaunchUi(apiStatusText)
                if (queueReady)
                    loadQueueStatus(true)
                else
                    root.showInfoDialog(qsTr("CloudPlay"), apiStatusText)
                return
            }
            apiStatusText = consolePane.trText("Не удалось получить данные для запуска. Попробуйте ещё раз.")
            resetLaunchUi(apiStatusText)
        })
    }

    function startPendingCloudPlayStream() {
        if (!pendingStreamSession) {
            apiStatusText = streamActive ? consolePane.trText("Игра уже запущена") : consolePane.trText("Не удалось подготовить запуск. Попробуйте ещё раз.")
            launchStatusText = apiStatusText
            return
        }
        apiStatusText = consolePane.trText("Подключаем игру…")
        launchStatusText = apiStatusText
        var preflightHost = sessionHost(pendingStreamSession)
        var preflightPort = sessionControlPort(pendingStreamSession)
        var reachable = false
        for (var reachAttempt = 0; reachAttempt < 14; ++reachAttempt) {
            if (Chiaki.cloudPlayCanReach(preflightHost, preflightPort, 1000)) {
                reachable = true
                break
            }
        }
        if (!reachable) {
            apiStatusText = consolePane.trText("PS5 не ответила · пробуем другую…")
            launchStatusText = apiStatusText
            handleCloudPlayNativeSessionEnded("preflight_failed")
            pendingStreamSession = null
            return
        }
        // Smoke marker kept for legacy check only: "Starting Remote Play stream core". UI text stays product-facing.
        // Smoke marker: backend start/wake payload path is Chiaki.cloudPlayStartStream(payload.session); pendingStreamSession stores that session payload.
        var started = Chiaki.cloudPlayStartStream(pendingStreamSession)
        if (!started) {
            resetLaunchUi(consolePane.trText("Игра не запустилась"))
            root.showInfoDialog(qsTr("CloudPlay"), qsTr(consolePane.trText("Не удалось подключить игру.")))
        } else {
            nativeStreamStarting = true
            nativeStreamStartedAtMs = Date.now()
            nativeStreamSessionSeen = !!Chiaki.session
            console.log("CloudPlay start_flow native_start_returned session=" + activeSessionId + " hasNativeSession=" + nativeStreamSessionSeen + " host=" + preflightHost + " port=" + preflightPort)
            streamActive = false
            cloudPlayStreamConnectedNotified = false
            launchProgress = 0.86
            launchStatusText = consolePane.trText("Подключаемся к PS5…")
            apiStatusText = consolePane.trText("Подключаемся к PS5…")
            cloudPlayStreamMonitorTimer.restart()
        }
        pendingStreamSession = null
    }

    function wakeCloudPlaySession(showDialog, done) {
        if (activeSessionId.length === 0)
            return
        var sessionId = activeSessionId
        request("POST", "/sessions/" + sessionId + "/wake", {}, true, function(ok, status, payload) {
            if (ok)
                apiStatusText = consolePane.trText("Запускаем консоль…")
            else
                apiStatusText = consolePane.trText("Консоль запускается дольше обычного…")
            if (showDialog)
                root.showInfoDialog(qsTr("CloudPlay"), apiStatusText)
            if (done)
                done(ok, payload)
        })
    }

    function stopCloudPlaySession(reason, done) {
        if (activeSessionId.length === 0)
            return
        if (cloudPlayStopInFlight)
            return
        var sessionId = activeSessionId
        var stopReason = reason || "user_stop"
        pendingStreamSession = null
        streamStartTimer.stop()
        if (["connect_failed", "preflight_failed", "stream_quit"].indexOf(String(stopReason)) < 0)
            cloudPlayLaunchRetryCount = 0
        cloudPlayStopInFlight = true
        cloudPlayStreamMonitorTimer.stop()
        cloudPlayHeartbeatTimer.stop()
        apiBusy = true
        request("POST", "/sessions/" + sessionId + "/stop", { reason: stopReason, platform: updatePlatformKey() }, true, function(ok, status, payload) {
            apiBusy = false
            cloudPlayStopInFlight = false
            if (ok) {
                activeSessionId = ""
                activeSlotId = ""
                activeSessionStatus = ""
                streamActive = false
                nativeStreamStarting = false
                cloudPlayStreamConnectedNotified = false
                minutesBalance = Number(payload.remaining_minutes || minutesBalance)
                cloudStore.minutesBalance = minutesBalance
                apiStatusText = consolePane.trText("Игра завершена · осталось ") + minutesBalance + consolePane.trText(" мин")
                if (done)
                    done(true, payload)
                else
                    loadCloudPlayState()
            } else {
                apiStatusText = consolePane.trText("Не удалось завершить игру. Попробуйте ещё раз.")
                root.showInfoDialog(qsTr("CloudPlay"), apiStatusText)
                if (done)
                    done(false, payload)
            }
        })
    }


    function formatMoney(value) {
        var n = Number(value || 0)
        return n.toLocaleString(Qt.locale("ru_RU")) + " UZS"
    }

    function listFromPayload(payload, keys) {
        if (!payload)
            return []
        if (Array.isArray(payload))
            return payload
        for (var i = 0; i < keys.length; ++i) {
            var v = payload[keys[i]]
            if (Array.isArray(v))
                return v
            if (v && typeof v === "object") {
                var nested = listFromPayload(v, keys)
                if (nested.length > 0)
                    return nested
            }
        }
        if (payload.results && Array.isArray(payload.results))
            return payload.results
        if (payload.data && Array.isArray(payload.data))
            return payload.data
        return []
    }

    function firstValue(obj, keys) {
        if (!obj)
            return undefined
        for (var i = 0; i < keys.length; ++i) {
            var v = obj[keys[i]]
            if (v !== undefined && v !== null && String(v).length > 0)
                return v
        }
        return undefined
    }

    function numericMoney(value) {
        if (value === undefined || value === null || value === "")
            return 0
        if (typeof value === "number")
            return isNaN(value) ? 0 : value
        var cleaned = String(value).replace(/[^0-9.,-]/g, "").replace(/\s/g, "")
        if (cleaned.indexOf(",") >= 0 && cleaned.indexOf(".") < 0)
            cleaned = cleaned.replace(",", ".")
        var n = Number(cleaned)
        return isNaN(n) ? 0 : n
    }

    function normalizePackages(items) {
        var arr = listFromPayload(items, ["packages", "plans", "items", "results", "data"])
        if (!arr || arr.length === 0)
            return availablePackages
        var out = []
        for (var i = 0; i < arr.length && i < 6; ++i) {
            var pkg = arr[i] || {}
            var mins = Number(firstValue(pkg, ["minutes", "duration_minutes", "durationMinutes", "time_minutes", "timeMinutes", "play_minutes", "playMinutes", "minutes_count", "minutesCount"]) || 0)
            var hours = mins > 0 ? (mins % 60 === 0 ? (mins / 60 + consolePane.trText(" час") + (mins / 60 >= 5 ? consolePane.trText("ов") : mins / 60 > 1 ? consolePane.trText("а") : "")) : (mins + consolePane.trText(" мин"))) : (pkg.title || pkg.name || (consolePane.trText("Пакет ") + (i + 1)))
            var amount = numericMoney(firstValue(pkg, ["price_amount", "priceAmount", "amount_uzs", "amountUzs", "price_uzs", "priceUzs", "amount", "cost"]))
            if (amount <= 0)
                amount = numericMoney(pkg.price)
            var priceText = firstValue(pkg, ["price_label", "priceLabel", "priceText", "amount_label", "amountLabel", "price"])
            if (!priceText || numericMoney(priceText) === 0 && amount > 0)
                priceText = amount > 0 ? formatMoney(amount) : "—"
            out.push({
                id: String(pkg.id || pkg.package_id || pkg.packageId || pkg.code || ("pkg-" + i)),
                title: pkg.title || pkg.name || hours,
                minutes: mins,
                price: String(priceText),
                amount: amount,
                badge: pkg.badge || pkg.label || pkg.tag || (i === 1 ? consolePane.trText("Хит") : i === 2 ? consolePane.trText("Выгодно") : i === 3 ? consolePane.trText("Лучшая цена") : consolePane.trText("Старт")),
                rate: pkg.rate_label || pkg.rateLabel || pkg.rate || (mins > 0 && amount > 0 ? formatMoney(Math.round(amount / (mins / 60))) + consolePane.trText(" / час") : "CloudPlay")
            })
        }
        return out
    }

    function normalizeTransactions(payload) {
        var arr = listFromPayload(payload, ["transactions", "operations", "items", "results"])
        var out = []
        for (var i = 0; i < arr.length && i < 5; ++i) {
            var t = arr[i] || {}
            out.push({
                title: t.title || t.description || t.type || consolePane.trText("Операция"),
                amount: t.amount_label || (t.amount ? formatMoney(t.amount) : (t.minutes ? (t.minutes + consolePane.trText(" мин")) : "—")),
                status: t.status || "done",
                time: sessionTime(t)
            })
        }
        return out
    }

    function loadPackages() {
        if (!cloudPlayLoggedIn) {
            packagesLoading = false
            packagesLoadedFromApi = false
            packagesStatusText = consolePane.trText("Войдите через Telegram, чтобы купить время.")
            return
        }
        packagesLoading = true
        packagesStatusText = consolePane.trText("Обновляем пакеты…")
        request("GET", "/packages", null, true, function(ok, status, payload) {
            packagesLoading = false
            if (ok) {
                availablePackages = normalizePackages(payload)
                packagesLoadedFromApi = true
                packagesStatusText = consolePane.trText("Пакеты обновлены.")
            } else {
                packagesLoadedFromApi = false
                packagesStatusText = consolePane.trText("Не удалось обновить пакеты. Показываем последний доступный список.")
            }
        })
    }

    function loadGamesCatalog() {
        if (!cloudPlayLoggedIn)
            return
        request("GET", "/games", null, true, function(ok, status, payload) {
            if (ok) {
                var games = normalizeLibraryGames(listFromPayload(payload, ["games", "catalog", "library", "items", "results"]))
                libraryGames = games
                if (games.length > 0)
                    featuredGames = normalizeFeaturedGames(listFromPayload(payload, ["popularGames", "popular_games", "featuredGames", "featured_games", "games", "catalog", "library", "items", "results"]))
            }
        })
    }

    function loadQueueStatus(silent) {
        if (!cloudPlayLoggedIn)
            return
        request("GET", "/queue/status", null, true, function(ok, status, payload) {
            if (!ok || !payload)
                return
            var qText = applyQueuePayload(payload)
            queueCount = Number(payload.queue_count || payload.queueCount || payload.waiting || queueCount || 0)
            if (payload.available_slots !== undefined)
                availableSlots = Number(payload.available_slots)
            if (payload.availableSlots !== undefined)
                availableSlots = Number(payload.availableSlots)
            setNetworkPing(pingFromPayload(payload))
            var session = sessionFromPayload(payload)
            if (queueReady && session) {
                prepareCloudPlaySessionLaunch(session, false)
                if (!silent)
                    root.showInfoDialog(qsTr("CloudPlay"), consolePane.trText("Очередь подошла. PS5 готова к запуску."))
            } else if (queuePosition > 0 || queueTicketId.length > 0 || queueReady) {
                apiStatusText = qText
            } else if (availableSlots > 0) {
                clearQueueState()
            }
        })
    }

    function enableQueueTelegramNotify() {
        if (!cloudPlayLoggedIn) {
            beginTelegramLogin()
            return
        }
        request("POST", "/queue/notify-telegram", {}, true, function(ok, status, payload) {
            if (ok && payload) {
                applyQueuePayload(payload)
                queueNotifyTelegram = true
                apiStatusText = consolePane.trText("Telegram-уведомление включено. Мы сообщим, когда подойдёт ваша очередь.")
            } else {
                apiStatusText = consolePane.trText("Не удалось включить Telegram-уведомление. Попробуйте ещё раз.")
            }
            root.showInfoDialog(qsTr("CloudPlay"), apiStatusText)
        })
    }

    function cancelQueue() {
        if (!cloudPlayLoggedIn)
            return
        request("POST", "/queue/cancel", {}, true, function(ok, status, payload) {
            if (ok) {
                clearQueueState()
                apiStatusText = consolePane.trText("Очередь отменена")
            } else {
                apiStatusText = consolePane.trText("Не удалось отменить очередь. Попробуйте ещё раз.")
            }
            root.showInfoDialog(qsTr("CloudPlay"), apiStatusText)
        })
    }

    function loadWalletTransactions() {
        if (!cloudPlayLoggedIn)
            return
        request("GET", "/transactions", null, true, function(ok, status, payload) {
            if (ok)
                walletTransactions = normalizeTransactions(payload)
        })
    }

    function createClickPayment(amount, packageId, minutes) {
        if (!cloudPlayLoggedIn) {
            beginTelegramLogin()
            return
        }
        var paymentAmount = Math.round(Number(amount || 0))
        if (paymentAmount <= 0) {
            paymentStatusText = consolePane.trText("Введите сумму пополнения.")
            return
        }
        paymentStatusText = consolePane.trText("Готовим оплату…")
        apiBusy = true
        var body = { amount: paymentAmount, amount_uzs: paymentAmount, amountUzs: paymentAmount, package_id: packageId || "", packageId: packageId || "", minutes: Number(minutes || 0), platform: updatePlatformKey() }
        request("POST", "/payments/click/create", body, true, function(ok, status, payload) {
            apiBusy = false
            if (!ok) {
                paymentStatusText = consolePane.trText("Не удалось создать оплату. Попробуйте ещё раз.")
                root.showInfoDialog(qsTr("CloudPlay"), paymentStatusText)
                return
            }
            var url = payload.payment_url || payload.paymentUrl || payload.click_url || payload.pay_url || payload.url || ""
            paymentStatusText = ""
            if (url.length > 0)
                Qt.openUrlExternally(url)
            else
                root.showInfoDialog(qsTr("CloudPlay"), qsTr(consolePane.trText("Оплата создана, но ссылка не открылась. Попробуйте ещё раз.")))
        })
    }

    function buySelectedPackage() {
        createClickPayment(selectedPackageAmount, selectedPackageId, selectedPackageMinutes)
        buyTimePopup.close()
    }

    function openSupportTelegram() {
        if (supportTelegramUrl.length > 0)
            Qt.openUrlExternally(supportTelegramUrl)
    }

    function callSupport() {
        callCenterPopup.open()
    }

    function openPlayStart() {
        currentPage = "play"
        if (!cloudPlayLoggedIn) {
            beginTelegramLogin()
            return
        }
        beginGamePopup.open()
    }

    function runLaunchSequence(allocationMode) {
        currentPage = "play"
        streamActive = false
        nativeStreamStarting = false
        cloudPlayLaunchRetryCount = 0
        cloudPlayFailedSlotIds = []
        launchStep = 0
        launchProgress = 0.08
        launchStatusText = consolePane.trText("Подключаем…")
        launchUiTimer.restart()
        if ((!allocationMode || String(allocationMode).length === 0) && pendingStreamSession && activeSessionId.length > 0) {
            prepareCloudPlaySessionLaunch(pendingStreamSession, true)
            return
        }
        startCloudPlaySession(allocationMode || "")
    }

    function updateLaunchUi() {
        launchStep += 1
        if (launchStep === 1) {
            launchProgress = Math.max(launchProgress, 0.28)
            launchStatusText = apiBusy ? consolePane.trText("Готовим PS5…") : launchStatusText
        } else if (launchStep === 2) {
            launchProgress = Math.max(launchProgress, 0.46)
            if (pendingStreamSession)
                launchStatusText = consolePane.trText("Готовим подключение…")
        } else {
            launchProgress = Math.max(launchProgress, 0.72)
            if (!pendingStreamSession && !apiBusy)
                launchUiTimer.stop()
        }
    }

    StackView.onActivated: forceActiveFocus(Qt.TabFocusReason)

    Keys.onReturnPressed: startCloudPlaySession()
    Keys.onEscapePressed: root.showConfirmDialog(qsTr(consolePane.trText("Выход")), qsTr(consolePane.trText("Закрыть CloudPlay Console?")), () => Chiaki.window.close())


    Timer {
        id: launchUiTimer
        interval: 900
        repeat: true
        running: false
        onTriggered: consolePane.updateLaunchUi()
    }

    Rectangle {
        anchors.fill: parent
        color: "#04050a"

        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.0; color: "#071023" }
                GradientStop { position: 0.42; color: "#04050a" }
                GradientStop { position: 1.0; color: "#020308" }
            }
        }

        RowLayout {
            anchors.fill: parent
            spacing: 0

            Rectangle {
                Layout.preferredWidth: 238
                Layout.fillHeight: true
                color: "#070a13"
                border.width: 0

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 16

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 52
                        spacing: 12
                        Image { Layout.preferredWidth: 42; Layout.preferredHeight: 42; source: "qrc:/icons/cloudplay-console-logo.png"; fillMode: Image.PreserveAspectFit }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: -1
                            Label { text: "CloudPlay"; color: "#eaf0ff"; font.family: consolePane.fontDisplay; font.pixelSize: 16; font.weight: Font.DemiBold }
                            Label { text: "Console"; color: "#828ca6"; font.family: consolePane.fontUi; font.pixelSize: 12 }
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 5
                        Repeater {
                            model: [
                                { key: "home", label: consolePane.trText("Главная"), icon: "qrc:/icons/cp-home.svg" },
                                { key: "play", label: consolePane.trText("Играть"), icon: "qrc:/icons/cp-play.svg" },
                                { key: "library", label: consolePane.trText("Игры"), icon: "qrc:/icons/cp-library.svg" },
                                { key: "wallet", label: consolePane.trText("Баланс"), icon: "qrc:/icons/cp-wallet.svg" },
                                { key: "packages", label: consolePane.trText("Время"), icon: "qrc:/icons/cp-clock.svg" },
                                { key: "queue", label: consolePane.trText("Очередь"), icon: "qrc:/icons/cp-sessions.svg" },
                                { key: "profile", label: consolePane.trText("Профиль"), icon: "qrc:/icons/cp-user.svg" },
                                { key: "settings", label: consolePane.trText("Настройки"), icon: "qrc:/icons/cp-settings.svg" }
                            ]
                            delegate: Button {
                                id: navButton
                                Layout.fillWidth: true
                                Layout.preferredHeight: 42
                                flat: true
                                padding: 0
                                focusPolicy: Qt.NoFocus
                                highlighted: consolePane.currentPage === modelData.key
                                background: Rectangle {
                                    anchors.fill: parent
                                    radius: 12
                                    color: navButton.highlighted ? "#101624" : (navButton.hovered ? "#0d1320" : "transparent")
                                    border.width: 0
                                }
                                contentItem: Item {
                                    anchors.fill: parent
                                    Image {
                                        id: navIcon
                                        width: 18
                                        height: 18
                                        anchors.left: parent.left
                                        anchors.leftMargin: 14
                                        anchors.verticalCenter: parent.verticalCenter
                                        source: modelData.icon
                                        fillMode: Image.PreserveAspectFit
                                        opacity: 0.88
                                    }
                                    Text {
                                        anchors.left: navIcon.right
                                        anchors.leftMargin: 11
                                        anchors.right: parent.right
                                        anchors.rightMargin: 12
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: modelData.label
                                        color: navButton.highlighted ? "#eaf0ff" : "#828ca6"
                                        font.family: consolePane.fontUi
                                        font.pixelSize: 14
                                        font.weight: navButton.highlighted ? Font.DemiBold : Font.Medium
                                        horizontalAlignment: Text.AlignLeft
                                        verticalAlignment: Text.AlignVCenter
                                        elide: Text.ElideRight
                                    }
                                }
                                onClicked: consolePane.currentPage = modelData.key
                            }
                        }
                    }

                    Item { Layout.fillHeight: true }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 94
                        radius: 16
                        color: "#080c16"
                        border.width: 1
                        border.color: "#121b30"
                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 4
                            Button {
                                id: callCenterButton
                                Layout.fillWidth: true
                                Layout.preferredHeight: 38
                                flat: true
                                padding: 0
                                focusPolicy: Qt.NoFocus
                                background: Rectangle { anchors.fill: parent; radius: 11; color: callCenterButton.hovered ? "#101624" : "transparent"; border.width: 0 }
                                contentItem: Item {
                                    anchors.fill: parent
                                    Image { id: callIcon; width: 17; height: 17; anchors.left: parent.left; anchors.leftMargin: 10; anchors.verticalCenter: parent.verticalCenter; source: "qrc:/icons/cp-console.svg"; fillMode: Image.PreserveAspectFit; opacity: 0.86 }
                                    Text { anchors.left: callIcon.right; anchors.leftMargin: 10; anchors.right: parent.right; anchors.rightMargin: 10; anchors.verticalCenter: parent.verticalCenter; text: consolePane.trText("Позвонить"); color: "#dce6ff"; font.family: consolePane.fontUi; font.pixelSize: 13; font.weight: Font.DemiBold; elide: Text.ElideRight; verticalAlignment: Text.AlignVCenter }
                                }
                                onClicked: consolePane.callSupport()
                            }
                            Button {
                                id: telegramSupportButton
                                Layout.fillWidth: true
                                Layout.preferredHeight: 38
                                flat: true
                                padding: 0
                                focusPolicy: Qt.NoFocus
                                background: Rectangle { anchors.fill: parent; radius: 11; color: telegramSupportButton.hovered ? "#101624" : "transparent"; border.width: 0 }
                                contentItem: Item {
                                    anchors.fill: parent
                                    Image { id: supportIcon; width: 17; height: 17; anchors.left: parent.left; anchors.leftMargin: 10; anchors.verticalCenter: parent.verticalCenter; source: "qrc:/icons/cp-support.svg"; fillMode: Image.PreserveAspectFit; opacity: 0.9 }
                                    Text { anchors.left: supportIcon.right; anchors.leftMargin: 10; anchors.right: parent.right; anchors.rightMargin: 10; anchors.verticalCenter: parent.verticalCenter; text: consolePane.trText("Поддержка"); color: "#dce6ff"; font.family: consolePane.fontUi; font.pixelSize: 13; font.weight: Font.DemiBold; elide: Text.ElideRight; verticalAlignment: Text.AlignVCenter }
                                }
                                onClicked: consolePane.openSupportTelegram()
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 86
                        radius: 18
                        color: "#0b0f1b"
                        border.width: 1
                        border.color: "#1f2a46"
                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 14
                            spacing: 3
                            Label { Layout.fillWidth: true; text: consolePane.cloudPlayLoggedIn ? consolePane.cloudPlayUser : consolePane.trText("Вход через Telegram"); color: "#eaf0ff"; font.pixelSize: 13; font.weight: Font.DemiBold; elide: Text.ElideRight }
                            Label { text: consolePane.cloudPlayLoggedIn ? consolePane.trText("Вы вошли") : consolePane.trText("Войдите, чтобы играть"); color: consolePane.cloudPlayLoggedIn ? "#36e08a" : "#828ca6"; font.pixelSize: 12 }
                            Label { text: consolePane.formatMoney(consolePane.walletBalanceUzs); color: "#828ca6"; font.pixelSize: 11 }
                        }
                        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: consolePane.currentPage = "profile" }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "transparent"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 26
                    spacing: 18

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 58
                        radius: 20
                        color: "#990b0f1b"
                        border.color: "#1f2a46"
                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 20
                            anchors.rightMargin: 14
                            spacing: 12
                            Label { text: consolePane.currentPage === "home" ? consolePane.trText("Главная") : consolePane.currentPage === "play" ? consolePane.trText("Играть") : consolePane.currentPage === "library" ? consolePane.trText("Игры") : consolePane.currentPage === "wallet" ? consolePane.trText("Баланс") : consolePane.currentPage === "packages" ? consolePane.trText("Время") : consolePane.currentPage === "queue" ? consolePane.trText("Очередь") : consolePane.currentPage === "settings" ? consolePane.trText("Настройки") : consolePane.trText("Профиль"); color: "#eaf0ff"; font.family: consolePane.fontUi; font.pixelSize: 22; font.weight: Font.DemiBold }
                            Item { Layout.fillWidth: true }
                            Label { Layout.preferredWidth: 300; text: consolePane.apiStatusText; color: "#8c9ab8"; font.family: consolePane.fontUi; font.pixelSize: 12; elide: Text.ElideRight; horizontalAlignment: Text.AlignRight }
                            Label { text: consolePane.availableSlots > 0 ? (consolePane.availableSlots + consolePane.trText(" PS5 свободны")) : consolePane.trText("Все PS5 заняты"); color: consolePane.availableSlots > 0 ? "#36e08a" : "#828ca6"; font.pixelSize: 13 }
                            Button {
                                id: headerRefreshButton
                                Layout.preferredWidth: 46
                                Layout.preferredHeight: 38
                                text: ""
                                flat: true
                                focusPolicy: Qt.NoFocus
                                ToolTip.visible: hovered
                                ToolTip.text: consolePane.trText("Обновить")
                                background: Rectangle {
                                    radius: 14
                                    color: headerRefreshButton.down ? "#20304f" : (headerRefreshButton.hovered ? "#182238" : "#101827")
                                    border.color: headerRefreshButton.hovered ? "#3a527e" : "#1f2a46"
                                }
                                contentItem: Item {
                                    implicitWidth: 24
                                    implicitHeight: 24
                                    Image {
                                        id: headerRefreshIcon
                                        anchors.centerIn: parent
                                        width: headerRefreshButton.hovered ? 25 : 23
                                        height: width
                                        source: "qrc:/icons/cp-refresh.svg"
                                        fillMode: Image.PreserveAspectFit
                                        smooth: true
                                        transformOrigin: Item.Center
                                        opacity: headerRefreshButton.enabled ? 1.0 : 0.45
                                        Behavior on width { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
                                        NumberAnimation {
                                            id: headerRefreshSpin
                                            target: headerRefreshIcon
                                            property: "rotation"
                                            from: 0
                                            to: 360
                                            duration: 520
                                            easing.type: Easing.OutCubic
                                        }
                                    }
                                }
                                onClicked: {
                                    headerRefreshSpin.restart()
                                    if (consolePane.cloudPlayLoggedIn)
                                        consolePane.loadCloudPlayState()
                                    else
                                        consolePane.beginTelegramLogin()
                                }
                            }
                        }
                    }

                    Loader {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        sourceComponent: consolePane.currentPage === "play" ? playPage : consolePane.currentPage === "library" ? libraryPage : consolePane.currentPage === "wallet" ? walletPage : consolePane.currentPage === "packages" ? packagesPage : consolePane.currentPage === "queue" ? queuePage : consolePane.currentPage === "profile" ? profilePage : consolePane.currentPage === "settings" ? settingsPage : homePage
                    }
                }
            }
        }
    }

    Component {
        id: homePage
        Item {
            Flickable {
                id: homeScroll
                anchors.fill: parent
                clip: true
                contentWidth: width
                contentHeight: homeContent.implicitHeight + 8
                boundsBehavior: Flickable.StopAtBounds
                flickableDirection: Flickable.VerticalFlick
                ScrollBar.vertical: ScrollBar { policy: homeScroll.contentHeight > homeScroll.height ? ScrollBar.AlwaysOn : ScrollBar.AsNeeded }

                ColumnLayout {
                    id: homeContent
                    width: homeScroll.width - (homeScroll.contentHeight > homeScroll.height ? 14 : 0)
                    spacing: 14

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 248
                    radius: 24
                    color: "#0b0f1b"
                    border.color: consolePane.cardBorder
                    clip: true
                    Image { anchors.fill: parent; source: "qrc:/icons/cloudplay-console-main-bg.png"; fillMode: Image.PreserveAspectCrop; opacity: 0.78 }
                    Rectangle { anchors.fill: parent; gradient: Gradient { orientation: Gradient.Horizontal; GradientStop { position: 0; color: "#f004050a" } GradientStop { position: 0.54; color: "#aa04050a" } GradientStop { position: 1; color: "#5504050a" } } }
                    Rectangle { anchors.right: parent.right; anchors.rightMargin: 28; anchors.verticalCenter: parent.verticalCenter; width: 280; height: 168; radius: 22; color: "#bb080d18"; border.color: consolePane.cardBorder
                        ColumnLayout { anchors.fill: parent; anchors.margins: 18; spacing: 8
                            Label { text: consolePane.trText("Статус"); color: "#8c9ab8"; font.family: consolePane.fontUi; font.pixelSize: 12 }
                            Label { Layout.fillWidth: true; text: consolePane.availableSlots > 0 ? consolePane.trText("PS5 свободна") : consolePane.trText("Есть очередь"); color: consolePane.availableSlots > 0 ? "#36e08a" : "#ffb86b"; font.family: consolePane.fontUi; font.pixelSize: 20; font.weight: Font.DemiBold; elide: Text.ElideRight }
                            Label { Layout.fillWidth: true; text: consolePane.minutesBalance + consolePane.trText(" мин · ") + consolePane.formatMoney(consolePane.walletBalanceUzs); color: "#dce6ff"; font.family: consolePane.fontUi; font.pixelSize: 13; font.weight: Font.DemiBold; elide: Text.ElideRight }
                            Item { Layout.fillHeight: true }
                            Label { Layout.fillWidth: true; text: consolePane.trText("Время начнёт списываться после подключения к игре."); color: "#96a4c0"; font.family: consolePane.fontUi; font.pixelSize: 12; wrapMode: Text.WordWrap }
                        }
                    }
                    ColumnLayout {
                        anchors.left: parent.left
                        anchors.leftMargin: 28
                        anchors.verticalCenter: parent.verticalCenter
                        width: Math.min(520, parent.width - 360)
                        spacing: 12
                        Label { text: "CLOUDPLAY CONSOLE"; color: consolePane.neonCyan; font.family: consolePane.fontUi; font.pixelSize: 12; font.weight: Font.DemiBold; font.letterSpacing: 1.2 }
                        Label { Layout.fillWidth: true; text: consolePane.trText("Играй на PS5 в облаке"); color: "#f4f7ff"; font.family: consolePane.fontUi; font.pixelSize: 38; font.weight: Font.Bold; font.letterSpacing: -0.4; wrapMode: Text.WordWrap }
                        Label { Layout.fillWidth: true; text: consolePane.trText("Запускайте игры, следите за временем и пополняйте баланс в одном приложении."); color: "#b7c2dc"; font.family: consolePane.fontUi; font.pixelSize: 16; wrapMode: Text.WordWrap }
                        RowLayout { spacing: 10
                            NeonButton { text: consolePane.trText("Играть"); onClicked: consolePane.openPlayStart() }
                            SoftButton { text: consolePane.trText("Пополнить"); onClicked: topupPopup.open() }
                            SoftButton { text: consolePane.trText("Игры"); onClicked: consolePane.currentPage = "library" }
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 92
                    Layout.maximumHeight: 92
                    spacing: 14
                    StatCard { title: consolePane.trText("Баланс"); value: consolePane.formatMoney(consolePane.walletBalanceUzs); note: consolePane.trText("Для игр и пополнений"); valueColor: consolePane.neonCyan }
                    StatCard { title: consolePane.trText("Игровое время"); value: consolePane.minutesBalance + consolePane.trText(" мин"); note: consolePane.trText("Доступно сейчас"); valueColor: consolePane.neonPink }
                    StatCard { title: "PS5"; value: consolePane.availableSlots > 0 ? consolePane.trText("Свободна") : consolePane.trText("Очередь"); note: consolePane.queueCount > 0 ? (consolePane.trText("В очереди: ") + consolePane.queueCount) : consolePane.trText("Без ожидания"); valueColor: consolePane.availableSlots > 0 ? consolePane.neonCyan : "#ffb86b" }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 128
                    Layout.minimumHeight: 128
                    radius: 20
                    color: "#0b0f1b"
                    border.color: consolePane.cardBorder
                    ColumnLayout { anchors.fill: parent; anchors.margins: 16; spacing: 10
                        Label { text: consolePane.trText("Быстрые действия"); color: "#eaf0ff"; font.family: consolePane.fontUi; font.pixelSize: 17; font.weight: Font.DemiBold }
                        RowLayout { Layout.fillWidth: true; Layout.preferredHeight: 60; Layout.minimumHeight: 60; Layout.maximumHeight: 60; spacing: 12
                            QuickActionCard { title: consolePane.trText("Пополнить"); subtitle: consolePane.trText("Баланс"); accent: consolePane.neonCyan; onClicked: topupPopup.open() }
                            QuickActionCard { title: consolePane.trText("Купить игровое время"); subtitle: consolePane.trText("Игровое время"); accent: consolePane.neonPink; onClicked: consolePane.currentPage = "packages" }
                            QuickActionCard { title: consolePane.trText("Очередь"); subtitle: consolePane.queueCount > 0 ? (consolePane.queueCount + consolePane.trText(" в очереди")) : consolePane.trText("Свободно"); accent: "#8a5cff"; onClicked: consolePane.currentPage = "queue" }
                            QuickActionCard { title: consolePane.trText("Профиль"); subtitle: consolePane.cloudPlayLoggedIn ? consolePane.trText("Аккаунт") : consolePane.trText("Войти"); accent: "#2e7bff"; onClicked: consolePane.currentPage = "profile" }
                        }
                    }
                }

                Rectangle {
                    id: popularSection
                    Layout.fillWidth: true
                    property int gameCount: Math.min(12, consolePane.featuredGames.length)
                    property int adaptiveColumns: width >= 2100 ? 10 : (width >= 1760 ? 9 : (width >= 1500 ? 8 : (width >= 1220 ? 7 : (width >= 980 ? 6 : (width >= 760 ? 5 : 4)))))
                    property int cardWidth: Math.max(124, Math.min(178, Math.floor((width - 14 * (adaptiveColumns - 1) - 8) / adaptiveColumns)))
                    property int cardHeight: Math.max(176, Math.floor(cardWidth * 1.42))
                    property int rowCount: gameCount <= 0 ? 1 : Math.ceil(gameCount / adaptiveColumns)
                    Layout.preferredHeight: 34 + 18 + (rowCount * cardHeight) + Math.max(0, rowCount - 1) * 14 + 18
                    Layout.minimumHeight: Layout.preferredHeight
                    radius: 0
                    color: "transparent"
                    border.width: 0
                    clip: false
                    ColumnLayout { anchors.fill: parent; anchors.margins: 0; spacing: 10
                        RowLayout { Layout.fillWidth: true; Layout.leftMargin: 2; Layout.rightMargin: 2; Layout.preferredHeight: 34
                            Label { text: consolePane.trText("Популярное"); color: "#f4f7ff"; font.family: consolePane.fontUi; font.pixelSize: 18; font.weight: Font.DemiBold }
                            Item { Layout.fillWidth: true }
                            Label { text: popularSection.gameCount + consolePane.trText(" игр"); color: "#7d8aa8"; font.family: consolePane.fontUi; font.pixelSize: 12; font.weight: Font.Medium }
                        }

                        GridLayout {
                            id: popularGrid
                            Layout.fillWidth: true
                            Layout.preferredHeight: popularSection.rowCount * popularSection.cardHeight + Math.max(0, popularSection.rowCount - 1) * rowSpacing + 8
                            Layout.topMargin: 8
                            columns: popularSection.adaptiveColumns
                            rowSpacing: 14
                            columnSpacing: 14
                            clip: false

                            Repeater {
                                model: consolePane.featuredGames.slice(0, 12)
                                delegate: GameCard {
                                    Layout.preferredWidth: popularSection.cardWidth
                                    Layout.minimumWidth: popularSection.cardWidth
                                    Layout.maximumWidth: popularSection.cardWidth
                                    Layout.preferredHeight: popularSection.cardHeight
                                    Layout.minimumHeight: popularSection.cardHeight
                                    Layout.maximumHeight: popularSection.cardHeight
                                    title: modelData.title
                                    subtitle: modelData.genre
                                    image: modelData.image
                                }
                            }
                        }
                    }
                }
            }
            }
            }
            }

            Component {
                id: playPage
                Item {
                    Flickable {
                        id: playScroll
                        anchors.fill: parent
                        clip: true
                        contentWidth: width
                        contentHeight: playContent.implicitHeight + 8
                        boundsBehavior: Flickable.StopAtBounds
                        flickableDirection: Flickable.VerticalFlick
                        ScrollBar.vertical: ScrollBar { policy: playScroll.contentHeight > playScroll.height ? ScrollBar.AlwaysOn : ScrollBar.AsNeeded }

                        ColumnLayout {
                            id: playContent
                            width: playScroll.width - (playScroll.contentHeight > playScroll.height ? 14 : 0)
                            spacing: 14

                            RowLayout {
                                Layout.fillWidth: true
                                Layout.minimumHeight: 500
                                Layout.preferredHeight: Math.max(500, Math.min(540, playScroll.height - 48))
                                spacing: 14

                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    Layout.minimumWidth: 560
                                    radius: 28
                                    color: "#070b14"
                                    border.color: consolePane.cardBorder
                                    clip: true

                                    Rectangle {
                                        anchors.fill: parent
                                        gradient: Gradient {
                                            orientation: Gradient.Horizontal
                                            GradientStop { position: 0.0; color: "#141f37" }
                                            GradientStop { position: 0.48; color: "#09101d" }
                                            GradientStop { position: 1.0; color: "#05070d" }
                                        }
                                    }
                                    Rectangle { anchors.right: parent.right; anchors.top: parent.top; width: 300; height: 300; radius: 150; anchors.rightMargin: -94; anchors.topMargin: -118; color: "#2219e9ff"; opacity: 0.42 }
                                    Rectangle { anchors.left: parent.left; anchors.bottom: parent.bottom; width: 260; height: 260; radius: 130; anchors.leftMargin: -92; anchors.bottomMargin: -130; color: "#332e7bff"; opacity: 0.30 }

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 24
                                        spacing: 22

                                        ColumnLayout {
                                            Layout.fillWidth: true
                                            Layout.fillHeight: true
                                            spacing: 16

                                            RowLayout {
                                                Layout.fillWidth: true
                                                spacing: 10
                                                Rectangle {
                                                    Layout.preferredWidth: 44
                                                    Layout.preferredHeight: 44
                                                    radius: 15
                                                    color: "#13223b"
                                                    border.color: "#31476d"
                                                    Image { anchors.centerIn: parent; width: 24; height: 24; source: "qrc:/icons/cp-play.svg"; fillMode: Image.PreserveAspectFit; opacity: 0.95 }
                                                }
                                                ColumnLayout {
                                                    Layout.fillWidth: true
                                                    spacing: 1
                                                    Label { Layout.fillWidth: true; text: streamActive ? consolePane.trText("Игра уже запущена") : (nativeStreamStarting ? consolePane.trText("Подключаем PS5") : consolePane.trText("Готово к запуску")); color: "#f4f7ff"; font.family: consolePane.fontDisplay; font.pixelSize: 31; font.weight: Font.DemiBold; elide: Text.ElideRight }
                                                    Label { Layout.fillWidth: true; text: consolePane.cloudPlayLoggedIn ? consolePane.trText("Запустите PS5, проверьте пинг и баланс в одном месте.") : consolePane.trText("Войдите через Telegram, чтобы запустить игру."); color: "#9aa7c2"; font.family: consolePane.fontUi; font.pixelSize: 13; elide: Text.ElideRight }
                                                }
                                                Rectangle {
                                                    Layout.preferredWidth: 124
                                                    Layout.preferredHeight: 34
                                                    radius: 17
                                                    color: streamActive ? "#183020" : (nativeStreamStarting ? "#302614" : "#101827")
                                                    border.color: streamActive ? "#3355f0a5" : (nativeStreamStarting ? "#44ffb86b" : consolePane.cardBorder)
                                                    Label { anchors.centerIn: parent; text: streamActive ? consolePane.trText("В игре") : (nativeStreamStarting ? consolePane.trText("Запуск") : consolePane.trText("Ожидание")); color: streamActive ? "#55f0a5" : (nativeStreamStarting ? "#ffb86b" : "#9aa7c2"); font.family: consolePane.fontUi; font.pixelSize: 12; font.weight: Font.DemiBold }
                                                }
                                            }

                                            Item { Layout.fillHeight: true }

                                            ColumnLayout {
                                                Layout.fillWidth: true
                                                spacing: 9
                                                Label { Layout.fillWidth: true; text: launchStatusText; color: "#dce6ff"; font.family: consolePane.fontUi; font.pixelSize: 17; font.weight: Font.DemiBold; wrapMode: Text.WordWrap }
                                                Rectangle {
                                                    Layout.fillWidth: true
                                                    Layout.preferredHeight: 12
                                                    radius: 6
                                                    color: "#121827"
                                                    border.color: "#22304d"
                                                    Rectangle {
                                                        height: parent.height
                                                        radius: 6
                                                        width: Math.max(8, parent.width * consolePane.launchProgress)
                                                        visible: consolePane.launchProgress > 0 || nativeStreamStarting || streamActive
                                                        gradient: Gradient { orientation: Gradient.Horizontal; GradientStop { position: 0; color: "#19e9ff" } GradientStop { position: 1; color: "#8a5cff" } }
                                                        Behavior on width { NumberAnimation { duration: 420; easing.type: Easing.OutCubic } }
                                                    }
                                                }
                                            }

                                            RowLayout {
                                                Layout.fillWidth: true
                                                Layout.preferredHeight: 76
                                                spacing: 12
                                                LaunchStepCard { title: consolePane.trText("Аккаунт"); value: consolePane.cloudPlayLoggedIn ? consolePane.trText("Готов") : consolePane.trText("Нужен вход"); active: consolePane.launchProgress >= 0.08 || consolePane.cloudPlayLoggedIn; done: consolePane.cloudPlayLoggedIn }
                                                LaunchStepCard { title: "PS5"; value: consolePane.availableSlots > 0 ? consolePane.trText("Свободна") : consolePane.trText("Очередь"); active: consolePane.launchProgress >= 0.28 || consolePane.availableSlots > 0; done: consolePane.launchProgress >= 0.42 || streamActive }
                                                LaunchStepCard { title: consolePane.trText("Игра"); value: streamActive ? consolePane.trText("Подключено") : (nativeStreamStarting ? consolePane.trText("Подключаем") : consolePane.trText("Готово")); active: consolePane.launchProgress >= 0.72 || nativeStreamStarting || streamActive; done: streamActive }
                                            }

                                            RowLayout {
                                                Layout.fillWidth: true
                                                spacing: 12
                                                NeonButton {
                                                    Layout.preferredWidth: 190
                                                    text: streamActive ? consolePane.trText("Вернуться к игре") : (consolePane.cloudPlayLoggedIn ? consolePane.trText("Начать игру") : consolePane.trText("Войти и играть"))
                                                    onClicked: streamActive ? consolePane.startPendingCloudPlayStream() : beginGamePopup.open()
                                                }
                                                SoftButton { Layout.preferredWidth: 150; text: streamActive ? consolePane.trText("Завершить") : consolePane.trText("Очередь"); onClicked: streamActive ? consolePane.stopCloudPlaySession("user_stop") : consolePane.currentPage = "queue" }
                                                SoftButton { Layout.preferredWidth: 150; text: consolePane.trText("Купить время"); onClicked: consolePane.currentPage = "packages" }
                                                Item { Layout.fillWidth: true }
                                            }

                                            Rectangle {
                                                Layout.fillWidth: true
                                                Layout.preferredHeight: 44
                                                radius: 15
                                                color: "#121827"
                                                border.color: "#22304d"
                                                RowLayout {
                                                    anchors.fill: parent
                                                    anchors.leftMargin: 14
                                                    anchors.rightMargin: 14
                                                    spacing: 10
                                                    Rectangle { Layout.preferredWidth: 8; Layout.preferredHeight: 8; radius: 4; color: "#55f0a5" }
                                                    Label { Layout.fillWidth: true; text: consolePane.trText("Время списывается только после успешного подключения к игре."); color: "#aeb9d2"; font.family: consolePane.fontUi; font.pixelSize: 12; elide: Text.ElideRight }
                                                    Label { text: consolePane.cloudPlayLoggedIn ? (consolePane.trText("баланс: ") + consolePane.minutesBalance + consolePane.trText(" мин")) : consolePane.trText("нужен вход"); color: consolePane.cloudPlayLoggedIn ? "#eaf0ff" : "#8c9ab8"; font.family: consolePane.fontUi; font.pixelSize: 12; font.weight: Font.DemiBold }
                                                }
                                            }
                                        }

                                    }
                                }

                                ColumnLayout {
                                    Layout.preferredWidth: 310
                                    Layout.fillHeight: true
                                    spacing: 14

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        radius: 24
                                        color: "#0b0f1b"
                                        border.color: consolePane.cardBorder
                                        ColumnLayout {
                                            anchors.fill: parent
                                            anchors.margins: 18
                                            spacing: 12
                                            RowLayout { Layout.fillWidth: true; spacing: 10
                                                Image { Layout.preferredWidth: 24; Layout.preferredHeight: 24; source: "qrc:/icons/cp-console.svg"; fillMode: Image.PreserveAspectFit; opacity: 0.95 }
                                                ColumnLayout { Layout.fillWidth: true; spacing: 1
                                                    Label { Layout.fillWidth: true; text: consolePane.trText("Состояние"); color: "#eaf0ff"; font.family: consolePane.fontUi; font.pixelSize: 18; font.weight: Font.DemiBold; elide: Text.ElideRight }
                                                    Label { Layout.fillWidth: true; text: consolePane.trText("обновляется автоматически"); color: "#7f8ba6"; font.family: consolePane.fontUi; font.pixelSize: 11; elide: Text.ElideRight }
                                                }
                                            }
                                            StatCard { title: "PS5"; value: consolePane.availableSlots > 0 ? consolePane.trText("Свободно") : consolePane.trText("Занято"); note: consolePane.queueCount > 0 ? (consolePane.queueCount + consolePane.trText(" в очереди")) : consolePane.trText("без очереди"); valueColor: consolePane.availableSlots > 0 ? "#36e08a" : "#ffb86b" }
                                            StatCard { title: consolePane.trText("Пинг"); value: consolePane.pingValueText(); note: consolePane.pingStatusText(); valueColor: consolePane.pingColor() }
                                            StatCard { title: consolePane.trText("Время"); value: consolePane.minutesBalance + consolePane.trText(" мин"); note: consolePane.trText("списывается после подключения"); valueColor: consolePane.neonPink }
                                            QuickActionCard { title: consolePane.trText("Настроить экран"); subtitle: consolePane.trText("FPS · качество · HDR"); accent: "#7cc7ff"; onClicked: consolePane.currentPage = "settings" }
                                            QuickActionCard { title: consolePane.trText("Поддержка"); subtitle: consolePane.supportCallDisplay.length > 0 ? consolePane.supportCallDisplay : consolePane.trText("колл центр"); accent: "#55f0a5"; onClicked: callCenterPopup.open() }
                                        }
                                    }
                                }
                            }

                        }
                    }
                }
            }

    Component { id: libraryPage; Item { ColumnLayout { anchors.fill: parent; spacing: 14
        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 132; radius: 22; color: "#0b0f1b"; border.color: consolePane.cardBorder
            ColumnLayout { anchors.fill: parent; anchors.margins: 18; spacing: 12
                RowLayout { Layout.fillWidth: true; spacing: 14
                    ColumnLayout { Layout.fillWidth: true; spacing: 3
                        Label { text: consolePane.trText("Игры"); color: "#eaf0ff"; font.family: consolePane.fontDisplay; font.pixelSize: 24; font.weight: Font.DemiBold }
                        Label { text: consolePane.cloudPlayLoggedIn ? (consolePane.filteredLibraryGames().length + consolePane.trText(" из ") + consolePane.libraryGames.length + consolePane.trText(" игр")) : consolePane.trText("Войдите, чтобы открыть каталог игр"); color: "#8c9ab8"; font.family: consolePane.fontUi; font.pixelSize: 13; elide: Text.ElideRight }
                    }
                    SoftButton { text: consolePane.trText("Обновить"); onClicked: consolePane.cloudPlayLoggedIn ? consolePane.loadGamesCatalog() : consolePane.beginTelegramLogin() }
                    NeonButton { text: consolePane.trText("Играть"); onClicked: consolePane.openPlayStart() }
                }
                RowLayout { Layout.fillWidth: true; spacing: 10
                    TextField {
                        Layout.preferredWidth: 360
                        Layout.preferredHeight: 42
                        placeholderText: consolePane.trText("Найти игру")
                        text: consolePane.librarySearchQuery
                        color: "#eaf0ff"
                        placeholderTextColor: "#64708a"
                        font.family: consolePane.fontUi
                        font.pixelSize: 13
                        onTextChanged: consolePane.librarySearchQuery = text
                        background: Rectangle { radius: 14; color: "#101827"; border.color: consolePane.cardBorder }
                    }
                    FilterChip { text: consolePane.trText("Все"); active: consolePane.libraryFilter === "all"; onClicked: consolePane.libraryFilter = "all" }
                    FilterChip { text: consolePane.trText("Популярные"); active: consolePane.libraryFilter === "popular"; onClicked: consolePane.libraryFilter = "popular" }
                    FilterChip { text: consolePane.trText("Доступные"); active: consolePane.libraryFilter === "ready"; onClicked: consolePane.libraryFilter = "ready" }
                    Item { Layout.fillWidth: true }
                    Label { text: consolePane.availableSlots > 0 ? consolePane.trText("Можно играть сейчас") : consolePane.trText("Все PS5 заняты"); color: consolePane.availableSlots > 0 ? "#36e08a" : "#8c9ab8"; font.family: consolePane.fontUi; font.pixelSize: 12 }
                }
            }
        }
        ScrollView {
            id: libraryScroll
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            contentWidth: availableWidth
            ScrollBar.vertical.policy: ScrollBar.AlwaysOn
            ScrollBar.vertical.interactive: true

            GridLayout {
                id: libraryGrid
                width: libraryScroll.availableWidth
                property int adaptiveColumns: width >= 2100 ? 10 : (width >= 1800 ? 9 : (width >= 1500 ? 8 : (width >= 1220 ? 7 : (width >= 980 ? 6 : (width >= 760 ? 5 : (width >= 540 ? 4 : 3))))))
                property int cardWidth: Math.max(124, Math.min(190, Math.floor((width - columnSpacing * (adaptiveColumns - 1) - 22) / adaptiveColumns)))
                columns: adaptiveColumns
                rowSpacing: 14
                columnSpacing: 12

                Repeater {
                    model: consolePane.filteredLibraryGames()
                    delegate: LibraryGameCard {
                        Layout.preferredWidth: libraryGrid.cardWidth
                        Layout.preferredHeight: Math.max(214, Math.floor(libraryGrid.cardWidth * 1.42))
                        title: modelData.title
                        subtitle: modelData.genre
                        image: modelData.image
                        status: modelData.status
                        onClicked: consolePane.openGameDetails(modelData)
                    }
                }
            }
        }
    } } }

    Component {
        id: walletPage
        Item {
            Flickable {
                id: walletScroll
                anchors.fill: parent
                clip: true
                contentWidth: width
                contentHeight: walletContent.implicitHeight + 8
                boundsBehavior: Flickable.StopAtBounds
                flickableDirection: Flickable.VerticalFlick
                ScrollBar.vertical: ScrollBar { policy: walletScroll.contentHeight > walletScroll.height ? ScrollBar.AlwaysOn : ScrollBar.AsNeeded }

                ColumnLayout {
                    id: walletContent
                    width: walletScroll.width - (walletScroll.contentHeight > walletScroll.height ? 14 : 0)
                    spacing: 14

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 316
                        spacing: 14

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 26
                            color: "#0b0f1b"
                            border.color: "#243451"
                            clip: true

                            Rectangle {
                                anchors.fill: parent
                                radius: 26
                                gradient: Gradient {
                                    orientation: Gradient.Horizontal
                                    GradientStop { position: 0.0; color: "#151f36" }
                                    GradientStop { position: 0.56; color: "#0b0f1b" }
                                    GradientStop { position: 1.0; color: "#07111f" }
                                }
                                opacity: 0.86
                            }

                            Rectangle { anchors.right: parent.right; anchors.top: parent.top; width: 220; height: 220; radius: 110; color: "#2219e9ff"; opacity: 0.36; anchors.rightMargin: -78; anchors.topMargin: -92 }
                            Rectangle { anchors.right: parent.right; anchors.bottom: parent.bottom; width: 150; height: 150; radius: 75; color: "#332e7bff"; opacity: 0.26; anchors.rightMargin: 60; anchors.bottomMargin: -90 }

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 22
                                spacing: 12

                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 12
                                    Rectangle {
                                        Layout.preferredWidth: 48
                                        Layout.preferredHeight: 48
                                        radius: 16
                                        color: "#11263f"
                                        border.color: "#33466f"
                                        Image { anchors.centerIn: parent; width: 25; height: 25; source: "qrc:/icons/cp-wallet.svg"; fillMode: Image.PreserveAspectFit; opacity: 0.94 }
                                    }
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 1
                                        Label { Layout.fillWidth: true; text: consolePane.trText("Баланс CloudPlay"); color: "#f4f7ff"; font.family: consolePane.fontDisplay; font.pixelSize: 24; font.weight: Font.DemiBold; elide: Text.ElideRight }
                                        Label { Layout.fillWidth: true; text: consolePane.trText("Деньги для пополнений и игровое время для запуска PS5."); color: "#9aa7c2"; font.family: consolePane.fontUi; font.pixelSize: 13; elide: Text.ElideRight }
                                    }
                                    Rectangle { Layout.preferredWidth: 118; Layout.preferredHeight: 34; radius: 17; color: consolePane.cloudPlayLoggedIn ? "#183020" : "#302414"; border.color: consolePane.cloudPlayLoggedIn ? "#3355f0a5" : "#44ffb86b"; Label { anchors.centerIn: parent; text: consolePane.cloudPlayLoggedIn ? consolePane.trText("Активен") : consolePane.trText("Нужен вход"); color: consolePane.cloudPlayLoggedIn ? "#55f0a5" : "#ffb86b"; font.family: consolePane.fontUi; font.pixelSize: 12; font.weight: Font.DemiBold } }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    spacing: 14

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        Layout.minimumHeight: 190
                                        radius: 22
                                        color: "#99070c16"
                                        border.color: "#263653"
                                        ColumnLayout {
                                            anchors.fill: parent
                                            anchors.margins: 16
                                            spacing: 7
                                            Label { text: consolePane.trText("Денежный баланс"); color: "#8c9ab8"; font.family: consolePane.fontUi; font.pixelSize: 12; font.weight: Font.Medium }
                                            Label { Layout.fillWidth: true; text: consolePane.formatMoney(consolePane.walletBalanceUzs); color: consolePane.neonCyan; font.family: consolePane.fontDisplay; font.pixelSize: 30; font.weight: Font.DemiBold; elide: Text.ElideRight }
                                            Label { Layout.fillWidth: true; text: consolePane.trText("Пополняется через Click. Можно покупать пакеты времени."); color: "#7e8aa5"; font.family: consolePane.fontUi; font.pixelSize: 12; wrapMode: Text.WordWrap }
                                            Item { Layout.fillHeight: true }
                                            NeonButton { Layout.fillWidth: true; Layout.preferredHeight: 44; text: consolePane.trText("Пополнить баланс"); onClicked: topupPopup.open() }
                                        }
                                    }

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        Layout.minimumHeight: 190
                                        radius: 22
                                        color: "#99070c16"
                                        border.color: "#263653"
                                        ColumnLayout {
                                            anchors.fill: parent
                                            anchors.margins: 16
                                            spacing: 7
                                            Label { text: consolePane.trText("Игровое время"); color: "#8c9ab8"; font.family: consolePane.fontUi; font.pixelSize: 12; font.weight: Font.Medium }
                                            Label { Layout.fillWidth: true; text: consolePane.minutesBalance + consolePane.trText(" мин"); color: consolePane.neonPink; font.family: consolePane.fontDisplay; font.pixelSize: 30; font.weight: Font.DemiBold; elide: Text.ElideRight }
                                            Label { Layout.fillWidth: true; text: consolePane.trText("Списывается только после реального подключения к игре."); color: "#7e8aa5"; font.family: consolePane.fontUi; font.pixelSize: 12; wrapMode: Text.WordWrap }
                                            Item { Layout.fillHeight: true }
                                            SoftButton { Layout.fillWidth: true; Layout.preferredHeight: 44; text: consolePane.trText("Купить время"); onClicked: consolePane.currentPage = "packages" }
                                        }
                                    }
                                }
                            }
                        }

                        Rectangle {
                            Layout.preferredWidth: 292
                            Layout.fillHeight: true
                            radius: 24
                            color: "#0b0f1b"
                            border.color: consolePane.cardBorder
                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 20
                                spacing: 12
                                Label { Layout.fillWidth: true; text: consolePane.trText("Как это работает"); color: "#eaf0ff"; font.family: consolePane.fontDisplay; font.pixelSize: 18; font.weight: Font.DemiBold; elide: Text.ElideRight }
                                Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: "#182238" }
                                RowLayout { Layout.fillWidth: true; spacing: 10; Rectangle { Layout.preferredWidth: 28; Layout.preferredHeight: 28; radius: 14; color: "#14314d"; Label { anchors.centerIn: parent; text: "1"; color: consolePane.neonCyan; font.weight: Font.DemiBold } } Label { Layout.fillWidth: true; text: consolePane.trText("Пополняешь баланс через Click"); color: "#dce6ff"; font.family: consolePane.fontUi; font.pixelSize: 13; wrapMode: Text.WordWrap } }
                                RowLayout { Layout.fillWidth: true; spacing: 10; Rectangle { Layout.preferredWidth: 28; Layout.preferredHeight: 28; radius: 14; color: "#14314d"; Label { anchors.centerIn: parent; text: "2"; color: consolePane.neonCyan; font.weight: Font.DemiBold } } Label { Layout.fillWidth: true; text: consolePane.trText("Покупаешь пакет игрового времени"); color: "#dce6ff"; font.family: consolePane.fontUi; font.pixelSize: 13; wrapMode: Text.WordWrap } }
                                RowLayout { Layout.fillWidth: true; spacing: 10; Rectangle { Layout.preferredWidth: 28; Layout.preferredHeight: 28; radius: 14; color: "#14314d"; Label { anchors.centerIn: parent; text: "3"; color: consolePane.neonCyan; font.weight: Font.DemiBold } } Label { Layout.fillWidth: true; text: consolePane.trText("Минуты списываются после подключения"); color: "#dce6ff"; font.family: consolePane.fontUi; font.pixelSize: 13; wrapMode: Text.WordWrap } }
                                Item { Layout.fillHeight: true }
                                SoftButton { Layout.fillWidth: true; text: consolePane.trText("Обновить данные"); onClicked: consolePane.loadCloudPlayState() }
                            }
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 276
                        spacing: 14

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 22
                            color: "#0b0f1b"
                            border.color: consolePane.cardBorder
                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 18
                                spacing: 12
                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 12
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 2
                                        Label { Layout.fillWidth: true; text: consolePane.trText("Быстрая покупка времени"); color: "#eaf0ff"; font.family: consolePane.fontDisplay; font.pixelSize: 18; font.weight: Font.DemiBold; elide: Text.ElideRight }
                                        Label { Layout.fillWidth: true; text: consolePane.packagesStatusText; visible: consolePane.packagesLoading || !consolePane.cloudPlayLoggedIn; color: "#7e8aa5"; font.family: consolePane.fontUi; font.pixelSize: 12; elide: Text.ElideRight }
                                    }
                                    SoftButton { Layout.preferredHeight: 38; text: consolePane.packagesLoading ? consolePane.trText("Загрузка…") : consolePane.trText("Все пакеты"); onClicked: { if (consolePane.cloudPlayLoggedIn) consolePane.loadPackages(); consolePane.currentPage = "packages" } }
                                }
                                GridLayout {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 168
                                    Layout.maximumHeight: 168
                                    columns: 3
                                    columnSpacing: 10
                                    rowSpacing: 10
                                    Repeater {
                                        model: consolePane.availablePackages.length > 3 ? consolePane.availablePackages.slice(0, 3) : consolePane.availablePackages
                                        delegate: Rectangle {
                                            Layout.fillWidth: true
                                            Layout.preferredHeight: 156
                                            Layout.minimumHeight: 156
                                            Layout.maximumHeight: 156
                                            radius: 18
                                            color: packageMouse.containsMouse ? "#121a2c" : "#0f1524"
                                            border.color: "#1f2a46"
                                            clip: true
                                            ColumnLayout {
                                                anchors.fill: parent
                                                anchors.margins: 12
                                                spacing: 5
                                                RowLayout {
                                                    Layout.fillWidth: true
                                                    spacing: 8
                                                    Rectangle {
                                                        Layout.preferredWidth: 62
                                                        Layout.preferredHeight: 24
                                                        radius: 12
                                                        color: "#162b46"
                                                        border.color: "#294a70"
                                                        Label { anchors.centerIn: parent; text: modelData.badge; color: consolePane.neonCyan; font.family: consolePane.fontUi; font.pixelSize: 10; font.weight: Font.DemiBold; elide: Text.ElideRight; width: parent.width - 12; horizontalAlignment: Text.AlignHCenter }
                                                    }
                                                    Item { Layout.fillWidth: true }
                                                    Label { text: modelData.rate; color: "#828ca6"; font.family: consolePane.fontUi; font.pixelSize: 10; elide: Text.ElideRight }
                                                }
                                                Label { Layout.fillWidth: true; Layout.preferredHeight: 24; text: modelData.title; color: "#f4f7ff"; font.family: consolePane.fontUi; font.pixelSize: 19; font.weight: Font.DemiBold; elide: Text.ElideRight; verticalAlignment: Text.AlignVCenter }
                                                Label { Layout.fillWidth: true; Layout.preferredHeight: 18; text: modelData.price; color: "#dce6ff"; font.family: consolePane.fontMono; font.pixelSize: 13; font.weight: Font.DemiBold; elide: Text.ElideRight; verticalAlignment: Text.AlignVCenter }
                                                Item { Layout.fillHeight: true }
                                                Rectangle {
                                                    Layout.fillWidth: true
                                                    Layout.preferredHeight: 34
                                                    Layout.minimumHeight: 34
                                                    Layout.maximumHeight: 34
                                                    radius: 17
                                                    color: packageMouse.containsMouse ? "#223b5d" : "#172238"
                                                    border.color: "#2a3f61"
                                                    Label { anchors.centerIn: parent; text: consolePane.trText("Купить"); color: "#dce6ff"; font.family: consolePane.fontUi; font.pixelSize: 12; font.weight: Font.DemiBold }
                                                }
                                            }
                                            MouseArea { id: packageMouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: { consolePane.selectedPackageId = modelData.id; consolePane.selectedPackageMinutes = modelData.minutes; consolePane.selectedPackageAmount = modelData.amount; consolePane.selectedPackageTitle = modelData.title; consolePane.selectedPackagePrice = modelData.price; buyTimePopup.open() } }
                                        }
                                    }
                                }
                            }
                        }

                        Rectangle {
                            Layout.preferredWidth: 292
                            Layout.fillHeight: true
                            radius: 22
                            color: "#0b0f1b"
                            border.color: consolePane.cardBorder
                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 18
                                spacing: 8
                                Label { Layout.fillWidth: true; text: consolePane.trText("Оплата"); color: "#eaf0ff"; font.family: consolePane.fontDisplay; font.pixelSize: 18; font.weight: Font.DemiBold; elide: Text.ElideRight }
                                Label { Layout.fillWidth: true; text: consolePane.paymentStatusText.length > 0 ? consolePane.paymentStatusText : consolePane.trText("Click откроется в браузере. После оплаты данные можно обновить."); color: "#9aa7c2"; font.family: consolePane.fontUi; font.pixelSize: 13; wrapMode: Text.WordWrap }
                                Item { Layout.fillHeight: true }
                                NeonButton { Layout.fillWidth: true; text: consolePane.trText("Пополнить"); onClicked: topupPopup.open() }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Math.max(250, 88 + Math.max(1, consolePane.walletTransactions.length) * 66)
                        radius: 22
                        color: "#0b0f1b"
                        border.color: consolePane.cardBorder
                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 18
                            spacing: 10
                            RowLayout {
                                Layout.fillWidth: true
                                Label { Layout.fillWidth: true; text: consolePane.trText("История операций"); color: "#eaf0ff"; font.family: consolePane.fontDisplay; font.pixelSize: 18; font.weight: Font.DemiBold; elide: Text.ElideRight }
                                SoftButton { text: consolePane.trText("Обновить"); onClicked: consolePane.loadWalletTransactions() }
                            }
                            Rectangle {
                                visible: consolePane.walletTransactions.length === 0
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                radius: 18
                                color: "#0f1524"
                                border.color: "#1b2438"
                                ColumnLayout {
                                    anchors.centerIn: parent
                                    width: Math.min(parent.width - 40, 420)
                                    spacing: 8
                                    Image { Layout.alignment: Qt.AlignHCenter; Layout.preferredWidth: 38; Layout.preferredHeight: 38; source: "qrc:/icons/cp-wallet.svg"; opacity: 0.55; fillMode: Image.PreserveAspectFit }
                                    Label { Layout.fillWidth: true; text: consolePane.trText("История пока пустая"); color: "#dce6ff"; font.family: consolePane.fontUi; font.pixelSize: 16; font.weight: Font.DemiBold; horizontalAlignment: Text.AlignHCenter }
                                    Label { Layout.fillWidth: true; text: consolePane.trText("Пополнения, покупки пакетов и списания появятся здесь."); color: "#828ca6"; font.family: consolePane.fontUi; font.pixelSize: 13; wrapMode: Text.WordWrap; horizontalAlignment: Text.AlignHCenter }
                                }
                            }
                            Repeater {
                                model: consolePane.walletTransactions
                                delegate: Rectangle {
                                    visible: consolePane.walletTransactions.length > 0
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 58
                                    radius: 16
                                    color: "#101827"
                                    border.color: "#1b2438"
                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.leftMargin: 14
                                        anchors.rightMargin: 14
                                        spacing: 12
                                        Rectangle { Layout.preferredWidth: 34; Layout.preferredHeight: 34; radius: 17; color: "#14213a"; border.color: "#263653"; Image { anchors.centerIn: parent; width: 18; height: 18; source: "qrc:/icons/cp-check.svg"; fillMode: Image.PreserveAspectFit; opacity: 0.85 } }
                                        ColumnLayout { Layout.fillWidth: true; spacing: 0; Label { Layout.fillWidth: true; text: modelData.title; color: "#eaf0ff"; font.family: consolePane.fontUi; font.pixelSize: 13; font.weight: Font.DemiBold; elide: Text.ElideRight } Label { Layout.fillWidth: true; text: modelData.time; color: "#828ca6"; font.family: consolePane.fontUi; font.pixelSize: 11; elide: Text.ElideRight } }
                                        Label { text: modelData.amount; color: consolePane.neonCyan; font.family: consolePane.fontMono; font.pixelSize: 13; font.weight: Font.DemiBold }
                                        Label { Layout.preferredWidth: 80; text: modelData.status; color: "#8c9ab8"; font.family: consolePane.fontUi; font.pixelSize: 12; horizontalAlignment: Text.AlignRight; elide: Text.ElideRight }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Component { id: packagesPage; Item { ColumnLayout { anchors.fill: parent; spacing: 14
        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 96; radius: 20; color: "#0b0f1b"; border.color: consolePane.cardBorder
            RowLayout { anchors.fill: parent; anchors.margins: 18; spacing: 14
                ColumnLayout { Layout.fillWidth: true; spacing: 4
                    Label { text: consolePane.trText("Игровое время"); color: "#eaf0ff"; font.family: consolePane.fontDisplay; font.pixelSize: 22; font.weight: Font.DemiBold }
                    Label { visible: consolePane.packagesLoading || !consolePane.cloudPlayLoggedIn; text: consolePane.packagesStatusText; color: "#8c9ab8"; font.family: consolePane.fontUi; font.pixelSize: 13; wrapMode: Text.WordWrap }
                }
                SoftButton { text: consolePane.packagesLoading ? consolePane.trText("Загрузка…") : consolePane.trText("Обновить"); onClicked: consolePane.cloudPlayLoggedIn ? consolePane.loadPackages() : consolePane.beginTelegramLogin() }
            }
        }
        ScrollView { id: packagesScroll; Layout.fillWidth: true; Layout.fillHeight: true; clip: true; contentWidth: availableWidth
            GridLayout { id: packagesGrid; width: packagesScroll.availableWidth; columns: packagesScroll.availableWidth > 760 ? 2 : 1; rowSpacing: 14; columnSpacing: 14
                Repeater {
                    model: consolePane.availablePackages
                    delegate: PackageCard {
                        Layout.preferredWidth: packagesGrid.columns === 2 ? Math.floor((packagesGrid.width - packagesGrid.columnSpacing) / 2) : packagesGrid.width
                        packageId: modelData.id
                        minutes: modelData.minutes
                        amount: modelData.amount
                        hours: modelData.title
                        price: modelData.price
                        badge: modelData.badge
                        rate: modelData.rate
                    }
                }
            }
        }
    } } }

    Component { id: queuePage; Item { Rectangle { anchors.fill: parent; radius: 24; color: "#0b0f1b"; border.color: "#1f2a46"
        RowLayout { anchors.centerIn: parent; spacing: 34
            Rectangle { Layout.preferredWidth: 180; Layout.preferredHeight: 180; radius: 90; color: "transparent"; border.width: 12; border.color: consolePane.queueReady ? "#36e08a" : "#19e9ff"; Label { anchors.centerIn: parent; text: consolePane.queueReady ? "✓" : (consolePane.queuePosition > 0 ? ("#" + consolePane.queuePosition) : "0"); color: "#eaf0ff"; font.pixelSize: 42; font.weight: Font.Bold } }
            ColumnLayout { Layout.preferredWidth: 520; spacing: 12
                Label { text: consolePane.queueReady ? consolePane.trText("Очередь подошла") : (consolePane.availableSlots > 0 ? consolePane.trText("PS5 свободна") : consolePane.trText("Все PS5 заняты")); color: "#eaf0ff"; font.pixelSize: 29; font.weight: Font.Bold }
                Label { Layout.fillWidth: true; text: consolePane.queueText.length > 0 ? consolePane.queueText : (consolePane.availableSlots > 0 ? consolePane.trText("Можно играть сейчас.") : consolePane.trText("Ожидаем свободную PS5. Мы уведомим вас в Telegram, когда очередь подойдёт.")); color: "#b7c2dc"; font.pixelSize: 16; wrapMode: Text.WordWrap }
                Label { text: consolePane.trText("Место: ") + (consolePane.queuePosition > 0 ? consolePane.queuePosition : "—") + consolePane.trText(" · Ожидание: ") + consolePane.queueEtaText; color: "#828ca6"; font.pixelSize: 14 }
                Label { visible: consolePane.queueNotifyTelegram || consolePane.queueTelegramNotified; text: consolePane.trText("✓ Сообщим в Telegram, когда подойдёт очередь"); color: "#36e08a"; font.pixelSize: 14 }
                RowLayout { NeonButton { text: consolePane.queueReady ? consolePane.trText("Играть") : consolePane.trText("Играть"); onClicked: consolePane.openPlayStart() } SoftButton { text: consolePane.trText("Обновить"); onClicked: consolePane.loadQueueStatus(false) } SoftButton { visible: !consolePane.queueNotifyTelegram && !consolePane.queueTelegramNotified && (consolePane.queuePosition > 0 || consolePane.queueTicketId.length > 0); text: consolePane.trText("Уведомить в Telegram"); onClicked: consolePane.enableQueueTelegramNotify() } SoftButton { visible: consolePane.queuePosition > 0 || consolePane.queueTicketId.length > 0; text: consolePane.trText("Отменить"); onClicked: consolePane.cancelQueue() } }
            }
        }
    } } }

    Component { id: profilePage; Item { RowLayout { anchors.fill: parent; spacing: 14
        Rectangle { Layout.preferredWidth: 380; Layout.fillHeight: true; radius: 22; color: "#0b0f1b"; border.color: consolePane.cardBorder
            ColumnLayout { anchors.fill: parent; anchors.margins: 22; spacing: 14
                Rectangle { Layout.preferredWidth: 76; Layout.preferredHeight: 76; radius: 38; color: "#14213a"; border.color: consolePane.cardBorder; Label { anchors.centerIn: parent; text: "CP"; color: consolePane.neonCyan; font.family: consolePane.fontDisplay; font.pixelSize: 22; font.weight: Font.DemiBold } }
                Label { Layout.fillWidth: true; text: consolePane.cloudPlayUser; color: "#eaf0ff"; font.family: consolePane.fontDisplay; font.pixelSize: 23; font.weight: Font.DemiBold; elide: Text.ElideRight }
                Label { text: consolePane.cloudPlayLoggedIn ? consolePane.trText("Вы вошли через Telegram") : consolePane.trText("Вход не выполнен"); color: consolePane.cloudPlayLoggedIn ? "#36e08a" : "#ffb86b"; font.family: consolePane.fontUi }
                StatCard { title: consolePane.trText("Баланс"); value: consolePane.formatMoney(consolePane.walletBalanceUzs); note: consolePane.trText("На аккаунте"); valueColor: consolePane.neonCyan }
                StatCard { title: consolePane.trText("Игровое время"); value: consolePane.minutesBalance + consolePane.trText(" мин"); note: consolePane.trText("Доступно для игры"); valueColor: consolePane.neonPink }
                Item { Layout.fillHeight: true }
                NeonButton { Layout.fillWidth: true; text: consolePane.cloudPlayLoggedIn ? consolePane.trText("Играть") : consolePane.trText("Войти"); onClicked: consolePane.openPlayStart() }
                SoftButton { Layout.fillWidth: true; text: consolePane.trText("Поддержка"); onClicked: supportPopup.open() }
                Button { Layout.fillWidth: true; text: consolePane.trText("Выйти"); flat: true; visible: consolePane.cloudPlayLoggedIn; onClicked: consolePane.logoutCloudPlay() }
            }
        }
        Rectangle { Layout.fillWidth: true; Layout.fillHeight: true; radius: 22; color: "#0b0f1b"; border.color: consolePane.cardBorder
            ColumnLayout { anchors.fill: parent; anchors.margins: 18; spacing: 12
                RowLayout { Layout.fillWidth: true; Label { text: consolePane.trText("Недавние игры"); color: "#eaf0ff"; font.family: consolePane.fontDisplay; font.pixelSize: 18; font.weight: Font.DemiBold } Item { Layout.fillWidth: true } SoftButton { text: consolePane.trText("Обновить"); onClicked: consolePane.loadSessionHistory() } }
                Repeater { model: consolePane.recentSessions; delegate: Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 68; radius: 16; color: "#101827"; border.color: "#1b2438"; RowLayout { anchors.fill: parent; anchors.margins: 14; spacing: 12; ColumnLayout { Layout.fillWidth: true; spacing: 2; Label { Layout.fillWidth: true; text: modelData.title; color: "#eaf0ff"; font.weight: Font.DemiBold; elide: Text.ElideRight } Label { Layout.fillWidth: true; text: modelData.time; color: "#828ca6"; font.pixelSize: 12; elide: Text.ElideRight } } Label { text: modelData.duration; color: consolePane.neonCyan; font.family: consolePane.fontMono } } } }
                Item { Layout.fillHeight: true }
                Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 96; radius: 18; color: "#0f1524"; border.color: consolePane.cardBorder; RowLayout { anchors.fill: parent; anchors.margins: 16; ColumnLayout { Layout.fillWidth: true; spacing: 4; Label { text: consolePane.trText("Поддержка"); color: "#eaf0ff"; font.pixelSize: 16; font.weight: Font.DemiBold } Label { text: consolePane.supportCallDisplay; color: "#8c9ab8"; font.family: consolePane.fontMono } } SoftButton { text: consolePane.trText("Позвонить"); onClicked: consolePane.callSupport() } SoftButton { text: "Telegram"; onClicked: consolePane.openSupportTelegram() } } }
            }
        }
    } } }


    Component {
        id: settingsPage
        Item {
            RowLayout {
                anchors.fill: parent
                spacing: 14

                Rectangle {
                    Layout.preferredWidth: 334
                    Layout.fillHeight: true
                    radius: 24
                    color: "#0b0f1b"
                    border.color: consolePane.cardBorder

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 14

                        Rectangle {
                            Layout.preferredWidth: 66
                            Layout.preferredHeight: 66
                            radius: 20
                            color: "#101827"
                            border.color: "#1f2a46"
                            Image {
                                anchors.centerIn: parent
                                width: 30
                                height: 30
                                source: "qrc:/icons/cp-settings.svg"
                                fillMode: Image.PreserveAspectFit
                                opacity: 0.92
                            }
                        }

                        Label { Layout.fillWidth: true; text: consolePane.trText("Настройки"); color: "#eaf0ff"; font.family: consolePane.fontDisplay; font.pixelSize: 25; font.weight: Font.DemiBold }
                        Label { Layout.fillWidth: true; text: consolePane.trText("Управление приложением, качеством игры, звуком и геймпадом. Всё в стиле CloudPlay — без технических экранов."); color: "#8c9ab8"; font.family: consolePane.fontUi; font.pixelSize: 13; lineHeight: 1.15; wrapMode: Text.WordWrap }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 8
                            SettingsCategoryButton { title: consolePane.trText("Игра"); subtitle: consolePane.trText("качество и поток"); iconSource: "qrc:/icons/cp-play.svg"; key: "stream" }
                            SettingsCategoryButton { title: consolePane.trText("Экран"); subtitle: consolePane.trText("картинка, цвет и рендер"); iconSource: "qrc:/icons/cp-display.svg"; key: "display" }
                            SettingsCategoryButton { title: consolePane.trText("Звук"); subtitle: consolePane.trText("аудио и приватность"); iconSource: "qrc:/icons/cp-bell.svg"; key: "audio" }
                            SettingsCategoryButton { title: consolePane.trText("Геймпад"); subtitle: consolePane.trText("контроллер и вибрация"); iconSource: "qrc:/icons/cp-gamepad.svg"; key: "controls" }
                            SettingsCategoryButton { title: consolePane.trText("Клавиатура"); subtitle: consolePane.trText("клавиши и мышь"); iconSource: "qrc:/icons/cp-keyboard.svg"; key: "keyboard" }
                            SettingsCategoryButton { title: consolePane.trText("Язык"); subtitle: consolePane.trText("язык интерфейса"); iconSource: "qrc:/icons/cp-settings.svg"; key: "language" }
                            SettingsCategoryButton { title: consolePane.trText("Обновление"); subtitle: consolePane.trText("новая версия приложения"); iconSource: "qrc:/icons/cp-refresh.svg"; key: "updates" }
                            SettingsCategoryButton { title: consolePane.trText("Аккаунт"); subtitle: consolePane.trText("профиль и поддержка"); iconSource: "qrc:/icons/cp-user.svg"; key: "account" }
                        }

                        Item { Layout.fillHeight: true }
                        NeonButton { Layout.fillWidth: true; text: consolePane.trText("Играть"); onClicked: consolePane.openPlayStart() }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 24
                    color: "#0b0f1b"
                    border.color: consolePane.cardBorder
                    clip: true

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 22
                        spacing: 16

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 14
                            Rectangle {
                                Layout.preferredWidth: 54
                                Layout.preferredHeight: 54
                                radius: 17
                                color: "#101827"
                                border.color: "#1f2a46"
                                Image {
                                    anchors.centerIn: parent
                                    width: 26
                                    height: 26
                                    source: consolePane.settingsCategoryIcon(consolePane.settingsCategory)
                                    fillMode: Image.PreserveAspectFit
                                    opacity: 0.9
                                }
                            }
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2
                                Label { Layout.fillWidth: true; text: consolePane.settingsCategoryTitle(consolePane.settingsCategory); color: "#eaf0ff"; font.family: consolePane.fontDisplay; font.pixelSize: 22; font.weight: Font.DemiBold; elide: Text.ElideRight }
                                Label { Layout.fillWidth: true; text: consolePane.settingsCategorySubtitle(consolePane.settingsCategory); color: "#8c9ab8"; font.family: consolePane.fontUi; font.pixelSize: 13; elide: Text.ElideRight }
                            }
                        }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: "#121b30"; opacity: 0.7 }

                        Flickable {
                            id: settingsScroll
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            contentWidth: width
                            contentHeight: settingsContent.implicitHeight + 12
                            boundsBehavior: Flickable.StopAtBounds
                            flickableDirection: Flickable.VerticalFlick
                            ScrollBar.vertical: ScrollBar {
                                policy: settingsScroll.contentHeight > settingsScroll.height ? ScrollBar.AlwaysOn : ScrollBar.AsNeeded
                            }

                            ColumnLayout {
                                id: settingsContent
                                width: settingsScroll.width - (settingsScroll.contentHeight > settingsScroll.height ? 14 : 0)
                                spacing: 12

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 12
                                    visible: consolePane.settingsCategory === "stream"
                                    SettingComboRow { title: consolePane.trText("После выхода из игры"); subtitle: consolePane.trText("Что делать с консолью после завершения."); modelValues: [consolePane.trText("Оставить как есть"), consolePane.trText("Перевести в режим покоя"), consolePane.trText("Спросить")] ; currentIndex: Chiaki.settings.disconnectAction; onActivated: index => Chiaki.settings.disconnectAction = index }
                                    SettingComboRow { title: consolePane.trText("При сворачивании"); subtitle: consolePane.trText("Поведение при потере фокуса приложения."); modelValues: [consolePane.trText("Ничего не делать"), consolePane.trText("Режим покоя")] ; currentIndex: Chiaki.settings.suspendAction; onActivated: index => Chiaki.settings.suspendAction = index }
                                    SettingToggleRow { title: consolePane.trText("Меню во время игры"); subtitle: consolePane.trText("Быстрый доступ к настройкам в стриме."); checked: Chiaki.settings.streamMenuEnabled; onToggled: value => Chiaki.settings.streamMenuEnabled = value }
                                    SettingToggleRow { title: consolePane.trText("Статистика поверх игры"); subtitle: consolePane.trText("FPS, задержка и сеть во время сессии."); checked: Chiaki.settings.showStreamStats; onToggled: value => Chiaki.settings.showStreamStats = value }
                                    SettingComboRow { title: consolePane.trText("Кнопка меню 1"); subtitle: consolePane.trText("Первое сочетание для меню в игре."); modelValues: [consolePane.trText("Нет"), "Share", "Options", "PS", "Touchpad"] ; currentIndex: Chiaki.settings.streamMenuShortcut1; onActivated: index => Chiaki.settings.streamMenuShortcut1 = index }
                                    SettingComboRow { title: consolePane.trText("Кнопка меню 2"); subtitle: consolePane.trText("Второе сочетание для меню в игре."); modelValues: [consolePane.trText("Нет"), "Share", "Options", "PS", "Touchpad"] ; currentIndex: Chiaki.settings.streamMenuShortcut2; onActivated: index => Chiaki.settings.streamMenuShortcut2 = index }
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 12
                                    visible: consolePane.settingsCategory === "display"
                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: 120
                                        radius: 18
                                        color: "#0f1524"
                                        border.color: "#1b2946"
                                        ColumnLayout {
                                            anchors.fill: parent
                                            anchors.margins: 18
                                            spacing: 8
                                            Label { Layout.fillWidth: true; text: consolePane.trText("Видео и рендер — дефолт Chiaki"); color: "#eaf0ff"; font.family: consolePane.fontUi; font.pixelSize: 17; font.weight: Font.Bold }
                                            Label { Layout.fillWidth: true; text: consolePane.trText("В этой macOS сборке CloudPlay не меняет bitrate, codec, FPS, renderer или FEC. Используется чистый upstream Chiaki stream path."); color: "#9aa8c4"; wrapMode: Text.WordWrap; font.family: consolePane.fontUi; font.pixelSize: 13 }
                                        }
                                    }
                                    SettingToggleRow { title: consolePane.trText("Вертикальная синхронизация"); subtitle: consolePane.trText("Стандартная настройка Chiaki, без CloudPlay override."); checked: Chiaki.settings.vSyncEnabled; onToggled: value => Chiaki.settings.vSyncEnabled = value }
                                    SettingToggleRow { title: consolePane.trText("Скрывать курсор"); subtitle: consolePane.trText("Убирает мышь поверх игры."); checked: Chiaki.settings.hideCursor; onToggled: value => Chiaki.settings.hideCursor = value }
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 12
                                    visible: consolePane.settingsCategory === "audio"
                                    SettingComboRow { title: consolePane.trText("Видео и звук"); subtitle: consolePane.trText("Быстро отключить звук или картинку при необходимости."); modelValues: [consolePane.trText("Всё включено"), consolePane.trText("Отключить звук"), consolePane.trText("Отключить видео"), consolePane.trText("Отключить всё")] ; currentIndex: Chiaki.settings.audioVideoDisabled; onActivated: index => Chiaki.settings.audioVideoDisabled = index }
                                    SettingComboRow { title: consolePane.trText("Устройство вывода"); subtitle: consolePane.trText("Куда выводить звук игры."); modelValues: [consolePane.trText("Авто")].concat(Chiaki.settings.availableAudioOutDevices); currentIndex: Math.max(0, modelValues.indexOf(Chiaki.settings.audioOutDevice)); onActivated: index => Chiaki.settings.audioOutDevice = index ? modelValues[index] : "" }
                                    SettingComboRow { title: consolePane.trText("Микрофон"); subtitle: consolePane.trText("Устройство ввода для голосового чата."); modelValues: [consolePane.trText("Авто")].concat(Chiaki.settings.availableAudioInDevices); currentIndex: Math.max(0, modelValues.indexOf(Chiaki.settings.audioInDevice)); onActivated: index => Chiaki.settings.audioInDevice = index ? modelValues[index] : "" }
                                    SettingSliderRow { title: consolePane.trText("Громкость"); subtitle: consolePane.trText("Общая громкость звука игры."); from: 0; to: 100; stepSize: 1; valueSuffix: "%"; currentValue: Chiaki.settings.audioVolume; onMoved: value => Chiaki.settings.audioVolume = value }
                                    SettingSliderRow { title: consolePane.trText("Буфер аудио"); subtitle: consolePane.trText("Больше буфер — стабильнее звук, но выше задержка."); from: 1; to: 20; stepSize: 1; valueSuffix: ""; currentValue: Chiaki.settings.audioBufferSize / 1920 ? (Chiaki.settings.audioBufferSize / 1920) : 5; onMoved: value => Chiaki.settings.audioBufferSize = value * 1920 }
                                    SettingToggleRow { title: consolePane.trText("Микрофон включён при старте"); subtitle: consolePane.trText("Автоматически открывать голос во время игры."); checked: Chiaki.settings.startMicUnmuted; onToggled: value => Chiaki.settings.startMicUnmuted = value }
                                    SettingToggleRow { title: consolePane.trText("Уведомления сети"); subtitle: consolePane.trText("Показывать предупреждения при просадках Wi‑Fi."); checked: Chiaki.settings.wifiDroppedNotif > 0; onToggled: value => Chiaki.settings.wifiDroppedNotif = value ? 10 : 0 }
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 12
                                    visible: consolePane.settingsCategory === "controls"
                                    SettingToggleRow { title: consolePane.trText("Геймпад в фоне"); subtitle: consolePane.trText("Оставлять управление активным при потере фокуса."); checked: Chiaki.settings.allowJoystickBackgroundEvents; onToggled: value => Chiaki.settings.allowJoystickBackgroundEvents = value }
                                    SettingToggleRow { title: consolePane.trText("Кнопки по позиции"); subtitle: consolePane.trText("Помогает, если кнопки контроллера перепутаны."); checked: Chiaki.settings.buttonsByPosition; onToggled: value => Chiaki.settings.buttonsByPosition = value }
                                    SettingComboRow { title: consolePane.trText("Вибрация"); subtitle: consolePane.trText("Интенсивность вибрации и haptics."); modelValues: [consolePane.trText("Выкл"), consolePane.trText("Слабо"), consolePane.trText("Средне"), consolePane.trText("Сильно")] ; currentIndex: Chiaki.settings.rumbleHapticsIntensity; onActivated: index => Chiaki.settings.rumbleHapticsIntensity = index }
                                    SettingSliderRow { title: consolePane.trText("Сила haptics"); subtitle: consolePane.trText("Ручная тонкая настройка отклика."); from: 0; to: 100; stepSize: 1; valueSuffix: "%"; currentValue: Chiaki.settings.hapticOverride; onMoved: value => Chiaki.settings.hapticOverride = value }
                                    SettingToggleRow { title: consolePane.trText("Сенсорная крестовина"); subtitle: consolePane.trText("Дополнительная D‑pad логика для некоторых игр."); checked: Chiaki.settings.dpadTouchEnabled; onToggled: value => Chiaki.settings.dpadTouchEnabled = value }
                                    SettingSliderRow { title: consolePane.trText("Шаг крестовины"); subtitle: consolePane.trText("Чувствительность сенсорной крестовины."); from: 1; to: 20; stepSize: 1; valueSuffix: ""; currentValue: Chiaki.settings.dpadTouchIncrement; onMoved: value => Chiaki.settings.dpadTouchIncrement = value }
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 12
                                    visible: consolePane.settingsCategory === "keyboard"
                                    SettingToggleRow { title: consolePane.trText("Клавиатура"); subtitle: consolePane.trText("Разрешить управление с клавиатуры."); checked: Chiaki.settings.keyboardEnabled; onToggled: value => Chiaki.settings.keyboardEnabled = value }
                                    SettingToggleRow { title: consolePane.trText("Мышь как тачпад"); subtitle: consolePane.trText("Использовать мышь для тачпада контроллера."); checked: Chiaki.settings.mouseTouchEnabled; onToggled: value => Chiaki.settings.mouseTouchEnabled = value }
                                    Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 54; radius: 16; color: "#0b0f1b"; border.color: "#1a2540"; RowLayout { anchors.fill: parent; anchors.leftMargin: 16; anchors.rightMargin: 16; spacing: 12; Label { Layout.fillWidth: true; text: consolePane.trText("Раскладка клавиатуры"); color: "#eaf0ff"; font.family: consolePane.fontUi; font.pixelSize: 15; font.weight: Font.DemiBold; elide: Text.ElideRight } Label { text: consolePane.trText("для игры без геймпада"); color: "#8c9ab8"; font.family: consolePane.fontUi; font.pixelSize: 12 } } }
                                    Repeater {
                                        model: Chiaki.settings.controllerMapping
                                        KeyMappingRow { actionTitle: modelData.buttonName; keyName: modelData.keyName; buttonValue: modelData.buttonValue }
                                    }
                                    SettingActionRow { title: consolePane.trText("Сбросить клавиши"); subtitle: consolePane.trText("Вернуть стандартную раскладку клавиатуры."); buttonText: consolePane.trText("Сброс"); onTriggered: Chiaki.settings.clearKeyMapping() }
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 12
                                    visible: consolePane.settingsCategory === "language"
                                    SettingComboRow { title: consolePane.trText("Язык приложения"); subtitle: consolePane.trText("Выберите язык приложения. Интерфейс переключится сразу."); modelValues: [consolePane.trText("Русский"), consolePane.trText("Английский"), consolePane.trText("Узбекский")] ; currentIndex: Math.max(0, ["ru", "en", "uz"].indexOf(cloudStore.appLanguage)); onActivated: index => cloudStore.appLanguage = ["ru", "en", "uz"][index] }
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 12
                                    visible: consolePane.settingsCategory === "updates"
                                    Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 148; radius: 20; color: "#0f1524"; border.color: consolePane.updateAvailable ? consolePane.neonCyan : consolePane.cardBorder; RowLayout { anchors.fill: parent; anchors.margins: 16; spacing: 14; Rectangle { Layout.preferredWidth: 52; Layout.preferredHeight: 52; radius: 18; color: consolePane.updateAvailable ? "#113244" : "#14213a"; border.color: consolePane.updateAvailable ? consolePane.neonCyan : "#1f2a46"; Image { anchors.centerIn: parent; width: 25; height: 25; source: "qrc:/icons/cp-refresh.svg"; fillMode: Image.PreserveAspectFit; opacity: 0.95 } } ColumnLayout { Layout.fillWidth: true; spacing: 5; Label { Layout.fillWidth: true; text: consolePane.trText("CloudPlay Console") + " " + Qt.application.version; color: "#eaf0ff"; font.family: consolePane.fontUi; font.pixelSize: 16; font.weight: Font.DemiBold; elide: Text.ElideRight } Label { Layout.fillWidth: true; text: consolePane.updateStatusText; color: consolePane.updateAvailable ? consolePane.neonCyan : "#8c9ab8"; font.family: consolePane.fontUi; font.pixelSize: 13; wrapMode: Text.WordWrap } Label { Layout.fillWidth: true; visible: consolePane.updateLatestVersion.length > 0; text: consolePane.trText("Новая версия") + ": " + consolePane.updateLatestVersion; color: "#8c9ab8"; font.family: consolePane.fontUi; font.pixelSize: 12 } Label { Layout.fillWidth: true; visible: consolePane.updateReleaseNotes.length > 0; text: consolePane.updateReleaseNotes; color: "#71809f"; font.family: consolePane.fontUi; font.pixelSize: 12; maximumLineCount: 2; elide: Text.ElideRight; wrapMode: Text.WordWrap } } } }
                                    RowLayout { Layout.fillWidth: true; spacing: 10; SoftButton { Layout.fillWidth: true; text: consolePane.updateChecking ? consolePane.trText("Проверяем…") : consolePane.trText("Проверить обновление"); enabled: !consolePane.updateChecking; onClicked: consolePane.checkForUpdates(false) } NeonButton { Layout.fillWidth: true; text: consolePane.updateAvailable ? consolePane.trText("Скачать обновление") : consolePane.trText("Открыть релиз"); enabled: consolePane.updateDownloadUrl.length > 0; onClicked: consolePane.openUpdateDownload() } }
                                    Label { Layout.fillWidth: true; text: consolePane.trText("Если вышла новая версия, приложение откроет официальный установщик для macOS или Windows."); color: "#71809f"; font.family: consolePane.fontUi; font.pixelSize: 12; wrapMode: Text.WordWrap }
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 12
                                    visible: consolePane.settingsCategory === "account"
                                    Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 112; radius: 20; color: "#0f1524"; border.color: consolePane.cardBorder; RowLayout { anchors.fill: parent; anchors.margins: 16; spacing: 14; Rectangle { Layout.preferredWidth: 52; Layout.preferredHeight: 52; radius: 26; color: "#14213a"; border.color: "#1f2a46"; Label { anchors.centerIn: parent; text: "CP"; color: consolePane.neonCyan; font.family: consolePane.fontDisplay; font.pixelSize: 16; font.weight: Font.DemiBold } } ColumnLayout { Layout.fillWidth: true; spacing: 3; Label { Layout.fillWidth: true; text: consolePane.cloudPlayUser; color: "#eaf0ff"; font.family: consolePane.fontUi; font.pixelSize: 16; font.weight: Font.DemiBold; elide: Text.ElideRight } Label { text: consolePane.cloudPlayLoggedIn ? consolePane.trText("Аккаунт подключён") : consolePane.trText("Войдите через Telegram"); color: consolePane.cloudPlayLoggedIn ? "#36e08a" : "#ffb86b"; font.family: consolePane.fontUi; font.pixelSize: 12 } Label { text: consolePane.formatMoney(consolePane.walletBalanceUzs) + " · " + consolePane.minutesBalance + consolePane.trText(" мин"); color: "#8c9ab8"; font.family: consolePane.fontUi; font.pixelSize: 12 } } SoftButton { text: consolePane.trText("Профиль"); onClicked: consolePane.currentPage = "profile" } } }
                                    SettingToggleRow { title: consolePane.trText("Приватный режим"); subtitle: consolePane.trText("Скрывать данные аккаунта в трансляциях и скриншотах."); checked: Chiaki.settings.streamerMode; onToggled: value => Chiaki.settings.streamerMode = value }
                                    SettingToggleRow { title: consolePane.trText("Безопасные логи"); subtitle: consolePane.trText("Скрывать чувствительные данные в логах."); checked: Chiaki.settings.logSanitize; onToggled: value => Chiaki.settings.logSanitize = value }
                                    Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 86; radius: 18; color: "#0f1524"; border.color: consolePane.cardBorder; RowLayout { anchors.fill: parent; anchors.margins: 16; spacing: 12; ColumnLayout { Layout.fillWidth: true; spacing: 4; Label { text: consolePane.trText("Поддержка"); color: "#eaf0ff"; font.family: consolePane.fontUi; font.pixelSize: 15; font.weight: Font.DemiBold } Label { Layout.fillWidth: true; text: consolePane.supportCallDisplay; color: "#8c9ab8"; font.family: consolePane.fontUi; font.pixelSize: 12; elide: Text.ElideRight } } SoftButton { text: consolePane.trText("Позвонить"); onClicked: consolePane.callSupport() } SoftButton { text: "Telegram"; onClicked: consolePane.openSupportTelegram() } } }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Dialog {
        id: keyCaptureDialog
        property int buttonValue: 0
        property var buttonCallback: null
        parent: Overlay.overlay
        x: Math.round((root.width - width) / 2)
        y: Math.round((root.height - height) / 2)
        title: qsTr(consolePane.trText("Назначить клавишу"))
        modal: true
        standardButtons: Dialog.Close
        closePolicy: Popup.CloseOnPressOutside
        onOpened: keyCaptureLabel.forceActiveFocus(Qt.TabFocusReason)

        function show(opts) {
            buttonValue = opts.value;
            buttonCallback = opts.callback;
            open();
        }

        Label {
            id: keyCaptureLabel
            focus: true
            Layout.preferredWidth: 360
            wrapMode: Text.WordWrap
            text: qsTr(consolePane.trText("Нажмите любую клавишу, чтобы назначить её на выбранную кнопку."))
            Keys.onReleased: (event) => {
                var name = Chiaki.settings.changeControllerKey(keyCaptureDialog.buttonValue, event.key);
                if (keyCaptureDialog.buttonCallback)
                    keyCaptureDialog.buttonCallback(name);
                keyCaptureDialog.close();
                event.accepted = true;
            }
        }
    }

    component SettingsCategoryButton: Button {
        id: categoryButton
        property string key: "stream"
        property string title: ""
        property string subtitle: ""
        property string iconSource: "qrc:/icons/cp-settings.svg"
        Layout.fillWidth: true
        Layout.preferredHeight: 58
        flat: true
        padding: 0
        focusPolicy: Qt.NoFocus
        highlighted: consolePane.settingsCategory === categoryButton.key
        background: Rectangle {
            radius: 16
            color: categoryButton.highlighted ? "#101827" : (categoryButton.hovered ? "#0d1320" : "transparent")
            border.width: categoryButton.highlighted ? 1 : 0
            border.color: "#1f2a46"
        }
        contentItem: Item {
            anchors.fill: parent
            Image { id: categoryIcon; width: 21; height: 21; anchors.left: parent.left; anchors.leftMargin: 14; anchors.verticalCenter: parent.verticalCenter; source: categoryButton.iconSource; fillMode: Image.PreserveAspectFit; opacity: 0.88 }
            ColumnLayout { anchors.left: categoryIcon.right; anchors.leftMargin: 12; anchors.right: parent.right; anchors.rightMargin: 12; anchors.verticalCenter: parent.verticalCenter; spacing: -1
                Label { Layout.fillWidth: true; text: categoryButton.title; color: categoryButton.highlighted ? "#eaf0ff" : "#a6b2cc"; font.family: consolePane.fontUi; font.pixelSize: 14; font.weight: categoryButton.highlighted ? Font.DemiBold : Font.Medium; elide: Text.ElideRight }
                Label { Layout.fillWidth: true; text: categoryButton.subtitle; color: "#6f7c96"; font.family: consolePane.fontUi; font.pixelSize: 11; elide: Text.ElideRight }
            }
        }
        onClicked: consolePane.settingsCategory = categoryButton.key
    }

    component SettingToggleRow: Rectangle {
        id: toggleRow
        property string title: ""
        property string subtitle: ""
        property bool checked: false
        signal toggled(bool value)
        Layout.fillWidth: true
        Layout.preferredHeight: 78
        radius: 18
        color: "#0f1524"
        border.width: 1
        border.color: consolePane.cardBorder
        RowLayout { anchors.fill: parent; anchors.margins: 16; spacing: 14
            ColumnLayout { Layout.fillWidth: true; spacing: 3
                Label { Layout.fillWidth: true; text: toggleRow.title; color: "#eaf0ff"; font.family: consolePane.fontUi; font.pixelSize: 15; font.weight: Font.DemiBold; elide: Text.ElideRight }
                Label { Layout.fillWidth: true; text: toggleRow.subtitle; color: "#8c9ab8"; font.family: consolePane.fontUi; font.pixelSize: 12; elide: Text.ElideRight }
            }
            Switch { checked: toggleRow.checked; onToggled: toggleRow.toggled(checked) }
        }
    }

    component SettingComboRow: Rectangle {
        id: comboRow
        property string title: ""
        property string subtitle: ""
        property var modelValues: []
        property int currentIndex: 0
        signal activated(int index)
        Layout.fillWidth: true
        Layout.preferredHeight: 86
        radius: 18
        color: "#0f1524"
        border.width: 1
        border.color: consolePane.cardBorder
        RowLayout { anchors.fill: parent; anchors.margins: 16; spacing: 14
            ColumnLayout { Layout.fillWidth: true; spacing: 3
                Label { Layout.fillWidth: true; text: comboRow.title; color: "#eaf0ff"; font.family: consolePane.fontUi; font.pixelSize: 15; font.weight: Font.DemiBold; elide: Text.ElideRight }
                Label { Layout.fillWidth: true; text: comboRow.subtitle; color: "#8c9ab8"; font.family: consolePane.fontUi; font.pixelSize: 12; elide: Text.ElideRight }
            }
            ComboBox { Layout.preferredWidth: 230; model: comboRow.modelValues; currentIndex: comboRow.currentIndex; onActivated: index => comboRow.activated(index) }
        }
    }

    component SettingSliderRow: Rectangle {
        id: sliderRow
        property string title: ""
        property string subtitle: ""
        property real from: 0
        property real to: 100
        property real stepSize: 1
        property real currentValue: 0
        property string valueSuffix: ""
        signal moved(real value)
        Layout.fillWidth: true
        Layout.preferredHeight: 94
        radius: 18
        color: "#0f1524"
        border.width: 1
        border.color: consolePane.cardBorder
        RowLayout { anchors.fill: parent; anchors.margins: 16; spacing: 14
            ColumnLayout { Layout.fillWidth: true; spacing: 3
                Label { Layout.fillWidth: true; text: sliderRow.title; color: "#eaf0ff"; font.family: consolePane.fontUi; font.pixelSize: 15; font.weight: Font.DemiBold; elide: Text.ElideRight }
                Label { Layout.fillWidth: true; text: sliderRow.subtitle; color: "#8c9ab8"; font.family: consolePane.fontUi; font.pixelSize: 12; elide: Text.ElideRight }
            }
            Slider {
                id: settingsSlider
                Layout.preferredWidth: 210
                from: sliderRow.from
                to: sliderRow.to
                stepSize: sliderRow.stepSize
                value: sliderRow.currentValue
                snapMode: Slider.SnapAlways
                onMoved: sliderRow.moved(value)
            }
            Label { Layout.preferredWidth: 82; text: Math.round(settingsSlider.value) + sliderRow.valueSuffix; color: consolePane.neonCyan; font.family: consolePane.fontMono; font.pixelSize: 13; horizontalAlignment: Text.AlignRight }
        }
    }

    component SettingActionRow: Rectangle {
        id: actionRow
        property string title: ""
        property string subtitle: ""
        property string buttonText: consolePane.trText("Открыть")
        signal triggered()
        Layout.fillWidth: true
        Layout.preferredHeight: 86
        radius: 18
        color: "#0f1524"
        border.width: 1
        border.color: consolePane.cardBorder
        RowLayout { anchors.fill: parent; anchors.margins: 16; spacing: 14
            ColumnLayout { Layout.fillWidth: true; spacing: 3
                Label { Layout.fillWidth: true; text: actionRow.title; color: "#eaf0ff"; font.family: consolePane.fontUi; font.pixelSize: 15; font.weight: Font.DemiBold; elide: Text.ElideRight }
                Label { Layout.fillWidth: true; text: actionRow.subtitle; color: "#8c9ab8"; font.family: consolePane.fontUi; font.pixelSize: 12; elide: Text.ElideRight }
            }
            SoftButton { text: actionRow.buttonText; onClicked: actionRow.triggered() }
        }
    }

    component KeyMappingRow: Rectangle {
        id: keyRow
        property string actionTitle: ""
        property string keyName: ""
        property int buttonValue: 0
        Layout.fillWidth: true
        Layout.preferredHeight: 68
        radius: 18
        color: "#0f1524"
        border.width: 1
        border.color: consolePane.cardBorder

        function controllerIconSource(name) {
            switch (name) {
            case "Cross": return "qrc:/icons/cp-ps-cross.svg";
            case "Moon": return "qrc:/icons/cp-ps-circle.svg";
            case "Box": return "qrc:/icons/cp-ps-square.svg";
            case "Pyramid": return "qrc:/icons/cp-ps-triangle.svg";
            case "D-Pad Left": return "qrc:/icons/cp-ps-dpad-left.svg";
            case "D-Pad Right": return "qrc:/icons/cp-ps-dpad-right.svg";
            case "D-Pad Up": return "qrc:/icons/cp-ps-dpad-up.svg";
            case "D-Pad Down": return "qrc:/icons/cp-ps-dpad-down.svg";
            case "L1": return "qrc:/icons/cp-ps-l1.svg";
            case "R1": return "qrc:/icons/cp-ps-r1.svg";
            case "L2": return "qrc:/icons/cp-ps-l2.svg";
            case "R2": return "qrc:/icons/cp-ps-r2.svg";
            case "L3": return "qrc:/icons/cp-ps-l3.svg";
            case "R3": return "qrc:/icons/cp-ps-r3.svg";
            case "Options": return "qrc:/icons/cp-ps-options.svg";
            case "Share": return "qrc:/icons/cp-ps-share.svg";
            case "Touchpad": return "qrc:/icons/cp-ps-touchpad.svg";
            case "PS": return "qrc:/icons/cp-ps-ps.svg";
            case "MIC": return "qrc:/icons/cp-ps-mic.svg";
            case "Left Stick Right": return "qrc:/icons/cp-ps-stick-l-right.svg";
            case "Left Stick Left": return "qrc:/icons/cp-ps-stick-l-left.svg";
            case "Left Stick Up": return "qrc:/icons/cp-ps-stick-l-up.svg";
            case "Left Stick Down": return "qrc:/icons/cp-ps-stick-l-down.svg";
            case "Left Stick X": return "qrc:/icons/cp-ps-stick-l-x.svg";
            case "Left Stick Y": return "qrc:/icons/cp-ps-stick-l-y.svg";
            case "Right Stick Right": return "qrc:/icons/cp-ps-stick-r-right.svg";
            case "Right Stick Left": return "qrc:/icons/cp-ps-stick-r-left.svg";
            case "Right Stick Up": return "qrc:/icons/cp-ps-stick-r-up.svg";
            case "Right Stick Down": return "qrc:/icons/cp-ps-stick-r-down.svg";
            case "Right Stick X": return "qrc:/icons/cp-ps-stick-r-x.svg";
            case "Right Stick Y": return "qrc:/icons/cp-ps-stick-r-y.svg";
            default: return "";
            }
        }

        function controllerLabel(name) {
            switch (name) {
            case "Cross": return consolePane.trText("Крестик");
            case "Moon": return consolePane.trText("Круг");
            case "Box": return consolePane.trText("Квадрат");
            case "Pyramid": return consolePane.trText("Треугольник");
            case "D-Pad Left": return consolePane.trText("Крестовина влево");
            case "D-Pad Right": return consolePane.trText("Крестовина вправо");
            case "D-Pad Up": return consolePane.trText("Крестовина вверх");
            case "D-Pad Down": return consolePane.trText("Крестовина вниз");
            case "L1": return consolePane.trText("L1 / левый бампер");
            case "R1": return consolePane.trText("R1 / правый бампер");
            case "L2": return consolePane.trText("L2 / левый триггер");
            case "R2": return consolePane.trText("R2 / правый триггер");
            case "L3": return consolePane.trText("L3 / нажать левый стик");
            case "R3": return consolePane.trText("R3 / нажать правый стик");
            case "Options": return "Options";
            case "Share": return "Share";
            case "Touchpad": return consolePane.trText("Тачпад");
            case "PS": return consolePane.trText("Кнопка PS");
            case "MIC": return consolePane.trText("Микрофон");
            case "Left Stick Right": return consolePane.trText("Левый аналог вправо");
            case "Left Stick Left": return consolePane.trText("Левый аналог влево");
            case "Left Stick Up": return consolePane.trText("Левый аналог вверх");
            case "Left Stick Down": return consolePane.trText("Левый аналог вниз");
            case "Left Stick X": return consolePane.trText("Левый аналог горизонталь");
            case "Left Stick Y": return consolePane.trText("Левый аналог вертикаль");
            case "Right Stick Right": return consolePane.trText("Правый аналог вправо");
            case "Right Stick Left": return consolePane.trText("Правый аналог влево");
            case "Right Stick Up": return consolePane.trText("Правый аналог вверх");
            case "Right Stick Down": return consolePane.trText("Правый аналог вниз");
            case "Right Stick X": return consolePane.trText("Правый аналог горизонталь");
            case "Right Stick Y": return consolePane.trText("Правый аналог вертикаль");
            default: return name;
            }
        }

        RowLayout { anchors.fill: parent; anchors.leftMargin: 14; anchors.rightMargin: 14; anchors.topMargin: 10; anchors.bottomMargin: 10; spacing: 14
            Image {
                Layout.preferredWidth: 64
                Layout.preferredHeight: 48
                source: keyRow.controllerIconSource(keyRow.actionTitle)
                fillMode: Image.PreserveAspectFit
                smooth: true
                mipmap: false
                asynchronous: false
                visible: source.toString().length > 0
            }
            Rectangle {
                Layout.preferredWidth: 64
                Layout.preferredHeight: 48
                visible: keyRow.controllerIconSource(keyRow.actionTitle).length === 0
                radius: 16
                color: "#111a2d"
                border.width: 1
                border.color: "#243451"
                Label { anchors.centerIn: parent; text: keyRow.actionTitle; color: "#eaf0ff"; font.family: consolePane.fontUi; font.pixelSize: 11; font.weight: Font.DemiBold; elide: Text.ElideRight }
            }
            Label {
                Layout.fillWidth: true
                text: keyRow.controllerLabel(keyRow.actionTitle)
                color: "#eaf0ff"
                font.family: consolePane.fontUi
                font.pixelSize: 14
                font.weight: Font.DemiBold
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }
            SoftButton {
                Layout.preferredWidth: 180
                text: keyRow.keyName && keyRow.keyName.length > 0 ? keyRow.keyName : consolePane.trText("Назначить")
                onClicked: keyCaptureDialog.show({ value: keyRow.buttonValue, callback: function(name) { keyRow.keyName = name } })
            }
        }
    }

    component StatCard: Rectangle {
        property string title: ""
        property string value: ""
        property string note: ""
        property color valueColor: "#eaf0ff"
        Layout.fillWidth: true
        Layout.preferredHeight: 92
        Layout.maximumHeight: 92
        radius: 18
        color: "#0b0f1b"
        border.width: 1
        border.color: consolePane.cardBorder
        ColumnLayout {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            anchors.topMargin: 12
            anchors.bottomMargin: 10
            spacing: 3
            Label { text: title; color: "#8c9ab8"; font.family: consolePane.fontUi; font.pixelSize: 12; font.weight: Font.Medium }
            Label { Layout.fillWidth: true; Layout.preferredHeight: 31; text: value; color: valueColor; font.family: consolePane.fontUi; font.pixelSize: 24; font.weight: Font.DemiBold; elide: Text.ElideRight; verticalAlignment: Text.AlignVCenter }
            Label { Layout.fillWidth: true; text: note; color: "#77839d"; font.family: consolePane.fontUi; font.pixelSize: 11; elide: Text.ElideRight }
        }
    }

    component NeonButton: Button {
        id: neonButton
        focusPolicy: Qt.NoFocus
        implicitHeight: 44
        leftPadding: 18
        rightPadding: 18
        background: Rectangle {
            radius: 16
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: consolePane.neonCyan }
                GradientStop { position: 1.0; color: consolePane.neonBlue }
            }
            // Keep resize/windowed mode responsive: per-button MultiEffect shadows
            // force offscreen render passes and become very expensive while the
            // whole window is being resized on 4K displays.
            layer.enabled: false
        }
        contentItem: Text {
            text: neonButton.text
            color: "#04111c"
            font.family: consolePane.fontUi
            font.pixelSize: 14
            font.weight: Font.DemiBold
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    component SoftButton: Button {
        id: softButton
        focusPolicy: Qt.NoFocus
        implicitHeight: 44
        leftPadding: 18
        rightPadding: 18
        background: Rectangle { radius: 16; color: softButton.hovered ? "#151b2b" : "#0f1524"; border.color: consolePane.cardBorder }
        contentItem: Text { text: softButton.text; color: "#dce6ff"; font.family: consolePane.fontUi; font.pixelSize: 14; font.weight: Font.DemiBold; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
    }

    component QuickActionCard: Rectangle {
        id: quickAction
        property string title: ""
        property string subtitle: ""
        property color accent: consolePane.neonCyan
        signal clicked()
        Layout.fillWidth: true
        Layout.preferredHeight: 60
        Layout.minimumHeight: 60
        Layout.maximumHeight: 60
        radius: 16
        clip: true
        color: actionArea.containsMouse ? "#121a2c" : "#0f1524"
        border.color: consolePane.cardBorder
        Rectangle { anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 3; radius: 2; color: quickAction.accent; opacity: 0.9 }
        ColumnLayout { anchors.fill: parent; anchors.leftMargin: 14; anchors.rightMargin: 10; anchors.topMargin: 8; anchors.bottomMargin: 8; spacing: 0
            Label { Layout.fillWidth: true; Layout.preferredHeight: 25; text: quickAction.title; color: "#edf4ff"; font.family: consolePane.fontUi; font.pixelSize: 13; font.weight: Font.DemiBold; elide: Text.ElideRight; verticalAlignment: Text.AlignVCenter }
            Label { Layout.fillWidth: true; Layout.preferredHeight: 19; text: quickAction.subtitle; color: quickAction.accent; font.family: consolePane.fontUi; font.pixelSize: 11; font.weight: Font.DemiBold; elide: Text.ElideRight; verticalAlignment: Text.AlignVCenter }
        }
        MouseArea { id: actionArea; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: quickAction.clicked() }
    }

    component PosterCornerCutters: Shape {
        id: cutters
        property real r: 24
        property color fill: "#05070d"
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer

        ShapePath { fillColor: cutters.fill; strokeWidth: 0; startX: 0; startY: 0
            PathLine { x: cutters.r; y: 0 }
            PathArc { x: 0; y: cutters.r; radiusX: cutters.r; radiusY: cutters.r; direction: PathArc.Counterclockwise }
            PathLine { x: 0; y: 0 }
        }
        ShapePath { fillColor: cutters.fill; strokeWidth: 0; startX: cutters.width; startY: 0
            PathLine { x: cutters.width - cutters.r; y: 0 }
            PathArc { x: cutters.width; y: cutters.r; radiusX: cutters.r; radiusY: cutters.r; direction: PathArc.Clockwise }
            PathLine { x: cutters.width; y: 0 }
        }
        ShapePath { fillColor: cutters.fill; strokeWidth: 0; startX: 0; startY: cutters.height
            PathLine { x: cutters.r; y: cutters.height }
            PathArc { x: 0; y: cutters.height - cutters.r; radiusX: cutters.r; radiusY: cutters.r; direction: PathArc.Clockwise }
            PathLine { x: 0; y: cutters.height }
        }
        ShapePath { fillColor: cutters.fill; strokeWidth: 0; startX: cutters.width; startY: cutters.height
            PathLine { x: cutters.width - cutters.r; y: cutters.height }
            PathArc { x: cutters.width; y: cutters.height - cutters.r; radiusX: cutters.r; radiusY: cutters.r; direction: PathArc.Counterclockwise }
            PathLine { x: cutters.width; y: cutters.height }
        }
    }

    component GameCard: Rectangle {
        id: gameCard
        property string title: ""
        property string subtitle: ""
        property string image: ""
        Layout.fillWidth: false
        Layout.fillHeight: false
        radius: 24
        color: "#0b0f1b"
        border.width: 0
        // Rectangle.clip cuts a square box, not a rounded path. Mask only the
        // poster and bottom scrim; no shadows/blur, so resize stays lighter.
        clip: false
        scale: gameHover.hovered ? 1.015 : 1.0
        Behavior on scale { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }

        Rectangle {
            anchors.fill: parent
            radius: gameCard.radius
            visible: gameCard.image.length === 0 || gameCardImageSource.status === Image.Error
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0; color: "#1b315c" }
                GradientStop { position: 0.55; color: "#101827" }
                GradientStop { position: 1; color: "#070b14" }
            }
            layer.enabled: false
        }

        Image {
            id: gameCardImageSource
            anchors.fill: parent
            source: gameCard.image
            fillMode: Image.Stretch
            asynchronous: true
            cache: true
            smooth: true
            mipmap: false
            opacity: gameCard.image.length > 0 && status !== Image.Error ? 1 : 0
            layer.enabled: false
        }

        Image {
            anchors.centerIn: parent
            width: 54
            height: 54
            source: "qrc:/icons/cp-gamepad.svg"
            opacity: gameCardImageSource.status === Image.Error || gameCard.image.length === 0 ? 0.34 : 0
            fillMode: Image.PreserveAspectFit
        }

        Rectangle {
            id: gameCardScrimSource
            anchors.fill: parent
            radius: gameCard.radius
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.0; color: gameHover.hovered ? "#11000000" : "#00000000" }
                GradientStop { position: 0.46; color: "#22000000" }
                GradientStop { position: 0.78; color: "#aa03060f" }
                GradientStop { position: 1.0; color: "#f0040710" }
            }
            layer.enabled: false
        }

        PosterCornerCutters { r: gameCard.radius; fill: "#05070d" }

        ColumnLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.leftMargin: 14
            anchors.rightMargin: 14
            anchors.bottomMargin: 14
            spacing: 2
            Label { Layout.fillWidth: true; text: gameCard.title; color: "#ffffff"; font.family: consolePane.fontUi; font.pixelSize: Math.max(13, Math.min(16, Math.floor(gameCard.width / 12))); font.weight: Font.DemiBold; elide: Text.ElideRight; maximumLineCount: 1 }
            Label { Layout.fillWidth: true; text: gameCard.subtitle; color: "#d3dcf2"; font.family: consolePane.fontUi; font.pixelSize: Math.max(10, Math.min(12, Math.floor(gameCard.width / 17))); elide: Text.ElideRight; maximumLineCount: 1 }
        }

        Rectangle {
            anchors.fill: parent
            radius: gameCard.radius
            color: "transparent"
            border.width: gameHover.hovered ? 1 : 0
            border.color: "#55ffffff"
        }

        HoverHandler { id: gameHover }
        TapHandler { onTapped: consolePane.openPlayStart() }
    }

    component LibraryGameCard: Rectangle {
        id: libraryGameCard
        property string title: ""
        property string subtitle: ""
        property string image: ""
        property string status: ""
        signal clicked()
        radius: 24
        color: "#0b0f1b"
        border.width: 0
        // Plain clip shows square image corners on Windows/4K; use a rounded
        // mask for the poster/scrim only, without the old shadow effects.
        clip: false

        Rectangle {
            id: posterFallback
            anchors.fill: parent
            radius: libraryGameCard.radius
            visible: libraryGameCard.image.length === 0 || posterImageSource.status === Image.Error
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0; color: "#1a2742" }
                GradientStop { position: 0.56; color: "#101827" }
                GradientStop { position: 1; color: "#070b14" }
            }
            layer.enabled: false
        }

        Image {
            id: posterImageSource
            anchors.fill: parent
            source: libraryGameCard.image
            fillMode: Image.Stretch
            asynchronous: true
            cache: true
            smooth: true
            mipmap: false
            opacity: libraryGameCard.image.length > 0 && status !== Image.Error ? 1.0 : 0
            layer.enabled: false
        }

        Image {
            anchors.centerIn: parent
            width: 56
            height: 56
            source: "qrc:/icons/cp-gamepad.svg"
            opacity: libraryGameCard.image.length === 0 || posterImageSource.status === Image.Error ? 0.36 : 0
            fillMode: Image.PreserveAspectFit
        }

        Rectangle {
            id: titleScrimSource
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: Math.max(72, Math.floor(parent.height * 0.28))
            radius: 0
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.0; color: "#00000000" }
                GradientStop { position: 0.44; color: "#aa02050c" }
                GradientStop { position: 1.0; color: "#f0040710" }
            }
            layer.enabled: false
        }

        PosterCornerCutters { r: libraryGameCard.radius; fill: "#05070d" }

        ColumnLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            anchors.bottomMargin: 12
            spacing: 2
            Label { Layout.fillWidth: true; text: libraryGameCard.title; color: "#ffffff"; font.family: consolePane.fontDisplay; font.pixelSize: Math.max(12, Math.min(15, Math.floor(libraryGameCard.width / 11))); font.weight: Font.DemiBold; elide: Text.ElideRight; maximumLineCount: 1 }
            Label { Layout.fillWidth: true; text: libraryGameCard.subtitle; visible: libraryGameCard.subtitle.length > 0; color: "#d3dcf2"; font.family: consolePane.fontUi; font.pixelSize: Math.max(9, Math.min(11, Math.floor(libraryGameCard.width / 15))); elide: Text.ElideRight; maximumLineCount: 1 }
        }

        Rectangle {
            anchors.fill: parent
            radius: libraryGameCard.radius
            color: "transparent"
            border.width: 1
            border.color: "#33ffffff"
        }

        TapHandler { onTapped: libraryGameCard.clicked() }
    }

    component FilterChip: Button {
        id: filterChip
        property bool active: false
        focusPolicy: Qt.NoFocus
        implicitHeight: 36
        leftPadding: 14
        rightPadding: 14
        background: Rectangle { radius: 13; color: filterChip.active ? "#182137" : (filterChip.hovered ? "#121827" : "#0f1524"); border.color: filterChip.active ? "#668aa5ff" : consolePane.cardBorder }
        contentItem: Text { text: filterChip.text; color: filterChip.active ? "#ffffff" : "#9aa7c2"; font.family: consolePane.fontUi; font.pixelSize: 12; font.weight: filterChip.active ? Font.DemiBold : Font.Medium; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
    }

    component LaunchStepCard: Rectangle {
        id: launchStepCard
        property string title: ""
        property string value: ""
        property bool active: false
        property bool done: false
        Layout.fillWidth: true
        Layout.minimumWidth: 150
        Layout.preferredHeight: 72
        radius: 18
        color: done ? "#12261d" : (active ? "#121a2c" : "#0d1320")
        border.width: 1
        border.color: done ? "#3355f0a5" : (active ? "#33466f" : "#1b2438")
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 14
            anchors.rightMargin: 14
            anchors.topMargin: 10
            anchors.bottomMargin: 10
            spacing: 10
            Rectangle {
                Layout.preferredWidth: 12
                Layout.preferredHeight: 12
                radius: 6
                color: launchStepCard.done ? "#55f0a5" : (launchStepCard.active ? consolePane.neonCyan : "#3a465d")
            }
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 1
                Label {
                    Layout.fillWidth: true
                    text: launchStepCard.title
                    color: launchStepCard.done ? "#55f0a5" : (launchStepCard.active ? "#dce6ff" : "#7d879b")
                    font.family: consolePane.fontUi
                    font.pixelSize: 12
                    font.weight: Font.DemiBold
                    elide: Text.ElideRight
                }
                Label {
                    Layout.fillWidth: true
                    text: launchStepCard.value
                    color: launchStepCard.active || launchStepCard.done ? "#f4f7ff" : "#8c9ab8"
                    font.family: consolePane.fontUi
                    font.pixelSize: 15
                    font.weight: Font.DemiBold
                    elide: Text.ElideRight
                }
            }
        }
    }

    component PackageCard: Rectangle {
        property string packageId: ""
        property int minutes: 0
        property int amount: 0
        property string hours: ""
        property string price: ""
        property string rate: ""
        property string badge: ""
        Layout.fillWidth: true
        Layout.preferredHeight: 220
        Layout.minimumHeight: 200
        radius: 22
        color: "#0b0f1b"
        border.color: consolePane.cardBorder
        ColumnLayout { anchors.fill: parent; anchors.margins: 20; spacing: 10
            RowLayout { Layout.fillWidth: true; Label { text: badge; color: "#19e9ff"; font.pixelSize: 13; font.weight: Font.DemiBold } Item { Layout.fillWidth: true } }
            Label { text: hours; color: "#eaf0ff"; font.pixelSize: 29; font.weight: Font.Bold }
            Label { text: price; color: "#eaf0ff"; font.pixelSize: 20; font.weight: Font.DemiBold }
            Label { text: rate; color: "#828ca6"; font.pixelSize: 13 }
            Item { Layout.fillHeight: true }
            NeonButton { Layout.fillWidth: true; text: consolePane.trText("Купить"); onClicked: { consolePane.selectedPackageId = packageId; consolePane.selectedPackageMinutes = minutes; consolePane.selectedPackageAmount = amount; consolePane.selectedPackageTitle = hours; consolePane.selectedPackagePrice = price; buyTimePopup.open() } }
        }
    }

    Item {
        id: beginGamePopup
        anchors.fill: parent
        z: 1000
        visible: false
        opacity: visible ? 1 : 0
        focus: visible

        function open() {
            visible = true
            forceActiveFocus()
        }

        function close() {
            visible = false
        }

        Keys.onEscapePressed: close()

        Rectangle {
            anchors.fill: parent
            color: "#aa020308"
            MouseArea { anchors.fill: parent; onClicked: beginGamePopup.close() }
        }

        Rectangle {
            id: startModalCard
            width: Math.min(520, Math.max(360, Math.min(consolePane.width - 48, consolePane.width * 0.34)))
            height: startModalContent.implicitHeight + 52
            anchors.centerIn: parent
            radius: 26
            color: "#0b0f1b"
            border.width: 1
            border.color: "#33466f"
            clip: true

            Rectangle {
                anchors.fill: parent
                anchors.margins: 1
                radius: 25
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#141d32" }
                    GradientStop { position: 0.46; color: "#0b0f1b" }
                    GradientStop { position: 1.0; color: "#080b14" }
                }
                opacity: 0.78
            }

            MouseArea { anchors.fill: parent }

            ColumnLayout {
                id: startModalContent
                anchors.fill: parent
                anchors.margins: 26
                spacing: 18

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 14
                    Rectangle {
                        Layout.preferredWidth: 48
                        Layout.preferredHeight: 48
                        radius: 16
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "#19e9ff" }
                            GradientStop { position: 1.0; color: "#2e7bff" }
                        }
                        Label { anchors.centerIn: parent; text: "▶"; color: "#ffffff"; font.pixelSize: 20; font.weight: Font.DemiBold }
                    }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        Label { Layout.fillWidth: true; text: consolePane.trText("Играть"); color: "#f4f7ff"; font.family: consolePane.fontDisplay; font.pixelSize: 24; font.weight: Font.DemiBold; elide: Text.ElideRight }
                        Label { Layout.fillWidth: true; text: consolePane.trText("CloudPlay подготовит PS5 для игры"); color: "#8c9ab8"; font.family: consolePane.fontUi; font.pixelSize: 13; elide: Text.ElideRight }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 94
                    radius: 20
                    color: "#0f1524"
                    border.width: 1
                    border.color: "#1f2a46"
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 6
                        Label { Layout.fillWidth: true; text: consolePane.trText("Как начнём"); color: "#dce6ff"; font.family: consolePane.fontUi; font.pixelSize: 13; font.weight: Font.DemiBold }
                        Label { Layout.fillWidth: true; text: consolePane.trText("1. Проверим вход · 2. Подготовим PS5 · 3. Подключим игру"); color: "#b7c2dc"; font.family: consolePane.fontUi; font.pixelSize: 13; wrapMode: Text.WordWrap }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10
                    Rectangle { Layout.preferredWidth: 8; Layout.preferredHeight: 8; radius: 4; color: "#36e08a" }
                    Label { Layout.fillWidth: true; text: consolePane.trText("Время начнёт списываться после подключения к игре."); color: "#b8f5cf"; font.family: consolePane.fontUi; font.pixelSize: 12; wrapMode: Text.WordWrap }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.topMargin: 4
                    spacing: 12
                    SoftButton { Layout.fillWidth: true; text: consolePane.trText("Отмена"); onClicked: beginGamePopup.close() }
                    NeonButton { Layout.fillWidth: true; text: consolePane.trText("Играть"); onClicked: { beginGamePopup.close(); consolePane.runLaunchSequence() } }
                }
            }
        }
    }

    Item {
        id: preferredBusyPopup
        anchors.fill: parent
        z: 1001
        visible: false
        focus: visible

        function open() {
            visible = true
            forceActiveFocus()
        }

        function close() {
            visible = false
        }

        Keys.onEscapePressed: close()

        Rectangle {
            anchors.fill: parent
            color: "#aa020308"
            MouseArea {
                anchors.fill: parent
                onClicked: preferredBusyPopup.close()
            }
        }

        Rectangle {
            width: Math.min(560, Math.max(380, consolePane.width - 64))
            height: preferredBusyContent.implicitHeight + 52
            anchors.centerIn: parent
            radius: 26
            color: "#0b0f1b"
            border.width: 1
            border.color: "#5b345f"
            clip: true

            Rectangle {
                anchors.fill: parent
                anchors.margins: 1
                radius: 25
                opacity: 0.88
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#24142f" }
                    GradientStop { position: 0.55; color: "#0b0f1b" }
                    GradientStop { position: 1.0; color: "#080b14" }
                }
            }

            MouseArea { anchors.fill: parent }

            ColumnLayout {
                id: preferredBusyContent
                anchors.fill: parent
                anchors.margins: 26
                spacing: 16

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 14
                    Rectangle {
                        Layout.preferredWidth: 48
                        Layout.preferredHeight: 48
                        radius: 16
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "#ffb86b" }
                            GradientStop { position: 1.0; color: "#ff2e8b" }
                        }
                        Label {
                            anchors.centerIn: parent
                            text: "PS5"
                            color: "#ffffff"
                            font.pixelSize: 13
                            font.weight: Font.Bold
                        }
                    }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        Label {
                            Layout.fillWidth: true
                            text: consolePane.trText("Прошлая PS5 занята")
                            color: "#f4f7ff"
                            font.family: consolePane.fontDisplay
                            font.pixelSize: 24
                            font.weight: Font.DemiBold
                            elide: Text.ElideRight
                        }
                        Label {
                            Layout.fillWidth: true
                            text: consolePane.trText("Можно играть на другой или ждать именно прошлую консоль")
                            color: "#8c9ab8"
                            font.family: consolePane.fontUi
                            font.pixelSize: 13
                            wrapMode: Text.WordWrap
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: preferredBusyDetails.implicitHeight + 28
                    radius: 20
                    color: "#0f1524"
                    border.color: "#2a3046"
                    ColumnLayout {
                        id: preferredBusyDetails
                        anchors.fill: parent
                        anchors.margins: 14
                        spacing: 6
                        Label {
                            Layout.fillWidth: true
                            text: consolePane.preferredBusyMessage
                            color: "#dce6ff"
                            font.family: consolePane.fontUi
                            font.pixelSize: 14
                            wrapMode: Text.WordWrap
                        }
                        Label {
                            visible: consolePane.preferredBusySlot.length > 0
                            Layout.fillWidth: true
                            text: consolePane.trText("Прошлая консоль: ") + consolePane.preferredBusySlot
                            color: "#9aa7c4"
                            font.pixelSize: 13
                        }
                        Label {
                            visible: consolePane.preferredBusyUser.length > 0
                            Layout.fillWidth: true
                            text: consolePane.trText("Сейчас играет: ") + consolePane.preferredBusyUser
                            color: "#ffb86b"
                            font.pixelSize: 13
                        }
                        Label {
                            visible: consolePane.preferredBusyAlternate.length > 0
                            Layout.fillWidth: true
                            text: consolePane.trText("Свободна другая: ") + consolePane.preferredBusyAlternate
                            color: "#36e08a"
                            font.pixelSize: 13
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12
                    SoftButton {
                        Layout.fillWidth: true
                        text: consolePane.trText("Отмена")
                        onClicked: preferredBusyPopup.close()
                    }
                    SoftButton {
                        Layout.fillWidth: true
                        text: consolePane.trText("Ждать прошлую PS5")
                        onClicked: {
                            preferredBusyPopup.close()
                            consolePane.currentPage = "queue"
                            consolePane.runLaunchSequence("wait_preferred")
                        }
                    }
                    NeonButton {
                        Layout.fillWidth: true
                        text: consolePane.trText("Играть на другой")
                        onClicked: {
                            preferredBusyPopup.close()
                            consolePane.runLaunchSequence("play_other")
                        }
                    }
                }
            }
        }
    }

    Item {
        id: gameDetailsPopup
        anchors.fill: parent
        z: 1001
        visible: false
        opacity: visible ? 1 : 0
        focus: visible
        function open() { visible = true; forceActiveFocus() }
        function close() { visible = false }
        Keys.onEscapePressed: close()
        Rectangle { anchors.fill: parent; color: "#aa020308"; MouseArea { anchors.fill: parent; onClicked: gameDetailsPopup.close() } }
        Rectangle {
            width: Math.min(560, Math.max(380, consolePane.width - 48))
            height: gameDetailsContent.implicitHeight + 52
            anchors.centerIn: parent
            radius: 26
            color: "#0b0f1b"
            border.width: 1
            border.color: "#33466f"
            clip: true
            Rectangle {
                anchors.fill: parent
                anchors.margins: 1
                radius: 25
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#141d32" }
                    GradientStop { position: 0.48; color: "#0b0f1b" }
                    GradientStop { position: 1.0; color: "#080b14" }
                }
                opacity: 0.82
            }
            MouseArea { anchors.fill: parent }
            RowLayout {
                id: gameDetailsContent
                anchors.fill: parent
                anchors.margins: 26
                spacing: 18
                Rectangle {
                    Layout.preferredWidth: 150
                    Layout.preferredHeight: 214
                    radius: 22
                    clip: true
                    color: "#101827"
                    Image { anchors.fill: parent; source: consolePane.selectedGameImage; fillMode: Image.Stretch; asynchronous: true; smooth: true }
                    Rectangle { anchors.fill: parent; color: "transparent"; border.color: "#33ffffff"; radius: 22 }
                }
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 214
                    spacing: 10
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10
                        Rectangle { Layout.preferredWidth: 10; Layout.preferredHeight: 10; radius: 5; color: consolePane.neonCyan }
                        Label { Layout.fillWidth: true; text: consolePane.trText("Игра"); color: "#8c9ab8"; font.family: consolePane.fontUi; font.pixelSize: 13; elide: Text.ElideRight }
                    }
                    Label { Layout.fillWidth: true; text: consolePane.selectedGameTitle; color: "#f4f7ff"; font.family: consolePane.fontDisplay; font.pixelSize: 24; font.weight: Font.DemiBold; wrapMode: Text.WordWrap }
                    Label { Layout.fillWidth: true; text: consolePane.selectedGameGenre; color: consolePane.neonCyan; font.family: consolePane.fontMono; font.pixelSize: 12; elide: Text.ElideRight }
                    Label { Layout.fillWidth: true; text: consolePane.selectedGameStatus; color: "#b7c2dc"; font.family: consolePane.fontUi; font.pixelSize: 13; wrapMode: Text.WordWrap }
                    Label { Layout.fillWidth: true; text: consolePane.trText("Нажмите «Играть» — CloudPlay подготовит PS5 и подключит вас к игре."); color: "#8c9ab8"; font.family: consolePane.fontUi; font.pixelSize: 13; wrapMode: Text.WordWrap }
                    Item { Layout.fillHeight: true }
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12
                        SoftButton { Layout.fillWidth: true; text: consolePane.trText("Закрыть"); onClicked: gameDetailsPopup.close() }
                        NeonButton { Layout.fillWidth: true; text: consolePane.trText("Играть"); onClicked: consolePane.launchSelectedGame() }
                    }
                }
            }
        }
    }

    Item {
        id: topupPopup
        anchors.fill: parent
        z: 1001
        visible: false
        opacity: visible ? 1 : 0
        focus: visible
        function open() { visible = true; forceActiveFocus(); topupAmountField.forceActiveFocus(Qt.TabFocusReason) }
        function close() { visible = false }
        function submitCustomAmount() {
            var amount = Math.round(consolePane.numericMoney(topupAmountField.text))
            if (amount <= 0) {
                consolePane.paymentStatusText = consolePane.trText("Введите сумму пополнения.")
                return
            }
            consolePane.createClickPayment(amount, "", 0)
        }
        Keys.onEscapePressed: close()
        Rectangle { anchors.fill: parent; color: "#aa020308"; MouseArea { anchors.fill: parent; onClicked: topupPopup.close() } }
        Rectangle {
            width: Math.min(460, Math.max(360, consolePane.width - 48))
            height: topupContent.implicitHeight + 52
            anchors.centerIn: parent
            radius: 26
            color: "#0b0f1b"
            border.width: 1
            border.color: "#33466f"
            clip: true
            Rectangle { anchors.fill: parent; anchors.margins: 1; radius: 25; gradient: Gradient { GradientStop { position: 0.0; color: "#141d32" } GradientStop { position: 0.52; color: "#0b0f1b" } GradientStop { position: 1.0; color: "#080b14" } } opacity: 0.82 }
            MouseArea { anchors.fill: parent }
            ColumnLayout {
                id: topupContent
                anchors.fill: parent
                anchors.margins: 26
                spacing: 16
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 14
                    Rectangle { Layout.preferredWidth: 48; Layout.preferredHeight: 48; radius: 16; gradient: Gradient { GradientStop { position: 0.0; color: "#19e9ff" } GradientStop { position: 1.0; color: "#2e7bff" } } Label { anchors.centerIn: parent; text: "+"; color: "#ffffff"; font.pixelSize: 26; font.weight: Font.DemiBold } }
                    ColumnLayout { Layout.fillWidth: true; spacing: 2; Label { Layout.fillWidth: true; text: consolePane.trText("Пополнение"); color: "#f4f7ff"; font.family: consolePane.fontDisplay; font.pixelSize: 24; font.weight: Font.DemiBold; elide: Text.ElideRight } Label { Layout.fillWidth: true; text: consolePane.trText("Выберите готовую сумму или введите свою"); color: "#8c9ab8"; font.family: consolePane.fontUi; font.pixelSize: 13; elide: Text.ElideRight } }
                }
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10
                    SoftButton { Layout.fillWidth: true; text: "50 000 UZS"; onClicked: consolePane.createClickPayment(50000, "", 0) }
                    SoftButton { Layout.fillWidth: true; text: "100 000 UZS"; onClicked: consolePane.createClickPayment(100000, "", 0) }
                    SoftButton { Layout.fillWidth: true; text: "200 000 UZS"; onClicked: consolePane.createClickPayment(200000, "", 0) }
                }
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 74
                    radius: 18
                    color: "#0f1524"
                    border.width: 1
                    border.color: "#1f2a46"
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 10
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 46
                            radius: 14
                            color: "#0b0f1b"
                            border.color: topupAmountField.activeFocus ? consolePane.neonCyan : "#22304b"
                            border.width: 1
                            clip: true

                            Label {
                                anchors.left: parent.left
                                anchors.leftMargin: 16
                                anchors.verticalCenter: parent.verticalCenter
                                text: consolePane.trText("Другая сумма")
                                color: "#6f7b94"
                                font.family: consolePane.fontUi
                                font.pixelSize: 14
                                visible: topupAmountField.text.length === 0
                            }

                            TextInput {
                                id: topupAmountField
                                anchors.fill: parent
                                anchors.leftMargin: 16
                                anchors.rightMargin: 12
                                text: ""
                                inputMethodHints: Qt.ImhDigitsOnly
                                validator: IntValidator { bottom: 1000; top: 50000000 }
                                selectByMouse: true
                                color: "#f4f7ff"
                                selectionColor: consolePane.neonCyan
                                selectedTextColor: "#07111f"
                                font.family: consolePane.fontMono
                                font.pixelSize: 17
                                verticalAlignment: TextInput.AlignVCenter
                                clip: true
                                Keys.onReturnPressed: topupPopup.submitCustomAmount()
                                Keys.onEnterPressed: topupPopup.submitCustomAmount()
                            }
                        }
                        Label { text: "UZS"; color: "#8c9ab8"; font.family: consolePane.fontMono; font.pixelSize: 13 }
                        NeonButton { Layout.preferredWidth: 128; Layout.preferredHeight: 44; text: consolePane.trText("Пополнить"); onClicked: topupPopup.submitCustomAmount() }
                    }
                }
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 64
                    radius: 18
                    color: "#0f1524"
                    border.width: 1
                    border.color: "#1f2a46"
                    Label { anchors.fill: parent; anchors.margins: 14; text: consolePane.paymentStatusText.length > 0 ? consolePane.paymentStatusText : consolePane.trText("После выбора суммы откроется страница оплаты."); color: "#9aa7c2"; font.family: consolePane.fontUi; font.pixelSize: 12; wrapMode: Text.WordWrap; verticalAlignment: Text.AlignVCenter }
                }
                SoftButton { Layout.fillWidth: true; text: consolePane.trText("Закрыть"); onClicked: topupPopup.close() }
            }
        }
    }

    Item {
        id: buyTimePopup
        anchors.fill: parent
        z: 1001
        visible: false
        opacity: visible ? 1 : 0
        focus: visible
        function open() { visible = true; forceActiveFocus() }
        function close() { visible = false }
        Keys.onEscapePressed: close()
        Rectangle { anchors.fill: parent; color: "#aa020308"; MouseArea { anchors.fill: parent; onClicked: buyTimePopup.close() } }
        Rectangle {
            width: Math.min(430, Math.max(340, consolePane.width - 48))
            height: buyTimeContent.implicitHeight + 52
            anchors.centerIn: parent
            radius: 26
            color: "#0b0f1b"
            border.width: 1
            border.color: "#33466f"
            clip: true
            Rectangle { anchors.fill: parent; anchors.margins: 1; radius: 25; gradient: Gradient { GradientStop { position: 0.0; color: "#141d32" } GradientStop { position: 0.52; color: "#0b0f1b" } GradientStop { position: 1.0; color: "#080b14" } } opacity: 0.82 }
            MouseArea { anchors.fill: parent }
            ColumnLayout {
                id: buyTimeContent
                anchors.fill: parent
                anchors.margins: 26
                spacing: 16
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 14
                    Rectangle { Layout.preferredWidth: 48; Layout.preferredHeight: 48; radius: 16; gradient: Gradient { GradientStop { position: 0.0; color: consolePane.neonPink } GradientStop { position: 1.0; color: "#2e7bff" } } Label { anchors.centerIn: parent; text: "⏱"; color: "#ffffff"; font.pixelSize: 21 } }
                    ColumnLayout { Layout.fillWidth: true; spacing: 2; Label { Layout.fillWidth: true; text: consolePane.trText("Купить игровое время"); color: "#f4f7ff"; font.family: consolePane.fontDisplay; font.pixelSize: 24; font.weight: Font.DemiBold; elide: Text.ElideRight } Label { Layout.fillWidth: true; text: consolePane.trText("Подтвердите покупку"); color: "#8c9ab8"; font.family: consolePane.fontUi; font.pixelSize: 13; elide: Text.ElideRight } }
                }
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 78
                    radius: 18
                    color: "#0f1524"
                    border.width: 1
                    border.color: "#1f2a46"
                    ColumnLayout { anchors.fill: parent; anchors.margins: 14; spacing: 4; Label { Layout.fillWidth: true; text: consolePane.selectedPackageTitle; color: "#f4f7ff"; font.family: consolePane.fontDisplay; font.pixelSize: 20; font.weight: Font.DemiBold; elide: Text.ElideRight } Label { Layout.fillWidth: true; text: consolePane.selectedPackagePrice; color: consolePane.neonCyan; font.family: consolePane.fontMono; font.pixelSize: 13; elide: Text.ElideRight } }
                }
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12
                    SoftButton { Layout.fillWidth: true; text: consolePane.trText("Отмена"); onClicked: buyTimePopup.close() }
                    NeonButton { Layout.fillWidth: true; text: consolePane.trText("Купить"); onClicked: consolePane.buySelectedPackage() }
                }
            }
        }
    }
    Item {
        id: callCenterPopup
        anchors.fill: parent
        z: 1001
        visible: false
        opacity: visible ? 1 : 0
        focus: visible

        function open() {
            visible = true
            forceActiveFocus()
        }

        function close() {
            visible = false
        }

        Keys.onEscapePressed: close()

        Rectangle {
            anchors.fill: parent
            color: "#aa020308"
            MouseArea { anchors.fill: parent; onClicked: callCenterPopup.close() }
        }

        Rectangle {
            id: callCenterCard
            width: Math.min(430, Math.max(340, consolePane.width - 48))
            height: callCenterContent.implicitHeight + 52
            anchors.centerIn: parent
            radius: 24
            color: "#0b0f1b"
            border.width: 1
            border.color: "#33466f"
            clip: true

            Rectangle {
                anchors.fill: parent
                anchors.margins: 1
                radius: 23
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#141d32" }
                    GradientStop { position: 0.55; color: "#0b0f1b" }
                    GradientStop { position: 1.0; color: "#080b14" }
                }
                opacity: 0.82
            }

            MouseArea { anchors.fill: parent }

            ColumnLayout {
                id: callCenterContent
                anchors.fill: parent
                anchors.margins: 26
                spacing: 16

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 14
                    Rectangle {
                        Layout.preferredWidth: 48
                        Layout.preferredHeight: 48
                        radius: 16
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "#19e9ff" }
                            GradientStop { position: 1.0; color: "#2e7bff" }
                        }
                        Label { anchors.centerIn: parent; text: "📞"; color: "#ffffff"; font.pixelSize: 21 }
                    }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        Label { Layout.fillWidth: true; text: consolePane.trText("Позвонить"); color: "#f4f7ff"; font.family: consolePane.fontDisplay; font.pixelSize: 24; font.weight: Font.DemiBold; elide: Text.ElideRight }
                        Label { Layout.fillWidth: true; text: consolePane.trText("Свяжитесь с нами по телефону"); color: "#8c9ab8"; font.family: consolePane.fontUi; font.pixelSize: 13; elide: Text.ElideRight }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 78
                    radius: 18
                    color: "#0f1524"
                    border.width: 1
                    border.color: "#1f2a46"
                    Label {
                        anchors.centerIn: parent
                        text: "+998 71 205-05-01"
                        color: "#f4f7ff"
                        font.family: consolePane.fontDisplay
                        font.pixelSize: 23
                        font.weight: Font.DemiBold
                        horizontalAlignment: Text.AlignHCenter
                    }
                }

                SoftButton {
                    Layout.fillWidth: true
                    text: consolePane.trText("Закрыть")
                    onClicked: callCenterPopup.close()
                }
            }
        }
    }
    Item {
        id: supportPopup
        anchors.fill: parent
        z: 1001
        visible: false
        opacity: visible ? 1 : 0
        focus: visible
        function open() { visible = true; forceActiveFocus() }
        function close() { visible = false }
        Keys.onEscapePressed: close()
        Rectangle { anchors.fill: parent; color: "#aa020308"; MouseArea { anchors.fill: parent; onClicked: supportPopup.close() } }
        Rectangle {
            width: Math.min(500, Math.max(360, consolePane.width - 48))
            height: supportContent.implicitHeight + 52
            anchors.centerIn: parent
            radius: 26
            color: "#0b0f1b"
            border.width: 1
            border.color: "#33466f"
            clip: true
            Rectangle { anchors.fill: parent; anchors.margins: 1; radius: 25; gradient: Gradient { GradientStop { position: 0.0; color: "#141d32" } GradientStop { position: 0.52; color: "#0b0f1b" } GradientStop { position: 1.0; color: "#080b14" } } opacity: 0.82 }
            MouseArea { anchors.fill: parent }
            ColumnLayout {
                id: supportContent
                anchors.fill: parent
                anchors.margins: 26
                spacing: 16
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 14
                    Rectangle { Layout.preferredWidth: 48; Layout.preferredHeight: 48; radius: 16; gradient: Gradient { GradientStop { position: 0.0; color: "#19e9ff" } GradientStop { position: 1.0; color: "#2e7bff" } } Image { anchors.centerIn: parent; width: 24; height: 24; source: "qrc:/icons/cp-support.svg"; fillMode: Image.PreserveAspectFit } }
                    ColumnLayout { Layout.fillWidth: true; spacing: 2; Label { Layout.fillWidth: true; text: consolePane.trText("Поддержка"); color: "#f4f7ff"; font.family: consolePane.fontDisplay; font.pixelSize: 24; font.weight: Font.DemiBold; elide: Text.ElideRight } Label { Layout.fillWidth: true; text: consolePane.trText("Напишите нам в Telegram"); color: "#8c9ab8"; font.family: consolePane.fontUi; font.pixelSize: 13; elide: Text.ElideRight } }
                }
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 128
                    radius: 18
                    color: "#0f1524"
                    border.width: 1
                    border.color: "#1f2a46"
                    TextArea {
                        anchors.fill: parent
                        anchors.margins: 10
                        placeholderText: consolePane.trText("Опишите проблему")
                        text: consolePane.supportDraft
                        onTextChanged: consolePane.supportDraft = text
                        color: "#dce6ff"
                        placeholderTextColor: "#66718a"
                        background: Rectangle { color: "transparent" }
                        wrapMode: TextArea.Wrap
                    }
                }
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12
                    SoftButton { Layout.fillWidth: true; text: consolePane.trText("Закрыть"); onClicked: supportPopup.close() }
                    SoftButton { Layout.fillWidth: true; text: consolePane.trText("Позвонить"); onClicked: { supportPopup.close(); consolePane.callSupport() } }
                    NeonButton { Layout.fillWidth: true; text: consolePane.trText("Написать"); onClicked: consolePane.openSupportTelegram() }
                }
            }
        }
    }
}
