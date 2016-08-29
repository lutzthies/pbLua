-- This is the example code file for the webpage at:
--
-- www.hempeldesigngroup.com/lego/pbLua/tutorial/pbLuaI2C.html

--codeExampleStart 1 -----------------------------------------------------------
function I2CReadProto(port)
    -- Read 14 bytes of data from the sensor
    nxt.I2CSendData( port, nxt.I2Cdata[2], 14 )
    waitI2C( port )
    s = nxt.I2CRecvData( port, 14 )

    -- Break the resulting string into 8 bytes and print the results
    c = {string.byte(s,1,14)}
    
    print( string.format( "Result: %3i %3i %3i %3i %3i %3i %3i %3i",
                                    c[1], c[2], c[3], c[4], c[5], c[6], c[7], c[8] ) )
end

-- And using the function - press the orange button on the NXT to stop it
I2CRead(4)

