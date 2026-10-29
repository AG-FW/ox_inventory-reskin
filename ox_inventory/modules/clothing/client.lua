--[[
    Clothing module for ox_inventory (glass UI).

    Lets players toggle individual pieces of clothing and save/wear outfits from the
    inventory screen. Works on top of any appearance script (illenium-appearance,
    fivem-appearance, etc.) because it only uses ped natives on freemode peds.

    - Toggling a piece off remembers exactly what was worn and puts it back on.
    - Outfits are stored per character (client KVP) and capture removed pieces as worn.
    - Command:  /wear <hat|glasses|ears|mask|top|vest|pants|shoes|bag|chain|watch|bracelet>
    - Export:   exports.ox_inventory:toggleClothing('hat')
]]

if not lib then return end

local Config = {
    animations = true,   -- play a short clothing animation when toggling
    maxOutfits = 6,      -- saved outfits per character

    -- inventory items counted for the cash / dirty money pills in the header
    cashItems  = { 'money', 'cash' },
    dirtyItems = { 'black_money' },

    -- Drawable id that means "nothing worn" for each freemode model.
    -- Change these if your clothing pack uses different blank/underwear drawables.
    blank = {
        [`mp_m_freemode_01`] = { [1] = 0, [3] = 15, [4] = 61, [5] = 0, [6] = 34, [7] = 0, [8] = 15, [9] = 0, [11] = 15 },
        [`mp_f_freemode_01`] = { [1] = 0, [3] = 15, [4] = 15, [5] = 0, [6] = 35, [7] = 0, [8] = 15, [9] = 0, [11] = 15 },
    },
}

---@class ClothingSlot
---@field id string
---@field label string
---@field prop? integer       ped prop index (hat, glasses, ...)
---@field comps? integer[]    ped components removed/restored together
---@field check? integer[]    components that decide whether the slot counts as "worn"

---@type ClothingSlot[]
local SLOTS = {
    { id = 'hat',      label = 'Hat',      prop = 0 },
    { id = 'glasses',  label = 'Glasses',  prop = 1 },
    { id = 'ears',     label = 'Earrings', prop = 2 },
    { id = 'mask',     label = 'Mask',     comps = { 1 },        check = { 1 } },
    { id = 'top',      label = 'Top',      comps = { 11, 8, 3 }, check = { 11, 8 } },
    { id = 'vest',     label = 'Vest',     comps = { 9 },        check = { 9 } },
    { id = 'pants',    label = 'Pants',    comps = { 4 },        check = { 4 } },
    { id = 'shoes',    label = 'Shoes',    comps = { 6 },        check = { 6 } },
    { id = 'bag',      label = 'Bag',      comps = { 5 },        check = { 5 } },
    { id = 'chain',    label = 'Chain',    comps = { 7 },        check = { 7 } },
    { id = 'watch',    label = 'Watch',    prop = 6 },
    { id = 'bracelet', label = 'Bracelet', prop = 7 },
}

local SLOT_BY_ID = {}
local SLOT_IDS = {}
for i = 1, #SLOTS do
    SLOT_BY_ID[SLOTS[i].id] = SLOTS[i]
    SLOT_IDS[i] = SLOTS[i].id
end

local ANIMS = {
    hat     = { 'missheist_agency2ahelmet', 'take_off_helmet_stand' },
    glasses = { 'clothingspecs', 'take_off' },
    mask    = { 'mp_masks@standard_car@ds@', 'put_on_mask' },
    pants   = { 'clothingtrousers', 'try_trousers_neutral_a' },
    shoes   = { 'clothingshoes', 'try_shoes_positive_a' },
    default = { 'clothingtie', 'try_tie_neutral_a' },
}

local SNAP_COMPS = { 1, 3, 4, 5, 6, 7, 8, 9, 10, 11 }
local SNAP_PROPS = { 0, 1, 2, 6, 7 }

---------------------------------------------------------------------------------------------------
-- helpers
---------------------------------------------------------------------------------------------------

--- What was taken off, so it can be put back exactly as it was. Reset when the character changes.
---@type table<string, { index?: integer, prop?: integer[], comps?: table<integer, integer[]> }>
local stored = {}
local storedFor

local function identity()
    local id = PlayerData and PlayerData.identifier or 'default'

    if storedFor ~= id then
        stored = {}
        storedFor = id
    end

    return id
end

local function getBlank(ped)
    return Config.blank[GetEntityModel(ped)]
end

local function isWorn(ped, slot, blank)
    if slot.prop then
        return GetPedPropIndex(ped, slot.prop) ~= -1
    end

    for i = 1, #slot.check do
        local comp = slot.check[i]

        if GetPedDrawableVariation(ped, comp) ~= (blank[comp] or 0) then
            return true
        end
    end

    return false
end

