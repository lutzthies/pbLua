-- This is the example code file for the webpage at:
--
-- www.hempeldesigngroup.com/lego/pbLua/tutorial/pbLuaDatalog.html

--codeExampleStart 1 -----------------------------------------------------------
-- Read gyro sensor until the orange button is pressed
function GyroRead(port)

  -- Set up the gyro sensor with low sensitivity
  nxt.InputSetType(port,0)
  nxt.InputSetState(port,0,0)
  nxt.InputSetDir(port,1,1)

  -- Now start reading the sensor and putting out data
  repeat
    print( nxt.TimerRead(), nxt.InputGetStatus(port) )
  until( 8 == nxt.ButtonRead() )
end

-- And using the function - press the orange button on the NXT to stop it
GyroRead(1)
--codeExampleEnd 1

--codeExampleStart 1r -----------------------------------------------------------
52017   617     0       0
52019   615     0       0
52021   617     0       0
52023   616     0       0
52025   616     0       0
52027   617     0       0
52029   616     0       0
--codeExampleEnd 1r

--codeExampleStart 2 -----------------------------------------------------------
-- Lots of tricks in this function, note the concatenation operator ".." and
-- that the last two results from nxt.InputGetStatus() are simply discarded!

function sampleString(port)
  return nxt.istr(nxt.TimerRead()) .. nxt.istr(nxt.InputGetStatus(port)) 
end
--codeExampleEnd 2

--codeExampleStart 2s -----------------------------------------------------------
-- Let's do a few examples first...
=string.byte(nxt.istr(0),1,4)
=string.byte(nxt.istr(255),1,4)
=string.byte(nxt.istr(65535),1,4)
=string.byte(nxt.istr(-1),1,4)

-- And now use the function to generate the string...
port = 1
s = sampleString(port)

-- And dump the results. Can you figure out what the values were?
=string.byte(s,1,8)

-- It's easy if you do this...

-- The timestamp is the first 4 bytes (1 to 4)
=nxt.stri(string.sub(s,1,4))

-- The value is the second 4 bytes (5 to 8) 
=nxt.stri(string.sub(s,5,8))
--codeExampleEnd 2s

--codeExampleStart 2r -----------------------------------------------------------
-- Let's do a few examples first...
> =string.byte(nxt.istr(0),1,4)
0       0       0       0

> =string.byte(nxt.istr(255),1,4)
255     0       0       0

> =string.byte(nxt.istr(65535),1,4)
255     255     0       0

> =string.byte(nxt.istr(-1),1,4)
255     255     255     255

-- And now use the function to generate the string...
> port = 1
> s = sampleString(port)

-- And dump the results. Can you figure out what the values were?
> =string.byte(s,1,8)
148     26      10      0       106     2       0       0

-- It's easy if you do this...

> -- The timestamp is the first 4 bytes (1 to 4)
> =nxt.stri(string.sub(s,1,4))
662164

-- The value is the second 4 bytes (5 to 8) 
> =nxt.stri(string.sub(s,5,8))
618
--codeExampleEnd 2r

--codeExampleStart 3 -----------------------------------------------------------
-- Function to save 100 timestamped samples to a file as quickly as
-- possible

function save100 (port)
  -- Set up the gyro sensor with low sensitivity
  nxt.InputSetType(port,0)
  nxt.InputSetState(port,0,0)
  nxt.InputSetDir(port,1,1)
  
  -- Create an 800 byte file, save the handle
  local file = nxt.FileCreate("sampleFile", 800)
  
  -- And now read and save 100 individual samples and timestamps
  for i=1,100 do
    nxt.FileWrite( file, nxt.istr(nxt.TimerRead()) .. nxt.istr(nxt.InputGetStatus(port)) )
  end
  
  -- And close the file
  nxt.FileClose(file)
end

-- And run the function on port 1 to try it out...
save100(1)
--codeExampleEnd 3

--codeExampleStart 4 -----------------------------------------------------------
-- Function to dump timestamped samples from a file

function DataDumper()
  -- Open the file
  file = nxt.FileOpen( "sampleFile" )
 
  -- And now read individual samples and timestamps 8 bytes
  -- at a time until there are no more
  repeat
	local s = nxt.FileRead( file, 8 )
	
	if s then
	  local t = nxt.stri(string.sub(s,1,4))
	  local v = nxt.stri(string.sub(s,5,8))
	  print( string.format( "T:%08i V:%04i", t, v  ) )
	end
  until nil == s
  
  -- And close the file
  nxt.FileClose(file)
end

-- And run the function to see how fast the writing went...
DataDumper()

T:00950217 V:0617
T:00950221 V:0616
T:00950224 V:0619
    ...
T:00950574 V:0616
T:00950578 V:0615
T:00950581 V:0618

-- Yep, that's 100 samples written in 364 msec!
--codeExampleEnd 4

--codeExampleStart 5 -----------------------------------------------------------
-- Complete data logger example
s = [[
function DataLogger ()
  -- Set up the gyro sensor on port 1 with low sensitivity
  nxt.InputSetType(1,0)
  nxt.InputSetState(1,0,0)
  nxt.InputSetDir(1,1,1)

  -- Check to see if the file exists, and if so, erase it...
  if nxt.FileExists("sampleFile") then
    nxt.FileDelete("sampleFile")
  end
  
  -- Create an 8000 byte file, save the handle
  local file = nxt.FileCreate("sampleFile", 8000)
  
  -- Clear the display
  nxt.DisplayClear()

  -- And now read and save up to 100 individual samples and timestamps
  for i=1,1000 do
    nxt.FileWrite( file, nxt.istr(nxt.TimerRead()) .. nxt.istr(nxt.InputGetStatus(1)) )

    -- Update the LCD so we can see what's going on...
    
    nxt.DisplayText( i )

    -- break out of the loop if the user hits the orange button
    if 8 == nxt.ButtonRead() then
      break
    end
  end
  
  -- And close the file
  nxt.FileClose(file)

  -- And turn off the NXT
  nxt.PowerDown()
end

-- Don't forget tot execute it :-)
DataLogger()
]]
--codeExampleEnd 5

--codeExampleStart 6 -----------------------------------------------------------
> =string.len(s)
970
--codeExampleEnd 6

--codeExampleStart 7 -----------------------------------------------------------
> f=nxt.FileCreate("pbLuaStartup", 1024)
> nxt.FileWrite(f,s)
> nxt.FileClose(f)
--codeExampleEnd 7

--codeExampleStart n -----------------------------------------------------------
--codeExampleEnd n


