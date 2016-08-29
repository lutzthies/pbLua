-- This is the example code file for the webpage at:
--
-- www.hempeldesigngroup.com/lego/pbLua/tutorial/pbLuaXmodem.html

--codeExampleStart 1 -----------------------------------------------------------
nxt.DisplayClear()
i = 0

repeat 
  s=nxt.XMODEMRecv()
  if s then
    nxt.DisplayText( string.format( "Record %i", i ) )
    i = i + 1
  end
until s == nil
--codeExampleEnd 1

--codeExampleStart 2 -----------------------------------------------------------
nxt.DisplayClear()
a={}
repeat 
  s=nxt.XMODEMRecv()
  if s then
    table.insert(a,s)
  end
until s == nil
--codeExampleEnd 2

--codeExampleStart 3 -----------------------------------------------------------
for _,s in ipairs(a) do
  nxt.FileWrite(0,s)
end
--codeExampleEnd 3

----codeExampleStart 4 -----------------------------------------------------------
p = ""
i = 0
repeat
  s = nxt.XMODEMSend(p)
  if( s ) then
    if i == 256 then
      p = nil
    else
      p = string.rep( string.char(i), 128 )
      i = i + 1
    end
  end
until s == nil
--codeExampleEnd 4

--codeExampleStart 5 -----------------------------------------------------------
p = ""
addr = 0x100000

repeat
  local s = nxt.XMODEMSend(p)
  
  if( s ) then
    if addr >= 0x140000 then
      p = nil
    else
      p = nxt.MemRead(addr,128)
      addr = addr + 128
    end
  end

until s == nil
--codeExampleEnd 5

--codeExampleStart 6 -----------------------------------------------------------
-- Function to set up the light sensor and then start transferring data
-- to the host as quickly as possible. Call the function, then start the
-- XMOPDEM transfer on the host, and then press the orange button to
-- start the sampling...

function LogLight( port )
-- Set up the light sensor on port 1 for passive mode

  nxt.InputSetType(port,0)
  nxt.InputSetState(port,0,0)
  nxt.InputSetDir(port,1,1)

  repeat
    -- Wait here until the orange button is pressed
  until( 8 == nxt.ButtonRead() )

  local startTicks = nxt.TimerRead()
  local sampleTick = startTicks
  local p = ""
  local d = ""
  local s = true

  repeat
    local nowTicks = nxt.TimerRead()

    -- Grab a light sensor sample and add it to our string if
    -- at least 3 milliseconds have passed and we're still sending

    if (sampleTick + 3 <= nowTicks) and (p ~= nil) then
      d = d .. string.format( "%06i %06i\r\n", nowTicks, nxt.InputGetStatus(port) )
      sampleTick = nowTicks
    end

    -- Only try sending if we have more than 128 bytes to send

    if string.len(d) > 128 then
      s = nxt.XMODEMSend(p)
  
      if( s ) then
        if startTicks + 10000 < nowTicks then
          p = nil
        else
          p = string.sub(d,1,128)
          d = string.sub(d,129)
          print(p)
        end
      end
    end
  until s == nil
end
--codeExampleEnd 6

--codeExampleStart 7 -----------------------------------------------------------
-- Start the high-speed datalogger

LogLight(1)
--codeExampleEnd 7

--codeExampleStart 7r -----------------------------------------------------------
119345 000623
119348 000619
119351 000621
119354 000623
119357 000619
119360 000623
119363 000622
119366 000622
119369 000623
119372 000623
119375 000619
119378 000619
--codeExampleEnd 7r

--codeExampleStart n -----------------------------------------------------------
--codeExampleEnd n

