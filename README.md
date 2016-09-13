pbLua
======
This repo contains the firmware replacement *pbLua* that enables a Lua runtime on the Lego Mindstorms NXT robots. You can simply write code in any text editor and transfer it to the brick via a serial connection (USB/Bluetooth), for instance by using *[screen](https://www.gnu.org/software/screen/manual/screen.html)* or *[minicom](http://linux.die.net/man/1/minicom)*. Compilation and execution then takes place on the NXT itself. Additional scripts which are helpful for eased handling and transmission of scripts can be found in the [pbLuaConnect](https://github.com/7HAL32/pbLuaConnect) repository.

The project was developed by Ralph Hempel and originally provided at [his website](http://hempeldesigngroup.com/lego/pblua/). Due to downtime of this page the most recent stable package is mirrored here for now. No license is provided as all rights belong to their respective owners. Please contact Mr. Hempel for any enquiries.

Instructions
------
1. Download and install the *[Lego Mindstorms NXT Software Suite](
http://esd.lego.com.edgesuite.net/digitaldelivery/mindstorms/6ecda7c2-1189-4816-b2dd-440e22d65814/public/MINDSTORMS%20NXT%20Retail%20MacWin%20v2.0f6.iso)* for flashing the firmware.

2. Head over to the [releases page](https://github.com/7HAL32/pbLua/releases) and grab the latest one.

3. Start the *Lego Mindstorms NXT Software Suite* and open the dialog under **Tools** > **Update Firmware**. Then choose the file *pbLua.rfw* from the previously downloaded package.

4. Flash the firmware.
