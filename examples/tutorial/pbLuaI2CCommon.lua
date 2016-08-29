-- This is the example code file for the tutorials at:
--
-- www.hempeldesigngroup.com/lego/pblua/tutorial/
--
-- These routines are basic helper functions to make dealing with
-- the I2C sensor ports a bit easier.

--codeExampleStart 1 -----------------------------------------------------------
-- setupI2C() - sets up the specified port to handle an I2C sensor

function setupI2C(port)
  nxt.InputSetType(port,11)
  nxt.I2CInitPins(port)
end

-- These are functions that return strings that can be used to
-- access any register in any I2C device. All you need to pass
-- in as parameters are the device address and the register you
-- want to start reading from.
--
function nxt.I2CReadString( devaddr, regaddr )
  return string.char( devaddr, regaddr )
end

-- Now we'll add 4 generic helpers to get strings from the standard
-- registers for use with the LEGO MINDSTORMS NXT sensors
--
function nxt.I2Cversion( devaddr )
  return nxt.I2CReadString( devaddr, 0x00 )
end

function nxt.I2Cproduct( devaddr )
  return nxt.I2CReadString( devaddr, 0x08 )
end

function nxt.I2Ctype( devaddr )
  return nxt.I2CReadString( devaddr, 0x10 )
end

function nxt.I2Cdata( devaddr )
  return nxt.I2CReadString( devaddr, 0x42 )
end

-- waitI2C() - sits in a tight loop until the I2C system goes idle, there
--             are better ways to do this, but this is good enough for
--             now

function waitI2C( port )
  while( 0 ~= nxt.I2CGetStatus( port ) ) do
  end
end

-- Put it all together in a function that prints out a report of which
-- sensor is connected to a port
--
-- Recall that nxt.I2CSendData() is capable of write/read operation. In
-- other words, if you want to read 8 bytes of data starting at the
-- ProductId field, just send the correct string and specify 8 bytes in
-- the receive data parameter. All nxt.I2CRecvData() does is read the
-- bytes out of the buffer that the nxt.I2CSendData() filled up!

function checkI2C( port, devaddr )
  setupI2C(port)

  nxt.I2CSendData( port, nxt.I2Cversion( devaddr ), 8 )
  waitI2C( port )
  print( "Version    -> " .. nxt.I2CRecvData( port, 8 ) )

  nxt.I2CSendData( port, nxt.I2Cproduct( devaddr ), 8 )
  waitI2C( port )
  print( "Product ID -> " .. nxt.I2CRecvData( port, 8 ) )

  nxt.I2CSendData( port, nxt.I2Ctype( devaddr ), 8 )
  waitI2C( port )
  print( "SensorType -> " .. nxt.I2CRecvData( port, 8 ) )
end

-- For an I2C device on port 1, all you need to do is:

checkI2C(1,2)
--codeExampleEnd 1

--codeExampleStart n -----------------------------------------------------------
--codeExampleEnd n


