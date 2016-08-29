-- This is the example code file for the webpage at:
--
-- www.hempeldesigngroup.com/lego/pbLua/tutorial/pbLuaBlueToothRemote.html

--codeExampleStart 1 -----------------------------------------------------------
-- Turn the Bluetooth radio on:
nxt.BtPower(1)
--codeExampleEnd 1

--codeExampleStart 1a -----------------------------------------------------------
-- make the NXT visible for Bluetooth searches:
nxt.BtVisible(1)
--codeExampleEnd 1a
--
--codeExampleStart 2 -----------------------------------------------------------
-- Reset the Bluetooth subsystem to factory defaults. Note theat this does
-- not reset the firmware, just the device tables. 
nxt.BtFactoryReset()
--codeExampleEnd 2

--codeExampleStart 3 -----------------------------------------------------------
-- Change the name of the NXT
nxt.BtSetName("LEFTY")
--codeExampleEnd 3

--codeExampleStart 4 -----------------------------------------------------------
-- Enter the PIN code for your NXT
nxt.BtSetPIN("5551212") 
--codeExampleEnd 4


--codeExampleStart 12 -----------------------------------------------------------
-- Dump the first 4 entries in the device table
btDevice(4)

-- Results are below, do not paste the following text to the console!
Name:        DELLD610 Addr:00:10:c6:62:f6:ba Class:00:02:01:04 Status:2
Name:      BT GPS V10 Addr:00:0a:3a:24:33:97 Class:00:00:1f:00 Status:130
Name:                 Addr:00:00:00:00:00:00 Class:00:00:00:00 Status:0
Name:                 Addr:00:00:00:00:00:00 Class:00:00:00:00 Status:0
--codeExampleEnd 12

--codeExampleStart 13 -----------------------------------------------------------
-- Search for the NXT
nxt.BtSearch(1) -- This takes about 20 seconds!
--codeExampleEnd 13

--codeExampleStart 14 -----------------------------------------------------------
-- Dump the first 4 entries in the device table
btDevice(4)

-- Results are below, do not paste the following text to the console!
Name:        DELLD610 Addr:00:10:c6:62:f6:ba Class:00:02:01:04 Status:66
Name:      BT GPS V10 Addr:00:0a:3a:24:33:97 Class:00:00:1f:00 Status:130
Name:           LEFTY Addr:00:16:53:09:f7:59 Class:00:00:08:04 Status:130
Name:          RIGHTY Addr:00:16:53:09:f9:26 Class:00:00:08:04 Status:65
--codeExampleEnd 14

--codeExampleStart 15 -----------------------------------------------------------
-- Start the connection on CONTROL between channel 1 and device 3 (RIGHTY)
nxt.BtConnect(1,3)

-- Wait 5 seconds before entering the PIN on CONTROL
nxt.BtSetPIN("5551212")

-- Now enter the PIN on RIGHTY
nxt.BtSetPIN("5551212")
--codeExampleEnd 15

--codeExampleStart 16 -----------------------------------------------------------
-- Check the connection table on CONTROL
btConnect()

-- Results are below, do not paste the following text to the console!
Name:                 Addr:00:00:00:00:00:00 Class:00:00:00:00 PIN: Status:0
Name:          RIGHTY Addr:00:16:53:09:f9:26 Class:00:00:08:04 PIN:5551212 Status:0
Name:                 Addr:00:00:00:00:00:00 Class:00:00:00:00 PIN: Status:0
Name:                 Addr:00:00:00:00:00:00 Class:00:00:00:00 PIN: Status:0
--codeExampleEnd 16

--codeExampleStart 17 -----------------------------------------------------------
-- Check the device table on CONTROL
btDevice(4)

-- Results are below, do not paste the following text to the console!
Name:        DELLD610 Addr:00:10:c6:62:f6:ba Class:00:02:01:04 Status:2
Name:      BT GPS V10 Addr:00:0a:3a:24:33:97 Class:00:00:1f:00 Status:2
Name:           LEFTY Addr:00:16:53:09:f7:59 Class:00:00:08:04 Status:2
Name:          RIGHTY Addr:00:16:53:09:f9:26 Class:00:00:08:04 Status:2
--codeExampleEnd 17

--codeExampleStart 18 -----------------------------------------------------------
-- Sit in a loop and spit out anything from the Bluetooth radio to the
-- console...copy this to LEFTY and RIGHT

function BtListen() 
  -- Make sure we're reading the raw stream, not NXT messages
  nxt.BtStreamMode(1)

  -- Spin in a loop and echo any data we get until the big
  -- orange button is pressed.
  repeat
    s = nxt.BtStreamRecv()
    if s then
      print( s )
    end
  until( 8 == nxt.ButtonRead() )
