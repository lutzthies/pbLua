-- This is the example code file for the webpage at:
--
-- www.hempeldesigngroup.com/lego/pbLua/tutorial/pbLuaGyro.html

--codeExampleStart 1 -----------------------------------------------------------
-- Initialize the Gyro sensor on a port

function GyroInit(port,active)
  nxt.InputSetType(port,0)

  if 0 == (active or 0) then nxt.InputSetState(port,0,0)
                        else nxt.InputSetState(port,1,0)
  end

  nxt.InputSetDir(port,1,1)
end

-- Read the Gyro sensor no faster than every 4 msec and
-- print the timestamp and result. Stop when we press the
-- orange button

function GyroTest(port, timeout)
  timeout = timeout or 4

  local sampletick = 0
  local tick, new

  repeat
    tick = nxt.TimerRead() 
    if tick-sampletick >= timeout then
      new = nxt.InputGetStatus(port)
      print( tick .. " | " .. new )
      sampletick = tick
    end
  until( 8 == nxt.ButtonRead() )
  	
  repeat
  -- spin here until the button is released!
  until( 0 == nxt.ButtonRead() )
  	
end

-- Inititialize the gyro on port 1 to less sensitive mode and print
-- the samples

GyroInit(1,0)
GyroTest(1)
--codeExampleEnd 1

--codeExampleStart 1r -----------------------------------------------------------
2279974 617
2279978 617
2279983 617
2279994 617
2279999 617
2280003 617
2280007 620
2280011 614
2280017 616
2280030 617
2280034 617
2280038 617
2280042 615
2280048 617
2280053 616
2280067 617
2280071 617
2280075 617
2280079 617
2280083 617
--codeExampleEnd 1r

--codeExampleStart 2 -----------------------------------------------------------
-- Read the Gyro sensor no faster than every 4 msec and calculate the
-- running average. Each sample is scaled by 64 and the average is
-- weighted by a factor of 128.

function GyroZero(port, scale, weight)
  local sampletick = 0
  local printtick  = 0
  local avg = 0
  local fweight = nxt.float( scale*weight )

  local tick, new
    
  repeat
    local tick = nxt.TimerRead() 

    -- update the average no faster than every 4 msec
    if tick-sampletick >= 4 then
      new = nxt.InputGetStatus(port)*scale
      avg = avg - (avg/weight) + new
      sampletick = tick
    end

    -- print the average no faster than every 256 msec
    if tick-printtick >= 256 then
      print( tick, avg, avg/fweight )
      printtick = tick
    end

  until( 8 == nxt.ButtonRead() )

  repeat
  -- spin here until the button is released!
  until( 0 == nxt.ButtonRead() )
  	
  return( avg )
end

-- Inititialize the gyro in port 1 to less sensitive mode and print
-- the running average until the orange button is pressed

GyroInit(1,0)
=GyroZero(1,64,128)
--codeExampleEnd 2

--codeExampleStart 2r -----------------------------------------------------------
> =GyroZero(1,64,128)
130430  39488   4.820312
130686  1845131 225.235717
130942  3031650 370.074462
131198  3758822 458.840576
131454  4230305 516.394653
131710  4532917 553.334594
131966  4718822 576.028076
132222  4837786 590.550048
132478  4917269 600.252563
132734  4964312 605.995117
132990  4995417 609.792114
133246  5015514 612.245361
133502  5027208 613.672851
133758  5034958 614.618896
134014  5039344 615.154296
134270  5042426 615.530517
134526  5044153 615.741333
134782  5045634 615.922119
135038  5046739 616.057006
135294  5046977 616.086059
135550  5047888 616.197265
135806  5048128 616.226562
136062  5047896 616.198242
136318  5048005 616.211547
136574  5048054 616.217529
136830  5048699 616.296264
137086  5048668 616.292480
--codeExampleEnd 2r

--codeExampleStart 3 -----------------------------------------------------------
-- Read the Gyro sensor no faster than every 32 msec and subtract the scaled
-- zero point returned by a previous call to GyroZero().

function GyroRead(port,scale,weight,zero)
  local sampletick = 0
  local fweight = nxt.float( scale*weight )
  
  local tick, new

  repeat
	tick = nxt.TimerRead() 

	-- take a new sample no faster than every 32 msec
	if tick-sampletick >= 32 then
	  new = nxt.InputGetStatus(port)*scale*weight - zero
      print( tick, new, new/fweight )
	  sampletick = tick
	end
	
  until( 8 == nxt.ButtonRead() )
  	
  repeat
  -- spin here until the button is released!
  until( 0 == nxt.ButtonRead() )
  	
end

-- Inititialize the gyro in port 1 to less sensitive mode and print
-- the running average until the orange button is pressed, then print
-- the zero compensated output until the orange button is pressed
--
-- Notice how the output of one function is part of the input to
-- the next one...

