-- This is the example code file for the webpage at:
--
-- www.hempeldesigngroup.com/lego/pbLua/tutorial/pbLuaFirstSteps.html

--codeExampleStart 1 -----------------------------------------------------------
-- Hello World! for pbLua

print( "Hello World!" )
--codeExampleEnd 1

--codeExampleStart 2 -----------------------------------------------------------
-- Reading the NXT millisecond timer

print( nxt.TimerRead() )
--codeExampleEnd 2

--codeExampleStart 3 -----------------------------------------------------------
-- Reading the NXT millisecond timer using the short form of print

=nxt.TimerRead()
--codeExampleEnd 3

--codeExampleStart 4 -----------------------------------------------------------
-- Reading the NXT millisecond timer and storing it in a variable

cur = nxt.TimerRead()

-- And now print the saved result...

print( cur )

-- or equivalently at the console...

=cur
--codeExampleEnd 4

--codeExampleStart 5 -----------------------------------------------------------
-- Implementing a simple busy-wait loop

function BusyWait( n )
  local start, stop
  start = nxt.TimerRead()

  repeat
    stop = nxt.TimerRead()
  until start+n < stop
end

-- And use it like this:

function testBusyWait( n )
  print( nxt.TimerRead() )
  BusyWait( n )
  print( nxt.TimerRead() )
end
--codeExampleEnd 5

--codeExampleStart 6 -----------------------------------------------------------
-- Reading the NXT front panel buttons

print( nxt.ButtonRead() )
--codeExampleEnd 6

--codeExampleStart 7 -----------------------------------------------------------
-- Detecting a button press...

function WaitButtonPress()
  repeat
    b = nxt.ButtonRead()
  until b ~= 0

  return b, nxt.TimerRead()
end

-- and using the function

b,t = WaitButtonPress()

print( "Button -> " .. b .. " Time -> " .. t )
--codeExampleEnd 7

--codeExampleStart 8 -----------------------------------------------------------
-- Detecting a button release...

function WaitButtonRelease()
  local b

  repeat
    b = nxt.ButtonRead()
  until b == 0

  return b, nxt.TimerRead()
end

-- A function that combines these operations:

function TimeButtonPress()
  local b,s = WaitButtonPress()
  _,e = WaitButtonRelease()

  print( "Button -> " .. b .. " Time -> " .. s )
  print( "Released at Time -> " .. e )
  print( "Total Time Pressed -> " .. e-s )
end
--codeExampleEnd 8

--codeExampleStart 9 -----------------------------------------------------------
-- Detecting button state...

function WaitButtonState( s )
  repeat
    b = nxt.ButtonRead()
  until b == s

  return b, nxt.TimerRead()
end

-- A function that combines these operations:

function TimeButtonPress()
  b,s = WaitButtonState( 8 )
  _,e = WaitButtonState( 0 )

  print( "Button -> " .. b .. "Time -> " .. s )
  print( "Released at Time -> " .. e )
  print( "Total Time Pressed -> " .. e-s )
end
--codeExampleEnd 9

--codeExampleStart n
--codeExampleEnd n
