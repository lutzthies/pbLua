-- This is the example code file for the webpage at:
--
-- www.hempeldesigngroup.com/lego/pbLua/tutorial/pbLuaGPS.html

--codeExampleStart 1 -----------------------------------------------------------
-- Turn the Bluetooth radio off:
nxt.BtPower(0)
  
-- Turn the Bluetooth radio on:
nxt.BtPower()
  
-- or
nxt.BtPower(1)
--codeExampleEnd 1

--codeExampleStart 2 -----------------------------------------------------------
-- Reset the Bluetooth subsystem to factory defaults. Note theat this does
-- not reset the firmware, just the device tables. You'll need to do a fresh
-- search of the Bluetooth devices
nxt.BtFactoryReset()
  
-- Turn the visibility of the NXT on:
nxt.BtVisible() 
  
-- Turn the visibility of the NXT off:
nxt.BtVisible(0)
  
-- Start searching for other visible Bluetooth devices:
nxt.BtSearch()
  
-- Abort the search:
nxt.BtSearch(0)
--codeExampleEnd 2

--codeExampleStart 3 -----------------------------------------------------------
-- Turn on the Bluetoorh radio, make the NXT visible and search for
-- other devices
function btIdleWait()
    local active
    repeat
      _,active = nxt.BtGetStatus()
    until 17 == active
end
       
nxt.BtPower()
btIdleWait()
  
nxt.BtVisible()
btIdleWait()

nxt.BtSearch() -- This takes about 20 seconds!
btIdleWait()
  
-- Now you're ready to use the Bluetooth system!</pre>
--codeExampleEnd 3

--codeExampleStart 4 -----------------------------------------------------------
-- Turn on the Bluetooth system but make the NXT invisible to discovery
nxt.BtPower()
nxt.BtVisible(0)
--codeExampleEnd 4

--codeExampleStart 5 -----------------------------------------------------------
-- Make the NXT visible to discovery
nxt.BtVisible()
--codeExampleEnd 5

--codeExampleStart 6 -----------------------------------------------------------
-- Change the name of the NXT
nxt.BtSetName("Frodo")
--codeExampleEnd 6

--codeExampleStart 7 -----------------------------------------------------------
-- Search for the NXT
nxt.BtSearch() -- This takes about 20 seconds!
btIdleWait()
--codeExampleEnd 7

--codeExampleStart 8 -----------------------------------------------------------
-- btMonitor(n) monitors the Bluetooth system for n seconds and
--              prints a message any time there's a change

function btMonitor( n )
  local t = nxt.TimerRead()
  local oldState, oldActive, oldUpdate
  
  repeat
    state, active, update = nxt.BtGetStatus()
    if (state ~= oldState) or (active ~= oldActive) or (update ~= oldUpdate) then
      print( nxt.TimerRead() - t, state, active, update )
      oldState  = state
      oldActive = active
      oldUpdate = update
    end
  until t+n < nxt.TimerRead()
end
--codeExampleEnd 8

--codeExampleStart 9 -----------------------------------------------------------
btMonitor(30000)
--codeExampleEnd 9

--codeExampleStart 10 -----------------------------------------------------------
-- Set the PIN in your NXT
nxt.BtSetPIN("yourPIN")  -- Put your own PIN in the quotes!
--codeExampleEnd 10

--codeExampleStart 11 -----------------------------------------------------------
-- btDevice(n) dumps the first n entries in the Bluetooth device table

function btDevice( n )
  for idx=0,n-1 do
    name, class, addr, status = nxt.BtGetDeviceEntry( idx )
   
    -- Format the BT device address
    addr = string.format("%02x:%02x:%02x:%02x:%02x:%02x", string.byte( addr, 1, 6 ) )
   
    -- Format the BT class
    class = string.format("%02x:%02x:%02x:%02x", string.byte( class, 1, 4 ))

    -- Print the device info
    print(string.format("Name:%16s Addr:%s Class:%s Status:%i",name,addr,class,status))
  end
end
--codeExampleEnd 11

--codeExampleStart 12 -----------------------------------------------------------
-- Dump the first 4 entries in the device table
btDevice(4)

-- Results are below, do not paste the following text to the console!
Name:                 Addr:00:00:00:00:00:00 Class:00:00:00:00 Status:0
Name:                 Addr:00:00:00:00:00:00 Class:00:00:00:00 Status:0
Name:                 Addr:00:00:00:00:00:00 Class:00:00:00:00 Status:0
Name:                 Addr:00:00:00:00:00:00 Class:00:00:00:00 Status:0
--codeExampleEnd 12

--codeExampleStart 13 -----------------------------------------------------------
-- Initiate a new search for Bluetooth devices
nxt.BtSearch()
btMonitor(30000)

-- Results are below, do not paste the following text to the console!
0       65      10      3
13822   65      10      4
13823   65      10      5
15630   65      10      4
15631   65      17      0
--codeExampleEnd 13

--codeExampleStart 14 -----------------------------------------------------------
-- Dump the first 4 entries in the device table
btDevice(4)