local function countItems(names)
    local total = 0

    for _, item in pairs(PlayerData and PlayerData.inventory or {}) do
        for i = 1, #names do
            if item.name == names[i] then
                total += item.count or 0
                break
            end
        end
    end

    return total
end

local function playAnim(ped, slot)
    if not Config.animations or cache.vehicle or IsPedCuffed(ped) then return end

    local anim = ANIMS[slot.id] or ANIMS.default

    CreateThread(function()
        if not pcall(lib.requestAnimDict, anim[1], 1000) then return end

        TaskPlayAnim(ped, anim[1], anim[2], 4.0, 4.0, 1200, 48, 0.0, false, false, false)
        SetTimeout(1400, function() RemoveAnimDict(anim[1]) end)
    end)
end

---------------------------------------------------------------------------------------------------
-- toggling
---------------------------------------------------------------------------------------------------

local function removeSlot(ped, slot, blank)
    local snap = {}

    if slot.prop then
        snap.index = slot.prop
        snap.prop = { GetPedPropIndex(ped, slot.prop), GetPedPropTextureIndex(ped, slot.prop) }
        ClearPedProp(ped, slot.prop)
    else
        snap.comps = {}

        for i = 1, #slot.comps do
            local comp = slot.comps[i]

            snap.comps[comp] = {
                GetPedDrawableVariation(ped, comp),
                GetPedTextureVariation(ped, comp),
                GetPedPaletteVariation(ped, comp),
            }

            SetPedComponentVariation(ped, comp, blank[comp] or 0, 0, 0)
        end
    end

    stored[slot.id] = snap
end

local function restoreSlot(ped, slot)
    local snap = stored[slot.id]

    if not snap then return false end

    if snap.prop then
        SetPedPropIndex(ped, slot.prop, snap.prop[1], snap.prop[2], true)
    else
        for comp, v in pairs(snap.comps) do
            SetPedComponentVariation(ped, comp, v[1], v[2], v[3] or 0)
        end
    end

    stored[slot.id] = nil

    return true
end

---@return boolean success
---@return string message
local function canChange(ped)
    if IsEntityDead(ped) or IsPedCuffed(ped) then
        return false, 'You can\'t do that right now.'
    end

    if not getBlank(ped) then
        return false, 'This character model isn\'t supported.'
    end

    return true, ''
end

---@param id string
---@return boolean success
---@return string message
local function toggle(id)
    identity()

    local ped = cache.ped
    local ok, err = canChange(ped)

    if not ok then return false, err end

    local slot = SLOT_BY_ID[id]

    if not slot then return false, 'Unknown clothing slot.' end

    local blank = getBlank(ped)

    if isWorn(ped, slot, blank) then
        removeSlot(ped, slot, blank)
        playAnim(ped, slot)

        return true, ('%s off'):format(slot.label)
    end

    if restoreSlot(ped, slot) then
        playAnim(ped, slot)

        return true, ('%s on'):format(slot.label)
    end

    return false, ('You have no %s to put on.'):format(slot.label:lower())
end

---@return boolean success
---@return string message
local function toggleAll()
    identity()

    local ped = cache.ped
    local ok, err = canChange(ped)

    if not ok then return false, err end

    local blank = getBlank(ped)
    local anyWorn = false

    for i = 1, #SLOTS do
        if isWorn(ped, SLOTS[i], blank) then
            anyWorn = true
            break
        end
    end

    if anyWorn then
        for i = 1, #SLOTS do
            local slot = SLOTS[i]

            if isWorn(ped, slot, blank) then
                removeSlot(ped, slot, blank)
            end
        end

        playAnim(ped, SLOT_BY_ID.top)

        return true, 'Everything off'
    end

    local restored = false

    for i = 1, #SLOTS do
        restored = restoreSlot(ped, SLOTS[i]) or restored
    end

    if not restored then return false, 'Nothing to put back on.' end

    playAnim(ped, SLOT_BY_ID.top)

    return true, 'Everything back on'
end

---------------------------------------------------------------------------------------------------
-- outfits
---------------------------------------------------------------------------------------------------

local function kvpKey()
    return ('ox_inventory:outfits:%s'):format(identity())
end

local function loadOutfits()
    local raw = GetResourceKvpString(kvpKey())
    local list = raw and json.decode(raw)

    return type(list) == 'table' and list or {}
end

local function saveOutfits(list)
    SetResourceKvp(kvpKey(), json.encode(list))
end

--- Current appearance, counting anything that is currently taken off as worn.
local function snapshot(ped)
    local out = { model = GetEntityModel(ped), comps = {}, props = {} }

    for i = 1, #SNAP_COMPS do
        local comp = SNAP_COMPS[i]

        out.comps[tostring(comp)] = {
            GetPedDrawableVariation(ped, comp),
            GetPedTextureVariation(ped, comp),
            GetPedPaletteVariation(ped, comp),
        }
    end

    for i = 1, #SNAP_PROPS do
        local prop = SNAP_PROPS[i]

        out.props[tostring(prop)] = { GetPedPropIndex(ped, prop), GetPedPropTextureIndex(ped, prop) }
    end

    for _, snap in pairs(stored) do
        if snap.comps then
            for comp, v in pairs(snap.comps) do
                out.comps[tostring(comp)] = v
            end
        elseif snap.prop then
            out.props[tostring(snap.index)] = snap.prop
        end
    end

    return out
