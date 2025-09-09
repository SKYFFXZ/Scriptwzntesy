-- WZN HUB - AutoUpdate Hotfix

local VERSION = 1.0 -- aumente sempre que atualizar

local UPDATE_URL = "https://pastebin.com/raw/mGX4fkQz"

local HttpService = game:GetService("HttpService")

local RunService = game:GetService("RunService")

local StarterGui = game:GetService("StarterGui")

-- Função para notificar e atualizar

local function notifyAndUpdate(remoteScript)

    -- notificação para o usuário

    pcall(function()

        StarterGui:SetCore("SendNotification", {

            Title = "WZN MODZ",

            Text = "Nova versão disponível! Atualizando...",

            Duration = 5

        })

    end)

    -- carrega o script remoto

    pcall(function()

        loadstring(remoteScript)()

    end)

end

-- Checagem de atualização

local function checkUpdate()

    local success, remoteScript = pcall(function()

        return game:HttpGet(UPDATE_URL)

    end)

    if success and remoteScript then

        -- procura pela linha VERSION no script remoto

        local remoteVersion = tonumber(remoteScript:match("local VERSION%s*=%s*([%d%.]+)"))

        if remoteVersion and remoteVersion > VERSION then

            notifyAndUpdate(remoteScript)

            return true -- script atualizado

        end

    end

    return false

end

-- Loop de monitoramento contínuo

spawn(function()

    while true do

        task.wait(30) -- checa a cada 30s (pode ajustar)

        if checkUpdate() then

            return -- para loop após atualizar

        end

    end

end)

-- === SEU SCRIPT ORIGINAL ABAIXO ===

-- Cole aqui todo o seu script WZN HUB (o que você me enviou antes)

-- Mantenha a lógica de KeySystem, idioma e carregamento dos jogos intacta

-- PARTE 1 / 3

-- SERVIÇOS

local Players = game:GetService("Players")

local player = Players.LocalPlayer

local HttpService = game:GetService("HttpService")

local RunService = game:GetService("RunService")

-- CONFIGURAÇÕES

local Links = {

    "https://lootdest.org/s?YwdPHj8d",

    "https://loot-link.com/s?KlNedpDW",

    "https://loot-link.com/s?YIskQ3Yt",

    "https://loot-link.com/s?4OuXXTrP",

    "https://loot-link.com/s?Ir60l0gl"

}

local ValidKeys = {

    "KEY_WZN_KSHFISNX1629",

    "KEY_WZN_WJISDNAPQA7819",

    "KEY_WZN_JDIWKZKAP8792",

    "KEY_WZN_HWOSBDIW2617",

    "KEY_WZN_JEHFIEBS7292"

}

local ExpireTime = 12 * 60 * 60 -- 12 horas (modifique para teste: ex. 40)

local SaveFile = "WZN_KeySystem.json"

-- Default language until user chooses (will persist after user chooses)

local SelectedLanguage = "Português"

-- PlaceIds permitidos

local AllowedPlaceIds = {

    [2753915549] = "Blox Fruits",          -- Blox Fruits (main)

    [4442272183] = "Blox Fruits",          -- Blox Fruits (others / seas)

    [7449423635] = "Blox Fruits",

    [79546208627805] = "99 Noites na Floresta" -- 99 Noites (fornecido por você)

}

-- TEXTOS (i18n)

