-- This is the example code file for the webpage at:
--
-- www.hempeldesigngroup.com/lego/pbLua/tutorial/pbLuaBasicMotors.html

--codeExampleStart 1 -----------------------------------------------------------
-- Read motor port until the orange button is pressed
function MotorRead(port)

  repeat
    print( nxt.TimerRead(), nxt.OutputGetStatus(port) )
  until( 8 == nxt.ButtonRead() )
end

-- And using the function with a motor plugged into port A...
MotorRead(1)
--codeExampleEnd 1

--codeExampleStart 2 -----------------------------------------------------------
-- Read motor port until the orange button is pressed
-- Left arrow decreases speed
-- Right arrow increases speed
function MotorSpeed(port)
  local speed = 0

  repeat
    if 4 == nxt.ButtonRead() then
      if speed >= -95 then
        speed = speed - 5
        nxt.OutputSetSpeed( port, 32, speed )
      end
    end

    if 2 == nxt.ButtonRead() then
      if speed <= 95 then
        speed = speed + 5
        nxt.OutputSetSpeed( port, 32, speed )
      end
    end

    print( nxt.TimerRead(), nxt.OutputGetStatus(port) )
  until( 8 == nxt.ButtonRead() )

  -- Remember to turn the motor off!
  nxt.OutputSetSpeed( port, 0, 0 )
end

-- And using the function with a motor plugged into port A...
MotorSpeed(1)
--codeExampleEnd 2

--codeExampleStart 3 -----------------------------------------------------------
-- Read motor port until the orange button is pressed
-- Left arrow decreases speed
-- Right arrow increases speed
function MotorSpeed(port)
  local speed = 0
  local oldButton = 0
  local newButton = 0

  repeat
    newButton = nxt.ButtonRead()

    if 0 == oldButton then
      -- Only check buttons if no buttons are pressed!

      if 4 == newButton then
        if speed >= -95 then
          speed = speed - 5
          nxt.OutputSetSpeed( port, 32, speed )
        end
      end

      if 2 == newButton then
        if speed <= 95 then
          speed = speed + 5
          nxt.OutputSetSpeed( port, 32, speed )
        end
      end
    end

    oldButton = newButton

    print( nxt.TimerRead(), nxt.OutputGetStatus(port) )

  until( 8 == newButton )

  -- Remember to turn the motor off!
  nxt.OutputSetSpeed( port, 0, 0 )
end
-- And using the function with a motor plugged into port A...
MotorSpeed(1)
--codeExampleEnd 3

--codeExampleStart 4 -----------------------------------------------------------
-- Read motor port until the orange button is pressed
-- Left arrow decreases speed
-- Right arrow increases speed

function MotorSpeed(port, state, mode )
  local speed = 0
  local oldButton = 0
  local newButton = 0

  nxt.OutputSetRegulation( port, state, mode )

  repeat
    newButton = nxt.ButtonRead()

    if 0 == oldButton then
      if 4 == newButton then
        if speed >= -95 then
          speed = speed - 5
          nxt.OutputSetSpeed( port, 32, speed )
        end
      end

      if 2 == newButton then
        if speed <= 95 then
          speed = speed + 5
          nxt.OutputSetSpeed( port, 32, speed )
        end
      end
    end

    oldButton = newButton

    print( nxt.TimerRead(), nxt.OutputGetStatus(port), nxt.HeapInfo() )
  until( 8 == newButton )

  -- Remember to turn the motor off!
  nxt.OutputSetSpeed( port, 0, 0 )
end

-- Now try it out with regulation in float mode...
MotorSpeed( 1, 1, 0 )

-- Now try it out with regulation in brake mode...
MotorSpeed( 1, 1, 1 )

-- And with no regulation at all...
MotorSpeed( 1, 0, 0 )
--codeExampleEnd 4

--codeExampleStart 5 -----------------------------------------------------------
-- Line Follower!
function LineFollow(target,delay,n)
  local port = 1

  nxt.InputSetType(port,5)

  nxt.OutputSetRegulation(1,1,1)
  nxt.OutputSetRegulation(3,1,1)

  local idx = 1
  local speed = 0;

  -- initialize the raw array to "grey"
  local raw = {}
  for i=1,n do
    raw[i] = target
  end

  repeat
   t = nxt.TimerRead()
   while t+delay > nxt.TimerRead() do
     -- nothing
   end

   -- get a new raw reading
   raw[(idx%n)+1] = nxt.InputGetStatus(port)

   -- calculate the average
   local sum = 0
   for i=1,n do
     sum = sum + raw[n]
   end

   local avg = sum/n

   print( avg )

   if avg > target then
     speed = 20 + ((avg - target)/2)
     if speed > 50 then speed = 50 end

     nxt.OutputSetSpeed(1,0x20,20)
     nxt.OutputSetSpeed(3,0x20,speed)
   else
     speed = 20 + ((target - avg)/2)
     if speed > 50 then speed = 50 end

     nxt.OutputSetSpeed(1,0x20,speed)
     nxt.OutputSetSpeed(3,0x20,20)
   end

   idx = idx + 1
  until( 8 == nxt.ButtonRead() )

  nxt.OutputSetSpeed(1,0,0)
  nxt.OutputSetSpeed(3,0,0)
  nxt.InputSetState(port,0,0)
end

-- And using the function - press the orange button on the NXT to stop it
LineFollow(760,780)
--codeExampleEnd 5

--codeExampleStart 6 -----------------------------------------------------------
-- Sync Motors B (I) and C (II) - the speed is s and the difference is t

function MotorSync(s,t)

  nxt.OutputResetTacho(2,1,1,1)
  nxt.OutputResetTacho(3,1,1,1)

  nxt.OutputSetRegulation(2,2,1)
  nxt.OutputSetRegulation(3,2,1)

  nxt.DisableNXT( 1 );
  nxt.OutputSetSpeed(2,0x20,s, 0, t )
  nxt.OutputSetSpeed(3,0x20,s, 0, t )
  nxt.DisableNXT( 0 );

  repeat
  until( 8 == nxt.ButtonRead() )

  nxt.OutputSetSpeed(2)
  nxt.OutputSetSpeed(3)
end
-- And using the function - press the orange button on the NXT to stop it

-- Motor I and II try to stay sunchronized
MotorSync(75,0)

-- Motor I turns a bit slower than Motor I
MotorSync(75,20)

-- Motor I stops - all power goes to Motor I
MotorSync(75,50)

-- Motor I turns a bit slower than Motor 1 - in the opposite direction
MotorSync(75,60)
--codeExampleEnd 6

--codeExampleStart n -----------------------------------------------------------
--codeExampleEnd n


