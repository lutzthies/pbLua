-- This is the example code file for the webpage at:
--
-- www.hempeldesigngroup.com/lego/pbLua/tutorial/pbLuaLinearActuators.html

--codeExampleStart 2 -----------------------------------------------------------
-- Save current Motor position, turn forward while grey button is pressed,
-- then reverse to original position...

port = 1
nxt.OutputResetTacho(port,1,1,1)
nxt.OutputSetRegulation(port,1,1)

function CycleProbe( port, fwd, rev )
    -- Save the starting tacho position
	local _,startPos = nxt.OutputGetStatus(port)

	while 0 == nxt.ButtonRead() do
      -- Wait for button press
	end

	-- Start moving toward the target at half speed
    nxt.OutputSetSpeed(port,0x20,fwd)

	while 0 ~= nxt.ButtonRead() do
      -- Wait for button release
    end

	-- Brake motor now
    nxt.OutputSetSpeed(port,0x20,0)

    t = nxt.TimerRead()
    while t+400 > nxt.TimerRead() do
  	  -- Let the system settle down
    end

    -- Save the current tacho position
	local _,endPos = nxt.OutputGetStatus(port)

	print( startPos, endPos, nxt.abs(endPos-startPos) )

	-- Reverse the motor back to the starting position at full speed
    nxt.OutputSetSpeed(port,0x20,-rev,nxt.abs(endPos-startPos))

    t = nxt.TimerRead()
    while t+5000 > nxt.TimerRead() do
  	  -- Let the system settle down
    end
end
--codeExampleEnd 2


--codeExampleStart n -----------------------------------------------------------
--codeExampleEnd n


