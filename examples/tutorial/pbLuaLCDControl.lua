-- This is the example code file for the webpage at:
--
-- www.hempeldesigngroup.com/lego/pbLua/tutorial/pbLuaLCDControl.html

--codeExampleStart 1 -----------------------------------------------------------
-- Hello World! for the LCD Display

nxt.DisplayClear()
nxt.DisplayText( "Hello World!" )
--codeExampleEnd 1

--codeExampleStart 2 -----------------------------------------------------------
-- Writing text to the LCD

nxt.DisplayClear()

nxt.DisplayText( "Line 1",  0,  0 )
nxt.DisplayText( "Line 2",  4,  8 )
nxt.DisplayText( "Line 3",  8, 16 )
nxt.DisplayText( "Line 4", 12, 24 )
nxt.DisplayText( "Line 5", 16, 32 )
nxt.DisplayText( "Line 6", 20, 40 )
nxt.DisplayText( "Line 7", 24, 48 )
nxt.DisplayText( "Line 8", 28, 56 )
--codeExampleEnd 2

--codeExampleStart 3 -----------------------------------------------------------
-- Writing alternating light and dark text to the LCD

nxt.DisplayClear()

nxt.DisplayText( "Line 1",  0,  0, 0   )
nxt.DisplayText( "Line 2",  4,  8, 1   )
nxt.DisplayText( "Line 3",  8, 16      )
nxt.DisplayText( "Line 4", 12, 24, 999 )
nxt.DisplayText( "Line 5", 16, 32, 0   )
nxt.DisplayText( "Line 6", 20, 40, -8  )
nxt.DisplayText( "Line 7", 24, 48, 0   )
nxt.DisplayText( "Line 8", 28, 56, 1   )
--codeExampleEnd 3

--codeExampleStart 4 -----------------------------------------------------------
-- Scrolling the LCD

nxt.DisplayClear()
nxt.DisplayText( "Line 1" )
nxt.DisplayScroll()
nxt.DisplayText( "Line 2" )
nxt.DisplayScroll()
nxt.DisplayText( "Line 3" )
nxt.DisplayScroll()
nxt.DisplayText( "Line 4" )
nxt.DisplayScroll()
--codeExampleEnd 4

--codeExampleStart 5 -----------------------------------------------------------
-- Demonstration of setting random display pixels

function RandomDisplayPixel()
  local x,y
  nxt.DisplayClear()

  for i=1,10000 do
    x = nxt.random(100)
    y = nxt.random(64)
    nxt.DisplayPixel(x,y)
  end

end

-- Another way of writing this without local variables is

function RandomDisplayPixel()
  nxt.DisplayClear()

  for i=1,10000 do
    nxt.DisplayPixel(nxt.random(100),nxt.random(64))
  end

end

-- And an even faster way is

function RandomDisplayPixel()
  nxt.DisplayClear()

  local random = nxt.random
  local DisplayPixel = nxt.DisplayPixel

  for i=1,10000 do
    DisplayPixel(random(100),random(64))
  end

end
--codeExampleEnd 5

--codeExampleStart 6 -----------------------------------------------------------
-- Reading the Display and Writing it to the Console

function DumpDisplay()
 
  -- Set up the header for the XPM file
  --
  s = [[
/* XPM */
static char * _xpm[] = {
"72 108 2 1",
"  c #77cc88",
"* c #000044", ]]

  -- Print the header
  --
  print( s )

  -- Now go ahead and loop through the pixels to print the body of the XPM file
  --
  for x=-4,103 do
    s = ""
    for y=67,-4,-1 do
      if nxt.DisplayGetPixel(x,y) then
        s = s .. "*"
       else
        s = s .. " "
      end
    end

    print( "\"" .. s .. "\"," )
  end

  -- Close off the XPM file
  --
  print( "};" )
end
--codeExampleEnd 6

--codeExampleStart 7 -----------------------------------------------------------
-- main() startup display
nxt.DisplayClear()

nxt.DisplayText( "Wait for BT",    0,  0, 0   )
nxt.DisplayText( "Act 11 Upd 01",  0, 48, 0   )
nxt.DisplayText( "yyyyy Button 0", 0, 56, 0   )

DumpDisplay()
--
--codeExampleEnd 7

--codeExampleStart 8 -----------------------------------------------------------
-- Console Chooser startup display
nxt.DisplayClear()

nxt.DisplayText( "USB Console",    0,  0, 1   )
nxt.DisplayText( "BT Console",     0,  8, 0   )
nxt.DisplayText( "xxxx mV Cells",  0, 24, 0   )
nxt.DisplayText( "OGEL",           0, 40, 0   )
nxt.DisplayText( "yyyyy Button 0", 0, 56, 0   )

DumpDisplay()
--codeExampleEnd 8

--codeExampleStart 9 -----------------------------------------------------------
-- CDC Init Display
nxt.DisplayClear()

nxt.DisplayText( "CDC Init",       0,  0, 0   )
nxt.DisplayText( "yyyyy Button 0", 0, 56, 0   )

DumpDisplay()
--codeExampleEnd 9

--codeExampleStart 10 -----------------------------------------------------------
-- CDC Connect Display
nxt.DisplayClear()

nxt.DisplayText( "CDC Connect",    0,  0, 0   )
nxt.DisplayText( "00199 Button 0", 0, 56, 0   )

DumpDisplay()
--codeExampleEnd 10

--codeExampleStart 11 -----------------------------------------------------------
-- pbLua Version Display
nxt.DisplayClear()

nxt.DisplayText( "pbLua xx.yy.zz", 0,  0, 0   )

DumpDisplay()
--codeExampleEnd 11

--codeExampleStart n -----------------------------------------------------------
--codeExampleEnd n
