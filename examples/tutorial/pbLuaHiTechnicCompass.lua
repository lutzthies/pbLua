-- This is the example code file for the webpage at:
--
-- www.hempeldesigngroup.com/lego/pbLua/tutorial/pbLuaHiTechnicCompass.html

--codeExampleStart 1 -----------------------------------------------------------
-- Read compass sensor in raw mode until the orange button is pressed

function CompassRead(port)
  -- Set up the port and report on the sensor type (I2C address 2)
  checkI2C(port,2)

  -- Read and print the results until the orange button is pressed
  repeat
    -- Read 8 bytes of data from the sensor
    nxt.I2CSendData( port, nxt.I2Cdata(2), 4 )
    waitI2C( port )
    s = nxt.I2CRecvData( port, 4 )

    -- Break the resulting string into 8 bytes and print the results
    c1,c2,c3,c4 = string.byte(s,1,8)
    print( string.format( "Result: %3i %3i %3i %3i",
                                    c1, c2, c3, c4 ) )
  until( 8 == nxt.ButtonRead() )
end

-- Run the test code...
CompassRead(1)
--codeExampleEnd 1

--codeExampleStart 2 -----------------------------------------------------------
function Spin(speed)
  nxt.OutputSetSpeed(2,32,-speed)
  nxt.OutputSetSpeed(3,32, speed)
end

function Move(speed)
  nxt.OutputSetSpeed(2,32, speed)
  nxt.OutputSetSpeed(3,32, speed)
end

function Stop()
  nxt.OutputSetSpeed(2)
  nxt.OutputSetSpeed(3)
end
--codeExampleEnd 2

--codeExampleStart 3 -----------------------------------------------------------
function RunCompass(port)
   -- Set up the port and report on the sensor type
  checkI2C(port,2)

  nxt.OutputSetRegulation(2,1,1)
  nxt.OutputSetRegulation(3,1,1)

  -- Read and print the results until the orange button is pressed
  repeat
    -- Read 8 bytes of data from the sensor
    nxt.I2CSendData( port, nxt.I2Cdata(2), 4 )
    waitI2C( port )
    s = nxt.I2CRecvData( port, 4 )

    -- Break the resulting string into 8 bytes and print the results
    c1,c2,c3,c4 = string.byte(s,1,8)
    print( string.format( "Result: %3i %3i %3i %3i",
                                    c1, c2, c3, c4 ) )

    angle = c1

    if angle < 3 then
      Spin(0)
    elseif angle < 90 then
      Spin(-60)
    elseif angle < 177 then
      Spin( 60)
    else
      Spin(0)
    end

  until( 8 == nxt.ButtonRead() )

  Stop()
end 

-- And run the test code...
RunCompass(1)
--codeExampleEnd 3

--codeExampleStart 4 -----------------------------------------------------------
function RunCompass(port,desired)
  -- Initialize the desired direction - remember to divide by two
  desired = desired/2 or 0

   -- Set up the port and report on the sensor type
  checkI2C(port,2)

  nxt.OutputSetRegulation(2,1,1)
  nxt.OutputSetRegulation(3,1,1)

  -- Read and print the results until the orange button is pressed
  repeat
    -- Read 8 bytes of data from the sensor
    nxt.I2CSendData( port, nxt.I2Cdata(2), 4 )
    waitI2C( port )
    s = nxt.I2CRecvData( port, 4 )

    -- Break the resulting string into 8 bytes and print the results
    c1,c2,c3,c4 = string.byte(s,1,8)
    print( string.format( "Result: %3i %3i %3i %3i",
                                    c1, c2, c3, c4 ) )

    -- Figure out the difference and adjust to a positive value
    angle = (c1 - desired + 180) % 180

    -- angle = c1

    if angle < 3 then
      Spin(0)
    elseif angle < 90 then
      Spin(-60)
    elseif angle < 177 then
      Spin( 60)
    else
      Spin(0)
    end

  until( 8 == nxt.ButtonRead() )

  Stop()
end 

-- And run the test code...
RunCompass(1,90)
--codeExampleEnd 4

--codeExampleStart 5 -----------------------------------------------------------
function RunCompass(port,desired,tolerance)
  -- Initialize the desired direction - remember to divide by two
  desired   = (desired   or 0) / 2
  tolerance = (tolerance or 2) / 2

   -- Set up the port and report on the sensor type
  checkI2C(port,2)

  nxt.OutputSetRegulation(2,1,1)
  nxt.OutputSetRegulation(3,1,1)

  -- Read and print the results until the orange button is pressed
  repeat
    -- Read 8 bytes of data from the sensor
    nxt.I2CSendData( port, nxt.I2Cdata(2), 4 )
    waitI2C( port )
    s = nxt.I2CRecvData( port, 4 )

    -- Break the resulting string into 8 bytes and print the results
    c1,c2,c3,c4 = string.byte(s,1,8)
    print( string.format( "Result: %3i %3i %3i %3i",
                                    c1, c2, c3, c4 ) )

    -- Figure out the difference and adjust to a positive value
    angle = (c1 - desired + 180) % 180
    
    if angle < tolerance then
      Spin(0)
    elseif angle < 90 then
      Spin( -(10 + angle) )
    elseif angle < 180-tolerance then
      Spin( 10 + 180 - angle )
    else
      Spin(0)
    end

  until( 8 == nxt.ButtonRead() )

  Stop()
end 

-- And run the test code...
RunCompass(1,90,2)
--codeExampleEnd 5

--codeExampleStart 6 -----------------------------------------------------------
-- Put the compass in calibrate mode and spin very slowly for 5 seconds

function CompassCalibrate( port ) 
  -- Set up the port and report on the sensor type
  checkI2C(port,2)
  
  -- Force the compass into calibrate mode
  nxt.I2CSendData( port, string.char( 0x41, 0x43 ), 1 )
  waitI2C( port )
  print( "Calibration Result->" .. string.byte( nxt.I2CRecvData( port, 1 ) ) )

  -- Force regulation mode so we can get the lowest possible steady speed
  nxt.OutputSetRegulation(2,1,1)
  nxt.OutputSetRegulation(3,1,1)

  --Now spin slowly for 20 seconds - then stop
  Spin( 15 )
 
  local t=nxt.TimerRead()
  repeat
      -- do nothing
  until( t+20000 < nxt.TimerRead() )

  Stop()

  -- Go back to normal mode and check calibration results
  nxt.I2CSendData( port, string.char( 0x41, 0x00 ), 1 )
  waitI2C( port )
  print( "Calibration Result->" .. string.byte( nxt.I2CRecvData( port, 1 ) ) )
end

-- Running the calibration routine
CompassCalibrate(1)
--codeExampleEnd 6