local Texts = {

    ["Português"] = {

        title = "WZN MODZ - KEYSYSTEM",

        placeholder = "Cole sua Key",

        getKey = "Pegar Key",

        checkKey = "Checar Key",

        statusEmpty = "Cole uma Key!",

        statusInvalid = "Key inválida!",

        statusUsed = "Você já usou essa Key! Pegue outra.",

        statusAccepted = "Key aceita! Carregando script...",

        expiredMsg = "Sua Key expirou! Pegue outra e continue a usar o script",

        linkCopied = "Link copiado! Abra no navegador para pegar a Key.",

        allUsed = "Todas as Keys já foram usadas! Espere expirar.",

        loading = "Carregando...",

        verifying = "Verificando Key..."

    },

    ["Espanhol"] = {

        title = "WZN MODZ - SISTEMA DE KEY",

        placeholder = "Pega tu Key",

        getKey = "Obtener Key",

        checkKey = "Verificar Key",

        statusEmpty = "¡Pega una Key!",

        statusInvalid = "Key inválida!",

        statusUsed = "¡Ya usaste esta Key! Obtén otra.",

        statusAccepted = "¡Key aceptada! Cargando script...",

        expiredMsg = "¡Tu Key ha expirado! Obtén otra para continuar usando el script",

        linkCopied = "¡Link copiado! Ábrelo en el navegador para obtener la Key.",

        allUsed = "¡Todas las Keys ya fueron usadas! Espera a que expiren.",

        loading = "Cargando...",

        verifying = "Verificando Key..."

    },

    ["Inglês"] = {

        title = "WZN MODZ - KEYSYSTEM",

        placeholder = "Paste your Key",

        getKey = "Get Key",

        checkKey = "Check Key",

        statusEmpty = "Paste a Key!",

        statusInvalid = "Invalid Key!",

        statusUsed = "You already used this Key! Get another.",

        statusAccepted = "Key accepted! Loading script...",

        expiredMsg = "Your Key has expired! Get another to continue using the script",

        linkCopied = "Link copied! Open in browser to get the Key.",

        allUsed = "All Keys have been used! Wait for expiration.",

        loading = "Loading...",

        verifying = "Verifying Key..."

    }

}

-- SMALL HELPERS: JSON save/load (safe)

local function saveJSON(file, obj)

    local ok, err = pcall(function()

        writefile(file, HttpService:JSONEncode(obj))

    end)

    return ok, err

end

local function loadJSON(file)

    if isfile(file) then

        local ok, res = pcall(function()

            return HttpService:JSONDecode(readfile(file))

        end)

        if ok then return res end

    end

    return nil

end

-- LOAD/DEFAULT DATA

local function LoadData()

    local data = loadJSON(SaveFile)

    if type(data) == "table" then

        -- ensure keys exist

        data.CurrentKey = data.CurrentKey or nil

        data.ExpireAt = data.ExpireAt or nil

        data.UsedKeys = data.UsedKeys or {}

        data.UsedLinks = data.UsedLinks or {}

        data.LastLinkIndex = data.LastLinkIndex or nil

        data.SelectedLanguage = data.SelectedLanguage or "Português"

        return data

    end

    return {

        CurrentKey = nil,

        ExpireAt = nil,

        UsedKeys = {},

        UsedLinks = {},

        LastLinkIndex = nil,

        SelectedLanguage = "Português"

    }

end

local function SaveData(data)

    return saveJSON(SaveFile, data)

end

-- NOTIFICAÇÃO via SetCore (Delta/KRNL compatível)

local function Notify(title, text, duration)

    pcall(function()

        game:GetService("StarterGui"):SetCore("SendNotification", {

            Title = title or "WZN MODZ",

            Text = text or "",

            Duration = duration or 5

        })

    end)

end

-- CHECAR JOGO (retorna nome padronizado ou nil e kicka se inválido)

local function CheckGame()

    local place = game.PlaceId

    local name = AllowedPlaceIds[place]

    if name then

        -- notify small message in english/pt? use default notify

        Notify("WZN MODZ", "Jogo detectado: "..name, 4)

        return name

    else

        Notify("WZN MODZ", "This script only works on Blox Fruits or 99 nights in the forest!", 6)

        wait(1)

        pcall(function() player:Kick("This script only works on Blox Fruits or 99 nights in the forest!") end)

        return nil

    end

end

-- localizar índice de uma key (aux)

local function indexOf(tbl, value)

    if not tbl then return nil end

    for i,v in ipairs(tbl) do

        if v == value then return i end

    end

    return nil

end

-- inicial notify

Notify("WZN MODZ", "Carregando...", 4)

-- PARTE 2 / 3

-- TELA DE SELEÇÃO DE IDIOMA (mostra as 3 frases: PT / ES / EN)

