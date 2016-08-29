-- This is the example code file for the webpage at:
--
-- www.hempeldesigngroup.com/lego/pbLua/tutorial/pbLuaHiTechnicTrike.html

--codeExampleStart 1 -----------------------------------------------------------
-- Simple test code for reading orange switch

function TestButton()

  print( "Waiting for keypress" )

  -- Now spin here until someone presses the orange key
  repeat
  until( 8 == nxt.ButtonRead() )
 
  -- And spin here until someone presses the ornage key again
  repeat
    print( "Running main routine" )
  until( 8 == nxt.ButtonRead() )

  print( "Done" )
end

-- Running the test
TestButton()
--codeExampleEnd 1

--codeExampleStart 2 -----------------------------------------------------------
-- A better framework for reading the orange switch

function TestButton()

  print( "Waiting for keypress" )

  -- Now spin here until someone presses and releases the orange key
  local oldKey = 0;
  local newKey = 0;
  
  repeat
    oldKey = newKey
    newKey = nxt.ButtonRead()
  until( oldKey == 8 and newKey == 0 )
 
  -- And spin here until someone presses the orange key again
  repeat
    print( "Running main routine" )
  until( 8 == nxt.ButtonRead() )

  print( "Done" )
end

-- Running the test
TestButton()
--codeExampleEnd 2

--codeExampleStart 3 -----------------------------------------------------------
-- Move the Trike forward for one second...then stop. Note that we're using
-- our orange switch framework more sensibly. You can pass a function to the
-- TestButton() function now!

function TestTrike( doThis )

  print( "Waiting for keypress" )

  -- Now spin here until someone presses and releases the orange key
  local oldKey = 0;
  local newKey = 0;
  
  repeat
    oldKey = newKey
    newKey = nxt.ButtonRead()
  until( oldKey == 8 and newKey == 0 )
 
  doThis()

  print( "Done" )
end

-- Here's the actual test function

function MoveForward( )
  local ticks = nxt.TimerRead()

  -- Turn the motors on
  --
  nxt.OutputSetSpeed(2,32,80)
  nxt.OutputSetSpeed(3,32,80)

  -- Stay here for 1 second (1000 ticks)
  --
  repeat
    -- this space intentionally left blank
  until( ticks+1000 < nxt.TimerRead() )

  -- Turn the motors off
  --
  nxt.OutputSetSpeed(2,0,0)
  nxt.OutputSetSpeed(3,0,0)
end

-- Running the test
TestTrike( MoveForward )
--codeExampleEnd 3


--codeExampleStart 4 -----------------------------------------------------------
-- A first pass at functions to move the Trike
--
function TrikeForward( speed )
  nxt.OutputSetSpeed(2,32, speed)
  nxt.OutputSetSpeed(3,32, speed)
end

function TrikeReverse( speed )
  nxt.OutputSetSpeed(2,32,-speed)
  nxt.OutputSetSpeed(3,32,-speed)
end

function TrikeClockwise( speed )
  nxt.OutputSetSpeed(2,32,-speed)
  nxt.OutputSetSpeed(3,32, speed)
end

function TrikeCounterClockwise( speed )
  nxt.OutputSetSpeed(2,32, speed)
  nxt.OutputSetSpeed(3,32,-speed)
end

function TrikeStop()
  nxt.OutputSetSpeed(2,0,0)
  nxt.OutputSetSpeed(3,0,0)
end
--codeExampleEnd 4

--codeExampleStart 5 -----------------------------------------------------------
-- Make is so we only have to change one function if the motor port changes

function MoveTrike( leftSpeed, rightSpeed )
  nxt.OutputSetSpeed(2,32,rightSpeed)
  nxt.OutputSetSpeed(3,32,leftSpeed)
end
 
function TrikeForward( speed )
  MoveTrike( speed, speed )
end

function TrikeReverse( speed )
  MoveTrike(-speed,-speed )
end

function TrikeClockwise( speed )
  MoveTrike(-speed, speed )
end

function TrikeCounterClockwise( speed )
  MoveTrike( speed,-speed )
end

function TrikeStop()
  MoveTrike( 0, 0 )
end
--codeExampleEnd 5

--codeExampleStart 6 -----------------------------------------------------------
-- New test function, use the framework from example 3

function TimedMoves( )
  local ticks = nxt.TimerRead()

  TrikeForward( 80 )

  repeat
    -- this space intentionally left blank
  until( ticks+1000 < nxt.TimerRead() )

  TrikeReverse( 80 )

  repeat
    -- this space intentionally left blank
  until( ticks+2000 < nxt.TimerRead() )

  TrikeClockwise( 80 )

  repeat
    -- this space intentionally left blank
  until( ticks+3000 < nxt.TimerRead() )

  TrikeCounterClockwise( 80 )

  repeat
    -- this space intentionally left blank
  until( ticks+4000 < nxt.TimerRead() )

  TrikeStop( 80 )
end

-- Running the test
TestTrike( TimedMoves )
--codeExampleEnd 6
