-- This is the example code file for the webpage at:
--
-- www.hempeldesigngroup.com/lego/pbLua/tutorial/pbLuaBtConsole.html


--codeExampleStart BtConsole_1 ----------------------------------------------------------- 
> nxt.BtFactoryReset()
--codeExampleEnd BtConsole_1

--codeExampleStart BtConsole_2 ----------------------------------------------------------- 
> nxt.BtPower(1)
--codeExampleEnd BtConsole_2

--codeExampleStart BtConsole_3 ----------------------------------------------------------- 
> nxt.BtVisible(1)
--codeExampleEnd BtConsole_3

--codeExampleStart BtConsole_4 ----------------------------------------------------------- 
> nxt.BtSetName("OGEL")
--codeExampleEnd BtConsole_4


--codeExampleStart Linux_1 -----------------------------------------------------------
rhempel@debian:~$ dmesg

[ 3337.783560] usb 1-1: USB disconnect, address 4
[ 3533.515988] Clocksource tsc unstable (delta = 4686977665 ns)
[ 3668.161395] usb 1-1: new full speed USB device using uhci_hcd and address 6
[ 3668.403670] usb 1-1: configuration #1 chosen from 1 choice
[ 3668.467956] cdc_acm: This device cannot do calls on its own. It is no modem.
[ 3668.469863] cdc_acm 1-1:1.0: ttyACM0: USB ACM device
--codeExampleEnd Linux_1

--codeExampleStart Linux_2 -----------------------------------------------------------
rhempel@debian:~$ ls /dev/ttyACM*
/dev/ttyACM0
--codeExampleEnd Linux_2

--codeExampleStart Linux_3 ----------------------------------------------------------- 
# Machine-generated file - use setup menu in minicom to change parameters.
pu port             /dev/ttyACM0
pu minit
pu mreset
--codeExampleEnd Linux_3

--codeExampleStart Linux_4 ----------------------------------------------------------- 
rhempel@debian:~$ minicom acm0
Welcome to minicom 2.3

OPTIONS: I18n 
Compiled on Oct 24 2008, 06:37:44.
Port /dev/ttyACM0

                 Press CTRL-A Z for help on special keys
>
--codeExampleEnd Linux_4

--codeExampleStart Linux_5 ----------------------------------------------------------- 
rhempel@debian:~$ sudo apt-get install bluez bluez-hcidump

Unpacking bluez (from .../archives/bluez_4.57-1_i386.deb) ...
--codeExampleEnd Linux_5

--codeExampleStart Linux_6 ----------------------------------------------------------- 
-- /etc/default/bluetooth

HID2HCI_ENABLED=1
HID2HCI_UNDO=1
--codeExampleEnd Linux_6

----codeExampleStart Linux_7 ----------------------------------------------------------- 
-- Only run this if your Bluetooth interface is connected to the USB bus
rhempel@debian:~$ lsusb
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 002: ID 050d:016a Belkin Components
Bus 001 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub

-- Check if your Bluetooth interface is recognized
rhempel@debian:~$ hcitool dev
Devices:
        hci0    aa:bb:cc:dd:ee:ff
--codeExampleEnd Linux_7

--codeExampleStart Linux_8 ----------------------------------------------------------- 
rhempel@debian:~$ sudo hcidump
HCI sniffer - Bluetooth packet analyzer ver 1.42
device: hci0 snap_len: 1028 filter: 0xffffffff
< HCI Command: Create Connection (0x01|0x0005) plen 13
> HCI Event: Command Status (0x0f) plen 4
> HCI Event: Connect Complete (0x03) plen 11
...
> HCI Event: Link Key Request (0x17) plen 6
< HCI Command: Link Key Request Reply (0x01|0x000b) plen 22
> HCI Event: Command Complete (0x0e) plen 10
> HCI Event: Connect Complete (0x03) plen 11
< HCI Command: Read Remote Supported Features (0x01|0x001b) plen 2
< ACL data: handle 11 flags 0x02 dlen 10
    L2CAP(s): Info req: type 2
> ACL data: handle 11 flags 0x02 dlen 16
    L2CAP(s): Info rsp: type 2 result 0
      Extended feature mask 0x0000