local function LanguageSelection()

    -- primeiro checa o jogo

    local GameName = CheckGame()

    if not GameName then return end

    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

    ScreenGui.Name = "WZN_LanguageSelect"

    local Frame = Instance.new("Frame", ScreenGui)

    Frame.Size = UDim2.new(0, 520, 0, 320)

    Frame.Position = UDim2.new(0.5, -260, 0.5, -160)

    Frame.BackgroundColor3 = Color3.fromRGB(28,28,28)

    Frame.BorderSizePixel = 0

    Frame.Active = true

    Frame.Draggable = true

    local corner = Instance.new("UICorner", Frame); corner.CornerRadius = UDim.new(0,12)

    -- FRASES MULTI-IDIOMA (de cima para baixo)

    local f1 = Instance.new("TextLabel", Frame)

    f1.Size = UDim2.new(1, -20, 0, 28); f1.Position = UDim2.new(0,10,0,8)

    f1.Text = "qual idioma você é?"; f1.TextScaled = true; f1.BackgroundTransparency = 1; f1.TextColor3 = Color3.new(1,1,1)

    local f2 = Instance.new("TextLabel", Frame)

    f2.Size = UDim2.new(1, -20, 0, 28); f2.Position = UDim2.new(0,10,0,38)

    f2.Text = "¿Que idioma eres?"; f2.TextScaled = true; f2.BackgroundTransparency = 1; f2.TextColor3 = Color3.new(1,1,1)

    local f3 = Instance.new("TextLabel", Frame)

    f3.Size = UDim2.new(1, -20, 0, 28); f3.Position = UDim2.new(0,10,0,68)

    f3.Text = "What language are you?"; f3.TextScaled = true; f3.BackgroundTransparency = 1; f3.TextColor3 = Color3.new(1,1,1)

    -- BOTÕES

    local btnES = Instance.new("TextButton", Frame)

    btnES.Size = UDim2.new(0.8,0,0,44); btnES.Position = UDim2.new(0.1,0,0.35,0)

    btnES.Text = "1 - Espanhol"; btnES.TextScaled = true; btnES.BackgroundColor3 = Color3.fromRGB(200,40,40)

    local cES = Instance.new("UICorner", btnES); cES.CornerRadius = UDim.new(0,8)

    local btnPT = Instance.new("TextButton", Frame)

    btnPT.Size = UDim2.new(0.8,0,0,44); btnPT.Position = UDim2.new(0.1,0,0.55,0)

    btnPT.Text = "2 - Português"; btnPT.TextScaled = true; btnPT.BackgroundColor3 = Color3.fromRGB(40,200,40)

    local cPT = Instance.new("UICorner", btnPT); cPT.CornerRadius = UDim.new(0,8)

    local btnEN = Instance.new("TextButton", Frame)

    btnEN.Size = UDim2.new(0.8,0,0,44); btnEN.Position = UDim2.new(0.1,0,0.75,0)

    btnEN.Text = "3 - Americano (EUA, CANADÁ)"; btnEN.TextScaled = true; btnEN.BackgroundColor3 = Color3.fromRGB(40,120,200)

    local cEN = Instance.new("UICorner", btnEN); cEN.CornerRadius = UDim.new(0,8)

    local function chooseLang(lang)

        SelectedLanguage = lang

        local msg = ""

        if lang == "Português" then

            msg = "Idioma selecionado: Português"

        elseif lang == "Espanhol" then

            msg = "Idioma seleccionado: Español"

        elseif lang == "Inglês" then

            msg = "Selected language: English"

        end

        -- salva preferência de idioma (persistente)

        local data = LoadData()

        data.SelectedLanguage = SelectedLanguage

        SaveData(data)

        Notify("WZN MODZ", msg, 4)

        ScreenGui:Destroy()

        -- depois da escolha, abre a interface de Key (definida na PARTE 3)

        if typeof(CreateKeyInterface) == "function" then

            CreateKeyInterface()

        else

            -- fallback: esperar e tentar chamar após colagem da PARTE 3

            task.delay(0.2, function()

                if typeof(CreateKeyInterface) == "function" then

                    CreateKeyInterface()

                end

            end)

        end

    end

    btnES.MouseButton1Click:Connect(function() chooseLang("Espanhol") end)

    btnPT.MouseButton1Click:Connect(function() chooseLang("Português") end)

    btnEN.MouseButton1Click:Connect(function() chooseLang("Inglês") end)

