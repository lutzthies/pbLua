-- This is the example code file for the webpage at:
--
-- www.hempeldesigngroup.com/lego/pbLua/tutorial/pbLuaCoroutines.html

--codeExampleStart 1 -----------------------------------------------------------
co = coroutine.create(
function ()
  for i=1,10 do
    print("co",i)
    coroutine.yield()
  end
end
)
--codeExampleEnd 1

--codeExampleStart 2 -----------------------------------------------------------

co1 = coroutine.create(
function ( s )
  local t = nxt.TimerRead()
  while s do
    if t+1000 < nxt.TimerRead() then
      t = t+1000
      print("co1", t)
    end

    s = coroutine.yield()
  end
end
)

co2 = coroutine.create(
function ( s )
  local t = nxt.TimerRead()
  while s do
    if t+1500 < nxt.TimerRead() then
      t = t+1500
      print("bo2", t)
    end

    s = coroutine.yield()
  end
end
)


repeat
  local s = nxt.ButtonRead()
until false == (coroutine.resume(co1, s==0) and coroutine.resume(co2, s==0))

--codeExampleEnd 2

--codeExampleStart n -----------------------------------------------------------
-- Using a coroutine to drive a motor back and forth until
-- a button is pressed

SeeSaw1 = coroutine.create(
function ( port, speed, rot )
  local s = true

  nxt.OutputSetRegulation(port,1,1)
  nxt.OutputResetTacho(port,1,1,1)
  
  while s do
    nxt.OutputSetSpeed(port,0x20,speed,rot)
    repeat
      s = coroutine.yield()
      _,_,_,_,_,_,d = nxt.OutputGetStatus( port )
    until d < 3
    speed = -speed
  end
end
)

coroutine.resume(SeeSaw1,1,75,360)
repeat
  local s = nxt.ButtonRead()
until false == coroutine.resume(SeeSaw1,s==0)
--codeExampleEnd n

--codeExampleStart n -----------------------------------------------------------


function TurnWait( port, co )
  local s,v = coroutine.resume( co )
  local _,_,_,_,_,_,d = nxt.OutputGetStatus( port )
  return  s, v, (d < 3) 
end 

function Flipper( port, speed, rot, co )
  return coroutine.create( function ()
    nxt.OutputSetRegulation(port,1,1)
    nxt.OutputResetTacho(port,1,1,1)

    local s,t,v,d = true,0,0,false

    repeat
      while t == 0 do
        s,v = coroutine.resume( co )
        t = t + v
      end

      t = 0
      nxt.OutputSetSpeed(port,0x20, speed,rot)
      repeat
        s,v,d = TurnWait( port, co )
        t = t + v
      until d

      while t == 0 do
        s,v = coroutine.resume( co )
        t = t + v
      end
      
      t = 0
      coroutine.yield(1)

      nxt.OutputSetSpeed(port,0x20,-speed,rot)
      repeat
        s,v,d = TurnWait( port, co )
        t = t + v
      until d

    until s == false
  end ) 
end


function Ticker( n )
  return coroutine.create( function ()
     local t = nxt.TimerRead()
     repeat
       t = t + n
       repeat
         coroutine.yield( 0 )
       until t <= nxt.TimerRead()
       print( "Tick" )
       coroutine.yield( 1 )
     until 0~=nxt.ButtonRead()
  end )
end


function Clock( co )
  repeat
  until false == coroutine.resume( co ) 
end

-- Clock( Ticker( 1000 ) )
-- Clock( Flipper( 1,75,90, Ticker( 1000 ) ) )
-- Clock( Flipper( 2,75,90, Flipper( 1,75,90, Ticker( 1000 ) ) ) )
Clock( Flipper( 3,75,180, Flipper( 2,75,180, Flipper( 1,75,180, Ticker( 1000 ) ) ) ) )

--codeExampleEnd n
