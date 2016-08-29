-- This is the example code file for the webpage at:
--
-- www.hempeldesigngroup.com/lego/pbLua/tutorial/pbLuaSensors.html

--codeExampleStart 1 -----------------------------------------------------------
-- Read touch sensor until the orange button is pressed
function TouchRead(port)

  nxt.InputSetType(port,1)

  repeat
    print( nxt.TimerRead(), nxt.InputGetStatus(port) )
  until( 8 == nxt.ButtonRead() )
end

-- And using the function - press the orange button on the NXT to stop it
TouchRead(1)
--codeExampleEnd 1

--codeExampleStart 1a -----------------------------------------------------------
-- Read touch sensor in boolean mode until the orange button is pressed
function TouchRead(port)

  nxt.InputSetType(port,1,0x20)

  repeat
    print( nxt.TimerRead(), nxt.InputGetStatus(port) )
  until( 8 == nxt.ButtonRead() )
end

-- And using the function - press the orange button on the NXT to stop it
TouchRead(1)
--codeExampleEnd 1a

--codeExampleStart 1b -----------------------------------------------------------
-- Read touch sensor in transition count mode until the orange button is pressed
function TouchRead(port)

  nxt.InputSetType(port,1,0x40)

  repeat
    print( nxt.TimerRead(), nxt.InputGetStatus(port) )
  until( 8 == nxt.ButtonRead() )
end

-- And using the function - press the orange button on the NXT to stop it
TouchRead(1)
--codeExampleEnd 1b

--codeExampleStart 1c -----------------------------------------------------------
-- Read touch sensor in period count mode until the orange button is pressed
function TouchRead(port)

  nxt.InputSetType(port,1,0x60)

  repeat
    print( nxt.TimerRead(), nxt.InputGetStatus(port) )
  until( 8 == nxt.ButtonRead() )
end

-- And using the function - press the orange button on the NXT to stop it
TouchRead(1)
--codeExampleEnd 1c


--codeExampleStart 2 -----------------------------------------------------------
-- Read touch sensor until the orange button is pressed - note that it's a
-- lot easier to simply read the sensor in boolean mode...

function TouchChange(port, thresh)

  nxt.InputSetType(port,0)

  local oldState,newState

  repeat
    if( thresh < nxt.InputGetStatus( port ) ) then
      newState = 0
    else
      newState = 1
    end

    if newState ~= oldState then
      print( nxt.TimerRead(), newState )
      oldState = newState
    end

  until( 8 == nxt.ButtonRead() )
end

-- And using the function - press the orange button on the NXT to stop it
TouchChange(1,500)
--codeExampleEnd 2

--codeExampleStart 3 -----------------------------------------------------------
-- Read sound sensor until the orange button is pressed
function SoundRead(port)

  nxt.InputSetType(port,0,7)

  repeat
    print( nxt.TimerRead(), nxt.InputGetStatus(port) )
  until( 8 == nxt.ButtonRead() )
end

-- And using the function - press the orange button on the NXT to stop it
SoundRead(2)
--codeExampleEnd 3

--codeExampleStart 4 -----------------------------------------------------------
-- Read sound sensor and scale the results the hard way
function SoundScale(port,sensitive)

  sensitive = sensitive or 0

  if 0 == sensitive then nxt.InputSetType(port,8)
                    else nxt.InputSetType(port,7)
  end

  repeat
    local raw = nxt.InputGetStatus(port)

    -- Check if raw value is less than minimum, adjust if needed
    if raw < 162 then raw = 0
                 else raw = raw - 162
    end

    -- Scale the result
    raw = (raw*100)/83

    -- Check if raw value is greater than maximum, adjust if needed
    if raw > 1023 then raw = 1023
    end

    -- Invert the raw value
    raw = 1023 - raw

    -- Make a string that represents the volume...

    print( nxt.TimerRead(), string.rep("*", raw/16 ) )
  until( 8 == nxt.ButtonRead() )
end

-- And using the function - press the orange button on the NXT to stop it
SoundScale(2,0)
--codeExampleEnd 4