end
--codeExampleEnd 18

--codeExampleStart 19 -----------------------------------------------------------
-- A little piece of code to wait until the BT system is idle...
function BtIdleWait()
    local active
    repeat
      _,active = nxt.BtGetStatus()
    until 17 == active
end

-- Set up the connection to LEFTY on channel 1 and device 2 (your device
-- number may be different!
nxt.BtConnect(1,2)

-- Wait until idle
BtIdleWait()

-- Set up the connection to RIGHTY on channel 2 and device 3 (your device
-- number may be different!
nxt.BtConnect(2,3)
--codeExampleEnd 19

--codeExampleStart 20 -----------------------------------------------------------
function BtStream() 
  -- Make sure we're reading the raw stream, not NXT messages
  nxt.BtStreamMode(1)
 
  local i = 0

  repeat
    nxt.BtStreamSend(1,"LEFTY"  .. i)
    nxt.BtStreamSend(2,"RIGHTY" .. i)
    i = i+1
  until( 8 == nxt.ButtonRead() )
end
--codeExampleEnd 20

--codeExampleStart 21 -----------------------------------------------------------
-- Start listening on LEFTY by typing this in the LEFTY console:
BtListen()

-- Start listening on RIGHTY by typing this in the RIGHTY console:
BtListen()

-- Start streaming by typing this in the CONTROL console:
BtStream()
--codeExampleEnd 21

--codeExampleStart 22 -----------------------------------------------------------
-- Copy the BtListen() function into FLASH on LEFTY and RIGHTY and run
-- it at startup

-- Create the program as an extended string...
s = [[
function BtListen() 
  -- Make sure we're reading the raw stream, not NXT messages
  nxt.BtStreamMode(1)

  -- Spin in a loop and echo any data we get until the big
  -- orange button is pressed.
  repeat
    s = nxt.BtStreamRecv()
    if s then
      nxt.DisplayScroll()
      nxt.DisplayText(s)
    end
  until( 8 == nxt.ButtonRead() )
end

repeat
  BtListen()

  -- Wait for button to be released 
  repeat
  until( 0 == nxt.ButtonRead() )

  -- Wait for button to be pressed
  repeat
  until( 8 == nxt.ButtonRead() )

  -- Wait for button to be released
  repeat
  until( 0 == nxt.ButtonRead() )
until false
]]

-- Create the file, save the handle so we can use it later...
h = nxt.FileCreate( "pbLuaStartup", string.len(s) )

-- Now write the string...
nxt.FileWrite( h, s )

-- And close the file...
nxt.FileClose( h )

-- The next time you boot LEFTY or RIGHTY, this program will run, even
-- if you're not connected to the console
--codeExampleEnd 22


--codeExampleStart 23 -----------------------------------------------------------
-- Copy the BtStream() function into FLASH on CONTROL and run
-- it at startup

-- Create the program as an extended string...
s = [[
function BtIdleWait()
    local active
    repeat
      _,active = nxt.BtGetStatus()
    until 17 == active
end


function BtStream() 
  nxt.BtDisconnectAll()
  
  -- Wait until idle
  BtIdleWait()

  -- Set up the connection to LEFTY on channel 1 and device 2 (your device
  -- number may be different!
  nxt.BtConnect(1,1)

  -- Wait until idle
  BtIdleWait()

  -- Set up the connection to RIGHTY on channel 2 and device 3 (your device
  -- number may be different!
  nxt.BtConnect(2,2)

    -- Wait until idle
  BtIdleWait()

  --Make sure we're reading the raw stream, not NXT messages
  nxt.BtStreamMode(1)
 
  local i = 0

  repeat
    nxt.BtStreamSend(1,"LEFTY"  .. i)
    nxt.BtStreamSend(2,"RIGHTY" .. i)
    i = i+1
  until( 8 == nxt.ButtonRead() )
end

repeat
  BtStream()

  -- Wait for button to be released 
  repeat
  until( 0 == nxt.ButtonRead() )

  -- Wait for button to be pressed
  repeat
  until( 8 == nxt.ButtonRead() )

  -- Wait for button to be released
  repeat
  until( 0 == nxt.ButtonRead() )
until false
]]

-- Create the file, save the handle so we can use it later...
h = nxt.FileCreate( "pbLuaStartup", string.len(s) )

-- Now write the string...
nxt.FileWrite( h, s )

-- And close the file...
nxt.FileClose( h )

-- The next time you boot CONTROL, this program will run, even
-- if you're not connected to the console
--codeExampleEnd 23