end

-- PARTE 3 / 3

-- CRIA INTERFACE DE KEY, LIDA COM GET/CHECK, EXPIRAÇÃO E LOAD DO SCRIPT DO JOGO

-- helper: pega textos atuais

local function getTexts()

    local data = LoadData()

    local lang = data.SelectedLanguage or SelectedLanguage or "Português"

    return Texts[lang] or Texts["Português"], lang

end

-- FUNÇÃO: abrir interface de Key

function CreateKeyInterface()

    local texts, lang = getTexts()

    local data = LoadData()

    -- construir GUI

    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

    ScreenGui.Name = "WZN_KeyInterface"

    local Frame = Instance.new("Frame", ScreenGui)

    Frame.Size = UDim2.new(0, 480, 0, 260)

    Frame.Position = UDim2.new(0.5, -240, 0.5, -130)

    Frame.BackgroundColor3 = Color3.fromRGB(26,26,26)

    Frame.BorderSizePixel = 0

    Frame.Active = true

    Frame.Draggable = true

    local corner = Instance.new("UICorner", Frame); corner.CornerRadius = UDim.new(0,12)

    local Title = Instance.new("TextLabel", Frame)

    Title.Size = UDim2.new(1, -20, 0, 40); Title.Position = UDim2.new(0,10,0,6)

    Title.Text = texts.title; Title.TextScaled = true; Title.BackgroundTransparency = 1

    -- efeito RGB no título

    local hue = 0

    local rsConn

    rsConn = RunService.RenderStepped:Connect(function()

        hue = (hue + 0.006) % 1

        Title.TextColor3 = Color3.fromHSV(hue, 1, 1)

    end)

    local KeyBox = Instance.new("TextBox", Frame)

    KeyBox.Size = UDim2.new(0.8,0,0,38); KeyBox.Position = UDim2.new(0.1,0,0.36,0)

    KeyBox.PlaceholderText = texts.placeholder; KeyBox.TextScaled = true

    KeyBox.BackgroundColor3 = Color3.fromRGB(40,40,40)

    local tbCorner = Instance.new("UICorner", KeyBox); tbCorner.CornerRadius = UDim.new(0,8)

    local Status = Instance.new("TextLabel", Frame)

    Status.Size = UDim2.new(1, -20, 0, 22); Status.Position = UDim2.new(0,10,0,210)

    Status.BackgroundTransparency = 1; Status.TextColor3 = Color3.new(1,1,1); Status.TextScaled = true

    local GetBtn = Instance.new("TextButton", Frame)

    GetBtn.Size = UDim2.new(0.42,0,0,40); GetBtn.Position = UDim2.new(0.05,0,0.68,0)

    GetBtn.Text = texts.getKey; GetBtn.TextScaled = true; GetBtn.BackgroundColor3 = Color3.fromRGB(0,150,255)

    local cGet = Instance.new("UICorner", GetBtn); cGet.CornerRadius = UDim.new(0,8)

    local CheckBtn = Instance.new("TextButton", Frame)

    CheckBtn.Size = UDim2.new(0.42,0,0,40); CheckBtn.Position = UDim2.new(0.53,0,0.68,0)

    CheckBtn.Text = texts.checkKey; CheckBtn.TextScaled = true; CheckBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)

    local cChk = Instance.new("UICorner", CheckBtn); cChk.CornerRadius = UDim.new(0,8)

    -- carrega estado atualizado

    data = LoadData()

    -- FUNÇÃO GET KEY: escolhe link que não foi usado ainda (do ciclo). se todos usados -> reset.

    GetBtn.MouseButton1Click:Connect(function()

        local available = {}

        for i,link in ipairs(Links) do

            if not data.UsedLinks[i] then

                table.insert(available, {link = link, index = i})

            end

        end

        if #available == 0 then

            -- todos usados, reset para permitir reutilização

            data.UsedLinks = {}

            SaveData(data)

            available = {}

            for i,link in ipairs(Links) do table.insert(available, {link = link, index = i}) end

        end

        local chosen = available[math.random(1, #available)]

        -- tenta copiar para clipboard

        pcall(function() setclipboard(chosen.link) end)

        data.LastLinkIndex = chosen.index

        data.UsedLinks[chosen.index] = true

        SaveData(data)

        Status.Text = texts.linkCopied

        Notify(texts.title, texts.linkCopied, 4)

    end)

    -- FUNÇÃO PARA CARREGAR O SCRIPT DO JOGO DEPENDENDO DO JOGO DETECTADO

    local function LoadGameScript()

        local gameName = CheckGame() -- vai kickar se não suportado

        if not gameName then return end

        if gameName == "Blox Fruits" then

            Notify(texts.title, (Texts[lang].loading or "Loading...").." Blox Fruits", 4)

            -- Blox Fruits script (pastebin raw)

            pcall(function()

                loadstring(game:HttpGet("https://pastebin.com/raw/GNGx7a9w"))()

            end)

        elseif gameName == "99 Noites na Floresta" then

            Notify(texts.title, (Texts[lang].loading or "Loading...").." 99 Noites", 4)

            pcall(function()

                loadstring(game:HttpGet("https://pastefy.app/TIYYwr88/raw"))()

            end)

        end

    end

    -- CHECAR KEY (ao clicar)

    CheckBtn.MouseButton1Click:Connect(function()

        local key = tostring(KeyBox.Text or ""):gsub("^%s*(.-)%s*$","%1") -- trim

        if key == "" then

            Status.Text = texts.statusEmpty

            Notify(texts.title, texts.statusEmpty, 4)

            return

        end

        -- atualiza data (recarrega)

        data = LoadData()

        -- se key já usada (globalmente) -> recusa

        if indexOf(data.UsedKeys, key) then

            Status.Text = texts.statusUsed

            Notify(texts.title, texts.statusUsed, 4)

            return

        end

        -- valida contra lista autorizada

        local keyIndex = indexOf(ValidKeys, key)

        if not keyIndex then

            Status.Text = texts.statusInvalid

            Notify(texts.title, texts.statusInvalid, 4)

            return

        end

        -- aceita key: grava CurrentKey e ExpireAt (usando os.time() para persistência)

        data.CurrentKey = key

        data.ExpireAt = os.time() + ExpireTime

        data.UsedKeys = data.UsedKeys or {}

        table.insert(data.UsedKeys, key) -- marca essa key como usada

        -- note: UsedLinks mantém links usados no ciclo; não limpamos aqui

        -- salva idioma selecionado também

        data.SelectedLanguage = SelectedLanguage or data.SelectedLanguage or "Português"

        SaveData(data)

        Status.Text = texts.statusAccepted

        Notify(texts.title, texts.statusAccepted, 4)

        -- fecha interface

        ScreenGui:Destroy()

        if rsConn then rsConn:Disconnect() end

        -- inicia monitor de expiração (em background)

        spawn(function()

            while true do

                task.wait(5)

                local d = LoadData()

                if not d or not d.ExpireAt then break end

                if os.time() >= d.ExpireAt then

                    -- expirada: limpa current key e reset de UsedLinks (assim usuário pode pegar links novamente)

                    d.CurrentKey = nil

                    d.ExpireAt = nil

                    d.UsedLinks = {} -- reset links after key expires

                    SaveData(d)

                    -- mostra interface expirada

                    -- ExpiredInterface será definida logo abaixo; chamamos com textos corretos

                    if typeof(ExpiredInterface) == "function" then

                        ExpiredInterface()

                    else

                        Notify(texts.title, texts.expiredMsg, 6)

                    end

                    break

                end

            end

        end)

        -- carrega o script do jogo

        LoadGameScript()

    end)

    -- se já tem Key válida salva ao abrir a interface, pula direto para carregar o script

    local existing = data

    if existing.CurrentKey and existing.ExpireAt and os.time() < existing.ExpireAt then

        -- usa idioma salvo (se houver)

        SelectedLanguage = data.SelectedLanguage or SelectedLanguage

        -- fechar gui e carregar

        if ScreenGui and ScreenGui.Parent then ScreenGui:Destroy() end

        if rsConn then rsConn:Disconnect() end

        LoadGameScript()

    end

end

-- INTERFACE EXPIRED (aparece quando a Key realmente expira)

function ExpiredInterface()

    local texts, lang = getTexts()

    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

    ScreenGui.Name = "WZN_KeyExpired"

    local Frame = Instance.new("Frame", ScreenGui)

    Frame.Size = UDim2.new(0, 460, 0, 200)

    Frame.Position = UDim2.new(0.5, -230, 0.5, -100)

    Frame.BackgroundColor3 = Color3.fromRGB(24,24,24)

    local c = Instance.new("UICorner", Frame); c.CornerRadius = UDim.new(0,12)

    local Title = Instance.new("TextLabel", Frame)

    Title.Size = UDim2.new(1, -20, 0, 38); Title.Position = UDim2.new(0,10,0,6)

    Title.Text = texts.title; Title.TextScaled = true; Title.BackgroundTransparency = 1

    local hue = 0

    local rconn = RunService.RenderStepped:Connect(function()

        hue = (hue + 0.006) % 1

        Title.TextColor3 = Color3.fromHSV(hue,1,1)

    end)

    local Msg = Instance.new("TextLabel", Frame)

    Msg.Size = UDim2.new(0.9,0,0,80); Msg.Position = UDim2.new(0.05,0,0.25,0)
    Msg.Text = texts.expiredMsg; Msg.TextScaled = true; Msg.BackgroundTransparency = 1; Msg.TextWrapped = true

    local BackBtn = Instance.new("TextButton", Frame)
    BackBtn.Size = UDim2.new(0.5,0,0,40); BackBtn.Position = UDim2.new(0.25,0,0.8,0)
    BackBtn.Text = "Exit"; BackBtn.TextScaled = true; BackBtn.BackgroundColor3 = Color3.fromRGB(0,150,255)
    local cb = Instance.new("UICorner", BackBtn); cb.CornerRadius = UDim.new(0,8)

    BackBtn.MouseButton1Click:Connect(function()
        if rconn then rconn:Disconnect() end
        ScreenGui:Destroy()
        CreateKeyInterface()
    end)
end

-- START: se o usuário já tiver key válida e idioma salvo, carrega script; senão abre seleção de idioma
do
    local data = LoadData()
    if data and data.CurrentKey and data.ExpireAt and os.time() < data.ExpireAt then
        -- existe key válida
        SelectedLanguage = data.SelectedLanguage or SelectedLanguage
        -- carrega script diretamente (vai checar jogo)
        -- espera 1s só pra garantir notificação apareça
        Notify("WZN MODZ", "Verificando Key...", 2)
        task.wait(1)
        -- LoadGameScript defined above inside CreateKeyInterface closure; call CheckGame+loader directly:
        local gameName = CheckGame()
        if gameName == "Blox Fruits" then
            pcall(function() loadstring(game:HttpGet("https://pastebin.com/raw/GNGx7a9w"))() end)
        elseif gameName == "99 Noites na Floresta" then
            pcall(function() loadstring(game:HttpGet("https://pastefy.app/rDobKMFh/raw"))() end)
        end
    else
        -- não tem key válida: abre seleção de idioma (ela chama CreateKeyInterface depois)
        -- give tiny delay to ensure Parts pasted fully
        task.wait(0.1)
        if typeof(LanguageSelection) == "function" then
            LanguageSelection()
        else
            Notify("WZN MODZ", "Erro: LanguageSelection não encontrada.", 5)
        end
    end
end