--codeExampleStart 4a -----------------------------------------------------------
-- Read sound sensor and scale the results the easy way
function SoundScale(port,sensitive)

  sensitive = sensitive or 0

  if 0 == sensitive then nxt.InputSetType(port,8,0x80)
                    else nxt.InputSetType(port,7,0x80)
  end

  repeat
    local _,_,_,raw = nxt.InputGetStatus(port)

    print( nxt.TimerRead(), string.rep("*", raw/2) )
  until( 8 == nxt.ButtonRead() )
end

-- And using the function - press the orange button on the NXT to stop it
SoundScale(2,0)
--codeExampleEnd 4a

--codeExampleStart 5 -----------------------------------------------------------
-- Read light sensor until the orange button is pressed
function LightRead(port,active)

  active = active or 0

  if 0 == active then nxt.InputSetType(port,6,0x80)
                 else nxt.InputSetType(port,5,0x80)
  end

  repeat
    print( nxt.TimerRead(), nxt.InputGetStatus(port) )
  until( 8 == nxt.ButtonRead() )
end

-- And using the function - press the orange button on the NXT to stop it
LightRead(3,0)
--codeExampleEnd 5

--codeExampleStart 6 -----------------------------------------------------------
-- Read light sensor until the orange button is pressed
function Barcode(port,active,threshold,guard)

  nxt.InputSetType(port,0)

  active = active or 0

  if 0 == active then nxt.InputSetState(port,0,0)
                 else nxt.InputSetState(port,1,0)
  end

  nxt.InputSetDir(port,1,1)

  local oldState = 1
  local newState = 1
  local light

  repeat
    light = nxt.InputGetStatus(port)

    if light > (threshold + guard) then newState = 0 end
    if light < (threshold + guard) then newState = 1 end

    if newState ~= oldState then
      print( nxt.TimerRead(), newState )
      oldState = newState
    end

  until( 8 == nxt.ButtonRead() )
end

-- And here's how to call the function. You may need to try this
-- with different values for the threshold and guard
Barcode(3,1,700,20)
--codeExampleEnd 6

--codeExampleStart 7a -----------------------------------------------------------
-- The color sensor turns on steady red...
function RedSensor(port)

  nxt.InputSetType(port,14)

  repeat
      print( nxt.TimerRead(), nxt.InputGetStatus(port) )

  until( 8 == nxt.ButtonRead() )
end
-- And using the function - press the orange button on the NXT to stop it
RedSensor(3)
--codeExampleEnd 7a

--codeExampleStart 7b -----------------------------------------------------------
-- The color sensor turns on steady green...
function GreenSensor(port)

  nxt.InputSetType(port,15)

  repeat
      print( nxt.TimerRead(), nxt.InputGetStatus(port) )

  until( 8 == nxt.ButtonRead() )
end
-- And using the function - press the orange button on the NXT to stop it
GreenSensor(3)
--codeExampleEnd 7b

--codeExampleStart 7c -----------------------------------------------------------
-- The color sensor turns on steady blue...
function BlueSensor(port)

  nxt.InputSetType(port,16)

  repeat
      print( nxt.TimerRead(), nxt.InputGetStatus(port) )

  until( 8 == nxt.ButtonRead() )
end
-- And using the function - press the orange button on the NXT to stop it
BlueSensor(3)
--codeExampleEnd 7c

--codeExampleStart 7d -----------------------------------------------------------
-- The color sensor is an active full color device - must use pct mode
function FullSensor(port)

  nxt.InputSetType(port,13,0x80)

  repeat
      print( nxt.TimerRead(), nxt.InputGetStatus(port) )

  until( 8 == nxt.ButtonRead() )
end
-- And using the function - press the orange button on the NXT to stop it
FullSensor(3)
--codeExampleEnd 7d
--
--codeExampleStart 7e -----------------------------------------------------------
-- The color sensor is a passive light sensor - must use pct mode
function NoneSensor(port)

  nxt.InputSetType(port,17,0x80)

  repeat
      print( nxt.TimerRead(), nxt.InputGetStatus(port) )

  until( 8 == nxt.ButtonRead() )
end
-- And using the function - press the orange button on the NXT to stop it
NoneSensor(3)
--codeExampleEnd 7e
--
--codeExampleStart n -----------------------------------------------------------
--codeExampleEnd n