...
... You get the idea 
--codeExampleEnd Linux_8
--
--codeExampleStart Linux_9 ----------------------------------------------------------- 
rhempel@debian:~$ /usr/sbin/hciconfig
hci0:   Type: USB
        BD Address: aa:bb:cc:dd:ee:ff ACL MTU: 1021:8 SCO MTU: 64:1
        UP RUNNING PSCAN
        RX bytes:2145 acl:0 sco:0 events:82 errors:0
        TX bytes:2040 acl:0 sco:0 commands:82 errors:0
--codeExampleEnd Linux_9

--codeExampleStart Linux_10 ----------------------------------------------------------- 
rhempel@debian:~$ hcitool scan
Scanning ...
        nn:xx:tt:mm:aa:cc       OGEL
--codeExampleEnd Linux_10

--codeExampleStart Linux_11 ----------------------------------------------------------- 
rhempel@debian:~$ ls /var/lib/bluetooth/aa:bb:cc:dd:ee:ff/
classes  config  lastseen  names
--codeExampleEnd Linux_11

--codeExampleStart Linux_12 ----------------------------------------------------------- 
-- /var/lib/bluetooth/aa:bb:cc:dd:ee:ff/pincodes
-- Add a line that looks like this (put your desired pincode instead of 1234):

nn:xx:tt:mm:aa:cc 1234
--codeExampleEnd Linux_12
--
--codeExampleStart Linux_13 ----------------------------------------------------------- 
-- /var/lib/bluetooth/aa:bb:cc:dd:ee:ff/trusts
-- Add a line that looks like this:

nn:xx:tt:mm:aa:cc [all]
--codeExampleEnd Linux_13

--codeExampleStart Linux_14 ----------------------------------------------------------- 
/etc/bluetooth/rfcomm.conf

-- Edit the rfcomm0 section like so:
rfcomm0 {
        # Automatically bind the device at startup
        bind yes;

        # Bluetooth address of the device
        device nn:xx:tt:mm:aa:cc;

        # RFCOMM channel for the connection
        channel 1;

        # Description of the connection
        comment "OGEL";
}
--codeExampleEnd Linux_14

--codeExampleStart Linux_15 ----------------------------------------------------------- 
rhempel@debian:~$ sudo /etc/init.d/bluetooth restart
--codeExampleEnd Linux_15

--codeExampleStart Linux_16 ----------------------------------------------------------- 
> nxt.BtSetPIN("1234")

-- Optionally, you can run this little snippet of code that will send the
-- PIN every time you press the orange button...

function sendPIN()
  local oldButton = 0
  local newButton = 0

  while( 1 ) do
    newButton = nxt.ButtonRead()

    if 0 == oldButton then
      -- Only check buttons if no buttons were pressed!

      if 8 == newButton then
        nxt.BtSetPIN("1234") 
      end
    end

    oldButton = newButton
  end
end
  
-- And run the function (it's an endless loop - power off the NXT to stop it)
sendPIN()
--codeExampleEnd Linux_16

--codeExampleStart Linux_17 ----------------------------------------------------------- 
rhempel@debian:~$ sudo rfcomm bind 0
rhempel@debian:~$ sudo rfcomm connect 0
Can't create RFCOMM TTY: Address already in use
--codeExampleEnd Linux_17

--codeExampleStart Linux_18 ----------------------------------------------------------- 
rhempel@debian:~$ ls /var/lib/bluetooth/aa:bb:cc:dd:ee:ff/
classes  features  lastused  manufacturers  pincodes
config   lastseen  linkkeys  names          trusts
--codeExampleEnd Linux_18

--codeExampleStart Linux_19 ----------------------------------------------------------- 
rhempel@debian:~$ sudo /etc/init.d/bluetooth restart

-- Verify that rfcomm0 is assigned to OGEL
rhempel@debian:~$ rfcomm
rfcomm0: 00:16:53:04:E8:A3 channel 1 clean
--codeExampleEnd Linux_19

--codeExampleStart Linux_20 ----------------------------------------------------------- 
-- One last step, create a config for minicom in your home directory
-- called .minirc.OGEL with this as the contents:
# Machine-generated file - use setup menu in minicom to change parameters.
pu port             /dev/rfcomm0
pu minit
pu mreset
--codeExampleEnd Linux_20

--codeExampleStart Linux_21 ----------------------------------------------------------- 
rhempel@debian:~$ minicom OGEL
Welcome to minicom 2.3

OPTIONS: I18n 
Compiled on Oct 24 2008, 06:37:44.
Port /dev/rfcomm0

                 Press CTRL-A Z for help on special keys
>
--codeExampleEnd Linux_21


