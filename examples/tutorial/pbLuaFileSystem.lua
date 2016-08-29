-- This is the example code file for the webpage at:
--
-- www.hempeldesigngroup.com/lego/pbLua/tutorial/pbLuaFileSystem.html

--codeExampleStart 1 -----------------------------------------------------------
-- Format the FLASH file system, erasing all files:
nxt.FileFormat(1)

-- Format the FLASH file system, moves the file descriptor block to a new
-- location, makes erased descriptors usable, leaves exiting files untouched:
nxt.FileFormat(0)
--codeExampleEnd 1

--codeExampleStart 2 -----------------------------------------------------------
-- Return information on the pbLua filesystem
function FileSysInfo()
  files, blocks, blockSize = nxt.FileSysInfo()

  print( "Total File Descriptors -> " .. files  )
  print( "Total FLASH Blocks     -> " .. blocks )
  print( "FLASH Block Size       -> " .. blockSize .. " bytes" )
end
--codeExampleEnd 2

--codeExampleStart r2 -----------------------------------------------------------
-- Print out the FLASH File System Information
FileSysInfo()

-- Results are below, do not paste the following text to the console!
Total File Descriptors -> 31
Total FLASH Blocks     -> 374
FLASH Block Size       -> 256 bytes
--codeExampleEnd r2

--codeExampleStart 3 -----------------------------------------------------------
-- Return information on the pbLua filesystem
function DumpFileDesc(from,to)

  print( "Type Name         Block MaxBytes CurBytes CurPtr" )

  for h=from,to do
    print( string.format( "%4i %12s %5i %5i    %5i    %8i", nxt.FileHandleInfo(h) ) )
  end
end
--codeExampleEnd 3

--codeExampleStart r3 -----------------------------------------------------------
-- Dump all of the file descriptors
DumpFileDesc(0,31)

-- Results are below, do not paste the following text to the console!
Type Name         Block MaxBytes CurBytes CurPtr
   3 pbLuaFileSys     0   512        0     1214976
   1 ÿÿÿÿÿÿÿÿÿÿÿÿ 65535 65535        0    17991936
   1 ÿÿÿÿÿÿÿÿÿÿÿÿ 65535 65535        0    17991936
   1 ÿÿÿÿÿÿÿÿÿÿÿÿ 65535 65535        0    17991936
   ... 
--codeExampleEnd r3

--codeExampleStart 4 -----------------------------------------------------------
function Hello()
  nxt.DisplayClear()
  nxt.DisplayText( "Hello, World!" )
end
--codeExampleEnd 4

--codeExampleStart 5 -----------------------------------------------------------
programString = [[
nxt.DisplayClear()
nxt.DisplayText( "Hello, World!" )
]]
--codeExampleEnd 5

--codeExampleStart 6 -----------------------------------------------------------
-- Print the number of bytes in the string:
=string.len( programString )

-- Or do it a bit fancier:
print( "programString has " .. string.len( programString ) .. " bytes" )

-- Compile the string into a function:
test = loadstring( programString )

-- And run it, but clear the display first:
nxt.DisplayClear()
test()
--codeExampleEnd 6

--codeExampleStart 7 -----------------------------------------------------------
programString = [[
nxt.DisplayClear()
nxt.DisplayText( "Hello, World!" )
]]

-- Create the file, save the handle so we can use it later...
h = nxt.FileCreate( "hello", 128 )

-- Now write the string...
nxt.FileWrite( h, programString )

-- And close the file...
nxt.FileClose( h )
--codeExampleEnd 7

--codeExampleStart r7 -----------------------------------------------------------
-- Now let's dump the first few file descriptors to see what we get:
DumpFileDesc(0,3)

-- Results are below, do not paste the following text to the console!
Type Name         Block MaxBytes CurBytes CurPtr
   3 pbLuaFileSys     0   512        0     1214976
   5        hello     2    54        0     1215488
   1 ÿÿÿÿÿÿÿÿÿÿÿÿ 65535 65535        0    17991936
   1 ÿÿÿÿÿÿÿÿÿÿÿÿ 65535 65535        0    17991936
   ...
