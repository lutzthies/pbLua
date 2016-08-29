-- This is the example code file for the webpage at:
--
-- www.hempeldesigngroup.com/lego/pbLua/tutorial/pbluaIRLink.html

--codeExampleStart 1 -----------------------------------------------------------
-- And use it - make sure you specify the port you have plugged the
-- IR Link in to:

checkI2C(1,2)

-- Gives these results:

-- Version    -> ýV1.2
-- Product ID -> HiTechnc
-- SensorType -> IRLink
--codeExampleEnd 1

--codeExampleStart 2 -----------------------------------------------------------
-- Set up the two strings that we'll use alternately. The only difference
-- is the toggle bit. It will send the combo-direct command on channel 0 to
-- turn OutputA onfwd and OutputB float. The mode byte is 2 for PF motors.
-- If the IR signal is lost, the motors will turn off.
--
-- Note: Output A is the RED connector, and make sure the IR receiver is
--       set to channel 0!

s0 = nxt.EncodeIR( 0x011, 2 )
s1 = nxt.EncodeIR( 0x811, 2 )

-- And this is the test function

function IRTest(port)
  -- Set up the port and report on the sensor type
  checkI2C(port,2)

  repeat
    nxt.I2CSendData( port, s0, 0 )
    waitI2C( port )
    nxt.I2CSendData( port, s1, 0 )
    waitI2C( port )
  until( 8 == nxt.ButtonRead() )
end

-- And using the function - press the orange button on the NXT to stop it
IRTest(1)
--codeExampleEnd 2

--codeExampleStart 3 -----------------------------------------------------------
-- Set up strings for brake, fwd, rev for motor A

b0 = nxt.EncodeIR( 0x013, 2 )
b1 = nxt.EncodeIR( 0x813, 2 )

f0 = nxt.EncodeIR( 0x011, 2 )
f1 = nxt.EncodeIR( 0x811, 2 )

r0 = nxt.EncodeIR( 0x012, 2 )
r1 = nxt.EncodeIR( 0x812, 2 )

-- And this is the test function

function IRTest(port)
  -- Set up the port and report on the sensor type
  checkI2C(port,2)

  repeat
    if nxt.ButtonRead() == 2 then       -- Set up for FWD
      s0, s1 = f0, f1                   -- multi-assignment, cool!
    elseif nxt.ButtonRead() == 4 then   -- Set up for REV
      s0, s1 = r0, r1
    else                                -- Set up for BRAKE
      s0, s1 = b0, b1
    end

    nxt.I2CSendData( port, s0, 0 )
    waitI2C( port )
    nxt.I2CSendData( port, s1, 0 )
    waitI2C( port )
  until( 8 == nxt.ButtonRead() )
end

-- And using the function - press the orange button on the NXT to stop it
IRTest(1)
--codeExampleEnd 3

--codeExampleStart 4 -----------------------------------------------------------
-- Set up strings with toggles for StepFWD, StepRev, Stop for channel 1 

StepFwd = { nxt.EncodeIR( 0x100, 1 ), nxt.EncodeIR( 0x101, 1 ) }
StepRev = { nxt.EncodeIR( 0x110, 1 ), nxt.EncodeIR( 0x111, 1 ) }
Stop    = { nxt.EncodeIR( 0x120, 1 ), nxt.EncodeIR( 0x121, 1 ) }

-- And this is the test function

function TrainTest(port)
  -- Set up the port and report on the sensor type
  checkI2C(port,2)

  local toggle = true
  local s = Stop[1]

  repeat
    if nxt.ButtonRead() == 2 then       -- Set up for FWD
      if toggle then s = StepFwd[1] else s = StepFwd[2] end
      toggle = not toggle
    elseif nxt.ButtonRead() == 4 then   -- Set up for REV
      if toggle then s = StepRev[1] else s = StepRev[2] end
      toggle = not toggle
    elseif nxt.ButtonRead() == 1 then   -- Set up for Stop
      if toggle then s = Stop[1] else s = Stop[2] end
      toggle = not toggle
    end

    repeat
    -- spin here until the button is released!
    until( 0 == nxt.ButtonRead() )

    nxt.I2CSendData( port, s, 0 )
    waitI2C( port )

  until( 8 == nxt.ButtonRead() )
end

-- And using the function - press the orange button on the NXT to stop it
TrainTest(1)
--codeExampleEnd 4

--codeExampleStart n -----------------------------------------------------------
--codeExampleEnd n


