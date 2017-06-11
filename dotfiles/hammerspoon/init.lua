-- log = hs.logger.new("Dotfiles", "debug")
handled = true
nextHandler = false

isCtrlChord = false
lastFlags = {}

numpad = {
  ["7"]="pad7",["8"]="pad8",["9"]="pad9",
  ["l"]="pad4",["u"]="pad5",["y"]="pad6",
  ["n"]="pad1",["e"]="pad2",["i"]="pad3",
  ["k"]="pad0"
}
eventtap = function(event)
  -- I use Colemak, for the rare occasions someone else needs to use
  -- my Mac I want to have it behave as close to default as possible
  -- i.e. US Keyboard and normal Ctrl/Escape/Number keys.
  if hs.keycodes.currentLayout() ~= "Colemak" then
    return nextHandler
  end
  local eventType = event:getType()
  if eventType == hs.eventtap.event.types.keyDown then
    local keyCode = hs.keycodes.map[event:getKeyCode()]
    if keyCode == "escape" then
      -- In Hammerspoon, returning false from this event continues 
      -- up the handler chain. I've "renamed" false to nextHandler so it
      -- looks kind of like connect.js
      return nextHandler
    end
    if lastFlags["ctrl"] then
      -- My ctrl key is ESC when just pressed, but it works like a 
      -- ctrl key when used as part of a key combination (chord)
      isCtrlChord = true
      -- I am superimposing a numpad over the home row by my right hand
      -- When ctrl + a "numpad" key is pressed I want a number
      if numpad[keyCode] then
        hs.eventtap.keyStroke({}, numpad[keyCode])
	-- In Hammerspoon, return true from this event stops further
	-- handling by events. I've "renamed" true to handled so it
	-- looks somewhat like winforms...
        return handled
      end
    end
  end

  if eventType == hs.eventtap.event.types.flagsChanged then
    -- We want one "clock" cycle of lookbehind for any modifier key
    -- changes, this just sets that up
    local newFlags = event:getFlags()
    local lastFlagsHasCtrl = lastFlags["ctrl"]
    local newFlagsHasCtrl = newFlags["ctrl"]
    lastFlags = newFlags
    -- Whenever we press control without it being previously pressed
    -- we're going to assume it's pressed alone and reset the
    -- variable used to track if it's been part of a chord
    if not lastFlagsHasCtrl and newFlagsHasCtrl then
      isCtrlChord = false
      return nextHandler
    end
  end

  return nextHandler
end

watcher = hs.eventtap.new({hs.eventtap.event.types.flagsChanged, hs.eventtap.event.types.keyDown}, eventtap)

watcher:start()