end

local function applyOutfit(ped, outfit)
    for key, v in pairs(outfit.comps or {}) do
        SetPedComponentVariation(ped, tonumber(key) --[[@as integer]], v[1], v[2], v[3] or 0)
    end

    for key, v in pairs(outfit.props or {}) do
        local prop = tonumber(key) --[[@as integer]]

        if v[1] == -1 then
            ClearPedProp(ped, prop)
        else
            SetPedPropIndex(ped, prop, v[1], v[2], true)
        end
    end

    stored = {}
end

---------------------------------------------------------------------------------------------------
-- NUI
---------------------------------------------------------------------------------------------------

local function buildState()
    identity()

    local ped = cache.ped
    local blank = getBlank(ped)

    local state = {
        supported = blank ~= nil,
        slots = {},
        outfits = {},
        maxOutfits = Config.maxOutfits,
        cash = countItems(Config.cashItems),
        dirty = countItems(Config.dirtyItems),
    }

    if blank then
        for i = 1, #SLOTS do
            local slot = SLOTS[i]

            state.slots[i] = {
                id = slot.id,
                label = slot.label,
                worn = isWorn(ped, slot, blank),
                stored = stored[slot.id] ~= nil,
            }
        end
    end

    local outfits = loadOutfits()

    for i = 1, #outfits do
        state.outfits[i] = { name = outfits[i].name }
    end

    return state
end

local function reply(cb, ok, msg)
    local state = buildState()

    state.ok = ok
    state.msg = msg

    cb(state)
end

RegisterNUICallback('glass:state', function(_, cb)
    cb(buildState())
end)

RegisterNUICallback('glass:toggle', function(data, cb)
    reply(cb, toggle(data and data.id))
end)

RegisterNUICallback('glass:all', function(_, cb)
    reply(cb, toggleAll())
end)

RegisterNUICallback('glass:save', function(data, cb)
    local ped = cache.ped
    local ok, err = canChange(ped)

    if not ok then return reply(cb, false, err) end

    local outfits = loadOutfits()

    if #outfits >= Config.maxOutfits then
        return reply(cb, false, 'All outfit slots are used.')
    end

    local name = type(data) == 'table' and type(data.name) == 'string' and data.name or ''
    name = (name:gsub('^%s+', ''):gsub('%s+$', '')):sub(1, 24)

    if name == '' then name = ('Outfit %d'):format(#outfits + 1) end

    local outfit = snapshot(ped)
    outfit.name = name
    outfits[#outfits + 1] = outfit
    saveOutfits(outfits)

    reply(cb, true, ('Saved "%s"'):format(name))
end)

RegisterNUICallback('glass:wear', function(data, cb)
    local ped = cache.ped
    local ok, err = canChange(ped)

    if not ok then return reply(cb, false, err) end

    local outfit = loadOutfits()[data and tonumber(data.index) or 0]

    if not outfit then return reply(cb, false, 'Outfit not found.') end

    if outfit.model ~= GetEntityModel(ped) then
        return reply(cb, false, 'This outfit was saved on a different character model.')
    end

    applyOutfit(ped, outfit)
    playAnim(ped, SLOT_BY_ID.top)

    reply(cb, true, ('Wearing "%s"'):format(outfit.name))
end)

RegisterNUICallback('glass:delete', function(data, cb)
    local outfits = loadOutfits()
    local index = data and tonumber(data.index) or 0
    local outfit = outfits[index]

    if not outfit then return reply(cb, false, 'Outfit not found.') end

    table.remove(outfits, index)
    saveOutfits(outfits)

    reply(cb, true, ('Deleted "%s"'):format(outfit.name))
end)

---------------------------------------------------------------------------------------------------
-- command & export
---------------------------------------------------------------------------------------------------

exports('toggleClothing', toggle)

RegisterCommand('wear', function(_, args)
    local id = args[1] and args[1]:lower()

    if not id or not SLOT_BY_ID[id] then
        return lib.notify({ type = 'inform', description = ('Usage: /wear [%s]'):format(table.concat(SLOT_IDS, ' | ')) })
    end

    local ok, msg = toggle(id)

    lib.notify({ type = ok and 'success' or 'error', description = msg })
end, false)

TriggerEvent('chat:addSuggestion', '/wear', 'Toggle a piece of clothing', {
    { name = 'slot', help = table.concat(SLOT_IDS, ', ') },
})
