script_name('News Helper - Simple')
script_version('10.50')
script_description('Помощник для СМИ')
script_author('Alikhan')
local script_version = "10.50"
local script_url = "https://raw.githubusercontent.com/alikhandwawd/newstools/main/newstools.lua"
local update_available = false
local new_version = nil
local isDevMode = true
local memory = require 'memory'
local ev = require 'samp.events'
local vk = require 'vkeys'
local imgui = require 'mimgui'
local ffi = require 'ffi'
local new, str, sizeof = imgui.new, ffi.string, ffi.sizeof
local encoding = require 'encoding'
local render = require 'lib.samp.events' 
local requests = require("requests")
local fa = require 'fAwesome6'
encoding.default = 'CP1251'
local u8 = encoding.UTF8
if not ui then ui={} end
ui.fonts=ui.fonts or {}
local windows = {
	help = new.bool(),
	customAd = new.bool(),
	colorSettings = new.bool(),
	editor = new.bool(),
	editCategory = new.bool(),
	editBind = new.bool(),
	contextMenu = new.bool(false),
	addCustomBind = new.bool(),
	pro = new.bool(),
	mainSettings = new.bool(),
	checker = new.bool(false),
	rsWindow = new.bool(false),
	rsEditor = new.bool(false),
	rsInput = new.bool(false),
	playerMenu = new.bool(false)
}
local settings = {
	windowPos = {x = -1, y = -1},
	windowSize = {x = 400, y = 500},
	maxBufferSize = 60,
	searchDebounceDelay = 0.1,
	renderPriority = 1000,
	topMostFlags = imgui.WindowFlags.NoSavedSettings,
	configFolder = getWorkingDirectory() .. '\\config\\Newstools\\',
	bufferFilePath = getWorkingDirectory() .. '\\config\\Newstools\\NewsBuffer.json',
	bufferCategoryName = "Буфер объявлений",
	starJumpKey = vk.VK_TAB,
	silentMode = new.bool(false),
	themes = {
		current = "custom",
		list = {
			default = {
				name = "Стандартная",
				colors = {
					Text = {0.95, 0.95, 0.95, 1},
					WindowBg = {0.05, 0.05, 0.05, 0.94},
					PopupBg = {0.07, 0.07, 0.07, 0.94},
					Border = {0.25, 0.25, 0.25, 0.5},
					TitleBgActive = {0.15, 0.15, 0.15, 1},
					ScrollbarGrab = {0.3, 0.3, 0.3, 1},
					Button = {0.25, 0.25, 0.25, 0.6},
					FrameBgHovered = {0.15, 0.15, 0.15, 0.54},
					FrameBgActive = {0.12, 0.12, 0.12, 0.54},
					Tab = {0.15, 0.15, 0.15, 0.86},
					ResizeGrip = {0.25, 0.25, 0.25, 0.25},
					CategoryColor = {0.25, 0.25, 0.25, 1}
				}
			},
			blue = {
				name = "Синяя",
				colors = {
					Text = {0.82, 0.90, 1, 1},
					WindowBg = {0.10, 0.12, 0.18, 0.94},
					PopupBg = {0.08, 0.10, 0.16, 0.94},
					Border = {0.30, 0.40, 0.60, 0.50},
					TitleBgActive = {0.20, 0.30, 0.50, 1},
					ScrollbarGrab = {0.25, 0.35, 0.55, 1},
					Button = {0.20, 0.30, 0.50, 0.60},
					FrameBgHovered = {0.20, 0.30, 0.50, 0.54},
					FrameBgActive = {0.18, 0.27, 0.45, 0.54},
					Tab = {0.18, 0.28, 0.45, 0.86},
					ResizeGrip = {0.20, 0.30, 0.50, 0.25},
					CategoryColor = {0.20, 0.30, 0.50, 1}
				}
			},
			green = {
				name = "Зелёная",
				colors = {
					Text = {96/255, 227/255, 84/255, 235/255},
					WindowBg = {23/255, 31/255, 14/255, 240/255},
					PopupBg = {3/255, 48/255, 4/255, 218/255},
					Border = {2/255, 144/255, 70/255, 128/255},
					TitleBgActive = {8/255, 147/255, 0/255, 1},
					ScrollbarGrab = {135/255, 196/255, 35/255, 150/255},
					Button = {69/255, 147/255, 99/255, 79/255},
					FrameBgHovered = {90/255, 170/255, 120/255, 79/255},
					FrameBgActive = {75/255, 155/255, 105/255, 79/255},
					Tab = {69/255, 147/255, 99/255, 79/255},
					ResizeGrip = {29/255, 255/255, 0/255, 144/255},
					CategoryColor = {35/255, 85/255, 50/255, 1}
				}
			},
			orange = {
				name = "Оранжевая",
				colors = {
					Text = {1, 0.88, 0.80, 1},
					WindowBg = {0.1, 0.06, 0.02, 0.94},
					PopupBg = {0.12, 0.08, 0.03, 0.94},
					Border = {0.7, 0.4, 0.1, 0.5},
					TitleBgActive = {0.35, 0.22, 0.08, 1},
					ScrollbarGrab = {0.6, 0.3, 0.1, 1},
					Button = {0.6, 0.3, 0.1, 0.6},
					FrameBgHovered = {0.5, 0.25, 0.08, 0.54},
					FrameBgActive = {0.4, 0.2, 0.06, 0.54},
					Tab = {0.4, 0.2, 0.08, 0.86},
					ResizeGrip = {0.8, 0.4, 0.1, 0.25},
					CategoryColor = {0.6, 0.3, 0.1, 1}
				}
			},
			purple = {
				name = "Фиолетовая",
				colors = {
					Text = {0.9, 0.8, 1, 1},
					WindowBg = {0.08, 0.04, 0.12, 0.94},
					PopupBg = {0.1, 0.05, 0.15, 0.94},
					Border = {0.4, 0.2, 0.6, 0.5},
					TitleBgActive = {0.3, 0.15, 0.45, 1},
					ScrollbarGrab = {0.4, 0.2, 0.6, 1},
					Button = {0.4, 0.2, 0.6, 0.6},
					FrameBgHovered = {0.3, 0.15, 0.45, 0.54},
					FrameBgActive = {0.25, 0.12, 0.37, 0.54},
					Tab = {0.3, 0.15, 0.45, 0.86},
					ResizeGrip = {0.4, 0.2, 0.6, 0.25},
					CategoryColor = {0.4, 0.2, 0.6, 1}
				}
			},
			red = {
				name = "Красная",
				colors = {
					Text = {1, 0.82, 0.82, 1},
					WindowBg = {0.15, 0.05, 0.05, 0.94},
					PopupBg = {0.12, 0.04, 0.04, 0.94},
					Border = {0.60, 0.20, 0.20, 0.50},
					TitleBgActive = {0.40, 0.15, 0.15, 1},
					ScrollbarGrab = {0.50, 0.20, 0.20, 1},
					Button = {0.45, 0.18, 0.18, 0.60},
					FrameBgHovered = {0.50, 0.20, 0.20, 0.54},
					FrameBgActive = {0.40, 0.16, 0.16, 0.54},
					Tab = {0.40, 0.16, 0.16, 0.86},
					ResizeGrip = {0.45, 0.18, 0.18, 0.25},
					CategoryColor = {0.45, 0.18, 0.18, 1}
				}
			},
			custom = {
				name = "Своя",
				colors = {
					Text = {1, 1, 1, 1},
					WindowBg = {0.06, 0.06, 0.06, 0.94},
					PopupBg = {0.08, 0.08, 0.08, 0.94},
					Border = {0.43, 0.43, 0.50, 0.50},
					TitleBgActive = {0.16, 0.29, 0.48, 1},
					ScrollbarGrab = {0.31, 0.31, 0.31, 1},
					Button = {0.26, 0.59, 0.98, 0.40},
					FrameBgHovered = {0.26, 0.45, 0.68, 0.54},
					FrameBgActive = {0.20, 0.35, 0.58, 0.54},
					Tab = {0.18, 0.35, 0.58, 0.86},
					ResizeGrip = {0.26, 0.59, 0.98, 0.25},
					CategoryColor = {0.26, 0.59, 0.98, 1}
				}
			}
		}
	},
	colors = {
		background = imgui.new.float[3](0.07, 0.07, 0.07),
		categoryButtons = imgui.new.float[4](0.12, 0.12, 0.12, 1),
		itemButtons = imgui.new.float[4](0.20, 0.20, 0.20, 1),
		categoryColor = imgui.new.float[3](0.26, 0.59, 0.98)
	},
	checker = {
		enabled = new.bool(false),
		interval = new.int(10),
		textColor = imgui.new.float[4](0, 1, 1, 1),
		fontSize = new.int(15),
		pos = {x = 100, y = 100},
		firstSetup = true,
		timeout = 3.0,
		lastUpdate = 0,
		requestAttempts = 0,
		maxRequestAttempts = 3,
		waiting = false,
		lastUpdate = 0,
		requestTime = 0,
		lineHeight = 18,
		positioning = false,
		detectingRank = false
	},
	autologin = {
		enabled = new.bool(false),
		password = new.char[256](),
		pincode = new.char[256](),
		showPassword = new.bool(false),
		showPincode = new.bool(false),
		badPassword = false
	},
	customAd = {
		size = {x = 420, y = 240},
		tempSize = {x = 420, y = 240},
		isPreview = false,
		data = {
			authorId = nil,
			isAuthorOnline = false
		},
		originalText = nil,
		nextPos = nil,
		responseText = imgui.new.char[1024](),
		deleteMode = false,
		deleteReason = ""
	}
}
local ui = {
	contextMenu = {
		type = 0,
		pos = {x = 0, y = 0}
	},
	search = {
		input = imgui.new.char[128](),
		id = 1,
		tmp = {},
		debounceTimer = 0,
		lastQuery = "",
		cachedResults = {},
		resultsValid = false,
		scrollPos = 0,
		savedScrollY = 0,
		needRestoreScroll = false,
		restoreFrame = 0
	},
	hotkeys = {
		help = {vk.VK_DELETE},
		pro = {},
		edit = {vk.VK_Q},
		settings = {vk.VK_CONTROL, vk.VK_M},
		isSettingHelp = false,
		isSettingPro = false,
		isSettingEdit = false,
		isSettingCustom = false,
		currentIndex = 0,
		tempBuffer = {},
		helpHandled = false
	},
	fonts = {
		default = nil,
		bold = nil,
		checker = nil,
		custom = {}
	}
}
local editor = {
	history = {},
	historyIndex = 0,
	categoryStates = {},
	allExpanded = false,
	spoilerStates = {},
	edit = {
		categoryIndex = 0,
		bindCategoryIndex = 0,
		bindIndex = 0,
		categoryName = imgui.new.char[256](),
		bindName = imgui.new.char[256](),
		bindText = imgui.new.char[1024]()
	}
}
local efir = {
	type = nil,
	selectedType = nil,
	currentSubTab = 1,
	selectedSubTab = 1,
	counter = {},
	messages = {},
	messageDisplayNames = {},
	lastBallVariant = {},
	messageVariants = {},
	confirmFinishEfir = false,
	confirmEndEfir = false,
	mode = new.bool(false),
	pausedManually = false,
	questionId = 0,
	awaitingAnswer = false,
	currentQuestion = 0,
	lastSMSTime = 0,
	examples = {
		math = {},
		country = {},
		himia = {},
		zerkalo = {},
		annagramm = {},
		zagadki = {},
		sinonim = {}
	},
	answers = {
		math = {},
		country = {},
		himia = {},
		zerkalo = {},
		annagramm = {},
		zagadki = {},
		sinonim = {}
	},
	confirmAddBall = false,
	messageSizes = {
		msg1 = 512, msg2 = 512, msg3 = 512, msg4 = 512, msg5 = 512,
		msg6 = 512, msg7 = 256, msg8 = 512, msg5_2 = 512,
		first = 256, next = 256,
		ball1 = 256, ball2 = 256, ball5 = 256,
		winner1 = 512, winner2 = 512, winner3 = 512,
		end1 = 512, end2 = 512, end3 = 512, end4 = 512, end5 = 256,
		introduce = 512, introduce2 = 256,
		question1 = 256, question2 = 256, question3 = 256, question4 = 256
	},
	inputs = {
		money = imgui.new.char[32](),
		playerId = imgui.new.char[32](),
		reklamaText = imgui.new.char[1024](),
		math = {
			primer1 = imgui.new.char[256](),
			primer2 = imgui.new.char[256]()
		},
		country = {
			primer1 = imgui.new.char[256](),
			primer2 = imgui.new.char[256]()
		},
		himia = {
			primer1 = imgui.new.char[256](),
			primer2 = imgui.new.char[256]()
		},
		zerkalo = {
			primer1 = imgui.new.char[256](),
			primer2 = imgui.new.char[256]()
		},
		annagramm = {
			primer1 = imgui.new.char[256](),
			primer2 = imgui.new.char[256]()
		},
		zagadki = {
			primer1 = imgui.new.char[256](),
			primer2 = imgui.new.char[256]()
		},
		sinonim = {
			primer1 = imgui.new.char[256](),
			primer2 = imgui.new.char[256]()
		}
	},
	interview = {
		name = imgui.new.char[256](),
		rang = imgui.new.char[256]()
	},
	custom = {
		list = {},
		selected = nil,
		lines = {},
		newName = nil,
		newKey = nil,
		newLineName = nil,
		newLineText = nil,
		viewMode = 'bars',
		squareText = imgui.new.char[8192](),
		sendInterval = imgui.new.int(3000)
	},
	control = {
		paused = false,
		running = false,
		currentLine = 1,
		thread = nil,
		pauseHotkey = {vk.VK_K},
		isSettingPauseKey = false,
		shouldEnd = false
	},
	variableInput = {
		bindText = "",
		starCount = 0,
		inputs = {},
		isDialog = false,
		firstFrameSkipped = false,
		setFocusOnField = nil,
		scrollReset = false
	},
	intervals = {
		math = imgui.new.int(3000),
		country = imgui.new.int(3000),
		himia = imgui.new.int(3000),
		zerkalo = imgui.new.int(3000),
		annagramm = imgui.new.int(3000),
		zagadki = imgui.new.int(3000),
		sinonim = imgui.new.int(3000),
		inter = imgui.new.int(3000),
		reklama = imgui.new.int(3000),
		reklamaLines = imgui.new.int(3000),
		sobes = imgui.new.int(3000)
	},
	auto = {
		active = false,
		currentQuestion = 0,
		totalQuestions = 0,
		waitingForAnswer = false,
		correctAnswers = {},
		efirType = nil,
		updating = false,
		actionQueue = {},
		pausedDuringQuestions = false,
		pausedDuringStartup = false,
		finishedQuestions = false,
		pausedAnswer = nil
	}
}
local bulkInput = {
	active = false,
	mode = nil,
	efirType = nil,
	text = imgui.new.char[8192]()
}
local user = {
	nick = nil,
	rang = nil,
	org = nil,
	city = nil,
	gender = imgui.new.int(2),
	radioInt = imgui.new.int(2),
	waveTag = imgui.new.char[32]()
}
local flags = {
	focusResponse = false,
	lastEnterState = false,
	inputFieldActive = false,
	needUnfocus = false,
	deleteWasDown = false,
	updaterBusy = false,
	deletePending = false,
	checkDone = false,
	needScrollToBottom = false,
	autoBufferEnabled = new.bool(true),
	autospawnEnabled = new.bool(false),
	updateCheckDone = false,
	focusLineIndex = nil,
	draggingLineIndex = nil,
	dragStartY = nil,
	dragOffsetY = nil,
	movingLineIndex = nil,
	inputRecreateFrame = 0,
	blockNextEnter = false,
	blockSendUntil = 0,
	updateRetryCount = 0,
	updateFailed = false
}
local bufferHistory = {
	currentIndex = 0,
	originalText = nil,
	isNavigating = false
}
local keyStates = {
	[imgui.Key.UpArrow] = false,
	[imgui.Key.DownArrow] = false
}
local bufferNavigationState = {
	isNavigating = false,
	currentIndex = 0,
	originalText = nil,
	lastAdText = nil
}
local data = {
	newsHelpBind = {},
	customBinds = {},
	adBuffer = {},
	membersList = {},
	startTime = os.clock(),
	updateCheckTimer = 0,
	UPDATE_CHECK_DELAY = 5000,
	PROtext = "",
	Ustavtext = "",
	PPStext = "",
	NTStext = "",
	currentMainSettingsTab = 0,
	selectedBindsVariant = 1,
	currentProTab = 0,
	myRankNumber = 0,
	mainIni = {
		config = {
			c_nick = "",
			c_rang_b = "",
			c_cnn = "", 
			c_city_n = "",
			c_pol = 2,
			wave_tag = "VaF"
		}
	},
	devConfig = {
		pro_version = 3,
		last_pro_version = 2,
		ustav_version = 2,
		last_ustav_version = 1,
		pps_version = 2,
		last_pps_version = 1,
		nts_version = 2,
		last_nts_version = 1
	}
}
local states = {
	upKeyPressed = false,
	settingsKeysPressed = {},
	downKeyPressed = false,
	enterReleased = true,
	pendingCursorPos = nil,
	starPositions = {},
	currentStarIndex = 1,
	isProcessingTab = false,
	CustomAdEditCallback = nil,
	lastTextLength = 0,
	enterWasPressed = false,
	CustomAdEditCallbackCast = nil
}
local helpers = {
	showVariablesHelp = new.bool(false),
	newMessageKey = imgui.new.char[64](),
	newMessageText = imgui.new.char[512](),
	newMessageDisplayName = imgui.new.char[128](),
	newBindCommand = imgui.new.char[32](),
	tempNewLineBuffer = nil
}
local mathResults = {
	primer1 = nil,
	primer2 = nil
}
local chat = {
	scoreUpdateQueue = {},
	idPlayers = {},
	myId = -1
}
local cache = {
	lower = {},
	search = {}
}
local binder = {
	list = {},
	editing = nil,
	hoveredIndex = nil,
	deleteConfirm = nil,
	editWindow = new.bool(false),
	conditionsWindow = new.bool(false),
	keyCapture = {
		active = false,
		keys = {},
		lastKeyTime = 0
	}
}
local binderEdit = {
	name = imgui.new.char[256](),
	hotkey = {},
	command = imgui.new.char[64](),
	enableOnChat = new.bool(false),
	enableOnDialog = new.bool(false),
	requireConfirm = new.bool(false),
	blockKey = new.bool(false),
	mode = new.int(1),
	delay = new.int(3000),
	lines = {},
	squareText = imgui.new.char[8192](),
	tempHotkey = {}
}
local rsSettings = {
	interactionKey=vk.VK_R,
	isSettingKey=false,
	actions={
		invite={name="Принять сотрудника",lines={"/me достал планшет из кармана","/me зашёл в базу данных сотрудников","/me внёс данные нового сотрудника","/me передал планшет обратно в карман"},delay=3000,needInput=false},
		uninvite={name="Уволить сотрудника",lines={"/me достал планшет из кармана","/me зашёл в базу данных сотрудников","/me удалил данные сотрудника из базы данных"},delay=3000,needInput=true,inputPlaceholder="Введите причину увольнения"},
		rank={name="Повысить сотрудника",lines={"/me достал планшет из кармана","/me зашёл в базу данных сотрудников","/me изменил ранг сотрудника в базе данных"},delay=3000,needInput=true,inputPlaceholder="Введите новый ранг (1-10)"},
		givedress={name="Дать одежду",lines={"/me открыл шкаф с формой","/me достал комплект униформы","/me протянул униформу сотруднику"},delay=3000,needInput=false},
		vig={name="Выдать выговор",lines={"/me достал планшет из кармана","/me зашёл в систему выговоров","/me внёс выговор в личное дело сотрудника"},delay=3000,needInput=true,inputPlaceholder="Введите причину выговора"},
		unvig={name="Снять выговор",lines={"/me достал планшет из кармана","/me зашёл в систему выговоров","/me снял выговор с личного дела сотрудника"},delay=3000,needInput=false}
	}
}
local playerInteraction = {
	targetId = -1,
	targetName = "",
	hoveredPlayerId = -1,
	inputType = "",
	inputTitle = "",
	inputText = imgui.new.char[256]()
}
local rsEditor = {
	lines = {},
	newLineText = imgui.new.char[512](),
	focusInput = false,
	scrollToBottom = false
}
local autoRP = {
	enabled = new.bool(false)
}
if not vk.VK_SHIFT then vk.VK_SHIFT = 0x10 end
if not vk.VK_CONTROL then vk.VK_CONTROL = 0x11 end
if not vk.VK_MENU then vk.VK_MENU = 0x12 end
local tabWindowSizes = {
	[0] = {x = 800, y = 620},
	[1] = {x = 800, y = 783},
	[2] = {x = 800, y = 310},
	[3] = {x = 800, y = 350},
	[4] = {x = 800, y = 307},
	[5] = {x = 800, y = 240},
	[6] = {x = 800, y = 623},
	[7] = {x = 800, y = 700},
	[8] = {x = 800, y = 600}
}
local trstl1 = {
	['ph'] = 'ф',['Ph'] = 'Ф',['Ch'] = 'Ч',['ch'] = 'ч',['Th'] = 'Т',['th'] = 'т',
	['Sh'] = 'Ш',['sh'] = 'ш', ['ea'] = 'и',['Ae'] = 'Э',['ae'] = 'э',
	['Yu'] = 'Ю',['yu'] = 'ю',['Yo'] = 'Ё',['yo'] = 'ё',['Cz'] = 'Ц',['cz'] = 'ц',
	['ia'] = 'я', ['Ya'] = 'Я', ['ya'] = 'я', ['oo'] = 'у', ['Oo'] = 'У'
}
local trstl = {
	['B'] = 'Б',['Z'] = 'З',['T'] = 'Т',['Y'] = 'Й',['P'] = 'П',['J'] = 'Дж',
	['X'] = 'Кс',['G'] = 'Г',['V'] = 'В',['H'] = 'Х',['N'] = 'Н',['E'] = 'Е',
	['I'] = 'И',['D'] = 'Д',['O'] = 'О',['K'] = 'К',['F'] = 'Ф',['A'] = 'А',
	['C'] = 'К',['L'] = 'Л',['M'] = 'М',['W'] = 'В',['Q'] = 'К',['U'] = 'А',
	['R'] = 'Р',['S'] = 'С',['h'] = 'х',['q'] = 'к',['y'] = 'и',['a'] = 'а',
	['w'] = 'в',['b'] = 'б',['v'] = 'в',['g'] = 'г',['d'] = 'д',['e'] = 'е',
	['z'] = 'з',['i'] = 'и',['j'] = 'ж',['k'] = 'к',['l'] = 'л',['m'] = 'м',
	['n'] = 'н',['o'] = 'о',['p'] = 'п',['r'] = 'р',['s'] = 'с',['t'] = 'т',
	['u'] = 'у',['f'] = 'ф',['x'] = 'x',['c'] = 'к'
}
local translitExceptions = {
	["Anastasia Sun"] = "Анастасия Сан",
	["Ivan Petrov"] = "Иван Петров",
	["Ferrucio_Snow"] = "Ферручо Сноу",
}
local hotkeyNames = {
	[vk.VK_F1] = "F1", [vk.VK_F2] = "F2", [vk.VK_F3] = "F3", [vk.VK_F4] = "F4",
	[vk.VK_F5] = "F5", [vk.VK_F6] = "F6", [vk.VK_F7] = "F7", [vk.VK_F8] = "F8",
	[vk.VK_F9] = "F9", [vk.VK_F10] = "F10", [vk.VK_F11] = "F11", [vk.VK_F12] = "F12",
	[vk.VK_SHIFT] = "Shift",
	[vk.VK_LSHIFT] = "Left Shift",
	[vk.VK_RSHIFT] = "Right Shift",
	[vk.VK_CONTROL] = "Ctrl",
	[vk.VK_LCONTROL] = "Left Ctrl",
	[vk.VK_RCONTROL] = "Right Ctrl",
	[vk.VK_MENU] = "Alt",
	[vk.VK_LMENU] = "Left Alt", 
	[vk.VK_RMENU] = "Right Alt",
	[vk.VK_SPACE] = "Space", 
	[vk.VK_TAB] = "Tab", 
	[vk.VK_RETURN] = "Enter",
	[vk.VK_BACK] = "Backspace", 
	[vk.VK_PAUSE] = "Pause", 
	[vk.VK_CAPITAL] = "CapsLock", 
	[vk.VK_ESCAPE] = "Escape",
	[vk.VK_PRIOR] = "PageUp", [vk.VK_NEXT] = "PageDown",
	[vk.VK_END] = "End", [vk.VK_HOME] = "Home",
	[vk.VK_LEFT] = "Left Arrow", [vk.VK_UP] = "Up Arrow", 
	[vk.VK_RIGHT] = "Right Arrow", [vk.VK_DOWN] = "Down Arrow",
	[vk.VK_INSERT] = "Insert", [vk.VK_DELETE] = "Delete",
	[vk.VK_NUMPAD0] = "Num 0", [vk.VK_NUMPAD1] = "Num 1", [vk.VK_NUMPAD2] = "Num 2",
	[vk.VK_NUMPAD3] = "Num 3", [vk.VK_NUMPAD4] = "Num 4", [vk.VK_NUMPAD5] = "Num 5",
	[vk.VK_NUMPAD6] = "Num 6", [vk.VK_NUMPAD7] = "Num 7", [vk.VK_NUMPAD8] = "Num 8", 
	[vk.VK_NUMPAD9] = "Num 9",
	[vk.VK_MULTIPLY] = "Num *", [vk.VK_ADD] = "Num +", 
	[vk.VK_SUBTRACT] = "Num -", [vk.VK_DECIMAL] = "Num .", 
	[vk.VK_DIVIDE] = "Num /", [vk.VK_NUMLOCK] = "NumLock",
	[vk.VK_SCROLL] = "ScrollLock", [vk.VK_SNAPSHOT] = "PrintScreen",
	[vk.VK_CLEAR] = "Clear", [vk.VK_SELECT] = "Select",
	[vk.VK_PRINT] = "Print", [vk.VK_EXECUTE] = "Execute",
	[vk.VK_HELP] = "Help", [vk.VK_APPS] = "Apps",
	[vk.VK_Q] = "Q"
}
for i = 0x30, 0x39 do hotkeyNames[i] = string.char(i) end
for i = 0x41, 0x5A do hotkeyNames[i] = string.char(i) end
local en_to_ru = {
	q='й', w='ц', e='у', r='к', t='е', y='н', u='г', i='ш', o='щ', p='з', ['[']='х', [']']='ъ',
	a='ф', s='ы', d='в', f='а', g='п', h='р', j='о', k='л', l='д', [';']='ж', ["'"]='э',
	z='я', x='ч', c='с', v='м', b='и', n='т', m='ь', [',']='б', ['.']='ю'
}
local ru_to_en = {}
for k,v in pairs(en_to_ru) do ru_to_en[v] = k end
local aboutTabContent = {
	commands = {
		'/newshelp - помощь по биндам',
		'/newseditor - редактор биндов',
		'/newstools - окно настроек',
		'/reloadbinds - перезагрузка биндов',
		'/clearbuffer - очистка буфера',
		'/newsbufferlimit [1-1000] - лимит буфера',
		'/newsupdate - проверить обновления',
		'/newsinstall - установить обновление'
	},
	hotkeys = {
		{func = function() return getHotkeyString(ui.hotkeys.help) end, desc = ' - помощь'},
		{func = function() return getHotkeyString(ui.hotkeys.pro) end, desc = ' - ПРО'},
		{func = function() return getHotkeyString(ui.hotkeys.edit) end, desc = ' - открыть /edit'},
		{text = 'ESC - закрыть окно'}
	}
}
local aboutTabWhatsNew = {
	'Были полностью пофикшены все эфиры',
	'Полностью доработана система автоэфира',
	'Добавлено автоотзеркаливания текста в эфире "Зеркало"',
	'Чекер теперь стал чётче',
	'Автообновление',
	'Добавлен полноценный менеджер биндов с поддержкой комбинаций клавиш',
	'Добавлена панель управления сотрудниками для заместителей',
	'Добавлены возможность менять все цвета а еще темы',
	'Исправлены цвета теперь они все меняются'
}
local ballMessageVariants = {
	ball1 = {" получает * балл!", " зарабатывает * балл!", " набирает * балл!"},
	ball2 = {" получает * балла!", " зарабатывает * балла!", " набирает * балла!"},
	ball5 = {" получает * баллов!", " зарабатывает * баллов!", " набирает * баллов!"}
}
local efirLineCount = {
	math = 10, country = 10, himia = 10, zerkalo = 10,
	annagramm = 10, zagadki = 10, sinonim = 10
}
function compareVersions(localVer, remoteVer)
	local function split(ver)
		local t = {}
		for num in string.gmatch(ver, "[0-9]+") do
			table.insert(t, tonumber(num))
		end
		return t
	end
	local l, r = split(localVer), split(remoteVer)
	for i = 1, math.max(#l, #r) do
		local lv, rv = l[i] or 0, r[i] or 0
		if lv < rv then return true end
		if lv > rv then return false end
	end
	return false
end
function validateScript(path)
	local file = io.open(path, 'rb')
	if not file then return false end
	local content = file:read('*a')
	file:close()
	local size = #content
	if size < 204800 then return false end
	if not content:find('imgui%.OnInitialize') then return false end
	if not content:find('function main') then return false end
	return true
end
function createBackup()
	local backup_path = settings.configFolder .. 'newstools.backup'
	if doesFileExist(backup_path) then os.remove(backup_path) end
	local source = io.open(thisScript().path, 'rb')
	if not source then return false end
	local content = source:read('*a')
	source:close()
	local dest = io.open(backup_path, 'wb')
	if not dest then return false end
	dest:write(content)
	dest:close()
	return true
end
function restoreBackup()
	local backup_path = settings.configFolder .. 'newstools.backup'
	if doesFileExist(backup_path) then
		if doesFileExist(thisScript().path) then os.remove(thisScript().path) end
		local source = io.open(backup_path, 'rb')
		if not source then return false end
		local content = source:read('*a')
		source:close()
		local dest = io.open(thisScript().path, 'wb')
		if not dest then return false end
		dest:write(content)
		dest:close()
		return true
	end
	return false
end
function cleanUpdateFiles()
	local files = {'newstools.backup', 'newstools.tmp'}
	for _, file in ipairs(files) do
		local path = settings.configFolder .. file
		if doesFileExist(path) then
			pcall(function() os.remove(path) end)
		end
	end
end
function checkForUpdates(manual)
	lua_thread.create(function()
		if flags.updaterBusy then return end
		
		if manual then
			sampAddChatMessage(u8:decode("[News Helper] Проверяем обновления..."), 0xFFFF00)
		end
		flags.updaterBusy = true
		
		local ok, response = pcall(function()
			return requests.get("https://raw.githubusercontent.com/alikhandwawd/newstools/main/version.txt", { timeout = 10 })
		end)
		
		if not ok or not response or not response.text then
			sampAddChatMessage(u8:decode("[News Helper] Ошибка соединения с GitHub."), 0xFF0000)
			flags.updaterBusy = false
			return
		end
		
		local server_version = response.text:gsub("[\n\r%s]", ""):gsub("^v", "")
		
		if server_version ~= "" and compareVersions(script_version, server_version) then
			update_available = true
			new_version = server_version
			sampAddChatMessage(u8:decode(string.format("[News Helper] Доступно обновление до %s!", server_version)), 0x00FF00)
			if not manual then
				sampAddChatMessage(u8:decode("[News Helper] Автообновление через 3 секунды..."), 0xFFFF00)
				wait(3000)
				installUpdate()
			else
				sampAddChatMessage(u8:decode("[News Helper] Используйте /newsinstall для установки."), 0xFFFF00)
			end
		else
			if manual then
				sampAddChatMessage(u8:decode("[News Helper] У вас последняя версия."), 0x00FF00)
			end
			flags.updaterBusy = false
		end
	end)
end
function installUpdate()
	lua_thread.create(function()
		if not update_available or not new_version then
			sampAddChatMessage(u8:decode("[News Helper] Нет доступных обновлений."), 0xFF0000)
			return
		end

		flags.updaterBusy = true
		local backup_path = settings.configFolder .. 'newstools.backup'
		local temp_path = settings.configFolder .. 'newstools.tmp'

		sampAddChatMessage(u8:decode("[News Helper] Создание резервной копии..."), 0xFFFF00)
		if not createBackup() then
			sampAddChatMessage(u8:decode("[News Helper] Ошибка создания бэкапа."), 0xFF0000)
			flags.updaterBusy = false
			return
		end

		sampAddChatMessage(u8:decode("[News Helper] Скачиваем обновление..."), 0xFFFF00)
		local download_url = "https://raw.githubusercontent.com/alikhandwawd/newstools/main/newstools.lua"
		
		local ok, err = downloadUrlToFile(download_url, temp_path)
		if ok then
			sampAddChatMessage(u8:decode("[News Helper] Проверка файла..."), 0xFFFF00)
			wait(500)
			if validateScript(temp_path) then
				local success_copy = pcall(function()
					if doesFileExist(thisScript().path) then os.remove(thisScript().path) end
					local fin = io.open(temp_path, "rb")
					local fout = io.open(thisScript().path, "wb")
					if fin and fout then
						fout:write(fin:read("*a"))
						fin:close()
						fout:close()
					end
				end)
				if success_copy then
					cleanUpdateFiles()
					flags.updateRetryCount = 0
					flags.updateFailed = false
					flags.nextUpdateCheck = nil
					sampAddChatMessage(u8:decode(string.format("[News Helper] Обновление до %s установлено!", new_version)), 0x00FF00)
					flags.updaterBusy = false
					wait(2000)
					thisScript():reload()
				else
					sampAddChatMessage(u8:decode("[News Helper] Ошибка установки. Восстановление..."), 0xFF0000)
					if restoreBackup() then
						sampAddChatMessage(u8:decode("[News Helper] Восстановлена предыдущая версия."), 0xFFFF00)
					else
						sampAddChatMessage(u8:decode("[News Helper] Ошибка восстановления!"), 0xFF0000)
					end
					cleanUpdateFiles()
					flags.updaterBusy = false
				end
			else
				sampAddChatMessage(u8:decode("[News Helper] Файл не прошёл проверку."), 0xFF0000)
				if restoreBackup() then
					sampAddChatMessage(u8:decode("[News Helper] Восстановлена предыдущая версия."), 0xFFFF00)
				end
				cleanUpdateFiles()
				flags.updaterBusy = false
				flags.updateFailed = true
			end
		else
			sampAddChatMessage(u8:decode("[News Helper] Ошибка скачивания: " .. tostring(err)), 0xFF0000)
			restoreBackup()
			cleanUpdateFiles()
			flags.updaterBusy = false
		end
	end)
end
local function InitCustomAdCallback()
	if not states.CustomAdEditCallback then
		states.CustomAdEditCallback = function(data)
			if states.isProcessingTab then
				return 0
			end
			if states.pendingCursorPos then
				data.CursorPos = states.pendingCursorPos
				states.pendingCursorPos = nil
			end
			if data.EventFlag == imgui.InputTextFlags.CallbackCharFilter then
				if data.EventChar == 9 and #states.starPositions > 0 then
					states.isProcessingTab = true
					local text = ffi.string(data.Buf)
					local nextStarPos = nil
					for _, pos in ipairs(states.starPositions) do
						if pos > data.CursorPos then
							nextStarPos = pos
							break
						end
					end
					if not nextStarPos and #states.starPositions > 0 then
						nextStarPos = states.starPositions[1]
					end
					if nextStarPos then
						states.pendingCursorPos = nextStarPos - 1
						local newText = text:sub(1, nextStarPos - 1) .. text:sub(nextStarPos + 1)
						ffi.copy(data.Buf, newText)
						data.BufTextLen = #newText
						data.BufDirty = true
						local newPositions = {}
						for _, pos in ipairs(states.starPositions) do
							if pos ~= nextStarPos then
								if pos > nextStarPos then
									table.insert(newPositions, pos - 1)
								else
									table.insert(newPositions, pos)
								end
							end
						end
						states.starPositions = newPositions
					end
					states.isProcessingTab = false
					return 1
				end
			end
			return 0
		end
		states.CustomAdEditCallbackCast = ffi.cast("int(*)(ImGuiInputTextCallbackData*)", states.CustomAdEditCallback)
	end
end
local function lower_utf8_optimized(s)
	if not s then return '' end
	if cache.lower[s] then
		return cache.lower[s]
	end
	local out = string.lower(s)
	local replacements = {
		['А'] = 'а', ['Б'] = 'б', ['В'] = 'в', ['Г'] = 'г', ['Д'] = 'д',
		['Е'] = 'е', ['Ё'] = 'ё', ['Ж'] = 'ж', ['З'] = 'з', ['И'] = 'и',
		['Й'] = 'й', ['К'] = 'к', ['Л'] = 'л', ['М'] = 'м', ['Н'] = 'н',
		['О'] = 'о', ['П'] = 'п', ['Р'] = 'р', ['С'] = 'с', ['Т'] = 'т',
		['У'] = 'у', ['Ф'] = 'ф', ['Х'] = 'х', ['Ц'] = 'ц', ['Ч'] = 'ч',
		['Ш'] = 'ш', ['Щ'] = 'щ', ['Ъ'] = 'ъ', ['Ы'] = 'ы', ['Ь'] = 'ь',
		['Э'] = 'э', ['Ю'] = 'ю', ['Я'] = 'я'
	}
	for upper, lower in pairs(replacements) do
		out = out:gsub(upper, lower)
	end
	if #cache.lower > 1000 then
		cache.lower = {}
	end
	cache.lower[s] = out
	return out
end
local function switch_layout(text, to)
	local result = {}
	local map = (to == "ru") and en_to_ru or ru_to_en
	for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
		local lower = uchar:lower()
		local mapped = map[lower] or uchar
		table.insert(result, mapped)
	end
	return table.concat(result)
end
local function strip_bb_tags(str)
	if not str then return "" end
	str = str:gsub("{%x%x%x%x%x%x}", "")
	str = str:gsub("%[/?%s*%a+[^%]]*%]", "")
	return str
end
local function normalize_search_text(str)
	if not str then return "" end
	local cleaned = strip_bb_tags(str)
	cleaned = cleaned:lower()
	cleaned = cleaned:gsub("%s+", " ")
	cleaned = cleaned:gsub("^%s+", ""):gsub("%s+$", "")
	return cleaned
end
local function normalize_search_query(str)
	if not str then return "" end
	local query = str:lower()
	query = query:gsub("%s+", " ")
	query = query:gsub("^%s+", ""):gsub("%s+$", "")
	return query
end
local function normalizeText(str)
	if not str then return "" end
	str = str:gsub("\r\n", "\n")
	str = str:gsub("\n\n+", "\n")
	str = str:gsub("%s+$", "")
	return str
end
local function normalizeTextForComparison(str)
	if not str then return "" end
	str = str:gsub("\r\n", " ")
	str = str:gsub("\n", " ")
	str = str:gsub("%s+", " ")
	str = str:gsub("^%s+", "")
	str = str:gsub("%s+$", "")
	return str
end
local function normalizeForBufferCompare(text)
	if not text then return "" end
	text = text:gsub("\r\n", "")
	text = text:gsub("\n", "")
	text = text:gsub("%s+", "")
	text = lower_utf8_optimized(text)
	return text
end
local function strip_bb_tags(str)
	if not str then return "" end
	str = str:gsub("{%x%x%x%x%x%x}", "")
	str = str:gsub("%[/?%s*%a+[^%]]*%]", "")
	return str
end
local function normalize_search_text(str)
	if not str then return "" end
	local cleaned = strip_bb_tags(str)
	cleaned = cleaned:lower()
	cleaned = cleaned:gsub("%s+", " ")
	cleaned = cleaned:gsub("^%s+", ""):gsub("%s+$", "")
	return cleaned
end
local function search_in_bb_text(searchQuery, targetText)
	if not searchQuery or searchQuery == "" then return true end
	local queryNorm = lower_utf8_optimized(searchQuery):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
	local altRu = switch_layout(queryNorm, "ru")
	local altEn = switch_layout(queryNorm, "en")
	local queryAlt = (altRu ~= queryNorm) and altRu or altEn
	local textNorm = targetText or ""
	textNorm = textNorm:gsub("{%x%x%x%x%x%x}", "")
	textNorm = textNorm:gsub("%[/?%s*%a+[^%]]*%]", "")
	textNorm = lower_utf8_optimized(textNorm)
	textNorm = textNorm:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
	if textNorm:find(queryNorm, 1, true) or textNorm:find(queryAlt, 1, true) then
		return true
	end
	local quote_inner = targetText:match("%[%s*[Qq][Uu][Oo][Tt][Ee]%s*%](.-)%[%s*/%s*[Qq][Uu][Oo][Tt][Ee]%s*%]")
	if quote_inner then
		local quoteNorm = lower_utf8_optimized(quote_inner)
		quoteNorm = quoteNorm:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
		if quoteNorm:find(queryNorm, 1, true) or quoteNorm:find(queryAlt, 1, true) then
			return true
		end
	end
	local spoiler_inner = targetText:match('%[%s*[Ss][Pp][Oo][Ii][Ll][Ee][Rr]%s*=%s*".-"%s*%](.-)%[%s*/%s*[Ss][Pp][Oo][Ii][Ll][Ee][Rr]%s*%]')
	if spoiler_inner then
		local spoilerNorm = lower_utf8_optimized(spoiler_inner)
		spoilerNorm = spoilerNorm:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
		if spoilerNorm:find(queryNorm, 1, true) or spoilerNorm:find(queryAlt, 1, true) then
			return true
		end
	end
	return false
end
local function insertTextToInput(text)
	ffi.fill(settings.customAd.responseText, ffi.sizeof(settings.customAd.responseText))
	local len = math.min(#text, ffi.sizeof(settings.customAd.responseText) - 1)
	ffi.copy(settings.customAd.responseText, text, len)
	flags.focusResponse = true
end
local function cleanNickname(nick)
	if not nick then return "" end
	nick = nick:gsub("%[PC%]", ""):gsub("%[M%]", ""):gsub("%[%d+%]", "")
	nick = nick:gsub("^%s+", ""):gsub("%s+$", "")
	nick = nick:gsub("[а-яёА-ЯЁ]", function(c)
		local cyrillic = {а="a", б="b", в="v", г="g", д="d", е="e", ё="yo", ж="zh", з="z", и="i", й="y", к="k", л="l", м="m", н="n", о="o", п="p", р="r", с="s", т="t", у="u", ф="f", х="kh", ц="ts", ч="ch", ш="sh", щ="sch", ъ="", ы="y", ь="", э="e", ю="yu", я="ya"}
		return cyrillic[c:lower()] or c
	end)
	return nick
end
local function calculateAboutTabHeight()
	local baseHeight = 50
	local lineHeight = 20
	local titleAndVersion = 1
	local buttons = 105
	local commands = 8 * lineHeight
	local hotkeys = 5 * lineHeight
	local whatsNew = (#aboutTabWhatsNew + 2) * lineHeight * 1.00
	return baseHeight + titleAndVersion + buttons + commands + hotkeys + whatsNew
end
local function calculateBindsTabHeight()
	local baseHeight = 300
	local hotkeyLineHeight = 35
	local customBindsCount = 0
	for _ in pairs(data.customBinds) do
		customBindsCount = customBindsCount + 1
	end
	if customBindsCount == 0 then
		return baseHeight
	end
	local totalCustomBindsHeight = customBindsCount * hotkeyLineHeight
	return baseHeight + totalCustomBindsHeight
end
local function isKeyPressed(key)
	return bit.band(ffi.C.GetAsyncKeyState(key), 0x8000) ~= 0
end
local function wasKeyPressed(key)
	local isPressed = isKeyPressed(key)
	local wasPressed = keyStates[key] or false
	local justPressed = isPressed and not wasPressed
	keyStates[key] = isPressed
	return justPressed
end
local function isHotkeyPressed(hotkey)
	if not hotkey or #hotkey == 0 then return false end
	for _, key in ipairs(hotkey) do
		if not isKeyDown(key) then
			return false
		end
	end
	return true
end
local function processKeyCapture()
	if not ui.hotkeys.isSettingHelp and not ui.hotkeys.isSettingPro then
		return nil
	end
	if isKeyJustPressed(vk.VK_ESCAPE) then
		return nil
	end
	for key = 0x08, 0xFE do
		if key ~= vk.VK_ESCAPE and isKeyJustPressed(key) then
			return key
		end
	end
	return nil
end
local function bringWindowToFront()
	if imgui.IsWindowFocused() then
		return
	end
	imgui.SetWindowFocus()
end
local function cp1251_to_utf8(str)
	if not str then return "" end
	local res, pos = {}, 1
	while pos <= #str do
		local b = str:byte(pos)
		if b < 128 then
			table.insert(res, string.char(b))
		else
			local c1, c2
			if b >= 192 then
				c1 = 0xD0; c2 = b - 0xC0 + 0x90
				if b >= 240 then
					c1 = 0xD1; c2 = b - 0xF0 + 0x80
				end
			else
				c1, c2 = 0xD1, 0x91
			end
			table.insert(res, string.char(c1, c2))
		end
		pos = pos + 1
	end
	return table.concat(res)
end
local function toUtf(s)
	if type(s) ~= "string" then return "" end
	if _G.u8 and type(u8.decode) == "function" then
		return u8:decode(s)
	end
	if type(cp1251_to_utf8) == "function" then
		return cp1251_to_utf8(s)
	end
	return s
end
local function render_bb_text(line, baseScale)
	if not line or line == "" then return end
	local center_inner = line:match("%[CENTER%](.-)%[/CENTER%]")
	if center_inner then
		render_centered_block(center_inner, baseScale)
		return
	end
	local function strip_bb_tags(str)
		if not str then return "" end
		return (str:gsub("%[/?%s*%a+[^%]]*%]", ""))
	end
	local chunks = {}
	local function find_next_tag(str, start_pos)
		local patterns = {
			{open = "%[B%]", close = "%[/B%]", name = "B"},
			{open = "%[I%]", close = "%[/I%]", name = "I"},
			{open = "%[COLOR=rgb%((%d+),%s*(%d+),%s*(%d+)%)%]", close = "%[/COLOR%]", name = "COLOR"},
			{open = "%[SIZE=(%d+)%]", close = "%[/SIZE%]", name = "SIZE"},
			{open = "%[FONT=([%w_]+)%]", close = "%[/FONT%]", name = "FONT"}
		}
		local nearest = nil
		local nearest_pos = #str + 1
		for _, p in ipairs(patterns) do
			local s, e, c1, c2, c3 = str:find(p.open, start_pos)
			if s and s < nearest_pos then
				nearest_pos = s
				nearest = {pattern = p, start_pos = s, end_pos = e, captures = {c1, c2, c3}}
			end
		end
		return nearest
	end
	local function parse_with_style(text, style)
		local tag = find_next_tag(text, 1)
		if not tag then
			local clean = strip_bb_tags(text)
			if clean ~= "" then
				table.insert(chunks, {text = clean, style = style})
			end
			return
		end
		if tag.start_pos > 1 then
			local before = text:sub(1, tag.start_pos - 1)
			local clean = strip_bb_tags(before)
			if clean ~= "" then
				table.insert(chunks, {text = clean, style = style})
			end
		end
		local close_start, close_end = text:find(tag.pattern.close, tag.end_pos + 1)
		if not close_start then
			local rest = text:sub(tag.end_pos + 1)
			local clean = strip_bb_tags(rest)
			if clean ~= "" then
				table.insert(chunks, {text = clean, style = style})
			end
			return
		end
		local inner = text:sub(tag.end_pos + 1, close_start - 1)
		local new_style = {}
		for k, v in pairs(style) do new_style[k] = v end
		if tag.pattern.name == "B" then
			new_style.bold = true
		elseif tag.pattern.name == "I" then
			new_style.italic = true
		elseif tag.pattern.name == "COLOR" then
			local r, g, b = tonumber(tag.captures[1]), tonumber(tag.captures[2]), tonumber(tag.captures[3])
			new_style.color = {r/255, g/255, b/255, 1}
		elseif tag.pattern.name == "SIZE" then
			new_style.scale = (tonumber(tag.captures[1]) or 5) / 5 * baseScale
		elseif tag.pattern.name == "FONT" then
			if ui.fonts.custom and ui.fonts.custom[tag.captures[1]:lower()] then
				new_style.font = ui.fonts.custom[tag.captures[1]:lower()]
			end
		end
		parse_with_style(inner, new_style)
		local rest = text:sub(close_end + 1)
		if rest ~= "" then
			parse_with_style(rest, style)
		end
	end
	parse_with_style(line, {scale = baseScale})
	if #chunks == 0 then return end
	local function apply_style(style)
		if style.scale then
			imgui.SetWindowFontScale(style.scale)
		else
			imgui.SetWindowFontScale(baseScale)
		end
		if style.color then
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(
				style.color[1], style.color[2], style.color[3], style.color[4]
			))
		end
		if style.font then
			imgui.PushFont(style.font)
		elseif style.bold and ui.fonts.bold then
			imgui.PushFont(ui.fonts.bold)
		end
	end
	local function reset_style(style)
		if style.font or (style.bold and ui.fonts.bold) then
			imgui.PopFont()
		end
		if style.color then
			imgui.PopStyleColor()
		end
		imgui.SetWindowFontScale(baseScale)
	end
	local function get_text_width(text, style)
		apply_style(style)
		local width = imgui.CalcTextSize(text).x
		reset_style(style)
		return width
	end
	local total_width = 0
	for _, chunk in ipairs(chunks) do
		if type(chunk.text) == "string" then
			total_width = total_width + get_text_width(chunk.text, chunk.style)
		end
	end
	local available_width = imgui.GetContentRegionAvail().x
	if total_width <= available_width then
		for i, chunk in ipairs(chunks) do
			apply_style(chunk.style)
			if i > 1 then
				imgui.SameLine(0, 0)
			end
			imgui.Text(chunk.text)
			reset_style(chunk.style)
		end
		return
	end
	local current_line_width = 0
	local is_first_in_line = true
	for _, chunk in ipairs(chunks) do
		if type(chunk.text) ~= "string" then goto continue end
		local text = chunk.text
		local i = 1
		while i <= #text do
			local word_start = i
			while word_start <= #text and text:sub(word_start, word_start):match("%s") do
				word_start = word_start + 1
			end
			if word_start > #text then break end
			local word_end = word_start
			while word_end <= #text and not text:sub(word_end, word_end):match("%s") do
				word_end = word_end + 1
			end
			local spaces_before = text:sub(i, word_start - 1)
			local word = text:sub(word_start, word_end - 1)
			local text_to_render = word
			if not is_first_in_line and spaces_before ~= "" then
				text_to_render = spaces_before .. word
			end
			local word_width = get_text_width(text_to_render, chunk.style)
			if current_line_width + word_width > available_width and not is_first_in_line then
				current_line_width = 0
				is_first_in_line = true
				text_to_render = word
				word_width = get_text_width(word, chunk.style)
			end
			apply_style(chunk.style)
			if not is_first_in_line then
				imgui.SameLine(0, 0)
			end
			imgui.Text(text_to_render)
			reset_style(chunk.style)
			current_line_width = current_line_width + word_width
			is_first_in_line = false
			i = word_end
		end
		::continue::
	end
end
local function render_centered_block(text, baseScale)
	if not text or text == "" then return end
	imgui.SetWindowFontScale(baseScale)
	local winW = imgui.GetWindowWidth()
	for paragraph in text:gmatch("[^\r\n]+") do
		local clean = paragraph:gsub("^%s+", ""):gsub("%s+$", "")
		if clean == "" then
			imgui.Text("")
		else
			local stripped = strip_bb_tags(clean)
			local textW = imgui.CalcTextSize(stripped).x
			local x = (winW - textW) / 2
			if x < 0 then x = 0 end
			imgui.SetCursorPosX(x)
			render_bb_text(clean, baseScale)
		end
	end
	imgui.SetWindowFontScale(1.0)
end
local function render_pro_text(text, baseScale)
	if not text or text == "" then return end
	local pos = 1
	local len = #text
	while pos <= len do
		local s_sp, e_sp, sp_title = text:find('%[%s*[Ss][Pp][Oo][Ii][Ll][Ee][Rr]%s*=%s*"(.-)"%s*%]', pos)
		local s_ctr, e_ctr = text:find('%[%s*[Cc][Ee][Nn][Tt][Ee][Rr]%s*%]', pos)
		local s_qt, e_qt = text:find('%[%s*[Qq][Uu][Oo][Tt][Ee]%s*%]', pos)
		local next_start, tag_type, tag_end, tag_title
		if s_sp and (not s_ctr or s_sp < s_ctr) and (not s_qt or s_sp < s_qt) then
			next_start = s_sp; tag_type = 'spoiler'; tag_end = e_sp; tag_title = sp_title
		elseif s_qt and (not s_ctr or s_qt < s_ctr) then
			next_start = s_qt; tag_type = 'quote'; tag_end = e_qt
		elseif s_ctr then
			next_start = s_ctr; tag_type = 'center'; tag_end = e_ctr
		else
			next_start = nil
		end
		if not next_start then
			local rest = text:sub(pos)
			for line in rest:gmatch("[^\r\n]+") do
				if line:match("%S") then
					render_bb_text(line, baseScale)
				end
			end
			break
		else
			if next_start > pos then
				local before = text:sub(pos, next_start - 1)
				for line in before:gmatch("[^\r\n]+") do
					if line:match("%S") then
						render_bb_text(line, baseScale)
					end
				end
			end
			if tag_type == 'spoiler' then
				local close_s, close_e = text:find('%[%s*/%s*[Ss][Pp][Oo][Ii][Ll][Ee][Rr]%s*%]', tag_end + 1)
				if not close_s then close_s = len; close_e = len end
				local inner = text:sub(tag_end + 1, close_s - 1)
				local header = tag_title or "Спойлер"
				if imgui.CollapsingHeader(header) then
					local dark = imgui.ImVec4(
						settings.colors.background[0] * 0.3,
						settings.colors.background[1] * 0.3,
						settings.colors.background[2] * 0.3,
						1
					)
					local renderLines = {}
					for line in inner:gmatch("[^\r\n]+") do
						if line:match("%S") then
							table.insert(renderLines, line)
						end
					end
					imgui.SetWindowFontScale(baseScale)
					local lineHeight = imgui.GetTextLineHeightWithSpacing()
					imgui.SetWindowFontScale(1.0)
					local childH = lineHeight * #renderLines * 1 + 30
					imgui.PushStyleColor(imgui.Col.ChildBg, dark)
					imgui.BeginChild(
						"spoiler_" .. header,
						imgui.ImVec2(-1, childH),
						false,
						imgui.WindowFlags.AlwaysUseWindowPadding + imgui.WindowFlags.NoScrollbar
					)
					for _, line in ipairs(renderLines) do
						render_bb_text(line, baseScale)
					end
					imgui.EndChild()
					imgui.PopStyleColor()
				end
				pos = close_e + 1
			elseif tag_type == 'quote' then
				local close_s, close_e = text:find('%[%s*/%s*[Qq][Uu][Oo][Tt][Ee]%s*%]', tag_end + 1)
				if not close_s then close_s = len; close_e = len end
				local inner = text:sub(tag_end + 1, close_s - 1)
				local dark = imgui.ImVec4(
					settings.colors.background[0] * 0.3,
					settings.colors.background[1] * 0.3,
					settings.colors.background[2] * 0.3,
					1
				)
				local renderLines = {}
				for line in inner:gmatch("[^\r\n]+") do
					if line:match("%S") then
						table.insert(renderLines, line)
					end
				end
				imgui.SetWindowFontScale(baseScale)
				local lineHeight = imgui.GetTextLineHeightWithSpacing()
				imgui.SetWindowFontScale(1.0)
				local childH = lineHeight * #renderLines * 1 + 30
				imgui.PushStyleColor(imgui.Col.ChildBg, dark)
				imgui.BeginChild(
					"quote_" .. tostring(pos),
					imgui.ImVec2(-1, childH),
					true,
					imgui.WindowFlags.AlwaysUseWindowPadding + imgui.WindowFlags.NoScrollbar
				)
				for _, line in ipairs(renderLines) do
					render_bb_text(line, baseScale)
				end
				imgui.EndChild()
				imgui.PopStyleColor()
				pos = close_e + 1
			else
				local close_s, close_e = text:find('%[%s*/%s*[Cc][Ee][Nn][Tt][Ee][Rr]%s*%]', tag_end + 1)
				if not close_s then close_s = len; close_e = len end
				local inner = text:sub(tag_end + 1, close_s - 1)
				render_centered_block(inner, baseScale)
				pos = close_e + 1
			end
		end
	end
end
local function searchInText_optimized(searchQuery, targetText, searchText)
	if not searchQuery or searchQuery == '' then return false end
	local cache_key = searchQuery .. "|" .. (targetText or "") .. "|" .. (searchText or "")
	if cache.search[cache_key] ~= nil then
		return cache.search[cache_key]
	end
	local q = searchQuery:gsub("[%s\r\n]+", " "):gsub("^%s+", ""):gsub("%s+$", "")
	local qnorm = lower_utf8_optimized(q)
	local altRu = switch_layout(qnorm, "ru")
	local altEn = switch_layout(qnorm, "en")
	local queryAlt = (altRu ~= qnorm) and altRu or altEn
	local result = false
	if targetText then
		local tnorm = lower_utf8_optimized(targetText)
		if tnorm:find(qnorm, 1, true) or tnorm:find(queryAlt, 1, true) then 
			result = true
		end
	end
	if not result and searchText then
		local snorm = lower_utf8_optimized(searchText)
		if snorm:find(qnorm, 1, true) or snorm:find(queryAlt, 1, true) then 
			result = true
		end
	end
	if #cache.search > 5000 then
		cache.search = {}
	end
	cache.search[cache_key] = result
	return result
end
local function updateSearchResults(query)
	if query == ui.search.lastQuery and ui.search.resultsValid then
		return
	end
	ui.search.cachedResults = {}
	ui.search.lastQuery = query
	for i = 1, #data.newsHelpBind do
		local category = data.newsHelpBind[i]
		local matchingItems = {}
		local isBufferCategory = category and category[1] == settings.bufferCategoryName
		if query == "" then
			for j = 2, #category do
				table.insert(matchingItems, j)
			end
			ui.search.cachedResults[i] = matchingItems
		else
			for j = 2, #category do 
				local bind = category[j] or {}
				local bindName = bind[1] or ''
				local bindText = bind[2] or ''
				local bindAuthor = bind[3] or ''
				if searchInText_optimized(query, bindName) or 
					searchInText_optimized(query, bindText) or
					searchInText_optimized(query, bindAuthor) then
					table.insert(matchingItems, j)
				end
			end
			if #matchingItems > 0 then
				ui.search.cachedResults[i] = matchingItems
			end
		end
	end
	ui.search.resultsValid = true
end
local function reverseString(str)
	if not str or str == "" then return "" end
	local chars = {}
	local i = 1
	while i <= #str do
		local byte = str:byte(i)
		local char_len = 1
		if byte >= 240 then char_len = 4
		elseif byte >= 224 then char_len = 3
		elseif byte >= 192 then char_len = 2
		end
		table.insert(chars, str:sub(i, i + char_len - 1))
		i = i + char_len
	end
	local result = ""
	for j = #chars, 1, -1 do
		result = result .. chars[j]
	end
	return result
end
local function getCheckerFont(size)
	size=math.floor(math.max(8,math.min(30,tonumber(size) or 13)))
	return ui.fonts.checkerFonts[size] or ui.fonts.bold
end
local function json_escape(str)
	str = str:gsub('\\', '\\\\'):gsub('"', '\\"')
	str = str:gsub('\n', '\\n'):gsub('\r', '\\r'):gsub('\t', '\\t')
	return str
end
local function trim(s)
	return (s or ""):match("^%s*(.-)%s*$")
end
local function getPlayerPlatform(playerId)
	if not sampIsPlayerConnected(playerId) then return nil end
	local fullNick = sampGetPlayerNickname(playerId)
	if not fullNick then return nil end
	if fullNick:find("%[PC%]") then
		return "PC"
	elseif fullNick:find("%[M%]") then
		return "M"
	end
	return nil
end
local function parseMembers(raw_text)
	local members = {}
	if type(raw_text) ~= "string" then return members end
	local lines = {}
	for line in raw_text:gmatch("[^\r\n]+") do
		table.insert(lines, line)
	end
	for i = 1, #lines do
		local raw = lines[i]
		local cleanLine = raw:gsub("{%x%x%x%x%x%x}", "")
		cleanLine = trim(cleanLine)
		if cleanLine ~= "" and cleanLine:match("^%d+%.") then
			local parts = {}
			for part in cleanLine:gmatch("[^|]+") do
				table.insert(parts, trim(part))
			end
			if #parts >= 4 then
				local num, pos, rank = parts[1]:match("^(%d+)%.%s*(.-)%[(%d+)%]")
				local name, id = parts[2]:match("^([%w_]+)%s*%[(%d+)%]")
				local phone = parts[3] or "N/A"
				local warns = parts[4] or "0/0"
				local afk, mute, noUniform = nil, nil, false
				local extra = ""
				if #parts > 4 then
					for j = 5, #parts do
						extra = extra .. " " .. parts[j]
					end
				end
				extra = trim(extra:gsub("{%x%x%x%x%x%x}", ""))
				extra = cp1251_to_utf8(extra)
				local afkMatch = extra:match("[Aa][Ff][Kk]:?%s*([%w:%s]+)")
				if afkMatch then
					afk = trim(afkMatch)
					extra = extra:gsub("[Aa][Ff][Kk]:?%s*[%w:%s]+", "")
					extra = trim(extra)
				end
				local muteMatch = extra:match("[Вв]%s*муте%s*%(*%s*([%d:]+)%s*%)")
				if not muteMatch then
					muteMatch = extra:match("муте%s*%(*%s*([%d:]+)%s*%)")
				end
				if not muteMatch then
					muteMatch = extra:match("[Mm][Uu][Tt][Ee]%s*%(*%s*([%d:]+)%s*%)")
				end
				if muteMatch then
					mute = trim(muteMatch)
					extra = extra:gsub("[Вв]%s*муте%s*%(*%s*[%d:]+%s*%)", "")
					extra = trim(extra)
				end
				if extra:lower():find("без формы") then
					noUniform = true
					extra = extra:gsub("[Бб]ез формы", "")
					extra = trim(extra)
				end
				local isOffline = false
				if pos and pos:find("^%-") then
					isOffline = true
				end
				local platform = nil
				if num and name and id then
					local playerId = tonumber(id)
					if playerId then
						platform = getPlayerPlatform(playerId)
					end
					table.insert(members, {
						num = tonumber(num) or 0,
						position = cp1251_to_utf8(pos or "N/A"),
						rank = tonumber(rank) or 0,
						name = cp1251_to_utf8(name),
						id = tonumber(id) or 0,
						phone = phone or "N/A",
						warns = warns or "0/0",
						afk = afk,
						mute = mute,
						online = not isOffline,
						noUniform = noUniform,
						platform = platform
					})
				end
			end
		end
	end
	return members
end
local function decode1251(str)
	local t = {
		[0xC0]='А',[0xC1]='Б',[0xC2]='В',[0xC3]='Г',[0xC4]='Д',[0xC5]='Е',[0xC6]='Ж',[0xC7]='З',[0xC8]='И',[0xC9]='Й',
		[0xCA]='К',[0xCB]='Л',[0xCC]='М',[0xCD]='Н',[0xCE]='О',[0xCF]='П',[0xD0]='Р',[0xD1]='С',[0xD2]='Т',[0xD3]='У',
		[0xD4]='Ф',[0xD5]='Х',[0xD6]='Ц',[0xD7]='Ч',[0xD8]='Ш',[0xD9]='Щ',[0xDA]='Ъ',[0xDB]='Ы',[0xDC]='Ь',[0xDD]='Э',
		[0xDE]='Ю',[0xDF]='Я',[0xE0]='а',[0xE1]='б',[0xE2]='в',[0xE3]='г',[0xE4]='д',[0xE5]='е',[0xE6]='ж',[0xE7]='з',
		[0xE8]='и',[0xE9]='й',[0xEA]='к',[0xEB]='л',[0xEC]='м',[0xED]='н',[0xEE]='о',[0xEF]='п',[0xF0]='р',[0xF1]='с',
		[0xF2]='т',[0xF3]='у',[0xF4]='ф',[0xF5]='х',[0xF6]='ц',[0xF7]='ч',[0xF8]='ш',[0xF9]='щ',[0xFA]='ъ',[0xFB]='ы',
		[0xFC]='ь',[0xFD]='э',[0xFE]='ю',[0xFF]='я'
	}
	local out = {}
	for i = 1, #str do
		local b = string.byte(str, i)
		if b < 128 then
			out[#out+1] = string.char(b)
		else
			out[#out+1] = t[b] or '?'
		end
	end
	return table.concat(out)
end
local function escapeProblematicChars(text)
	text = text:gsub("w", "w​"):gsub("W", "W​")
	text = text:gsub("u", "u​"):gsub("U", "U​")
	return text
end
local function isAnyOtherKeyPressed(allowedKeys)
	local keysToCheck = {
		vk.VK_SHIFT, vk.VK_LSHIFT, vk.VK_RSHIFT, vk.VK_CONTROL, vk.VK_LCONTROL, vk.VK_RCONTROL,
		vk.VK_MENU, vk.VK_LMENU, vk.VK_RMENU, vk.VK_SPACE, vk.VK_TAB, vk.VK_RETURN, vk.VK_BACK,
		vk.VK_ESCAPE, vk.VK_LBUTTON, vk.VK_RBUTTON, vk.VK_MBUTTON
	}
	for i = 0x30, 0x39 do table.insert(keysToCheck, i) end
	for i = 0x41, 0x5A do table.insert(keysToCheck, i) end
	for i = vk.VK_F1, vk.VK_F12 do table.insert(keysToCheck, i) end
	local allowed = {}
	for _, k in ipairs(allowedKeys) do 
		allowed[k] = true 
	end
	allowed[vk.VK_SHIFT] = allowed[vk.VK_LSHIFT] or allowed[vk.VK_RSHIFT] or allowed[vk.VK_SHIFT]
	allowed[vk.VK_CONTROL] = allowed[vk.VK_LCONTROL] or allowed[vk.VK_RCONTROL] or allowed[vk.VK_CONTROL]
	allowed[vk.VK_MENU] = allowed[vk.VK_LMENU] or allowed[vk.VK_RMENU] or allowed[vk.VK_MENU]
	for _, key in ipairs(keysToCheck) do
		if not allowed[key] and isKeyPressed(key) then
			return true
		end
	end
	return false
end
local function formatRPMessage(text)
	if not text or text == "" then return text end
	text = text:gsub("^%s+", ""):gsub("%s+$", "")
	if text == "" then return text end
	local firstByte = text:byte(1)
	if firstByte >= 0xE0 and firstByte <= 0xFF then
		local upperByte = firstByte - 0x20
		text = string.char(upperByte) .. text:sub(2)
	elseif firstByte == 0xB8 then
		text = string.char(0xA8) .. text:sub(2)
	elseif firstByte and firstByte >= 0x61 and firstByte <= 0x7A then
		text = firstByte >= 0x61 and firstByte <= 0x7A
			and string.char(firstByte - 0x20) .. text:sub(2)
			or text
	end
	if not text:match("[%.%!%?]$") then
		text = text .. "."
	end
	return text
end
function navigateBufferUp()
	local bufferData = loadBufferFromFile()
	local currentAdText = normalizeForBufferCompare(settings.customAd.data.advertisement or "")
	if bufferNavigationState.lastAdText ~= currentAdText then
		bufferNavigationState.isNavigating = false
		bufferNavigationState.currentIndex = 0
		bufferNavigationState.originalText = nil
		bufferNavigationState.lastAdText = currentAdText
	end
	if not bufferNavigationState.isNavigating then
		bufferNavigationState.isNavigating = true
		bufferNavigationState.originalText = ffi.string(settings.customAd.responseText)
		bufferNavigationState.currentIndex = 0
	end
	local found = false
	for i = bufferNavigationState.currentIndex + 1, #bufferData do
		local bufferAdText = normalizeForBufferCompare(bufferData[i].advertisement or "")
		if bufferAdText == currentAdText then
			local textToSet = bufferData[i].editedText or ""
			flags.pendingBufferInsert = textToSet
			flags.inputRecreateFrame = 2
			bufferNavigationState.currentIndex = i
			found = true
			chatMessage(u8:decode('[News Helper] Загружен вариант #' .. i .. ' из буфера'), 0xFFFF00)
			break
		end
	end
	if not found then
		bufferNavigationState.currentIndex = 0
		chatMessage(u8:decode('[News Helper] Больше нет вариантов'), 0xFFFF00)
	end
end
function navigateBufferDown()
	if bufferNavigationState.isNavigating and bufferNavigationState.originalText then
		flags.pendingBufferInsert = bufferNavigationState.originalText
		flags.inputRecreateFrame = 2
		bufferNavigationState.isNavigating = false
		bufferNavigationState.currentIndex = 0
		bufferNavigationState.lastAdText = nil
		chatMessage(u8:decode('[News Helper] Возвращен оригинальный текст'), 0xFFFF00)
	end
end
function getKeyName(vkCode)
	if not vkCode then return "Не назначено" end
	return hotkeyNames[vkCode] or string.format("Key[%d]", vkCode)
end
function getHotkeyString(hotkey)
	if not hotkey or #hotkey == 0 then
		return "Не назначено"
	end
	local parts = {}
	for _, key in ipairs(hotkey) do
		table.insert(parts, getKeyName(key))
	end
	return table.concat(parts, " + ")
end
function getChatIdAllPlayers()
	chat.idPlayers = {}
	for i = 0, sampGetMaxPlayerId() do
		if sampIsPlayerConnected(i) or i == chat.myId then
			chat.idPlayers[i] = sampGetPlayerNickname(i)
		end
	end
	return chat.idPlayers
end
function onReceiveRpc(id, bs)
	if id == 137 then
		local playerId = raknetBitStreamReadInt16(bs)
		raknetBitStreamIgnoreBits(bs, 40)
		local nickLen = raknetBitStreamReadInt8(bs)
		local name = raknetBitStreamReadString(bs, nickLen)
		chat.idPlayers[playerId] = name
	end
	if id == 138 then
		local playerId = raknetBitStreamReadInt16(bs)
		chat.idPlayers[playerId] = nil
	end
end
function calculateEfirMessagesTabHeight()
	if not efir.selectedType or not efir.messages[efir.selectedType] then
		return 500
	end
	local baseHeight = 270
	local messageLineHeight = 60
	local paddingAndSpacing = 50
	local categories = getEfirMessageOrder(efir.selectedType)
	local messageCount = 0
	if efir.currentSubTab == 1 then
		messageCount = #categories.start
	elseif efir.currentSubTab == 2 then
		messageCount = #categories.additional
	elseif efir.currentSubTab == 3 then
		messageCount = #categories.end_messages
	end
	local messagesHeight = messageCount * messageLineHeight
	local maxScrollHeight = 700
	if messagesHeight > maxScrollHeight then
		messagesHeight = maxScrollHeight
	end
	local totalHeight = baseHeight + messagesHeight + paddingAndSpacing
	local minHeight = 500
	local maxHeight = 950
	if totalHeight < minHeight then
		totalHeight = minHeight
	elseif totalHeight > maxHeight then
		totalHeight = maxHeight
	end
	return totalHeight
end
function calculateFreeEfirTabHeight()
	if efir.custom.viewMode == 'square' then
		return 800
	end
	local baseHeight = 180  
	local lineHeight = 30
	local paddingAndSpacing = 50
	local lineCount = 0
	if efir.custom.selected and efir.custom.lines and #efir.custom.lines > 0 then
		lineCount = #efir.custom.lines
	end
	local addButtonHeight = 40
	local linesHeight = lineCount * lineHeight
	local totalHeight = baseHeight + linesHeight + addButtonHeight + paddingAndSpacing
	local minHeight = 600
	local maxHeight = 800
	if totalHeight < minHeight then
		totalHeight = minHeight
	elseif totalHeight > maxHeight then
		totalHeight = maxHeight
	end
	return totalHeight
end
pcall(ffi.cdef, [[
	short GetAsyncKeyState(int vKey);
]])
function chatMessage(text, color)
	if not settings.silentMode[0] then
		sampAddChatMessage(text, color)
	end
end
function createEfirBuffersFromData(data)
	local result = {}
	efir.messageDisplayNames = {} 
	for efirType, efirData in pairs(data) do
		result[efirType] = {}
		if efirData.messages then
			for key, text in pairs(efirData.messages) do
				local size = efir.messageSizes[key] or 512
				result[efirType][key] = imgui.new.char[size](text)
			end
			if efirData.displayNames then
				efir.messageDisplayNames[efirType] = efirData.displayNames
			end
		else
			for key, text in pairs(efirData) do
				local size = efir.messageSizes[key] or 512
				result[efirType][key] = imgui.new.char[size](text)
			end
		end
	end
	return result
end
function resetIO()
	for i = 0, 511 do
		imgui.GetIO().KeysDown[i] = false
	end
	for i = 0, 4 do
		imgui.GetIO().MouseDown[i] = false
	end
	imgui.GetIO().KeyCtrl = false
	imgui.GetIO().KeyShift = false
	imgui.GetIO().KeyAlt = false
	imgui.GetIO().KeySuper = false
end
function onKeyDown(key, down)
	if windows.customAd[0] and key == vk.VK_TAB then
		return false
	end
end
function onBinderWindowMessage(msg, wparam, lparam)
	if not binder.keyCapture.active then return end
	if msg == 0x100 or msg == 0x104 then
		if wparam == vk.VK_ESCAPE then
			binder.keyCapture.active = false
			binder.keyCapture.keys = {}
			binderEdit.tempHotkey = {}
			consumeWindowMessage(true, true)
			return true
		end
		local pressedKey = wparam
		local isExtended = bit.band(lparam, 0x1000000) ~= 0
		if wparam == vk.VK_SHIFT then
			local scancode = bit.band(bit.rshift(lparam, 16), 0xFF)
			pressedKey = (scancode == 0x36) and vk.VK_RSHIFT or vk.VK_LSHIFT
		elseif wparam == vk.VK_CONTROL then
			pressedKey = isExtended and vk.VK_RCONTROL or vk.VK_LCONTROL
		elseif wparam == vk.VK_MENU then
			pressedKey = isExtended and vk.VK_RMENU or vk.VK_LMENU
		end
		local alreadyPressed = false
		for _, key in ipairs(binder.keyCapture.keys) do
			if key == pressedKey then
				alreadyPressed = true
				break
			end
		end
		if not alreadyPressed then
			table.insert(binder.keyCapture.keys, pressedKey)
			binder.keyCapture.lastKeyTime = os.clock()
		end
		consumeWindowMessage(true, true)
		return true
	elseif msg == 0x101 then
		if binder.keyCapture.active then
			lua_thread.create(function()
				wait(100)
				if binder.keyCapture.active then
					local allKeysReleased = true
					for _, key in ipairs(binder.keyCapture.keys) do
						if isKeyPressed(key) then
							allKeysReleased = false
							break
						end
					end
					if allKeysReleased and #binder.keyCapture.keys > 0 then
						binderEdit.hotkey = {}
						for _, key in ipairs(binder.keyCapture.keys) do
							table.insert(binderEdit.hotkey, key)
						end
						binder.keyCapture.active = false
						binder.keyCapture.keys = {}
					end
				end
			end)
			consumeWindowMessage(true, true)
			return true
		end
	end
	return false
end
function onRSWindowMessage(msg,wparam,lparam)
	if rsSettings.isSettingKey then
		if msg==0x100 or msg==0x104 then
			if wparam==vk.VK_ESCAPE then
				rsSettings.isSettingKey=false
				consumeWindowMessage(true,true)
				return true
			end
			if wparam>=vk.VK_F1 and wparam<=vk.VK_F12 then
				rsSettings.interactionKey=wparam
				rsSettings.isSettingKey=false
				saveRSSettings()
				consumeWindowMessage(true,true)
				return true
			end
		end
		consumeWindowMessage(true,true)
		return true
	end
	if windows.playerMenu[0] or windows.rsWindow[0] or windows.rsEditor[0] or windows.rsInput[0] then
		return false
	end
	if msg==0x100 or msg==0x104 then
		if isKeyDown(vk.VK_RBUTTON) and wparam==rsSettings.interactionKey then
			if isAnyOtherKeyPressed({vk.VK_RBUTTON,rsSettings.interactionKey}) then
				consumeWindowMessage(true,true)
				return true
			end
			local result,ped=getCharPlayerIsTargeting(PLAYER_HANDLE)
			if result then
				local result2,id=sampGetPlayerIdByCharHandle(ped)
				if result2 and sampIsPlayerConnected(id) then
					playerInteraction.targetId=id
					playerInteraction.targetName=sampGetPlayerNickname(id)
					windows.playerMenu[0]=true
					consumeWindowMessage(true,true)
					return true
				end
			end
		end
	end
	return false
end
function onWindowMessage(msg, wparam, lparam)
	if onBinderWindowMessage(msg, wparam, lparam) then
		return false
	end	
	if onRSWindowMessage(msg, wparam, lparam) then
		return false
	end
	for i, bind in ipairs(binder.list) do
		if bind.blockKey and bind.hotkey and #bind.hotkey > 0 then
			if msg == 0x100 or msg == 0x104 then
				local pressedKey = wparam
				local isExtended = bit.band(lparam, 0x1000000) ~= 0
				if wparam == vk.VK_SHIFT then
					local scancode = bit.band(bit.rshift(lparam, 16), 0xFF)
					pressedKey = (scancode == 0x36) and vk.VK_RSHIFT or vk.VK_LSHIFT
				elseif wparam == vk.VK_CONTROL then
					pressedKey = isExtended and vk.VK_RCONTROL or vk.VK_LCONTROL
				elseif wparam == vk.VK_MENU then
					pressedKey = isExtended and vk.VK_RMENU or vk.VK_LMENU
				end
				for _, key in ipairs(bind.hotkey) do
					if key == pressedKey then
						local allPressed = true
						for _, k in ipairs(bind.hotkey) do
							if not isKeyPressed(k) then
								allPressed = false
								break
							end
						end
						if allPressed then
							consumeWindowMessage(true, true)
							return false
						end
					end
				end
			end
		end
	end
	if ui.hotkeys.isSettingHelp or ui.hotkeys.isSettingPro or ui.hotkeys.isSettingEdit or ui.hotkeys.isSettingCustom or efir.control.isSettingPauseKey or ui.hotkeys.isSettingSettings then
		if msg == 0x100 then
			if wparam == vk.VK_ESCAPE then
				ui.hotkeys.isSettingHelp = false
				ui.hotkeys.isSettingPro = false
				ui.hotkeys.isSettingEdit = false
				ui.hotkeys.isSettingCustom = false
				ui.hotkeys.isSettingSettings = false
				efir.control.isSettingPauseKey = false
				ui.hotkeys.tempBuffer = {}
				ui.hotkeys.currentIndex = 0
				consumeWindowMessage(true, true)
				return false
			elseif wparam ~= vk.VK_LBUTTON and wparam ~= vk.VK_RBUTTON and wparam ~= vk.VK_MBUTTON then
				table.insert(ui.hotkeys.tempBuffer, wparam)
				if ui.hotkeys.isSettingHelp then
					ui.hotkeys.help[ui.hotkeys.currentIndex] = wparam
					ui.hotkeys.isSettingHelp = false
				elseif ui.hotkeys.isSettingPro then
					ui.hotkeys.pro[ui.hotkeys.currentIndex] = wparam
					ui.hotkeys.isSettingPro = false
				elseif ui.hotkeys.isSettingEdit then
					ui.hotkeys.edit[ui.hotkeys.currentIndex] = wparam
					ui.hotkeys.isSettingEdit = false
				elseif ui.hotkeys.isSettingSettings then
					ui.hotkeys.settings[ui.hotkeys.currentIndex] = wparam
					ui.hotkeys.isSettingSettings = false
				elseif efir.control.isSettingPauseKey then
					efir.control.pauseHotkey[ui.hotkeys.currentIndex] = wparam
					efir.control.isSettingPauseKey = false
				elseif ui.hotkeys.isSettingCustom then
					if data.customBinds[ui.hotkeys.isSettingCustom] then
						data.customBinds[ui.hotkeys.isSettingCustom][ui.hotkeys.currentIndex] = wparam
					end
					ui.hotkeys.isSettingCustom = false
				end
				ui.hotkeys.tempBuffer = {}
				ui.hotkeys.currentIndex = 0
				saveConfig()
				consumeWindowMessage(true, true)
				return false
			end
		end
		consumeWindowMessage(true, true)
		return false
	end
	if ui.hotkeys.isSettingStarKey then
		if msg == 0x100 or msg == 0x104 then
			if wparam == vk.VK_ESCAPE then
				ui.hotkeys.isSettingStarKey = false
				consumeWindowMessage(true, true)
			else
				local actualKey = wparam
				local isExtended = bit.band(lparam, 0x1000000) ~= 0
				if wparam == vk.VK_SHIFT then
					local scancode = bit.band(bit.rshift(lparam, 16), 0xFF)
					actualKey = (scancode == 0x36) and vk.VK_RSHIFT or vk.VK_LSHIFT
				elseif wparam == vk.VK_CONTROL then
					actualKey = isExtended and vk.VK_RCONTROL or vk.VK_LCONTROL
				elseif wparam == vk.VK_MENU then
					actualKey = isExtended and vk.VK_RMENU or vk.VK_LMENU
				end
				local allowedKeys = {
					[vk.VK_F1] = true, [vk.VK_F2] = true, [vk.VK_F3] = true, [vk.VK_F4] = true,
					[vk.VK_F5] = true, [vk.VK_F6] = true, [vk.VK_F7] = true, [vk.VK_F8] = true,
					[vk.VK_F9] = true, [vk.VK_F10] = true, [vk.VK_F11] = true, [vk.VK_F12] = true,
					[vk.VK_LSHIFT] = true, [vk.VK_RSHIFT] = true, [vk.VK_LCONTROL] = true,
					[vk.VK_RCONTROL] = true, [vk.VK_LMENU] = true, [vk.VK_RMENU] = true,
					[vk.VK_TAB] = true, [vk.VK_SPACE] = true, [vk.VK_PAUSE] = true,
					[vk.VK_CAPITAL] = true, [vk.VK_PRIOR] = true, [vk.VK_NEXT] = true,
					[vk.VK_END] = true, [vk.VK_HOME] = true, [vk.VK_INSERT] = true,
					[vk.VK_DELETE] = true, [vk.VK_NUMPAD0] = true, [vk.VK_NUMPAD1] = true,
					[vk.VK_NUMPAD2] = true, [vk.VK_NUMPAD3] = true, [vk.VK_NUMPAD4] = true,
					[vk.VK_NUMPAD5] = true, [vk.VK_NUMPAD6] = true, [vk.VK_NUMPAD7] = true,
					[vk.VK_NUMPAD8] = true, [vk.VK_NUMPAD9] = true, [vk.VK_MULTIPLY] = true,
					[vk.VK_ADD] = true, [vk.VK_SUBTRACT] = true, [vk.VK_DECIMAL] = true,
					[vk.VK_DIVIDE] = true,
				}
				if allowedKeys[actualKey] then
					settings.starJumpKey = actualKey
					ui.hotkeys.isSettingStarKey = false
					saveConfig()
					consumeWindowMessage(true, true)
				end
			end
		end
		return
	end
	if msg == 0x100 then
		if ui.hotkeys.settings and #ui.hotkeys.settings > 0 then
			local allPressed = true
			for _, key in ipairs(ui.hotkeys.settings) do
				if not isKeyPressed(key) then
					allPressed = false
					break
				end
			end
			if allPressed then
				if efir.auto.active and not efir.auto.paused and not efir.auto.pausedDuringQuestions and not efir.auto.pausedDuringStartup then
					chatMessage(u8:decode('[News Helper] Нельзя открыть настройки во время активного автоэфира!'), 0xFF0000)
					consumeWindowMessage(true, true)
					return false
				end
				states.settingsKeysPressed[wparam] = true
				consumeWindowMessage(true, true)
				return false
			end
		end
	elseif msg == 0x101 then
		if ui.hotkeys.settings and #ui.hotkeys.settings > 0 then
			local wasPressed = states.settingsKeysPressed[wparam]
			states.settingsKeysPressed = {}
			if wasPressed then
				if efir.auto.active and not efir.auto.paused and not efir.auto.pausedDuringQuestions and not efir.auto.pausedDuringStartup then
					chatMessage(u8:decode('[News Helper] Нельзя открыть настройки во время активного автоэфира!'), 0xFF0000)
					consumeWindowMessage(true, true)
					return false
				end
				local allStillPressed = true
				for _, key in ipairs(ui.hotkeys.settings) do
					if not isKeyPressed(key) then
						allStillPressed = false
						break
					end
				end
				if not allStillPressed or #ui.hotkeys.settings == 1 then
					if not windows.help[0] and not windows.editor[0] and not windows.editCategory[0] and not windows.editBind[0] then
						windows.mainSettings[0] = not windows.mainSettings[0]
						consumeWindowMessage(true, true)
					end
				end
				return false
			end
		end
	end
	if windows.customAd[0] and (msg == 0x100 or msg == 0x104) then
		local pressedKey = wparam
		local isExtended = bit.band(lparam, 0x1000000) ~= 0
		if wparam == vk.VK_SHIFT then
			local scancode = bit.band(bit.rshift(lparam, 16), 0xFF)
			pressedKey = (scancode == 0x36) and vk.VK_RSHIFT or vk.VK_LSHIFT
		elseif wparam == vk.VK_CONTROL then
			pressedKey = isExtended and vk.VK_RCONTROL or vk.VK_LCONTROL
		elseif wparam == vk.VK_MENU then
			pressedKey = isExtended and vk.VK_RMENU or vk.VK_LMENU
		end
		if pressedKey == settings.starJumpKey then
			if flags.inputFieldActive and #states.starPositions > 0 then
				local currentText = ffi.string(settings.customAd.responseText)
				local currentLength = #currentText
				local lengthDiff = 0
				if states.currentStarIndex > 0 and states.lastTextLength > 0 then
					lengthDiff = currentLength - states.lastTextLength
					if lengthDiff ~= 0 then
						for i = states.currentStarIndex + 1, #states.starPositions do
							states.starPositions[i] = states.starPositions[i] + lengthDiff
						end
					end
				end
				states.currentStarIndex = states.currentStarIndex + 1
				if states.currentStarIndex > #states.starPositions then
					states.currentStarIndex = 1
				end
				local targetPos = states.starPositions[states.currentStarIndex]
				states.lastTextLength = currentLength
				states.pendingCursorPos = targetPos
				flags.focusResponse = true
				consumeWindowMessage(true, true)
				return false
			end
		end
	end
	if windows.customAd[0] and flags.inputFieldActive then
		if msg == 0x100 then
			if wparam == vk.VK_UP then
				if not states.upKeyPressed then
					states.upKeyPressed = true
					lua_thread.create(function()
						wait(0)
						navigateBufferUp()
					end)
				end
				consumeWindowMessage(true, true)
				return false
			elseif wparam == vk.VK_DOWN then
				if not states.downKeyPressed then
					states.downKeyPressed = true
					lua_thread.create(function()
						wait(0)
						navigateBufferDown()
					end)
				end
				consumeWindowMessage(true, true)
				return false
			end
		elseif msg == 0x101 then
			if wparam == vk.VK_UP then
				states.upKeyPressed = false
			elseif wparam == vk.VK_DOWN then
				states.downKeyPressed = false
			end
		end
	end
	if msg == 0x100 and wparam == vk.VK_ESCAPE then
		if not isPauseMenuActive() then
			local windowClosed = false
			if windows.addCustomBind[0] then
				windows.addCustomBind[0] = false
				windowClosed = true
			elseif windows.contextMenu[0] then
				windows.contextMenu[0] = false
				windowClosed = true
			elseif windows.editCategory[0] then
				windows.editCategory[0] = false
				windowClosed = true
			elseif windows.editBind[0] then
				windows.editBind[0] = false
				windowClosed = true
			elseif windows.colorSettings[0] then
				windows.colorSettings[0] = false
				windowClosed = true
			elseif bulkInput.active then
				bulkInput.active = false
				windowClosed = true
			elseif windows.editor[0] then
				windows.editor[0] = false
				windowClosed = true
			elseif windows.help[0] then
				windows.help[0] = false
				ui.search.resultsValid = false
				ui.search.cachedResults = {}
				ui.search.tmp = ui.search.tmp or {}
				ui.search.tmp.helpFind = nil
				windowClosed = true
			elseif windows.pro[0] then
				windows.pro[0] = false
				windowClosed = true
			elseif windows.mainSettings[0] then
				windows.mainSettings[0] = false
				windowClosed = true
			elseif windows.rsWindow[0] then
				windows.rsWindow[0] = false
				windowClosed = true
			elseif windows.rsEditor[0] then
				windows.rsEditor[0] = false
				windowClosed = true
			elseif windows.rsInput[0] then
				windows.rsInput[0] = false
				windowClosed = true
			elseif windows.playerMenu[0] then
				windows.playerMenu[0] = false
				windowClosed = true
			elseif windows.customAd[0] then
				closeCustomAd(false)
				sampSendDialogResponse(698, 0, 0, "")
				windowClosed = true
			end
			if windowClosed then
				resetIO()
				consumeWindowMessage(true, true)
			end
		end
	end
	if windows.customAd[0] and flags.inputFieldActive and (msg == 0x100 or msg == 0x101 or msg == 0x104) then
		if wparam == vk.VK_TAB then
			local tabUsedInHotkey = false
			for i, bind in ipairs(binder.list) do
				if bind.blockKey and bind.hotkey and #bind.hotkey > 0 then
					for _, key in ipairs(bind.hotkey) do
						if key == vk.VK_TAB then
							tabUsedInHotkey = true
							break
						end
					end
					if tabUsedInHotkey then break end
				end
			end
			if not tabUsedInHotkey then
				consumeWindowMessage(true, true)
				return true
			end
		end
	end
end
function replaceEfirVariables(text)
	if not text then return "" end
	local result = text
	if data.mainIni and data.mainIni.config then
		result = result:gsub("#1", data.mainIni.config.c_rang_b or "") 
		result = result:gsub("#", data.mainIni.config.c_nick or "") 
	end
	result = result:gsub("%*2", ffi.string(efir.inputs.money) or "0")
	return result
end
function renderIntervalControl(efirType, label)
	local bg = settings.colors.background
	local item = settings.colors.itemButtons
	local inputBgColor = imgui.ImVec4(bg[0] * 0.5, bg[1] * 0.5, bg[2] * 0.5, 1)
	local inputBgColorHovered = imgui.ImVec4(bg[0] * 0.7, bg[1] * 0.7, bg[2] * 0.7, 1)
	local inputBgColorActive = imgui.ImVec4(bg[0] * 0.9, bg[1] * 0.9, bg[2] * 0.9, 1)
	if not efir.intervals[efirType] then
		efir.intervals[efirType] = imgui.new.int(3000)
	end
	imgui.Text(label .. ':')
	imgui.SameLine()
	local intervalValue = efir.intervals[efirType][0]
	local digitCount = string.len(tostring(intervalValue))
	local inputWidth = math.max(60, digitCount * 10 + 20)
	imgui.PushItemWidth(inputWidth)
	imgui.SameLine()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
	if imgui.Button('-##Dec' .. efirType, imgui.ImVec2(20, 20)) then
		efir.intervals[efirType][0] = math.max(1000, efir.intervals[efirType][0] - 100)
		saveConfig()
	end
	imgui.SameLine()
	if imgui.InputInt('##Interval' .. efirType, efir.intervals[efirType], 0, 0) then
		if efir.intervals[efirType][0] < 1000 then efir.intervals[efirType][0] = 1000 end
		if efir.intervals[efirType][0] > 10000 then efir.intervals[efirType][0] = 10000 end
		saveConfig()
	end
	imgui.PopStyleColor(3)
	imgui.PopItemWidth()
	imgui.SameLine()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
	if imgui.Button('+##Inc' .. efirType, imgui.ImVec2(20, 20)) then
		efir.intervals[efirType][0] = math.min(10000, efir.intervals[efirType][0] + 100)
		saveConfig()
	end
	imgui.PopStyleColor(3)
end
function renderEfirMessageCategory(efirType, messageKeys, categoryName)
	local messages = efir.messages[efirType]
	local item = settings.colors.itemButtons
	local bg = settings.colors.background
	imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), 'Как добавить новое сообщение:')
	imgui.TextWrapped('1. Нажмите "Добавить"')
	imgui.TextWrapped('2. Введите ключ (например: msg9, ball1.2, end6)')
	imgui.TextWrapped('3. Введите отображаемое имя и текст сообщения')
	imgui.TextWrapped('4. Нажмите "Добавить" в окне или Enter')
	imgui.TextWrapped('Переменная денежной суммы была изменена с ! на *2 пожалуйста нажмите сбросить эфир или поменяйте вручную')
	imgui.Spacing()
	imgui.Separator()
	imgui.Spacing()
	if categoryName ~= "баллы" then
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.8, 0.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.9, 0.3, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.1, 0.7, 0.1, 1))
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(fa('circle_plus') .. ' Добавить новое##' .. categoryName, imgui.ImVec2(120, 25)) then
			if fa_font then imgui.PopFont() end
			imgui.OpenPopup('AddMessage##' .. categoryName)
		end
		if fa_font then imgui.PopFont() end
		imgui.PopStyleColor(3)
		imgui.SameLine()
	end
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.4, 0.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.5, 0.3, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.3, 0.1, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('arrow_rotate_right') .. ' Сбросить эфир##' .. categoryName, imgui.ImVec2(120, 25)) then
		if fa_font then imgui.PopFont() end
		resetEfirMessagesToDefault(efir.selectedType)
		chatMessage(u8:decode('[News Helper] Эфир "' .. efir.selectedType .. '" сброшен!'), 0x00FF00)
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	imgui.SameLine()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.6, 0.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.7, 0.3, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.5, 0.1, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('floppy_disk') .. ' Сохранить##' .. categoryName, imgui.ImVec2(120, 25)) then
		if fa_font then imgui.PopFont() end
		saveEfirMessagesToFile()
		chatMessage(u8:decode('[News Helper] Эфир сохранен!'), 0x00FF00)
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	imgui.Spacing()
	imgui.Separator()
	imgui.Spacing()
	imgui.BeginChild('##Messages' .. categoryName, imgui.ImVec2(0, -1), false)
	for _, msgKey in ipairs(messageKeys) do
		if messages[msgKey] then
			local displayName = getEfirMessageDisplayName(msgKey, efirType)
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.8, 1, 0.8, 1))
			imgui.Text(displayName .. ' [' .. msgKey .. ']:')
			imgui.PopStyleColor()
			imgui.PushItemWidth(-40)
			local inputBgColor = imgui.ImVec4(bg[0] * 0.5, bg[1] * 0.5, bg[2] * 0.5, 1)
			local inputBgColorHovered = imgui.ImVec4(bg[0] * 0.7, bg[1] * 0.7, bg[2] * 0.7, 1)
			local inputBgColorActive = imgui.ImVec4(bg[0] * 0.9, bg[1] * 0.9, bg[2] * 0.9, 1)
			imgui.InputText('##' .. msgKey .. efirType, messages[msgKey], ffi.sizeof(messages[msgKey]))
			imgui.PopItemWidth()
			imgui.SameLine()
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.2, 0.2, 1))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.3, 0.3, 1))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.1, 0.1, 1))
			if imgui.Button('X##del' .. msgKey, imgui.ImVec2(25, 20)) then
				messages[msgKey] = nil
				if efir.messageDisplayNames and efir.messageDisplayNames[efirType] then
					efir.messageDisplayNames[efirType][msgKey] = nil
				end
				saveConfig()
				tabWindowSizes[7].y = calculateEfirMessagesTabHeight()
			end
			imgui.PopStyleColor(3)
			imgui.Spacing()
		end
	end
	imgui.EndChild()
	imgui.PushStyleColor(imgui.Col.PopupBg, imgui.ImVec4(bg[0], bg[1], bg[2], 0.98))
	imgui.PushStyleColor(imgui.Col.TitleBg, imgui.ImVec4(item[0], item[1], item[2], 1))
	imgui.PushStyleColor(imgui.Col.TitleBgActive, imgui.ImVec4(item[0] * 1.1, item[1] * 1.1, item[2] * 1.1, 1))
	if imgui.BeginPopupModal('AddMessage##' .. categoryName, nil, imgui.WindowFlags.AlwaysAutoResize) then
		if not helpers.newMessageKey then
			helpers.newMessageKey = imgui.new.char[64]()
			helpers.newMessageText = imgui.new.char[512]()
			helpers.newMessageDisplayName = imgui.new.char[128]()
		end
		if imgui.IsKeyPressed(imgui.Key.Escape) then
			imgui.CloseCurrentPopup()
			helpers.newMessageKey = nil
			helpers.newMessageText = nil
			helpers.newMessageDisplayName = nil
		end
		imgui.Text('Добавить новое сообщение:')
		imgui.Separator()
		local suggestedKey = ""
		if categoryName == "начать" then
			local maxMsgNum = 0
			for msgKey, _ in pairs(messages) do
				local num = msgKey:match("^msg(%d+)$")
				if num then
					maxMsgNum = math.max(maxMsgNum, tonumber(num))
				end
			end
			suggestedKey = "msg" .. (maxMsgNum + 1)
		elseif categoryName == "завершить" then
			local maxEndNum = 0
			for msgKey, _ in pairs(messages) do
				local num = msgKey:match("^end(%d+)$")
				if num then
					maxEndNum = math.max(maxEndNum, tonumber(num))
				end
			end
			suggestedKey = "end" .. (maxEndNum + 1)
		elseif categoryName == "стоп" then
			local maxStopNum = 0
			for msgKey, _ in pairs(messages) do
				local num = msgKey:match("^stop(%d+)$")
				if num then
					maxStopNum = math.max(maxStopNum, tonumber(num))
				end
			end
			suggestedKey = "stop" .. (maxStopNum + 1)
		else
			suggestedKey = "ball1.2"
		end
		imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), 'Примеры ключей:')
		if categoryName == "начать" then
			imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'msg9, msg10 (для основных сообщений)')
		elseif categoryName == "завершить" then
			imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'end6, end7 (для завершающих)')
		else
			imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'ball1.2, winner4 (для вариаций)')
		end
		imgui.TextColored(imgui.ImVec4(0.5, 1, 0.5, 1), 'Следующий ключ: ' .. suggestedKey)
		imgui.Spacing()
		imgui.Text('Ключ сообщения:')
		imgui.PushItemWidth(200)
		local inputBgColor = imgui.ImVec4(bg[0] * 0.5, bg[1] * 0.5, bg[2] * 0.5, 1)
		local inputBgColorHovered = imgui.ImVec4(bg[0] * 0.7, bg[1] * 0.7, bg[2] * 0.7, 1)
		local inputBgColorActive = imgui.ImVec4(bg[0] * 0.9, bg[1] * 0.9, bg[2] * 0.9, 1)
		local keyEnterPressed = imgui.InputText('##NewMsgKey', helpers.newMessageKey, 64, imgui.InputTextFlags.EnterReturnsTrue)
		imgui.PopItemWidth()
		imgui.Spacing()
		imgui.Text('Отображаемое имя:')
		imgui.PushItemWidth(400)
		local nameEnterPressed = imgui.InputText('##NewMsgDisplayName', helpers.newMessageDisplayName, 128, imgui.InputTextFlags.EnterReturnsTrue)
		imgui.PopStyleColor(3)
		imgui.PopItemWidth()
		if imgui.IsItemHovered() then
			imgui.SetTooltip('Как будет отображаться это сообщение в списке')
		end
		imgui.Spacing()
		imgui.Text('Текст сообщения:')
		imgui.InputTextMultiline('##NewMsgText', helpers.newMessageText, 512, imgui.ImVec2(400, 100))
		imgui.PopStyleColor(3)
		imgui.Separator()
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0] * 1.2, item[1] * 1.2, item[2] * 1.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0] * 1.4, item[1] * 1.4, item[2] * 1.4, 1))
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(fa('xmark') .. ' Отмена (ESC)', imgui.ImVec2(120, 30)) then
			if fa_font then imgui.PopFont() end
			imgui.CloseCurrentPopup()
			helpers.newMessageKey = nil
			helpers.newMessageText = nil
			helpers.newMessageDisplayName = nil
		end
		if fa_font then imgui.PopFont() end
		imgui.PopStyleColor(3)
		imgui.SameLine()
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0] * 1.2, item[1] * 1.2, item[2] * 1.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0] * 1.4, item[1] * 1.4, item[2] * 1.4, 1))
		local shouldAdd = imgui.Button('Добавить Enter ' .. fa('arrow_turn_down_left'), imgui.ImVec2(120, 30))
		if shouldAdd then
			local key = ffi.string(helpers.newMessageKey)
			local text = ffi.string(helpers.newMessageText)
			local displayName = ffi.string(helpers.newMessageDisplayName)
			if key ~= '' and text ~= '' then
				local size = efir.messageSizes[key] or 512
				messages[key] = imgui.new.char[size](text)
				if displayName ~= '' then
					if not efir.messageDisplayNames then
						efir.messageDisplayNames = {}
					end
					if not efir.messageDisplayNames[efirType] then
						efir.messageDisplayNames[efirType] = {}
					end
					efir.messageDisplayNames[efirType][key] = displayName
				end
				saveConfig()
				tabWindowSizes[7].y = calculateEfirMessagesTabHeight()
				chatMessage(u8:decode('[News Helper] Сообщение добавлено!'), 0x00FF00)
				imgui.CloseCurrentPopup()
				helpers.newMessageKey = nil
				helpers.newMessageText = nil
				helpers.newMessageDisplayName = nil
			else
				chatMessage(u8:decode('[News Helper] Заполните обязательные поля (ключ и текст)!'), 0xFF0000)
			end
		end
		imgui.PopStyleColor(3)
		imgui.EndPopup()
	end
	imgui.PopStyleColor(3)
end
function queueAddBall(name)
	table.insert(chat.scoreUpdateQueue, {action = "add", name = name})
end
function queueClearScore()
	table.insert(chat.scoreUpdateQueue, {action = "clear"})
end
function processScoreQueue()
	if #chat.scoreUpdateQueue == 0 then return end
	for _, update in ipairs(chat.scoreUpdateQueue) do
		if update.action == "add" then
			if efir.counter[update.name] then
				efir.counter[update.name] = efir.counter[update.name] + 1
			else
				efir.counter[update.name] = 1
			end
		elseif update.action == "clear" then
			efir.counter = {}
			efir.lastBallVariant = {}
		end
	end
	chat.scoreUpdateQueue = {}
end
function renderEfirMessagesEditor()
	imgui.Text('Редактирование сообщений для эфиров:')
	imgui.Separator()
	imgui.Spacing()
	renderVariablesButton()
	imgui.Spacing()
	imgui.Text('Выберите тип эфира для редактирования:')
	local efirTypes = {
		{key = 'math', name = 'Математика'},
		{key = 'country', name = 'Столицы'},
		{key = 'himia', name = 'Химия'},
		{key = 'zerkalo', name = 'Зеркало'},
		{key = 'annagramm', name = 'Анаграммы'},
		{key = 'zagadki', name = 'Загадки'},
		{key = 'sinonim', name = 'Синонимы'},
		{key = 'inter', name = 'Интервью'},
		{key = 'reklama', name = 'Реклама'},
		{key = 'sobes', name = 'Собеседование'}
	}
	local item = settings.colors.itemButtons
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0] * 1.2, item[1] * 1.2, item[2] * 1.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0] * 1.4, item[1] * 1.4, item[2] * 1.4, 1))
	for i, efirType in ipairs(efirTypes) do
		if i > 1 then imgui.SameLine() end
		local isSelected = efir.selectedType == efirType.key
		if isSelected then
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.8, 0.2, 1))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.9, 0.3, 1))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.1, 0.7, 0.1, 1))
		end
		if imgui.Button(efirType.name .. '##' .. efirType.key, imgui.ImVec2(73, 25)) then
			efir.selectedType = efirType.key
			tabWindowSizes[7].y = calculateEfirMessagesTabHeight()
		end
		if isSelected then
			imgui.PopStyleColor(3)
		end
	end
	imgui.PopStyleColor(3)
	imgui.Separator()
	imgui.Spacing()
	if efir.messages[efir.selectedType] then
		imgui.Text('Сообщения для эфира: ' .. efir.selectedType)
		imgui.PushStyleColor(imgui.Col.Tab, imgui.ImVec4(item[0], item[1], item[2], 1))
		imgui.PushStyleColor(imgui.Col.TabHovered, imgui.ImVec4(item[0] * 1.2, item[1] * 1.2, item[2] * 1.2, 1))
		imgui.PushStyleColor(imgui.Col.TabActive, imgui.ImVec4(item[0] * 1.4, item[1] * 1.4, item[2] * 1.4, 1))
		if imgui.BeginTabBar('##EfirSubTabs') then
			local order = getEfirMessageOrder(efir.selectedType)
			if imgui.BeginTabItem('Начать эфир') then
				efir.currentSubTab = 1
				tabWindowSizes[7].y = calculateEfirMessagesTabHeight()
				renderEfirMessageCategory(efir.selectedType, order.start, "начать")
				imgui.EndTabItem()
			end
			if efir.selectedType ~= 'sobes' then
				if #order.additional > 0 then
					if imgui.BeginTabItem('Баллы и награды') then
						efir.currentSubTab = 2
						tabWindowSizes[7].y = calculateEfirMessagesTabHeight()
						renderEfirMessageCategory(efir.selectedType, order.additional, "баллы")
						imgui.EndTabItem()
					end
				end
			end
			if efir.selectedType ~= 'sobes' then
				if imgui.BeginTabItem('Завершить эфир') then
					efir.currentSubTab = 3
					tabWindowSizes[7].y = calculateEfirMessagesTabHeight()
					local endOnlyMessages = {}
					for _, key in ipairs(order.end_messages) do
						if not key:match("^stop%d+$") then
							table.insert(endOnlyMessages, key)
						end
					end
					renderEfirMessageCategory(efir.selectedType, endOnlyMessages, "завершить")
					imgui.EndTabItem()
				end
			end
			imgui.EndTabBar()
		end
		imgui.PopStyleColor(3)
	else
		imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'Выберите тип эфира для редактирования')
	end
	renderResetEfirConfirmation()
end
function getEfirMessageCategories(efirType)
	return getEfirMessageOrder(efirType)
end
function renderFreeEfirVariablesButton()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.6, 0.8, 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.7, 0.9, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.1, 0.5, 0.7, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('code') .. ' Переменные', imgui.ImVec2(100, 25)) then
		if fa_font then imgui.PopFont() end
		helpers.showVariablesHelp[0] = not helpers.showVariablesHelp[0]
	end
	imgui.PopStyleColor(3)
	if helpers.showVariablesHelp[0] then
		imgui.SameLine()
		imgui.BeginChild('##VariablesHelpFreeEfir', imgui.ImVec2(400, 80), true)
		imgui.Text('Доступные переменные:')
		imgui.Separator()
		imgui.TextColored(imgui.ImVec4(0.8, 1, 0.8, 1), '# - Ник ведущего')
		imgui.TextColored(imgui.ImVec4(0.8, 1, 0.8, 1), '#1 - Ранг ведущего')
		imgui.EndChild()
	end
end
function renderSquareMode()
	local bg = settings.colors.background
	local item = settings.colors.itemButtons
	local inputBgColor = imgui.ImVec4(bg[0] * 0.5, bg[1] * 0.5, bg[2] * 0.5, 1)
	local inputBgColorHovered = imgui.ImVec4(bg[0] * 0.7, bg[1] * 0.7, bg[2] * 0.7, 1)
	local inputBgColorActive = imgui.ImVec4(bg[0] * 0.9, bg[1] * 0.9, bg[2] * 0.9, 1)
	imgui.Text('Введите текст (каждая строка будет отправлена отдельно):')
	local textAreaHeight = imgui.GetWindowHeight() - 120
	imgui.InputTextMultiline('##SquareTextInput', efir.custom.squareText, 
		ffi.sizeof(efir.custom.squareText), 
		imgui.ImVec2(-1, textAreaHeight))
	imgui.PopStyleColor(3)
end
function sendSquareText()
	local text = ffi.string(efir.custom.squareText)
	if text == '' then
		chatMessage(u8:decode('[News Helper] Текст пуст!'), 0xFF0000)
		return
	end
	local lines = {}
	for line in text:gmatch("[^\r\n]+") do
		local trimmed = line:gsub("^%s+", ""):gsub("%s+$", "")
		if trimmed ~= "" then
			table.insert(lines, trimmed)
		end
	end
	if #lines == 0 then
		chatMessage(u8:decode('[News Helper] Нет строк для отправки!'), 0xFF0000)
		return
	end
	lua_thread.create(function()
		chatMessage(u8:decode('[News Helper] Начинаю отправку ' .. #lines .. ' строк...'), 0x00FF00)
		for i, line in ipairs(lines) do
			local processedText = replaceEfirVariables(line)
			sampSendChat(u8:decode(processedText))
			if i < #lines then
				wait(efir.custom.sendInterval[0])
			end
		end
		chatMessage(u8:decode('[News Helper] Все строки отправлены!'), 0x00FF00)
	end)
end
function convertSquareToLines()
	local text = ffi.string(efir.custom.squareText)
	if text == '' then
		chatMessage(u8:decode('[News Helper] Текст пуст!'), 0xFF0000)
		return
	end
	if efir.custom.selected then
		efir.custom.lines = {}
		for line in text:gmatch("[^\r\n]+") do
			local trimmed = line:gsub("^%s+", ""):gsub("%s+$", "")
			table.insert(efir.custom.lines, {
				text = imgui.new.char[512](trimmed)
			})
		end
		saveCustomEfirs()
	else
		chatMessage(u8:decode('[News Helper] Сначала выберите эфир!'), 0xFF0000)
	end
end
function convertLinesToSquare()
	if not efir.custom.lines or #efir.custom.lines == 0 then
		return
	end
	local squareText = {}
	for _, line in ipairs(efir.custom.lines) do
		if line.text then
			local text = ffi.string(line.text)
			if text ~= "" then
				table.insert(squareText, text)
			end
		end
	end
	local combinedText = table.concat(squareText, "\n")
	ffi.fill(efir.custom.squareText, ffi.sizeof(efir.custom.squareText))
	ffi.copy(efir.custom.squareText, combinedText)
	saveCustomEfirs()
end
function renderFreeEfirTab()
	imgui.Text('Пользовательские эфиры')
	imgui.Separator()
	imgui.Spacing()
	local bg = settings.colors.background
	local item = settings.colors.itemButtons
	local inputBgColor = imgui.ImVec4(bg[0] * 0.5, bg[1] * 0.5, bg[2] * 0.5, 1)
	local inputBgColorHovered = imgui.ImVec4(bg[0] * 0.7, bg[1] * 0.7, bg[2] * 0.7, 1)
	local inputBgColorActive = imgui.ImVec4(bg[0] * 0.9, bg[1] * 0.9, bg[2] * 0.9, 1)
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.8, 0.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.9, 0.3, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.1, 0.7, 0.1, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('circle_plus') .. ' Добавить эфир', imgui.ImVec2(140, 25)) then
		imgui.OpenPopup('AddCustomEfir')
	end
	imgui.SameLine()
	imgui.Text('Пауза/возобновление:')
	imgui.SameLine()
	local buttonText = getHotkeyString(efir.control.pauseHotkey)
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0] * 1.2, item[1] * 1.2, item[2] * 1.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0] * 1.4, item[1] * 1.4, item[2] * 1.4, 1))
	imgui.PopStyleColor(3)
	if imgui.Button(buttonText .. '##pausekey', imgui.ImVec2(120, 25)) then
	end
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.Text('Клавиша для паузы/возобновления эфира')
		imgui.Text('Чтобы поменять перейдите в вкладку Горячие клавиши')
		imgui.EndTooltip()
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	imgui.Spacing()
	imgui.Text('Интервал отправки (мс):')
	imgui.SameLine()
	if not efir.auto.active then
		local intervalValue = efir.custom.sendInterval[0]
		local digitCount = string.len(tostring(intervalValue))
		local inputWidth = math.max(60, digitCount * 10 + 20)
		imgui.PushItemWidth(inputWidth)
		imgui.SameLine()
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0] * 1.2, item[1] * 1.2, item[2] * 1.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0] * 1.4, item[1] * 1.4, item[2] * 1.4, 1))
		if imgui.Button('-##DecInterval', imgui.ImVec2(20, 20)) then
			efir.custom.sendInterval[0] = math.max(100, efir.custom.sendInterval[0] - 100)
			saveConfig()
		end
		imgui.SameLine()
		if imgui.InputInt('##SendInterval', efir.custom.sendInterval, 0, 0) then
			if efir.custom.sendInterval[0] < 100 then
				efir.custom.sendInterval[0] = 100
			elseif efir.custom.sendInterval[0] > 10000 then
				efir.custom.sendInterval[0] = 10000
			end
			saveConfig()
		end
		imgui.PopStyleColor(3)
		imgui.PopItemWidth()
		imgui.SameLine()
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0] * 1.2, item[1] * 1.2, item[2] * 1.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0] * 1.4, item[1] * 1.4, item[2] * 1.4, 1))
		if imgui.Button('+##IncInterval', imgui.ImVec2(20, 20)) then
			efir.custom.sendInterval[0] = math.min(10000, efir.custom.sendInterval[0] + 100)
			saveConfig()
		end
		imgui.PopStyleColor(3)
		if imgui.IsItemHovered() or imgui.IsItemHovered(-1) then
			imgui.SetTooltip('Интервал между отправкой строк (100-10000 мс)')
		end
	else
		efir.custom.sendInterval[0] = 3000
		imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), '(Автоматический режим: 3000 мс)')
	end
	imgui.Spacing()
	if next(efir.custom.list) then
		imgui.Text('Ваши эфиры:')
		imgui.Separator()
		local buttonsPerRow = 4
		local buttonWidth = (imgui.GetWindowWidth() - 40 - (buttonsPerRow - 1) * 5) / buttonsPerRow
		local buttonCount = 0
		for key, efirData in pairs(efir.custom.list) do
			if buttonCount > 0 and buttonCount % buttonsPerRow ~= 0 then
				imgui.SameLine()
			end
			local isSelected = efir.custom.selected == key
			if isSelected then
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.8, 0.2, 1))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.9, 0.3, 1))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.1, 0.7, 0.1, 1))
			else
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0] * 1.2, item[1] * 1.2, item[2] * 1.2, 1))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0] * 1.4, item[1] * 1.4, item[2] * 1.4, 1))
			end
			if imgui.Button(efirData.name .. '##efir_' .. key, imgui.ImVec2(buttonWidth, 30)) then
				efir.custom.selected = key
				loadCustomEfirs(key)
			end
			if imgui.IsItemHovered() and imgui.IsMouseDoubleClicked(0) then
				efir.custom.list[key] = nil
				if efir.custom.selected == key then
					efir.custom.selected = nil
					efir.custom.lines = {}
				end
				saveCustomEfirs()
				chatMessage(u8:decode('[News Helper] Эфир "' .. efirData.name .. '" удален!'), 0xFF0000)
			end
			if imgui.IsItemHovered() then
				imgui.SetTooltip('Двойной клик для удаления')
			end
			imgui.PopStyleColor(3)
			buttonCount = buttonCount + 1
		end
		imgui.Spacing()
		imgui.Separator()
		imgui.Spacing()
		if efir.custom.selected and efir.custom.list[efir.custom.selected] then
			renderCustomEfirEditor()
		end
	else
		imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'Нет созданных эфиров. Нажмите "Добавить эфир" для начала.')
	end
	renderAddCustomEfirPopup()
end
function renderCustomEfirEditor()
	local efirData = efir.custom.list[efir.custom.selected]
	if not efirData then return end
	local bg = settings.colors.background
	local item = settings.colors.itemButtons
	local inputBgColor = imgui.ImVec4(bg[0] * 0.5, bg[1] * 0.5, bg[2] * 0.5, 1)
	local inputBgColorHovered = imgui.ImVec4(bg[0] * 0.7, bg[1] * 0.7, bg[2] * 0.7, 1)
	local inputBgColorActive = imgui.ImVec4(bg[0] * 0.9, bg[1] * 0.9, bg[2] * 0.9, 1)
	imgui.Text('Редактирование: ' .. efirData.name)
	imgui.Text('/startefir ' .. efir.custom.selected .. ' - для запуска эфира')
	imgui.Text('/stopefir ' .. efir.custom.selected .. ' - для завершения эфира')
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.6, 0.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.7, 0.3, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.5, 0.1, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('floppy_disk') .. ' Сохранить', imgui.ImVec2(120, 25)) then
		if fa_font then imgui.PopFont() end
		if efir.custom.viewMode == 'square' then
			convertSquareToLines()
		elseif efir.custom.viewMode == 'bars' then
			convertLinesToSquare()
		end
		saveCustomEfirs()
		sampAddChatMessage(u8:decode('[News Helper] Эфир сохранен!'), 0x00FF00)
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	imgui.SameLine()
	imgui.SetCursorPosX(imgui.GetWindowWidth() - 140)
	local viewModeIcon = efir.custom.viewMode == 'bars' and fa('square') or fa('bars')
	local viewModeTooltip = efir.custom.viewMode == 'bars' and 'Переключить на большое поле' or 'Переключить на строки'
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0] * 1.2, item[1] * 1.2, item[2] * 1.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0] * 1.4, item[1] * 1.4, item[2] * 1.4, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(viewModeIcon .. ' Режим вида', imgui.ImVec2(120, 25)) then
		if fa_font then imgui.PopFont() end
		if efir.custom.viewMode == 'bars' then
			convertLinesToSquare()
			efir.custom.viewMode = 'square'
		else
			convertSquareToLines()
			efir.custom.viewMode = 'bars'
		end
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	if imgui.IsItemHovered() then
		imgui.SetTooltip(viewModeTooltip)
	end
	imgui.Spacing()
	imgui.Separator()
	imgui.Spacing()
	if efir.custom.viewMode == 'square' then
		renderSquareMode()
		return
	end
	imgui.BeginChild('##CustomEfirLines', imgui.ImVec2(0, -1), false)
	if not efir.custom.lines or #efir.custom.lines == 0 then
		efir.custom.lines = {{ text = imgui.new.char[512]("") }}
	end
	local toDelete = nil
	local mousePos = imgui.GetMousePos()
	local childPos = imgui.GetWindowPos()
	local scrollY = imgui.GetScrollY()
	local lineHeight = 30
	local lineSpacing = 5
	local n = #efir.custom.lines
	local targetInsertIndex = nil
	if not flags.focusLineIndex then flags.focusLineIndex = nil end
	if flags.draggingLineIndex and flags.draggingLineIndex > 0 and flags.draggingLineIndex <= n then
		local relativeMouseY = mousePos.y - childPos.y + scrollY
		targetInsertIndex = 1
		local accumulatedHeight = 0
		for i = 1, n do
			local currentLineCenter = accumulatedHeight + (lineHeight / 2)
			if relativeMouseY > currentLineCenter then
				targetInsertIndex = i + 1
			end
			accumulatedHeight = accumulatedHeight + lineHeight + lineSpacing
		end
		targetInsertIndex = math.max(1, math.min(targetInsertIndex, n + 1))
	end
	for i = 1, n do
		local line = efir.custom.lines[i]
		if not line then
			efir.custom.lines[i] = { text = imgui.new.char[512]("") }
			line = efir.custom.lines[i]
		end
		local skipLine = (flags.draggingLineIndex == i)
		if flags.draggingLineIndex and targetInsertIndex == i and targetInsertIndex ~= flags.draggingLineIndex then
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.3, 0.8, 0.3, 0.3))
			imgui.Button('← Вставить сюда →##dropzone' .. i, imgui.ImVec2(-1, 20))
			imgui.PopStyleColor()
			imgui.Spacing()
		end
		if not skipLine then
			imgui.PushIDInt(i)
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
			local dragText = '↕'
			if fa_font then
				imgui.PushFont(fa_font)
				dragText = fa.ICON_FA_ARROWS_ALT_V or '↕'
			end
			if imgui.Button(dragText .. '##drag' .. i, imgui.ImVec2(25, 20)) then
			end
			if imgui.IsItemHovered() then
				imgui.SetTooltip('Нажмите и удерживайте для перемещения.')
			end
			if fa_font then imgui.PopFont() end
			if imgui.IsItemActive() and not imgui.IsItemHovered() then
				if not flags.draggingLineIndex then
					flags.draggingLineIndex = i
					local lineY = childPos.y - scrollY
					local accHeight = 0
					for j = 1, i - 1 do
						accHeight = accHeight + lineHeight + lineSpacing
					end
					lineY = lineY + accHeight
					dragOffsetY = mousePos.y - lineY
					dragOffsetY = math.max(0, math.min(dragOffsetY, lineHeight))
				end
			end
			imgui.PopStyleColor(3)
			imgui.SameLine()
			imgui.PushItemWidth(-55)
			if flags.focusLineIndex == i then
				imgui.SetKeyboardFocusHere()
				flags.focusLineIndex = nil
			end
			local enterPressed = imgui.InputText('##text' .. i, line.text, ffi.sizeof(line.text), imgui.InputTextFlags.EnterReturnsTrue)
			imgui.PopItemWidth()
			if enterPressed then
				table.insert(efir.custom.lines, i + 1, { text = imgui.new.char[512]("") })
				tabWindowSizes[8].y = calculateFreeEfirTabHeight()
				saveCustomEfirs()
				flags.focusLineIndex = i + 1
				flags.needScrollToBottom = true
			end
			imgui.SameLine()
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.2, 0.2, 1))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.3, 0.3, 1))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.1, 0.1, 1))
			if imgui.Button('X##del' .. i, imgui.ImVec2(25, 20)) then
				if n > 1 then toDelete = i end
			end
			imgui.PopStyleColor(3)
			imgui.PopID()
		else
			imgui.Dummy(imgui.ImVec2(0, lineHeight))
		end
		imgui.Spacing()
	end
	if flags.draggingLineIndex and targetInsertIndex == n + 1 then
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.3, 0.8, 0.3, 0.3))
		imgui.Button('← Вставить в конец →##dropzoneend', imgui.ImVec2(-1, 20))
		imgui.PopStyleColor()
	end
	if flags.draggingLineIndex then
		local windowHeight = imgui.GetWindowHeight()
		local relativeMouseY = mousePos.y - childPos.y
		local scrollZone = 40 
		local scrollSpeed = 5 
		local scrollMultiplier = 1
		if relativeMouseY < scrollZone and imgui.GetScrollY() > 0 then
			scrollMultiplier = 1 - (relativeMouseY / scrollZone) 
			local currentScroll = imgui.GetScrollY()
			local newScroll = math.max(0, currentScroll - (scrollSpeed * (1 + scrollMultiplier * 2)))
			imgui.SetScrollY(newScroll)
			local drawList = imgui.GetWindowDrawList()
			local getColorU32 = imgui.GetColorU32Vec4 or imgui.ColorConvertFloat4ToU32
			if getColorU32 then
				drawList:AddRectFilled(
					imgui.ImVec2(childPos.x, childPos.y),
					imgui.ImVec2(childPos.x + imgui.GetWindowWidth(), childPos.y + 3),
					getColorU32(imgui.ImVec4(0.3, 0.8, 0.3, 0.3 + scrollMultiplier * 0.4))
				)
			end
		end
		if relativeMouseY > windowHeight - scrollZone and imgui.GetScrollY() < imgui.GetScrollMaxY() then
			scrollMultiplier = (relativeMouseY - (windowHeight - scrollZone)) / scrollZone 
			local currentScroll = imgui.GetScrollY()
			local maxScroll = imgui.GetScrollMaxY()
			local newScroll = math.min(maxScroll, currentScroll + (scrollSpeed * (1 + scrollMultiplier * 2)))
			imgui.SetScrollY(newScroll)
			local drawList = imgui.GetWindowDrawList()
			local getColorU32 = imgui.GetColorU32Vec4 or imgui.ColorConvertFloat4ToU32
			if getColorU32 then
				drawList:AddRectFilled(
					imgui.ImVec2(childPos.x, childPos.y + windowHeight - 3),
					imgui.ImVec2(childPos.x + imgui.GetWindowWidth(), childPos.y + windowHeight),
					getColorU32(imgui.ImVec4(0.3, 0.8, 0.3, 0.3 + scrollMultiplier * 0.4))
				)
			end
		end
	end
	if flags.draggingLineIndex and efir.custom.lines[flags.draggingLineIndex] then
		local drawList = imgui.GetWindowDrawList()
		local line = efir.custom.lines[flags.draggingLineIndex]
		local dragPosX = childPos.x + 10
		local dragPosY = mousePos.y - (dragOffsetY or (lineHeight / 2))
		local getColorU32 = imgui.GetColorU32Vec4 or imgui.ColorConvertFloat4ToU32
		if getColorU32 then
			drawList:AddRectFilled(
				imgui.ImVec2(dragPosX, dragPosY),
				imgui.ImVec2(dragPosX + imgui.GetWindowWidth() - 30, dragPosY + lineHeight),
				getColorU32(imgui.ImVec4(inputBgColor.x, inputBgColor.y, inputBgColor.z, 0.97)),
				5
			)
			local text = ""
			if line and line.text then
				local success, result = pcall(ffi.string, line.text)
				if success then
					text = result
				end
			end
			if text == "" then text = "[Пустая строка]" end
			if #text > 50 then text = text:sub(1, 47) .. "..." end
			drawList:AddText(
				imgui.ImVec2(dragPosX + 30, dragPosY + 5),
				getColorU32(imgui.ImVec4(1, 1, 1, 1)),
				text
			)
		end
	end
	if flags.draggingLineIndex and not imgui.IsMouseDown(0) then
		if targetInsertIndex and targetInsertIndex ~= flags.draggingLineIndex and 
			flags.draggingLineIndex > 0 and flags.draggingLineIndex <= n then
			local movingLine = table.remove(efir.custom.lines, flags.draggingLineIndex)
			if movingLine then
				local insertPos = targetInsertIndex
				if insertPos > flags.draggingLineIndex then
					insertPos = insertPos - 1
				end
				insertPos = math.max(1, math.min(insertPos, #efir.custom.lines + 1))
				table.insert(efir.custom.lines, insertPos, movingLine)
				saveCustomEfirs()
			end
		end
		flags.draggingLineIndex = nil
		dragOffsetY = nil
	end
	if not flags.draggingLineIndex then
		imgui.Dummy(imgui.ImVec2(25, 20))
		imgui.SameLine()
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(inputBgColor.x, inputBgColor.y, inputBgColor.z, 0.5))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(inputBgColorHovered.x, inputBgColorHovered.y, inputBgColorHovered.z, 0.7))
		imgui.PushStyleColor(imgui.Col.ButtonActive, inputBgColorActive)
		imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1, 1, 1, 0.5))
		local buttonWidth = imgui.GetContentRegionAvail().x - 30
		local buttonText = 'Нажмите Enter ' .. fa('arrow_turn_down_left') .. ' или кликните мышью чтобы добавить строку.##addnewline'
		if imgui.Button(buttonText, imgui.ImVec2(buttonWidth, 20)) then
			table.insert(efir.custom.lines, { text = imgui.new.char[512]("") })
			saveCustomEfirs()
			flags.focusLineIndex = #efir.custom.lines
			flags.needScrollToBottom = true 
		end
		imgui.PopStyleColor(4)
		imgui.SameLine()
		imgui.Dummy(imgui.ImVec2(25, 20))
	end
	if toDelete and toDelete > 0 and toDelete <= #efir.custom.lines then
		table.remove(efir.custom.lines, toDelete)
		tabWindowSizes[8].y = calculateFreeEfirTabHeight()
		saveCustomEfirs()
	end
	if flags.needScrollToBottom then
		imgui.SetScrollHereY(1.0)
		flags.needScrollToBottom = false
	end
	imgui.EndChild()
end
function renderAddCustomEfirPopup()
	local bg = settings.colors.background
	local item = settings.colors.itemButtons
	local inputBgColor = imgui.ImVec4(bg[0] * 0.5, bg[1] * 0.5, bg[2] * 0.5, 1)
	local inputBgColorHovered = imgui.ImVec4(bg[0] * 0.7, bg[1] * 0.7, bg[2] * 0.7, 1)
	local inputBgColorActive = imgui.ImVec4(bg[0] * 0.9, bg[1] * 0.9, bg[2] * 0.9, 1)
	imgui.PushStyleColor(imgui.Col.PopupBg, imgui.ImVec4(bg[0], bg[1], bg[2], 0.98))
	imgui.PushStyleColor(imgui.Col.TitleBg, imgui.ImVec4(item[0], item[1], item[2], 1))
	imgui.PushStyleColor(imgui.Col.TitleBgActive, imgui.ImVec4(item[0] * 1.1, item[1] * 1.1, item[2] * 1.1, 1))
	if imgui.BeginPopupModal('AddCustomEfir', nil, imgui.WindowFlags.AlwaysAutoResize) then
		if not efir.custom.newName then
			efir.custom.newName = imgui.new.char[128]()
			efir.custom.newKey = imgui.new.char[64]()
		end
		if imgui.IsKeyPressed(imgui.Key.Escape) then
			imgui.CloseCurrentPopup()
			efir.custom.newName = nil
			efir.custom.newKey = nil
		end
		imgui.Text('Создание нового эфира:')
		imgui.Separator()
		imgui.Text('Название эфира:')
		imgui.PushItemWidth(300)
		local nameEnter = imgui.InputText('##EfirName', efir.custom.newName, 128, imgui.InputTextFlags.EnterReturnsTrue)
		imgui.PopItemWidth()
		imgui.Text('Ключ (латиницей):')
		imgui.PushItemWidth(200)
		local keyEnter = imgui.InputText('##EfirKey', efir.custom.newKey, 64, imgui.InputTextFlags.EnterReturnsTrue)
		imgui.PopItemWidth()
		imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'Например: math, interview, custom1')
		imgui.Separator()
		local winW = imgui.GetWindowWidth() or 400
		local buttonWidth = (winW - 50) / 2
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0] * 1.2, item[1] * 1.2, item[2] * 1.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0] * 1.4, item[1] * 1.4, item[2] * 1.4, 1))
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(fa('xmark') .. ' Отмена', imgui.ImVec2(buttonWidth, 30)) then
			if fa_font then imgui.PopFont() end
			imgui.CloseCurrentPopup()
			efir.custom.newName = nil
			efir.custom.newKey = nil
		end
		if fa_font then imgui.PopFont() end
		imgui.PopStyleColor(3)
		imgui.SameLine()
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0] * 1.2, item[1] * 1.2, item[2] * 1.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0] * 1.4, item[1] * 1.4, item[2] * 1.4, 1))
		local shouldAdd = false
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(fa('circle_plus') .. ' Создать', imgui.ImVec2(buttonWidth, 30)) then
			shouldAdd = true
		end
		if fa_font then imgui.PopFont() end
		imgui.PopStyleColor(3)
		shouldAdd = shouldAdd or nameEnter or keyEnter
		if shouldAdd then
			local name = ffi.string(efir.custom.newName)
			local key = ffi.string(efir.custom.newKey)
			if name ~= '' and key ~= '' and key:match("^[a-zA-Z0-9_]+$") then
				if not efir.custom.list[key] then
					efir.custom.list[key] = {
						name = name,
						lines = {}
					}
					efir.custom.selected = key
					efir.custom.lines = {}
					saveCustomEfirs()
					sampAddChatMessage(u8:decode('[News Helper] Эфир "' .. name .. '" создан!'), 0x00FF00)
					imgui.CloseCurrentPopup()
					efir.custom.newName = nil
					efir.custom.newKey = nil
				else
					sampAddChatMessage(u8:decode('[News Helper] Эфир с таким ключом уже существует!'), 0xFF0000)
				end
			else
				sampAddChatMessage(u8:decode('[News Helper] Заполните все поля! Ключ только латиница.'), 0xFF0000)
			end
		end
	end
	imgui.PopStyleColor(3)
end
function getEfirMessageOrder(efirType)
	if not efir.messages[efirType] then
		return {start = {}, additional = {}, end_messages = {}}
	end
	local messages = efir.messages[efirType]
	local start = {}
	local additional = {}
	local end_messages = {}
	for key, _ in pairs(messages) do
		if key:match("^msg%d+$") then
			table.insert(start, key)
		elseif key == "first" or key == "next" then
			table.insert(start, key)
		elseif key:match("^end%d+$") then
			table.insert(end_messages, key)
		else
			table.insert(additional, key)
		end
	end
	local function compareKeys(a, b)
		local numA = tonumber(a:match("%d+"))
		local numB = tonumber(b:match("%d+"))
		if numA and numB then
			return numA < numB
		end
		return a < b
	end
	table.sort(start, compareKeys)
	table.sort(additional, compareKeys)
	table.sort(end_messages, compareKeys)
	local msgKeys = {}
	local firstKey = nil
	local nextKey = nil
	for _, key in ipairs(start) do
		if key == "first" then
			firstKey = key
		elseif key == "next" then
			nextKey = key
		else
			table.insert(msgKeys, key)
		end
	end
	if firstKey then table.insert(msgKeys, firstKey) end
	if nextKey then table.insert(msgKeys, nextKey) end
	return {
		start = msgKeys,
		additional = additional,
		end_messages = end_messages
	}
end
function getEfirMessageDisplayName(msgKey, efirType)
	if efir.messageDisplayNames and efir.messageDisplayNames[efirType] and efir.messageDisplayNames[efirType][msgKey] then
		return efir.messageDisplayNames[efirType][msgKey]
	end
	local names = {
		msg1 = 'Сообщение 1',
		msg2 = 'Сообщение 2', 
		msg3 = 'Сообщение 3',
		msg4 = 'Сообщение 4',
		msg5 = 'Сообщение 5',
		msg5_2 = 'Сообщение 5.2',
		msg6 = 'Сообщение 6',
		msg7 = 'Сообщение 7',
		msg8 = 'Сообщение 8',
		msg9 = 'Сообщение 9',
		msg10 = 'Сообщение 10',
		msg11 = 'Сообщение 11',
		msg12 = 'Сообщение 12',
		msg13 = 'Сообщение 13',
		msg14 = 'Сообщение 14',
		first = 'Первый вопрос/пример',
		next = 'Следующий вопрос/пример',
		ball1 = '1 балл',
		['ball1.2'] = '1 балл (вариант 2)',
		ball2 = '2-4 балла', 
		['ball2.2'] = '2-4 балла (вариант 2)',
		ball5 = '5-10 баллов',
		['ball5.2'] = '5-10 баллов (вариант 2)',
		winner1 = 'Победитель 1',
		winner2 = 'Победитель 2',
		winner3 = 'Победитель 3',
		end1 = 'Конец 1',
		end2 = 'Конец 2',
		end3 = 'Конец 3',
		end4 = 'Конец 4',
		end5 = 'Конец 5',
		introduce = 'Представление гостя',
		introduce2 = 'Переход к вопросам',
		question1 = 'Вопрос 1',
		question2 = 'Вопрос 2',
		question3 = 'Вопрос 3',
		question4 = 'Вопрос 4',
		stop1 = 'Завершение 1',
		stop2 = 'Завершение 2',
		stop3 = 'Завершение 3',
		stop4 = 'Завершение 4',
		stop5 = 'Завершение 5',
		stop6 = 'Завершение 6',
		stop7 = 'Завершение 7',
		stop8 = 'Завершение 8',
		stop9 = 'Завершение 9',
		stop10 = 'Завершение 10'
	}
	return names[msgKey] or msgKey
end
function renderVariablesButton()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.6, 0.8, 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.7, 0.9, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.1, 0.5, 0.7, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('code') .. ' Переменные', imgui.ImVec2(100, 25)) then
	if fa_font then imgui.PopFont() end
		helpers.showVariablesHelp[0] = not helpers.showVariablesHelp[0]
	end
	imgui.PopStyleColor(3)
	if helpers.showVariablesHelp[0] then
		imgui.SameLine()
		imgui.BeginChild('##VariablesHelp', imgui.ImVec2(400, 140), true)
		imgui.Text('Доступные переменные:')
		imgui.Separator()
		imgui.TextColored(imgui.ImVec4(0.8, 1, 0.8, 1), '# - Ник ведущего')
		imgui.TextColored(imgui.ImVec4(0.8, 1, 0.8, 1), '#1 - Ранг ведущего')  
		imgui.TextColored(imgui.ImVec4(1, 0.8, 0.8, 1), '* - Имя победителя')
		imgui.TextColored(imgui.ImVec4(1, 0.8, 0.8, 1), '*1 - Ник для балла')
		imgui.TextColored(imgui.ImVec4(0.8, 0.8, 1, 1), '%% - Количество баллов')
		imgui.TextColored(imgui.ImVec4(1, 1, 0.8, 1), '*2 - Денежная сумма')
		imgui.Separator()
		imgui.TextColored(imgui.ImVec4(1, 1, 0.5, 1), 'Вариации:')
		imgui.Text('ball1.2, ball2.3 и т.д. для чередования')
		imgui.EndChild()
	end
end
function isRequiredMessage(msgKey, efirType)
	local required = {
		msg1 = true,
		msg2 = true,
		msg3 = true,
		end1 = true,
		end5 = true
	}
	return required[msgKey] or false
end
function renderResetEfirConfirmation()
	if imgui.BeginPopupModal('ConfirmResetEfir', nil, imgui.WindowFlags.AlwaysAutoResize) then
		imgui.Text('Вы уверены, что хотите сбросить все сообщения эфиров?')
		imgui.Text('Все ваши изменения будут потеряны!')
		imgui.Separator()
		local item = settings.colors.itemButtons
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.2, 0.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.3, 0.3, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.1, 0.1, 1))
		if imgui.Button('Да, сбросить', imgui.ImVec2(120, 0)) then
			resetEfirMessagesToDefault()
			imgui.CloseCurrentPopup()
		end
		imgui.PopStyleColor(3)
		imgui.SameLine()
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0] * 1.2, item[1] * 1.2, item[2] * 1.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0] * 1.4, item[1] * 1.4, item[2] * 1.4, 1))
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(fa('xmark') .. ' Отмена', imgui.ImVec2(buttonWidth, 30)) then
		if fa_font then imgui.PopFont() end
			imgui.CloseCurrentPopup()
		end
		imgui.PopStyleColor(3)
		imgui.EndPopup()
	end
end
function resetAllEfirMessages()
	imgui.OpenPopup('ConfirmResetEfir')
end
function addball(name)
	if efir.counter[name] ~= nil then
		efir.counter[name] = efir.counter[name] + 1
	else 
		efir.counter[name] = 1
	end
end
function trst(name)
	if translitExceptions[name] then
		return translitExceptions[name]
	end
	if name:match('%a+') then
		for k, v in pairs(trstl1) do
			name = name:gsub(k, v) 
		end
		for k, v in pairs(trstl) do
			name = name:gsub(k, v) 
		end
		return name
	end
	return name
end
function getPlayerNickTranslated()
	local _, myId = sampGetPlayerIdByCharHandle(PLAYER_PED)
	if myId then
		local nickname = sampGetPlayerNickname(myId)
		if nickname then
			local cleanNick = nickname:gsub("%[PC%]", ""):gsub("%[M%]", ""):gsub("%[%d+%]", ""):gsub("^%s+", ""):gsub("%s+$", "")
			if translitExceptions[cleanNick] then
				return translitExceptions[cleanNick]
			end
			local forTranslit = cleanNick:gsub("_", " ")
			return trst(forTranslit)
		end
	end
	return ""
end
function detectMyRank()
	if not sampIsLocalPlayerSpawned() then return end
	settings.checker.detectingRank = true
	lua_thread.create(function()
		wait(100)
		if not sampIsChatInputActive() and not sampIsDialogActive() then
			sampSendChat("/members")
			settings.checker.waiting = true
			settings.checker.requestTime = os.clock()
		end
	end)
end
function getMyRankFromMembers()
	local _, myId = sampGetPlayerIdByCharHandle(PLAYER_PED)
	if not myId then return nil end
	local myNick = sampGetPlayerNickname(myId)
	if not myNick or myNick == "" then return nil end
	local function normalize(str)
		str = str:gsub("%[PC%]", ""):gsub("%[M%]", "")
		str = str:gsub("%[%d+%]", "")
		str = str:gsub("^%s*(.-)%s*$", "%1")
		str = str:lower()
		return str
	end
	local cleanMyNick = normalize(myNick)
	if not data.membersList or #data.membersList == 0 then
		return nil
	end
	for i, member in ipairs(data.membersList) do
		if type(member.name) == "string" then
			local cleanMemberName = normalize(member.name)
			if cleanMemberName == cleanMyNick then
				local pos = member.position:match("^(.-)%s*%[") or member.position
				pos = pos:gsub("^%s*(.-)%s*$", "%1")
				data.myRankNumber = member.rank or 0
				return pos
			end
		end
	end
	return nil
end
function initUserVariables()
	if not user then user = {} end
	local function safeChar(v)
		if type(v) ~= "cdata" then
			return ffi.new("char[256]", "")
		end
		return v
	end
	user.nick = safeChar(user.nick)
	user.rang = safeChar(user.rang)
	user.org  = safeChar(user.org)
	user.city = safeChar(user.city)
end
function safeAutoDetect()
	if not isSampAvailable() or not sampIsLocalPlayerSpawned() then return end
	if isDevMode then return end
	local translatedNick = getPlayerNickTranslated()
	if translatedNick ~= "" and (not data.mainIni.config.c_nick or data.mainIni.config.c_nick == "") then
		data.mainIni.config.c_nick = translatedNick
		if user.nick then ffi.copy(user.nick, translatedNick) end
		saveConfig()
	end
	detectMyRank()
end
function checkUserData()
	if data.mainIni and data.mainIni.config then
		local name = data.mainIni.config['c_nick']
		if name and name ~= '' and name ~= ' ' then
			return true
		end
	end
	return false
end
function resetEfirMessagesToDefault(efirType)
	if efirType == 'all' then
		local allTypes = {'math', 'country', 'himia', 'zerkalo', 'annagramm', 'zagadki', 'sinonim', 'inter', 'reklama', 'sobes'}
		for _, type in ipairs(allTypes) do
			resetEfirMessagesToDefault(type)
		end
		saveEfirMessagesToFile()
		chatMessage(u8:decode('[News Helper] Все эфиры сброшены к дефолтным значениям'), 0x00FF00)
		return
	end
	if not efir.messages then
		efir.messages = {}
	end
	if efir.messages[efirType] then
		for key, _ in pairs(efir.messages[efirType]) do
			efir.messages[efirType][key] = nil
		end
	else
		efir.messages[efirType] = {}
	end
	if efir.messageDisplayNames and efir.messageDisplayNames[efirType] then
		efir.messageDisplayNames[efirType] = {}
	end
	local defaults = {
		math = {
			msg1 = "/todo Начнем..* включив микрофон.",
			msg2 = " •°•°•°•° Музыкальная заставка Voice of Inner City •°•°•°•°•",
			msg3 = " Добрый день, уважаемые радиослушатели! У микрофона #..",
			msg4 = "Сегодня я проведу эфир на тему \"Математика\"..",
			msg5 = "..я называю пример - Вы ответ в СМС по номеру 1-1-1-1!",
			msg6 = "Призовой фонд составляет целых *2$!",
			msg7 = "А мы играем до 10 баллов!",
			msg8 = "Начинаем!",
			first = "Первый пример..",
			next = "Следующий пример..",
			ball1 = "*1 зарабатывает % балл!",
			["ball1.2"] = "*1 получает % балл!",
			ball2 = "*1 зарабатывает % балла!",
			["ball2.2"] = "*1 получает % балла!",
			ball5 = "*1 зарабатывает % баллов!",
			["ball5.2"] = "*1 получает % баллов!",
			winner1 = "И у нас есть победитель!",
			winner2 = "Побеждает * - первый набрал 10 баллов и получает приз!",
			winner3 = "Просим победителя приехать в нашу редакцию для получения приза.",
			end1 = "На этом наш эфир подходит к концу.",
			end2 = "С вами был #1 - #!",
			end3 = "До свидания, штат. Оставайтесь на волне!",
			end4 = "•°•°•°•° Музыкальная заставка •°•°•°•°•",
			end5 = "/todo Вот и всё..* выключив микрофон."
		},
		country = {
			msg1 = "/todo Начнем..* включив микрофон.",
			msg2 = " •°•°•°•° Музыкальная заставка Voice of Inner City •°•°•°•°•",
			msg3 = "Добрый день, уважаемые радиослушатели! У микрофона #",
			msg4 = "Сегодня я проведу эфир на тему \"Столицы\"..",
			msg5 = "..я называю страну - Вы столицу в СМС по номеру 1-1-1-1!",
			msg6 = "Призовой фонд составляет целых *2$!",
			msg7 = "А мы играем до 10 баллов! Начинаем!",
			first = "Первая страна..",
			next = "Следующая страна..",
			ball1 = "*1 зарабатывает % балл!",
			["ball1.2"] = "*1 получает % балл!",
			ball2 = "*1 зарабатывает % балла!",
			["ball2.2"] = "*1 получает % балла!",
			ball5 = "*1 зарабатывает % баллов!",
			["ball5.2"] = "*1 получает % баллов!",
			winner1 = "И у нас есть победитель!",
			winner2 = "Побеждает * - первый набрал 10 баллов и получает приз!",
			winner3 = "Просим победителя приехать в нашу редакцию для получения приза.",
			end1 = "На этом наш эфир подходит к концу.",
			end2 = "С вами был #1 - #!",
			end3 = "До свидания, штат. Оставайтесь на волне!",
			end4 = "•°•°•°•° Музыкальная заставка •°•°•°•°•",
			end5 = "/todo На этом всё..* выключив микрофон."
		},
		himia = {
			msg1 = "/todo Начнем..* включив микрофон.",
			msg2 = " •°•°•°•° Музыкальная заставка Voice of Inner City •°•°•°•°•",
			msg3 = "Добрый день, уважаемые радиослушатели! У микрофона #",
			msg4 = "Сегодня я проведу эфир на тему \"Химия\"..",
			msg5 = "..я называю элемент - Вы его название в СМС по номеру 1-1-1-1!",
			msg6 = "Призовой фонд составляет целых *2$!",
			msg7 = "А мы играем до 10 баллов! Начинаем!",
			first = "Первый элемент..",
			next = "Следующий элемент..",
			ball1 = "*1 зарабатывает % балл!",
			["ball1.2"] = "*1 получает % балл!",
			ball2 = "*1 зарабатывает % балла!",
			["ball2.2"] = "*1 получает % балла!",
			ball5 = "*1 зарабатывает % баллов!",
			["ball5.2"] = "*1 получает % баллов!",
			winner1 = "И у нас есть победитель!",
			winner2 = "Побеждает * - первый набрал 10 баллов и получает приз!",
			winner3 = "Просим победителя приехать в нашу редакцию для получения приза.",
			end1 = "На этом наш эфир подходит к концу.",
			end2 = "С вами был #1 - #!",
			end3 = "До свидания, штат. Оставайтесь на волне!",
			end4 = "•°•°•°•° Музыкальная заставка •°•°•°•°•",
			end5 = "/todo На этом всё..* выключив микрофон."
		},
		zerkalo = {
			msg1 = "/todo Начнем..* включив микрофон.",
			msg2 = " •°•°•°•° Музыкальная заставка Voice of Inner City •°•°•°•°•",
			msg3 = "Добрый день, уважаемые радиослушатели! У микрофона #",
			msg4 = "Сегодня я проведу эфир на тему \"Зеркало\"..",
			msg5 = "..я называю слово - Вы отправляете перевернутый вариант в СМС по номеру 1-1-1-1!",
			msg6 = "Призовой фонд составляет целых *2$!",
			msg7 = "А мы играем до 10 баллов! Начинаем!",
			first = "Первое слово..",
			next = "Следующее слово..",
			ball1 = "*1 зарабатывает % балл!",
			["ball1.2"] = "*1 получает % балл!",
			ball2 = "*1 зарабатывает % балла!",
			["ball2.2"] = "*1 получает % балла!",
			ball5 = "*1 зарабатывает % баллов!",
			["ball5.2"] = "*1 получает % баллов!",
			winner1 = "И у нас есть победитель!",
			winner2 = "Побеждает * - первый набрал 10 баллов и получает приз!",
			winner3 = "Просим победителя приехать в нашу редакцию для получения приза.",
			end1 = "На этом наш эфир подходит к концу.",
			end2 = "С вами был #1 - #!",
			end3 = "До свидания, штат. Оставайтесь на волне!",
			end4 = "•°•°•°•° Музыкальная заставка •°•°•°•°•",
			end5 = "/todo На этом всё..* выключив микрофон."
		},
		sobes = {
			msg1 = "/todo Начнем..*включив микрофон.",
			msg2 = "•°•°•°•° Музыкальная заставка Voice of Inner City •°•°•°•°•",
			msg3 = "Доброе время суток, уважаемые радиослушатели!",
			msg4 = "Вы находитесь на волне ВИС.",
			msg5 = "Возможно Вы давно хотели попробовать себя в роли ведущего?",
			msg6 = "Зарабатывать от 100.000$ в день?",
			msg7 = "Стать популярным и узнаваемым человеком в штате?",
			msg8 = "Именно сейчас, у вас есть такая возможность, ведь прямо сейчас...",
			msg9 = "...проходит собеседование в нашу редакцию.",
			msg10 = "Наш радиоцентр лучший из всех, что есть в штате.",
			msg11 = "Чтобы пройти собеседование вам нужно иметь при себе...",
			msg12 = "...паспорт, мед. карту, трудовую книгу и быть законопослушным гражданином.",
			msg13 = "Так-же вы можете подать заявку на оффициальном портале.",
			msg14 = "Не упускай свой шанс заработать, и стать популярной личностью!",
			msg15 = "•°•°•°•° Музыкальная заставка Voice of Inner City •°•°•°•°•",
			end1 = "/todo Начнем..*включив микрофон.",
			end2 = "•°•°•°•° Музыкальная заставка Voice of Inner City •°•°•°•°•",
			end3 = "Доброе время суток, уважаемые радиослушатели!",
			end4 = "Хочу сказать, что собеседование в редакцию окончено.",
			end5 = "Ждем вас на следующем собеседовании, или же..",
			end6 = "..ждём вашего заявления на оффициальном портале.",
			end7 = "На этом наш эфир подходит к концу.",
			end8 = "До свидания, штат. Оставайтесь на волне ВИС.",
			end9 = "•°•°•°•° Музыкальная заставка Voice of Inner City •°•°•°•°•",
			end10 = "/todo На этом всё..*выключив микрофон."
		},
		annagramm = {
			msg1 = "/todo Начнем..* включив микрофон.",
			msg2 = " •°•°•°•° Музыкальная заставка Voice of Inner City •°•°•°•°•",
			msg3 = "Добрый день, уважаемые радиослушатели! У микрофона #",
			msg4 = "Сегодня я проведу эфир на тему \"Анаграммы\"..",
			msg5 = "..я называю буквы из слова - Вы правильное слово в СМС по номеру 1-1-1-1!",
			msg6 = "Призовой фонд составляет целых *2$!",
			msg7 = "А мы играем до 10 баллов! Начинаем!",
			first = "Первые буквы..",
			next = "Следующие буквы..",
			ball1 = "*1 зарабатывает % балл!",
			["ball1.2"] = "*1 получает % балл!",
			ball2 = "*1 зарабатывает % балла!",
			["ball2.2"] = "*1 получает % балла!",
			ball5 = "*1 зарабатывает % баллов!",
			["ball5.2"] = "*1 получает % баллов!",
			winner1 = "И у нас есть победитель!",
			winner2 = "Побеждает * - первый набрал 10 баллов и получает приз!",
			winner3 = "Просим победителя приехать в нашу редакцию для получения приза.",
			end1 = "На этом наш эфир подходит к концу.",
			end2 = "С вами был #1 - #!",
			end3 = "До свидания, штат. Оставайтесь на волне!",
			end4 = "•°•°•°•° Музыкальная заставка •°•°•°•°•",
			end5 = "/todo На этом всё..* выключив микрофон."
		},
		zagadki = {
			msg1 = "/todo Начнем..* включив микрофон.",
			msg2 = " •°•°•°•° Музыкальная заставка Voice of Inner City •°•°•°•°•",
			msg3 = "Добрый день, уважаемые радиослушатели! У микрофона #",
			msg4 = "Сегодня я проведу эфир на тему \"Загадки\"..",
			msg5 = "..я загадываю загадку - Вы ответ в СМС по номеру 1-1-1-1!",
			msg6 = "Призовой фонд составляет целых *2$!",
			msg7 = "А мы играем до 10 баллов! Начинаем!",
			first = "Первая загадка..",
			next = "Следующая загадка..",
			ball1 = "*1 зарабатывает % балл!",
			["ball1.2"] = "*1 получает % балл!",
			ball2 = "*1 зарабатывает % балла!",
			["ball2.2"] = "*1 получает % балла!",
			ball5 = "*1 зарабатывает % баллов!",
			["ball5.2"] = "*1 получает % баллов!",
			winner1 = "И у нас есть победитель!",
			winner2 = "Побеждает * - первый набрал 10 баллов и получает приз!",
			winner3 = "Просим победителя приехать в нашу редакцию для получения приза.",
			end1 = "На этом наш эфир подходит к концу.",
			end2 = "С вами был #1 - #!",
			end3 = "До свидания, штат. Оставайтесь на волне!",
			end4 = "•°•°•°•° Музыкальная заставка •°•°•°•°•",
			end5 = "/todo На этом всё..* выключив микрофон."
		},
		sinonim = {
			msg1 = "/todo Начнем..* включив микрофон.",
			msg2 = " •°•°•°•° Музыкальная заставка Voice of Inner City •°•°•°•°•",
			msg3 = "Добрый день, уважаемые радиослушатели! У микрофона #",
			msg4 = "Сегодня я проведу эфир на тему \"Синонимы\"..",
			msg5 = "..я называю слово, а вы его синоним в СМС по номеру 1-1-1-1!",
			msg5_2 = "Например, я называю слово бежать, а вы - мчаться.",
			msg6 = "Призовой фонд составляет целых *2$!",
			msg7 = "А мы играем до 10 баллов! Начинаем!",
			first = "Первое слово..",
			next = "Следующее слово..",
			ball1 = "*1 зарабатывает % балл!",
			["ball1.2"] = "*1 получает % балл!",
			ball2 = "*1 зарабатывает % балла!",
			["ball2.2"] = "*1 получает % балла!",
			ball5 = "*1 зарабатывает % баллов!",
			["ball5.2"] = "*1 получает % баллов!",
			winner1 = "И у нас есть победитель!",
			winner2 = "Побеждает * - первый набрал 10 баллов и получает приз!",
			winner3 = "Просим победителя приехать в нашу редакцию для получения приза.",
			end1 = "На этом наш эфир подходит к концу.",
			end2 = "С вами был #1 - #!",
			end3 = "До свидания, штат. Оставайтесь на волне!",
			end4 = "•°•°•°•° Музыкальная заставка •°•°•°•°•",
			end5 = "/todo На этом всё..* выключив микрофон."
		},
		inter = {
			msg1 = "/todo Начнем..* включив микрофон.",
			msg2 = "•°•°•°•° Музыкальная заставка Voice of Inner City °•°•°•°•",
			msg3 = "Добрый день, уважаемые радиослушатели! У микрофона #",
			msg4 = "Вы находитесь на волне ВИС..",
			msg5 = "И сейчас я проведу интервью.",
			introduce = "Сегодня у нас в гостях *",
			introduce2 = "И сейчас я задам вам несколько вопросов.",
			question1 = "Как ваше настроение?",
			question2 = "Расскажите о себе.",
			question3 = "Есть ли у вас жена, дети?",
			question4 = "Хотели бы вы передать кому-нибудь приветы?",
			end1 = "На этом наше интервью подходит к концу.",
			end2 = "С вами был ведущий #1 - #!",
			end3 = "До свидания, штат. Оставайтесь на волне ВИС.",
			end4 = "•°•°•°•° Музыкальная заставка Voice of Inner City °•°•°•°•",
			end5 = "/todo Вот и всё..* выключив микрофон."
		},
		reklama = {
			msg1 = "/todo Начнем..* включив микрофон.",
			msg2 = "•°•°•°•° Музыкальная заставка Voice of Inner City •°•°•°•°•",
			msg3 = "Доброе время суток, уважаемые радиослушатели! У микрофона #",
			msg4 = "Вы находитесь на волне ВИС.",
			msg5 = "Сейчас прозвучит рекламная пауза.",
			end1 = "На этом наш эфир подходит к концу.",
			end2 = "С вами был #1 - #! До свидания, штат. Оставайтесь на волне ВИС.",
			end3 = "•°•°•°•° Музыкальная заставка Voice of Inner City •°•°•°•°•",
			end4 = "/todo На этом всё..* выключив микрофон."
		}
	}
	if defaults[efirType] then
		for key, value in pairs(defaults[efirType]) do
			local size = efir.messageSizes[key] or 512
			efir.messages[efirType][key] = imgui.new.char[size](value)
		end
	end
	saveEfirMessagesToFile()
end
function clearSearchCache()
	cache.search = {}
	cache.lower = {}
	ui.search.cachedResults = {}
	ui.search.resultsValid = false
end
function normalizeAnswer(text)
	if not text then return "" end
	text = text:lower()
	text = text:gsub("%s+", "")
	text = text:gsub("[%p%c]", "")
	return text
end
function checkSMSAnswer(smsText, correctAnswer)
	local normalized = normalizeAnswer(smsText)
	local correct = normalizeAnswer(correctAnswer)
	return normalized == correct
end
function sendNextQuestion()
	local currentType = efir.type or efir.selectedType or 'math'
	if efir.currentQuestion < 1 then
		efir.currentQuestion = 1
	end
	if efir.currentQuestion <= efirLineCount[currentType] then
		local example = ffi.string(efir.examples[currentType][efir.currentQuestion])
		if example ~= '' then
			lua_thread.create(function()
				local msgKey = efir.currentQuestion == 1 and "first" or "next"
				sampSendChat(u8:decode(ffi.string(efir.messages[currentType][msgKey])))
				wait(3000)
				sampSendChat(u8:decode(example))
				efir.awaitingAnswer = true
			end)
		end
	end
end
function replaceWaveTagInAllBinds(newTag)
	if not newTag or newTag == "" then
		chatMessage(u8:decode('[News Helper] Введите название волны!'), 0xFF0000)
		return false
	end
	if not data.newsHelpBind or type(data.newsHelpBind) ~= "table" then
		chatMessage(u8:decode('[News Helper] Ошибка: данные биндов не загружены!'), 0xFF0000)
		return false
	end
	local replacedCount = 0
	for catIndex = 1, #data.newsHelpBind do
		local category = data.newsHelpBind[catIndex]
		if category[1] ~= settings.bufferCategoryName then
			for bindIndex = 2, #category do
				local bind = category[bindIndex]
				if bind and bind[2] then
					local oldText = bind[2]
					local newText = oldText
					local firstBracketStart, firstBracketEnd = oldText:find("%[.-%]")
					if firstBracketStart then
						local beforeFirst = oldText:sub(1, firstBracketStart - 1)
						local afterFirst = oldText:sub(firstBracketEnd + 1)
						afterFirst = afterFirst:gsub("%[.-%]", "[]")
						newText = beforeFirst .. "[" .. newTag .. "]" .. afterFirst
						if oldText ~= newText then
							bind[2] = newText
							replacedCount = replacedCount + 1
						end
					end
				end
			end
		end
	end
	if replacedCount > 0 then
		data.mainIni.config.wave_tag = newTag
		saveConfig()
		saveHelpBinds()
		clearSearchCache()
		chatMessage(u8:decode(string.format('[News Helper] Заменено тегов в %d биндах (вариант %d)!', replacedCount, data.selectedBindsVariant)), 0x00FF00)
		return true
	else
		chatMessage(u8:decode('[News Helper] Теги уже совпадают с новым значением'), 0xFFFF00)
		return false
	end
end
function getWavePrefixFromBinds()
	if not data.newsHelpBind or #data.newsHelpBind == 0 then
		return "[" .. ffi.string(user.waveTag) .. "]"
	end
	for i = 1, #data.newsHelpBind do
		local category = data.newsHelpBind[i]
		if category[1] ~= settings.bufferCategoryName then
			for j = 2, #category do
				local bind = category[j]
				if bind and bind[2] then
					local prefix = bind[2]:match("^%[(.-)%]")
					if prefix then
						return "[" .. prefix .. "]"
					end
				end
			end
		end
	end
	return "[" .. ffi.string(user.waveTag) .. "]"
end
function calculateMathExpression(expression)
	if not expression or expression == "" then
		return nil, "Пустое выражение"
	end
	local cleanExpr = expression:gsub("%s+", "")
	if not cleanExpr:match("^[%d%+%*/%(%).%-]+$") then
		return nil, "Недопустимые символы"
	end
	local function addImplicitMultiplication(expr)
		local result = expr
		result = result:gsub("([%d%.])%(", "%1*(")
		result = result:gsub("%)([%d])", ")*%1")
		result = result:gsub("%)%(", ")*(")
		return result
	end
	cleanExpr = addImplicitMultiplication(cleanExpr)
	if cleanExpr:match("[%+%-*/][%+%-*/]") then
		if not (cleanExpr:match("%-%-") or cleanExpr:match("%+%-") or cleanExpr:match("%-%+")) then
			return nil, "Последовательные операторы"
		else
			cleanExpr = cleanExpr:gsub("%-%-", "+")
			cleanExpr = cleanExpr:gsub("%+%-", "-")
			cleanExpr = cleanExpr:gsub("%-%+", "-")
			cleanExpr = cleanExpr:gsub("%+%+", "+")
		end
	end
	if cleanExpr:match("^[%+%*/]") or cleanExpr:match("[%+%-*/]$") then
		return nil, "Оператор в начале или конце"
	end
	local openCount = 0
	for char in cleanExpr:gmatch(".") do
		if char == "(" then
			openCount = openCount + 1
		elseif char == ")" then
			openCount = openCount - 1
			if openCount < 0 then
				return nil, "Несбалансированные скобки"
			end
		end
	end
	if openCount ~= 0 then
		return nil, "Несбалансированные скобки"
	end
	if cleanExpr:match("%(%)") then
		return nil, "Пустые скобки"
	end
	if cleanExpr:match("%([%+%*/]") then
		return nil, "Оператор после открывающей скобки"
	end
	if cleanExpr:match("[%+%-*/]%)") then
		return nil, "Оператор перед закрывающей скобкой"
	end
	local func, err = loadstring("return " .. cleanExpr)
	if not func then
		return nil, "Ошибка в выражении"
	end
	local env = {
		math = math,
	}
	setfenv(func, env)
	local success, result = pcall(func)
	if success then
		if type(result) == "number" then
			if result == math.huge or result == -math.huge then
				return nil, "Деление на ноль"
			elseif result ~= result then
				return nil, "Неопределенный результат"
			end
			if math.floor(result) == result then
				return tostring(math.floor(result)), nil
			else
				local formatted = string.format("%.2f", result)
				formatted = formatted:gsub("%.?0+$", "")
				return formatted, nil
			end
		else
			return nil, "Неверный результат"
		end
	else
		return nil, "Ошибка вычисления"
	end
end
function saveEfirSettings()
	local efirData = {}
	for efirType, messages in pairs(efir.messages) do
		if type(messages) == "table" then
			efirData[efirType] = {
				messages = {},
				displayNames = {}
			}
			for key, charPtr in pairs(messages) do
				if type(charPtr) == "cdata" then
					efirData[efirType].messages[key] = ffi.string(charPtr)
				elseif type(charPtr) == "string" then
					efirData[efirType].messages[key] = charPtr
				else
					efirData[efirType].messages[key] = tostring(charPtr) or ""
				end
			end
			if efir.messageDisplayNames and efir.messageDisplayNames[efirType] then
				efirData[efirType].displayNames = efir.messageDisplayNames[efirType]
			end
		end
	end
	return efirData
end
function loadEfirSettings(efirData)
	if not efirData or type(efirData) ~= "table" then return end
	for efirType, efirTypeData in pairs(efirData) do
		if efir.messages[efirType] and type(efirTypeData) == "table" then
			local messages = efirTypeData.messages or efirTypeData 
			for key, text in pairs(messages) do
				if efir.messages[efirType][key] and type(text) == "string" then
					local success, size = pcall(function()
						return ffi.sizeof(efir.messages[efirType][key])
					end)
					if success and size then
						local maxSize = size - 1
						if #text > maxSize then
							text = text:sub(1, maxSize)
						end
						ffi.copy(efir.messages[efirType][key], text)
					else
						local bufferSize = efir.messageSizes[key] or 512
						efir.messages[efirType][key] = imgui.new.char[bufferSize](text)
					end
				end
			end
			if efirTypeData.displayNames then
				if not efir.messageDisplayNames then
					efir.messageDisplayNames = {}
				end
				efir.messageDisplayNames[efirType] = efirTypeData.displayNames
			end
		end
	end
end
function loadCustomEfirs()
	local filePath = settings.configFolder .. 'CustomEfirs.json'
	if doesFileExist(filePath) then
		local file = io.open(filePath, 'r')
		if file then
			local content = file:read('*a')
			file:close()
			local data = decodeJson(content)
			if data then
				efir.custom.list = data
				if efir.custom.selected and efir.custom.list[efir.custom.selected] and efir.custom.list[efir.custom.selected].lines then
					efir.custom.lines = {}
					for _, line in ipairs(efir.custom.list[efir.custom.selected].lines) do
						table.insert(efir.custom.lines, {
							name = line.name,
							text = imgui.new.char[512](line.text or "")
						})
					end
				else
					efir.custom.lines = {}
				end
				tabWindowSizes[8].y = calculateFreeEfirTabHeight()
				return true
			end
		end
	end
	efir.custom.list = {}
	efir.custom.lines = {}
	return false
end
function saveCustomEfirs()
	if efir.custom.selected and efir.custom.list[efir.custom.selected] then
		efir.custom.list[efir.custom.selected].lines = {}
		for _, line in ipairs(efir.custom.lines) do
			table.insert(efir.custom.list[efir.custom.selected].lines, {
				name = line.name,
				text = ffi.string(line.text)
			})
		end
	end
	local data = {}
	for key, efirData in pairs(efir.custom.list) do
		data[key] = {
			name = efirData.name,
			lines = efirData.lines or {}
		}
	end
	local filePath = settings.configFolder .. 'CustomEfirs.json'
	local file = io.open(filePath, 'w')
	if file then
		file:write(encodeJson(data))
		file:close()
		return true
	end
	return false
end
function sendAllCustomEfirLines()
	if not efir.custom.lines or #efir.custom.lines == 0 then
		chatMessage(u8:decode('[News Helper] Нет строк для отправки!'), 0xFF0000)
		return
	end
	lua_thread.create(function()
		for i, line in ipairs(efir.custom.lines) do
			local text = ffi.string(line.text)
			if text ~= '' then
				text = replaceEfirVariables(text)
				sampSendChat(u8:decode(text))
				wait(3000) 
			end
		end
		chatMessage(u8:decode('[News Helper] Все строки отправлены!'), 0x00FF00)
	end)
end
function startEfir(efirType)
	if not checkUserData() then 
		if not settings.silentMode[0] then
			chatMessage(u8:decode('[News Helper] Заполните данные пользователя!'), 0xFF0000)
		end
		return 
	end
	local messages = efir.messages[efirType]
	if not messages then
		if not settings.silentMode[0] then
			chatMessage(u8:decode('[News Helper] Неизвестный тип эфира: ' .. efirType), 0xFF0000)
		end
		return
	end
	if efirType == 'math' or efirType == 'country' or efirType == 'himia' or 
		efirType == 'zerkalo' or efirType == 'annagramm' or efirType == 'zagadki' or efirType == 'sinonim' then
		local hasExamples = false
		for i = 1, 10 do
			if ffi.string(efir.examples[efirType][i]) ~= '' then
				hasExamples = true
				break
			end
		end
		if not hasExamples then
			chatMessage(u8:decode('[News Helper] Заполните хотя бы один пример!'), 0xFF0000)
			return
		end
	end
	if efirType ~= 'inter' and efirType ~= 'reklama' and efirType ~= 'sobes' then
		if ffi.string(efir.inputs.money) == '' or ffi.string(efir.inputs.money) == '0' then
			chatMessage(u8:decode('[News Helper] Укажите призовой фонд!'), 0xFF0000)
			return
		end
	end
	_G.currentEfirType = efirType
	efir.control.running = true
	efir.control.paused = false
	efir.control.shouldEnd = false
	efir.control.thread = lua_thread.create(function()
		local function sendMessage(text, delay)
			while efir.control.paused and efir.control.running and not efir.control.shouldEnd do
				wait(100)
			end
			if not efir.control.running then return false end
			if efir.control.shouldEnd then
				sampSendChat(u8:decode(text))
				wait(100)
				return true
			end
			sampSendChat(u8:decode(text))
			if delay then
				local interval = efir.intervals[efirType] and efir.intervals[efirType][0] or delay
				for i = 1, math.ceil(interval/100) do
					if not efir.control.running then return false end
					if efir.control.shouldEnd then break end
					wait(100)
					if efir.control.paused then
						while efir.control.paused and efir.control.running and not efir.control.shouldEnd do
							wait(100)
						end
					end
				end
			end
			return true
		end
		if messages.msg1 then 
			if not sendMessage(replaceEfirVariables(ffi.string(messages.msg1)), 2000) then 
				efir.control.running = false
				return 
			end
		end
		if messages.msg2 then 
			if not sendMessage(replaceEfirVariables(ffi.string(messages.msg2)), 3000) then 
				efir.control.running = false
				return 
			end
		end
		if messages.msg3 then 
			if not sendMessage(replaceEfirVariables(ffi.string(messages.msg3)), 3000) then 
				efir.control.running = false
				return 
			end
		end
		local msgOrder = {'msg4', 'msg5', 'msg5_2', 'msg6', 'msg7', 'msg8', 'msg9', 'msg10', 'msg11', 'msg12', 'msg13', 'msg14', 'msg15'}
		for _, msgKey in ipairs(msgOrder) do
			if messages[msgKey] then
				local msgText = replaceEfirVariables(ffi.string(messages[msgKey]))
				if not sendMessage(msgText, 3000) then 
					efir.control.running = false
					return 
				end
			end
		end
		if efir.control.shouldEnd and efir.control.running then
			wait(1000)
			endEfir()
		end
	end)
end
function startAutoEfir(efirType)
	if not checkUserData() then
		chatMessage(u8:decode('[News Helper] Заполните данные пользователя!'), 0xFF0000)
		return
	end
	windows.mainSettings[0] = false
	efir.auto.pausedDuringStartup = false
	efir.auto.pausedDuringQuestions = false
	efir.auto.finishedQuestions = false
	efir.auto.pausedAnswer = nil
	efir.auto.active = false
	efir.auto.paused = false
	efir.auto.pausedManually = false
	efir.auto.finishedQuestions = false
	efir.auto.efirType = nil
	efir.auto.currentQuestion = 0
	efir.auto.totalQuestions = 0
	efir.auto.waitingForAnswer = false
	efir.auto.correctAnswers = {}
	efir.auto.isFirstPassage = true
	efir.counter = {}
	efir.lastBallVariant = {}
	if not efir.messages[efirType] then
		chatMessage(u8:decode('[News Helper] Сообщения эфира не загружены!'), 0xFF0000)
		return
	end
	local messages = efir.messages[efirType]
	if not messages.first or not messages.next then
		chatMessage(u8:decode('[News Helper] Отсутствуют необходимые сообщения эфира!'), 0xFF0000)
		return
	end
	local questionCount = efirLineCount[efirType] or 10
	local filledCount = 0
	for i = 1, questionCount do
		local example = ffi.string(efir.examples[efirType][i])
		local answer = ffi.string(efir.answers[efirType][i])
		if example ~= '' and answer ~= '' then
			filledCount = filledCount + 1
		end
	end
	if filledCount < questionCount then
		chatMessage(u8:decode('[News Helper] Заполните все ' .. questionCount .. ' примеров И ответов!'), 0xFF0000)
		chatMessage(u8:decode('[News Helper] Заполнено: ' .. filledCount .. '/' .. questionCount), 0xFFFF00)
		return
	end
	if ffi.string(efir.inputs.money) == '' or ffi.string(efir.inputs.money) == '0' then
		chatMessage(u8:decode('[News Helper] Укажите призовой фонд!'), 0xFF0000)
		return
	end
	efir.auto.active = true
	efir.auto.paused = false
	efir.auto.pausedManually = false
	efir.auto.finishedQuestions = false
	efir.auto.efirType = efirType
	efir.auto.currentQuestion = 0
	efir.auto.waitingForAnswer = false
	efir.auto.totalQuestions = questionCount
	efir.auto.correctAnswers = {}
	efir.auto.isFirstPassage = true
	for i = 1, questionCount do
		efir.auto.correctAnswers[i] = ffi.string(efir.answers[efirType][i])
	end
	chatMessage(u8:decode('[News Helper] Автоматический эфир начат! Вопросов: ' .. questionCount), 0x00FF00)
	lua_thread.create(function()
		local msgs = efir.messages[efirType]
		local function checkPause()
			while efir.auto.pausedDuringStartup and efir.auto.active do
				wait(100)
			end
			return efir.auto.active and not efir.auto.pausedManually
		end
		if msgs.msg1 then
			sampSendChat(u8:decode(replaceEfirVariables(ffi.string(msgs.msg1))))
			wait(2000)
			if not checkPause() then return end
		end
		if msgs.msg2 then
			sampSendChat(u8:decode(replaceEfirVariables(ffi.string(msgs.msg2))))
			wait(3000)
			if not checkPause() then return end
		end
		if msgs.msg3 then
			sampSendChat(u8:decode(replaceEfirVariables(ffi.string(msgs.msg3))))
			wait(3000)
			if not checkPause() then return end
		end
		local msgOrder = {'msg4', 'msg5', 'msg5_2', 'msg6', 'msg7', 'msg8'}
		for _, msgKey in ipairs(msgOrder) do
			if not efir.auto.active or efir.auto.pausedManually then return end
			if msgs[msgKey] then
				sampSendChat(u8:decode(replaceEfirVariables(ffi.string(msgs[msgKey]))))
				wait(3000)
				if not checkPause() then return end
			end
		end
		if efir.auto.active and not efir.auto.pausedManually and not efir.auto.pausedDuringStartup then
			sendNextAutoQuestion()
		end
	end)
end
function sendNextAutoQuestion()
	if not efir.auto.active or efir.auto.pausedDuringStartup then return end
	efir.auto.currentQuestion = efir.auto.currentQuestion + 1
	local totalQuestions = efir.auto.totalQuestions or 10
	if efir.auto.currentQuestion > totalQuestions then
		efir.auto.currentQuestion = 1
		efir.auto.isFirstPassage = false
	end
	local efirType = efir.auto.efirType
	if not efirType then return end
	if not efir.examples or not efir.examples[efirType] then return end
	local exampleBuffer = efir.examples[efirType][efir.auto.currentQuestion]
	if not exampleBuffer then return end
	local example = ffi.string(exampleBuffer)
	if example == '' then
		lua_thread.create(function()
			wait(100)
			if efir.auto.active and not efir.auto.pausedDuringStartup then
				sendNextAutoQuestion()
			end
		end)
		return
	end
	lua_thread.create(function()
		local messages = efir.messages[efirType]
		if not messages then return end
		while (efir.auto.pausedDuringQuestions or efir.auto.pausedDuringStartup) and efir.auto.active do
			wait(100)
		end
		if not efir.auto.active or efir.auto.pausedDuringQuestions or efir.auto.pausedDuringStartup then return end
		local useFirst = efir.auto.isFirstPassage and efir.auto.currentQuestion == 1
		local msgKey = useFirst and "first" or "next"
		sampSendChat(u8:decode(replaceEfirVariables(ffi.string(messages[msgKey]))))
		wait(3000)
		while (efir.auto.pausedDuringQuestions or efir.auto.pausedDuringStartup) and efir.auto.active do
			wait(100)
		end
		if not efir.auto.active or efir.auto.pausedDuringQuestions or efir.auto.pausedDuringStartup then return end
		sampSendChat(u8:decode(example))
		efir.auto.waitingForAnswer = true
	end)
end
function pauseAutoEfirDuringQuestions()
	efir.auto.waitingForAnswer = false
	efir.auto.pausedDuringQuestions = true
	chatMessage(u8:decode('[News Helper] Эфир на паузе'), 0xFFFF00)
end
function pauseAutoEfir()
	efir.auto.active = false
	efir.auto.waitingForAnswer = false
	efir.auto.pausedManually = true
	chatMessage(u8:decode('[News Helper] Эфир на паузе'), 0xFFFF00)
end
function pauseAutoEfirDuringStartup()
	efir.auto.pausedDuringStartup = true
	chatMessage(u8:decode('[News Helper] Эфир на паузе'), 0xFFFF00)
end
function endAutoEfirQuestions()
	efir.auto.active = false
	efir.auto.waitingForAnswer = false
	efir.auto.finishedQuestions = true
	chatMessage(u8:decode('[News Helper] Вопросы закончились!'), 0xFFFF00)
	chatMessage(u8:decode('[News Helper] Измените текущие вопросы если хотите'), 0xFFFF00)
	chatMessage(u8:decode('[News Helper] Нажмите ' .. getHotkeyString(efir.control.pauseHotkey) .. ' чтобы продолжить.'), 0xFFFF00)
end
function resumeAutoEfirDuringStartup()
	if not efir.auto.pausedDuringStartup then return end
	efir.auto.pausedDuringStartup = false
	windows.mainSettings[0] = false
	chatMessage(u8:decode('[News Helper] Эфир возобновлен'), 0x00FF00)
end
function resumeAutoEfirAfterEnd()
	if not efir.auto.finishedQuestions then return end
	efir.auto.finishedQuestions = false
	efir.auto.active = true
	efir.auto.currentQuestion = 0
	efir.auto.isFirstPassage = false
	windows.mainSettings[0] = false
	local efirType = efir.auto.efirType
	if not efirType then
		chatMessage(u8:decode('[News Helper] Ошибка: тип эфира не определен'), 0xFF0000)
		stopAutoEfir()
		return
	end
	local totalQuestions = efirLineCount[efirType] or 10
	efir.auto.totalQuestions = totalQuestions
	efir.auto.correctAnswers = {}
	if not efir.answers[efirType] then
		chatMessage(u8:decode('[News Helper] Ошибка: данные ответов не загружены'), 0xFF0000)
		stopAutoEfir()
		return
	end
	for i = 1, totalQuestions do
		if efir.answers[efirType][i] then
			efir.auto.correctAnswers[i] = ffi.string(efir.answers[efirType][i])
		end
	end
	chatMessage(u8:decode('[News Helper] Начинаю циклирование вопросов'), 0x00FF00)
	sendNextAutoQuestion()
end
function resumeAutoEfirDuringQuestions()
	if not efir.auto.pausedDuringQuestions then return end
	efir.auto.pausedDuringQuestions = false
	windows.mainSettings[0] = false
	local efirType = efir.auto.efirType
	if not efirType then
		chatMessage(u8:decode('[News Helper] Ошибка: тип эфира не определен'), 0xFF0000)
		stopAutoEfir()
		return
	end
	local totalQuestions = efirLineCount[efirType] or 10
	efir.auto.correctAnswers = {}
	if not efir.answers[efirType] then
		chatMessage(u8:decode('[News Helper] Ошибка: данные ответов не загружены'), 0xFF0000)
		stopAutoEfir()
		return
	end
	for i = 1, totalQuestions do
		if efir.answers[efirType][i] then
			efir.auto.correctAnswers[i] = ffi.string(efir.answers[efirType][i])
		end
	end
	chatMessage(u8:decode('[News Helper] Эфир возобновлен'), 0x00FF00)
	if efir.auto.pausedAnswer then
		local answer = efir.auto.pausedAnswer
		efir.auto.pausedAnswer = nil
		efir.auto.waitingForAnswer = false
		local action = {
			type = "correct_answer",
			senderName = answer.senderName,
			translatedName = answer.translatedName,
			efirType = efir.auto.efirType,
			startTime = os.clock(),
			step = 1,
			points = 1,
			questionId = efir.auto.currentQuestion
		}
		if action.senderName and action.senderName ~= "" then
			table.insert(efir.auto.actionQueue, action)
		end
	else
		efir.auto.active = true
		efir.auto.waitingForAnswer = true
	end
end
function resumeAutoEfir()
	if not efir.auto.pausedManually and not efir.auto.finishedQuestions then return end
	efir.auto.finishedQuestions = false
	efir.auto.pausedManually = false
	efir.auto.active = true
	windows.mainSettings[0] = false
	local efirType = efir.auto.efirType
	if not efirType then
		chatMessage(u8:decode('[News Helper] Ошибка: тип эфира не определен'), 0xFF0000)
		stopAutoEfir()
		return
	end
	local totalQuestions = efirLineCount[efirType] or 10
	if not totalQuestions then totalQuestions = 10 end
	efir.auto.correctAnswers = {}
	if not efir.answers[efirType] then
		chatMessage(u8:decode('[News Helper] Ошибка: данные ответов не загружены'), 0xFF0000)
		stopAutoEfir()
		return
	end
	for i = 1, totalQuestions do
		if efir.answers[efirType][i] then
			efir.auto.correctAnswers[i] = ffi.string(efir.answers[efirType][i])
		end
	end
	chatMessage(u8:decode('[News Helper] Эфир возобновлен'), 0x00FF00)
	sendNextAutoQuestion()
end
function processAutoAnswerWithPause(smsText, sender, senderId)
	if efir.auto.paused then return false end
	return processAutoAnswer(smsText, sender, senderId)
end
function processAutoAnswer(smsText, sender, senderId)
	if not efir.auto.correctAnswers or not efir.auto.correctAnswers[efir.auto.currentQuestion] then 
		return false
	end
	if efir.auto.updating then return false end
	if not efir.auto.active and not efir.auto.pausedDuringQuestions then return false end
	if not efir.auto.waitingForAnswer and not efir.auto.pausedDuringQuestions then return false end
	if not efir.auto.correctAnswers or not efir.auto.correctAnswers[efir.auto.currentQuestion] then return false end
	local correctAnswer = efir.auto.correctAnswers[efir.auto.currentQuestion]
	if not correctAnswer or correctAnswer == '' then return false end
	if checkSMSAnswer(smsText, correctAnswer) then
		local senderName = sender and sender:gsub("_", " ") or "Unknown"
		local translatedName = sender and trst(sender:gsub("_", " ")) or "Unknown"
		if efir.auto.pausedDuringQuestions then
			if not efir.auto.pausedAnswer then
				efir.auto.pausedAnswer = {
					senderName = senderName,
					translatedName = translatedName
				}
				sampAddChatMessage(u8:decode('[News Helper] Ответ от ' .. translatedName .. ' принят, но эфир на паузе. Нажмите ' .. getHotkeyString(efir.control.pauseHotkey) .. ' для возобновления'), 0xFFFF00)
			end
			return true
		end
		efir.auto.waitingForAnswer = false
		local action = {
			type = "correct_answer",
			senderName = senderName,
			translatedName = translatedName,
			efirType = efir.auto.efirType,
			startTime = os.clock(),
			step = 1,
			points = 1,
			questionId = efir.auto.currentQuestion
		}
		if action.senderName and action.senderName ~= "" then
			table.insert(efir.auto.actionQueue, action)
			return true
		end
	end
	return false
end
function processAutoEfirActionQueue()
	if #efir.auto.actionQueue == 0 then return end
	if not efir.auto.active and not efir.auto.paused then 
		efir.auto.actionQueue = {}
		return 
	end
	local action = efir.auto.actionQueue[1]
	if not action then return end
	if efir.auto.pausedDuringQuestions or efir.auto.pausedDuringStartup then return end
	if action.questionId ~= efir.auto.currentQuestion then
		table.remove(efir.auto.actionQueue, 1)
		return
	end
	local efirType = efir.auto.efirType
	if not efirType then return end
	local currentTime = os.clock()
	local elapsed = (currentTime - action.startTime) * 1000
	if action.type == "correct_answer" then
		if action.step == 1 and elapsed >= 500 then
			sampSendChat(u8:decode("Стоп!"))
			if efir.counter and action.senderName then
				if efir.counter[action.senderName] then
					efir.counter[action.senderName] = efir.counter[action.senderName] + 1
				else
					efir.counter[action.senderName] = 1
				end
			end
			action.step = 2
			action.stepTime = currentTime
		end
		if action.step == 2 and (currentTime - action.stepTime) * 1000 >= 50 then
			action.points = (efir.counter and efir.counter[action.senderName]) or 1
			action.step = 3
			action.stepTime = currentTime
		end
		if action.step == 3 then
			local interval = 3000
			if efir.intervals and efir.intervals[efirType] then
				interval = efir.intervals[efirType][0] or 3000
			end
			if (currentTime - action.stepTime) * 1000 >= interval then
				action.step = 4
			end
		end
		if action.step == 4 then
			if efir.auto.pausedDuringQuestions or efir.auto.pausedDuringStartup then return end
			local points = action.points or 1
			if points < 10 then
				local variantType = ""
				if points == 1 then
					variantType = "ball1"
				elseif points <= 4 then
					variantType = "ball2"
				else
					variantType = "ball5"
				end
				local variants = {}
				if efir.messages and efir.messages[efirType] then
					local messages = efir.messages[efirType]
					for msgKey, _ in pairs(messages) do
						if msgKey == variantType or (type(msgKey) == "string" and msgKey:match("^" .. variantType .. "%.%d+$")) then
							table.insert(variants, msgKey)
						end
					end
				end
				if #variants > 0 then
					if not efir.lastBallVariant[action.senderName] then
						efir.lastBallVariant[action.senderName] = 1
					else
						efir.lastBallVariant[action.senderName] = (efir.lastBallVariant[action.senderName] % #variants) + 1
					end
					local selectedVariant = variants[efir.lastBallVariant[action.senderName]]
					if efir.messages and efir.messages[efirType] and selectedVariant then
						local messageBuffer = efir.messages[efirType][selectedVariant]
						if messageBuffer then
							local ballMessage = ffi.string(messageBuffer)
							if ballMessage and ballMessage ~= "" then
								ballMessage = replaceEfirVariables(ballMessage)
								ballMessage = ballMessage:gsub("%%", tostring(points))
								ballMessage = ballMessage:gsub("%*1", action.translatedName)
								sampSendChat(u8:decode(ballMessage))
							end
						end
					end
				end
			end
			action.step = 5
			action.stepTime = currentTime
		end
		if action.step == 5 then
			if efir.auto.pausedDuringQuestions or efir.auto.pausedDuringStartup then return end
			local waitTime = (action.points and action.points >= 10) and 2000 or 2000
			if (currentTime - action.stepTime) * 1000 >= waitTime then
				table.remove(efir.auto.actionQueue, 1)
				if action.points and action.points >= 10 then
					finishAutoEfirWithWinner(action.translatedName)
				else
					if efir.auto.currentQuestion >= (efir.auto.totalQuestions or 10) then
						endAutoEfirQuestions()
					else
						if efir.auto.active and not efir.auto.finishedQuestions then
							sendNextAutoQuestion()
						end
					end
				end
			end
		end
	end
end
function finishAutoEfir()
	if not efir.auto.active then return end
	local efirType = efir.auto.efirType
	if not efirType then
		stopAutoEfir()
		return
	end
	lua_thread.create(function()
		if not efir.messages or not efir.messages[efirType] then
			stopAutoEfir()
			return
		end
		local messages = efir.messages[efirType]
		if not messages then
			stopAutoEfir()
			return
		end
		local function checkPause()
			while efir.auto.pausedDuringQuestions and efir.auto.active do
				wait(100)
			end
			return efir.auto.active
		end
		if efir.auto.active and messages.end1 then 
			local end1Msg = ffi.string(messages.end1)
			if end1Msg and end1Msg ~= "" then
				sampSendChat(u8:decode(replaceEfirVariables(end1Msg)))
			end
			wait(4000)
			if not checkPause() then return end
		end
		if efir.auto.active and messages.end2 then 
			local end2Msg = ffi.string(messages.end2)
			if end2Msg and end2Msg ~= "" then
				sampSendChat(u8:decode(replaceEfirVariables(end2Msg)))
			end
			wait(4000)
			if not checkPause() then return end
		end
		if efir.auto.active and messages.end3 then 
			local end3Msg = ffi.string(messages.end3)
			if end3Msg and end3Msg ~= "" then
				sampSendChat(u8:decode(replaceEfirVariables(end3Msg)))
			end
			wait(4000)
			if not checkPause() then return end
		end
		if efir.auto.active and messages.end4 then 
			local end4Msg = ffi.string(messages.end4)
			if end4Msg and end4Msg ~= "" then
				sampSendChat(u8:decode(replaceEfirVariables(end4Msg)))
			end
			wait(3000)
			if not checkPause() then return end
		end
		if efir.auto.active and messages.end5 then 
			local end5Msg = ffi.string(messages.end5)
			if end5Msg and end5Msg ~= "" then
				sampSendChat(u8:decode(replaceEfirVariables(end5Msg)))
			end
		end
		stopAutoEfir()
		chatMessage(u8:decode('[News Helper] Автоэфир завершен. Можно открывать /newstools'), 0x00FF00)
	end)
end
function finishAutoEfirWithWinner(winnerName)
	if not efir.auto.active then return end
	local efirType = efir.auto.efirType
	if not efirType then
		stopAutoEfir()
		return
	end
	lua_thread.create(function()
		local messages = efir.messages[efirType]
		if not messages then
			stopAutoEfir()
			return
		end
		local function checkPause()
			while efir.auto.pausedDuringQuestions and efir.auto.active do
				wait(100)
			end
			return efir.auto.active
		end
		if efir.auto.active and messages.winner1 then 
			local winner1Msg = ffi.string(messages.winner1)
			if winner1Msg and winner1Msg ~= "" then
				sampSendChat(u8:decode(replaceEfirVariables(winner1Msg)))
			end
			wait(4000)
			if not checkPause() then return end
		end
		if efir.auto.active and messages.winner2 then
			local winner2Msg = ffi.string(messages.winner2)
			if winner2Msg and winner2Msg ~= "" then
				local msg = replaceEfirVariables(winner2Msg):gsub("%*", winnerName or "")
				sampSendChat(u8:decode(msg))
			end
			wait(4000)
			if not checkPause() then return end
		end
		if efir.auto.active and messages.winner3 then 
			local winner3Msg = ffi.string(messages.winner3)
			if winner3Msg and winner3Msg ~= "" then
				sampSendChat(u8:decode(replaceEfirVariables(winner3Msg)))
			end
			wait(4000)
			if not checkPause() then return end
		end
		finishAutoEfir()
	end)
end
function stopAutoEfir()
	if efir.control.running then
		if efir.control.thread then
			efir.control.thread:terminate()
		end
		efir.control.running = false
		efir.control.paused = false
		efir.control.currentLine = 1
	end
	local wasActive = efir.auto.active
	local efirType = efir.auto.efirType
	efir.auto.active = false
	efir.auto.paused = false
	efir.auto.efirType = nil
	efir.auto.currentQuestion = 0
	efir.auto.totalQuestions = 0
	efir.auto.waitingForAnswer = false
	efir.counter = {}
	efir.lastBallVariant = {}
	efir.auto.correctAnswers = {}
	if wasActive then
		chatMessage(u8:decode('[News Helper] Эфир завершен'), 0xFF0000)
	end
end
function setDialogTextWithEncoding(text)
	if sampIsDialogActive() then
		local convertedText = u8:encode(text)
		sampSetCurrentDialogEditboxText(convertedText)
	end
end
function setDialogCursorPos(pos)
	local m_pEditbox = memory.getuint32(sampGetDialogInfoPtr() + 0x24, true)
	if m_pEditbox ~= 0 then
		memory.setuint8(m_pEditbox + 0x119, pos, true)
		memory.setuint8(m_pEditbox + 0x11E, pos, true)
		memory.setuint8(m_pEditbox + 0x11D, 0, true)
	end
end
function checkUserData()
	if data.mainIni and data.mainIni.config and data.mainIni.config.c_nick and data.mainIni.config.c_nick ~= '' then
		return true
	end
	return false
end
function stopEfir()
	if efir.control.running then
		if efir.control.thread then
			efir.control.thread:terminate()
		end
		efir.control.running = false
		efir.control.paused = false
		efir.control.currentLine = 1
	end
	efir.counter = {}
	efir.lastBallVariant = {}
	chatMessage(u8:decode('[News Helper] Эфир остановлен'), 0xFF0000)
end
function endEfir()
	local efirType = _G.currentEfirType or 'sobes'
	local messages = efir.messages[efirType]
	
	if not messages then
		chatMessage(u8:decode('[News Helper] Сообщения для эфира не найдены'), 0xFF0000)
		return
	end
	if efir.control.running then
		efir.control.paused = true
		efir.control.shouldEnd = true
	end
	lua_thread.create(function()
		chatMessage(u8:decode('[News Helper] Завершаем эфир...'), 0xFFFF00)
		local endMessages = {
			messages.end1 or messages.end_1,
			messages.end2 or messages.end_2,
			messages.end3 or messages.end_3,
			messages.end4 or messages.end_4
		}
		for _, msg in ipairs(endMessages) do
			if msg then
				local msgText = ffi.string(msg)
				if msgText ~= '' then
					msgText = replaceEfirVariables(msgText)
					sampSendChat(u8:decode(msgText))
					wait(efir.intervals[efirType][0] or 3000)
				end
			end
		end
		efir.control.running = false
		efir.control.paused = false
		efir.control.shouldEnd = false
		efir.counter = {}
		efir.lastBallVariant = {}
		chatMessage(u8:decode('[News Helper] Эфир завершен!'), 0x00FF00)
	end)
end
function saveAutoEfirQuestions(efirType)
	if not efirType or not efir.examples[efirType] then
		chatMessage(u8:decode('[News Helper] Ошибка: эфир не выбран'), 0xFF0000)
		return
	end
	local totalQuestions = efirLineCount[efirType] or 10
	local savedCount = 0
	for i = 1, totalQuestions do
		local example = ffi.string(efir.examples[efirType][i])
		local answer = ffi.string(efir.answers[efirType][i])
		if example ~= '' and answer ~= '' then
			savedCount = savedCount + 1
		end
	end
	if savedCount == 0 then
		chatMessage(u8:decode('[News Helper] Нет вопросов для сохранения!'), 0xFF0000)
		return
	end
	saveConfig()
	chatMessage(u8:decode('[News Helper] Сохранено ' .. savedCount .. ' вопросов из ' .. totalQuestions), 0x00FF00)
end
function addPlayerBall()
	local id_string = ffi.string(efir.inputs.playerId)
	id_string = id_string:gsub("%s+", "")
	if id_string == "" then
		chatMessage(u8:decode('[News Helper] Введите ID игрока!'), 0xFF0000)
		return
	end
	local id = tonumber(id_string)
	if not id then
		chatMessage(u8:decode('[News Helper] ID должен быть числом!'), 0xFF0000)
		return
	end
	if id < 0 or id > 999 then
		chatMessage(u8:decode('[News Helper] ID должен быть от 0 до 999!'), 0xFF0000)
		return
	end
	local _, myId = sampGetPlayerIdByCharHandle(PLAYER_PED)
	if id ~= myId and not sampIsPlayerConnected(id) then
		chatMessage(u8:decode('[News Helper] Игрок с ID ' .. id .. ' не подключен к серверу!'), 0xFF0000)
		return
	end
	local u_name = sampGetPlayerNickname(id):gsub("_"," ")
	queueAddBall(u_name)
	lua_thread.create(function()
		wait(50)
		local ru_name = trst(u_name:gsub('%[PC%]',''):gsub('%[M%]',''))
		local points = efir.counter[u_name]
		local currentType = efir.type or efir.selectedType or 'math'
		local messages = efir.messages[currentType]
		if messages then
			if points < 10 then
				local ballMessage = ""
				local variantType = ""
				if points == 1 then
					variantType = "ball1"
				elseif points <= 4 then
					variantType = "ball2" 
				elseif points <= 10 then
					variantType = "ball5"
				end
				local variants = {}
				for msgKey, _ in pairs(messages) do
					if msgKey == variantType or msgKey:match("^" .. variantType .. "%.%d+$") then
						table.insert(variants, msgKey)
					end
				end
				if #variants > 0 then
					if not efir.lastBallVariant[u_name] then
						efir.lastBallVariant[u_name] = 1
					else
						efir.lastBallVariant[u_name] = (efir.lastBallVariant[u_name] % #variants) + 1
					end
					local selectedVariant = variants[efir.lastBallVariant[u_name]]
					ballMessage = ffi.string(messages[selectedVariant])
					ballMessage = replaceEfirVariables(ballMessage)
					ballMessage = ballMessage:gsub("%%", tostring(points)) 
					ballMessage = ballMessage:gsub("%*1", ru_name) 
					sampSendChat(u8:decode(ballMessage))
				end
			else
				local winnerMsg1 = messages.winner1 and replaceEfirVariables(ffi.string(messages.winner1)) or "И у нас есть победитель!"
				local winnerMsg2 = messages.winner2 and replaceEfirVariables(ffi.string(messages.winner2)):gsub("%*", ru_name) or ("Побеждает " .. ru_name .. " - первый набрал 10 баллов и получает приз!")
				local winnerMsg3 = messages.winner3 and replaceEfirVariables(ffi.string(messages.winner3)) or "Просим победителя приехать в нашу редакцию для получения приза."
				sampSendChat(u8:decode(winnerMsg1))
				wait(3000)
				sampSendChat(u8:decode(winnerMsg2))
				wait(3000)
				sampSendChat(u8:decode(winnerMsg3))
			end
		end
	end)
end
function clearEfirQuestions(efirType)
	if not efirType or not efir.examples[efirType] then return end
	for i = 1, 50 do
		if efir.examples[efirType][i] then
			ffi.fill(efir.examples[efirType][i], ffi.sizeof(efir.examples[efirType][i]))
		end
		if efir.answers[efirType][i] then
			ffi.fill(efir.answers[efirType][i], ffi.sizeof(efir.answers[efirType][i]))
		end
	end
	chatMessage(u8:decode('[News Helper] Все вопросы и ответы эфира "' .. efirType .. '" очищены'), 0x00FF00)
	saveConfig()
end
function renderSaveAndClearQuestionsButtons(efirType)
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.7, 0.3, 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.8, 0.4, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.15, 0.6, 0.25, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('floppy_disk') .. ' Сохранить##' .. efirType, imgui.ImVec2(100, 25)) then
		if fa_font then imgui.PopFont() end
		saveAutoEfirQuestions(efirType)
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	imgui.SameLine()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.6, 0.8, 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.7, 0.9, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.1, 0.5, 0.7, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('file_import') .. ' Вопросы', imgui.ImVec2(95, 25)) then
		if fa_font then imgui.PopFont() end
		bulkInput.active = true
		bulkInput.mode = 'questions'
		bulkInput.efirType = efirType
		ffi.fill(bulkInput.text, 8192)
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.Text('Вставьте все вопросы')
		imgui.Text('по одному на строку')
		imgui.Text('(максимум 10 строк)')
		imgui.EndTooltip()
	end
	imgui.SameLine()
	if efir.mode[0] then
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.6, 0.8, 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.7, 0.9, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.1, 0.5, 0.7, 1))
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(fa('file_import') .. ' Ответы', imgui.ImVec2(90, 25)) then
			if fa_font then imgui.PopFont() end
			bulkInput.active = true
			bulkInput.mode = 'answers'
			bulkInput.efirType = efirType
			ffi.fill(bulkInput.text, 8192)
		end
		if fa_font then imgui.PopFont() end
		imgui.PopStyleColor(3)
		if imgui.IsItemHovered() then
			imgui.BeginTooltip()
			imgui.Text('Вставьте все ответы')
			imgui.Text('по одному на строку')
			imgui.Text('(максимум 10 строк)')
			imgui.EndTooltip()
		end
	end
	imgui.SameLine()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.2, 0.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.3, 0.3, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.1, 0.1, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('trash_can') .. ' Очистить все', imgui.ImVec2(100, 25)) then
		if fa_font then imgui.PopFont() end
		clearEfirQuestions(efirType)
	end
	imgui.PopStyleColor(3)
	if imgui.IsItemHovered() then
		imgui.SetTooltip('Удалить все вопросы и ответы')
	end
end
function renderQuizEfir(efirType, efirName, questionLabel)
	if not efir.examples or not efir.examples[efirType] then return end
	if not efir.answers or not efir.answers[efirType] then return end
	if efir.selectedType == efirType then
		tabWindowSizes[6].y = 800
	end
	imgui.Text('Эфир "' .. efirName .. '"')
	imgui.Separator()
	local bg = settings.colors.background
	local item = settings.colors.itemButtons
	local inputBgColor = imgui.ImVec4(bg[0] * 0.5, bg[1] * 0.5, bg[2] * 0.5, 1)
	local inputBgColorHovered = imgui.ImVec4(bg[0] * 0.7, bg[1] * 0.7, bg[2] * 0.7, 1)
	local inputBgColorActive = imgui.ImVec4(bg[0] * 0.9, bg[1] * 0.9, bg[2] * 0.9, 1)
	imgui.BeginChild('##' .. efirType .. 'LeftPanel', imgui.ImVec2(250, 0), true)
	imgui.Text('Режим:')
	setupCheckboxStyle()
	if imgui.Checkbox('Автоматический##' .. efirType .. 'mode', efir.mode) then
		saveConfig()
	end
	cleanupCheckboxStyle()
	imgui.Spacing()
	if not efir.mode[0] then
		renderIntervalControl(efirType, 'Интервал (мс)')
	else
		imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), '(Автоматический режим: ')
		imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), 'интервал фиксирован - 3000 мс)')
	end
	imgui.Spacing()
	imgui.Text('Приз ($):')
	imgui.PushItemWidth(-1)
	if imgui.InputText('##MoneyPrize' .. efirType, efir.inputs.money, 32) then
		saveConfig()
	end
	imgui.PopItemWidth()
	imgui.Spacing()
	imgui.Separator()
	imgui.Spacing()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('play') .. ' Начать', imgui.ImVec2(-1, 30)) then
		if fa_font then imgui.PopFont() end
		if efir.mode[0] then
			startAutoEfir(efirType)
		else
			startEfir(efirType)
		end
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.4, 0.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.5, 0.3, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.3, 0.1, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('flag_checkered') .. ' Завершить', imgui.ImVec2(-1, 30)) then
		if fa_font then imgui.PopFont() end
		if not efir.confirmFinishEfir then
			efir.confirmFinishEfir = true
		else
			if efir.auto.active then
				stopAutoEfir()
			elseif efir.control.running then
				stopEfir()
			else
				chatMessage(u8:decode('[News Helper] Эфир не запущен'), 0xFF0000)
			end
			efir.confirmFinishEfir = false
		end
	end
	if efir.confirmFinishEfir and imgui.IsItemHovered() then
		imgui.SetTooltip('Нажмите еще раз для подтверждения')
	end
	imgui.PopStyleColor(3)
	if not efir.mode[0] then
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.6, 0.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.7, 0.3, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.5, 0.1, 1))
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(fa('stop') .. ' Закончить эфир', imgui.ImVec2(-1, 30)) then
			if fa_font then imgui.PopFont() end
			if efir.control.paused then
				chatMessage(u8:decode('[News Helper] Сначала возобновите эфир!'), 0xFF0000)
			else
				endEfir()
			end
			efir.confirmEndEfir = false
		end
		if efir.confirmEndEfir and imgui.IsItemHovered() then
			imgui.SetTooltip('Нажмите еще раз для подтверждения')
		end
		if fa_font then imgui.PopFont() end
		imgui.PopStyleColor(3)
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.2, 0.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.3, 0.3, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.1, 0.1, 1))
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(fa('hand') .. ' СТОП!', imgui.ImVec2(-1, 60)) then
			if fa_font then imgui.PopFont() end
			if efir.control.paused then
				chatMessage(u8:decode('[News Helper] Сначала возобновите эфир!'), 0xFF0000)
			else
				sampSendChat(u8:decode("Стоп!"))
			end
		end
		if fa_font then imgui.PopFont() end
		imgui.PopStyleColor(3)
		imgui.Spacing()
		imgui.Text('ID игрока:')
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
		if imgui.Button('-##DecPlayerId', imgui.ImVec2(25, 0)) then
			local currentId = tonumber(ffi.string(efir.inputs.playerId)) or 0
			if currentId > 0 then
				ffi.fill(efir.inputs.playerId, 32)
				ffi.copy(efir.inputs.playerId, tostring(currentId - 1))
			else
				ffi.fill(efir.inputs.playerId, 32)
			end
		end
		imgui.SameLine(0, 5)
		imgui.PopStyleColor(3)
		local inputWidth = imgui.GetWindowWidth() - 80
		imgui.PushItemWidth(inputWidth)
		imgui.InputText('##PlayerID' .. efirType, efir.inputs.playerId, 32)
		imgui.PopItemWidth()
		imgui.SameLine(0, 5)
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
		if imgui.Button('+##IncPlayerId', imgui.ImVec2(25, 0)) then
			local currentId = tonumber(ffi.string(efir.inputs.playerId))
			if currentId then
				if currentId < 999 then
					ffi.fill(efir.inputs.playerId, 32)
					ffi.copy(efir.inputs.playerId, tostring(currentId + 1))
				end
			else
				ffi.fill(efir.inputs.playerId, 32)
				ffi.copy(efir.inputs.playerId, "0")
			end
		end
		imgui.PopStyleColor(3)
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
		if imgui.Button('Добавить балл', imgui.ImVec2(-1, 25)) then
			if not efir.confirmAddBall then
				efir.confirmAddBall = true
			else
				addPlayerBall()
				efir.confirmAddBall = false
			end
		end
		imgui.PopStyleColor(3)
		if efir.confirmAddBall and imgui.IsItemHovered() then
			imgui.SetTooltip('Нажмите еще раз для подтверждения')
		end
		imgui.Spacing()
		renderScoreBoard()
	end
	if efir.mode[0] and efir.auto.active and efir.auto.efirType == efirType then
		imgui.Spacing()
		imgui.Separator()
		imgui.Spacing()
		imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), 'Автоматический режим активен')
		imgui.Text('Вопрос: ' .. efir.auto.currentQuestion .. ' / ' .. efirLineCount[efirType])
		if efir.auto.waitingForAnswer then
			imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), 'Ожидание ответа...')
		end
		renderAutoEfirScoreBoard()
	end
	imgui.EndChild()
	imgui.SameLine()
	imgui.BeginChild('##' .. efirType .. 'RightPanel', imgui.ImVec2(0, 0), true)
	imgui.Text(questionLabel .. ' и ответы:')
	imgui.Text('Количество строк: ' .. efirLineCount[efirType])
	imgui.SameLine()
	renderSaveAndClearQuestionsButtons(efirType)
	imgui.Separator()
	for i = 1, efirLineCount[efirType] do
		imgui.PushIDInt(i)
		imgui.Text(questionLabel .. ' ' .. i .. ':')
		imgui.PushItemWidth(250)
		if imgui.InputText('##Example', efir.examples[efirType][i], 256) then
			if efirType == 'math' then
				local example = ffi.string(efir.examples[efirType][i])
				if example ~= '' then
					local result, error = calculateMathExpression(example)
					if result then
						ffi.copy(efir.answers[efirType][i], result)
					else
						ffi.fill(efir.answers[efirType][i], 256)
					end
				else
					ffi.fill(efir.answers[efirType][i], 256)
				end
			elseif efirType == 'zerkalo' then
				local example = ffi.string(efir.examples[efirType][i])
				if example ~= '' then
					local function utf8reverse(s)
						local t = {}
						for uchar in s:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
							table.insert(t, 1, uchar)
						end
						return table.concat(t)
					end
					local mirrored = utf8reverse(example)
					if not efir.answers[efirType][i] then
						efir.answers[efirType][i] = imgui.new.char[256]()
					else
						ffi.fill(efir.answers[efirType][i], 256)
					end
					ffi.copy(efir.answers[efirType][i], mirrored)
				else
					if efir.answers[efirType][i] then
						ffi.fill(efir.answers[efirType][i], 256)
					end
				end
			end
		end
		imgui.PopItemWidth()
		if efir.mode[0] then
			imgui.SameLine()
			imgui.Text('Ответ:')
			imgui.SameLine()
			imgui.PushItemWidth(100)
			imgui.InputText('##Answer', efir.answers[efirType][i], 256)
			imgui.PopItemWidth()
		else
			imgui.SameLine()
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
			local answerText = ffi.string(efir.answers[efirType][i])
			if imgui.Button('Отправить', imgui.ImVec2(80, 20)) then
				local example = ffi.string(efir.examples[efirType][i])
				if example ~= '' then
					efir.type = efirType
					efir.currentQuestion = i
					lua_thread.create(function()
						if i == 1 then
							sampSendChat(u8:decode(ffi.string(efir.messages[efirType].first)))
						else
							sampSendChat(u8:decode(ffi.string(efir.messages[efirType].next)))
						end
						wait(4000)
						sampSendChat(u8:decode(example))
						efir.awaitingAnswer = true
					end)
				end
			end
			imgui.PopStyleColor(3)
			if imgui.IsItemHovered() then
				imgui.BeginTooltip()
				if answerText ~= '' then
					imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), 'Ответ: ' .. answerText)
				else
					imgui.SetTooltip('Введите ' .. questionLabel:lower() .. ' для расчета ответа')
				end
				imgui.EndTooltip()
			end
		end
		imgui.PopID()
		imgui.Spacing()
	end
	imgui.EndChild()
end
function renderMathEfir()
	renderQuizEfir('math', 'Математика', 'Пример')
end
function renderCountryEfir()
	renderQuizEfir('country', 'Столицы', 'Страна')
end
function renderHimiaEfir()
	renderQuizEfir('himia', 'Химия', 'Элемент')
end
function renderZerkaloEfir()
	renderQuizEfir('zerkalo', 'Зеркало', 'Слово')
end
function renderAnnagrammEfir()
	renderQuizEfir('annagramm', 'Анаграммы', 'Буквы')
end
function renderZagadkiEfir()
	renderQuizEfir('zagadki', 'Загадки', 'Загадка')
end
function renderSinonimEfir()
	renderQuizEfir('sinonim', 'Синонимы', 'Слово')
end
function renderIntervyuEfir()
	imgui.Text('Эфир "Интервью"')
	imgui.Separator()
	renderIntervalControl('inter', 'Интервал между сообщениями (мс)')
	local bg = settings.colors.background
	local item = settings.colors.itemButtons
	local inputBgColor = imgui.ImVec4(bg[0] * 0.5, bg[1] * 0.5, bg[2] * 0.5, 1)
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('play') .. ' Начать эфир', imgui.ImVec2(100, 25)) then
	if fa_font then imgui.PopFont() end
		startEfir('inter')
		efir.confirmFinishEfir = false
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(2)
	imgui.SameLine()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.4, 0.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.5, 0.3, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.3, 0.1, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('flag_checkered') .. ' Завершить', imgui.ImVec2(100, 25)) then
		if fa_font then imgui.PopFont() end
		if not efir.confirmFinishEfir then
			efir.confirmFinishEfir = true
		else
			if efir.control.running then
				stopEfir()
			else
				chatMessage(u8:decode('[News Helper] Эфир не запущен'), 0xFF0000)
			end
			efir.confirmFinishEfir = false
		end
	end
	if efir.confirmFinishEfir and imgui.IsItemHovered() then
		imgui.SetTooltip('Нажмите еще раз для подтверждения')
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	imgui.SameLine()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('stop') .. ' Закончить эфир', imgui.ImVec2(120, 25)) then
		if fa_font then imgui.PopFont() end
		if efir.control.paused then
			chatMessage(u8:decode('[News Helper] Сначала возобновите эфир!'), 0xFF0000)
		else
			_G.currentEfirType = 'inter'
			endEfir()
		end
		efir.confirmFinishEfir = false
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	imgui.Spacing()
	imgui.Text('Имя и Фамилия гостя:')
	imgui.InputText('##GuestName', efir.interview.name, 256)
	imgui.Text('Должность:')
	imgui.InputText('##GuestRank', efir.interview.rang, 256)
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('user_tie') .. ' Представить гостя', imgui.ImVec2(-1, 25)) then
	if fa_font then imgui.PopFont() end
		local messages = efir.messages.inter
		lua_thread.create(function()
			local name = ffi.string(efir.interview.name)
			local rang = ffi.string(efir.interview.rang)
			local introduceText = ffi.string(messages.introduce):gsub("%*", rang == '' and name or (rang .. ' - ' .. name))
			sampSendChat(u8:decode(introduceText))
			wait(efir.intervals.inter[0] or 3000)
			sampSendChat(u8:decode(ffi.string(messages.introduce2)))
		end)
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	imgui.Spacing()
	imgui.Text('Быстрые вопросы:')
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
	for i = 1, 4 do
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(fa('circle_question') .. ' ' .. ffi.string(efir.messages.inter["question"..i]), imgui.ImVec2(-1, 20)) then
			if fa_font then imgui.PopFont() end
			sampSendChat(u8:decode(ffi.string(efir.messages.inter["question"..i])))
		end
		if fa_font then imgui.PopFont() end
	end
	imgui.PopStyleColor(3)
end

function renderReklamaEfir()
	imgui.Text('Эфир "Реклама"')
	imgui.Separator()
	local bg = settings.colors.background
	local item = settings.colors.itemButtons
	local inputBgColor = imgui.ImVec4(bg[0] * 0.5, bg[1] * 0.5, bg[2] * 0.5, 1)
	imgui.Text('Интервал для начала/конца (мс):')
	imgui.SameLine()
	local intervalValue = efir.intervals.reklama[0]
	local digitCount = string.len(tostring(intervalValue))
	local inputWidth = math.max(60, digitCount * 10 + 20)
	imgui.PushItemWidth(inputWidth)
	imgui.SameLine()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
	if imgui.Button('-##DecIntervalReklama', imgui.ImVec2(20, 20)) then
		efir.intervals.reklama[0] = math.max(1000, efir.intervals.reklama[0] - 100)
		saveConfig()
	end
	imgui.SameLine()
	if imgui.InputInt('##IntervalReklama', efir.intervals.reklama, 0, 0) then
		if efir.intervals.reklama[0] < 1000 then efir.intervals.reklama[0] = 1000 end
		if efir.intervals.reklama[0] > 10000 then efir.intervals.reklama[0] = 10000 end
		saveConfig()
	end
	imgui.PopStyleColor(3)
	imgui.PopItemWidth()
	imgui.SameLine()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
	if imgui.Button('+##IncIntervalReklama', imgui.ImVec2(20, 20)) then
		efir.intervals.reklama[0] = math.min(10000, efir.intervals.reklama[0] + 100)
		saveConfig()
	end
	imgui.PopStyleColor(3)
	imgui.Text('Интервал между строками (мс):')
	imgui.SameLine()
	local linesIntervalValue = efir.intervals.reklamaLines[0]
	local linesDigitCount = string.len(tostring(linesIntervalValue))
	local linesInputWidth = math.max(60, linesDigitCount * 10 + 20)
	imgui.PushItemWidth(linesInputWidth)
	imgui.SameLine()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
	if imgui.Button('-##DecIntervalReklamaLines', imgui.ImVec2(20, 20)) then
		efir.intervals.reklamaLines[0] = math.max(1000, efir.intervals.reklamaLines[0] - 100)
		saveConfig()
	end
	imgui.SameLine()
	if imgui.InputInt('##IntervalReklamaLines', efir.intervals.reklamaLines, 0, 0) then
		if efir.intervals.reklamaLines[0] < 1000 then efir.intervals.reklamaLines[0] = 1000 end
		if efir.intervals.reklamaLines[0] > 10000 then efir.intervals.reklamaLines[0] = 10000 end
		saveConfig()
	end
	imgui.PopStyleColor(3)
	imgui.PopItemWidth()
	imgui.SameLine()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
	if imgui.Button('+##IncIntervalReklamaLines', imgui.ImVec2(20, 20)) then
		efir.intervals.reklamaLines[0] = math.min(10000, efir.intervals.reklamaLines[0] + 100)
		saveConfig()
	end
	imgui.PopStyleColor(3)
	imgui.Spacing()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('play') .. ' Начать эфир', imgui.ImVec2(100, 25)) then
		if fa_font then imgui.PopFont() end
		startEfir('reklama')
		efir.confirmFinishEfir = false
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(2)
	imgui.SameLine()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.4, 0.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.5, 0.3, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.3, 0.1, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('flag_checkered') .. ' Завершить', imgui.ImVec2(100, 25)) then
		if fa_font then imgui.PopFont() end
		if not efir.confirmFinishEfir then
			efir.confirmFinishEfir = true
		else
			if efir.control.running then
				stopEfir()
			else
				chatMessage(u8:decode('[News Helper] Эфир не запущен'), 0xFF0000)
			end
			efir.confirmFinishEfir = false
		end
	end
	if efir.confirmFinishEfir and imgui.IsItemHovered() then
		imgui.SetTooltip('Нажмите еще раз для подтверждения')
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	imgui.SameLine()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('stop') .. ' Закончить эфир', imgui.ImVec2(120, 25)) then
		if fa_font then imgui.PopFont() end
		_G.currentEfirType = 'reklama'
		endEfir()
		efir.confirmFinishEfir = false
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	imgui.Spacing()
	imgui.Text('Текст рекламы (каждая строка отдельно):')
	if not efir.inputs.reklamaText then efir.inputs.reklamaText = imgui.new.char[1024]() end
	local text = ffi.string(efir.inputs.reklamaText)
	local lineCount = 1
	for _ in text:gmatch("\n") do
		lineCount = lineCount + 1
	end
	local minHeight = 100
	local lineHeight = 18
	local calculatedHeight = math.max(minHeight, lineCount * lineHeight + 20)
	imgui.InputTextMultiline('##ReklamaText', efir.inputs.reklamaText, 1024, imgui.ImVec2(-1, calculatedHeight))
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('bullhorn') .. ' Прочитать рекламу', imgui.ImVec2(-1, 25)) then
		if fa_font then imgui.PopFont() end
		local text = ffi.string(efir.inputs.reklamaText)
		if text ~= "" then
			lua_thread.create(function()
				for line in text:gmatch("[^\r\n]+") do
					local trimmed = line:gsub("^%s+", ""):gsub("%s+$", "")
					if trimmed ~= "" then
						sampSendChat(u8:decode(trimmed))
						wait(efir.intervals.reklamaLines[0])
					end
				end
			end)
		else
			chatMessage(u8:decode('[News Helper] Введите текст рекламы!'), 0xFF0000)
		end
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
end
function renderSobesEfir()
	imgui.Text('Эфир "Собеседование"')
	imgui.Separator()
	renderIntervalControl('sobes', 'Интервал между сообщениями (мс)')
	local bg = settings.colors.background
	local item = settings.colors.itemButtons
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('play') .. ' Начать объявление', imgui.ImVec2(150, 25)) then
	if fa_font then imgui.PopFont() end
		startEfir('sobes')
		efir.confirmEndEfir = false
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(2)
	imgui.SameLine()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.6, 0.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.7, 0.3, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.5, 0.1, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('stop') .. ' Завершить объявление', imgui.ImVec2(160, 25)) then
		if fa_font then imgui.PopFont() end
		_G.currentEfirType = 'sobes'
		endEfir()
		efir.control.shouldEnd = true
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	imgui.SameLine()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.2, 0.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.3, 0.3, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.1, 0.1, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('flag_checkered') .. ' Завершить', imgui.ImVec2(100, 25)) then
		if fa_font then imgui.PopFont() end
		if not efir.confirmEndEfir then
			efir.confirmEndEfir = true
		else
			if efir.control.running then
				stopEfir()
			else
				chatMessage(u8:decode('[News Helper] Эфир не запущен'), 0xFF0000)
			end
			efir.confirmEndEfir = false
		end
	end
	if efir.confirmEndEfir and imgui.IsItemHovered() then
		imgui.SetTooltip('Нажмите еще раз для подтверждения')
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	imgui.Spacing()
	imgui.TextWrapped('Эфир для объявления о собеседовании в СМИ')
end
function renderScoreBoard()
	if efir.auto.active then
		imgui.Spacing()
		imgui.BeginChild('##AutoScoreBoard', imgui.ImVec2(-1, 100), true)
		imgui.Text('Таблица баллов:')
		imgui.Separator()
		local sortedScores = {}
		for name, score in pairs(efir.counter) do
			table.insert(sortedScores, {name = name, score = score})
		end
		table.sort(sortedScores, function(a, b) return a.score > b.score end)
		local colors = {
			imgui.ImVec4(1.0, 0.84, 0.0, 1),
			imgui.ImVec4(0.75, 0.75, 0.75, 1),
			imgui.ImVec4(0.8, 0.6, 0.2, 1),
			imgui.ImVec4(1.0, 1.0, 1.0, 1)
		}
		if #sortedScores == 0 then
			imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'Пока никто не набрал баллов')
		else
			for place, playerData in ipairs(sortedScores) do
				if place <= 4 then
					imgui.TextColored(colors[place], string.format("%d. %s = %d", place, playerData.name, playerData.score))
				else
					imgui.Text(string.format("%d. %s = %d", place, playerData.name, playerData.score))
				end
			end
		end
		imgui.EndChild()
		return
	end
	if efir.auto.updating then
		imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'Обновление данных...')
		return
	end
	imgui.Spacing()
	imgui.BeginChild('##ScoreBoard', imgui.ImVec2(-1, 100), true)
	imgui.Text('Таблица баллов:')
	imgui.Separator()
	local sortedScores = {}
	for name, score in pairs(efir.counter) do
		table.insert(sortedScores, {name = name, score = score})
	end
	table.sort(sortedScores, function(a, b) return a.score > b.score end)
	local colors = {
		imgui.ImVec4(1.0, 0.84, 0.0, 1),
		imgui.ImVec4(0.75, 0.75, 0.75, 1),
		imgui.ImVec4(0.8, 0.6, 0.2, 1),
		imgui.ImVec4(1.0, 1.0, 1.0, 1)
	}
	if #sortedScores == 0 then
		imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'Пока никто не набрал баллов')
	else
		for place, playerData in ipairs(sortedScores) do
			if place <= 4 then
				imgui.TextColored(colors[place], string.format("%d. %s = %d", place, playerData.name, playerData.score))
			else
				imgui.Text(string.format("%d. %s = %d", place, playerData.name, playerData.score))
			end
		end
	end
	imgui.EndChild()
	imgui.Spacing()
	local item = settings.colors.itemButtons
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.2, 0.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.3, 0.3, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.1, 0.1, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('trash_can') .. ' Очистить баллы', imgui.ImVec2(-1, 25)) then
		if fa_font then imgui.PopFont() end
		clearScoreboard()
	end
	imgui.PopStyleColor(3)
end
function clearScoreboard()
	queueClearScore()
	efir.counter = {}
	efir.lastBallVariant = {}
	chatMessage(u8:decode('[News Helper] Таблица баллов очищена'), 0x00FF00)
end
function renderAutoEfirScoreBoard()
	imgui.Spacing()
	imgui.Separator()
	imgui.Spacing()
	imgui.Text('Таблица баллов:')
	local sortedScores = {}
	for name, score in pairs(efir.counter) do
		table.insert(sortedScores, {name = name, score = score})
	end
	table.sort(sortedScores, function(a, b) return a.score > b.score end)
	local colors = {
		imgui.ImVec4(1.0, 0.84, 0.0, 1),
		imgui.ImVec4(0.75, 0.75, 0.75, 1),
		imgui.ImVec4(0.8, 0.6, 0.2, 1),
		imgui.ImVec4(1.0, 1.0, 1.0, 1)
	}
	if #sortedScores == 0 then
		imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'Пока никто не набрал баллов')
	else
		for place, playerData in ipairs(sortedScores) do
			if place <= 4 then
				imgui.TextColored(colors[place], string.format("%d. %s = %d", place, playerData.name, playerData.score))
			else
				imgui.Text(string.format("%d. %s = %d", place, playerData.name, playerData.score))
			end
		end
	end
end
function deepCopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[deepCopy(orig_key)] = deepCopy(orig_value)
		end
		setmetatable(copy, deepCopy(getmetatable(orig)))
	else
		copy = orig
	end
	return copy
end
function countStars(text)
	if not text then return 0 end
	local count = 0
	for _ in text:gmatch("%*") do
		count = count + 1
	end
	return count
end
function replaceStars(text, replacements)
	if not text or not replacements then return text end
	local result = text
	for i, replacement in ipairs(replacements) do
		result = result:gsub("%*", replacement, 1)
	end
	return result
end
function showVariableInputWindow(bindText, isDialog)
	states.enterReleased = false
	states.starPositions = {}
	states.currentStarIndex = 0
	states.lastTextLength = 0
	for i = 1, #bindText do
		if bindText:sub(i, i) == '*' then
			table.insert(states.starPositions, i)
		end
	end
	local processedText = bindText:gsub("%*", "")
	local cursorPosition = nil
	if #states.starPositions > 0 then
		states.currentStarIndex = 1
		for i = 1, #states.starPositions do
			states.starPositions[i] = states.starPositions[i] - (i - 1) - 1
		end
		cursorPosition = states.starPositions[1]
	end
	if isDialog and sampIsDialogActive() then
		setDialogTextWithEncoding(processedText)
		if cursorPosition then
			setDialogCursorPos(cursorPosition)
		end
	elseif not isDialog and windows.customAd[0] then
		settings.customAd.responseText = imgui.new.char[1024](processedText)
		if cursorPosition then
			states.pendingCursorPos = cursorPosition
		end
		flags.focusResponse = true
	end
	states.lastTextLength = #processedText
end
function addToHistory()
	for i = editor.historyIndex + 1, #editor.history do
		editor.history[i] = nil
	end
	editor.historyIndex = editor.historyIndex + 1
	editor.history[editor.historyIndex] = deepCopy(data.newsHelpBind)
	if #editor.history > 50 then
		table.remove(editor.history, 1)
		editor.historyIndex = editor.historyIndex - 1
	end
	clearSearchCache()
end
function expandAllCategories()
	for i = 1, #data.newsHelpBind do
		editor.categoryStates[i] = true
	end
	editor.allExpanded = true
end
function collapseAllCategories()
	for i = 1, #data.newsHelpBind do
		editor.categoryStates[i] = false
	end
	editor.allExpanded = false
end
function toggleAllCategories()
	if editor.allExpanded then
		collapseAllCategories()
	else
		expandAllCategories()
	end
end
function undo()
	if canUndo() then
		editor.historyIndex = editor.historyIndex - 1
		data.newsHelpBind = deepCopy(editor.history[editor.historyIndex])
		clearSearchCache()
	else
		chatMessage(u8:decode('[News Helper] Нет действий для отмены'), 0xFF0000)
	end
end
function canUndo() return editor.historyIndex > 1 end
function canRedo() return editor.historyIndex < #editor.history end
function undo()
	if canUndo() then
		editor.historyIndex = editor.historyIndex - 1
		data.newsHelpBind = deepCopy(editor.history[editor.historyIndex])
	else
		chatMessage(u8:decode('[News Helper] Нет действий для отмены'), 0xFF0000)
	end
end
function redo()
	if canRedo() then
		editor.historyIndex = editor.historyIndex + 1
		data.newsHelpBind = deepCopy(editor.history[editor.historyIndex])
	else
		chatMessage(u8:decode('[News Helper] Нет действий для возврата'), 0xFF0000)
	end
end
function resetEditorHistory()
	editor.history = {}
	editor.historyIndex = 0
	addToHistory()
end
function loadBinder()
	local path = settings.configFolder .. 'Binder.json'
	if doesFileExist(path) then
		local file = io.open(path, 'r')
		if file then
			local content = file:read('*a')
			file:close()
			local data = decodeJson(content)
			if data then
				binder.list = data
				for _, bind in ipairs(binder.list) do
					if bind.command and bind.command ~= "" then
						sampRegisterChatCommand(bind.command, function()
							executeBinder(bind)
						end)
					end
				end
				return true
			end
		end
	end
	binder.list = {
		{
			name = "Редактор",
			hotkey = {vk.VK_Q},
			command = "",
			enableOnChat = false,
			enableOnDialog = false,
			requireConfirm = false,
			blockKey = false,
			mode = 1,
			delay = 0,
			lines = {
				{text = "/edit", delay = 0}
			},
			squareText = "/edit",
			confirmed = false
		}
	}
	saveBinder()
	return false
end
function saveBinder()
	local data = {}
	for _, bind in ipairs(binder.list) do
		local bindData = {
			name = bind.name or "без названия",
			hotkey = bind.hotkey or {},
			command = bind.command or "",
			enableOnChat = bind.enableOnChat or false,
			enableOnDialog = bind.enableOnDialog or false,
			requireConfirm = bind.requireConfirm or false,
			blockKey = bind.blockKey or false,
			mode = bind.mode or 1,
			delay = bind.delay or 3000,
			lines = {},
			squareText = bind.squareText or ""
		}
		if bind.lines then
			for _, line in ipairs(bind.lines) do
				table.insert(bindData.lines, {
					text = line.text or ""
				})
			end
		end
		table.insert(data, bindData)
	end
	local path = settings.configFolder .. 'Binder.json'
	local file = io.open(path, 'w')
	if file then
		file:write(encodeJson(data))
		file:close()
		return true
	end
	return false
end
function saveRSSettings()
	local data={
		interactionKey=rsSettings.interactionKey,
		actions={}
	}
	for key,action in pairs(rsSettings.actions) do
		data.actions[key]={
			name=action.name,
			lines=action.lines,
			delay=action.delay,
			needInput=action.needInput,
			inputPlaceholder=action.inputPlaceholder
		}
	end
	local filePath=settings.configFolder..'RSSettings.json'
	local file=io.open(filePath,'w')
	if file then
		file:write(encodeJson(data))
		file:close()
		return true
	end
	return false
end
function loadRSSettings()
	local filePath=settings.configFolder..'RSSettings.json'
	if doesFileExist(filePath) then
		local file=io.open(filePath,'r')
		if file then
			local content=file:read('*a')
			file:close()
			local data=decodeJson(content)
			if data then
				if data.interactionKey then
					rsSettings.interactionKey=data.interactionKey
				end
				if data.actions then
					for key,actionData in pairs(data.actions) do
						if rsSettings.actions[key] then
							rsSettings.actions[key].lines=actionData.lines or rsSettings.actions[key].lines
							rsSettings.actions[key].delay=actionData.delay or rsSettings.actions[key].delay
						end
					end
				end
				return true
			end
		end
	end
	return false
end
function loadHelpBinds()
	local fileName = data.selectedBindsVariant == 1 and 'news_help_binds.json' or 'news_help_binds2.json'
	local filePath = settings.configFolder .. fileName
	local file = io.open(filePath, 'r')
	if file then
		local content = file:read('*a')
		file:close()
		local jsonData = decodeJson(content)
		if jsonData then
			data.newsHelpBind = {}
			for _, category in ipairs(jsonData) do
				local categoryData = { category.category } 
				for _, item in ipairs(category.items) do
					local bindData = { item.name, item.text }
					if item.searchText then
						bindData[3] = item.searchText
					end
					table.insert(categoryData, bindData)
				end
				table.insert(data.newsHelpBind, categoryData)
			end
			chatMessage(
				u8:decode(('[News Helper] Загружено %d категорий биндов (вариант %d)'):format(#data.newsHelpBind, data.selectedBindsVariant)),
				0x00FF00
			)
			clearSearchCache()
		end
	else
		chatMessage(u8:decode('[News Helper] Файл ' .. fileName .. ' не найден!'), 0xFF0000)
	end
	ensureBufferCategory()
	moveBufferCategoryToEnd()
end
function loadEfirMessages()
	local filePath = settings.configFolder .. 'EfirMessages.json'
	if doesFileExist(filePath) then
		local file = io.open(filePath, 'r')
		if file then
			local content = file:read('*a')
			file:close()
			local data = decodeJson(content)
			if data and next(data) then
				efir.messages = createEfirBuffersFromData(data)
				chatMessage(u8:decode('[News Helper] Сообщения эфиров загружены'), 0x00FF00)
				return true
			end
		end
	end
	chatMessage(u8:decode('[News Helper] Создание дефолтных сообщений эфиров...'), 0xFFFF00)
	resetEfirMessagesToDefault('all')
	saveEfirMessagesToFile()
	chatMessage(u8:decode('[News Helper] Файл с сообщениями эфиров создан'), 0x00FF00)
	return true
end
function saveHelpBinds()
	if not data.newsHelpBind or type(data.newsHelpBind) ~= "table" then
		chatMessage(u8:decode('[News Helper] Ошибка: данные биндов не загружены!'), 0xFF0000)
		return false
	end
	local jsonData = {}
	for _, category in ipairs(data.newsHelpBind) do
		if #category >= 1 and category[1] ~= settings.bufferCategoryName then
			local categoryData = {
				category = u8:decode(category[1]), 
				items = {}
			}
			for i = 2, #category do
				if category[i] and #category[i] >= 2 then
					local item = {
						name = u8:decode(category[i][1]), 
						text = u8:decode(category[i][2])
					}
					if category[i][3] then
						item.searchText = u8:decode(category[i][3])
					end
					table.insert(categoryData.items, item)
				end
			end
			table.insert(jsonData, categoryData)
		end
	end
	local fileName = data.selectedBindsVariant == 1 and 'news_help_binds.json' or 'news_help_binds2.json'
	local filePath = settings.configFolder .. fileName
	local file = io.open(filePath, 'w+b')
	if file then
		local jsonText = encodeJson(jsonData)
		file:write(u8:encode(jsonText))		
		file:close()
		resetEditorHistory()
		clearSearchCache()
		chatMessage(u8:decode('[News Helper] Бинды сохранены в ' .. fileName), 0x00FF00)
		return true
	else
		chatMessage(u8:decode('[News Helper] Ошибка сохранения в ' .. filePath), 0xFF0000)
		return false
	end
end
function showCustomAdWindow(data)
	settings.customAd.isPreview = false
	settings.customAd.data = data or {}
	settings.customAd.originalText = settings.customAd.data.advertisement or nil
	settings.customAd.responseText = imgui.new.char[1024]()
	flags.blockSendUntil = os.clock() + 0.2
	windows.customAd[0] = true
	local io = imgui.GetIO()
	io.WantCaptureKeyboard = false
	io.WantTextInput = false
	io.WantCaptureMouse = false
	flags.inputFieldActive = false
	flags.focusResponse = true
	flags.needUnfocus = false
end
function saveConfig()
	local config = {
		selectedTheme = settings.themes.current,
		customThemeColors = settings.themes.list.custom.colors,
		windowPos = settings.windowPos,
		windowSize = settings.windowSize,
		background = {settings.colors.background[0], settings.colors.background[1], settings.colors.background[2]},
		categoryButtons = {settings.colors.categoryButtons[0], settings.colors.categoryButtons[1], settings.colors.categoryButtons[2]},
		itemButtons = {settings.colors.itemButtons[0], settings.colors.itemButtons[1], settings.colors.itemButtons[2]},
		maxBufferSize = settings.maxBufferSize,
		membersCheckerPos = settings.checker.pos,
		membersCheckerFirstSetup = settings.checker.firstSetup,
		membersCheckerEnabled = settings.checker.enabled[0],
		checkerInterval = settings.checker.interval[0],
		checkerTextColor = {settings.checker.textColor[0], settings.checker.textColor[1], settings.checker.textColor[2], settings.checker.textColor[3]},
		checkerFontSize = settings.checker.fontSize[0],
		customAdSize = { x = settings.customAd.size.x, y = settings.customAd.size.y },
		helpHotkey = ui.hotkeys.help,
		proHotkey = ui.hotkeys.pro,
		autologinEnabled = settings.autologin.enabled[0],
		autologinPassword = ffi.string(settings.autologin.password),
		autologinPincode = ffi.string(settings.autologin.pincode),
		editBind = ui.hotkeys.edit,
		settingsHotkey = ui.hotkeys.settings,
		autoBufferEnabled = flags.autoBufferEnabled[0],
		customBinds = data.customBinds,
		pauseEfirHotkey = efir.control.pauseHotkey,
		starJumpKey = settings.starJumpKey,
		autoRPEnabled = autoRP.enabled[0],
		silentMode = settings.silentMode[0],
		devMode = isDevMode,
		efirSettings = {
			lastPrize = ffi.string(efir.inputs.money),
			userGender = user.gender[0]
		},
		autospawnEnabled = flags.autospawnEnabled[0],
		selectedBindsVariant = data.selectedBindsVariant,
		userSettings = {
			c_nick = data.mainIni.config.c_nick,
			c_rang_b = data.mainIni.config.c_rang_b,
			c_cnn = data.mainIni.config.c_cnn,
			c_city_n = data.mainIni.config.c_city_n,
			c_pol = data.mainIni.config.c_pol,
			wave_tag = data.mainIni.config.wave_tag
		},
		devConfig = {
			last_pro_version = data.devConfig.last_pro_version,
			last_ustav_version = data.devConfig.last_ustav_version,
			last_pps_version = data.devConfig.last_pps_version,
			last_nts_version = data.devConfig.last_nts_version
		},
		efirQuestions = {}
	}
	local efirIntervals = {}
	for key, value in pairs(efir.intervals) do
		efirIntervals[key] = value[0]
	end
	config.efirIntervals = efirIntervals
	for efirType, examples in pairs(efir.examples) do
		if examples then
			config.efirQuestions[efirType] = {
				examples = {},
				answers = {}
			}
			for i = 1, efirLineCount[efirType] or 10 do
				if examples[i] then
					local exStr = ffi.string(examples[i])
					if exStr ~= "" then
						config.efirQuestions[efirType].examples[tostring(i)] = exStr
					end
				end
				if efir.answers[efirType] and efir.answers[efirType][i] then
					local ansStr = ffi.string(efir.answers[efirType][i])
					if ansStr ~= "" then
						config.efirQuestions[efirType].answers[tostring(i)] = ansStr
					end
				end
			end
		end
	end
	local jsonText = encodeJson(config)
	if not jsonText then
		chatMessage(u8:decode('[News Helper] Ошибка кодирования конфига в JSON!'), 0xFF0000)
		return false
	end
	local file = io.open(settings.configFolder .. 'news_helper_config.json', 'w')
	if file then
		file:write(jsonText)
		file:close()
		return true
	else
		chatMessage(u8:decode('[News Helper] Не удалось открыть файл конфига!'), 0xFF0000)
		return false
	end
end
function loadConfig()
	local file = io.open(settings.configFolder .. 'news_helper_config.json', 'r')
	if file then
		local content = file:read('*a')
		file:close()
		local config = decodeJson(content)
		if config then
			if config.windowPos then settings.windowPos = config.windowPos end
			if config.windowSize then settings.windowSize = config.windowSize end
			if config.background then
				settings.colors.background[0], settings.colors.background[1], settings.colors.background[2] =
					config.background[1], config.background[2], config.background[3]
			end
			if config.categoryButtons then
				settings.colors.categoryButtons[0], settings.colors.categoryButtons[1], settings.colors.categoryButtons[2] =
					config.categoryButtons[1], config.categoryButtons[2], config.categoryButtons[3]
			end
			if config.itemButtons then
				settings.colors.itemButtons[0], settings.colors.itemButtons[1], settings.colors.itemButtons[2] =
					config.itemButtons[1], config.itemButtons[2], config.itemButtons[3]
			end
			if config.selectedTheme then
				settings.themes.current = config.selectedTheme
			end
			if config.customThemeColors then
				settings.themes.list.custom.colors = config.customThemeColors
			end
			if config.maxBufferSize then settings.maxBufferSize = config.maxBufferSize end
			if config.membersCheckerPos then settings.checker.pos = config.membersCheckerPos end
			if config.membersCheckerFirstSetup ~= nil then settings.checker.firstSetup = config.membersCheckerFirstSetup end
			if config.membersCheckerEnabled ~= nil then
				settings.checker.enabled[0] = config.membersCheckerEnabled
				windows.checker[0] = config.membersCheckerEnabled
			end
			if config.checkerInterval then
				settings.checker.interval[0] = config.checkerInterval
				membersCheckerUpdateInterval = config.checkerInterval * 1000
			end
			if config.checkerTextColor then
				settings.checker.textColor[0] = config.checkerTextColor[1]
				settings.checker.textColor[1] = config.checkerTextColor[2]
				settings.checker.textColor[2] = config.checkerTextColor[3]
				settings.checker.textColor[3] = config.checkerTextColor[4]
			end
			if config.selectedBindsVariant then
				data.selectedBindsVariant = config.selectedBindsVariant
			end
			if config.checkerFontSize then
				settings.checker.fontSize[0] = config.checkerFontSize
				if ui.fonts.checker and type(renderDeleteFont) == "function" then
					renderDeleteFont(ui.fonts.checker)
				end
				ui.fonts.checker = renderCreateFont("Tahoma", settings.checker.fontSize[0], 200, 0)
			end
			if config.customAdSize then
				settings.customAd.size.x = tonumber(config.customAdSize.x) or 420
				settings.customAd.size.y = tonumber(config.customAdSize.y) or 240
			else
				settings.customAd.size.x, settings.customAd.size.y = 420, 240
			end
			if config.efirIntervals then
				for key, value in pairs(config.efirIntervals) do
					if efir.intervals[key] then
						efir.intervals[key][0] = value
					end
				end
			end
			if config.autoRPEnabled ~= nil then
				autoRP.enabled[0] = config.autoRPEnabled
			end
			if config.devMode ~= nil then isDevMode = config.devMode end
			if config.helpHotkey and type(config.helpHotkey) == "table" then ui.hotkeys.help = config.helpHotkey end
			if config.proHotkey and type(config.proHotkey) == "table" then ui.hotkeys.pro = config.proHotkey end
			if config.settingsHotkey and type(config.settingsHotkey) == "table" then ui.hotkeys.settings = config.settingsHotkey end
			if config.autologinEnabled ~= nil then settings.autologin.enabled[0] = config.autologinEnabled end
			if config.autologinPassword then ffi.copy(settings.autologin.password, config.autologinPassword) end
			if config.autologinPincode then ffi.copy(settings.autologin.pincode, config.autologinPincode) end
			if config.editBind and type(config.editBind) == "table" then ui.hotkeys.edit = config.editBind end
			if config.autoBufferEnabled ~= nil then flags.autoBufferEnabled[0] = config.autoBufferEnabled end
			if config.pauseEfirHotkey and type(config.pauseEfirHotkey) == "table" then efir.control.pauseHotkey = config.pauseEfirHotkey end
			if config.autospawnEnabled ~= nil then flags.autospawnEnabled[0] = config.autospawnEnabled end
			if config.starJumpKey then settings.starJumpKey = config.starJumpKey end
			if config.silentMode ~= nil then settings.silentMode[0] = config.silentMode end
			if config.efirSettings then
				if config.efirSettings.lastPrize then ffi.copy(efir.inputs.money, config.efirSettings.lastPrize) end
				if config.efirSettings.userGender then 
					user.gender[0] = config.efirSettings.userGender
					user.radioInt[0] = config.efirSettings.userGender
				end
			end
			if config.customBinds then
				data.customBinds = config.customBinds
				for cmd, text in pairs(data.customBinds) do
					sampRegisterChatCommand(cmd, function()
						sampSendChat(data.customBinds[cmd])
					end)
				end
			end
			if config.userSettings then
				data.mainIni.config.c_nick = config.userSettings.c_nick or ""
				data.mainIni.config.c_rang_b = config.userSettings.c_rang_b or ""
				data.mainIni.config.c_cnn = config.userSettings.c_cnn or ""
				data.mainIni.config.c_city_n = config.userSettings.c_city_n or ""
				data.mainIni.config.c_pol = config.userSettings.c_pol or 2
				data.mainIni.config.wave_tag = config.userSettings.wave_tag or "VaF"
				ffi.copy(user.waveTag, data.mainIni.config.wave_tag)
				if config.userSettings.c_cnn then
					ffi.fill(user.org, ffi.sizeof(user.org))
					ffi.copy(user.org, config.userSettings.c_cnn)
				end
				if config.userSettings.c_city_n then
					ffi.fill(user.city, ffi.sizeof(user.city))
					ffi.copy(user.city, config.userSettings.c_city_n)
				end
			end
			if config.devConfig then
				data.devConfig.last_pro_version = config.devConfig.last_pro_version or 0
				data.devConfig.last_ustav_version = config.devConfig.last_ustav_version or 0
				data.devConfig.last_pps_version = config.devConfig.last_pps_version or 0
				data.devConfig.last_nts_version = config.devConfig.last_nts_version or 0
			end
			if config.efirQuestions then
				for efirType, qdata in pairs(config.efirQuestions) do
					if not efir.examples[efirType] then
						efir.examples[efirType] = {}
					end
					if not efir.answers[efirType] then
						efir.answers[efirType] = {}
					end
					for i = 1, (efirLineCount[efirType] or 10) do
						if not efir.examples[efirType][i] then
							efir.examples[efirType][i] = imgui.new.char[256]()
						end
						if not efir.answers[efirType][i] then
							efir.answers[efirType][i] = imgui.new.char[256]()
						end
					end
					if qdata.examples then
						for i = 1, (efirLineCount[efirType] or 10) do
							local example = qdata.examples[tostring(i)]
							if example and example ~= "" then
								ffi.copy(efir.examples[efirType][i], example)
							end
						end
					end
					if qdata.answers then
						for i = 1, (efirLineCount[efirType] or 10) do
							local answer = qdata.answers[tostring(i)]
							if answer and answer ~= "" then
								ffi.copy(efir.answers[efirType][i], answer)
							end
						end
					end
				end
			end
		end
	end
end
function saveEfirMessagesToFile()
	local efirData = {}
	for efirType, messages in pairs(efir.messages) do
		if type(messages) == "table" then
			efirData[efirType] = {
				messages = {},
				displayNames = {}
			}
			for key, charPtr in pairs(messages) do
				if type(charPtr) == "cdata" then
					efirData[efirType].messages[key] = ffi.string(charPtr)
				elseif type(charPtr) == "string" then
					efirData[efirType].messages[key] = charPtr
				else
					efirData[efirType].messages[key] = tostring(charPtr) or ""
				end
			end
			if efir.messageDisplayNames and efir.messageDisplayNames[efirType] then
				efirData[efirType].displayNames = efir.messageDisplayNames[efirType]
			end
		end
	end
	local filePath = settings.configFolder .. 'EfirMessages.json'
	local file = io.open(filePath, 'w')
	if file then
		file:write(encodeJson(efirData))
		file:close()
		return true
	else
		chatMessage(u8:decode('[News Helper] Ошибка сохранения сообщений эфиров'), 0xFF0000)
		return false
	end
end
function updateMembersList()
	if windows.customAd[0] then return end
	if not sampIsLocalPlayerSpawned() then return end
	if not settings.checker.enabled[0] then return end
	if sampIsCursorActive() then return end
	if settings.checker.waiting then 
		local elapsed = os.clock() - settings.checker.requestTime
		if elapsed > settings.checker.timeout then
			settings.checker.waiting = false
			settings.checker.requestAttempts = settings.checker.requestAttempts + 1
			if settings.checker.requestAttempts >= settings.checker.maxRequestAttempts then
				settings.checker.requestAttempts = 0
				settings.checker.lastUpdate = os.clock()
			end
		end
		return
	end
	local now = os.clock()
	local updateInterval = settings.checker.interval[0]
	if now - settings.checker.lastUpdate < updateInterval then return end
	if sampIsChatInputActive() or sampIsDialogActive() or sampIsCursorActive() then return end
	settings.checker.waiting = true
	settings.checker.requestTime = os.clock()
	settings.checker.lastUpdate = now
	lua_thread.create(function()
		wait(300)
		if not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsCursorActive() then
			sampSendChat("/members")
		else
			settings.checker.waiting = false
		end
	end)
end
function checkAllDocVersions()
	local docs = {
		{key = 'pro', file = 'NewsPRO.json', url = 'https://raw.githubusercontent.com/alikhandwawd/newstools/refs/heads/main/NewsPRO.json'},
		{key = 'ustav', file = 'NewsUstav.json', url = 'https://raw.githubusercontent.com/alikhandwawd/newstools/refs/heads/main/NewsUstav.json'},
		{key = 'pps', file = 'NewsPPS.json', url = 'https://raw.githubusercontent.com/alikhandwawd/newstools/refs/heads/main/NewsPPS.json'},
		{key = 'nts', file = 'NewsNTS.json', url = 'https://raw.githubusercontent.com/alikhandwawd/newstools/refs/heads/main/NewsNTS.json'}
	}
	for _, doc in ipairs(docs) do
		local versionKey = doc.key .. '_version'
		local lastVersionKey = 'last_' .. doc.key .. '_version'
		if data.devConfig[versionKey] > data.devConfig[lastVersionKey] then
			sampAddChatMessage(u8:decode('[News Helper] Обнаружена новая версия ' .. doc.file .. '. Обновление...'), 0xFFFF00)
			local docFilePath = settings.configFolder .. doc.file
			if doesFileExist(docFilePath) then
				os.remove(docFilePath)
			end
			lua_thread.create(function()
				local response = requests.get(doc.url, { timeout = 10 })
				if response and response.status_code == 200 and response.text then
					local f = io.open(docFilePath, "w")
					if f then
						f:write(response.text)
						f:close()
						if doc.key == 'pro' then
							data.PROtext = response.text
						elseif doc.key == 'ustav' then
							data.Ustavtext = response.text
						elseif doc.key == 'pps' then
							data.PPStext = response.text
						elseif doc.key == 'nts' then
							data.NTStext = response.text
						end
						data.devConfig[lastVersionKey] = data.devConfig[versionKey]
						saveConfig()
						sampAddChatMessage(u8:decode('[News Helper] ' .. doc.file .. ' обновлен до версии ' .. data.devConfig[versionKey] .. '!'), 0x00FF00)
					end
				else
					sampAddChatMessage(u8:decode('[News Helper] Ошибка загрузки ' .. doc.file), 0xFF0000)
				end
			end)
		end
	end
end
function loadAllDocuments()
	local docs = {
		{key = 'pro', file = 'NewsPRO.json', var = 'PROtext'},
		{key = 'ustav', file = 'NewsUstav.json', var = 'Ustavtext'},
		{key = 'pps', file = 'NewsPPS.json', var = 'PPStext'},
		{key = 'nts', file = 'NewsNTS.json', var = 'NTStext'}
	}
	for _, doc in ipairs(docs) do
		local filePath = settings.configFolder .. doc.file
		if doesFileExist(filePath) then
			local f = io.open(filePath, "r")
			local content = f:read("*a")
			f:close()
			if content then
				data[doc.var] = content
			end
		else
			sampAddChatMessage(u8:decode('[News Helper] Файл ' .. doc.file .. ' не найден!'), 0xFF0000)
		end
	end
end
function ensureJsonFiles()
	local files = {
		{ name = "NewsPRO.json", url = "https://raw.githubusercontent.com/alikhandwawd/newstools/refs/heads/main/NewsPRO.json" },
		{ name = "NewsUstav.json", url = "https://raw.githubusercontent.com/alikhandwawd/newstools/refs/heads/main/NewsUstav.json" },
		{ name = "NewsPPS.json", url = "https://raw.githubusercontent.com/alikhandwawd/newstools/refs/heads/main/NewsPPS.json" },
		{ name = "NewsNTS.json", url = "https://raw.githubusercontent.com/alikhandwawd/newstools/refs/heads/main/NewsNTS.json" },
		{ name = "news_help_binds.json", url = "https://raw.githubusercontent.com/alikhandwawd/newstools/refs/heads/main/news_help_binds.json" },
		{ name = "news_help_binds2.json", url = "https://raw.githubusercontent.com/alikhandwawd/newstools/refs/heads/main/news_help_binds2.json" },
		{ name = "EfirMessages.json", url = "https://raw.githubusercontent.com/alikhandwawd/newstools/refs/heads/main/EfirMessages.json" }
	}
	for _, file in ipairs(files) do
		local filePath = settings.configFolder .. file.name
		if not doesFileExist(filePath) then
			lua_thread.create(function()
				local msg1 = string.format("[News Helper] Загружаем %s...", file.name)
				sampAddChatMessage(u8:decode(msg1), 0xFFFF00)
				local response = requests.get(file.url, { timeout = 10 })
				if response and response.status_code == 200 and response.text then
					local f = io.open(filePath, "w")
					if f then
						f:write(response.text)
						f:close()
						local msg2 = string.format("[News Helper] %s успешно загружен!", file.name)
						sampAddChatMessage(u8:decode(msg2), 0x00FF00)
						sampAddChatMessage(u8:decode("[News Helper] Введите /reloadbinds чтобы обновить."), 0x00FF00)
						if file.name == "EfirMessages.json" then
							local data = decodeJson(response.text)
							if data then
								efir.messages = createEfirBuffersFromData(data)
							end
						end
					else
						local msg3 = string.format("[News Helper] Ошибка сохранения %s", file.name)
						sampAddChatMessage(u8:decode(msg3), 0xFF0000)
					end
				end
			end)
		end
	end
end
function reloadEfirMessages()
	local filePath = settings.configFolder .. 'EfirMessages.json'
	if doesFileExist(filePath) then
		os.remove(filePath)
	end
	loadEfirMessages()
end
function applyStyle()
	local style = imgui.GetStyle()
	local colors = style.Colors
	style.WindowRounding = 8
	style.FrameRounding = 4
	style.ScrollbarRounding = 4
	style.WindowBorderSize = 0
	
	local currentColors = settings.themes.list.custom.colors
	if not currentColors or not next(currentColors) then
		currentColors = settings.themes.list.default.colors
	end
	if currentColors.TitleBgActive then
		currentColors.TitleBg = {
			currentColors.TitleBgActive[1] * 0.7,
			currentColors.TitleBgActive[2] * 0.7,
			currentColors.TitleBgActive[3] * 0.7,
			currentColors.TitleBgActive[4]
		}
	end
	if currentColors.ScrollbarGrab then
		currentColors.ScrollbarBg = {
			currentColors.ScrollbarGrab[1] * 0.3,
			currentColors.ScrollbarGrab[2] * 0.3,
			currentColors.ScrollbarGrab[3] * 0.3,
			0.53
		}
		currentColors.ScrollbarGrabHovered = {
			math.min(currentColors.ScrollbarGrab[1] * 1.2, 1),
			math.min(currentColors.ScrollbarGrab[2] * 1.2, 1),
			math.min(currentColors.ScrollbarGrab[3] * 1.2, 1),
			currentColors.ScrollbarGrab[4]
		}
		currentColors.ScrollbarGrabActive = {
			math.min(currentColors.ScrollbarGrab[1] * 1.4, 1),
			math.min(currentColors.ScrollbarGrab[2] * 1.4, 1),
			math.min(currentColors.ScrollbarGrab[3] * 1.4, 1),
			currentColors.ScrollbarGrab[4]
		}
	end
	
	if currentColors.FrameBgHovered then
		currentColors.FrameBg = {
			currentColors.FrameBgHovered[1] * 0.85,
			currentColors.FrameBgHovered[2] * 0.85,
			currentColors.FrameBgHovered[3] * 0.85,
			currentColors.FrameBgHovered[4]
		}
	end
	local validImGuiColors = {
		"Text", "TextDisabled", "WindowBg", "ChildBg", "PopupBg", "Border", "BorderShadow",
		"FrameBg", "FrameBgHovered", "FrameBgActive", "TitleBg", "TitleBgActive", "TitleBgCollapsed",
		"MenuBarBg", "ScrollbarBg", "ScrollbarGrab", "ScrollbarGrabHovered", "ScrollbarGrabActive",
		"CheckMark", "SliderGrab", "SliderGrabActive", "Button", "ButtonHovered", "ButtonActive",
		"Header", "HeaderHovered", "HeaderActive", "Separator", "SeparatorHovered", "SeparatorActive",
		"ResizeGrip", "ResizeGripHovered", "ResizeGripActive", "Tab", "TabHovered", "TabActive",
		"TabUnfocused", "TabUnfocusedActive", "PlotLines", "PlotLinesHovered", "PlotHistogram",
		"PlotHistogramHovered", "TextSelectedBg", "DragDropTarget", "NavHighlight", "NavWindowingHighlight",
		"NavWindowingDimBg", "ModalWindowDimBg"
	}
	for _, colorName in ipairs(validImGuiColors) do
		if currentColors[colorName] then
			local colIdx = imgui.Col[colorName]
			if colIdx then
				local colorValue = currentColors[colorName]
				colors[colIdx] = imgui.ImVec4(colorValue[1], colorValue[2], colorValue[3], colorValue[4])
			end
		end
	end
	if currentColors.Button then
		settings.colors.itemButtons[0] = currentColors.Button[1]
		settings.colors.itemButtons[1] = currentColors.Button[2]
		settings.colors.itemButtons[2] = currentColors.Button[3]
		settings.colors.itemButtons[3] = currentColors.Button[4]
	end
	if currentColors.CategoryColor then
		settings.colors.categoryButtons[0] = currentColors.CategoryColor[1]
		settings.colors.categoryButtons[1] = currentColors.CategoryColor[2]
		settings.colors.categoryButtons[2] = currentColors.CategoryColor[3]
		colors[imgui.Col.Header] = imgui.ImVec4(
			currentColors.CategoryColor[1], 
			currentColors.CategoryColor[2], 
			currentColors.CategoryColor[3], 
			0.31
		)
		colors[imgui.Col.HeaderHovered] = imgui.ImVec4(
			math.min(currentColors.CategoryColor[1] * 1.2, 1),
			math.min(currentColors.CategoryColor[2] * 1.2, 1),
			math.min(currentColors.CategoryColor[3] * 1.2, 1),
			0.8
		)
		colors[imgui.Col.HeaderActive] = imgui.ImVec4(
			math.min(currentColors.CategoryColor[1] * 1.4, 1),
			math.min(currentColors.CategoryColor[2] * 1.4, 1),
			math.min(currentColors.CategoryColor[3] * 1.4, 1),
			1
		)
	end
	if currentColors.WindowBg then
		settings.colors.background[0] = currentColors.WindowBg[1]
		settings.colors.background[1] = currentColors.WindowBg[2]
		settings.colors.background[2] = currentColors.WindowBg[3]
	end
end
function applyTheme()
	local style = imgui.GetStyle()
	local theme = settings.themes.list[settings.themes.current]
	if not theme or settings.themes.current == "custom" then return end
	local colors = style.Colors
	for k, v in pairs(theme.colors) do
		if imgui.Col[k] then
			colors[imgui.Col[k]] = imgui.ImVec4(v[1], v[2], v[3], v[4])
		end
	end
	style.FrameRounding = 5
end
function setupSliderStyle()
	local currentThemeColors = settings.themes.list.custom.colors
	if not currentThemeColors or not next(currentThemeColors) then
		currentThemeColors = settings.themes.list.default.colors
	end
	local sliderBgColor = currentThemeColors["FrameBgHovered"] or {0.16, 0.29, 0.48, 0.54}
	local sliderBgHoveredColor = {
		math.min(sliderBgColor[1] * 1.2, 1),
		math.min(sliderBgColor[2] * 1.2, 1),
		math.min(sliderBgColor[3] * 1.2, 1),
		sliderBgColor[4]
	}
	local sliderBgActiveColor = {
		math.min(sliderBgColor[1] * 1.4, 1),
		math.min(sliderBgColor[2] * 1.4, 1),
		math.min(sliderBgColor[3] * 1.4, 1),
		sliderBgColor[4]
	}
	imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImVec4(sliderBgColor[1], sliderBgColor[2], sliderBgColor[3], sliderBgColor[4]))
	imgui.PushStyleColor(imgui.Col.FrameBgHovered, imgui.ImVec4(sliderBgHoveredColor[1], sliderBgHoveredColor[2], sliderBgHoveredColor[3], sliderBgHoveredColor[4]))
	imgui.PushStyleColor(imgui.Col.FrameBgActive, imgui.ImVec4(sliderBgActiveColor[1], sliderBgActiveColor[2], sliderBgActiveColor[3], sliderBgActiveColor[4]))
end
function cleanupSliderStyle()
	imgui.PopStyleColor(3)
end
function setupInputFieldStyle()
	local currentThemeColors = settings.themes.list.custom.colors
	if not currentThemeColors or not next(currentThemeColors) then
		currentThemeColors = settings.themes.list.default.colors
	end
	local frameBgColor = currentThemeColors["FrameBg"] or {0.16, 0.29, 0.48, 0.54}
	local frameBgHoveredColor = {
		math.min(frameBgColor[1] * 1.15, 1),
		math.min(frameBgColor[2] * 1.15, 1),
		math.min(frameBgColor[3] * 1.15, 1),
		frameBgColor[4]
	}
	local frameBgActiveColor = {
		math.min(frameBgColor[1] * 1.3, 1),
		math.min(frameBgColor[2] * 1.3, 1),
		math.min(frameBgColor[3] * 1.3, 1),
		frameBgColor[4]
	}
	imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImVec4(frameBgColor[1], frameBgColor[2], frameBgColor[3], frameBgColor[4]))
	imgui.PushStyleColor(imgui.Col.FrameBgHovered, imgui.ImVec4(frameBgHoveredColor[1], frameBgHoveredColor[2], frameBgHoveredColor[3], frameBgHoveredColor[4]))
	imgui.PushStyleColor(imgui.Col.FrameBgActive, imgui.ImVec4(frameBgActiveColor[1], frameBgActiveColor[2], frameBgActiveColor[3], frameBgActiveColor[4]))
end
function cleanupInputFieldStyle()
	imgui.PopStyleColor(3)
end
function setupCheckboxStyle()
	local currentThemeColors = settings.themes.list.custom.colors
	if not currentThemeColors or not next(currentThemeColors) then
		currentThemeColors = settings.themes.list.default.colors
	end
	local frameBgActiveColor = currentThemeColors["FrameBgActive"] or {0.16, 0.29, 0.48, 0.54}
	local frameBgActiveLighter = {
		math.min(frameBgActiveColor[1] * 1.2, 1),
		math.min(frameBgActiveColor[2] * 1.2, 1),
		math.min(frameBgActiveColor[3] * 1.2, 1),
		frameBgActiveColor[4]
	}
	local checkMarkColor = {
		math.min(frameBgActiveColor[1] * 1.4, 1),
		math.min(frameBgActiveColor[2] * 1.4, 1),
		math.min(frameBgActiveColor[3] * 1.4, 1),
		1
	}
	imgui.PushStyleColor(imgui.Col.CheckMark, imgui.ImVec4(checkMarkColor[1], checkMarkColor[2], checkMarkColor[3], checkMarkColor[4]))
	imgui.PushStyleColor(imgui.Col.FrameBgActive, imgui.ImVec4(frameBgActiveLighter[1], frameBgActiveLighter[2], frameBgActiveLighter[3], frameBgActiveLighter[4]))
	imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImVec4(frameBgActiveColor[1], frameBgActiveColor[2], frameBgActiveColor[3], frameBgActiveColor[4]))
end
function cleanupCheckboxStyle()
	imgui.PopStyleColor(3)
end
function setupScrollbarStyle()
	local currentThemeColors = settings.themes.list.custom.colors
	if not currentThemeColors or not next(currentThemeColors) then
		currentThemeColors = settings.themes.list.default.colors
	end
	local scrollbarGrabColor = currentThemeColors["ScrollbarGrab"] or {0.31, 0.31, 0.31, 1}
	local scrollbarBgColor = {
		scrollbarGrabColor[1] * 0.3,
		scrollbarGrabColor[2] * 0.3,
		scrollbarGrabColor[3] * 0.3,
		0.53
	}
	local scrollbarGrabHoveredColor = {
		math.min(scrollbarGrabColor[1] * 1.2, 1),
		math.min(scrollbarGrabColor[2] * 1.2, 1),
		math.min(scrollbarGrabColor[3] * 1.2, 1),
		scrollbarGrabColor[4]
	}
	local scrollbarGrabActiveColor = {
		math.min(scrollbarGrabColor[1] * 1.4, 1),
		math.min(scrollbarGrabColor[2] * 1.4, 1),
		math.min(scrollbarGrabColor[3] * 1.4, 1),
		scrollbarGrabColor[4]
	}
	imgui.PushStyleColor(imgui.Col.ScrollbarBg, imgui.ImVec4(scrollbarBgColor[1], scrollbarBgColor[2], scrollbarBgColor[3], scrollbarBgColor[4]))
	imgui.PushStyleColor(imgui.Col.ScrollbarGrab, imgui.ImVec4(scrollbarGrabColor[1], scrollbarGrabColor[2], scrollbarGrabColor[3], scrollbarGrabColor[4]))
	imgui.PushStyleColor(imgui.Col.ScrollbarGrabHovered, imgui.ImVec4(scrollbarGrabHoveredColor[1], scrollbarGrabHoveredColor[2], scrollbarGrabHoveredColor[3], scrollbarGrabHoveredColor[4]))
	imgui.PushStyleColor(imgui.Col.ScrollbarGrabActive, imgui.ImVec4(scrollbarGrabActiveColor[1], scrollbarGrabActiveColor[2], scrollbarGrabActiveColor[3], scrollbarGrabActiveColor[4]))
end
function cleanupScrollbarStyle()
	imgui.PopStyleColor(4)
end
function setupHeaderStyle()
	local currentThemeColors = settings.themes.list.custom.colors
	if not currentThemeColors or not next(currentThemeColors) then
		currentThemeColors = settings.themes.list.default.colors
	end
	local titleBgActiveColor = currentThemeColors["TitleBgActive"] or {0.16, 0.29, 0.48, 1}
	local titleBgColor = {
		titleBgActiveColor[1] * 0.7,
		titleBgActiveColor[2] * 0.7,
		titleBgActiveColor[3] * 0.7,
		titleBgActiveColor[4]
	}
	local headerColor = {
		titleBgActiveColor[1] * 0.5,
		titleBgActiveColor[2] * 0.5,
		titleBgActiveColor[3] * 0.5,
		0.55
	}
	local headerHoveredColor = {
		math.min(headerColor[1] * 1.3, 1),
		math.min(headerColor[2] * 1.3, 1),
		math.min(headerColor[3] * 1.3, 1),
		0.8
	}
	local headerActiveColor = {
		math.min(headerColor[1] * 1.5, 1),
		math.min(headerColor[2] * 1.5, 1),
		math.min(headerColor[3] * 1.5, 1),
		1
	}
	imgui.PushStyleColor(imgui.Col.TitleBg, imgui.ImVec4(titleBgColor[1], titleBgColor[2], titleBgColor[3], titleBgColor[4]))
	imgui.PushStyleColor(imgui.Col.TitleBgActive, imgui.ImVec4(titleBgActiveColor[1], titleBgActiveColor[2], titleBgActiveColor[3], titleBgActiveColor[4]))
	imgui.PushStyleColor(imgui.Col.Header, imgui.ImVec4(headerColor[1], headerColor[2], headerColor[3], headerColor[4]))
	imgui.PushStyleColor(imgui.Col.HeaderHovered, imgui.ImVec4(headerHoveredColor[1], headerHoveredColor[2], headerHoveredColor[3], headerHoveredColor[4]))
	imgui.PushStyleColor(imgui.Col.HeaderActive, imgui.ImVec4(headerActiveColor[1], headerActiveColor[2], headerActiveColor[3], headerActiveColor[4]))
end
function cleanupHeaderStyle()
	imgui.PopStyleColor(5)
end
function ev.onShowDialog(id, style, title, button1, button2, text)
	if settings.autologin.enabled[0] then
		if id == 40 then
			sampSendDialogResponse(40, 1, _, _)
			return false
		end
		if id == 41 then
			if not settings.autologin.badPassword then
				sampSendDialogResponse(41, 1, _, ffi.string(settings.autologin.password))
				return false
			end
		end
		if id == 42 then
			sampSendDialogResponse(42, 1, _, ffi.string(settings.autologin.pincode))
			return false
		end
		if id == 43 then
			sampSendDialogResponse(43, 0, _, _)
			return false
		end
		if id == 44 and flags.autospawnEnabled[0] then
			sampSendDialogResponse(44, 1, 0, _)
			return false
		end
	end
	if id == 10 then
		if settings.checker.waiting or settings.checker.detectingRank then
			data.membersList = parseMembers(text)
			if settings.checker.detectingRank then
				settings.checker.detectingRank = false
				local myRank = getMyRankFromMembers()
				if myRank then
					data.mainIni.config.c_rang_b = myRank
					if user.rang then ffi.copy(user.rang, myRank) end
					saveConfig()
					if not settings.silentMode[0] then
						chatMessage(u8:decode('[News Helper] Ранг определен: ' .. myRank), 0x00FF00)
					end
				else
					if not settings.silentMode[0] then
						chatMessage(u8:decode('[News Helper] Не удалось определить ранг.'), 0xFF0000)
					end
				end
			end
			settings.checker.waiting = false
			settings.checker.requestAttempts = 0
			settings.checker.requestTime = 0
			sampSendDialogResponse(id, 0, -1, "")
			return false
		end
		return true
	end
	if settings.customAd.deleteMode then
		if id == 697 then
			sampSendDialogResponse(697, 1, 2, "")
			return false
		end
		if id == 32700 then
			sampSendDialogResponse(32700, 1, -1, u8:decode(settings.customAd.deleteReason))
			settings.customAd.deleteMode = false
			settings.customAd.deleteReason = ""
			chatMessage(u8:decode('[News Helper] Объявление удалено'), 0x00FF00)
			return false
		end
		return true
	end
	if id == 698 then
		local adInfo = cp1251_to_utf8(text or ""):gsub("{%x%x%x%x%x%x}", "")
		local author = adInfo:match("Автор:%s*([%w_]+)") or "N/A"
		local authorId = nil
		local isOnline = false
		if author ~= "N/A" then
			for playerId = 0, sampGetMaxPlayerId() do
				if sampIsPlayerConnected(playerId) then
					local playerNick = sampGetPlayerNickname(playerId)
					if playerNick and playerNick:gsub("%[PC%]", ""):gsub("%[M%]", "") == author then
						authorId = playerId
						isOnline = true
						break
					end
				end
			end
		end
		settings.customAd.data.author = author
		settings.customAd.data.authorId = authorId
		settings.customAd.data.isAuthorOnline = isOnline
		settings.customAd.data.phone = adInfo:match("Номер телефона:%s*(%d+)") or "N/A"
		settings.customAd.data.advertisement = adInfo:match("Объявление:%s*(.-)В поле ниже") or "N/A"
		sampSetCursorMode(2)
		showCustomAdWindow(settings.customAd.data)
		return false
	end
	return true
end
function ev.onServerMessage(clr, message)
	message = decode1251(message)
	if settings.autologin.enabled[0] and message:find("Неверный пароль") then
		settings.autologin.badPassword = true
	end
	local originalMessage = message
	if efir.auto.active and efir.auto.waitingForAnswer then
		local smsText = originalMessage:match("SMS:%s*(.-)%s*Отправитель:")
		local sender = originalMessage:match("Отправитель:%s*([%w_%.%[%]%-]+)")
		if smsText and sender then
			sender = sender:gsub("%[.-]%s*$", ""):gsub("^%s+", ""):gsub("%s+$", "")
			local senderCopy = tostring(sender)
			if senderCopy and #senderCopy > 0 then
				if processAutoAnswer(smsText, senderCopy, senderCopy) then
					local modifiedMsg = addIdToSMS(originalMessage)
					modifiedMsg = modifiedMsg:gsub("{%x%x%x%x%x%x}", ""):gsub("{%x%x%x%x%x%x%x%x}", ""):gsub("{%x%x%x%x%x}", "")
					sampAddChatMessage(u8:decode(escapeProblematicChars(modifiedMsg)), 0xFFFF00)
					return false
				end
			end
		end
	end
	if efir.auto.pausedDuringQuestions and originalMessage:match("SMS:") then
		local smsText = originalMessage:match("SMS:%s*(.-)%s*Отправитель:")
		local sender = originalMessage:match("Отправитель:%s*([%w_%.%[%]%-]+)")
		if smsText and sender then
			sender = sender:gsub("%[.-]%s*$", ""):gsub("^%s+", ""):gsub("%s+$", "")
			local senderCopy = tostring(sender)
			if senderCopy and #senderCopy > 0 then
				if processAutoAnswer(smsText, senderCopy, senderCopy) then
					local modifiedMsg = addIdToSMS(originalMessage)
					modifiedMsg = modifiedMsg:gsub("{%x%x%x%x%x%x}", ""):gsub("{%x%x%x%x%x%x%x%x}", ""):gsub("{%x%x%x%x%x}", "")
					sampAddChatMessage(u8:decode(escapeProblematicChars(modifiedMsg)), 0xFFFF00)
					return false
				end
			end
		end
	end
	if efir.mode[0] and efir.awaitingAnswer and efir.currentQuestion > 0 then
		local smsText = originalMessage:match("SMS:%s*(.-)%s*Отправитель:")
		local sender = originalMessage:match("Отправитель:%s*([%w_%.%[%]%-]+)")
		if smsText and sender then
			sender = sender:gsub("%[.-]%s*$", ""):gsub("^%s+", ""):gsub("%s+$", "")
			local currentType = _G.currentEfirType or 'math'
			if not efir.answers[currentType] or not efir.answers[currentType][efir.currentQuestion] then
				return true
			end
			local correctAnswer = ffi.string(efir.answers[currentType][efir.currentQuestion])
			if checkSMSAnswer(smsText, correctAnswer) then
				efir.awaitingAnswer = false
				local translatedName = trst(sender:gsub("_", " "))
				addball(sender:gsub("_", " "))
				local points = efir.counter[sender:gsub("_", " ")]
				lua_thread.create(function()
					wait(efir.intervals[currentType][0])
					local ballMessage = ""
					local variantType = ""
					if points == 1 then
						variantType = "ball1"
					elseif points <= 4 then
						variantType = "ball2"
					else
						variantType = "ball5"
					end
					local variants = {}
					for msgKey, _ in pairs(efir.messages[currentType]) do
						if msgKey == variantType or msgKey:match("^" .. variantType .. "%.%d+$") then
							table.insert(variants, msgKey)
						end
					end
					if #variants > 0 then
						if not efir.lastBallVariant[sender:gsub("_", " ")] then
							efir.lastBallVariant[sender:gsub("_", " ")] = 1
						else
							efir.lastBallVariant[sender:gsub("_", " ")] = (efir.lastBallVariant[sender:gsub("_", " ")] % #variants) + 1
						end
						local selectedVariant = variants[efir.lastBallVariant[sender:gsub("_", " ")]]
						ballMessage = ffi.string(efir.messages[currentType][selectedVariant])
					end
					ballMessage = replaceEfirVariables(ballMessage)
					ballMessage = ballMessage:gsub("%%", tostring(points))
					ballMessage = ballMessage:gsub("%*1", translatedName)
					sampSendChat(u8:decode(ballMessage))
					if points == 10 then
						local messages = efir.messages[currentType]
						if messages then
							wait(4000)
							local winnerMsg1 = replaceEfirVariables(ffi.string(messages.winner1))
							sampSendChat(u8:decode(winnerMsg1))
							wait(4000)
							local winnerMsg2 = replaceEfirVariables(ffi.string(messages.winner2)):gsub("%*", translatedName)
							sampSendChat(u8:decode(winnerMsg2))
							wait(4000)
							local winnerMsg3 = replaceEfirVariables(ffi.string(messages.winner3))
							sampSendChat(u8:decode(winnerMsg3))
							wait(4000)
							endEfir()
						end
					else
						efir.currentQuestion = efir.currentQuestion + 1
						if efir.currentQuestion > efirLineCount[currentType] then
							efir.currentQuestion = 1
						end
						wait(2000)
						sendNextQuestion()
					end
				end)
				local modifiedMsg = addIdToSMS(originalMessage)
				modifiedMsg = modifiedMsg:gsub("{%x%x%x%x%x%x}", ""):gsub("{%x%x%x%x%x%x%x%x}", ""):gsub("{%x%x%x%x%x}", "")
				sampAddChatMessage(u8:decode(escapeProblematicChars(modifiedMsg)), 0x00FF00)
				return false
			end
		end
	end
	if originalMessage:match("SMS:") and originalMessage:match("Отправитель:") then
		local modifiedMsg = addIdToSMS(originalMessage)
		modifiedMsg = modifiedMsg:gsub("{%x%x%x%x%x%x}", ""):gsub("{%x%x%x%x%x%x%x%x}", ""):gsub("{%x%x%x%x%x}", "")
		sampAddChatMessage(u8:decode(escapeProblematicChars(modifiedMsg)), 0xFFFF00)
		return false
	end
	return true
end
function addIdToSMS(message)
	local beforeSMS = message:match("^(.-)SMS:")
	local smsText = message:match("SMS:%s*(.-)%s*Отправитель:")
	local sender = message:match("Отправитель:%s*(.-)%s*Тел")
	local phone = message:match("Тел%.:%s*(%d+)")
	if not smsText or not sender then
		return message
	end
	sender = sender:gsub("^%s+", ""):gsub("%s+$", ""):gsub("%[.-]$", "")
	local cleanNick = cleanNickname(sender)
	local id = nil
	local _, myId = sampGetPlayerIdByCharHandle(PLAYER_PED)
	if myId then
		local myNick = sampGetPlayerNickname(myId)
		if myNick then
			local cleanMyNick = cleanNickname(myNick)
			if cleanMyNick == cleanNick then
				id = myId
			end
		end
	end
	if not id then
		for playerId = 0, sampGetMaxPlayerId() do
			if sampIsPlayerConnected(playerId) then
				local playerNick = sampGetPlayerNickname(playerId)
				if playerNick then
					local cleanPlayerNick = cleanNickname(playerNick)
					if cleanPlayerNick == cleanNick then
						id = playerId
						break
					end
				end
			end
		end
	end
	beforeSMS = (beforeSMS or ""):gsub("{.-}", "")
	smsText = (smsText or ""):gsub("{.-}", "")
	local result = beforeSMS .. "SMS: " .. smsText .. " Отправитель: " .. cleanNick
	if id then
		result = result .. "[" .. tostring(id) .. "]"
	end
	result = result .. " Тел.: " .. (phone or "?")
	result = result:gsub("{.-}", "")
	return result
end
function ev.onInitGame(playerId)
	chat.myId = playerId
end
function ev.onSendChat(message)
	if not autoRP.enabled[0] then return end
	if message:sub(1, 1) == "/" then return end
	if message:sub(1, 1) == "!" then return end
	if message:sub(1, 1) == "." then return end
	if message:sub(1, 1) == "@" then return end
	if message:match("^%s*$") then return end
	local formatted = formatRPMessage(message)
	if formatted ~= message then
		sampSendChat(formatted)
		return false
	end
end
function doSendResponse()
	if os.clock() < flags.blockSendUntil then
		return false
	end
	local response = ffi.string(settings.customAd.responseText) 
	if response ~= '' and not response:match("^%s*$") then
		if windows.help[0] then
			ui.search.scrollPos = imgui.GetScrollY()
		end
		saveToAdBuffer(response)
		local convertedResponse = u8:decode(response)
		sampSendDialogResponse(698, 1, -1, convertedResponse)
		closeCustomAd(false) 
		return true
	else
		chatMessage(u8:decode('[News Helper] Введите ответ!'), 0xFF0000)
		return false
	end
end
function saveToAdBuffer(editedText, force)
	if not flags.autoBufferEnabled[0] and not force then
		return 
	end
	if not settings.customAd.data.advertisement or settings.customAd.data.advertisement == "N/A" then
		return
	end
	local bufferData = loadBufferFromFile()
	local currentAdNormalized = normalizeForBufferCompare(settings.customAd.data.advertisement)
	local resText = normalizeText(editedText)
	local found = false
	for _, entry in ipairs(bufferData) do
		local entryAdNormalized = normalizeForBufferCompare(entry.advertisement or "")
		if entryAdNormalized == currentAdNormalized and 
			entry.author == settings.customAd.data.author and
			entry.phone == settings.customAd.data.phone then
			entry.editedText = resText
			found = true
			break
		end
	end
	if not found then
		local newEntry = {
			advertisement = settings.customAd.data.advertisement,
			author = settings.customAd.data.author,
			phone = settings.customAd.data.phone,
			editedText = resText,
			displayName = settings.customAd.data.advertisement:sub(1, 30) .. (settings.customAd.data.advertisement:len() > 30 and "." or "")
		}
		table.insert(bufferData, 1, newEntry)
	end
	while #bufferData > settings.maxBufferSize do
		table.remove(bufferData, #bufferData)
	end
	saveBufferToFile(bufferData)
	ui.search.needRestoreScroll = true
	updateBufferCategory(bufferData)
	ui.search.resultsValid = false
	chatMessage(u8:decode('[News Helper] Сохранено в буфер'), 0x00FF00)
end
function ensureBufferCategory()
	local path = settings.bufferFilePath
	if not doesFileExist(path) then
		local file = io.open(path, "w")
		if file then
			file:write("[]")
			file:close()
		end
	end
end
function moveBufferCategoryToEnd()
	local bufferCategoryIndex = nil
	local bufferCategory = nil
	for i = 1, #data.newsHelpBind do
		if data.newsHelpBind[i][1] == settings.bufferCategoryName then
			bufferCategoryIndex = i
			bufferCategory = data.newsHelpBind[i]
			break
		end
	end
	if not bufferCategory then
		table.insert(data.newsHelpBind, {settings.bufferCategoryName})
	elseif bufferCategoryIndex and bufferCategoryIndex < #data.newsHelpBind then
		table.remove(data.newsHelpBind, bufferCategoryIndex)
		table.insert(data.newsHelpBind, bufferCategory)
	end
end
function closeCustomAd(sendResponse, text)
	if sampIsDialogActive() then
		if sendResponse then
			sampSendDialogResponse(698, 1, -1, u8:encode(text))
		else
			sampSendDialogResponse(698, 2, -1, "")
		end
	end
	local reopenMain = settings.customAd.isPreview 
	if settings.customAd.isPreview and settings.customAd.tempSize then
		settings.customAd.size.x = settings.customAd.tempSize.x
		settings.customAd.size.y = settings.customAd.tempSize.y
		saveConfig()
	end
	windows.customAd[0] = false
	settings.customAd.isPreview = false
	if sampGetCursorMode() ~= 0 then
		sampSetCursorMode(0)
	end
	settings.customAd.responseText = imgui.new.char[1024]()
	settings.customAd.originalText = nil
	settings.customAd.data = {}
	flags.lastEnterState = false 
	flags.inputFieldActive = false
	flags.focusResponse = false
	flags.needUnfocus = true
	flags.blockNextEnter = false
	states.enterReleased = false
	local io = imgui.GetIO()
	io.WantCaptureKeyboard = false
	io.WantCaptureMouse = false
	io.WantTextInput = false
	bufferNavigationState.isNavigating = false
	bufferNavigationState.currentIndex = 0
	bufferNavigationState.lastAdText = nil
	bufferNavigationState.originalText = nil
	states.pendingCursorPos = nil
	states.starPositions = {}
	states.currentStarIndex = 1
	if reopenMain then
		windows.mainSettings[0] = true
	end
end
function createNewBinder()
	local newBind = {
		name = "без названия",
		hotkey = {},
		command = "",
		enableOnChat = false,
		enableOnDialog = false,
		requireConfirm = false,
		blockKey = false,
		mode = 1,
		delay = 3000,
		lines = {},
		squareText = "",
		confirmed = false
	}
	table.insert(binder.list, newBind)
	saveBinder()
	return #binder.list
end
function deleteBinder(index)
	if binder.list[index] then
		local cmd = binder.list[index].command
		if cmd and cmd ~= "" then
			sampUnregisterChatCommand(cmd)
		end
		table.remove(binder.list, index)
		saveBinder()
	end
end
function openBinderEdit(index)
	if not binder.list[index] then return end
	local bind = binder.list[index]
	binder.editing = index
	ffi.fill(binderEdit.name, 256)
	ffi.copy(binderEdit.name, bind.name or "без названия")
	binderEdit.hotkey = {}
	for _, key in ipairs(bind.hotkey or {}) do
		table.insert(binderEdit.hotkey, key)
	end
	ffi.fill(binderEdit.command, 64)
	if bind.command then
		ffi.copy(binderEdit.command, bind.command)
	end
	binderEdit.enableOnChat[0] = bind.enableOnChat or false
	binderEdit.enableOnDialog[0] = bind.enableOnDialog or false
	binderEdit.requireConfirm[0] = bind.requireConfirm or false
	binderEdit.blockKey[0] = bind.blockKey or false
	binderEdit.mode[0] = bind.mode or 1
	binderEdit.delay[0] = bind.delay or 3000
	binderEdit.lines = {}
	if bind.lines then
		for _, line in ipairs(bind.lines) do
			table.insert(binderEdit.lines, {
				text = imgui.new.char[512](line.text or ""),
				delay = imgui.new.int(line.delay or bind.delay or 3000)
			})
		end
	end
	if #binderEdit.lines == 0 then
		table.insert(binderEdit.lines, {
			text = imgui.new.char[512](),
			delay = imgui.new.int(bind.delay or 3000)
		})
	end
	ffi.fill(binderEdit.squareText, 8192)
	if bind.squareText then
		ffi.copy(binderEdit.squareText, bind.squareText)
	end
	binder.editWindow[0] = true
end
function saveBinderEdit()
	if not binder.editing or not binder.list[binder.editing] then return end
	local bind = binder.list[binder.editing]
	local oldCmd = bind.command
	bind.name = ffi.string(binderEdit.name)
	bind.hotkey = {}
	for _, key in ipairs(binderEdit.hotkey) do
		table.insert(bind.hotkey, key)
	end
	local newCmd = ffi.string(binderEdit.command)
	bind.command = newCmd
	bind.enableOnChat = binderEdit.enableOnChat[0]
	bind.enableOnDialog = binderEdit.enableOnDialog[0]
	bind.requireConfirm = binderEdit.requireConfirm[0]
	bind.blockKey = binderEdit.blockKey[0]
	bind.mode = binderEdit.mode[0]
	bind.delay = binderEdit.delay[0]
	if binderEdit.mode[0] == 1 then
		bind.lines = {}
		for _, line in ipairs(binderEdit.lines) do
			table.insert(bind.lines, {
				text = ffi.string(line.text),
				delay = line.delay and line.delay[0] or bind.delay
			})
		end
	else
		local squareLines = {}
		local text = ffi.string(binderEdit.squareText)
		for line in text:gmatch("[^\r\n]+") do
			local trimmed = line:gsub("^%s+", ""):gsub("%s+$", "")
			if trimmed ~= "" then
				table.insert(squareLines, {
					text = trimmed,
					delay = bind.delay
				})
			end
		end
		if #squareLines > 0 then
			bind.lines = squareLines
		end
	end
	bind.squareText = ffi.string(binderEdit.squareText)
	if oldCmd ~= newCmd then
		if oldCmd and oldCmd ~= "" then
			sampUnregisterChatCommand(oldCmd)
		end
		if newCmd and newCmd ~= "" then
			sampRegisterChatCommand(newCmd, function()
				executeBinder(bind)
			end)
		end
	end
	saveBinder()
	binder.editWindow[0] = false
	binder.editing = nil
	chatMessage(u8:decode('[News Helper] Бинд сохранен!'), 0x00FF00)
end
function executeBinder(bind)
	if not bind then return end
	if not bind.enableOnChat and sampIsChatInputActive() then return end
	if not bind.enableOnDialog and sampIsDialogActive() then return end
	if bind.requireConfirm then
		if not bind.confirmed then
			bind.confirmed = true
			chatMessage(u8:decode('[News Helper] Нажмите еще раз для подтверждения'), 0xFFFF00)
			lua_thread.create(function()
				wait(3000)
				bind.confirmed = false
			end)
			return
		end
		bind.confirmed = false
	end
	lua_thread.create(function()
		if bind.lines and #bind.lines > 0 then
			for _, line in ipairs(bind.lines) do
				if line.text then
					local text = type(line.text) == "string" and line.text or ffi.string(line.text)
					if text ~= "" then
						sampSendChat(u8:decode(text))
						local delay = 3000
						if line.delay then
							delay = type(line.delay) == "number" and line.delay or line.delay[0]
						elseif bind.delay then
							delay = type(bind.delay) == "number" and bind.delay or bind.delay[0]
						end
						wait(delay)
					end
				end
			end
		end
	end)
end
function getHotkeyDisplayText(keys)
	if not keys or #keys == 0 then
		return "Не назначено"
	end
	local parts = {}
	for _, key in ipairs(keys) do
		table.insert(parts, getKeyName(key))
	end
	return table.concat(parts, " + ")
end
function renderBinderTab()
	imgui.Text('Менеджер биндов:')
	imgui.Separator()
	imgui.Spacing()
	local windowWidth = imgui.GetWindowWidth() - 40
	local buttonSize = 100
	local spacing = 10
	local buttonsPerRow = 6
	local binderCount = #binder.list
	imgui.BeginChild('##BinderList', imgui.ImVec2(0, -10), false)
	binder.hoveredIndex = nil
	local drawList = imgui.GetWindowDrawList()
	for i, bind in ipairs(binder.list) do
		local col = (i - 1) % buttonsPerRow
		if col > 0 then imgui.SameLine(0, spacing) end
		local cursorPos = imgui.GetCursorScreenPos()
		local item = settings.colors.itemButtons
		imgui.PushIDInt(i)
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
		if imgui.Button('##bindbtn', imgui.ImVec2(buttonSize, buttonSize)) then
		end
		local isHovered = imgui.IsItemHovered()
		imgui.PopStyleColor(3)
		local buttonText = bind.name or "без названия"
		if #buttonText > 12 then
			buttonText = buttonText:sub(1, 10) .. ".."
		end
		local textSize = imgui.CalcTextSize(buttonText)
		local textX = cursorPos.x + (buttonSize - textSize.x) / 2
		local textY = cursorPos.y + buttonSize + 3
		drawList:AddText(imgui.ImVec2(textX, textY), imgui.GetColorU32Vec4(imgui.ImVec4(1, 1, 1, 1)), buttonText)
		local statusText1 = ""
		local statusText2 = ""
		local statusColor = imgui.ImVec4(1, 1, 1, 1)
		if bind.hotkey and #bind.hotkey > 0 then
			statusText1 = getHotkeyDisplayText(bind.hotkey)
			statusColor = imgui.ImVec4(1, 1, 1, 1)
		elseif bind.command and bind.command ~= "" then
			statusText1 = "Команда"
			statusText2 = "/" .. bind.command
			statusColor = imgui.ImVec4(1, 1, 1, 1)
		else
			statusText1 = "не назначено"
			statusColor = imgui.ImVec4(0.7, 0.7, 0.7, 1)
		end
		if ui.fonts.binderStatus then imgui.PushFont(ui.fonts.binderStatus) end
		if statusText1 ~= "" then
			local statusSize1 = imgui.CalcTextSize(statusText1)
			local maxWidth = buttonSize - 10
			local statusX1 = cursorPos.x + (buttonSize - math.min(statusSize1.x, maxWidth)) / 2
			local statusY1 = cursorPos.y + (buttonSize - statusSize1.y) / 2
			if statusText2 ~= "" then
				statusY1 = cursorPos.y + (buttonSize / 2) - statusSize1.y - 2
			end
			if statusSize1.x > maxWidth then
				local words = {}
				for word in statusText1:gmatch("%S+") do
					table.insert(words, word)
				end
				local lines = {}
				local currentLine = ""
				for _, word in ipairs(words) do
					local testLine = currentLine == "" and word or currentLine .. " " .. word
					local testSize = imgui.CalcTextSize(testLine)
					if testSize.x > maxWidth and currentLine ~= "" then
						table.insert(lines, currentLine)
						currentLine = word
					else
						currentLine = testLine
					end
				end
				if currentLine ~= "" then
					table.insert(lines, currentLine)
				end
				
				for idx, line in ipairs(lines) do
					local lineSize = imgui.CalcTextSize(line)
					local lineX = cursorPos.x + (buttonSize - lineSize.x) / 2
					local lineY = statusY1 + (idx - 1) * 15
					drawList:AddText(imgui.ImVec2(lineX, lineY), imgui.GetColorU32Vec4(statusColor), line)
				end
			else
				drawList:AddText(imgui.ImVec2(statusX1, statusY1), imgui.GetColorU32Vec4(statusColor), statusText1)
			end
		end
		if statusText2 ~= "" then
			local statusSize2 = imgui.CalcTextSize(statusText2)
			local maxWidth = buttonSize - 10
			local statusX2 = cursorPos.x + (buttonSize - math.min(statusSize2.x, maxWidth)) / 2
			local statusY2 = cursorPos.y + (buttonSize / 2) + 2
			if statusSize2.x > maxWidth then
				local words = {}
				for word in statusText2:gmatch("%S+") do
					table.insert(words, word)
				end
				local lines = {}
				local currentLine = ""
				for _, word in ipairs(words) do
					local testLine = currentLine == "" and word or currentLine .. " " .. word
					local testSize = imgui.CalcTextSize(testLine)
					if testSize.x > maxWidth and currentLine ~= "" then
						table.insert(lines, currentLine)
						currentLine = word
					else
						currentLine = testLine
					end
				end
				if currentLine ~= "" then
					table.insert(lines, currentLine)
				end
				for idx, line in ipairs(lines) do
					local lineSize = imgui.CalcTextSize(line)
					local lineX = cursorPos.x + (buttonSize - lineSize.x) / 2
					local lineY = statusY2 + (idx - 1) * 15
					drawList:AddText(imgui.ImVec2(lineX, lineY), imgui.GetColorU32Vec4(statusColor), line)
				end
			else
				drawList:AddText(imgui.ImVec2(statusX2, statusY2), imgui.GetColorU32Vec4(statusColor), statusText2)
			end
		end
		if ui.fonts.binderStatus then imgui.PopFont() end
		if isHovered then
			binder.hoveredIndex = i
			local btnMin = imgui.ImVec2(cursorPos.x, cursorPos.y)
			local btnMax = imgui.ImVec2(cursorPos.x + buttonSize, cursorPos.y + buttonSize)
			drawList:AddRectFilled(btnMin, btnMax, imgui.GetColorU32Vec4(imgui.ImVec4(0, 0, 0, 0.6)))
			local delBtnSize = 30
			local delBtnX = cursorPos.x + buttonSize - delBtnSize - 5
			local delBtnY = cursorPos.y + 5
			local isConfirming = binder.deleteConfirm == i
			local delColor = isConfirming and imgui.ImVec4(1, 0.3, 0.3, 0.9) or imgui.ImVec4(0.8, 0.2, 0.2, 0.8)
			drawList:AddRectFilled(imgui.ImVec2(delBtnX, delBtnY), imgui.ImVec2(delBtnX + delBtnSize, delBtnY + delBtnSize), imgui.GetColorU32Vec4(delColor), 4)
			if fa_font then imgui.PushFont(fa_font) end
			local trashIcon = fa('trash')
			local trashSize = imgui.CalcTextSize(trashIcon)
			local trashX = delBtnX + (delBtnSize - trashSize.x) / 2
			local trashY = delBtnY + (delBtnSize - trashSize.y) / 2
			drawList:AddText(imgui.ImVec2(trashX, trashY), imgui.GetColorU32Vec4(imgui.ImVec4(1, 1, 1, 1)), trashIcon)
			if fa_font then imgui.PopFont() end
			local mousePos = imgui.GetMousePos()
			local isOnDelete = mousePos.x >= delBtnX and mousePos.x <= delBtnX + delBtnSize and mousePos.y >= delBtnY and mousePos.y <= delBtnY + delBtnSize
			if imgui.IsMouseClicked(0) then
				if isOnDelete then
					if isConfirming then
						deleteBinder(i)
						binder.deleteConfirm = nil
					else
						binder.deleteConfirm = i
					end
				else
					openBinderEdit(i)
				end
			end
			if isOnDelete and isConfirming then
				imgui.SetTooltip('Нажмите еще раз для подтверждения')
			elseif not isOnDelete then
				imgui.SetTooltip('Нажмите чтобы редактировать')
			end
		end
		imgui.PopID()
		if (i % buttonsPerRow == 0) and (i ~= binderCount) then
			imgui.Dummy(imgui.ImVec2(0, 25))
		end
	end
	if binder.hoveredIndex == nil and binder.deleteConfirm then
		binder.deleteConfirm = nil
	end
	local addCol = binderCount % buttonsPerRow
	if addCol > 0 then
		imgui.SameLine(0, spacing)
	else
		imgui.Dummy(imgui.ImVec2(0, 25))
	end
	local addCursorPos = imgui.GetCursorScreenPos()
	local item = settings.colors.itemButtons
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0]*0.7, item[1]*0.7, item[2]*0.7, 0.5))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0], item[1], item[2], 0.8))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('plus') .. '##addnew', imgui.ImVec2(buttonSize, buttonSize)) then
		createNewBinder()
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	local addTextSize = imgui.CalcTextSize('Новый бинд')
	local addTextX = addCursorPos.x + (buttonSize - addTextSize.x) / 2
	local addTextY = addCursorPos.y + buttonSize + 3
	drawList:AddText(imgui.ImVec2(addTextX, addTextY), imgui.GetColorU32Vec4(imgui.ImVec4(1, 1, 1, 1)), 'Новый бинд')
	imgui.EndChild()
end
function renderBinderEditPopup()
	if not binder.editWindow[0] then return end
	local sizeX, sizeY = getScreenResolution()
	imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
	imgui.SetNextWindowSize(imgui.ImVec2(700, 600), imgui.Cond.Always)
	local bg = settings.colors.background
	local item = settings.colors.itemButtons
	imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(bg[0], bg[1], bg[2], 0.98))
	imgui.PushStyleColor(imgui.Col.TitleBg, imgui.ImVec4(item[0], item[1], item[2], 1))
	imgui.PushStyleColor(imgui.Col.TitleBgActive, imgui.ImVec4(item[0]*1.1, item[1]*1.1, item[2]*1.1, 1))
	local windowFlags = imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse
	if imgui.Begin('Редактор бинда##bindedit', binder.editWindow, windowFlags) then
		local inputBg = imgui.ImVec4(bg[0]*0.5, bg[1]*0.5, bg[2]*0.5, 1)
		local inputBgHover = imgui.ImVec4(bg[0]*0.7, bg[1]*0.7, bg[2]*0.7, 1)
		local inputBgActive = imgui.ImVec4(bg[0]*0.9, bg[1]*0.9, bg[2]*0.9, 1)
		imgui.PushItemWidth(420)
		imgui.PushStyleColor(imgui.Col.FrameBg, inputBg)
		imgui.PushStyleColor(imgui.Col.FrameBgHovered, inputBgHover)
		imgui.PushStyleColor(imgui.Col.FrameBgActive, inputBgActive)
		imgui.InputTextWithHint('##bindname', 'Название бинда', binderEdit.name, 256)
		imgui.PopStyleColor(3)
		imgui.PopItemWidth()
		imgui.SameLine()
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(fa('sliders') .. '##conditions', imgui.ImVec2(35, 0)) then
			binder.conditionsWindow[0] = not binder.conditionsWindow[0]
		end
		if fa_font then imgui.PopFont() end
		imgui.PopStyleColor(3)
		imgui.SameLine()
		local viewModeIcon = binderEdit.mode[0] == 1 and fa('bars') or fa('square')
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(viewModeIcon .. '##viewmode', imgui.ImVec2(35, 0)) then
			if binderEdit.mode[0] == 1 then
				local squareLines = {}
				for _, line in ipairs(binderEdit.lines) do
					if line.text then
						local text = ffi.string(line.text)
						if text ~= "" then
							table.insert(squareLines, text)
						end
					end
				end
				local combinedText = table.concat(squareLines, "\n")
				ffi.fill(binderEdit.squareText, ffi.sizeof(binderEdit.squareText))
				ffi.copy(binderEdit.squareText, combinedText)
				binderEdit.mode[0] = 2
			else
				binderEdit.lines = {}
				local text = ffi.string(binderEdit.squareText)
				for line in text:gmatch("[^\r\n]+") do
					local trimmed = line:gsub("^%s+", ""):gsub("%s+$", "")
					if trimmed ~= "" then
						table.insert(binderEdit.lines, {
							text = imgui.new.char[512](trimmed),
							delay = imgui.new.int(binderEdit.delay[0])
						})
					end
				end
				if #binderEdit.lines == 0 then
					table.insert(binderEdit.lines, {
						text = imgui.new.char[512](),
						delay = imgui.new.int(binderEdit.delay[0])
					})
				end
				binderEdit.mode[0] = 1
			end
		end
		if fa_font then imgui.PopFont() end
		imgui.PopStyleColor(3)
		imgui.Spacing()
		imgui.Text('Горячая клавиша:')
		imgui.SameLine()
		local hotkeyText = binder.keyCapture.active and 'Нажмите клавиши...' or getHotkeyDisplayText(binderEdit.hotkey)
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
		if imgui.Button(hotkeyText .. '##hotkey', imgui.ImVec2(200, 25)) then
			local cmdText = ffi.string(binderEdit.command)
			if cmdText ~= "" then
				ffi.fill(binderEdit.command, 64)
			end
			binder.keyCapture.active = true
			binder.keyCapture.keys = {}
			binderEdit.tempHotkey = {}
		end
		imgui.PopStyleColor(3)
		if binder.keyCapture.active then
			imgui.SameLine()
			imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), 'Отпустите все клавиши для сохранения')
		end
		imgui.SameLine()
		if #binderEdit.hotkey > 0 then
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.2, 0.2, 1))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.3, 0.3, 1))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.1, 0.1, 1))
			if imgui.Button('X##clearhotkey', imgui.ImVec2(25, 25)) then
				binderEdit.hotkey = {}
			end
			imgui.PopStyleColor(3)
			if imgui.IsItemHovered() then
				imgui.SetTooltip('Удалить клавишу')
			end
			imgui.SameLine()
		end
		imgui.Text('Команда:')
		imgui.SameLine()
		imgui.PushItemWidth(150)
		imgui.PushStyleColor(imgui.Col.FrameBg, inputBg)
		imgui.PushStyleColor(imgui.Col.FrameBgHovered, inputBgHover)
		imgui.PushStyleColor(imgui.Col.FrameBgActive, inputBgActive)
		if imgui.InputTextWithHint('##command', 'без /', binderEdit.command, 64) then
			if #binderEdit.hotkey > 0 then
				binderEdit.hotkey = {}
			end
		end
		imgui.PopStyleColor(3)
		imgui.PopItemWidth()
		imgui.Spacing()
		imgui.Separator()
		imgui.Spacing()
		imgui.Text('Задержка (мс):')
		imgui.SameLine()
		imgui.PushItemWidth(100)
		imgui.PushStyleColor(imgui.Col.FrameBg, inputBg)
		imgui.PushStyleColor(imgui.Col.FrameBgHovered, inputBgHover)
		imgui.PushStyleColor(imgui.Col.FrameBgActive, inputBgActive)
		if imgui.InputInt('##delay', binderEdit.delay, 0, 0) then
			if binderEdit.delay[0] < 0 then binderEdit.delay[0] = 0 end
			if binderEdit.delay[0] > 100000 then binderEdit.delay[0] = 100000 end
		end
		imgui.PopStyleColor(3)
		imgui.PopItemWidth()
		imgui.SameLine()
		setupCheckboxStyle()
		if imgui.Checkbox('Блокировать клавишу', binderEdit.blockKey) then end
		if imgui.IsItemHovered() then
			imgui.SetTooltip('Если включено - при нажатии эта клавиша\nне будет работать в игре и других скриптах.')
		end
		cleanupCheckboxStyle()
		imgui.SameLine()
		setupCheckboxStyle()
		if imgui.Checkbox('Подтверждение активации', binderEdit.requireConfirm) then end
		if imgui.IsItemHovered() then
			imgui.SetTooltip('Если включено - для срабатывания биндера\nнужно нажать клавишу дважды подряд.')
		end
		cleanupCheckboxStyle()
		imgui.Spacing()
		if binderEdit.mode[0] == 1 then
			renderBinderLinesMode(inputBg, inputBgHover, inputBgActive, item)
		else
			renderBinderSquareMode(inputBg, inputBgHover, inputBgActive)
		end
		imgui.SetCursorPosY(imgui.GetWindowHeight() - 45)
		imgui.Separator()
		local btnWidth = (imgui.GetWindowWidth() - 30) / 2
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(fa('xmark') .. ' Отменить', imgui.ImVec2(btnWidth, 30)) then
			binder.editWindow[0] = false
			binder.editing = nil
		end
		if fa_font then imgui.PopFont() end
		imgui.PopStyleColor(3)
		imgui.SameLine()
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.7, 0.3, 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.8, 0.4, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.15, 0.6, 0.25, 1))
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(fa('floppy_disk') .. ' Сохранить', imgui.ImVec2(btnWidth, 30)) then
			saveBinderEdit()
		end
		if fa_font then imgui.PopFont() end
		imgui.PopStyleColor(3)
		imgui.End()
	end
	imgui.PopStyleColor(3)
	if binder.conditionsWindow[0] then
		renderConditionsPopup(item, inputBg, inputBgHover, inputBgActive)
	end
end
function renderConditionsPopup(item, inputBg, inputBgHover, inputBgActive)
	local sizeX, sizeY = getScreenResolution()
	imgui.SetNextWindowPos(imgui.ImVec2(sizeX/2 + 400, sizeY/2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
	imgui.SetNextWindowSize(imgui.ImVec2(300, 150), imgui.Cond.Always)
	local bg = settings.colors.background
	imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(bg[0], bg[1], bg[2], 0.98))
	imgui.PushStyleColor(imgui.Col.TitleBg, imgui.ImVec4(item[0], item[1], item[2], 1))
	imgui.PushStyleColor(imgui.Col.TitleBgActive, imgui.ImVec4(item[0]*1.1, item[1]*1.1, item[2]*1.1, 1))
	if imgui.Begin('Условия активации##conditions', binder.conditionsWindow, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse) then
		imgui.Text('Условия запуска:')
		imgui.Separator()
		imgui.Spacing()
		setupCheckboxStyle()
		if imgui.Checkbox('Запускать при активном чате', binderEdit.enableOnChat) then end
		imgui.Spacing()
		if imgui.Checkbox('Запускать при активном диалоге', binderEdit.enableOnDialog) then end
		cleanupCheckboxStyle()
		imgui.End()
	end
	imgui.PopStyleColor(3)
end
function renderBinderLinesMode(inputBg, inputBgHover, inputBgActive, item)
	local contentHeight = imgui.GetWindowHeight() - 280
	imgui.BeginChild('##BinderLines', imgui.ImVec2(0, contentHeight), true)
	if not binderEdit.lines or #binderEdit.lines == 0 then
		binderEdit.lines = {{text = imgui.new.char[512](), delay = imgui.new.int(binderEdit.delay[0])}}
	end
	local toDelete = nil
	local lineHeight = 30
	local lineSpacing = 5
	local mousePos = imgui.GetMousePos()
	local childPos = imgui.GetWindowPos()
	local scrollY = imgui.GetScrollY()
	local n = #binderEdit.lines
	local targetInsertIndex = nil
	if flags.draggingLineIndex and flags.draggingLineIndex > 0 and flags.draggingLineIndex <= n then
		local relativeMouseY = mousePos.y - childPos.y + scrollY
		targetInsertIndex = 1
		local accumulatedHeight = 0
		for i = 1, n do
			local currentLineCenter = accumulatedHeight + (lineHeight / 2)
			if relativeMouseY > currentLineCenter then
				targetInsertIndex = i + 1
			end
			accumulatedHeight = accumulatedHeight + lineHeight + lineSpacing
		end
		targetInsertIndex = math.max(1, math.min(targetInsertIndex, n + 1))
	end
	for i = 1, n do
		local line = binderEdit.lines[i]
		if not line then
			binderEdit.lines[i] = { text = imgui.new.char[512](), delay = imgui.new.int(binderEdit.delay[0]) }
			line = binderEdit.lines[i]
		end
		local skipLine = (flags.draggingLineIndex == i)
		if flags.draggingLineIndex and targetInsertIndex == i and targetInsertIndex ~= flags.draggingLineIndex then
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.3, 0.8, 0.3, 0.3))
			imgui.Button('← Вставить сюда →##dropzone' .. i, imgui.ImVec2(-1, 20))
			imgui.PopStyleColor()
			imgui.Spacing()
		end
		if not skipLine then
			imgui.PushIDInt(i)
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
			local dragText = '↕'
			if fa_font then
				imgui.PushFont(fa_font)
				dragText = fa.ICON_FA_ARROWS_ALT_V or '↕'
			end
			if imgui.Button(dragText .. '##drag' .. i, imgui.ImVec2(25, 20)) then
			end
			if fa_font then imgui.PopFont() end
			if imgui.IsItemActive() and imgui.IsMouseDragging(0) then
				if not flags.draggingLineIndex then
					flags.draggingLineIndex = i
					local lineY = childPos.y - scrollY
					local accHeight = 0
					for j = 1, i - 1 do
						accHeight = accHeight + lineHeight + lineSpacing
					end
					lineY = lineY + accHeight
					dragOffsetY = mousePos.y - lineY
					dragOffsetY = math.max(0, math.min(dragOffsetY, lineHeight))
				end
			end
			imgui.PopStyleColor(3)
			imgui.SameLine()
			imgui.PushItemWidth(-145)
			imgui.PushStyleColor(imgui.Col.FrameBg, inputBg)
			imgui.PushStyleColor(imgui.Col.FrameBgHovered, inputBgHover)
			imgui.PushStyleColor(imgui.Col.FrameBgActive, inputBgActive)
			if flags.focusLineIndex == i then
				imgui.SetKeyboardFocusHere()
				flags.focusLineIndex = nil
			end
			local enterPressed = imgui.InputText('##text' .. i, line.text, ffi.sizeof(line.text), imgui.InputTextFlags.EnterReturnsTrue)
			imgui.PopStyleColor(3)
			imgui.PopItemWidth()
			if enterPressed then
				table.insert(binderEdit.lines, i + 1, { text = imgui.new.char[512](), delay = imgui.new.int(binderEdit.delay[0]) })
				flags.focusLineIndex = i + 1
				flags.needScrollToBottom = true
			end
			imgui.SameLine()
			imgui.PushItemWidth(80)
			imgui.PushStyleColor(imgui.Col.FrameBg, inputBg)
			imgui.PushStyleColor(imgui.Col.FrameBgHovered, inputBgHover)
			imgui.PushStyleColor(imgui.Col.FrameBgActive, inputBgActive)
			if not line.delay then
				line.delay = imgui.new.int(binderEdit.delay[0])
			end
			if imgui.InputInt('##delay' .. i, line.delay, 0, 0) then
				if line.delay[0] < 100 then line.delay[0] = 100 end
				if line.delay[0] > 10000 then line.delay[0] = 10000 end
			end
			imgui.PopStyleColor(3)
			imgui.PopItemWidth()
			imgui.SameLine()
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.2, 0.2, 1))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.3, 0.3, 1))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.1, 0.1, 1))
			if imgui.Button('X##del' .. i, imgui.ImVec2(25, 20)) then
				if n > 1 then toDelete = i end
			end
			imgui.PopStyleColor(3)
			imgui.PopID()
		else
			imgui.Dummy(imgui.ImVec2(0, lineHeight))
		end
		imgui.Spacing()
	end
	if flags.draggingLineIndex and targetInsertIndex == n + 1 then
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.3, 0.8, 0.3, 0.3))
		imgui.Button('← Вставить в конец →##dropzoneend', imgui.ImVec2(-1, 20))
		imgui.PopStyleColor()
	end
	if flags.draggingLineIndex then
		local windowHeight = imgui.GetWindowHeight()
		local relativeMouseY = mousePos.y - childPos.y
		local scrollZone = 40
		local scrollSpeed = 5
		local scrollMultiplier = 1
		if relativeMouseY < scrollZone and imgui.GetScrollY() > 0 then
			scrollMultiplier = 1 - (relativeMouseY / scrollZone)
			local currentScroll = imgui.GetScrollY()
			local newScroll = math.max(0, currentScroll - (scrollSpeed * (1 + scrollMultiplier * 2)))
			imgui.SetScrollY(newScroll)
		end
		if relativeMouseY > windowHeight - scrollZone and imgui.GetScrollY() < imgui.GetScrollMaxY() then
			scrollMultiplier = (relativeMouseY - (windowHeight - scrollZone)) / scrollZone
			local currentScroll = imgui.GetScrollY()
			local maxScroll = imgui.GetScrollMaxY()
			local newScroll = math.min(maxScroll, currentScroll + (scrollSpeed * (1 + scrollMultiplier * 2)))
			imgui.SetScrollY(newScroll)
		end
	end
	if flags.draggingLineIndex and binderEdit.lines[flags.draggingLineIndex] then
		local drawList = imgui.GetWindowDrawList()
		local line = binderEdit.lines[flags.draggingLineIndex]
		local dragPosX = childPos.x + 10
		local dragPosY = mousePos.y - (dragOffsetY or (lineHeight / 2))
		local getColorU32 = imgui.GetColorU32Vec4 or imgui.ColorConvertFloat4ToU32
		if getColorU32 then
			drawList:AddRectFilled(
				imgui.ImVec2(dragPosX, dragPosY),
				imgui.ImVec2(dragPosX + imgui.GetWindowWidth() - 30, dragPosY + lineHeight),
				getColorU32(imgui.ImVec4(inputBg.x, inputBg.y, inputBg.z, 0.97)),
				5
			)
			local text = ""
			if line and line.text then
				local success, result = pcall(ffi.string, line.text)
				if success then
					text = result
				end
			end
			if text == "" then text = "[Пустая строка]" end
			if #text > 50 then text = text:sub(1, 47) .. "..." end
			drawList:AddText(
				imgui.ImVec2(dragPosX + 30, dragPosY + 5),
				getColorU32(imgui.ImVec4(1, 1, 1, 1)),
				text
			)
		end
	end
	if flags.draggingLineIndex and not imgui.IsMouseDown(0) then
		if targetInsertIndex and targetInsertIndex ~= flags.draggingLineIndex and
			flags.draggingLineIndex > 0 and flags.draggingLineIndex <= n then
			local movingLine = table.remove(binderEdit.lines, flags.draggingLineIndex)
			if movingLine then
				local insertPos = targetInsertIndex
				if insertPos > flags.draggingLineIndex then
					insertPos = insertPos - 1
				end
				insertPos = math.max(1, math.min(insertPos, #binderEdit.lines + 1))
				table.insert(binderEdit.lines, insertPos, movingLine)
			end
		end
		flags.draggingLineIndex = nil
		dragOffsetY = nil
	end
	if not flags.draggingLineIndex then
		imgui.Dummy(imgui.ImVec2(25, 20))
		imgui.SameLine()
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(inputBg.x, inputBg.y, inputBg.z, 0.5))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(inputBgHover.x, inputBgHover.y, inputBgHover.z, 0.7))
		imgui.PushStyleColor(imgui.Col.ButtonActive, inputBgActive)
		imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1, 1, 1, 0.5))
		local buttonWidth = imgui.GetContentRegionAvail().x - 30
		local buttonText = 'Нажмите Enter ' .. (fa_font and fa('arrow_turn_down_left') or '↵') .. ' или кликните мышью чтобы добавить строку.##addnewline'
		if imgui.Button(buttonText, imgui.ImVec2(buttonWidth, 20)) then
			table.insert(binderEdit.lines, { text = imgui.new.char[512](), delay = imgui.new.int(binderEdit.delay[0]) })
			flags.focusLineIndex = #binderEdit.lines
			flags.needScrollToBottom = true
		end
		imgui.PopStyleColor(4)
		imgui.SameLine()
		imgui.Dummy(imgui.ImVec2(25, 20))
	end
	if toDelete and toDelete > 0 and toDelete <= #binderEdit.lines then
		table.remove(binderEdit.lines, toDelete)
	end
	if flags.needScrollToBottom then
		imgui.SetScrollHereY(1.0)
		flags.needScrollToBottom = false
	end
	imgui.EndChild()
end
function renderBinderSquareMode(inputBg, inputBgHover, inputBgActive)
	local contentHeight = imgui.GetWindowHeight() - 280
	imgui.BeginChild('##BinderSquare', imgui.ImVec2(0, contentHeight), true)
	imgui.PushStyleColor(imgui.Col.FrameBg, inputBg)
	imgui.PushStyleColor(imgui.Col.FrameBgHovered, inputBgHover)
	imgui.PushStyleColor(imgui.Col.FrameBgActive, inputBgActive)
	imgui.InputTextMultiline('##squaretext', binderEdit.squareText, 8192, imgui.ImVec2(-1, -1))
	imgui.PopStyleColor(3)
	imgui.EndChild()
end
function checkBinderHotkeys()
	for i, bind in ipairs(binder.list) do
		if bind.hotkey and #bind.hotkey > 0 then
			local allPressed = true
			for _, key in ipairs(bind.hotkey) do
				if not isKeyPressed(key) then
					allPressed = false
					break
				end
			end
			if allPressed then
				if isAnyOtherKeyPressed(bind.hotkey) then
					if not bind.otherKeyWarningShown then
						bind.otherKeyWarningShown = true
					end
					goto continue
				end
				bind.otherKeyWarningShown = false
				if not bind.hotkeyPressed then
					bind.hotkeyPressed = true
					local shouldExecute = true
					if not bind.enableOnChat and sampIsChatInputActive() then
						shouldExecute = false
					end
					if not bind.enableOnDialog and sampIsDialogActive() then
						shouldExecute = false
					end
					if shouldExecute then
						if bind.blockKey then
							for _, key in ipairs(bind.hotkey) do
								consumeWindowMessage(true, true)
							end
						end
						executeBinder(bind)
					end
				end
			else
				bind.hotkeyPressed = false
				bind.otherKeyWarningShown = false
			end
			::continue::
		end
	end
end
function executeRSAction(actionKey,targetId)
	local action=rsSettings.actions[actionKey]
	if not action then return end
	if action.needInput then
		playerInteraction.inputType=actionKey
		playerInteraction.targetId=targetId
		playerInteraction.inputTitle=action.inputPlaceholder or "Введите данные"
		ffi.fill(playerInteraction.inputText,256)
		windows.rsInput[0]=true
		windows.playerMenu[0]=false
	else
		lua_thread.create(function()
			for _,line in ipairs(action.lines) do
				sampSendChat(u8:decode(line))
				wait(action.delay)
			end
			if actionKey=="invite" then
				sampSendChat(string.format("/invite %d",targetId))
			elseif actionKey=="givedress" then
				sampSendChat(string.format("/givedress %d",targetId))
			elseif actionKey=="unvig" then
				sampSendChat(string.format("/unvig %d",targetId))
			end
		end)
		windows.playerMenu[0]=false
	end
end
function executeRSActionWithInput(actionKey,targetId,inputText)
	local action=rsSettings.actions[actionKey]
	if not action then return end
	lua_thread.create(function()
		for _,line in ipairs(action.lines) do
			sampSendChat(u8:decode(line))
			wait(action.delay)
		end
		if actionKey=="uninvite" then
			sampSendChat(string.format("/uninvite %d %s",targetId,inputText))
		elseif actionKey=="rank" then
			sampSendChat(string.format("/rank %d %s",targetId,inputText))
		elseif actionKey=="vig" then
			sampSendChat(string.format("/vig %d %s",targetId,inputText))
		end
	end)
end
function openRSEditor(actionKey)
	rsSettings.currentAction=actionKey
	local action=rsSettings.actions[actionKey]
	if not action then return end
	rsEditor.lines={}
	for _,line in ipairs(action.lines) do
		table.insert(rsEditor.lines,{
			text=imgui.new.char[512](line)
		})
	end
	ffi.fill(rsEditor.newLineText,512)
	windows.rsEditor[0]=true
	windows.rsWindow[0]=false
end
function saveRSEditorChanges()
	if not rsSettings.currentAction then return end
	local action=rsSettings.actions[rsSettings.currentAction]
	if not action then return end
	action.lines={}
	for _,line in ipairs(rsEditor.lines) do
		local text=ffi.string(line.text)
		if text~="" then
			table.insert(action.lines,text)
		end
	end
	saveRSSettings()
	chatMessage(u8:decode('[News Helper] Отыгровки сохранены!'),0x00FF00)
	windows.rsEditor[0]=false
	windows.rsWindow[0]=true
end
imgui.OnFrame(function() return windows.rsWindow[0] end,function()
	local sizeX,sizeY=getScreenResolution()
	imgui.SetNextWindowPos(imgui.ImVec2(sizeX/2,sizeY/2),imgui.Cond.FirstUseEver,imgui.ImVec2(0.5,0.5))
	imgui.SetNextWindowSize(imgui.ImVec2(700,500),imgui.Cond.FirstUseEver)
	local bg=settings.colors.background
	local item=settings.colors.itemButtons
	imgui.PushStyleColor(imgui.Col.WindowBg,imgui.ImVec4(bg[0],bg[1],bg[2],0.98))
	imgui.PushStyleColor(imgui.Col.TitleBg,imgui.ImVec4(item[0],item[1],item[2],1))
	imgui.PushStyleColor(imgui.Col.TitleBgActive,imgui.ImVec4(item[0]*1.1,item[1]*1.1,item[2]*1.1,1))
	if imgui.Begin('Панель заместителя##rsWindow',windows.rsWindow,imgui.WindowFlags.NoCollapse) then
		imgui.Text('Настройки отыгровок для команд')
		imgui.Separator()
		imgui.Spacing()
		imgui.Text('Клавиша взаимодействия:')
		imgui.SameLine()
		local keyName=getKeyName(rsSettings.interactionKey)
		imgui.PushStyleColor(imgui.Col.Button,imgui.ImVec4(item[0],item[1],item[2],1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered,imgui.ImVec4(item[0]*1.2,item[1]*1.2,item[2]*1.2,1))
		imgui.PushStyleColor(imgui.Col.ButtonActive,imgui.ImVec4(item[0]*1.4,item[1]*1.4,item[2]*1.4,1))
		if rsSettings.isSettingKey then
			imgui.Button('Нажмите клавишу...##rskey',imgui.ImVec2(150,25))
		else
			if imgui.Button(keyName..'##rskey',imgui.ImVec2(150,25)) then
				rsSettings.isSettingKey=true
			end
		end
		imgui.PopStyleColor(3)
		if imgui.IsItemHovered() then
			imgui.SetTooltip('ПКМ + эта клавиша при наведении на игрока')
		end
		imgui.Spacing()
		imgui.Separator()
		imgui.Spacing()
		imgui.TextColored(imgui.ImVec4(1,1,0,1),'Примечание: команды НЕ нужно добавлять в отыгровки!')
		imgui.TextWrapped('Команда выполнится автоматически после всех /me')
		imgui.Spacing()
		imgui.Separator()
		imgui.Spacing()
		imgui.BeginChild('##rsActions',imgui.ImVec2(0,0),true)
		for actionKey,action in pairs(rsSettings.actions) do
			imgui.PushStyleColor(imgui.Col.Button,imgui.ImVec4(item[0],item[1],item[2],1))
			imgui.PushStyleColor(imgui.Col.ButtonHovered,imgui.ImVec4(item[0]*1.2,item[1]*1.2,item[2]*1.2,1))
			imgui.PushStyleColor(imgui.Col.ButtonActive,imgui.ImVec4(item[0]*1.4,item[1]*1.4,item[2]*1.4,1))
			if imgui.Button(action.name..'##'..actionKey,imgui.ImVec2(-1,30)) then
				openRSEditor(actionKey)
			end
			imgui.PopStyleColor(3)
			imgui.Spacing()
		end
		imgui.EndChild()
		imgui.End()
	end
	imgui.PopStyleColor(3)
end).Priority=settings.renderPriority+40
imgui.OnFrame(function() return windows.rsEditor[0] end,function()
	local sizeX,sizeY=getScreenResolution()
	imgui.SetNextWindowPos(imgui.ImVec2(sizeX/2,sizeY/2),imgui.Cond.Always,imgui.ImVec2(0.5,0.5))
	imgui.SetNextWindowSize(imgui.ImVec2(600,400),imgui.Cond.Always)
	local bg=settings.colors.background
	local item=settings.colors.itemButtons
	imgui.PushStyleColor(imgui.Col.WindowBg,imgui.ImVec4(bg[0],bg[1],bg[2],0.98))
	imgui.PushStyleColor(imgui.Col.TitleBg,imgui.ImVec4(item[0],item[1],item[2],1))
	imgui.PushStyleColor(imgui.Col.TitleBgActive,imgui.ImVec4(item[0]*1.1,item[1]*1.1,item[2]*1.1,1))
	if imgui.Begin('Редактор отыгровок##rsEditor',windows.rsEditor,imgui.WindowFlags.NoResize+imgui.WindowFlags.NoCollapse) then
		if rsSettings.currentAction then
			local action=rsSettings.actions[rsSettings.currentAction]
			if action then
				imgui.Text('Редактирование: '..action.name)
				imgui.Separator()
				imgui.Spacing()
				imgui.BeginChild('##rsEditorLines',imgui.ImVec2(0,-50),true)
				local toDelete=nil
				for i,line in ipairs(rsEditor.lines) do
					imgui.PushIDInt(i)
					imgui.PushItemWidth(-40)
					local inputBg=imgui.ImVec4(bg[0]*0.5,bg[1]*0.5,bg[2]*0.5,1)
					imgui.PushStyleColor(imgui.Col.FrameBg,inputBg)
					imgui.PushStyleColor(imgui.Col.FrameBgHovered,imgui.ImVec4(bg[0]*0.7,bg[1]*0.7,bg[2]*0.7,1))
					imgui.PushStyleColor(imgui.Col.FrameBgActive,imgui.ImVec4(bg[0]*0.9,bg[1]*0.9,bg[2]*0.9,1))
					if rsEditor.focusInput==i then
						imgui.SetKeyboardFocusHere()
						rsEditor.focusInput=false
					end
					local enterPressed=imgui.InputText('##line'..i,line.text,512,imgui.InputTextFlags.EnterReturnsTrue)
					imgui.PopStyleColor(3)
					imgui.PopItemWidth()
					if enterPressed then
						table.insert(rsEditor.lines,i+1,{text=imgui.new.char[512]()})
						rsEditor.focusInput=i+1
						rsEditor.scrollToBottom=true
					end
					imgui.SameLine()
					imgui.PushStyleColor(imgui.Col.Button,imgui.ImVec4(0.8,0.2,0.2,1))
					imgui.PushStyleColor(imgui.Col.ButtonHovered,imgui.ImVec4(0.9,0.3,0.3,1))
					imgui.PushStyleColor(imgui.Col.ButtonActive,imgui.ImVec4(0.7,0.1,0.1,1))
					if imgui.Button('X##del'..i,imgui.ImVec2(25,20)) then
						if #rsEditor.lines>1 then toDelete=i end
					end
					imgui.PopStyleColor(3)
					imgui.PopID()
					imgui.Spacing()
				end
				if toDelete then
					table.remove(rsEditor.lines,toDelete)
				end
				imgui.Dummy(imgui.ImVec2(25,20))
				imgui.SameLine()
				imgui.PushStyleColor(imgui.Col.Button,imgui.ImVec4(bg[0]*0.5,bg[1]*0.5,bg[2]*0.5,0.5))
				imgui.PushStyleColor(imgui.Col.ButtonHovered,imgui.ImVec4(bg[0]*0.7,bg[1]*0.7,bg[2]*0.7,0.7))
				imgui.PushStyleColor(imgui.Col.ButtonActive,imgui.ImVec4(bg[0]*0.9,bg[1]*0.9,bg[2]*0.9,1))
				if imgui.Button('Добавить строку##addrsline',imgui.ImVec2(-30,20)) then
					table.insert(rsEditor.lines,{text=imgui.new.char[512]()})
					rsEditor.focusInput=#rsEditor.lines
					rsEditor.scrollToBottom=true
				end
				imgui.PopStyleColor(3)
				if rsEditor.scrollToBottom then
					imgui.SetScrollHereY(1.0)
					rsEditor.scrollToBottom=false
				end
				imgui.EndChild()
				imgui.Separator()
				local btnWidth=(imgui.GetWindowWidth()-30)/2
				imgui.PushStyleColor(imgui.Col.Button,imgui.ImVec4(item[0],item[1],item[2],1))
				imgui.PushStyleColor(imgui.Col.ButtonHovered,imgui.ImVec4(item[0]*1.2,item[1]*1.2,item[2]*1.2,1))
				imgui.PushStyleColor(imgui.Col.ButtonActive,imgui.ImVec4(item[0]*1.4,item[1]*1.4,item[2]*1.4,1))
				if imgui.Button('Отмена',imgui.ImVec2(btnWidth,30)) then
					windows.rsEditor[0]=false
					windows.rsWindow[0]=true
				end
				imgui.PopStyleColor(3)
				imgui.SameLine()
				imgui.PushStyleColor(imgui.Col.Button,imgui.ImVec4(0.2,0.7,0.3,1))
				imgui.PushStyleColor(imgui.Col.ButtonHovered,imgui.ImVec4(0.3,0.8,0.4,1))
				imgui.PushStyleColor(imgui.Col.ButtonActive,imgui.ImVec4(0.15,0.6,0.25,1))
				if imgui.Button('Сохранить',imgui.ImVec2(btnWidth,30)) then
					saveRSEditorChanges()
				end
				imgui.PopStyleColor(3)
			end
		end
		imgui.End()
	end
	imgui.PopStyleColor(3)
end).Priority=settings.renderPriority+45
imgui.OnFrame(function() return windows.rsInput[0] end,function()
	local sizeX,sizeY=getScreenResolution()
	imgui.SetNextWindowPos(imgui.ImVec2(sizeX/2,sizeY/2),imgui.Cond.Always,imgui.ImVec2(0.5,0.5))
	imgui.SetNextWindowSize(imgui.ImVec2(400,150),imgui.Cond.Always)
	local bg=settings.colors.background
	local item=settings.colors.itemButtons
	imgui.PushStyleColor(imgui.Col.WindowBg,imgui.ImVec4(bg[0],bg[1],bg[2],0.98))
	imgui.PushStyleColor(imgui.Col.TitleBg,imgui.ImVec4(item[0],item[1],item[2],1))
	imgui.PushStyleColor(imgui.Col.TitleBgActive,imgui.ImVec4(item[0]*1.1,item[1]*1.1,item[2]*1.1,1))
	if imgui.Begin('Ввод данных##rsInput',windows.rsInput,imgui.WindowFlags.NoResize+imgui.WindowFlags.NoCollapse) then
		imgui.Text(playerInteraction.inputTitle)
		imgui.Separator()
		imgui.Spacing()
		imgui.PushItemWidth(-1)
		imgui.PushStyleColor(imgui.Col.FrameBg,imgui.ImVec4(bg[0]*0.5,bg[1]*0.5,bg[2]*0.5,1))
		imgui.PushStyleColor(imgui.Col.FrameBgHovered,imgui.ImVec4(bg[0]*0.7,bg[1]*0.7,bg[2]*0.7,1))
		imgui.PushStyleColor(imgui.Col.FrameBgActive,imgui.ImVec4(bg[0]*0.9,bg[1]*0.9,bg[2]*0.9,1))
		local enterPressed=imgui.InputText('##rsinput',playerInteraction.inputText,256,imgui.InputTextFlags.EnterReturnsTrue)
		imgui.PopStyleColor(3)
		imgui.PopItemWidth()
		imgui.Spacing()
		imgui.Separator()
		local btnWidth=(imgui.GetWindowWidth()-30)/2
		imgui.PushStyleColor(imgui.Col.Button,imgui.ImVec4(item[0],item[1],item[2],1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered,imgui.ImVec4(item[0]*1.2,item[1]*1.2,item[2]*1.2,1))
		imgui.PushStyleColor(imgui.Col.ButtonActive,imgui.ImVec4(item[0]*1.4,item[1]*1.4,item[2]*1.4,1))
		if imgui.Button('Отмена (ESC)',imgui.ImVec2(btnWidth,30)) or imgui.IsKeyPressed(imgui.Key.Escape) then
			windows.rsInput[0]=false
			ffi.fill(playerInteraction.inputText,256)
		end
		imgui.PopStyleColor(3)
		imgui.SameLine()
		imgui.PushStyleColor(imgui.Col.Button,imgui.ImVec4(0.2,0.7,0.3,1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered,imgui.ImVec4(0.3,0.8,0.4,1))
		imgui.PushStyleColor(imgui.Col.ButtonActive,imgui.ImVec4(0.15,0.6,0.25,1))
		if imgui.Button('Готово (Enter)',imgui.ImVec2(btnWidth,30)) or enterPressed then
			local inputText=ffi.string(playerInteraction.inputText)
			if inputText~="" then
				executeRSActionWithInput(playerInteraction.inputType,playerInteraction.targetId,inputText)
				windows.rsInput[0]=false
				ffi.fill(playerInteraction.inputText,256)
			end
		end
		imgui.PopStyleColor(3)
		imgui.End()
	end
	imgui.PopStyleColor(3)
end).Priority=settings.renderPriority+50
imgui.OnFrame(function() return windows.playerMenu[0] end,function()
	local sizeX,sizeY=getScreenResolution()
	imgui.SetNextWindowPos(imgui.ImVec2(sizeX/2,sizeY/2),imgui.Cond.Always,imgui.ImVec2(0.5,0.5))
	imgui.SetNextWindowSize(imgui.ImVec2(300,425),imgui.Cond.Always)
	local bg=settings.colors.background
	local item=settings.colors.itemButtons
	imgui.PushStyleColor(imgui.Col.WindowBg,imgui.ImVec4(bg[0],bg[1],bg[2],0.98))
	imgui.PushStyleColor(imgui.Col.TitleBg,imgui.ImVec4(item[0],item[1],item[2],1))
	imgui.PushStyleColor(imgui.Col.TitleBgActive,imgui.ImVec4(item[0]*1.1,item[1]*1.1,item[2]*1.1,1))
	if imgui.Begin('Действия с игроком##playerMenu',windows.playerMenu,imgui.WindowFlags.NoResize+imgui.WindowFlags.NoCollapse) then
		imgui.Text('ID игрока: '..tostring(playerInteraction.targetId))
		imgui.Text('Имя: '..playerInteraction.targetName)
		imgui.Separator()
		imgui.Spacing()
		imgui.BeginChild('##actions',imgui.ImVec2(0,-50),true)
		for actionKey,action in pairs(rsSettings.actions) do
			imgui.PushStyleColor(imgui.Col.Button,imgui.ImVec4(item[0],item[1],item[2],1))
			imgui.PushStyleColor(imgui.Col.ButtonHovered,imgui.ImVec4(item[0]*1.2,item[1]*1.2,item[2]*1.2,1))
			imgui.PushStyleColor(imgui.Col.ButtonActive,imgui.ImVec4(item[0]*1.4,item[1]*1.4,item[2]*1.4,1))
			if imgui.Button(action.name..'##action'..actionKey,imgui.ImVec2(-1,30)) then
				executeRSAction(actionKey,playerInteraction.targetId)
			end
			imgui.PopStyleColor(3)
			imgui.Spacing()
		end
		imgui.EndChild()
		imgui.Separator()
		imgui.PushStyleColor(imgui.Col.Button,imgui.ImVec4(item[0],item[1],item[2],1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered,imgui.ImVec4(item[0]*1.2,item[1]*1.2,item[2]*1.2,1))
		imgui.PushStyleColor(imgui.Col.ButtonActive,imgui.ImVec4(item[0]*1.4,item[1]*1.4,item[2]*1.4,1))
		if imgui.Button('Закрыть',imgui.ImVec2(-1,30)) then
			windows.playerMenu[0]=false
		end
		imgui.PopStyleColor(3)
		imgui.End()
	end
	imgui.PopStyleColor(3)
end).Priority=settings.renderPriority+55
imgui.OnFrame(function() return windows.contextMenu[0] end, function()
	imgui.SetNextWindowPos(imgui.ImVec2(ui.contextMenu.pos.x, ui.contextMenu.pos.y), imgui.Cond.Always)
	imgui.SetNextWindowSize(imgui.ImVec2(200, 100), imgui.Cond.Always)
	imgui.Begin('КОНТЕКСТНОЕ МЕНЮ', rContextMenu)
	imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), 'НАЖМИТЕ КЛАВИШУ:')
	imgui.Separator()
	imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), '[E] - Редактировать')
	imgui.TextColored(imgui.ImVec4(1, 0, 0, 1), '[X] - Удалить')
	imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), '[ESC] - Закрыть')
	imgui.End()
end)
imgui.OnFrame(function() return windows.editCategory[0] end, function()
	local sizeX, sizeY = getScreenResolution()
	imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
	imgui.SetNextWindowSize(imgui.ImVec2(350, 150), imgui.Cond.Always)
	imgui.SetNextWindowFocus()
	local windowFlags = imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove +
						imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar +
						imgui.WindowFlags.NoTitleBar + settings.topMostFlags
	imgui.Begin('##EditCategory', nil, windowFlags)
	bringWindowToFront()
	local titleSize = imgui.CalcTextSize('Редактирование категории')
	imgui.SetCursorPosX((imgui.GetWindowWidth() - titleSize.x) / 2)
	imgui.Text('Редактирование категории')
	imgui.Separator(); imgui.Spacing()
	imgui.Text('Название категории:')
	local bg = imgui.GetStyle().Colors[imgui.Col.WindowBg]
	imgui.PushStyleColor(imgui.Col.FrameBg,		imgui.ImVec4(bg.x * 0.5, bg.y * 0.5, bg.z * 0.5, 1))
	imgui.PushStyleColor(imgui.Col.FrameBgHovered, imgui.ImVec4(bg.x * 0.7, bg.y * 0.7, bg.z * 0.7, 1))
	imgui.PushStyleColor(imgui.Col.FrameBgActive,  imgui.ImVec4(bg.x * 0.9, bg.y * 0.9, bg.z * 0.9, 1))
	imgui.PushItemWidth(imgui.GetWindowWidth() - 20)
	imgui.InputText('##CategoryName', editor.edit.categoryName, sizeof(editor.edit.categoryName))
	imgui.PopItemWidth(); imgui.Spacing()
	imgui.PopStyleColor(3) 
	local buttonWidth = (imgui.GetWindowWidth() - 30) / 2
	local item = settings.colors.itemButtons
	imgui.PushStyleColor(imgui.Col.Button,		imgui.ImVec4(item[0], item[1], item[2], 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0] * 1.2, item[1] * 1.2, item[2] * 1.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive,  imgui.ImVec4(item[0] * 1.4, item[1] * 1.4, item[2] * 1.4, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('xmark') .. ' Выйти', imgui.ImVec2(buttonWidth, 30)) then
		if fa_font then imgui.PopFont() end
		windows.editCategory[0] = false
	end
	imgui.PopStyleColor(3); imgui.SameLine()
	imgui.PushStyleColor(imgui.Col.Button,		imgui.ImVec4(item[0], item[1], item[2], 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0] * 1.2, item[1] * 1.2, item[2] * 1.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive,  imgui.ImVec4(item[0] * 1.4, item[1] * 1.4, item[2] * 1.4, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('floppy_disk') .. ' Сохранить', imgui.ImVec2(buttonWidth, 30)) then
		if fa_font then imgui.PopFont() end
		local newName = str(editor.edit.categoryName)
		if newName ~= '' then
			addToHistory()
			local convertedName = newName
			if editor.edit.categoryIndex == 0 then
				table.insert(data.newsHelpBind, {convertedName})
				chatMessage(u8:decode('[News Helper] Категория создана!'), 0x00FF00)
			else
				data.newsHelpBind[editor.edit.categoryIndex][1] = convertedName
				chatMessage(u8:decode('[News Helper] Категория изменена!'), 0x00FF00)
			end
			windows.editCategory[0] = false
		else
			chatMessage(u8:decode('[News Helper] Введите название категории!'), 0xFF0000)
		end
	end
	imgui.PopStyleColor(3)
	imgui.End()
end).Priority = settings.renderPriority + 90
imgui.OnFrame(function() return windows.editBind[0] end, function()
	local sizeX, sizeY = getScreenResolution()
	imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
	imgui.SetNextWindowSize(imgui.ImVec2(450, 250), imgui.Cond.Always)
	imgui.SetNextWindowFocus()
	local windowFlags = imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove +
						imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar +
						imgui.WindowFlags.NoTitleBar + settings.topMostFlags
	imgui.Begin('##EditBind', nil, windowFlags)
	bringWindowToFront()
	local titleSize = imgui.CalcTextSize('Редактирование бинда')
	imgui.SetCursorPosX((imgui.GetWindowWidth() - titleSize.x) / 2)
	imgui.Text('Редактирование бинда')
	imgui.Separator(); imgui.Spacing()
	local bg = imgui.GetStyle().Colors[imgui.Col.WindowBg]
	imgui.PushStyleColor(imgui.Col.FrameBg,		imgui.ImVec4(bg.x * 0.5, bg.y * 0.5, bg.z * 0.5, 1))
	imgui.PushStyleColor(imgui.Col.FrameBgHovered, imgui.ImVec4(bg.x * 0.7, bg.y * 0.7, bg.z * 0.7, 1))
	imgui.PushStyleColor(imgui.Col.FrameBgActive,  imgui.ImVec4(bg.x * 0.9, bg.y * 0.9, bg.z * 0.9, 1))
	imgui.Text('Название бинда:')
	imgui.PushItemWidth(imgui.GetWindowWidth() - 20)
	imgui.InputText('##BindName', editor.edit.bindName, sizeof(editor.edit.bindName))
	imgui.PopItemWidth(); imgui.Spacing()
	imgui.Text('Текст бинда:')
	imgui.PushItemWidth(imgui.GetWindowWidth() - 20)
	imgui.InputTextMultiline('##BindText', editor.edit.bindText, sizeof(editor.edit.bindText), imgui.ImVec2(0, 80))
	imgui.PopItemWidth(); imgui.Spacing()
	imgui.PopStyleColor(3) 
	local buttonWidth = (imgui.GetWindowWidth() - 30) / 2
	local item = settings.colors.itemButtons
	imgui.PushStyleColor(imgui.Col.Button,		imgui.ImVec4(item[0], item[1], item[2], 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0] * 1.2, item[1] * 1.2, item[2] * 1.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive,  imgui.ImVec4(item[0] * 1.4, item[1] * 1.4, item[2] * 1.4, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('xmark') .. ' Выйти', imgui.ImVec2(buttonWidth, 30)) then
		if fa_font then imgui.PopFont() end
		windows.editBind[0] = false
	end
	imgui.PopStyleColor(3); imgui.SameLine()
	imgui.PushStyleColor(imgui.Col.Button,		imgui.ImVec4(item[0], item[1], item[2], 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0] * 1.2, item[1] * 1.2, item[2] * 1.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive,  imgui.ImVec4(item[0] * 1.4, item[1] * 1.4, item[2] * 1.4, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('floppy_disk') .. ' Сохранить', imgui.ImVec2(buttonWidth, 30)) then
		if fa_font then imgui.PopFont() end
		local newName = str(editor.edit.bindName)
		local newText = str(editor.edit.bindText)
		if newName ~= '' and newText ~= '' then
			addToHistory()
			local convertedName = newName
			local convertedText = newText
			if editor.edit.bindIndex == 0 then
				table.insert(data.newsHelpBind[editor.edit.bindCategoryIndex], {convertedName, convertedText})
				chatMessage(u8:decode('[News Helper] Бинд создан!'), 0x00FF00)
			else
				data.newsHelpBind[editor.edit.bindCategoryIndex][editor.edit.bindIndex][1] = convertedName
				data.newsHelpBind[editor.edit.bindCategoryIndex][editor.edit.bindIndex][2] = convertedText
				chatMessage(u8:decode('[News Helper] Бинд изменен!'), 0x00FF00)
			end
			windows.editBind[0] = false
		else
			chatMessage(u8:decode('[News Helper] Заполните все поля!'), 0xFF0000)
		end
	end
	imgui.PopStyleColor(3)
	imgui.End()
end).Priority = settings.renderPriority + 80
imgui.OnFrame(function() return bulkInput.active end, function()
	local sizeX, sizeY = getScreenResolution()
	imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
	imgui.SetNextWindowSize(imgui.ImVec2(700, 450), imgui.Cond.Always)
	local bg = settings.colors.background
	local item = settings.colors.itemButtons
	imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(bg[0], bg[1], bg[2], 0.98))
	imgui.PushStyleColor(imgui.Col.TitleBg, imgui.ImVec4(item[0], item[1], item[2], 1))
	imgui.PushStyleColor(imgui.Col.TitleBgActive, imgui.ImVec4(item[0] * 1.1, item[1] * 1.1, item[2] * 1.1, 1))
	local windowFlags = imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse
	if imgui.Begin(bulkInput.mode == 'questions' and 'Вставить вопросы' or 'Вставить ответы', nil, windowFlags) then
		imgui.TextWrapped('Введите по одному на строку (максимум 10 строк):')
		imgui.Spacing()
		local inputBgColor = imgui.ImVec4(bg[0] * 0.5, bg[1] * 0.5, bg[2] * 0.5, 1)
		imgui.BeginChild('##BulkInputContainer', imgui.ImVec2(-1, 300), false, imgui.WindowFlags.NoScrollbar)
		local currentText = ffi.string(bulkInput.text)
		local lineArray = {}
		for line in (currentText .. "\n"):gmatch("([^\n]*)\n") do
			table.insert(lineArray, line)
		end
		if #lineArray > 10 then
			lineArray = {table.unpack(lineArray, 1, 10)}
			local limited = table.concat(lineArray, "\n")
			ffi.fill(bulkInput.text, 8192)
			ffi.copy(bulkInput.text, limited)
		end
		local lineNumbers = ""
		for i = 1, #lineArray do
			lineNumbers = lineNumbers .. tostring(i) .. "\n"
		end
		imgui.PushItemWidth(30)
		imgui.InputTextMultiline('##LineNumbers', imgui.new.char[512](lineNumbers), 512, imgui.ImVec2(30, 280), imgui.InputTextFlags.ReadOnly)
		imgui.PopItemWidth()
		imgui.SameLine(0, 5)
		imgui.PushItemWidth(-1)
		imgui.InputTextMultiline('##BulkInput', bulkInput.text, 8192, imgui.ImVec2(-1, 280))
		imgui.PopItemWidth()
		imgui.EndChild()
		imgui.Spacing()
		local finalText = ffi.string(bulkInput.text)
		local finalLineCount = 1
		for _ in finalText:gmatch("\n") do
			finalLineCount = finalLineCount + 1
		end
		finalLineCount = math.min(finalLineCount, 10)
		imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'Строк: ' .. finalLineCount .. ' / 10')
		local buttonWidth = (imgui.GetWindowWidth() - 30) / 2
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0] * 1.2, item[1] * 1.2, item[2] * 1.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0] * 1.4, item[1] * 1.4, item[2] * 1.4, 1))
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(fa('xmark') .. ' Отмена', imgui.ImVec2(buttonWidth, 30)) then
			if fa_font then imgui.PopFont() end
			bulkInput.active = false
			ffi.fill(bulkInput.text, 8192)
		end
		if fa_font then imgui.PopFont() end
		imgui.PopStyleColor(3)
		imgui.SameLine()
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.8, 0.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.9, 0.3, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.1, 0.7, 0.1, 1))
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(fa('check') .. ' Готово', imgui.ImVec2(buttonWidth, 30)) then
			if fa_font then imgui.PopFont() end
			local text = ffi.string(bulkInput.text)
			local lines = {}
			for line in text:gmatch("[^\r\n]+") do
				local trimmed = line:gsub("^%s+", ""):gsub("%s+$", "")
				if trimmed ~= "" then
					table.insert(lines, trimmed)
				end
			end
			if #lines > 0 then
				local efirType = bulkInput.efirType
				local lineCount = efirLineCount[efirType] or 10
				for i = 1, math.min(#lines, lineCount) do
					if bulkInput.mode == 'questions' then
						ffi.copy(efir.examples[efirType][i], lines[i])
						if efirType == 'math' then
							local result, error = calculateMathExpression(lines[i])
							if result then
								ffi.copy(efir.answers[efirType][i], result)
							end
						end
					elseif bulkInput.mode == 'answers' then
						ffi.copy(efir.answers[efirType][i], lines[i])
					end
				end
				saveConfig()
				chatMessage(u8:decode('[News Helper] Вставлено ' .. math.min(#lines, lineCount) .. ' строк'), 0x00FF00)
			end
			bulkInput.active = false
			ffi.fill(bulkInput.text, 8192)
		end
		if fa_font then imgui.PopFont() end
		imgui.PopStyleColor(3)
		if imgui.IsKeyPressed(imgui.Key.Escape) then
			bulkInput.active = false
			ffi.fill(bulkInput.text, 8192)
		end
		imgui.End()
	end
	imgui.PopStyleColor(3)
end).Priority = settings.renderPriority + 120
imgui.OnFrame(function() return windows.help[0] end, function()
	local sizeX, sizeY = getScreenResolution()
	if settings.windowPos.x == -1 or settings.windowPos.y == -1 then
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX - 440, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(1, 0.5))
	else
		imgui.SetNextWindowPos(imgui.ImVec2(settings.windowPos.x, settings.windowPos.y), imgui.Cond.FirstUseEver)
	end
	imgui.SetNextWindowSize(imgui.ImVec2(settings.windowSize.x, settings.windowSize.y), imgui.Cond.FirstUseEver)
	saveConfig()
	local bufferCount = 0
	for i = 1, #data.newsHelpBind do
		if data.newsHelpBind[i][1] == settings.bufferCategoryName then
			bufferCount = #data.newsHelpBind[i] - 1
			break
		end
	end
	local title = string.format("News Helper																																									Буферов: %d", bufferCount)
	imgui.Begin(title, rHelp, imgui.WindowFlags.NoCollapse + settings.topMostFlags)
	local pos, size = imgui.GetWindowPos(), imgui.GetWindowSize()
	settings.windowPos.x, settings.windowPos.y, settings.windowSize.x, settings.windowSize.y = pos.x, pos.y, size.x, size.y
	if not windows.editor[0] then
		local resetButtonWidth = 60
		local expandButtonWidth = 105
		local settingsButtonWidth = 35
		local spacing = 4
		imgui.PushItemWidth(imgui.GetWindowWidth() - resetButtonWidth - expandButtonWidth - settingsButtonWidth - spacing * 3 - 30)
		local search_changed = false
		local bg = settings.colors.background
		if imgui.InputTextWithHint('##search' .. tostring(ui.search.id), 'Поиск по биндам', ui.search.input, sizeof(ui.search.input) - 1) then
			local s = str(ui.search.input)
			local new_query = s ~= '' and s or ""
			if new_query ~= (ui.search.tmp.helpFind or "") then
				ui.search.tmp.helpFind = new_query
				search_changed = true
				ui.search.debounceTimer = os.clock()
				ui.search.resultsValid = false
			end
		end
		imgui.PopItemWidth()
		imgui.SameLine()
		local itemColor = settings.colors.itemButtons
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(itemColor[0], itemColor[1], itemColor[2], itemColor[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(itemColor[0] * 1.2, itemColor[1] * 1.2, itemColor[2] * 1.2, 1))
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(fa('rotate') .. ' Сброс', imgui.ImVec2(resetButtonWidth, 0)) then 
			if fa_font then imgui.PopFont() end
			ui.search.id = ui.search.id + 1
			ui.search.input = imgui.new.char[128]()
			ui.search.tmp.helpFind = nil
			ui.search.resultsValid = false
			ui.search.cachedResults = {}
		end
		imgui.PopStyleColor(2)
		imgui.SameLine()
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(itemColor[0], itemColor[1], itemColor[2], itemColor[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(itemColor[0] * 1.2, itemColor[1] * 1.2, itemColor[2] * 1.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(itemColor[0] * 1.4, itemColor[1] * 1.4, itemColor[2] * 1.4, 1))
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(fa('gear'), imgui.ImVec2(settingsButtonWidth, 0)) then 
			if fa_font then imgui.PopFont() end
			if efir.auto.active and not efir.auto.paused and not efir.auto.pausedDuringQuestions and not efir.auto.pausedDuringStartup then
				chatMessage(u8:decode('[News Helper] Нельзя открыть настройки во время активного автоэфира!'), 0xFF0000)
			else
				windows.help[0] = false
				windows.mainSettings[0] = true
				ui.search.resultsValid = false
				ui.search.cachedResults = {}
				ui.search.tmp.helpFind = nil
			end
		end
		if fa_font then imgui.PopFont() end
		imgui.PopStyleColor(3)
		if imgui.IsItemHovered() then
			imgui.SetTooltip('Открыть настройки')
		end
		imgui.SameLine()
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(itemColor[0], itemColor[1], itemColor[2], itemColor[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(itemColor[0] * 1.2, itemColor[1] * 1.2, itemColor[2] * 1.2, 1))
		local expandButtonText = editor.allExpanded and (fa('square_minus') .. ' Свернуть все') or (fa('square_plus') .. ' Развернуть все')
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(expandButtonText, imgui.ImVec2(expandButtonWidth, 0)) then 
			if fa_font then imgui.PopFont() end
			toggleAllCategories()
		end
		imgui.PopStyleColor(2)
		local current_time = os.clock()
		if not ui.search.resultsValid and (current_time - ui.search.debounceTimer) >= settings.searchDebounceDelay then
			updateSearchResults(ui.search.tmp.helpFind or "")
		end
		imgui.Separator()
		imgui.BeginChild('ScrollArea', imgui.ImVec2(0, -50), false)
		if ui.search.needRestoreScroll and ui.search.savedScrollY then
			if not ui.search.restoreFrame then
				ui.search.restoreFrame = 0
			end
			ui.search.restoreFrame = ui.search.restoreFrame + 1
			if ui.search.restoreFrame == 1 then
				imgui.SetScrollY(ui.search.savedScrollY)
			elseif ui.search.restoreFrame > 1 then
				ui.search.needRestoreScroll = false
				ui.search.restoreFrame = 0
			end
		else
			ui.search.savedScrollY = imgui.GetScrollY()
			ui.search.restoreFrame = 0
		end
		if ui.search.resultsValid then
			for i = 1, #data.newsHelpBind do
				local matchingItems = ui.search.cachedResults[i]
				local category = data.newsHelpBind[i]
				local isBufferCategory = category and category[1] == settings.bufferCategoryName
				local searchQuery = ui.search.tmp.helpFind or ""
				local hasMatchingItems = matchingItems and #matchingItems > 0
				local shouldShow = (isBufferCategory and searchQuery == "") or hasMatchingItems
				if shouldShow then
					local categoryName = category[1] or ''
					if editor.categoryStates[i] ~= nil then
						imgui.SetNextItemOpen(editor.categoryStates[i])
					end
					local isOpen = imgui.CollapsingHeader(categoryName .. '##cat' .. i)
					editor.categoryStates[i] = isOpen
					if isOpen then
						local buttonWidth, buttonsInRow = (imgui.GetWindowWidth() - 40) / 3, 0
						if #category <= 1 and isBufferCategory then
							imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'Буфер пуст')
						else
							for idx, j in ipairs(matchingItems or {}) do
								local item = category[j]
								if buttonsInRow > 0 and buttonsInRow < 3 then imgui.SameLine() end
								local itemColor = settings.colors.itemButtons
								imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(itemColor[0], itemColor[1], itemColor[2], itemColor[3]))
								imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(itemColor[0] * 1.2, itemColor[1] * 1.2, itemColor[2] * 1.2, 1))
								imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(itemColor[0] * 1.4, itemColor[1] * 1.4, itemColor[2] * 1.4, 1))
								local buttonName = item[1] or '' 
								local buttonText = item[2] or ''
								local uniqueID = tostring(i) .. "_" .. tostring(idx)
								if imgui.Button(buttonName .. '##buf' .. uniqueID, imgui.ImVec2(buttonWidth, 28)) then
									if sampIsDialogActive() and not windows.customAd[0] then
										showVariableInputWindow(buttonText, true)
									elseif windows.customAd[0] then 
										showVariableInputWindow(buttonText, false)
									else
										sampAddChatMessage(u8:decode('[News Helper] Откройте диалог редактирования объявления!'), 0xFF0000) 
									end
								end
								imgui.PopStyleColor(3)
								if imgui.IsItemHovered() then 
									imgui.BeginTooltip()
									imgui.Text(buttonText)
									imgui.EndTooltip()
								end
								buttonsInRow = buttonsInRow + 1
								if buttonsInRow >= 3 then buttonsInRow = 0 end
							end
						end
					end
				end
			end
		else
			imgui.Text("Поиск...")
		end
		ui.search.savedScrollY = imgui.GetScrollY()
		imgui.EndChild()
		imgui.Separator()
		local itemColor = settings.colors.itemButtons
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(itemColor[0], itemColor[1], itemColor[2], itemColor[3]))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(itemColor[0] * 1.2, itemColor[1] * 1.2, itemColor[2] * 1.2, 1))
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(fa('pen_to_square') .. ' Редактор', imgui.ImVec2(imgui.GetWindowWidth() - 10, 30)) then
			if fa_font then imgui.PopFont() end
			windows.editor[0] = true
		end
		imgui.PopStyleColor(2)
		if imgui.IsItemHovered() then
			imgui.BeginTooltip()
			imgui.Text('Редактор биндов')
			imgui.EndTooltip()
		end
	end
	if not windows.help[0] then
		ui.search.resultsValid = false
		ui.search.cachedResults = {}
		ui.search.tmp = ui.search.tmp or {}
		ui.search.tmp.helpFind = nil
		ui.search.savedScrollY = 0
	end
	imgui.End()
end).Priority = settings.renderPriority + 250
imgui.OnFrame(function() return windows.pro[0] end, function()
	local sizeX, sizeY = getScreenResolution()
	imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
	imgui.SetNextWindowSize(imgui.ImVec2(1050, 600), imgui.Cond.FirstUseEver)
	if windows.pro[0] then imgui.SetNextWindowFocus() end
	local bg = settings.colors.background or {0.1, 0.1, 0.1}
	local item = settings.colors.itemButtons or {0.2, 0.2, 0.2}
	imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(bg[0], bg[1], bg[2], 1))
	imgui.Begin('VIC Справочник', rPRO, imgui.WindowFlags.NoCollapse + settings.topMostFlags)
	if windows.pro[0] then bringWindowToFront() end
	if not ui.search.pro then 
		ui.search.pro = {input = imgui.new.char[256](), results = {}, cachedText = "", selectedTab = nil} 
	end
	if data.myRankNumber < 2 and not isDevMode then
		imgui.TextColored(imgui.ImVec4(1, 0.3, 0.3, 1), "Доступно со 2-го ранга")
		local rankSuffix = data.myRankNumber == 1 and "-ый" or data.myRankNumber == 2 and "-ой" or data.myRankNumber == 3 and "-ий" or "-ый"
		imgui.TextColored(imgui.ImVec4(1, 0.3, 0.3, 1), string.format("Вы сейчас %d%s", data.myRankNumber, rankSuffix))
	else
		imgui.PushStyleColor(imgui.Col.Tab, imgui.ImVec4(item[0], item[1], item[2], 1))
		imgui.PushStyleColor(imgui.Col.TabHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
		imgui.PushStyleColor(imgui.Col.TabActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
		local windowWidth = imgui.GetWindowWidth()
		local searchWidth = 420
		local tabBarY = imgui.GetCursorPosY()
		if imgui.BeginTabBar('##ProTabs') then
			local function drawProTab(title, dataText, tooltip)
				local tabHovered = false
				if imgui.BeginTabItem(title) then
					tabHovered = imgui.IsItemHovered()
					local baseScale = 1.2
					local searchQuery = ffi.string(ui.search.pro.input)
					imgui.BeginChild("ScrollArea" .. title, imgui.ImVec2(0, -10), true, imgui.WindowFlags.NoScrollbar)
					if searchQuery ~= "" then
						local foundAny = false
						local pos = 1
						local len = #dataText
						while pos <= len do
							local s_sp, e_sp, sp_title = dataText:find('%[%s*[Ss][Pp][Oo][Ii][Ll][Ee][Rr]%s*=%s*"(.-)"', pos)
							local s_qt, e_qt = dataText:find('%[%s*[Qq][Uu][Oo][Tt][Ee]%s*%]', pos)
							local s_ctr, e_ctr = dataText:find('%[%s*[Cc][Ee][Nn][Tt][Ee][Rr]%s*%]', pos)
							local next_start, tag_type, tag_end, tag_title
							if s_sp and (not s_ctr or s_sp < s_ctr) and (not s_qt or s_sp < s_qt) then
								next_start = s_sp
								tag_type = 'spoiler'
								tag_end = e_sp
								tag_title = sp_title
							elseif s_qt and (not s_ctr or s_qt < s_ctr) then
								next_start = s_qt
								tag_type = 'quote'
								tag_end = e_qt
							elseif s_ctr then
								next_start = s_ctr
								tag_type = 'center'
								tag_end = e_ctr
							else
								next_start = nil
							end
							if not next_start then
								local rest = dataText:sub(pos)
								for line in rest:gmatch("[^\r\n]+") do
									if search_in_bb_text(searchQuery, line) then
										foundAny = true
										render_bb_text(line, baseScale)
										imgui.Spacing()
									end
								end
								break
							else
								if next_start > pos then
									local before = dataText:sub(pos, next_start - 1)
									for line in before:gmatch("[^\r\n]+") do
										if search_in_bb_text(searchQuery, line) then
											foundAny = true
											render_bb_text(line, baseScale)
											imgui.Spacing()
										end
									end
								end
								if tag_type == 'spoiler' then
									local close_s, close_e = dataText:find('%[%s*/%s*[Ss][Pp][Oo][Ii][Ll][Ee][Rr]%s*%]', tag_end + 1)
									if not close_s then close_s = len close_e = len end
									local inner = dataText:sub(tag_end + 1, close_s - 1)
									local header = tag_title or "Спойлер"
									if search_in_bb_text(searchQuery, inner) then
										foundAny = true
										if imgui.CollapsingHeader(header) then
											local dark = imgui.ImVec4(settings.colors.background[0] * 0.3, settings.colors.background[1] * 0.3, settings.colors.background[2] * 0.3, 1)
											local renderLines = {}
											for line in inner:gmatch("[^\r\n]+") do
												if line:match("%S") then
													table.insert(renderLines, line)
												end
											end
											imgui.SetWindowFontScale(baseScale)
											local lineHeight = imgui.GetTextLineHeightWithSpacing()
											imgui.SetWindowFontScale(1.0)
											local childH = lineHeight * #renderLines * 1 + 30
											imgui.PushStyleColor(imgui.Col.ChildBg, dark)
											imgui.BeginChild("spoiler_" .. header, imgui.ImVec2(-1, childH), false, imgui.WindowFlags.AlwaysUseWindowPadding + imgui.WindowFlags.NoScrollbar)
											for _, line in ipairs(renderLines) do
												render_bb_text(line, baseScale)
											end
											imgui.EndChild()
											imgui.PopStyleColor()
										end
									end
									pos = close_e + 1
								elseif tag_type == 'quote' then
									local close_s, close_e = dataText:find('%[%s*/%s*[Qq][Uu][Oo][Tt][Ee]%s*%]', tag_end + 1)
									if not close_s then close_s = len close_e = len end
									local inner = dataText:sub(tag_end + 1, close_s - 1)
									if search_in_bb_text(searchQuery, inner) then
										foundAny = true
										local dark = imgui.ImVec4(settings.colors.background[0] * 0.3, settings.colors.background[1] * 0.3, settings.colors.background[2] * 0.3, 1)
										local renderLines = {}
										for line in inner:gmatch("[^\r\n]+") do
											if line:match("%S") then
												table.insert(renderLines, line)
											end
										end
										imgui.SetWindowFontScale(baseScale)
										local lineHeight = imgui.GetTextLineHeightWithSpacing()
										imgui.SetWindowFontScale(1.0)
										local childH = lineHeight * #renderLines * 1 + 30
										imgui.PushStyleColor(imgui.Col.ChildBg, dark)
										imgui.BeginChild("quote_" .. tostring(pos), imgui.ImVec2(-1, childH), true, imgui.WindowFlags.AlwaysUseWindowPadding + imgui.WindowFlags.NoScrollbar)
										for _, line in ipairs(renderLines) do
											render_bb_text(line, baseScale)
										end
										imgui.EndChild()
										imgui.PopStyleColor()
									end
									pos = close_e + 1
								else
									local close_s, close_e = dataText:find('%[%s*/%s*[Cc][Ee][Nn][Tt][Ee][Rr]%s*%]', tag_end + 1)
									if not close_s then close_s = len close_e = len end
									local inner = dataText:sub(tag_end + 1, close_s - 1)
									if search_in_bb_text(searchQuery, inner) then
										foundAny = true
										render_centered_block(inner, baseScale)
									end
									pos = close_e + 1
								end
							end
						end
						if not foundAny then 
							imgui.TextColored(imgui.ImVec4(0.7,0.7,0.7,1),"Ничего не найдено") 
						end
					else
						if dataText ~= "" then 
							render_pro_text(dataText, baseScale) 
						else 
							imgui.Text("Файл " .. title .. " не загружен.") 
						end
					end
					imgui.EndChild()
					imgui.EndTabItem()
				else
					tabHovered = imgui.IsItemHovered()
				end
				if tabHovered then imgui.SetTooltip(tooltip) end
			end
			drawProTab('П.Р.О', data.PROtext, 'Правила Редактирования Объявлений')
			drawProTab('Устав', data.Ustavtext, 'Устав')
			drawProTab('П.П.С', data.PPStext, 'Правила Проведения Собеседований')
			drawProTab('Н.Т.С', data.NTStext, 'Названия Транспортных Средств')
			imgui.EndTabBar()
		end
		local searchInputWidth = 300
		local searchButtonWidth = 30
		local totalSearchWidth = searchInputWidth + searchButtonWidth + 10
		imgui.SetCursorPos(imgui.ImVec2(windowWidth - totalSearchWidth - 10, tabBarY - 4))
		local inputBgColor = imgui.ImVec4(bg[0] * 0.5, bg[1] * 0.5, bg[2] * 0.5, 1)
		local inputBgColorHovered = imgui.ImVec4(bg[0] * 0.7, bg[1] * 0.7, bg[2] * 0.7, 1)
		local inputBgColorActive = imgui.ImVec4(bg[0] * 0.9, bg[1] * 0.9, bg[2] * 0.9, 1)
		imgui.PushItemWidth(searchInputWidth)
		imgui.InputTextWithHint('##ProSearch', 'Поиск...', ui.search.pro.input, 256)
		imgui.PopItemWidth()
		imgui.SameLine()
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(fa('xmark') .. '##prosearch', imgui.ImVec2(30, 0)) then
			ffi.fill(ui.search.pro.input, 256)
		end
		if fa_font then imgui.PopFont() end
		imgui.PopStyleColor(3)
		imgui.PopStyleColor(3)
	end
	imgui.End()
	imgui.PopStyleColor()
end).Priority = settings.renderPriority + 60
imgui.OnFrame(function() return windows.editor[0] end, function()
	local sizeX, sizeY = getScreenResolution()
	imgui.SetNextWindowPos(imgui.ImVec2(settings.windowPos.x, settings.windowPos.y), imgui.Cond.Always)
	imgui.SetNextWindowSize(imgui.ImVec2(settings.windowSize.x, settings.windowSize.y), imgui.Cond.Always)
	imgui.Begin('Editor', nil, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar)
	local buttonWidth = (imgui.GetWindowWidth() - 30) / 4
	local cat = settings.colors.categoryButtons
	local undoColor = canUndo() and {cat[0], cat[1], cat[2]} or {cat[0] * 0.5, cat[1] * 0.5, cat[2] * 0.5}
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(undoColor[1], undoColor[2], undoColor[3], 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(undoColor[1] * 1.2, undoColor[2] * 1.2, undoColor[3] * 1.2, 1))
	local undoButtonText = canUndo() and 'Отменить' or 'Нету действий'
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('rotate_left') .. ' Отменить', imgui.ImVec2(buttonWidth, 25)) then
	if fa_font then imgui.PopFont() end
		if canUndo() then
			undo()
		else
			chatMessage(u8:decode('[News Helper] Нет действий для отмены'), 0xFF0000)
		end
	end
	imgui.PopStyleColor(2); imgui.SameLine()
	local redoColor = canRedo() and {cat[0], cat[1], cat[2]} or {cat[0] * 0.5, cat[1] * 0.5, cat[2] * 0.5}
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(redoColor[1], redoColor[2], redoColor[3], 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(redoColor[1] * 1.2, redoColor[2] * 1.2, redoColor[3] * 1.2, 1))
	local redoButtonText = canRedo() and 'Вернуть' or 'Нету действий'
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('arrow_rotate_right') .. ' Вернуть', imgui.ImVec2(buttonWidth, 25)) then
	if fa_font then imgui.PopFont() end
		if canRedo() then
			redo()
		else
			chatMessage(u8:decode('[News Helper] Нет действий для возврата'), 0xFF0000)
		end
	end
	imgui.PopStyleColor(2); imgui.SameLine()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(cat[0], cat[1], cat[2], 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(cat[0] * 1.2, cat[1] * 1.2, cat[2] * 1.2, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('xmark') .. ' Выйти', imgui.ImVec2(buttonWidth, 25)) then
	if fa_font then imgui.PopFont() end
		windows.editor[0] = false
	end
	imgui.PopStyleColor(2); imgui.SameLine()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(cat[0], cat[1], cat[2], 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(cat[0] * 1.2, cat[1] * 1.2, cat[2] * 1.2, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('floppy_disk') .. ' Сохранить', imgui.ImVec2(buttonWidth, 25)) then
	if fa_font then imgui.PopFont() end
		if saveHelpBinds() then
			windows.editor[0] = false
		end
	end
	imgui.PopStyleColor(2)
	imgui.Separator(); imgui.Spacing()
	local item = settings.colors.itemButtons
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0] * 1.2, item[1] * 1.2, item[2] * 1.2, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('folder_plus') .. ' Создать категорию', imgui.ImVec2(imgui.GetWindowWidth() - 10, 25)) then
	if fa_font then imgui.PopFont() end
		editor.edit.categoryIndex = 0
		ffi.fill(editor.edit.categoryName, 256)
		windows.editCategory[0] = true
	end
	imgui.PopStyleColor(2)
	imgui.Spacing(); imgui.BeginChild('EditorScrollArea', imgui.ImVec2(0, 0), false)
	for i = 1, #data.newsHelpBind do
		local category = data.newsHelpBind[i]
		local categoryName = category[1] or ''
		if categoryName == settings.bufferCategoryName then
			imgui.CollapsingHeader(categoryName .. '##editcat' .. i)
		else
			local isOpen = imgui.CollapsingHeader(categoryName .. '##editcat' .. i)
			if imgui.IsItemClicked(1) then
				local mousePos = imgui.GetMousePos()
				ui.contextMenu.pos.x = mousePos.x
				ui.contextMenu.pos.y = mousePos.y
				editor.edit.categoryIndex = i
				ui.contextMenu.type = 1
				windows.contextMenu[0] = true
			end
			if imgui.IsItemHovered() and not imgui.IsItemActive() then
				imgui.BeginTooltip()
				imgui.Text('ПКМ для меню действий')
				imgui.EndTooltip()
			end
			if isOpen then
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0] * 0.8, item[1] * 0.8, item[2] * 0.8, 1))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0], item[1], item[2], 1))
				if fa_font then imgui.PushFont(fa_font) end
				if imgui.Button(fa('plus') .. ' Добавить бинд##' .. i, imgui.ImVec2(imgui.GetWindowWidth() - 30, 20)) then
					if fa_font then imgui.PopFont() end
					editor.edit.bindCategoryIndex = i
					editor.edit.bindIndex = 0
					ffi.fill(editor.edit.bindName, 256)
					ffi.fill(editor.edit.bindText, 1024)
					windows.editBind[0] = true
				end
				imgui.PopStyleColor(2)
				imgui.Spacing()
				local bindButtonWidth = (imgui.GetWindowWidth() - 50) / 3
				local bindButtonsInRow = 0
				for j = 2, #category do
					local bind = category[j]
					if bindButtonsInRow > 0 and bindButtonsInRow < 3 then imgui.SameLine() end
					imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
					imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0] * 1.2, item[1] * 1.2, item[2] * 1.2, 1))
					imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0] * 1.4, item[1] * 1.4, item[2] * 1.4, 1))
					local bindName = bind[1] or ''
					if imgui.Button(bindName .. '##editbind' .. i .. j, imgui.ImVec2(bindButtonWidth, 25)) then
					end
					if imgui.IsItemClicked(1) then
						local mousePos = imgui.GetMousePos()
						ui.contextMenu.pos.x = mousePos.x
						ui.contextMenu.pos.y = mousePos.y
						editor.edit.bindCategoryIndex = i
						editor.edit.bindIndex = j
						ui.contextMenu.type = 2
						windows.contextMenu[0] = true
					end
					imgui.PopStyleColor(3)
					if imgui.IsItemHovered() then
						imgui.BeginTooltip()
						imgui.Text(bind[2] or '')
						imgui.Text('ПКМ для меню действий')
						imgui.EndTooltip()
					end
					bindButtonsInRow = bindButtonsInRow + 1
					if bindButtonsInRow >= 3 then bindButtonsInRow = 0 end
				end
			end
		end
	end
	imgui.EndChild()
	imgui.End()
end).Priority = settings.renderPriority + 70
imgui.OnFrame(function() return windows.addCustomBind[0] end, function()
	local sizeX, sizeY = getScreenResolution()
	imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
	imgui.SetNextWindowSize(imgui.ImVec2(350, 180), imgui.Cond.Always)
	imgui.SetNextWindowFocus()
	local windowFlags = imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + 
					imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + 
					settings.topMostFlags
	local bg = settings.colors.background
	local cat = settings.colors.categoryButtons
	local item = settings.colors.itemButtons
	imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(bg[0], bg[1], bg[2], 0.98))
	imgui.PushStyleColor(imgui.Col.TitleBg, imgui.ImVec4(cat[0], cat[1], cat[2], 1))
	imgui.PushStyleColor(imgui.Col.TitleBgActive, imgui.ImVec4(cat[0] * 1.2, cat[1] * 1.2, cat[2] * 1.2, 1))
	imgui.Begin('Новая команда##AddCustomBind', rAddCustomBind, windowFlags)
	bringWindowToFront()
	imgui.Text('Название команды (без /):')
	imgui.PushItemWidth(imgui.GetWindowWidth() - 20)
	local inputBgColor = imgui.ImVec4(bg[0] * 0.5, bg[1] * 0.5, bg[2] * 0.5, 1)
	local inputBgColorHovered = imgui.ImVec4(bg[0] * 0.7, bg[1] * 0.7, bg[2] * 0.7, 1)
	local inputBgColorActive = imgui.ImVec4(bg[0] * 0.9, bg[1] * 0.9, bg[2] * 0.9, 1)
	local enterPressed = imgui.InputText('##NewBindCmd', helpers.newBindCommand, 32, imgui.InputTextFlags.EnterReturnsTrue)
	imgui.PopItemWidth()
	imgui.Spacing()
	imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), 'После создания сразу назначьте клавишу!')
	imgui.Spacing()
	local buttonWidth = (imgui.GetWindowWidth() - 30) / 2
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0] * 1.2, item[1] * 1.2, item[2] * 1.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0] * 1.4, item[1] * 1.4, item[2] * 1.4, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('xmark') .. ' Отмена', imgui.ImVec2(buttonWidth, 30)) then
	if fa_font then imgui.PopFont() end
		windows.addCustomBind[0] = false
		helpers.newBindCommand = nil
	end
	imgui.PopStyleColor(3)
	imgui.SameLine()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0] * 1.2, item[1] * 1.2, item[2] * 1.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0] * 1.4, item[1] * 1.4, item[2] * 1.4, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('circle_plus') .. ' Создать', imgui.ImVec2(150, 30)) then
	if fa_font then imgui.PopFont() end
		local cmd = ffi.string(helpers.newBindCommand)
		if cmd ~= '' then
			if not data.customBinds[cmd] then
				data.customBinds[cmd] = {vk.VK_F1}
				ui.hotkeys.isSettingCustom = cmd
				ui.hotkeys.isSettingHelp = false
				ui.hotkeys.isSettingPro = false
				ui.hotkeys.isSettingEdit = false
				ui.hotkeys.currentIndex = 1
				ui.hotkeys.tempBuffer = {}
				saveConfig()
				chatMessage(u8:decode('[News Helper] Команда /' .. cmd .. ' создана! Нажмите клавишу для назначения...'), 0x00FF00)
				windows.addCustomBind[0] = false
				helpers.newBindCommand = nil
			else
				chatMessage(u8:decode('[News Helper] Команда /' .. cmd .. ' уже существует!'), 0xFF0000)
			end
		end
	end
	imgui.PopStyleColor(3)
	imgui.End()
	imgui.PopStyleColor(3)
end).Priority = settings.renderPriority + 85
imgui.OnFrame(function() return windows.mainSettings[0] end, function()
	local sizeX, sizeY = getScreenResolution()
	tabWindowSizes[0].y = calculateAboutTabHeight()
	tabWindowSizes[3].y = calculateBindsTabHeight()
	if data.currentMainSettingsTab == 7 then
		tabWindowSizes[7].y = calculateEfirMessagesTabHeight()
	end
	local windowSize = tabWindowSizes[data.currentMainSettingsTab] or {x = 800, y = 600}
	imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
	imgui.SetNextWindowSize(imgui.ImVec2(windowSize.x, windowSize.y), imgui.Cond.Always)
	local windowFlags = imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + settings.topMostFlags
	local isOpen = windows.mainSettings
	if imgui.Begin('News Helper - Настройки', isOpen, windowFlags) then
		local item = settings.colors.itemButtons
		local bg = settings.colors.background
		local itemColor = imgui.ImVec4(item[0], item[1], item[2], 1)
		local itemColorHovered = imgui.ImVec4(item[0] * 1.2, item[1] * 1.2, item[2] * 1.2, 1)
		local itemColorActive = imgui.ImVec4(item[0] * 1.4, item[1] * 1.4, item[2] * 1.4, 1)
		local inputBgColor = imgui.ImVec4(bg[0] * 0.5, bg[1] * 0.5, bg[2] * 0.5, 1)
		local inputBgColorHovered = imgui.ImVec4(bg[0] * 0.7, bg[1] * 0.7, bg[2] * 0.7, 1)
		local inputBgColorActive = imgui.ImVec4(bg[0] * 0.9, bg[1] * 0.9, bg[2] * 0.9, 1)
		local currentThemeColors = settings.themes.list.custom.colors
		local currentThemeColors = settings.themes.list.custom.colors
		if not currentThemeColors or not next(currentThemeColors) then
			currentThemeColors = settings.themes.list.default.colors
		end
		local tabColor = currentThemeColors["Tab"] or {0.18, 0.35, 0.58, 0.86}
		local tabActiveColor = {
			math.min(tabColor[1] * 1.3, 1),
			math.min(tabColor[2] * 1.3, 1),
			math.min(tabColor[3] * 1.3, 1),
			tabColor[4]
		}
		local tabHoveredColor = {
			math.min(tabColor[1] * 1.15, 1),
			math.min(tabColor[2] * 1.15, 1),
			math.min(tabColor[3] * 1.15, 1),
			tabColor[4]
		}
		imgui.PushStyleColor(imgui.Col.Tab, imgui.ImVec4(tabColor[1], tabColor[2], tabColor[3], tabColor[4]))
		imgui.PushStyleColor(imgui.Col.TabActive, imgui.ImVec4(tabActiveColor[1], tabActiveColor[2], tabActiveColor[3], tabActiveColor[4]))
		imgui.PushStyleColor(imgui.Col.TabHovered, imgui.ImVec4(tabHoveredColor[1], tabHoveredColor[2], tabHoveredColor[3], tabHoveredColor[4]))
		if imgui.BeginTabBar('##MainTabs') then
			imgui.PushItemWidth(0)
			if fa_font then imgui.PushFont(fa_font) end
			if imgui.BeginTabItem(fa('circle_info') .. ' О скрипте') then
			if fa_font then imgui.PopFont() end
				data.currentMainSettingsTab = 0
				imgui.Spacing()
				imgui.Text('Версия: ' .. script_version)
				imgui.Text('News Helper - Помощник для работы с объявлениями')
				imgui.Text('Автор: alikhan')
				imgui.SameLine()
				imgui.Text('|')
				imgui.SameLine()
				local linkColor = imgui.ImVec4(0.3, 0.6, 1, 1)
				local hoverColor = imgui.ImVec4(0.5, 0.8, 1, 1)
				if imgui.IsItemHovered() then
					imgui.PushStyleColor(imgui.Col.Text, hoverColor)
				else
					imgui.PushStyleColor(imgui.Col.Text, linkColor)
				end
				imgui.Text('VK: @a.baisultanov')
				imgui.PopStyleColor()
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.TextColored(imgui.ImVec4(168/255, 0/255, 255/255, 1), 'Написать разработчику')
					imgui.EndTooltip()
					if imgui.IsItemClicked(0) then
						os.execute('start "" "https://vk.com/im?sel=654213586"')
					end
				end
				imgui.SameLine()
				imgui.SetCursorPos(imgui.ImVec2(imgui.GetWindowWidth() - 165, 60))
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.7, 0.3, 1))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.85, 0.4, 1))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.15, 0.6, 0.25, 1))
				if fa_font then imgui.PushFont(fa_font) end
				if imgui.Button(fa('arrows_rotate') .. ' Проверить обновления', imgui.ImVec2(145,50)) then
					if fa_font then imgui.PopFont() end
					checkForUpdates(true)
				end
				if fa_font then imgui.PopFont() end
				imgui.PopStyleColor(3)
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.TextColored(imgui.ImVec4(0.3, 0.85, 0.4, 1), 'Проверить наличие новых версий скрипта')
					imgui.EndTooltip()
				end
				imgui.Separator()
				imgui.Spacing()
				local buttonWidth = 145
				local buttonHeight = 25
				imgui.Text('Команды:')
				do
					local windowWidth = imgui.GetWindowWidth()
					local cursorPos = imgui.GetCursorPos()
					local spacing = 5
					imgui.SetCursorPosX(windowWidth - (buttonWidth * 2) - spacing + 130)
					imgui.SetCursorPosY(cursorPos.y - 18)
					imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.9, 0.5, 0.2, 1))
					imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(1.0, 0.6, 0.3, 1))
					imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.8, 0.4, 0.1, 1))
					if imgui.Button(fa('trash_can') .. ' Очистить буфер', imgui.ImVec2(buttonWidth, buttonHeight)) then
						clearBuffer()
					end
					imgui.PopStyleColor(3)
					if imgui.IsItemHovered() then
						imgui.BeginTooltip()
						imgui.TextColored(imgui.ImVec4(1, 0.8, 0.4, 1), 'Полностью очищает буфер объявлений')
						imgui.EndTooltip()
					end
					imgui.SetCursorPosX(windowWidth - (buttonWidth * 2) - spacing + 130)
					imgui.SetCursorPosY(cursorPos.y - 18 + buttonHeight + spacing)
					imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.6, 0.8, 1))
					imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.7, 0.9, 1))
					imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.1, 0.5, 0.7, 1))
					if fa_font then imgui.PushFont(fa_font) end
					if imgui.Button(fa('user_tie') .. ' Панель зама', imgui.ImVec2(buttonWidth, buttonHeight)) then
						if fa_font then imgui.PopFont() end
						if data.myRankNumber>=9 or isDevMode then
							windows.rsWindow[0]=true
							windows.mainSettings[0]=false
							loadRSSettings()
						else
							chatMessage(u8:decode('[News Helper] Доступно с 9-го ранга!'),0xFF0000)
						end
					end
					if fa_font then imgui.PopFont() end
					imgui.PopStyleColor(3)
					if imgui.IsItemHovered() then
						imgui.BeginTooltip()
						imgui.TextColored(imgui.ImVec4(0.3, 0.85, 0.4, 1), 'Панель заместителя/лидера для работы с сотрудниками')
						imgui.EndTooltip()
					end
					imgui.SetCursorPos(cursorPos)
				end
				for _, cmd in ipairs(aboutTabContent.commands) do
					imgui.BulletText(cmd)
				end
				imgui.Separator()
				imgui.Text('Горячие клавиши:')
				imgui.BulletText('Delete - помощь')
				imgui.BulletText('Insert - /prav (можно назначить хоткей во вкладке Горячие клавиши)')
				imgui.BulletText('Q - открыть /edit')
				imgui.BulletText('ESC - закрыть окно')
				imgui.Separator()
				imgui.Text('Что нового?:')
				imgui.BulletText('Версия: ' .. script_version)
				for _, item in ipairs(aboutTabWhatsNew) do
					imgui.TextWrapped('- ' .. item)
				end
				imgui.EndTabItem()
			end
			if fa_font then imgui.PushFont(fa_font) end
			if imgui.BeginTabItem(fa('gear') .. ' Настройки') then
			if fa_font then imgui.PopFont() end
				data.currentMainSettingsTab = 1
				imgui.Text('Данные пользователя:')
				imgui.Separator()
				imgui.Spacing()
				imgui.Text('Имя:')
				imgui.SameLine(120)
				local nickText = (data.mainIni.config.c_nick and data.mainIni.config.c_nick ~= "") and data.mainIni.config.c_nick or "Не определено"
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0, 0, 0, 0))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.15, 0.15, 0.15, 0.4))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.2, 0.2, 0.2, 0.6))
				if imgui.Button(nickText .. '##UserNameBtn', imgui.ImVec2(200, 0)) then
					local translatedNick = getPlayerNickTranslated()
					if translatedNick and translatedNick ~= "" then
						data.mainIni.config.c_nick = translatedNick
						if user.nick then ffi.copy(user.nick, translatedNick) end
						saveConfig()
						chatMessage(u8:decode('[News Helper] Ник определен: ' .. translatedNick), 0x00FF00)
					else
						chatMessage(u8:decode('[News Helper] Не удалось определить ник'), 0xFF0000)
					end
				end
				imgui.PopStyleColor(3)
				if imgui.IsItemHovered() then imgui.SetTooltip('Нажмите для определения имени') end
				imgui.Text('Должность:')
				imgui.SameLine(120)
				local rankText = (data.mainIni.config.c_rang_b and data.mainIni.config.c_rang_b ~= "") and data.mainIni.config.c_rang_b or "Не определено"
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0, 0, 0, 0))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.15, 0.15, 0.15, 0.4))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.2, 0.2, 0.2, 0.6))
				if imgui.Button(rankText .. '##UserRankBtn', imgui.ImVec2(200, 0)) then
					detectMyRank()
					chatMessage(u8:decode('[News Helper] Определяем ранг...'), 0xFFFF00)
				end
				imgui.PopStyleColor(3)
				if imgui.IsItemHovered() then imgui.SetTooltip('Нажмите для определения должности') end
				imgui.Text('СМИ:')
				imgui.SameLine(120)
				imgui.PushItemWidth(200)
				if imgui.InputText('##UserOrg', user.org, ffi.sizeof(user.org)) then
					data.mainIni.config.c_cnn = str(user.org)
					saveConfig()
				end
				imgui.PopItemWidth()
				if imgui.IsItemHovered() then
					imgui.SetTooltip('Введите название вашего СМИ (например: СМИ-ЛС, СМИ-СФ)')
				end
				imgui.Text('Город:')
				imgui.SameLine(120)
				imgui.PushItemWidth(200)
				if imgui.InputText('##UserCity', user.city, ffi.sizeof(user.city)) then
					data.mainIni.config.c_city_n = str(user.city)
					saveConfig()
				end
				imgui.PopItemWidth()
				if imgui.IsItemHovered() then
					imgui.SetTooltip('Введите ваш город (например: Лос-Сантос, Сан-Фиерро)')
				end
				imgui.Text('Пол:')
				imgui.SameLine(120)
				setupCheckboxStyle()
				if imgui.RadioButtonIntPtr('Мужской', user.gender, 2) then
					data.mainIni.config.c_pol = user.gender[0]
					saveConfig()
				end
				cleanupCheckboxStyle()
				imgui.SameLine()
				setupCheckboxStyle()
				if imgui.RadioButtonIntPtr('Женский', user.gender, 1) then
					data.mainIni.config.c_pol = user.gender[0]
					saveConfig()
				end
				cleanupCheckboxStyle()
				imgui.Spacing()
				imgui.Separator()
				imgui.Spacing()
				imgui.Text('Название волны:')
				imgui.SameLine(120)
				imgui.PushItemWidth(150)
				if imgui.InputText('##WaveTag', user.waveTag, ffi.sizeof(user.waveTag)) then
				end
				imgui.PopItemWidth()
				if imgui.IsItemHovered() then
					imgui.SetTooltip('Короткое название волны для биндов (например: VaF, ViC и т.д)')
				end
				imgui.SameLine()
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.7, 0.3, 1))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.85, 0.4, 1))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.15, 0.6, 0.25, 1))
				if fa_font then imgui.PushFont(fa_font) end
				if imgui.Button(fa('check') .. ' Применить ко всем', imgui.ImVec2(140, 0)) then
					if fa_font then imgui.PopFont() end
					replaceWaveTagInAllBinds(ffi.string(user.waveTag))
				end
				imgui.PopStyleColor(3)
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), 'ВНИМАНИЕ!')
					imgui.TextWrapped('Заменит ВСЕ теги в квадратных скобках [] во всех биндах')
					imgui.EndTooltip()
				end
				imgui.Spacing()
				imgui.Separator()
				imgui.Spacing()
				imgui.Text('Вариант биндов:')
				imgui.SameLine(120)
				setupCheckboxStyle()
				if imgui.RadioButtonIntPtr('Вариант 1', imgui.new.int(data.selectedBindsVariant), 1) then
					if data.selectedBindsVariant ~= 1 then
						data.selectedBindsVariant = 1
						saveConfig()
						loadHelpBinds()
						chatMessage(u8:decode('[News Helper] Вариант биндов изменен! Биндов перезагружены.'), 0x00FF00)
					end
				end
				cleanupCheckboxStyle()
				imgui.SameLine()
				setupCheckboxStyle()
				if imgui.RadioButtonIntPtr('Вариант 2', imgui.new.int(data.selectedBindsVariant), 2) then
					if data.selectedBindsVariant ~= 2 then
						data.selectedBindsVariant = 2
						saveConfig()
						loadHelpBinds()
						chatMessage(u8:decode('[News Helper] Вариант биндов изменен! Биндов перезагружены.'), 0x00FF00)
					end
				end
				cleanupCheckboxStyle()
				imgui.Spacing()
				imgui.Separator()
				imgui.Spacing()
				imgui.Text('Цвета:')
				imgui.Spacing()
				imgui.Text('Выберите тему:')
				imgui.Spacing()
				local themeOrder = {"default", "blue", "red", "green", "orange", "purple", "custom"}
				local themeColumns = 7
				for idx, themeKey in ipairs(themeOrder) do
					local theme = settings.themes.list[themeKey]
					if (idx - 1) % themeColumns ~= 0 then
						imgui.SameLine()
					end
					local isSelected = settings.themes.current == themeKey
					if isSelected then
						imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.8, 0.2, 1))
						imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.9, 0.3, 1))
						imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.1, 0.7, 0.1, 1))
					else
						imgui.PushStyleColor(imgui.Col.Button, itemColor)
						imgui.PushStyleColor(imgui.Col.ButtonHovered, itemColorHovered)
						imgui.PushStyleColor(imgui.Col.ButtonActive, itemColorActive)
					end
					if imgui.Button(theme.name .. '##theme' .. themeKey, imgui.ImVec2(100, 30)) then
						settings.themes.current = themeKey
						if themeKey ~= "custom" then
							settings.themes.list.custom.colors = {}
							for k, v in pairs(theme.colors) do
								settings.themes.list.custom.colors[k] = {v[1], v[2], v[3], v[4]}
							end
						end
						applyStyle()
						saveConfig()
					end
					imgui.PopStyleColor(3)
				end
				imgui.Spacing()
				imgui.Separator()
				imgui.Spacing()
				imgui.Text('Настройка цветов:')
				imgui.Spacing()
				local colorElements = {
					{"Text", "Текст"},
					{"Border", "Границы"},
					{"WindowBg", "Фон окна"},
					{"TitleBgActive", "Заголовок"},
					{"PopupBg", "Всплывающие"},
					{"ScrollbarGrab", "Скроллбар"},
					{"Button", "Кнопка"},
					{"FrameBgHovered", "Поля ввода"},
					{"FrameBgActive", "Фон чекбокса"},
					{"Tab", "Вкладка"},
					{"ResizeGrip", "Изменение"},
					{"CategoryColor", "Цвет категории"}
				}
				local currentThemeColors = settings.themes.list.custom.colors
				if not currentThemeColors or not next(currentThemeColors) then
					currentThemeColors = settings.themes.list.default.colors
				end
				local itemsPerRow = 3
				local labelWidth = 120
				for i = 1, #colorElements do
					local element = colorElements[i]
					local col = (i - 1) % itemsPerRow
					if col > 0 then
						imgui.SameLine()
					end
					imgui.BeginGroup()
					imgui.Text(element[2])
					imgui.SameLine(labelWidth)
					if not currentThemeColors[element[1]] then
						currentThemeColors[element[1]] = {1, 1, 1, 1}
					end
					local color = imgui.new.float[4](
						currentThemeColors[element[1]][1],
						currentThemeColors[element[1]][2],
						currentThemeColors[element[1]][3],
						currentThemeColors[element[1]][4]
					)
					imgui.PushItemWidth(120)
					if imgui.ColorEdit4('##color' .. element[1], color, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.AlphaBar) then
						settings.themes.current = "custom"
						settings.themes.list.custom.colors[element[1]] = {color[0], color[1], color[2], color[3]}
						applyStyle()
						saveConfig()
					end
					imgui.PopItemWidth()
					imgui.EndGroup()
				end
				imgui.Spacing()
				imgui.PushStyleColor(imgui.Col.Button, itemColor)
				imgui.PushStyleColor(imgui.Col.ButtonHovered, itemColorHovered)
				imgui.PushStyleColor(imgui.Col.ButtonActive, itemColorActive)
				if fa_font then imgui.PushFont(fa_font) end
				if imgui.Button(fa('rotate_left') .. ' Сбросить тему', imgui.ImVec2(170, 25)) then
					if settings.themes.current ~= "custom" then
						local baseTheme = settings.themes.list[settings.themes.current]
						settings.themes.list.custom.colors = {}
						for k, v in pairs(baseTheme.colors) do
							settings.themes.list.custom.colors[k] = {v[1], v[2], v[3], v[4]}
						end
					else
						settings.themes.list.custom.colors = {}
						for k, v in pairs(settings.themes.list.default.colors) do
							settings.themes.list.custom.colors[k] = {v[1], v[2], v[3], v[4]}
						end
					end
					applyStyle()
					saveConfig()
				end
				if fa_font then imgui.PopFont() end
				imgui.PopStyleColor(3)
				imgui.Separator()
				imgui.Spacing()
				imgui.Text('Окно объявлений:')
				imgui.PushStyleColor(imgui.Col.Button, itemColor)
				imgui.PushStyleColor(imgui.Col.ButtonHovered, itemColorHovered)
				imgui.PushStyleColor(imgui.Col.ButtonActive, itemColorActive)
				if fa_font then imgui.PushFont(fa_font) end
				if imgui.Button(fa('maximize') .. ' Изменить размер', imgui.ImVec2(150, 25)) then
				if fa_font then imgui.PopFont() end
					windows.mainSettings[0] = false
					settings.customAd.isPreview = true
					settings.customAd.data = {
						author = "Тест",
						phone = "123456",
						advertisement = "Тестовое объявление для изменения размера окна"
					}
					windows.customAd[0] = true
				end
				imgui.PopStyleColor(3)
				imgui.SameLine()
				imgui.PushStyleColor(imgui.Col.Button, itemColor)
				imgui.PushStyleColor(imgui.Col.ButtonHovered, itemColorHovered)
				imgui.PushStyleColor(imgui.Col.ButtonActive, itemColorActive)
				if fa_font then imgui.PushFont(fa_font) end
				if imgui.Button(fa('arrow_rotate_left') .. ' Вернуть по умолчанию', imgui.ImVec2(180, 25)) then
				if fa_font then imgui.PopFont() end
					settings.customAd.size.x, settings.customAd.size.y = 420, 240
					saveConfig()
					windows.customAd[0] = false
					windows.mainSettings[0] = true
					chatMessage(u8:decode('[News Helper] Размер окна объявлений сброшен'), 0x00FF00)
				end
				imgui.PopStyleColor(3)
				imgui.Separator()
				imgui.Spacing()
				imgui.Text('Автобуфер:')
				setupCheckboxStyle()
				if imgui.Checkbox('Включить автосохранение в буфер', flags.autoBufferEnabled) then
					saveConfig()
					if flags.autoBufferEnabled[0] then
						chatMessage(u8:decode('[News Helper] Автобуфер включен'), 0x00FF00)
					else
						chatMessage(u8:decode('[News Helper] Автобуфер отключен'), 0xFF0000)
					end
				end
				cleanupCheckboxStyle()
				imgui.Spacing()
				imgui.Text('Лимит буфера:')
				imgui.SameLine(100)
				imgui.PushItemWidth(150)
				setupSliderStyle()
				local tempBufferLimit = imgui.new.int(settings.maxBufferSize)
				if imgui.SliderInt('##BufferLimit', tempBufferLimit, 1, 1000) then
					settings.maxBufferSize = tempBufferLimit[0]
					saveConfig()
				end
				cleanupSliderStyle()
				imgui.PopItemWidth()
				imgui.SameLine()
				local textSize = imgui.CalcTextSize(tostring(settings.maxBufferSize))
				local inputWidth = textSize.x + 8.7
				imgui.PushItemWidth(inputWidth)
				local bufferLimitInput = imgui.new.int(settings.maxBufferSize)
				imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImVec4(0x1F/255, 0x1F/255, 0x1F/255, 1))
				imgui.PushStyleColor(imgui.Col.FrameBgHovered, imgui.ImVec4(0x1F/255, 0x1F/255, 0x1F/255, 1))
				imgui.PushStyleColor(imgui.Col.FrameBgActive, imgui.ImVec4(0x1F/255, 0x1F/255, 0x1F/255, 1))
				if imgui.InputInt('##BufferLimitInput', bufferLimitInput, 0, 0, imgui.InputTextFlags.EnterReturnsTrue) then
					local value = bufferLimitInput[0]
					if value < 1 then value = 1 end
					if value > 1000 then value = 1000 end
					settings.maxBufferSize = value
					saveConfig()
				end
				imgui.PopStyleColor(3)
				imgui.PopItemWidth()
				imgui.Separator()
				imgui.Spacing()
				imgui.Text('Дополнительные настройки:')
				setupCheckboxStyle()
				if imgui.Checkbox('Тихий режим (убрать уведомления в чат)', settings.silentMode) then
					saveConfig()
				end
				cleanupCheckboxStyle()
				if imgui.IsItemHovered() then
					imgui.SetTooltip('Отключает все сообщения в чат кроме загрузки скрипта')
				end
				imgui.Spacing()
				imgui.Text('Клавиша прыжка по звездочкам:')
				imgui.SameLine()
				local starKeyName = getKeyName(settings.starJumpKey)
				imgui.PushStyleColor(imgui.Col.Button, itemColor)
				imgui.PushStyleColor(imgui.Col.ButtonHovered, itemColorHovered)
				imgui.PushStyleColor(imgui.Col.ButtonActive, itemColorActive)
				if imgui.Button(starKeyName .. '##starjumpkey', imgui.ImVec2(100, 25)) then
					ui.hotkeys.isSettingStarKey = true
				end
				imgui.PopStyleColor(3)
				if ui.hotkeys.isSettingStarKey then
					imgui.SameLine()
					imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), 'Нажмите клавишу...')
				end
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.TextColored(imgui.ImVec4(0.0, 1.0, 0.0, 1.0), 'Клавиша для быстрого перемещения между * в тексте')
					imgui.EndTooltip()
				end
				imgui.Spacing()
				imgui.Separator()
				imgui.Spacing()
				imgui.Text('Авто-РП:')
				setupCheckboxStyle()
				if imgui.Checkbox('Автоматическое форматирование сообщений', autoRP.enabled) then
					saveConfig()
					if autoRP.enabled[0] then
						chatMessage(u8:decode('[News Helper] Авто-РП включено'), 0x00FF00)
					else
						chatMessage(u8:decode('[News Helper] Авто-РП отключено'), 0xFF0000)
					end
				end
				cleanupCheckboxStyle()
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.PushTextWrapPos(300)
					imgui.Text('Автоматически добавляет заглавную букву')
					imgui.Text('в начало и точку в конец каждого сообщения')
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				end
				imgui.EndTabItem()
			end
			if fa_font then imgui.PushFont(fa_font) end
			if imgui.BeginTabItem(fa('key') .. ' Автологин') then
			if fa_font then imgui.PopFont() end
				data.currentMainSettingsTab = 2
				imgui.Text('Настройки автологина:')
				imgui.Separator()
				imgui.Spacing()
				setupCheckboxStyle()
				if imgui.Checkbox('Включить автологин', settings.autologin.enabled) then
					saveConfig()
					if settings.autologin.enabled[0] then
						chatMessage(u8:decode('[News Helper] Автологин включен'), 0x00FF00)
					else
						chatMessage(u8:decode('[News Helper] Автологин отключен'), 0xFF0000)
					end
				end
				cleanupCheckboxStyle()
				imgui.Spacing()
				if settings.autologin.enabled[0] then
					imgui.Text('Пароль от аккаунта:')
					imgui.PushItemWidth(300)
					local passwordFlags = settings.autologin.showPassword[0] and 0 or imgui.InputTextFlags.Password
					if imgui.InputTextWithHint('##AutologinPassword', 'Введите пароль', settings.autologin.password, sizeof(settings.autologin.password), passwordFlags) then
						saveConfig()
					end
					imgui.PopItemWidth()
					imgui.SameLine()
					imgui.PushStyleColor(imgui.Col.Button, itemColor)
					imgui.PushStyleColor(imgui.Col.ButtonHovered, itemColorHovered)
					imgui.PushStyleColor(imgui.Col.ButtonActive, itemColorActive)
					if imgui.Button(settings.autologin.showPassword[0] and 'Скрыть##pass' or 'Показать##pass', imgui.ImVec2(80, 0)) then
						settings.autologin.showPassword[0] = not settings.autologin.showPassword[0]
					end
					imgui.PopStyleColor(3)
					imgui.Spacing()
					imgui.Text('Пин-код:')
					imgui.PushItemWidth(150)
					local pincodeFlags = settings.autologin.showPincode[0] and 0 or imgui.InputTextFlags.Password
					if imgui.InputTextWithHint('##AutologinPincode', 'Пин-код', settings.autologin.pincode, sizeof(settings.autologin.pincode), pincodeFlags) then
						local input_string = ffi.string(settings.autologin.pincode)
						local filtered_string = input_string:gsub('%D', '')
						if filtered_string ~= input_string then
							ffi.copy(settings.autologin.pincode, filtered_string, #filtered_string + 1)
						end
						saveConfig()
					end
					imgui.PopItemWidth()
					imgui.SameLine()
					imgui.PushStyleColor(imgui.Col.Button, itemColor)
					imgui.PushStyleColor(imgui.Col.ButtonHovered, itemColorHovered)
					imgui.PushStyleColor(imgui.Col.ButtonActive, itemColorActive)
					if imgui.Button(settings.autologin.showPincode[0] and 'Скрыть##pin' or 'Показать##pin', imgui.ImVec2(80, 0)) then
						settings.autologin.showPincode[0] = not settings.autologin.showPincode[0]
					end
					imgui.PopStyleColor(3)
					imgui.Spacing()
					imgui.Separator()
					imgui.Spacing()
					setupCheckboxStyle()
					if imgui.Checkbox('Автоматически появляться в фракции', flags.autospawnEnabled) then
						saveConfig()
						if flags.autospawnEnabled[0] then
							chatMessage(u8:decode('[News Helper] Автоспавн включен'), 0x00FF00)
						else
							chatMessage(u8:decode('[News Helper] Автоспавн отключен'), 0xFF0000)
						end
					end
					cleanupCheckboxStyle()
					imgui.PopStyleColor()
					if imgui.IsItemHovered() then
						imgui.SetTooltip('При входе в игру автоматически выберет спавн на базе фракции')
					end
					imgui.Spacing()
					imgui.Separator()
					imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), 'Внимание!')
					imgui.TextWrapped('Ваши данные хранятся локально на вашем компьютере и не передаются третьим лицам.')
				else
					imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'Включите автологин для настройки параметров')
				end
				imgui.EndTabItem()
			end
			if fa_font then imgui.PushFont(fa_font) end
			if imgui.BeginTabItem(fa('keyboard') .. ' Бинды') then
			if fa_font then imgui.PopFont() end
				data.currentMainSettingsTab = 3
				renderBinderTab()
				imgui.EndTabItem()
			end
			if fa_font then imgui.PushFont(fa_font) end
			if imgui.BeginTabItem(fa('gamepad') .. ' Горячие клавиши') then
			if fa_font then imgui.PopFont() end
				data.currentMainSettingsTab = 4
				imgui.Text('Настройка горячих клавиш:')
				imgui.Separator()
				imgui.Spacing()
				imgui.Text('Окно помощи:')
				local toRemoveHelp = nil
				for i = 1, #ui.hotkeys.help do
					imgui.SameLine()
					local buttonText = ui.hotkeys.isSettingHelp and ui.hotkeys.currentIndex == i and 
									 'Нажмите клавишу...' or getKeyName(ui.hotkeys.help[i])
					imgui.PushStyleColor(imgui.Col.Button, itemColor)
					imgui.PushStyleColor(imgui.Col.ButtonHovered, itemColorHovered)
					imgui.PushStyleColor(imgui.Col.ButtonActive, itemColorActive)
					if imgui.Button(buttonText .. '##helpkey' .. i, imgui.ImVec2(130, 25)) then
						ui.hotkeys.isSettingHelp = true
						ui.hotkeys.isSettingPro = false
						ui.hotkeys.isSettingEdit = false
						ui.hotkeys.currentIndex = i
						ui.hotkeys.tempBuffer = {}
					end
					imgui.PopStyleColor(3)
					if #ui.hotkeys.help > 1 then
						imgui.SameLine()
						imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.2, 0.2, 1))
						imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.3, 0.3, 1))
						imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.1, 0.1, 1))
						if imgui.Button('X##removehelpkey' .. i, imgui.ImVec2(25, 25)) then
							toRemoveHelp = i
						end
						imgui.PopStyleColor(3)
					end
				end
				if toRemoveHelp then
					table.remove(ui.hotkeys.help, toRemoveHelp)
					saveConfig()
				end
				if #ui.hotkeys.help < 3 then
					imgui.SameLine()
					imgui.PushStyleColor(imgui.Col.Button, itemColor)
					imgui.PushStyleColor(imgui.Col.ButtonHovered, itemColorHovered)
					imgui.PushStyleColor(imgui.Col.ButtonActive, itemColorActive)
					if imgui.Button('+##addhelpkey', imgui.ImVec2(25, 25)) then
						table.insert(ui.hotkeys.help, vk.VK_DELETE)
						ui.hotkeys.isSettingHelp = true
						ui.hotkeys.isSettingPro = false
						ui.hotkeys.isSettingEdit = false
						ui.hotkeys.currentIndex = #ui.hotkeys.help
						ui.hotkeys.tempBuffer = {}
					end
					imgui.PopStyleColor(3)
					if imgui.IsItemHovered() then
						imgui.SetTooltip('Добавить клавишу к комбинации (макс. 3)')
					end
				end
				imgui.Spacing()
				imgui.Text('Окно ПРО:')
				local toRemovePro = nil
				if #ui.hotkeys.pro == 0 then
					imgui.SameLine()
					imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(itemColor.x * 0.5, itemColor.y * 0.5, itemColor.z * 0.5, 1))
					imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(itemColor.x * 0.7, itemColor.y * 0.7, itemColor.z * 0.7, 1))
					imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(itemColor.x * 0.9, itemColor.y * 0.9, itemColor.z * 0.9, 1))
					if imgui.Button('Не назначено##prokey0', imgui.ImVec2(130, 25)) then
						table.insert(ui.hotkeys.pro, vk.VK_INSERT)
						ui.hotkeys.isSettingPro = true
						ui.hotkeys.isSettingHelp = false
						ui.hotkeys.isSettingEdit = false
						ui.hotkeys.currentIndex = 1
						ui.hotkeys.tempBuffer = {}
					end
					imgui.PopStyleColor(3)
					if imgui.IsItemHovered() then
						imgui.SetTooltip('Нажмите, чтобы назначить горячую клавишу')
					end
				else
					for i = 1, #ui.hotkeys.pro do
						imgui.SameLine()
						local buttonText = ui.hotkeys.isSettingPro and ui.hotkeys.currentIndex == i and 
										 'Нажмите клавишу...' or getKeyName(ui.hotkeys.pro[i])
						imgui.PushStyleColor(imgui.Col.Button, itemColor)
						imgui.PushStyleColor(imgui.Col.ButtonHovered, itemColorHovered)
						imgui.PushStyleColor(imgui.Col.ButtonActive, itemColorActive)
						if imgui.Button(buttonText .. '##prokey' .. i, imgui.ImVec2(130, 25)) then
							ui.hotkeys.isSettingPro = true
							ui.hotkeys.isSettingHelp = false
							ui.hotkeys.isSettingEdit = false
							ui.hotkeys.currentIndex = i
							ui.hotkeys.tempBuffer = {}
						end
						imgui.PopStyleColor(3)
						if #ui.hotkeys.pro > 1 then
							imgui.SameLine()
							imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.2, 0.2, 1))
							imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.3, 0.3, 1))
							imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.1, 0.1, 1))
							if imgui.Button('X##removeprokey' .. i, imgui.ImVec2(25, 25)) then
								toRemovePro = i
							end
							imgui.PopStyleColor(3)
						elseif #ui.hotkeys.pro == 1 then
							imgui.SameLine()
							imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.2, 0.2, 1))
							imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.3, 0.3, 1))
							imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.1, 0.1, 1))
							if imgui.Button('X##removeprokey' .. i, imgui.ImVec2(25, 25)) then
								toRemovePro = i
							end
							imgui.PopStyleColor(3)
						end
					end
				end
				if toRemovePro then
					table.remove(ui.hotkeys.pro, toRemovePro)
					saveConfig()
				end
				if #ui.hotkeys.pro > 0 and #ui.hotkeys.pro < 3 then
					imgui.SameLine()
					imgui.PushStyleColor(imgui.Col.Button, itemColor)
					imgui.PushStyleColor(imgui.Col.ButtonHovered, itemColorHovered)
					imgui.PushStyleColor(imgui.Col.ButtonActive, itemColorActive)
					if imgui.Button('+##addprokey', imgui.ImVec2(25, 25)) then
						table.insert(ui.hotkeys.pro, vk.VK_INSERT)
						ui.hotkeys.isSettingPro = true
						ui.hotkeys.isSettingHelp = false
						ui.hotkeys.isSettingEdit = false
						ui.hotkeys.currentIndex = #ui.hotkeys.pro
						ui.hotkeys.tempBuffer = {}
					end
					imgui.PopStyleColor(3)
					if imgui.IsItemHovered() then
						imgui.SetTooltip('Добавить клавишу к комбинации (макс. 3)')
					end
				end
				imgui.SameLine()
				imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), '(также можно командой /prav)')
				imgui.Spacing()
				imgui.Text('Пауза эфира:')
				local toRemovePause = nil
				for i = 1, #efir.control.pauseHotkey do
					imgui.SameLine()
					local buttonText = efir.control.isSettingPauseKey and ui.hotkeys.currentIndex == i and 
									 'Нажмите клавишу...' or getKeyName(efir.control.pauseHotkey[i])
					imgui.PushStyleColor(imgui.Col.Button, itemColor)
					imgui.PushStyleColor(imgui.Col.ButtonHovered, itemColorHovered)
					imgui.PushStyleColor(imgui.Col.ButtonActive, itemColorActive)
					if imgui.Button(buttonText .. '##pausekey' .. i, imgui.ImVec2(130, 25)) then
						efir.control.isSettingPauseKey = true
						ui.hotkeys.isSettingHelp = false
						ui.hotkeys.isSettingPro = false
						ui.hotkeys.isSettingEdit = false
						ui.hotkeys.currentIndex = i
						ui.hotkeys.tempBuffer = {}
					end
					imgui.PopStyleColor(3)
					if #efir.control.pauseHotkey > 1 then
						imgui.SameLine()
						imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.2, 0.2, 1))
						imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.3, 0.3, 1))
						imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.1, 0.1, 1))
						if imgui.Button('X##removepausekey' .. i, imgui.ImVec2(25, 25)) then
							toRemovePause = i
						end
						imgui.PopStyleColor(3)
					end
				end
				if toRemovePause then
					table.remove(efir.control.pauseHotkey, toRemovePause)
					saveConfig()
				end
				if #efir.control.pauseHotkey < 3 then
					imgui.SameLine()
					imgui.PushStyleColor(imgui.Col.Button, itemColor)
					imgui.PushStyleColor(imgui.Col.ButtonHovered, itemColorHovered)
					imgui.PushStyleColor(imgui.Col.ButtonActive, itemColorActive)
					if imgui.Button('+##addpausekey', imgui.ImVec2(25, 25)) then
						table.insert(efir.control.pauseHotkey, vk.VK_K)
						efir.control.isSettingPauseKey = true
						ui.hotkeys.isSettingHelp = false
						ui.hotkeys.isSettingPro = false
						ui.hotkeys.isSettingEdit = false
						ui.hotkeys.currentIndex = #efir.control.pauseHotkey
						ui.hotkeys.tempBuffer = {}
					end
					imgui.PopStyleColor(3)
					if imgui.IsItemHovered() then
						imgui.SetTooltip('Добавить клавишу к комбинации (макс. 3)')
					end
				end
				imgui.Spacing()
				imgui.Text('Окно настроек:')
				local toRemoveSettings = nil
				for i = 1, #ui.hotkeys.settings do
					imgui.SameLine()
					local buttonText = ui.hotkeys.isSettingSettings and ui.hotkeys.currentIndex == i and 
									 'Нажмите клавишу...' or getKeyName(ui.hotkeys.settings[i])
					imgui.PushStyleColor(imgui.Col.Button, itemColor)
					imgui.PushStyleColor(imgui.Col.ButtonHovered, itemColorHovered)
					imgui.PushStyleColor(imgui.Col.ButtonActive, itemColorActive)
					if imgui.Button(buttonText .. '##settingskey' .. i, imgui.ImVec2(130, 25)) then
						ui.hotkeys.isSettingSettings = true
						ui.hotkeys.isSettingHelp = false
						ui.hotkeys.isSettingPro = false
						ui.hotkeys.isSettingEdit = false
						efir.control.isSettingPauseKey = false
						ui.hotkeys.currentIndex = i
						ui.hotkeys.tempBuffer = {}
					end
					imgui.PopStyleColor(3)
					if #ui.hotkeys.settings > 1 then
						imgui.SameLine()
						imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.8, 0.2, 0.2, 1))
						imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.9, 0.3, 0.3, 1))
						imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.7, 0.1, 0.1, 1))
						if imgui.Button('X##removesettingskey' .. i, imgui.ImVec2(25, 25)) then
							toRemoveSettings = i
						end
						imgui.PopStyleColor(3)
					end
				end
				if toRemoveSettings then
					table.remove(ui.hotkeys.settings, toRemoveSettings)
					saveConfig()
				end
				if #ui.hotkeys.settings < 3 then
					imgui.SameLine()
					imgui.PushStyleColor(imgui.Col.Button, itemColor)
					imgui.PushStyleColor(imgui.Col.ButtonHovered, itemColorHovered)
					imgui.PushStyleColor(imgui.Col.ButtonActive, itemColorActive)
					if imgui.Button('+##addsettingskey', imgui.ImVec2(25, 25)) then
						table.insert(ui.hotkeys.settings, vk.VK_M)
						ui.hotkeys.isSettingSettings = true
						ui.hotkeys.isSettingHelp = false
						ui.hotkeys.isSettingPro = false
						ui.hotkeys.isSettingEdit = false
						efir.control.isSettingPauseKey = false
						ui.hotkeys.currentIndex = #ui.hotkeys.settings
						ui.hotkeys.tempBuffer = {}
					end
					imgui.PopStyleColor(3)
					if imgui.IsItemHovered() then
						imgui.SetTooltip('Добавить клавишу к комбинации (макс. 3)')
					end
				end
				imgui.Spacing()
				imgui.Separator()
				imgui.Spacing()
				imgui.PushStyleColor(imgui.Col.Button, itemColor)
				imgui.PushStyleColor(imgui.Col.ButtonHovered, itemColorHovered)
				imgui.PushStyleColor(imgui.Col.ButtonActive, itemColorActive)
				if imgui.Button('Вернуть по умолчанию', imgui.ImVec2(180, 30)) then
					ui.hotkeys.help = {vk.VK_DELETE}
					ui.hotkeys.pro = {}
					ui.hotkeys.settings = {vk.VK_CONTROL, vk.VK_M}
					ui.hotkeys.isSettingHelp = false
					ui.hotkeys.isSettingPro = false
					ui.hotkeys.isSettingEdit = false
					ui.hotkeys.isSettingSettings = false
					ui.hotkeys.currentIndex = 0
					ui.hotkeys.tempBuffer = {}
					saveConfig()
					chatMessage(u8:decode('[News Helper] Горячие клавиши сброшены'), 0x00FF00)
				end
				imgui.PopStyleColor(3)
				imgui.Spacing()
				imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'Подсказка:')
				imgui.TextWrapped('Нажмите на кнопку с названием клавиши, чтобы изменить её. Используйте кнопку "+", чтобы создать комбинацию из нескольких клавиш (до 3). Нажмите ESC для отмены изменения.')
				imgui.EndTabItem()
			end
			if fa_font then imgui.PushFont(fa_font) end
			if imgui.BeginTabItem(fa('users') .. ' Чекер') then
			if fa_font then imgui.PopFont() end
				data.currentMainSettingsTab = 5
				imgui.Text('Чекер сотрудников:')
				setupCheckboxStyle()
				if imgui.Checkbox('Включить чекер', settings.checker.enabled) then
					if settings.checker.enabled[0] then
						windows.checker[0] = true
						settings.checker.waiting = false
						settings.checker.requestAttempts = 0
						settings.checker.lastUpdate = 0
						data.membersList = {}
						lua_thread.create(function()
							wait(100)
							if not sampIsChatInputActive() and not sampIsDialogActive() then
								sampSendChat("/members")
								settings.checker.waiting = true
								settings.checker.requestTime = os.clock()
							end
						end)
					else
						windows.checker[0] = false
						data.membersList = {}
					end
					saveConfig()
				end
				cleanupCheckboxStyle()
				imgui.SameLine()
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.5, 0.8, 1))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.6, 0.9, 1))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.1, 0.4, 0.7, 1))
				imgui.PushStyleVarVec2(imgui.StyleVar.FramePadding, imgui.ImVec2(8, 8))
				if fa_font then imgui.PushFont(fa_font) end
				if imgui.Button(fa('arrows_up_down_left_right') .. ' ##PositionChecker', imgui.ImVec2(30, 30)) then
					if fa_font then imgui.PopFont() end
					if settings.checker.enabled[0] then
						settings.checker.positioning = true
						windows.mainSettings[0] = false
						chatMessage(u8:decode('[News Helper] Переместите мышку в нужное место и нажмите ЛКМ'), 0xFFFF00)
					else
						chatMessage(u8:decode('[News Helper] Сначала включите чекер'), 0xFF0000)
					end
				end
				if fa_font then imgui.PopFont() end
				imgui.PopStyleVar()
				imgui.PopStyleColor(3)
				if imgui.IsItemHovered() then
					imgui.SetTooltip('Изменить расположение чекера')
				end
				imgui.Spacing()
				imgui.Text('Интервал обновления (сек):')
				imgui.PushItemWidth(200)
				setupSliderStyle()
				if imgui.SliderInt('##CheckerInterval', settings.checker.interval, 3, 30) then
					membersCheckerUpdateInterval = settings.checker.interval[0] * 1000
					saveConfig()
				end
				cleanupSliderStyle()
				imgui.PopItemWidth()
				imgui.Text('Цвет заголовка:')
				imgui.SameLine(150)
				if imgui.ColorEdit4('##CheckerColor', settings.checker.textColor, imgui.ColorEditFlags.NoInputs) then
					saveConfig()
				end
				imgui.Text('Размер шрифта:')
				imgui.PushItemWidth(200)
				setupSliderStyle()
				if imgui.SliderInt('##CheckerFontSize', settings.checker.fontSize, 10, 30) then
					saveConfig()
				end
				cleanupSliderStyle()
				imgui.PopItemWidth()
				imgui.EndTabItem()
			end
			if fa_font then imgui.PushFont(fa_font) end
			if imgui.BeginTabItem(fa('microphone') .. ' Эфиры') then
				if fa_font then imgui.PopFont() end
				data.currentMainSettingsTab = 6
				if data.myRankNumber < 5 and not isDevMode then
					imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, 0.3)
					imgui.Text('Выберите тип эфира:')
					imgui.Separator()
					imgui.Spacing()
					local efirTypes = {
						{key = 'math', name = 'Математика', desc = 'Эфир с математическими примерами'},
						{key = 'country', name = 'Столицы', desc = 'Эфир про столицы стран'},
						{key = 'himia', name = 'Химия', desc = 'Эфир по химии'},
						{key = 'zerkalo', name = 'Зеркало', desc = 'Перевернутые слова'},
						{key = 'annagramm', name = 'Анаграммы', desc = 'Составление слов из букв'},
						{key = 'zagadki', name = 'Загадки', desc = 'Эфир с загадками'},
						{key = 'sinonim', name = 'Синонимы', desc = 'Подбор синонимов'},
						{key = 'inter', name = 'Интервью', desc = 'Интервью с гостем'},
						{key = 'reklama', name = 'Реклама', desc = 'Рекламная пауза'},
						{key = 'sobes', name = 'Собеседование', desc = 'Объявление о собеседовании'}
					}
					local windowWidth = imgui.GetWindowWidth() - 40
					local buttonWidth = (windowWidth - 40) / 5
					local buttonHeight = 40
					local spacing = 10
					for i, efirType in ipairs(efirTypes) do
						local col = (i - 1) % 5
						if col > 0 then imgui.SameLine(0, spacing) end
						imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.5, 0.5, 0.5, 1))
						imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.5, 0.5, 0.5, 1))
						imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.5, 0.5, 0.5, 1))
						imgui.Button(efirType.name .. '##' .. efirType.key, imgui.ImVec2(buttonWidth, buttonHeight))
						imgui.PopStyleColor(3)
						if i % 5 == 0 then imgui.Spacing() end
					end
					imgui.PopStyleVar()
					local winWidth = imgui.GetWindowWidth()
					local winHeight = imgui.GetWindowHeight()
					local topOffset = 50
					local overlayHeight = winHeight - topOffset - 10
					imgui.SetCursorPos(imgui.ImVec2(0, topOffset))
					imgui.PushStyleColor(imgui.Col.ChildBg, imgui.ImVec4(0, 0, 0, 0.6))
					imgui.BeginChild('##BlockedEfirOverlay', imgui.ImVec2(winWidth, overlayHeight), false, imgui.WindowFlags.NoScrollbar)
					local rankSuffix = data.myRankNumber == 1 and "-ый" or data.myRankNumber == 2 and "-ой" or data.myRankNumber == 3 and "-ий" or "-ый"
					local text = string.format("Доступно с 5-го ранга\n\nВы сейчас %d%s", data.myRankNumber, rankSuffix)
					imgui.SetWindowFontScale(2.0)
					local textSize = imgui.CalcTextSize(text)
					imgui.SetCursorPos(imgui.ImVec2(winWidth / 2 - textSize.x / 2, overlayHeight / 2 - textSize.y / 2))
					imgui.TextColored(imgui.ImVec4(1, 0.3, 0.3, 1), text)
					imgui.SetWindowFontScale(1.0)
					imgui.EndChild()
					imgui.PopStyleColor()
					imgui.EndTabItem()
				else
					imgui.Text('Выберите тип эфира:')
					imgui.Separator()
					imgui.Spacing()
					local efirTypes = {
						{key = 'math', name = 'Математика', desc = 'Эфир с математическими примерами'},
						{key = 'country', name = 'Столицы', desc = 'Эфир про столицы стран'},
						{key = 'himia', name = 'Химия', desc = 'Эфир по химии'},
						{key = 'zerkalo', name = 'Зеркало', desc = 'Перевернутые слова'},
						{key = 'annagramm', name = 'Анаграммы', desc = 'Составление слов из букв'},
						{key = 'zagadki', name = 'Загадки', desc = 'Эфир с загадками'},
						{key = 'sinonim', name = 'Синонимы', desc = 'Подбор синонимов'},
						{key = 'inter', name = 'Интервью', desc = 'Интервью с гостем'},
						{key = 'reklama', name = 'Реклама', desc = 'Рекламная пауза'},
						{key = 'sobes', name = 'Собеседование', desc = 'Объявление о собеседовании'}
					}
					local windowWidth = imgui.GetWindowWidth() - 40
					local buttonWidth = (windowWidth - 40) / 5
					local buttonHeight = 40
					local spacing = 10
					for i, efirType in ipairs(efirTypes) do
						local col = (i - 1) % 5
						if col > 0 then imgui.SameLine(0, spacing) end
						local isSelected = efir.selectedType == efirType.key
						if isSelected then
							imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.8, 0.2, 1))
							imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.9, 0.3, 1))
							imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.1, 0.7, 0.1, 1))
						else
							imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
							imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0] * 1.2, item[1] * 1.2, item[2] * 1.2, 1))
							imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0] * 1.4, item[1] * 1.4, item[2] * 1.4, 1))
						end
						if imgui.Button(efirType.name .. '##' .. efirType.key, imgui.ImVec2(buttonWidth, buttonHeight)) then
							efir.selectedType = efirType.key
						end
						imgui.PopStyleColor(3)
						if imgui.IsItemHovered() then imgui.SetTooltip(efirType.desc) end
						if i % 5 == 0 then imgui.Spacing() end
					end
					imgui.Separator()
					imgui.Spacing()
					if efir.selectedType and efir.messages[efir.selectedType] then
						imgui.Text('Выбранный эфир: ' .. efir.selectedType)
						imgui.Spacing()
						imgui.BeginChild('##EfirControl', imgui.ImVec2(0, 0), true)
						if efir.selectedType == 'math' then renderMathEfir()
						elseif efir.selectedType == 'country' then renderCountryEfir()
						elseif efir.selectedType == 'himia' then renderHimiaEfir()
						elseif efir.selectedType == 'zerkalo' then renderZerkaloEfir()
						elseif efir.selectedType == 'annagramm' then renderAnnagrammEfir()
						elseif efir.selectedType == 'zagadki' then renderZagadkiEfir()
						elseif efir.selectedType == 'sinonim' then renderSinonimEfir()
						elseif efir.selectedType == 'inter' then renderIntervyuEfir()
						elseif efir.selectedType == 'reklama' then renderReklamaEfir()
						elseif efir.selectedType == 'sobes' then renderSobesEfir() end
						imgui.EndChild()
					else
						imgui.TextColored(imgui.ImVec4(0.7, 0.7, 0.7, 1), 'Выберите тип эфира для начала работы')
					end
					imgui.EndTabItem()
				end
			end
			if fa_font then imgui.PushFont(fa_font) end
			if imgui.BeginTabItem(fa('comment') .. ' Сообщения эфира') then
				if fa_font then imgui.PopFont() end
				data.currentMainSettingsTab = 7
				if data.myRankNumber < 5 and not isDevMode then
					imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, 0.3)
					renderEfirMessagesEditor()
					imgui.PopStyleVar()
					local winWidth = imgui.GetWindowWidth()
					local winHeight = imgui.GetWindowHeight()
					local topOffset = 50
					local overlayHeight = winHeight - topOffset - 10
					imgui.SetCursorPos(imgui.ImVec2(0, topOffset))
					imgui.PushStyleColor(imgui.Col.ChildBg, imgui.ImVec4(0, 0, 0, 0.7))
					imgui.BeginChild('##BlockedMessages', imgui.ImVec2(winWidth, overlayHeight), false, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoInputs)
					local rankSuffix = data.myRankNumber == 1 and "-ый" or data.myRankNumber == 2 and "-ой" or data.myRankNumber == 3 and "-ий" or "-ый"
					local text = string.format("Доступно с 5-го ранга\n\nВы сейчас %d%s", data.myRankNumber, rankSuffix)
					imgui.SetWindowFontScale(2.0)
					local textSize = imgui.CalcTextSize(text)
					imgui.SetCursorPos(imgui.ImVec2(winWidth / 2 - textSize.x / 2, overlayHeight / 2 - textSize.y / 2))
					imgui.TextColored(imgui.ImVec4(1, 0.3, 0.3, 1), text)
					imgui.SetWindowFontScale(1.0)
					imgui.EndChild()
					imgui.PopStyleColor()
					imgui.EndTabItem()
				else
					renderEfirMessagesEditor()
					imgui.EndTabItem()
				end
			end
			if fa_font then imgui.PushFont(fa_font) end
			if imgui.BeginTabItem(fa('tower_broadcast') .. ' Эфир без вопросов') then
				data.currentMainSettingsTab = 8
				if data.myRankNumber < 5 and not isDevMode then
					imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, 0.3)
					renderFreeEfirTab()
					imgui.PopStyleVar()
					local winWidth = imgui.GetWindowWidth()
					local winHeight = imgui.GetWindowHeight()
					local topOffset = 50
					local overlayHeight = winHeight - topOffset - 10
					imgui.SetCursorPos(imgui.ImVec2(0, topOffset))
					imgui.PushStyleColor(imgui.Col.ChildBg, imgui.ImVec4(0, 0, 0, 0.7))
					imgui.BeginChild('##BlockedFreeEfir', imgui.ImVec2(winWidth, overlayHeight), false, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoInputs)
					local rankSuffix = data.myRankNumber == 1 and "-ый" or data.myRankNumber == 2 and "-ой" or data.myRankNumber == 3 and "-ий" or "-ый"
					local text = string.format("Доступно с 5-го ранга\n\nВы сейчас %d%s", data.myRankNumber, rankSuffix)
					imgui.SetWindowFontScale(2.0)
					local textSize = imgui.CalcTextSize(text)
					imgui.SetCursorPos(imgui.ImVec2(winWidth / 2 - textSize.x / 2, overlayHeight / 2 - textSize.y / 2))
					imgui.TextColored(imgui.ImVec4(1, 0.3, 0.3, 1), text)
					imgui.SetWindowFontScale(1.0)
					imgui.EndChild()
					imgui.PopStyleColor()
					imgui.EndTabItem()
				else
					tabWindowSizes[8].y = calculateFreeEfirTabHeight()
					renderFreeEfirTab()
					imgui.EndTabItem()
				end
			end
			imgui.PopItemWidth()
			imgui.EndTabBar()
			imgui.PopStyleColor(3)
			renderBinderEditPopup()
			imgui.End()
		end
	end
	if not isOpen[0] then
		windows.mainSettings[0] = false
	end
end).Priority = settings.renderPriority + 30
imgui.OnFrame(function() return windows.customAd[0] end, function()
	local sizeX, sizeY = getScreenResolution()
	local bg = settings.colors.background
	local windowWidth = settings.customAd.size.x
	local windowHeight = settings.customAd.size.y
	if settings.customAd.isPreview and settings.customAd.tempSize then
		windowWidth = settings.customAd.tempSize.x
		windowHeight = settings.customAd.tempSize.y
	end
	if settings.customAd.isPreview then
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(windowWidth, windowHeight), imgui.Cond.FirstUseEver)
	else
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(windowWidth, windowHeight), imgui.Cond.Always)
	end
	imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(bg[0], bg[1], bg[2], 0.98))
	local windowFlags
	if settings.customAd.isPreview then
		windowFlags = imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + settings.topMostFlags + imgui.WindowFlags.NoTitleBar
	else
		windowFlags = imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoTitleBar + settings.topMostFlags
	end
	imgui.Begin('##CustomAd', nil, windowFlags)
	if settings.customAd.isPreview then
		local currentSize = imgui.GetWindowSize()
		if not settings.customAd.tempSize then
			settings.customAd.tempSize = {x = currentSize.x, y = currentSize.y}
		else
			if settings.customAd.tempSize.x ~= currentSize.x or settings.customAd.tempSize.y ~= currentSize.y then
				settings.customAd.tempSize.x = currentSize.x
				settings.customAd.tempSize.y = currentSize.y
			end
		end
	end
	if windows.customAd[0] then
		bringWindowToFront()
	end
	local titleSize = imgui.CalcTextSize('Объявление')
	imgui.SetCursorPosX((imgui.GetWindowWidth() - titleSize.x) / 2)
	imgui.Text('Объявление')
	imgui.SameLine()
	imgui.TextColored(imgui.ImVec4(0.5, 0.5, 0.5, 1), '(?)')
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.PushTextWrapPos(400)
		imgui.TextColored(imgui.ImVec4(0.7, 0.3, 1, 1), 'Горячие клавиши:')
		imgui.Separator()
		if fa_font then imgui.PushFont(fa_font) end
		imgui.TextColored(imgui.ImVec4(0.3, 1, 0.3, 1), fa('arrow_up'))
		imgui.SameLine()
		imgui.Text('- Вставить текст из буфера с совпадающим объявлением')
		imgui.TextColored(imgui.ImVec4(1, 0.5, 0.3, 1), fa('arrow_down'))
		imgui.SameLine()
		imgui.Text('- Вернуть оригинальный введенный текст')
		imgui.TextColored(imgui.ImVec4(0.3, 0.8, 1, 1), getKeyName(settings.starJumpKey))
		imgui.SameLine()
		imgui.Text('- Прыгать между звездочками (*) в тексте')
		if fa_font then imgui.PopFont() end
		imgui.PopTextWrapPos()
		imgui.EndTooltip()
	end
	imgui.Separator()
	imgui.Spacing()
	local textColor = imgui.ImVec4(
		settings.themes.list.custom.colors.Text[1],
		settings.themes.list.custom.colors.Text[2],
		settings.themes.list.custom.colors.Text[3],
		settings.themes.list.custom.colors.Text[4]
	)
	local _, myId = sampGetPlayerIdByCharHandle(PLAYER_PED)
	local myNick = myId and sampGetPlayerNickname(myId) or ""
	myNick = myNick:gsub("%[PC%]", ""):gsub("%[M%]", "")
	local authorNick = (settings.customAd.data.author or ""):gsub("%[PC%]", ""):gsub("%[M%]", "")
	local authorText = 'Автор: ' .. (settings.customAd.data.author or 'N/A')
	if authorNick == myNick then
		authorText = authorText .. '[' .. tostring(myId) .. ']'
	elseif settings.customAd.data.isAuthorOnline and settings.customAd.data.authorId then
		authorText = authorText .. '[' .. tostring(settings.customAd.data.authorId) .. ']'
	else
		authorText = authorText .. '[не в сети]'
	end
	imgui.TextColored(textColor, authorText)
	imgui.Text('Номер телефона: ' .. (settings.customAd.data.phone or 'N/A'))
	imgui.Text('Объявление: ' .. (settings.customAd.data.advertisement or 'N/A'))
	imgui.Spacing()
	imgui.Text('Введите ответ:')
	imgui.PushItemWidth(imgui.GetWindowWidth() - 20)
	local inputFlags = imgui.InputTextFlags.EnterReturnsTrue
	local inputBgColor = imgui.ImVec4(bg[0] * 0.5, bg[1] * 0.5, bg[2] * 0.5, 1)
	local inputBgColorHovered = imgui.ImVec4(bg[0] * 0.7, bg[1] * 0.7, bg[2] * 0.7, 1)
	local inputBgColorActive = imgui.ImVec4(bg[0] * 0.9, bg[1] * 0.9, bg[2] * 0.9, 1)
	if flags.inputRecreateFrame > 0 then
		if flags.inputRecreateFrame == 2 then
			if flags.pendingBufferInsert then
				ffi.fill(settings.customAd.responseText, ffi.sizeof(settings.customAd.responseText))
				local len = math.min(#flags.pendingBufferInsert, ffi.sizeof(settings.customAd.responseText) - 1)
				ffi.copy(settings.customAd.responseText, flags.pendingBufferInsert, len)
				flags.pendingBufferInsert = nil
			end
			imgui.InvisibleButton('##InputPlaceholder', imgui.ImVec2(imgui.GetWindowWidth() - 20, 20))
		elseif flags.inputRecreateFrame == 1 then
			imgui.InputText('##AdResponse', settings.customAd.responseText, ffi.sizeof(settings.customAd.responseText), inputFlags)
			imgui.SetKeyboardFocusHere(-1)
			flags.inputFieldActive = imgui.IsItemActive()
		end
		flags.inputRecreateFrame = flags.inputRecreateFrame - 1
	else
		local inputTextFlags = imgui.InputTextFlags.EnterReturnsTrue
		if states.pendingCursorPos or #states.starPositions > 0 then
			inputTextFlags = inputTextFlags + imgui.InputTextFlags.CallbackAlways + imgui.InputTextFlags.CallbackCharFilter
		end
		local enterPressed = imgui.InputText('##AdResponse', settings.customAd.responseText, 
			ffi.sizeof(settings.customAd.responseText), inputTextFlags, 
			(states.pendingCursorPos or #states.starPositions > 0) and states.CustomAdEditCallbackCast or nil)
		flags.inputFieldActive = imgui.IsItemActive()
		if states.enterReleased and not flags.blockNextEnter then
			if os.clock() >= flags.blockSendUntil then
				doSendResponse()
			end
			states.enterReleased = false
		end
	end
	if imgui.IsKeyReleased(imgui.Key.Enter) then
		if flags.blockNextEnter then
			flags.blockNextEnter = false
		else
			states.enterReleased = true
		end
	end
	if flags.focusResponse and flags.inputRecreateFrame == 0 then
		imgui.SetKeyboardFocusHere(-1)
		flags.focusResponse = false
	end
	imgui.PopItemWidth()
	imgui.Spacing()
	if flags.focusResponse then
		imgui.SetKeyboardFocusHere(-1)
		flags.focusResponse = false
	end
	local topButtonCount = flags.autoBufferEnabled[0] and 3 or 4
	local topButtonWidth = (imgui.GetWindowWidth() - 20 - (topButtonCount - 1) * 5) / topButtonCount
	local item = settings.colors.itemButtons
	if buttonsDisabled then imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, 0.5) end
	if not flags.autoBufferEnabled[0] then
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
		if fa_font then imgui.PushFont(fa_font) end
		if imgui.Button(fa('copy') .. ' В буфер', imgui.ImVec2(topButtonWidth, 25)) then
			if fa_font then imgui.PopFont() end
			if not buttonsDisabled then
				local response = ffi.string(settings.customAd.responseText)
				if response ~= '' and not response:match("^%s*$") then
					saveToAdBuffer(response, true)
					chatMessage(u8:decode('[News Helper] Сохранено в буфер'), 0x00FF00)
				else
					chatMessage(u8:decode('[News Helper] Введите текст ответа!'), 0xFF0000)
				end
			end
		end
		imgui.PopStyleColor(3)
		imgui.SameLine()
	end
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('wand_magic_sparkles') .. ' Быстрая вставка', imgui.ImVec2(topButtonWidth, 25)) then
		if fa_font then imgui.PopFont() end
		if settings.customAd.originalText then
			ffi.fill(settings.customAd.responseText, ffi.sizeof(settings.customAd.responseText))
			local len = math.min(#settings.customAd.originalText, ffi.sizeof(settings.customAd.responseText)-1)
			ffi.copy(settings.customAd.responseText, settings.customAd.originalText, len)
			flags.inputRecreateFrame = 2
			chatMessage(u8:decode('[News Helper] Вставлен оригинальный текст'), 0x00FF00)
		else
			chatMessage(u8:decode('[News Helper] Оригинальный текст недоступен!'), 0xFF0000)
		end
	end
	if imgui.IsItemClicked(1) then
		if fa_font then imgui.PopFont() end
		local currentText = ffi.string(settings.customAd.responseText)
		local prefix = getWavePrefixFromBinds()
		if not currentText:match("^%[.-%]") then
			local newText = prefix .. " " .. currentText
			ffi.fill(settings.customAd.responseText, ffi.sizeof(settings.customAd.responseText))
			local len = math.min(#newText, ffi.sizeof(settings.customAd.responseText) - 1)
			ffi.copy(settings.customAd.responseText, newText, len)
			flags.inputRecreateFrame = 2
			chatMessage(u8:decode('[News Helper] Префикс добавлен'), 0x00FF00)
		else
			chatMessage(u8:decode('[News Helper] Префикс уже есть в начале текста'), 0xFFFF00)
		end
		if fa_font then imgui.PushFont(fa_font) end
	end
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.TextColored(imgui.ImVec4(0.3, 1, 0.3, 1), 'ЛКМ:')
		imgui.SameLine()
		imgui.Text('Вставить оригинальный текст объявления')
		imgui.TextColored(imgui.ImVec4(0.3, 0.8, 1, 1), 'ПКМ:')
		imgui.SameLine()
		imgui.Text('Добавить префикс волны в начало')
		imgui.EndTooltip()
	end
	imgui.PopStyleColor(3)
	imgui.SameLine()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('file_contract') .. ' Цена', imgui.ImVec2(topButtonWidth, 25)) then
		if fa_font then imgui.PopFont() end
		local currentText = ffi.string(settings.customAd.responseText)
		local newText
		if currentText:find("свободный") then
			newText = currentText:gsub("свободный", "договор")
		else
			newText = currentText .. "договор"
		end
		ffi.fill(settings.customAd.responseText, ffi.sizeof(settings.customAd.responseText))
		local len = math.min(#newText, ffi.sizeof(settings.customAd.responseText) - 1)
		ffi.copy(settings.customAd.responseText, newText, len)
		flags.inputRecreateFrame = 2
	end
	if imgui.IsItemClicked(1) then
		if fa_font then imgui.PopFont() end
		local currentText = ffi.string(settings.customAd.responseText)
		local newText
		if currentText:find("договор") then
			newText = currentText:gsub("договор", "свободный")
		else
			newText = currentText .. "свободный"
		end
		ffi.fill(settings.customAd.responseText, ffi.sizeof(settings.customAd.responseText))
		local len = math.min(#newText, ffi.sizeof(settings.customAd.responseText) - 1)
		ffi.copy(settings.customAd.responseText, newText, len)
		flags.inputRecreateFrame = 2
		if fa_font then imgui.PushFont(fa_font) end
	end
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.TextColored(imgui.ImVec4(0.3, 1, 0.3, 1), 'ЛКМ:')
		imgui.SameLine()
		imgui.Text('Добавить слово "договор"')
		imgui.TextColored(imgui.ImVec4(1, 0.5, 0.3, 1), 'ПКМ:')
		imgui.SameLine()
		imgui.Text('Добавить слово "свободный"')
		imgui.EndTooltip()
	end
	imgui.PopStyleColor(3)
	imgui.SameLine()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('trash_can') .. ' Удалить', imgui.ImVec2(topButtonWidth, 25)) then
		if fa_font then imgui.PopFont() end
		if not buttonsDisabled then
			local reason = ffi.string(settings.customAd.responseText)
			if reason ~= '' and not reason:match("^%s*$") then
				settings.customAd.deleteMode = true
				settings.customAd.deleteReason = reason
				closeCustomAd(false)
				sampSendDialogResponse(698, 0, 0, "")
			else
				chatMessage(u8:decode('[News Helper] Введите причину удаления!'), 0xFF0000)
			end
		end
	end
	if fa_font then imgui.PopFont() end
	imgui.PopStyleColor(3)
	if buttonsDisabled then imgui.PopStyleVar() end
	imgui.Spacing()
	imgui.Separator()
	local bigButtonWidth = (imgui.GetWindowWidth() - 20 - 5) / 2
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('circle_xmark') .. ' Закрыть', imgui.ImVec2(bigButtonWidth, 35)) then
		if fa_font then imgui.PopFont() end
		if not buttonsDisabled then
			closeCustomAd(false)
			sampSendDialogResponse(698, 0, 0, "")
		end
	end
	imgui.PopStyleColor(3)
	imgui.SameLine()
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(item[0], item[1], item[2], 1))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(item[0]*1.2, item[1]*1.2, item[2]*1.2, 1))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(item[0]*1.4, item[1]*1.4, item[2]*1.4, 1))
	if fa_font then imgui.PushFont(fa_font) end
	if imgui.Button(fa('paper_plane') .. ' Отправить', imgui.ImVec2(bigButtonWidth, 35)) then
		if fa_font then imgui.PopFont() end
		if not buttonsDisabled then doSendResponse() end
	end
	imgui.PopStyleColor(3)
	imgui.End()
	imgui.PopStyleColor()
end).Priority = settings.renderPriority + 110
imgui.OnFrame(function()
	return settings.checker.enabled[0] and windows.checker[0]
end,function(arg)
	arg.HideCursor=not settings.checker.positioning
	if settings.checker.positioning then
		local mx,my=getCursorPos()
		settings.checker.pos.x,settings.checker.pos.y=mx,my
	end
	imgui.SetNextWindowPos(imgui.ImVec2(settings.checker.pos.x,settings.checker.pos.y),imgui.Cond.Always)
	local windowFlags=imgui.WindowFlags.NoTitleBar+imgui.WindowFlags.NoResize+imgui.WindowFlags.NoScrollbar+imgui.WindowFlags.NoCollapse+imgui.WindowFlags.AlwaysAutoResize+settings.topMostFlags
	if settings.checker.positioning then windowFlags=windowFlags+imgui.WindowFlags.NoInputs end
	imgui.PushStyleColor(imgui.Col.WindowBg,imgui.ImVec4(0,0,0,0))
	imgui.Begin('##MembersChecker',nil,windowFlags)
	local textFont=getCheckerFont(settings.checker.fontSize[0])
	if textFont then imgui.PushFont(textFont) end
	local headerColor=imgui.ImVec4(settings.checker.textColor[0],settings.checker.textColor[1],settings.checker.textColor[2],settings.checker.textColor[3])
	if settings.checker.positioning then
		imgui.TextColored(imgui.ImVec4(1,1,0,1),'Нажмите ЛКМ чтобы закрепить')
		if isKeyJustPressed(vk.VK_LBUTTON) then
			settings.checker.positioning=false
			settings.checker.firstSetup=false
			saveConfig()
			chatMessage(u8:decode("[News Helper] Позиция чекера сохранена"),0x00FF00)
		end
	end
	imgui.TextColored(headerColor,'Сотрудники в сети:')
	if settings.checker.waiting and #data.membersList==0 then
		imgui.TextColored(imgui.ImVec4(0.7,0.7,0.7,1),'Загрузка...')
	elseif #data.membersList==0 then
		imgui.TextColored(imgui.ImVec4(0.7,0.7,0.7,1),'Никого нет в сети')
	else
		local onlineCount,noUniformCount,muteCount,afkCount=0,0,0,0
		for _,m in ipairs(data.membersList) do
			if m.online then
				onlineCount=onlineCount+1
				if m.noUniform then noUniformCount=noUniformCount+1 end
				if m.mute then muteCount=muteCount+1 end
				if m.afk then afkCount=afkCount+1 end
				local pos=tostring(m.position or "?")
				local name=tostring(m.name or "?")
				local phone=tostring(m.phone or "N/A")
				local warns=tostring(m.warns or "?")
				local mainText=string.format("%s[%d] | %s [%d]",pos,tonumber(m.rank) or 0,name,tonumber(m.id) or 0)
				local mainColor=m.noUniform and imgui.ImVec4(1,0.27,0.27,1) or imgui.ImVec4(1,1,1,1)
				imgui.TextColored(mainColor,mainText)
				imgui.SameLine(0,3)
				if m.platform then
					imgui.TextColored(mainColor,string.format("[%s]",tostring(m.platform)))
					imgui.SameLine(0,3)
				end
				imgui.TextColored(mainColor,string.format("| %s | %s",phone,warns))
				imgui.SameLine(0,3)
				if m.afk then
					imgui.TextColored(imgui.ImVec4(1,1,0,1),string.format("| AFK: %s",tostring(m.afk)))
					imgui.SameLine(0,3)
				end
				if m.mute then
					imgui.TextColored(imgui.ImVec4(1,0,0,1),string.format("| В муте (%s)",tostring(m.mute)))
					imgui.SameLine(0,3)
				end
				if m.noUniform then imgui.TextColored(imgui.ImVec4(1,0.27,0.27,1),"| БЕЗ ФОРМЫ") else imgui.Text("") end
			end
		end
		imgui.Spacing()
		local total=#data.membersList
		imgui.TextColored(imgui.ImVec4(0,1,0,1),'Всего: ')
		imgui.SameLine(0,0)
		imgui.TextColored(imgui.ImVec4(0,1,0,1),tostring(total))
		imgui.SameLine(0,3)
		imgui.TextColored(imgui.ImVec4(1,1,0,1),'| В АФК: ')
		imgui.SameLine(0,0)
		imgui.TextColored(imgui.ImVec4(1,1,0,1),tostring(afkCount))
		imgui.SameLine(0,3)
		imgui.TextColored(imgui.ImVec4(1,0,0,1),'| В муте: ')
		imgui.SameLine(0,0)
		imgui.TextColored(imgui.ImVec4(1,0,0,1),tostring(muteCount))
	end
	if textFont then imgui.PopFont() end
	imgui.End()
	imgui.PopStyleColor()
end).Priority=settings.renderPriority + 300
function shouldBlockInput()
	return windows.editor[0] or windows.colorSettings[0] or 
		windows.editCategory[0] or windows.editBind[0] or windows.contextMenu[0] or 
		windows.pro[0] or windows.mainSettings[0]
end
function loadBufferFromFile()
	local file = io.open(settings.bufferFilePath, 'r')
	if not file then
		return {}
	end
	local content = file:read('*a')
	file:close()
	local data = decodeJson(content)
	return data or {}
end
function clearBuffer()
	local path = settings.bufferFilePath
	local file = io.open(path, "w")
	if file then
		file:write("[]")
		file:close()
	end
	for i = #data.newsHelpBind, 1, -1 do
		local category = data.newsHelpBind[i]
		if category and category[1] == settings.bufferCategoryName then
			for j = #category, 2, -1 do
				table.remove(category, j)
			end
		end
	end
	if saveHelpBindsToFile then
		saveHelpBindsToFile()
	elseif saveConfig then
		saveConfig()
	end
	ui.search.resultsValid = false
	ui.search.cachedResults = {}
	chatMessage(u8:decode("[News Helper] Буфер объявлений очищен!"), 0x00FF00)
end
function saveBufferToFile(bufferData)
	local filePath = settings.configFolder .. 'NewsBuffer.json'
	local file = io.open(filePath, 'w')
	if file then
		file:write(encodeJson(bufferData))
		file:close()
		return true
	else
		chatMessage(u8:decode('[News Helper] Ошибка сохранения буфера'), 0xFF0000)
		return false
	end
end
function updateBufferCategory(bufferData)
	local path = settings.bufferFilePath
	local file = io.open(path, "w")
	if file then
		file:write(encodeJson(bufferData))
		file:close()
	end
	local bufferCategoryIndex
	for i = 1, #data.newsHelpBind do
		if data.newsHelpBind[i][1] == settings.bufferCategoryName then
			bufferCategoryIndex = i
			break
		end
	end
	if not bufferCategoryIndex then
		table.insert(data.newsHelpBind, {settings.bufferCategoryName})
		bufferCategoryIndex = #data.newsHelpBind
	end
	for i = #data.newsHelpBind[bufferCategoryIndex], 2, -1 do
		table.remove(data.newsHelpBind[bufferCategoryIndex], i)
	end
	for idx, entry in ipairs(bufferData) do
		local bindData = {
			entry.advertisement or "",
			entry.editedText or ""
		}
		table.insert(data.newsHelpBind[bufferCategoryIndex], bindData)
	end
end
function loadBufferOnStart()
	local bufferData = loadBufferFromFile()
	if bufferData and #bufferData > 0 then
		updateBufferCategory(bufferData)
		chatMessage(u8:decode(string.format("[News Helper] Загружено %d записей из буфера", #bufferData)), 0x00FF00)
	end
end
lua_thread.create(function()
	local helpKeys = {}
	local proKeys = {}
	local editKeys = {}
	local pauseKeys = {}
	local settingsKeys = {}
	local customKeys = {}
	for _, key in ipairs(ui.hotkeys.help or {}) do
		helpKeys[key] = false
	end
	for _, key in ipairs(ui.hotkeys.pro or {}) do
		proKeys[key] = false
	end
	for _, key in ipairs(ui.hotkeys.edit or {}) do
		editKeys[key] = false
	end
	for _, key in ipairs(efir.control.pauseHotkey or {}) do
		pauseKeys[key] = false
	end
	for _, key in ipairs(ui.hotkeys.settings or {}) do
		settingsKeys[key] = false
	end
	local helpTriggered = false
	local proTriggered = false
	local editTriggered = false
	local pauseTriggered = false
	local settingsTriggered = false
	local customTriggered = {}
	while true do
		wait(0)
		if ui.hotkeys.isSettingHelp or ui.hotkeys.isSettingPro or 
			ui.hotkeys.isSettingEdit or ui.hotkeys.isSettingCustom or
			ui.hotkeys.isSettingSettings or efir.control.isSettingPauseKey then
			goto continue
		end
		if ui.hotkeys.help and #ui.hotkeys.help > 0 then
			local allPressed = true
			for _, key in ipairs(ui.hotkeys.help) do
				if not isKeyPressed(key) then
					allPressed = false
					break
				end
			end
			if allPressed and not helpTriggered then
				helpTriggered = true
				if not windows.mainSettings[0] and
					not windows.editor[0] and not windows.editCategory[0] and 
					not windows.editBind[0] then
					windows.help[0] = not windows.help[0]
					if windows.help[0] then
						ui.search.id = (ui.search.id or 0) + 1
						if not ui.search.input then
							ui.search.input = imgui.new.char[128]()
						else
							ffi.fill(ui.search.input, 128)
						end
						ui.search.tmp = ui.search.tmp or {}
						ui.search.tmp.helpFind = nil
					else
						ui.search.resultsValid = false
						ui.search.cachedResults = {}
						ui.search.tmp = ui.search.tmp or {}
						ui.search.tmp.helpFind = nil
					end
				end
			elseif not allPressed then
				helpTriggered = false
			end
		end
		if ui.hotkeys.pro and #ui.hotkeys.pro > 0 then
			local allPressed = true
			for _, key in ipairs(ui.hotkeys.pro) do
				if not isKeyPressed(key) then
					allPressed = false
					break
				end
			end
			if allPressed and not proTriggered then
				proTriggered = true
				if not windows.mainSettings[0] then
					windows.pro[0] = not windows.pro[0]
					if windows.pro[0] and (data.PROtext or "") == "" then
						loadAllDocuments()
					end
				end
			elseif not allPressed then
				proTriggered = false
			end
			if allPressed and not proTriggered then
				proTriggered = true
				if not windows.mainSettings[0] then
					windows.pro[0] = not windows.pro[0]
					if windows.pro[0] and (data.PROtext or "") == "" then
						loadAllDocuments()
					end
				end
			elseif not allPressed then
				proTriggered = false
			end
		end
		if efir.control.pauseHotkey and #efir.control.pauseHotkey > 0 then
			if not sampIsChatInputActive() and not sampIsDialogActive() then
				local allPressed = true
				for _, key in ipairs(efir.control.pauseHotkey) do
					if not isKeyPressed(key) then
						allPressed = false
						break
					end
				end
				if allPressed and not pauseTriggered then
					pauseTriggered = true
					if efir.auto.finishedQuestions then
						resumeAutoEfirAfterEnd()
					elseif efir.auto.pausedDuringQuestions then
						resumeAutoEfirDuringQuestions()
					elseif efir.auto.pausedDuringStartup then
						resumeAutoEfirDuringStartup()
					elseif efir.auto.active and efir.auto.waitingForAnswer then
						pauseAutoEfirDuringQuestions()
					elseif efir.auto.active then
						pauseAutoEfirDuringStartup()
					elseif efir.control.running then
						efir.control.paused = not efir.control.paused
						if efir.control.paused then
							chatMessage(u8:decode('[News Helper] Эфир на паузе'), 0xFFFF00)
						else
							chatMessage(u8:decode('[News Helper] Эфир возобновлен'), 0x00FF00)
						end
					end
				elseif not allPressed then
					pauseTriggered = false
				end
			end
		end
		for cmd, hotkey in pairs(data.customBinds or {}) do
			if hotkey and #hotkey > 0 then
				if not customTriggered[cmd] then
					customTriggered[cmd] = false
				end
				local allPressed = true
				for _, key in ipairs(hotkey) do
					if not isKeyPressed(key) then
						allPressed = false
						break
					end
				end
				if allPressed and not customTriggered[cmd] then
					customTriggered[cmd] = true
					if not sampIsChatInputActive() and not sampIsDialogActive() then
						sampSendChat("/" .. cmd)
					end
				elseif not allPressed then
					customTriggered[cmd] = false
				end
			end
		end
		::continue::
	end
end)
function sendMembersRequest()
	if not sampIsLocalPlayerSpawned() then return false end
	if sampIsChatInputActive() or sampIsDialogActive() then return false end
	sampSendChat("/members")
	settings.checker.waiting = true
	settings.checker.requestTime = os.clock()
	return true
end
function checkerThreadFunction()
	while true do
		wait(100)
		if settings.checker.enabled[0] and sampIsLocalPlayerSpawned() and not settings.checker.attachToMouse then
			if settings.checker.waiting then
				if os.clock() - settings.checker.requestTime > settings.checker.timeout then
					settings.checker.waiting = false
					settings.checker.requestAttempts = settings.checker.requestAttempts + 1
					if settings.checker.requestAttempts >= settings.checker.maxRequestAttempts then
						settings.checker.requestAttempts = 0
						settings.checker.lastUpdate = os.clock()
					end
				end
			else
				local now = os.clock()
				local updateInterval = settings.checker.interval[0]
				if now - settings.checker.lastUpdate >= updateInterval then
					sendMembersRequest()
				end
			end
		end
	end
end
function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
	imgui.Process = true
	wait(0)
	chat.idPlayers = getChatIdAllPlayers()
	local _, myId = sampGetPlayerIdByCharHandle(PLAYER_PED)
	if myId then
		local myNick = sampGetPlayerNickname(myId)
		if myNick then
			myNick = myNick:gsub("%[PC%]", ""):gsub("%[M%]", "")
			isDevMode = (myNick == "Hayato_Mellson")
		end
	end
	if not doesDirectoryExist(getWorkingDirectory() .. '\\config') then
		createDirectory(getWorkingDirectory() .. '\\config')
	end
	if not doesDirectoryExist(getWorkingDirectory() .. '\\config\\Newstools') then
		createDirectory(getWorkingDirectory() .. '\\config\\Newstools')
	end
	local filesToMigrate = {
		"news_helper_config.json",
		"news_help_binds.json", 
		"NewsPRO.json",
		"NewsBuffer.json"
	}
	for _, fileName in ipairs(filesToMigrate) do
		local oldPath = getWorkingDirectory() .. '\\config\\' .. fileName
		local newPath = getWorkingDirectory() .. '\\config\\Newstools\\' .. fileName
		if doesFileExist(oldPath) and not doesFileExist(newPath) then
			local file = io.open(oldPath, 'r')
			if file then
				local content = file:read('*a')
				file:close()
				local newFile = io.open(newPath, 'w')
				if newFile then
					newFile:write(content)
					newFile:close()
					os.remove(oldPath)
				end
			end
		end
	end
	InitCustomAdCallback()
	initUserVariables()
	for i = 1, 10 do
		efir.examples.math[i] = imgui.new.char[256]()
		efir.answers.math[i] = imgui.new.char[256]()
		efir.examples.country[i] = imgui.new.char[256]()
		efir.answers.country[i] = imgui.new.char[256]()
		efir.examples.himia[i] = imgui.new.char[256]()
		efir.answers.himia[i] = imgui.new.char[256]()
		efir.examples.zerkalo[i] = imgui.new.char[256]()
		efir.answers.zerkalo[i] = imgui.new.char[256]()
		efir.examples.annagramm[i] = imgui.new.char[256]()
		efir.answers.annagramm[i] = imgui.new.char[256]()
		efir.examples.zagadki[i] = imgui.new.char[256]()
		efir.answers.zagadki[i] = imgui.new.char[256]()
		efir.examples.sinonim[i] = imgui.new.char[256]()
		efir.answers.sinonim[i] = imgui.new.char[256]()
	end
	cleanUpdateFiles()
	loadConfig()
	loadRSSettings()
	loadBinder()
	checkAllDocVersions()
	loadAllDocuments()
	checkForUpdates()
	safeAutoDetect()
	loadHelpBinds()
	if not loadEfirMessages() then
		chatMessage(u8:decode('[News Helper] Ошибка загрузки сообщений эфиров'), 0xFF0000)
	end
	ensureBufferCategory()
	loadBufferOnStart()
	moveBufferCategoryToEnd()
	ensureJsonFiles()
	loadCustomEfirs()
	lua_thread.create(function()
		wait(1000)
		local warmup = new.bool(true)
		imgui.OnFrame(function() return warmup[0] end, function()
			imgui.Begin('WarmupWindow', warmup, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar)
			imgui.Text('Initializing...')
			imgui.End()
			warmup[0] = false
		end)
	end)
	sampRegisterChatCommand('reloadefir', function()
		reloadEfirMessages()
		chatMessage(u8:decode('[News Helper] Сообщения эфиров перезагружены!'), 0x00FF00)
	end)
	sampRegisterChatCommand('newsrs',function()
		if data.myRankNumber>=9 or isDevMode then
			windows.rsWindow[0]=not windows.rsWindow[0]
			loadRSSettings()
		else
			chatMessage(u8:decode('[News Helper] Эта команда доступна с 9-го ранга!'),0xFF0000)
		end
	end)
	sampRegisterChatCommand('reloadbinds', function()
		loadHelpBinds()
		loadBufferOnStart()
		ensureBufferCategory()
		moveBufferCategoryToEnd()
		chatMessage(u8:decode('[News Helper] Бинды перезагружены!'), 0x00FF00)
	end)
	sampRegisterChatCommand('newshelp', function()
		if not windows.mainSettings[0] then
			windows.help[0] = not windows.help[0]
		end
		if windows.help[0] then
			ui.search.id = ui.search.id + 1
			ui.search.input = imgui.new.char[128]()
			ui.search.tmp.helpFind = nil
		else
			ui.search.resultsValid = false
			ui.search.cachedResults = {}
			ui.search.tmp.helpFind = nil
		end
	end)
	sampRegisterChatCommand('devmode', function()
		isDevMode = not isDevMode
		saveConfig()
		if isDevMode then
			sampAddChatMessage(u8:decode('[News Helper] Dev mode включен'), 0x00FF00)
		else
			sampAddChatMessage(u8:decode('[News Helper] Dev mode отключен'), 0xFF0000)
		end
	end)
	sampRegisterChatCommand('prav', function() 
		windows.pro[0] = not windows.pro[0]
		if windows.pro[0] and (data.PROtext or "") == "" then
			loadAllDocuments()
		end
	end)
	sampRegisterChatCommand('resetchecker', function()
		if not sampIsLocalPlayerSpawned() then
			chatMessage(u8:decode('[News Helper] Сначала заспавньтесь в игре!'), 0xFF0000)
			return
		end
		settings.checker.waiting = false
		settings.checker.requestAttempts = 0
		settings.checker.lastUpdate = 0
		data.membersList = {}
		chatMessage(u8:decode('[News Helper] Чекер сброшен'), 0x00FF00)
		if settings.checker.enabled[0] then
			sendMembersRequest()
		end
	end)
	sampRegisterChatCommand('resetefir', function(params)
		if params == 'all' then
			resetEfirMessagesToDefault('all')
			saveEfirMessagesToFile()
			chatMessage(u8:decode('[News Helper] Все эфиры сброшены и сохранены!'), 0x00FF00)
		else
			chatMessage(u8:decode('[News Helper] Используйте: /resetefir all'), 0xFFFF00)
		end
	end)
	sampRegisterChatCommand('startefir', function(params)
		if not params or params == '' then
			chatMessage(u8:decode('[News Helper] Использование: /startefir [ключ эфира]'), 0xFF0000)
			return
		end
		if not efir.custom.list[params] then
			chatMessage(u8:decode('[News Helper] Эфир с ключом "' .. params .. '" не найден!'), 0xFF0000)
			return
		end
		local efirData = efir.custom.list[params]
		local linesToSend = {}
		if efir.custom.viewMode == 'square' and efir.custom.selected == params then
			local text = ffi.string(efir.custom.squareText)
			if text ~= '' then
				for line in text:gmatch("[^\r\n]+") do
					local trimmed = line:gsub("^%s+", ""):gsub("%s+$", "")
					if trimmed ~= "" then
						table.insert(linesToSend, trimmed)
					end
				end
			end
		else
			if efirData.lines and #efirData.lines > 0 then
				for _, line in ipairs(efirData.lines) do
					if line.text and line.text ~= '' then
						table.insert(linesToSend, line.text)
					end
				end
			end
		end
		if #linesToSend == 0 then
			chatMessage(u8:decode('[News Helper] В эфире нет строк!'), 0xFF0000)
			return
		end
		efir.auto.finishedQuestions = false
		efir.auto.pausedManually = false
		if efir.control.running then
			if efir.control.thread then
				efir.control.thread:terminate()
			end
			efir.control.running = false
			efir.control.paused = false
			efir.control.currentLine = 1
			chatMessage(u8:decode('[News Helper] Предыдущий эфир остановлен'), 0xFF0000)
		end
		efir.control.running = true
		efir.control.paused = false
		efir.control.currentLine = 1
		efir.control.thread = lua_thread.create(function()
			chatMessage(u8:decode('[News Helper] Начинаю эфир: ' .. efirData.name), 0x00FF00)
			chatMessage(u8:decode('[News Helper] Нажмите ' .. getHotkeyString(efir.control.pauseHotkey) .. ' для паузы/возобновления'), 0xFFFF00)
			while efir.control.currentLine <= #linesToSend and efir.control.running do
				if not efir.control.paused then
					local text = linesToSend[efir.control.currentLine]
					text = replaceEfirVariables(text)
					sampSendChat(u8:decode(text))
					efir.control.currentLine = efir.control.currentLine + 1
					if efir.control.currentLine <= #linesToSend then
						local interval = efir.custom.sendInterval[0] or 3000
						for i = 1, math.ceil(interval/100) do
							if not efir.control.running then
								break
							end
							wait(100)
							if efir.control.paused then
								break
							end
						end
					end
				else
					wait(100)
				end
			end
			if efir.control.running and efir.control.currentLine > #linesToSend then
				chatMessage(u8:decode('[News Helper] Эфир завершен!'), 0x00FF00)
			end
			efir.control.running = false
			efir.control.paused = false
			efir.control.currentLine = 1
		end)
	end)
	sampRegisterChatCommand('stopefir', function(params)
		if efir.control.running then
			if efir.control.thread then
				efir.control.thread:terminate()
			end
			efir.control.running = false
			efir.control.paused = false
			efir.control.currentLine = 1
			chatMessage(u8:decode('[News Helper] Эфир остановлен'), 0xFF0000)
		else
			if params and params ~= '' then
				chatMessage(u8:decode('[News Helper] Эфир "' .. params .. '" закрыт'), 0xFF0000)
			else
				chatMessage(u8:decode('[News Helper] Нет активного эфира'), 0xFF0000)
			end
		end
	end)
	sampRegisterChatCommand('newstools', function()
		if efir.auto.active and not efir.auto.paused and not efir.auto.pausedDuringQuestions and not efir.auto.pausedDuringStartup then
			chatMessage(u8:decode('[News Helper] Нельзя открыть настройки во время активного автоэфира!'), 0xFF0000)
			return
		end
		windows.mainSettings[0] = not windows.mainSettings[0]
	end)
	if fa_font then imgui.PopFont() end
	sampRegisterChatCommand('clearbuffer', function()
		clearBuffer()
	end)
	sampRegisterChatCommand("aaa", function()
		windows.customAd[0] = true
	end)
	sampRegisterChatCommand("newsupdate", function() checkForUpdates(true) end)
	sampRegisterChatCommand("newsinstall", function() installUpdate() end)
	sampRegisterChatCommand("newsbufferlimit", function(arg)
		local value = tonumber(arg)
		if not value then
			chatMessage(u8:decode("[News Helper] Использование: /newsbufferlimit [1-1000]"), 0xFF0000)
			return
		end
		if value < 1 or value > 1000 then
			chatMessage(u8:decode("[News Helper] Введите число от 1 до 1000"), 0xFF0000)
			return
		end
		settings.maxBufferSize = value
		saveConfig()
		chatMessage(u8:decode(string.format("[News Helper] Лимит буфера установлен на %d", settings.maxBufferSize)), 0x00FF00)
	end)
	sampAddChatMessage(
		u8:decode('[News Helper] Скрипт загружен! Команды: /newstools, /newshelp, /newseditor'),
		0x00FF00
	)
	while true do
		wait(0)
		imgui.Process = true
		updateMembersList()
		processScoreQueue()
		processAutoEfirActionQueue()
		checkBinderHotkeys()
		if shouldBlockInput() then
			if windows.customAd[0] then
				if sampGetCursorMode() ~= 2 then
					sampSetCursorMode(2)
				end
			end
			if windows.help[0] then
				saveConfig()
			end
			if windows.contextMenu[0] then
				if wasKeyPressed(vk.VK_E) then
					consumeWindowMessage(true, false)
					if ui.contextMenu.type == 1 and data.newsHelpBind[editor.edit.categoryIndex] then
						local catName = data.newsHelpBind[editor.edit.categoryIndex][1]
						ffi.fill(editor.edit.categoryName, 256)
						ffi.copy(editor.edit.categoryName, catName)
						windows.editCategory[0] = true
					elseif ui.contextMenu.type == 2 and data.newsHelpBind[editor.edit.bindCategoryIndex] and data.newsHelpBind[editor.edit.bindCategoryIndex][editor.edit.bindIndex] then
						local bind = data.newsHelpBind[editor.edit.bindCategoryIndex][editor.edit.bindIndex]
						ffi.fill(editor.edit.bindName, 256)
						ffi.fill(editor.edit.bindText, 1024)
						ffi.copy(editor.edit.bindName, bind[1])
						ffi.copy(editor.edit.bindText, bind[2])
						windows.editBind[0] = true
					end
					windows.contextMenu[0] = false
				end
				if wasKeyPressed(vk.VK_X) then
					consumeWindowMessage(true, false)
					addToHistory()
					if ui.contextMenu.type == 1 and data.newsHelpBind[editor.edit.categoryIndex] then
						local catName = data.newsHelpBind[editor.edit.categoryIndex][1]
						table.remove(data.newsHelpBind, editor.edit.categoryIndex)
						chatMessage(u8:decode('[News Helper] Категория "' .. catName .. '" удалена'), 0x00FF00)
					elseif ui.contextMenu.type == 2 and data.newsHelpBind[editor.edit.bindCategoryIndex] and data.newsHelpBind[editor.edit.bindCategoryIndex][editor.edit.bindIndex] then
						local bindName = data.newsHelpBind[editor.edit.bindCategoryIndex][editor.edit.bindIndex][1]
						table.remove(data.newsHelpBind[editor.edit.bindCategoryIndex], editor.edit.bindIndex)
						chatMessage(u8:decode('[News Helper] Бинд "' .. bindName .. '" удален'), 0x00FF00)
					end
					windows.contextMenu[0] = false
				end
			end
			if windows.contextMenu[0] and imgui.IsMouseClicked(0) then
				windows.contextMenu[0] = false
			end
		end
	end
end
imgui.OnInitialize(function()
	imgui.GetIO().IniFilename = nil
	local glyph_ranges = imgui.GetIO().Fonts:GetGlyphRangesCyrillic()
	local font_path = getFolderPath(0x14) .. '\\trebucbd.ttf'
	local config = imgui.ImFontConfig()
	config.OversampleH = 2
	config.OversampleV = 2
	config.PixelSnapH = true
	config.RasterizerMultiply = 1.2
	imgui.GetIO().Fonts:AddFontFromFileTTF(font_path, 13.0, config, glyph_ranges)
	local fa_config = imgui.ImFontConfig()
	fa_config.MergeMode = true
	fa_config.PixelSnapH = true
	fa_glyph_ranges = imgui.new.ImWchar[3](fa.min_range, fa.max_range, 0)
	fa_font = imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(fa.get_font_data_base85('regular'), 13.0, fa_config, fa_glyph_ranges)
	applyStyle()
end)
imgui.OnInitialize(function()
	local io=imgui.GetIO()
	ui.fonts.default=io.Fonts:AddFontFromFileTTF(getWorkingDirectory()..'\\arial.ttf',16.0)
	ui.fonts.bold=io.Fonts:AddFontFromFileTTF(getWorkingDirectory()..'\\arialbd.ttf',16.0)
	io.Fonts:Build()
	io.FontDefault=ui.fonts.default
end)
imgui.OnInitialize(function()
	local io=imgui.GetIO()
	local fontPath=getFolderPath(0x14)..'\\arialbd.ttf'
	local glyphRanges=io.Fonts:GetGlyphRangesCyrillic()
	local fontConfig=imgui.ImFontConfig()
	fontConfig.OversampleH=3
	fontConfig.OversampleV=3
	fontConfig.RasterizerMultiply=1.3
	ui.fonts.default=io.Fonts:AddFontFromFileTTF(fontPath,13.0,fontConfig,glyphRanges)
	ui.fonts.bold=ui.fonts.default
	ui.fonts.checkerFonts={}
	for size=8,30 do
		local cfg=imgui.ImFontConfig()
		cfg.OversampleH=3
		cfg.OversampleV=3
		cfg.RasterizerMultiply=1.3
		ui.fonts.checkerFonts[size]=io.Fonts:AddFontFromFileTTF(fontPath,size,cfg,glyphRanges)
	end
	io.Fonts:Build()
end)
imgui.OnInitialize(function()
	local io = imgui.GetIO()
	local fontPath = getFolderPath(0x14) .. '\\arialbd.ttf'
	local glyphRanges = io.Fonts:GetGlyphRangesCyrillic()
	local fontConfig = imgui.ImFontConfig()
	fontConfig.OversampleH = 3
	fontConfig.OversampleV = 3
	fontConfig.RasterizerMultiply = 1.3
	ui.fonts.binderStatus = io.Fonts:AddFontFromFileTTF(fontPath, 17.0, fontConfig, glyphRanges)
	io.Fonts:Build()
end)