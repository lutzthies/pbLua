-- This is the example code file for the webpage at:
--
-- www.hempeldesigngroup.com/lego/pbLua/tutorial/pbLuaI2C.html

--codeExampleStart 1 -----------------------------------------------------------
-- Initialize port 4 for I2C communication

  nxt.I2CInitPins(4)

-- Use a variable to hold the port number

  port = 4

  nxt.I2CInitPins(port)
--codeExampleEnd 1

--codeExampleStart 2 -----------------------------------------------------------
-- setupI2C() - sets up the specified port to handle an I2C sensor

function setupI2C(port)
  nxt.InputSetType(port,2)
  nxt.InputSetDir(port,1,1)
  nxt.InputSetState(port,1,1)

  nxt.I2CInitPins(port)
end

-- Now put the standard I2C messages into the nxt table
nxt.I2Cversion    = string.char( 0x02, 0x00 )
nxt.I2Cproduct    = string.char( 0x02, 0x08 )
nxt.I2Ctype       = string.char( 0x02, 0x10 )
nxt.I2Ccontinuous = string.char( 0x02, 0x41, 0x02 )
nxt.I2Cdata       = string.char( 0x02, 0x42 )
--codeExampleEnd 2

--codeExampleStart 3 -----------------------------------------------------------
-- Use the ultrasound sensor in port 4, make sure the
-- previous sample has been loaded

setupI2C(4)

-- Now send the product string, up to 8 bytes can be sent by the sensor

nxt.I2CSendData( 4, nxt.I2Cproduct, 8 )
--codeExampleEnd 3

--codeExampleStart 4 -----------------------------------------------------------
-- Reading the data is simple. Make sure the previous example has been
-- loaded. The = notation is a short form for "print"

=nxt.I2CRecvData(4)
--codeExampleEnd 4

--codeExampleStart 5 -----------------------------------------------------------
-- waitI2C() - sits in a tight loop until the I2C system goes idle

function waitI2C( port )
  while( 0 ~= nxt.I2CGetStatus( port ) ) do
  end
end
--codeExampleEnd 5

--codeExampleStart 6 -----------------------------------------------------------
-- Put it all together in a function that prints out a report of which
-- sensor is connected to a port

function checkI2C(port)
  setupI2C(port)

  nxt.I2CSendData( port, nxt.I2Cversion, 8 )
  waitI2C( port )
  print( "Version    -> " .. nxt.I2CRecvData( port, 8 ) )

  nxt.I2CSendData( port, nxt.I2Cproduct, 8 )
  waitI2C( port )
  print( "Product ID -> " .. nxt.I2CRecvData( port, 8 ) )

  nxt.I2CSendData( port, nxt.I2Ctype, 8 )
  waitI2C( port )
  print( "SensorType -> " .. nxt.I2CRecvData( port, 8 ) )
end

-- And now run the function to see if it recognizes the sensor
checkI2C(4)

-- Results are below, do not paste the following text to the console!
Version    -> V1.0
Product ID -> LEGO
SensorType -> Sonar
--codeExampleEnd 6

--codeExampleStart 7 -----------------------------------------------------------
function I2CRead(port)
  -- Set up the port and report on the sensor type
  checkI2C(port)

  -- Put it into continuous sample mode
  nxt.I2CSendData( port, nxt.I2Ccontinuous, 0 )
  waitI2C( port )

  -- Read and print the results until the orange button is pressed

  repeat
    -- Read 8 bytes of data from the sensor
    nxt.I2CSendData( port, nxt.I2Cdata, 8 )
    waitI2C( port )
    s = nxt.I2CRecvData( port, 8 )

    -- Break the resulting string into 8 bytes and print the results
    c1,c2,c3,c4,c5,c6,c7,c8 = string.byte(s,1,8)
    print( string.format( "Result: %3i %3i %3i %3i %3i %3i %3i %3i",
                                    c1, c2, c3, c4, c5, c6, c7, c8 ) )
  until( 8 == nxt.ButtonRead() )
end

-- And using the function - press the orange button on the NXT to stop it
I2CRead(4)
--codeExampleEnd 7

--codeExampleStart n -----------------------------------------------------------
--codeExampleEnd n


