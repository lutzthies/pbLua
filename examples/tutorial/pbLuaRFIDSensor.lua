-- This is the example code file for the webpage at:
--
-- www.hempeldesigngroup.com/lego/pbLua/tutorial/pbluaIRLink.html

--codeExampleStart 1 -----------------------------------------------------------
-- And use it - make sure you specify the port you have plugged the
-- IR Link in to port 1

nxt.RFIDdummy      = string.char( 0x04, 0x00, 0x00 )
nxt.RFIDboot       = string.char( 0x04, 0x41, 0x81 )
nxt.RFIDstart      = string.char( 0x04, 0x41, 0x83 )
nxt.RFIDstatus     = string.char( 0x04, 32 )

setupI2C(1)

nxt.I2CSendData( 1, nxt.RFIDboot,  0 )
nxt.I2CSendData( 1, nxt.RFIDstart, 0 )

nxt.I2CSendData( 1, nxt.RFIDdummy, 0 )
waitI2C( 1 )
checkI2C(1, 4)

-- Gives these results:

-- Version    -> V1.0
-- Product ID -> CODATEX
-- SensorType -> RFID
--codeExampleEnd 1

--codeExampleStart 2 -----------------------------------------------------------
-- Turn on the RFID sensor and take a single reading, then print the result

nxt.RFIDsingle     = string.char( 0x04, 0x41, 0x01 )

-- And this is the test function

function singleRFID(port,delay)
    -- Do a single reading
    nxt.I2CSendData( port, nxt.RFIDdummy, 0 )
    waitI2C( port )

    nxt.I2CSendData( port, nxt.RFIDsingle, 0 )
    waitI2C( port )

	-- wait delay msec ...

    local t = nxt.TimerRead()
    while t+delay > nxt.TimerRead() do
      -- This space intentionally left blank!
    end

    nxt.I2CSendData( port, nxt.I2Cdata[4], 5 )
    waitI2C( port )
    local result = nxt.I2CRecvData( port, 5 )

    -- Break the resulting string into 5 bytes and print them

    local c1,c2,c3,c4,c5 = string.byte(result,1,5)

    print( string.format( "Result: %02x %02x %02x %02x %02x",
                                    c1, c2, c3, c4, c5 ) )
end

-- And using the function
singleRFID(1,200)
singleRFID(1,200)
singleRFID(1,200)

--codeExampleEnd 2

--codeExampleStart 3 -----------------------------------------------------------
-- Turn on the RFID sensor and take continuous readings, then print results
-- if consecutive readings are different and non-null...

nxt.RFIDcontinuous = string.char( 0x04, 0x41, 0x02 )
nxt.RFIDstatus     = string.char( 0x04, 0x32 )

-- These strings represent bad RFID results

nullRFID  = string.char( 0x00, 0x00, 0x00, 0x00, 0x00 )

-- And this is the test function

function contRFID(port,delay)
    -- wake up the sensor
	nxt.I2CSendData( port, nxt.RFIDdummy, 0 )
    waitI2C( port )

    local oldResult, result = "", ""
    local status = 0

    repeat
      oldResult = result

	  -- Do continuous reading
      nxt.I2CSendData( port, nxt.RFIDcontinuous, 0 )
      waitI2C( port )

	  -- Check status, and wait if it's 0
      nxt.I2CSendData( port, nxt.RFIDstatus, 1 )
      waitI2C( port )
      status =  string.byte( nxt.I2CRecvData( port, 1 ) )
      if 0 == status then
	    -- wait 250 msec
        local t = nxt.TimerRead()
        while t+250 > nxt.TimerRead() do
        -- This space intentionally left blank!
        end
      end

	  -- wait delay msec before reading sensor
      local t = nxt.TimerRead()
      while t+delay > nxt.TimerRead() do
      -- This space intentionally left blank!
      end

      nxt.I2CSendData( port, nxt.I2Cdata[4], 5 )
      waitI2C( port )
      result = nxt.I2CRecvData( port, 5 )

      -- print results if valid and different from previous

      if ((result ~= nullRFID) and (result ~= oldResult)) then
        -- Break the resulting string into 5 bytes and print them

         local c1,c2,c3,c4,c5 = string.byte(result,1,5)

        print( string.format( "Result: %02x %02x %02x %02x %02x",
                                        c1, c2, c3, c4, c5 ) )
      end

    until( 8 == nxt.ButtonRead() )
end

-- And using the function
contRFID(1,200)
--codeExampleEnd 3

