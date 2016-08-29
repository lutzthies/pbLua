-- This is the example code file for the webpage at:
--
-- www.hempeldesigngroup.com/lego/pbLua/tutorial/pbLuaMemory.html

--codeExampleStart 1 -----------------------------------------------------------
-- gcinfo() returns the approximate memory use in K (1024 byte) multiples
>=gcinfo()
16
-- This tells us we are using about 16*1024 = 16,384 bytes
--
-- For a more detailed estimate, use collectgarbage(), like this
-- The first value is the approximate memory use in K (1024 byte) multiples
-- and the second value is the fractional K values (mod 1024)
>=collectgarbage("count")
16      403
-- This tells us we are using about 16*1024 + 403 = 16,787 bytes
--
--Use the second form when you need a more accurate estimate of RAM usage
--codeExampleEnd 1

--codeExampleStart 2 -----------------------------------------------------------
-- Basic heap information available from pbLua
>=nxt.HeapInfo()
454     443     11      6728    2434    4294

-- This tells us two important things:
--
-- We have 454 "chunks" of memory in our heap, 443 are in use, and 11 are free
--
-- We have 6728 "blocks" of memory (each 8 bytes), 2434 are in use, 4294 are free
--codeExampleEnd 2

--codeExampleStart 3 -----------------------------------------------------------
>nxt.HeapInfo(1)

Dumping the umm_heap...
|0x00201fb8|B     0|NB     1|PB     0|Z     1|NF  3096|PF     0|
|0x00201fc0|B     1|NB    43|PB     0|Z    42|
|0x00202110|B    43|NB    68|PB     1|Z    25|
...
|0x00208118|B  3116|NB  3120|PB  3111|Z     4|
|0x00208138|B  3120|NB  3124|PB  3116|Z     4|
|0x00208158|B  3124|NB  3130|PB  3120|Z     6|NF  3148|PF  3096|
|0x00208188|B  3130|NB  3133|PB  3124|Z     3|
|0x002081a0|B  3133|NB  3144|PB  3130|Z    11|
|0x002081f8|B  3144|NB  3148|PB  3133|Z     4|
|0x00208218|B  3148|NB  3149|PB  3144|Z     1|NF  3070|PF  3124|
|0x00208220|B  3149|NB     0|PB  3148|Z  3580|NF     0|PF   136|
Total Entries   607    Used Entries   563    Free Entries    44
Total Blocks   6728    Used Blocks   3072    Free Blocks   3656

-- This somewhat truncated wiew of the heap dump lets you figure out exactly
-- how fragmented the heap is - if you are so inclined
--codeExampleEnd 3

--codeExampleStart 4 -----------------------------------------------------------
-- Dump the contents of the "debug" table using the pairs() iterator, the
-- following output is slightly altered for readability...
>for k,v in pairs(debug) do print(k,v) end
getupvalue      function:0x204214
debug           function:0x2040ec
sethook         function:0x204264
getmetatable    function:0x2041fc
gethook         function:0x20411c
setmetatable    function:0x2042d4
setlocal        function:0x20429c
traceback       function:0x204324
setfenv         function:0x20424c
getinfo         function:0x204154
setupvalue      function:0x2042ec
getlocal        function:0x20418c
getregistry     function:0x2041c4
getfenv         function:0x204104
--codeExampleEnd 4

--codeExampleStart 5 -----------------------------------------------------------
-- This example shows the RAM savings we get by eliminating the debug table
--
-- First, do a round of garbage collection...
=collectgarbage()

-- Now print out the current memory usage...
=collectgarbage("count")
16      776

-- That's (16*1024)+776 = 17160 bytes in use
--
-- Now let's delete the debug table, do a round of garbage collection, and
-- print the new memory usage...

debug=nil
=collectgarbage()

-- Now print out the current memory usage...
=collectgarbage("count")
15      938

-- That's (15*1024)+939 = 16299 bytes in use
--codeExampleEnd 5

--codeExampleStart 6 -----------------------------------------------------------
-- Now delete the table, string, and nxt libraries and see how much RAM is
-- in use...
table=nil
string=nil
nxt=nil
=collectgarbage()

-- Now print out the current memory usage...
=collectgarbage("count")
7       698

-- That's (7*1024)+698 = 7866 bytes in use - a pretty decent savings!
--codeExampleEnd 6

--codeExampleStart 7 -----------------------------------------------------------
-- What does require() return?
>=require()
table:0x204c74

-- It's a table, so let's put the table through an iterator to what's in it...
>for k,v in pairs(require()) do print(k,v) end
1       all
2       table
3       string
4       debug
5       nxt_misc
6       nxt_bt
7       nxt_math
8       nxt_file
9       nxt_output
10      nxt_display
11      nxt_i2c
12      nxt_rs485
13      nxt_input
14      nxt_sound
--codeExampleEnd 7

--codeExampleStart 8 -----------------------------------------------------------
-- First, let's dump debug - it should give an error since it's gone...
for k,v in pairs(debug) do print(k,v) end
tty: stdin:1: bad argument #1 to 'pairs' (table expected, got nil)

-- Now let's load up the debug library and dump it. I've reformatted the
-- output slightly...
require("debug")
for k,v in pairs(debug) do print(k,v) end
getupvalue      function:0x204ccc
debug           function:0x203274
sethook         function:0x204c7c
getmetatable    function:0x204ce4
gethook         function:0x203734
setmetatable    function:0x20315c
setlocal        function:0x204c44
traceback       function:0x20310c
setfenv         function:0x204c94
getinfo         function:0x2036fc
setupvalue      function:0x203144
getlocal        function:0x204d54
getregistry     function:0x204d1c
getfenv         function:0x20374c
--codeExampleEnd 8

--codeExampleStart n -----------------------------------------------------------
--codeExampleEnd n