-- Results are below, do not paste the following text to the console!
Name:  Ralph DellD610 Addr:00:10:c6:62:f6:ba Class:00:1c:01:0c Status:65
Name:                 Addr:00:00:00:00:00:00 Class:00:00:00:00 Status:0
Name:                 Addr:00:00:00:00:00:00 Class:00:00:00:00 Status:0
Name:                 Addr:00:00:00:00:00:00 Class:00:00:00:00 Status:0
--codeExampleEnd 14

--codeExampleStart 15 -----------------------------------------------------------
-- btConnect() dumps all the connection entries in the Bluetooth connection
--             table
function  btConnect()
  for idx=0,3 do
    name, class, pin, addr, handle, status, linkq = nxt.BtGetConnectEntry( idx )

    -- Format the BT device address
    addr = string.format("%02x:%02x:%02x:%02x:%02x:%02x", string.byte( addr, 1, 6 ) )

    -- Format the BT class
    class = string.format("%02x:%02x:%02x:%02x", string.byte( class, 1, 4 ))

    -- Print the connection info
    print(string.format("Name:%16s Addr:%s Class:%s PIN:%s Status:%i",name,addr,class,pin,status))
  end
end
--codeExampleEnd 15

--codeExampleStart 16 -----------------------------------------------------------
-- Summarize the Bluetooth connection table
btConnect()

-- Results are below, do not paste the following text to the console!
Name:                 Addr:00:10:c6:62:f6:ba Class:00:00:00:00 PIN:xyzzy Status:0
Name:                 Addr:00:00:00:00:00:00 Class:00:00:00:00 PIN: Status:0
Name:                 Addr:00:00:00:00:00:00 Class:00:00:00:00 PIN: Status:0
Name:                 Addr:00:00:00:00:00:00 Class:00:00:00:00 PIN: Status:0
--codeExampleEnd 16

--codeExampleStart 17 -----------------------------------------------------------
-- Connect device 0 to channel 0
nxt.BtConnect(0,0)
--codeExampleEnd 17

----codeExampleStart 18 -----------------------------------------------------------
-- Dump the connection table again
btConnect()

-- Results are below, do not paste the following text to the console!
Name:  Ralph DellD610 Addr:00:10:c6:62:f6:ba Class:f8:7a:01:0c PIN: Status:1
Name:                 Addr:00:00:00:00:00:00 Class:00:00:00:00 PIN: Status:0
Name:                 Addr:00:00:00:00:00:00 Class:00:00:00:00 PIN: Status:0
Name:                 Addr:00:00:00:00:00:00 Class:00:00:00:00 PIN: Status:0
--codeExampleEnd 18

----codeExampleStart 19 -----------------------------------------------------------
-- Put the NXT Bluetooth into raw streaming mode, and send some text
nxt.BtStreamMode(1)
nxt.BtStreamSend(0,"Hello world!")

-- And disconnect if we're done...
nxt.BtDisconnect(0)
--codeExampleEnd 19

----codeExampleStart 20 -----------------------------------------------------------
-- Search for the Navibe
nxt.BtSearch()

-- Wait 20 seconds, then dump the device table to see if we can find it
btDevice(4)

-- Results are below, do not paste the following text to the console!
Name:  Ralph DellD610 Addr:00:10:c6:62:f6:ba Class:f8:7a:01:0c Status:66
Name:      BT GPS V10 Addr:00:0a:3a:24:33:97 Class:00:00:1f:00 Status:65
Name:                 Addr:00:00:00:00:00:00 Class:00:00:00:00 Status:0
Name:                 Addr:00:00:00:00:00:00 Class:00:00:00:00 Status:0
--codeExampleEnd 20

----codeExampleStart 21 -----------------------------------------------------------
nxt.BtConnect(1,1) -- Device 1, connection 1

-- You may have to also set the PIN for successful connection...
nxt.BtSetPIN("0000")
--codeExampleEnd 21

----codeExampleStart 22 -----------------------------------------------------------
$GPGSA,A,2,,,,,,,,,,,,,50.0,50.0,50.0*06
$GPRMC,140817.000,V,4433.2983,N,08056.3970,W,1.42,77.42,020707,,,E*51
$GPGGA,140818.000,4433.2984,N,08056.3964,W,6,00,50.0,168.7,M,-36.0,M,,0000*5C
$GPGSA,A,2,,,,,,,,,,,,,50.0,50.0,50.0*06
$GPRMC,140818.000,V,4433.2984,N,08056.3964,W,1.42,77.42,020707,,,E*5C
$GPGGA,140819.000,4433.2984,N,08056.3959,W,6,00,50.0,168.7,M,-36.0,M,,0000*53
$GPGSA,A,2,,,,,,,,,,,,,50.0,50.0,50.0*06
$GPGSV,3,1,10,18,71,320,30,21,62,184,32,09,46,130,,22,36,290,20*79
$GPGSV,3,2,10,24,29,154,,26,28,050,22,29,18,052,,03,13,300,*78
$GPGSV,3,3,10,14,12,233,,19,07,327,*75
$GPRMC,140819.000,V,4433.2984,N,08056.3959,W,1.42,77.42,020707,,,E*53
$GPGGA,140820.000,4433.2985,N,08056.3954,W,6,00,50.0,168.7,M,-36.0,M,,0000*55
$GPGSA,A,2,,,,,,,,,,,,,50.0,50.0,50.0*06
$GPRMC,140820.000,V,4433.2985,N,08056.3954,W,1.42,77.42,020707,,,E*55
$GPGGA,140821.000,4433.2985,N,08056.3948,W,6,00,50.0,168.7,M,-36.0,M,,0000*59
$GPGSA,A,2,,,,,,,,,,,,,50.0,50.0,50.0*06
--codeExampleEnd 22

