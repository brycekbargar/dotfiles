isCtrlChord = false
lastFlags = {}

log = hs.logger.new("Dotfiles", "debug")

numberRow = {["1"]=true,["2"]=true,["3"]=true,["4"]=true,["5"]=true,["6"]=true,["7"]=true,["8"]=true,["9"]=true,["0"]=true}
numpad = {
  ["7"]="pad7",["8"]="pad8",["9"]="pad9",
  ["l"]="pad4",["u"]="pad5",["y"]="pad6",
  ["n"]="pad1",["e"]="pad2",["i"]="pad3",
  ["k"]="pad0"
}
eventtap = function(event)
  if hs.keycodes.currentLayout() ~= "Colemak" then
    log.i("not Colemak. behave like normal", eventType)
    return false
  end

  local eventType = event:getType()
  log.i("eventType", eventType) 

  if eventType == hs.eventtap.event.types.keyDown then
    local keyCode = hs.keycodes.map[event:getKeyCode()]
    log.i("keyCode", keyCode)

    if keyCode == "escape" then
      log.i("escape pressed")
      return false
    end

    if lastFlags["ctrl"] then
      isCtrlChord = true

      log.i("chord. Parse the numpad")
      if numpad[keyCode] then
        log.i("in numpad. send numkey")
        hs.eventtap.keyStroke({}, numpad[keyCode])
	return true
      end

      return false
    end

    log.i("no chord. Parse the numberrow -> symbols")
    if not event:getFlags()["shift"] and numberRow[keyCode] then
      log.i("on numberrow. send symbol")
      hs.eventtap.keyStroke({"shift"}, keyCode)
      return true
    end

    return false
  end

  if eventType == hs.eventtap.event.types.flagsChanged then
    local newFlags = event:getFlags()
    local lastFlagsHasCtrl = lastFlags["ctrl"]
    local newFlagsHasCtrl = newFlags["ctrl"]
    lastFlags = newFlags

    log.i("lastFlagsHasCtrl", lastFlagsHasCtrl)
    log.i("newFlagsHasCtrl", newFlagsHasCtrl)

    if not lastFlagsHasCtrl and newFlagsHasCtrl then
      isCtrlChord = false
      log.i("ctrl pressed")
      return false
    end

    if lastFlagsHasCtrl and not newFlagsHasCtrl and isCtrlChord then
      log.i("ctrl released after chord. don't send escape")
      return false
    end

    if lastFlagsHasCtrl and not newFlagsHasCtrl and not isCtrlChord then
      log.i("ctrl released. send escape here")
      hs.eventtap.keyStroke({}, "escape")
      return true
    end

  end

  return false
end

watcher = hs.eventtap.new({hs.eventtap.event.types.flagsChanged, hs.eventtap.event.types.keyDown}, eventtap)

watcher:start()