GyroInit(1,0)
GyroRead(1,64,128, GyroZero(1,64,128) )
--codeExampleEnd 3

--codeExampleStart 3r -----------------------------------------------------------
--codeExampleEnd 3r

--codeExampleStart 4 -----------------------------------------------------------
-- Read the Gyro sensor no faster than every 16 msec and subtract the scaled
-- zero point returned by a previous call to GyroZero(). Keep a running total
-- of the sum which is the current angular displacement

function GyroSum(port,scale,weight,zero,period)
     local tick = nxt.TimerRead()
     local printtick,sampletick = tick,tick
     local old, new, sum = 0,0,0
     local fweight = nxt.float( scale*weight*1000 )
	 
	 repeat
	   tick = nxt.TimerRead() 
   
	   -- take a new sample no faster than every period msec
	   if tick-sampletick >= period then
		 new = nxt.InputGetStatus(port)*scale*weight - zero
		 sum = sum + ((new+old)/2)*(tick-sampletick)
		 
		 old = new
		 sampletick = tick
	--     print( tick, new, diff, sum, sum/(scale*weight*1000), speed  )
	   end
	   
	   -- print the sum no faster than every 1000 msec
	   if tick-printtick >= 1000 then
		 print( sum, sum/fweight )
		 printtick = tick
       end

	   if 1 == nxt.ButtonRead() then
		 sum = 0  
	   end
	 
	 until( 8 == nxt.ButtonRead() )
   		   
	 repeat
	 -- spin here until the button is released!
	 until( 0 == nxt.ButtonRead() )
end

-- Inititialize the gyro in port 1 to less sensitive mode and print
-- the running average until the orange button is pressed, then print
-- the zero compensated output and total angular displacement until
-- the orange button is pressed
--
-- Notice how the output of one function is part of the input to
-- the next one...

GyroInit(1,0)
GyroSum(1,64,128, GyroZero(1,64,128), 32 )
--codeExampleEnd 4

--codeExampleStart 4r -----------------------------------------------------------
-- Here's the output of the program after the zero point stabilizes. I'm turning
-- the sensor 90 degrees clockwise in a fixture and the indicated angle is -91
-- degrees. When I return the sensor to the original position the indicated
-- angle is back to the original -1 degrees

4981144      0.608049
3260429      0.398001
1979037      0.241581
3651252      0.445709
101220116   12.355970
652550725   79.657073
764644166   93.340354
707941286   86.418617
15886016     1.939210
-894571     -0.109200
510008       0.062256
1992112      0.243177
--codeExampleEnd 4r

--codeExampleStart 5 -----------------------------------------------------------
-- Balance the robot

function GyroBalance(port,scale,weight,zero,period,pid)
    local tick = nxt.TimerRead()
	local printtick,sampletick = tick,tick
	local old, new, sum, diff, speed = 0,0,0,0,0
	local fweight = nxt.float( scale*weight )
  
  -- Set the motors on port 1 and port 3 to non-regulated 
  -- brake mode
  nxt.OutputSetRegulation(1,0,1)
  nxt.OutputSetRegulation(3,0,1)
  
  repeat
    tick = nxt.TimerRead() 

    -- take a new sample no faster than every period msec
    if tick-sampletick >= period then
	  new = nxt.InputGetStatus(port)*scale*weight - zero
	  diff = new - old
	  sum = sum + ((new+old)/2)*(tick-sampletick)
	  
	  speed = (pid.p*new+pid.d*diff+pid.i*(sum/1000))/(scale*weight*256)
	  speed = nxt.min(100,speed)
	  speed = nxt.max(speed,-100)
      nxt.OutputSetSpeed(1,0x20,speed)  
      nxt.OutputSetSpeed(3,0x20,speed)
      old = new
      sampletick = tick
 --     print( tick, new, diff, sum, sum/(scale*weight*1000), speed  )
    end
     
	if 1 == nxt.ButtonRead() then
	  sum = 0  
    end
  
  until( 8 == nxt.ButtonRead() )

  -- Don't forget to turn off the motors!
  
  nxt.OutputSetSpeed(1,0,0)  
  nxt.OutputSetSpeed(3,0,0)  
   	    
  repeat
  -- spin here until the button is released!
  until( 0 == nxt.ButtonRead() )
    
end

-- Inititialize the gyro in port 1 to less sensitive mode and print
-- the running average until the orange button is pressed, then balance
-- the robot
--
-- Notice how the output of one function is part of the input to
-- the next one...

pid = {p=180,i=6000,d=100}
GyroInit(1,0)
GyroBalance(1,16,128, GyroZero(1,16,128),32, pid )
--codeExampleEnd 5

--codeExampleStart nr -----------------------------------------------------------
--codeExampleEnd nr