--codeExampleStart 4 -----------------------------------------------------------
> contRFID(1,100)
Result: 50 00 2a 18 b6
Result: 50 00 29 d8 3b
Result: 50 00 2a 18 b6
Result: 04 16 1d 5f de

--codeExampleEnd 4

--codeExampleStart 5 -----------------------------------------------------------
-- Here are statements that you can run one at a time to sound tones:
nxt.SoundTone(440)
nxt.SoundTone(880)
nxt.SoundTone(110)

-- Here is a way to assign the tones to specific badges from the
-- previous examples. First start with a blank table:

badgeAction = {}

-- Next, index the table with a string and store compiled tone function:

badgeAction[ "low" ] =
  loadstring( "nxt.SoundTone(440)" )


badgeAction[ "high" ] =
  loadstring( "nxt.SoundTone(880)" )

-- And test the array one element at a time as a function:

badgeAction["low"]()   -- should sound a low tone

badgeAction["high"]()  -- should sound a high tone
--codeExampleEnd 5

--codeExampleStart 5r -----------------------------------------------------------
-- What happens with a non-existent index?

badgeAction["dummy"]()

tty: stdin:1: attempt to call field 'dummy' (a nil value)
--codeExampleEnd 5r

--codeExampleStart 6 -----------------------------------------------------------
-- Set up a metatable, it can have any name we want, but this is a consistent
-- style if the metatable is for one table only...

badgeAction.mt = {}

-- Now specify what to do when we index a non=existent value...

badgeAction.mt.f = loadstring( "nxt.SoundTone(110)" )
badgeAction.mt.__index = function() return badgeAction.mt.f end
--codeExampleEnd 6

--codeExampleStart 6r -----------------------------------------------------------
-- And test it out...

badgeAction["dummy"]()

tty: stdin:1: attempt to call field 'dummy' (a nil value)
--codeExampleEnd 6r

--codeExampleStart 7 -----------------------------------------------------------
-- Assign the new metatable to the original table

setmetatable(badgeAction, badgeAction.mt)

-- And test it out...

badgeAction["dummy"]()
--codeExampleEnd 7

--codeExampleStart 8 -----------------------------------------------------------
-- Example code to sound tones when badges are recognized
--
-- First, enter table values for the badges we want associated with tones

badgeAction[ string.char( 0x50, 0x00, 0x2a, 0x18, 0xb6 ) ] =
  loadstring( "nxt.SoundTone(440)" )

badgeAction[ string.char( 0x50, 0x00, 0x29, 0xd8, 0x3b ) ] =
  loadstring( "nxt.SoundTone(880)" )

-- Make sure that you've set up the metatable from the previous example...
--
-- Then load up this new function.

function badgeTone(port,delay)
    -- wake up the sensor
	nxt.I2CSendData( port, nxt.RFIDdummy, 0 )
    waitI2C( port )

    local oldResult, result = "", ""
    local status = 0

    repeat
      oldResult = result

      -- Do continuous reading
      nxt.I2CSendData( port, nxt.RFIDcontinuous, 0 )
      waitI2C( port )

	  -- Check status, and wait if it's 0
      nxt.I2CSendData( port, nxt.RFIDstatus, 1 )
      waitI2C( port )
      status =  string.byte( nxt.I2CRecvData( port, 1 ) )
      if 0 == status then
	    -- wait 250 msec
        local t = nxt.TimerRead()
        while t+250 > nxt.TimerRead() do
        -- This space intentionally left blank!
        end
      end

	  -- wait delay msec before reading sensor
      local t = nxt.TimerRead()
      while t+delay > nxt.TimerRead() do
      -- This space intentionally left blank!
      end

      nxt.I2CSendData( port, nxt.I2Cdata[4], 5 )
      waitI2C( port )
      result = nxt.I2CRecvData( port, 5 )

      -- print results if valid and different from previous

      if ((result ~= nullRFID) and (result ~= oldResult)) then
        -- Break the resulting string into 5 bytes and print them

        local c1,c2,c3,c4,c5 = string.byte(result,1,5)

        print( string.format( "Result: %02x %02x %02x %02x %02x",
                                        c1, c2, c3, c4, c5 ) )

		-- And don't forget to sound the tone! 
        badgeAction[ result ]()

	  end

    until( 8 == nxt.ButtonRead() )
end

-- And using the function
badgeTone(1,200)
--codeExampleEnd 8
--
--codeExampleStart n -----------------------------------------------------------
--codeExampleEnd n


