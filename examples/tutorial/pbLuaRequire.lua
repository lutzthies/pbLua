-- This is the example code file for the webpage at:
--
-- www.hempeldesigngroup.com/lego/pbLua/tutorial/pbLuaRequire.html

--codeExampleStart 1 -----------------------------------------------------------

--  "all" 
--
nxt_names = { 
                "nxt_misc" 
              , "nxt_bt"
              , "nxt_file"
              , "nxt_output"
              , "nxt_display"
              , "nxt_i2c"
              , "nxt_rs485"
              , "nxt_input"
              , "nxt_sound" }

--              , "nxt_math"
              
for _,s in pairs(nxt_names) do print(s) end

for k,v in pairs(list())      do print(k,v) end
for k,v in pairs(list(nil))   do print(k,v) end
for k,v in pairs(list("foo")) do print(k,v) end

for _,s in pairs(nxt_names) do 
  print( "----" .. s .. "----" )
  for k,v in pairs(list(s)) do print(k,v) end
end
--codeExampleEnd 1

require()
require(nil)
require("foo")

for _,s in pairs(nxt_names) do 
  print( "----" .. s .. "----" )
  require(s) 
end

unload()
unload(nil)
unload("foo")

for _,s in pairs(nxt_names) do 
  print( "----" .. s .. "----" )
  unload(s) 
end

for k,v in pairs(_G) do print(k,v) end

for k,v in pairs(nxt) do print(k,v) end

for _,s in pairs(nxt_names) do 
  print( "----" .. s .. "----" )
  require(s) 
end

              , "nxt_bt"
              , "nxt_sound" }

require("all")

require("nxt_misc")
require("nxt_bt")
require("nxt_file")
require("nxt_output")
require("nxt_display")
require("nxt_i2c")
require("nxt_rs485")
require("nxt_input")
require("nxt_sound")


for k,v in pairs(string) do nxt[k]=nil end
for k,v in pairs(table) do nxt[k]=nil end
for k,v in pairs(debug) do nxt[k]=nil end

string=nil
table=nil
debug=nil


=collectgarbage("count")
=collectgarbage()
=collectgarbage("count")
=collectgarbage()
=collectgarbage("count")
=collectgarbage()
=collectgarbage("count")
=collectgarbage()
=collectgarbage("count")
=collectgarbage()
=collectgarbage("count")
=collectgarbage()
=collectgarbage("count")
=collectgarbage()
=collectgarbage("count")


for k,v in pairs(nxt) do nxt[k]=nil end
for k,v in pairs(foo) do foo[k]=nil end


foo = {}
for k,v in pairs(nxt) do foo[k]=nxt[k] end

nxt=nil


=collectgarbage("count")
=collectgarbage()
=collectgarbage("count")
=collectgarbage()
=collectgarbage("count")
=collectgarbage()
=collectgarbage("count")
=collectgarbage()
=collectgarbage("count")
=collectgarbage()
=collectgarbage("count")
=collectgarbage()
=collectgarbage("count")
=collectgarbage()
=collectgarbage("count")


for k,v in pairs(_G) do print(k,v) end

nxt_names = { 
                "nxt_misc" 
              , "nxt_file"
              , "nxt_output"
              , "nxt_display"
              , "nxt_i2c"
              , "nxt_rs485"
              , "nxt_input"
              , "nxt_file"
              , "nxt_output"
              , "nxt_display"
              , "nxt_i2c"
              , "nxt_rs485"
              , "nxt_input"
              , "nxt_file"
              , "nxt_output"
              , "nxt_display"
              , "nxt_i2c"
              , "nxt_rs485"
              , "nxt_input"
              , "nxt_file"
              , "nxt_output"
              , "nxt_display"
              , "nxt_i2c"
              , "nxt_rs485"
              , "nxt_input"
              , "nxt_file"
              , "nxt_output"
              , "nxt_display"
              , "nxt_i2c"
              , "nxt_rs485"
              , "nxt_input"
              , "nxt_file"
              , "nxt_output"
              , "nxt_display"
              , "nxt_i2c"
              , "nxt_rs485"
              , "nxt_input"
              , "nxt_file"
              , "nxt_output"
              , "nxt_display"
              , "nxt_i2c"
              , "nxt_rs485"
              , "nxt_input"
              , "nxt_file"
              , "nxt_output"
              , "nxt_display"
              , "nxt_i2c"
              , "nxt_rs485"
              , "nxt_input"
              , "nxt_file"
              , "nxt_output"
              , "nxt_display"
              , "nxt_i2c"
              , "nxt_rs485"
              , "nxt_input"
              , "nxt_file"
              , "nxt_output"
              , "nxt_display"
              , "nxt_i2c"
              , "nxt_rs485"
              , "nxt_input"
            }


for _,s in pairs(nxt_names) do 
  print( "----" .. s .. "----" )
  require(s) 
end

for k,v in pairs(nxt) do nxt[k]=nil end
nxt=nil

=collectgarbage("count")
=collectgarbage()
=collectgarbage("count")
=collectgarbage()
=collectgarbage("count")
=collectgarbage()
=collectgarbage("count")
=collectgarbage()
=collectgarbage("count")
=collectgarbage()
=collectgarbage("count")
=collectgarbage()
=collectgarbage("count")
=collectgarbage()
=collectgarbage("count")

--codeExampleStart n -----------------------------------------------------------
--codeExampleEnd n