--codeExampleEnd r7

--codeExampleStart 8 -----------------------------------------------------------
-- Read the whole file as a string
h = nxt.FileOpen("hello")
s = nxt.FileRead(h,"*a")
nxt.FileClose(h)

print( s )

-- Results are below, do not paste the following text to the console!
nxt.DisplayClear()
nxt.DisplayText( "Hello, World!" )
--codeExampleEnd 8


--codeExampleStart 9 -----------------------------------------------------------
-- Read the whole file a line at a time
h = nxt.FileOpen("hello")
repeat
  s = nxt.FileRead(h,"*l")
  print( string.len(s or ""), s )
until nil == s
nxt.FileClose(h)

-- Results are below, do not paste the following text to the console!
--
-- Note that the value returned for the last line is nil, we've
-- arranged to have it printed here. Normally you would not print it.
18      nxt.DisplayClear()
34      nxt.DisplayText( "Hello, World!" )
0       nil:0x0
--codeExampleEnd 9

--codeExampleStart 10 -----------------------------------------------------------
-- Read the whole file 7 bytes at a time
h = nxt.FileOpen("hello")
repeat
  s = nxt.FileRead(h,7)
  print( string.len(s or ""), s )
until nil == s
nxt.FileClose(h)

-- Results are below, do not paste the following text to the console!
7       nxt.Dis
7       playCle
7       ar()
nx
7       t.Displ
7       ayText(
7        "Hello
7       , World
5       !" )

0       nil:0x0
--codeExampleEnd 10

--codeExampleStart 11 -----------------------------------------------------------
-- Read a file into a function that can be executed
f = nxt.loadfile("hello")

-- And now run the funtion to see the result
f()
--codeExampleEnd 11

--codeExampleStart 12 -----------------------------------------------------------
-- Read the file and execute it all at once
nxt.dofile("hello")
--codeExampleEnd 12

--codeExampleStart 13 -----------------------------------------------------------
-- Run the file chooser and return the name of the file chosen:
print( nxt.FileChooser("name") )

-- Or more simply...
print( nxt.FileChooser() )
--codeExampleEnd 13

--codeExampleStart 13a -----------------------------------------------------------
-- Run the file chooser and return the contents of the file chosen:
print( nxt.FileChooser("file") )
--codeExampleEnd 13a

--codeExampleStart 14 -----------------------------------------------------------
-- Run the file chooser and load the contents of the file into a function:
=nxt.FileChooser("loadfile")

-- Whoops, let's put it into a functioon and execute it...
f=nxt.FileChooser("loadfile")
f()
--codeExampleEnd 14

--codeExampleStart 15 -----------------------------------------------------------
-- Run the file chooser and execute the contents of the file
> =nxt.FileChooser("dofile")
--codeExampleEnd 15

--codeExampleStart 16 -----------------------------------------------------------
-- Run the file chooser and execute the contents of the file, but only give the
-- user 5 seconds to make up their mind
> =nxt.FileChooser("dofile",5)
--codeExampleEnd 16

--codeExampleStart 17 -----------------------------------------------------------
programString = [[
nxt.FileChooser("dofile")

melody = string.char(0x02, 0x00, 0x04, 0x00,
                     0x01, 0x00, 0x04, 0x00,
                     0x02, 0x00, 0x02, 0x00,
                     0x03, 0x00, 0x02, 0x00,
                     0x01, 0x00, 0x01, 0x00,
                     0x03, 0x00, 0x01, 0x00)
                     
while 0 == nxt.SoundMelody( melody, 1 ) do
-- do nothing
end
]]

h = nxt.FileCreate( "pbLuaStartup", 512 )

-- Now write the string...
nxt.FileWrite( h, programString )

-- And close the file...
nxt.FileClose( h )
--codeExampleEnd 17


--codeExampleStart n -----------------------------------------------------------
--codeExampleEnd n


