-- This is the example code file for the webpage at:
--
-- www.hempeldesigngroup.com/lego/pbLua/tutorial/pbLuaAdvancedMotors.html

--codeExampleStart 1 -----------------------------------------------------------
-- Read tachos until the orange button is pressed
function TachoRead(port)

  repeat
    if 4 == nxt.ButtonRead() then
      nxt.OutputResetTacho(port,1,0,0)
    elseif 2 == nxt.ButtonRead() then
      nxt.OutputResetTacho(port,0,0,1)
    elseif 1 == nxt.ButtonRead() then
      nxt.OutputResetTacho(port,0,1,0)
    end

    print( nxt.TimerRead(), nxt.OutputGetStatus(port) )

    t = nxt.TimerRead()
    while t+100 > nxt.TimerRead() do
      -- nothing
    end
  until( 8 == nxt.ButtonRead() )
end

-- And using the function with a motor plugged into port A...
TachoRead(1)
--codeExampleEnd 1

--codeExampleStart 2 -----------------------------------------------------------
-- Turn Motor 1 exactly 180 degrees at half speed
port = 1
nxt.OutputSetRegulation(port,1,1)
nxt.OutputSetSpeed(port,0x20,50,180)
--codeExampleEnd 2

--codeExampleStart 3 -----------------------------------------------------------
-- Turn Motor 1 exactly 180 degrees - and wait until done
port = 1
function move(degrees)
  nxt.OutputSetRegulation(port,1,1)

  _,tacho = nxt.OutputGetStatus(port)
  nxt.OutputSetSpeed(port,0x20,nxt.sign(degrees)*50,nxt.abs(degrees))

  repeat
    _,curtacho = nxt.OutputGetStatus(port)
  until 4 > nxt.abs( curtacho - (tacho + degrees) )
end
--codeExampleEnd 3

--codeExampleStart n -----------------------------------------------------------
--codeExampleEnd n