----codeExampleStart 23 -----------------------------------------------------------
-- Connect, set to stream mode, and then send a dummy character to
-- get communications running. Remember to have btIdleWait() loaded !
nxt.BtConnect(1,1) 
btIdleWait()
nxt.BtStreamMode(1)
nxt.BtStreamSend(1,"")

-- Wait a few seconds for BT data to accumulate, then enter:
print(nxt.BtStreamRecv())

-- Results are below, do not paste the following text to the console!
$GPRMC,170837.063,A,4433.3037,N,08056.4227,W,3.28,309.27,161108,,,D*70
$GPGGA,170838.063,4433.3023,N,08056.4205,W,2,03,2

-- Now disconnect
nxt.BtDisconnect(1)
--codeExampleEnd 23

----codeExampleStart 24 -----------------------------------------------------------
-- Code to parse out a GPGGA string
function parseGPGGA (s)
   print( s )
   _,_,time,lat,ns,long,ew,_,_,_,alt = string.find(s, 
     "([^,]+),([^,]+),([NS]),([^,]+),([EW]),([^,]+),([^,]+),([^,]+),([^,]+)")
   
   -- If we have a valid string, then update the NXT display
   
   if( nil ~= alt ) then
     print( time,lat,ns,long,ew,alt )
     nxt.DisplayText( string.format( "Time %s",  time),       0,  0 )
     nxt.DisplayText( string.format( "Lat  %s%s", lat, ns),   0,  8 )
     nxt.DisplayText( string.format( "Long %s%s", long, ew),  0, 16 )
     nxt.DisplayText( string.format( "Alt  %sm",  alt),       0, 24 )
   end
end

-- Main routine that looks for strings from the 
function btGPS( timeout )
  local t=nxt.TimerRead()
  local s
  local gps = ""
  
  nxt.DisplayClear()

  -- And now loop until we get fully formed GPS messages
  while( t+timeout > nxt.TimerRead() ) do
  
    -- Get and available GPS data from the BT device
    s = nxt.BtStreamRecv()

    if s then
--      print( "--" .. s )
      
      gps = gps .. s
      
      start = string.find( gps, "\$GP", 2 )
      
      while nil ~= start do
      
        if start > 1 then
          -- Here's where we pull out an entire $GP string
          
          data = string.sub( gps, 1, start-2 )
          _,_,sentence,data = string.find( data, "\$GP(%u+),(.+)" )
          
          -- And check to see if it's one we're interested in
          
          if "GGA" == sentence then
            parseGPGGA( data )
          end
          
          -- Here's where you can parse other strings...
          
          -- And now skip over the string we just parsed to get ready for
          -- the next one 
          
          gps = string.sub( gps, start, -1 )
        
        end
        start = string.find( gps, "\$GP", 2 )
      end
    end
  end
end
--codeExampleEnd 24

----codeExampleStart 25 -----------------------------------------------------------
-- Set up the connection to the Navibe GPS
nxt.BtConnect(1,1) -- Device 1, connection 1
btIdleWait()

-- Put the strean into binary mode
nxt.BtStreamMode(1)
  
-- Do a dummy send to get the NXT to accept streaming data
nxt.BtStreamSend(1,"")

-- And now start reading for 5 seconds
btGPS(5000)

-- Results are below, do not paste the following text to the console!
143115.000      4433.3073       N       08056.3969      W       172.7
143116.000,433.3073,N,08056.3969,W,1,03,2.8,172.7,M,-36.0,M,,0000*65
143116.000      433.3073        N       08056.3969      W       172.7
143117.000,4433.3073,N,08056.3969,W,1,03,2.8,172.7,M,-36.0,M,,0000*64
143117.000      4433.3073       N       08056.3969      W       172.7
143118.000,4433.3073,N,08056.3969,W,1,03,2.8,172.7,M,-36.0,M,,0000*6B
143118.000      4433.3073       N       08056.3969      W       172.7
143119.000,4433.3073,N,08056.3969,W,1,03,2.8,172.7,M,-36.0,M,,0000*6A
143119.000      4433.3073       N       08056.3969      W       172.7
143120.000,4433.3073,N,08056.3969,W,1,03,2.8,172.7,M,-36.0,M,,0000*60
143120.000      4433.3073       N       08056.3969      W       172.7
--codeExampleEnd 25

----codeExampleStart n -----------------------------------------------------------
--codeExampleEnd n

----codeExampleStart n -----------------------------------------------------------
--codeExampleEnd n

