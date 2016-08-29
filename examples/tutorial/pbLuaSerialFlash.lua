-- Daniel, here's a full example that works on stock pbLua
-- as currently distributed on my website

-- Define a function to set up an I2C port

function setupI2C(port)
  nxt.InputSetType(port,2)
  nxt.InputSetDir(port,1,1)
  nxt.InputSetState(port,1,1)

  nxt.I2CInitPins(port)
end

-- And a function to wait for the I2C bus to go idle

function waitI2C( port )
  while( 0 ~= nxt.I2CGetStatus( port ) ) do
  end
end

-- Set up the I2C FLASH memory to be on port 1

port = 1

setupI2C(port)

--  Here's where we write data to the I2C FLASH. The bytes
--  are ordered like this:
--
--  A0 is the device code and address
--  0x45 0x98 are the address bytes in big endian format
--  11 12 13 14 are the bytes to write
--
--  Since the total write string can be only 16 bytes long, you
--  can only write 13 bytes of data, so round it down to 8 or 12
--
--  What makes this a write? The 3rd parameter to the I2CSendData
--  function is 0, which means no restart!

memstr = string.char( 0xA0, 0x45, 0x98, 21, 22, 23, 24 )
nxt.I2CSendData( port, memstr, 0 )
waitI2C( port )

--  Here's where we read data from the I2C FLASH. The bytes
--  are ordered like this:
--
--  A0 is the device code and address
--  0x45 0x98 are the address bytes in big endian format
--  11 12 13 14 are the bytes to write
--
--  Since the total read string can be only 16 bytes long, you
--  can read up to 16 bytes at a time (I think)

memstr = string.char( 0xA0, 0x45, 0x98 )
nxt.I2CSendData( port, memstr, 4 )
waitI2C( port )

-- Here's where we read the I2C buffer and print the results
-- byte by byte...

print( string.byte(nxt.I2CRecvData(port),1,4) )

for i=1,1024 do
  memstr = string.char( 0xA0, 0x45, 0x98 )
  nxt.I2CSendData( port, memstr, 16 )
  waitI2C( port )
--  print( string.byte(nxt.I2CRecvData(port),1,16) )
end
