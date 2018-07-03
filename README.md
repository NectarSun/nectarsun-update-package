![Nectarsun S][nectarsun]
# Nectarsun Software Updater
Nectarsun software updater tool for the distributors of the Nectarsun to help maintain up-to-date software on shipped devices. 

Currently this application only runs on Windows.

>Detailed information on Nectarsun firmware updates and releases at [https://nectarsun.github.io](https://nectarsun.github.io)

## Tools needed
To update your Nectarsun, first of all, you will need these tools:
- Software from this page
- An ST-link programmer. We're using the top half of an ST Nucleo board as our programmer: [https://bit.ly/2KuabNp](https://bit.ly/2KuabNp)
- A USB-to-Serial converter. We're using the one in the link, but any generic USB-to-Serial converter will work: [https://ebay.to/2IS7Ypg](https://ebay.to/2IS7Ypg)
- Female to female jumper wires. E.g.: [https://bit.ly/2lSrAkc](https://bit.ly/2lSrAkc)
- 2 x mini USB cables to connect the ST-link programmer and the USB-to-Serial converter to your PC

## Getting started
1. Download the `nectarsun-updater-package` from this page (select `Clone or download > Download ZIP`), and extract it on your PC.
1. Install the ST-link and the FTDI drivers from the `drivers` folder. If you're using a different USB-to-Serial converter, you will have to find and install the required drivers yourself. Go to the `Control Panel > Devices and Printers` and check that your drivers installed properly, and both devices show up.
2. Run the `ns-updater.bat` script. If you get a warning from Windows about an unrecognized app, select `More info > Run anyway`. The next time you run this application Windows won't throw this warning again.
3. Remove the top cover of the Nectarsun by undoing the two screws:

![Top cover screws][top-cover-screws]

4. Connect the programmer to one of the programming ports on the Nectarsun (check the section below for detailed instructions), and follow the instructions on the updater script.

>We recommend updating all three boards, as the latest software update has many improvements, especially if your Nectarsun runs software version `v1.06` or below. More information about the latest features and improvements that were added to the Nectarsun's software, please go to [https://nectarsun.github.io](https://nectarsun.github.io).

## Using
#### Updating the ESP board
1. Plug the USB-to-Serial converter to your PC.
2. Connect the USB-to-Serial converter to the ESP programming port (J17 port) on the Nectarsun using the jumper wires and the diagrams below. Make sure that the the selector on the USB-to-Serial converter is set to `3.3V`!! Connect the `GPIO-0` pin on the J17 port to ground (e.g. `GND` pin on the J11 port).

USB-to-Serial converter pinout:
![USB-to-Serial][usb-to-serial-pinout]

ESP pinout (J17 port):
![ESP pinout][esp-pinout]

3. When you've connected the USB-to-Serial converter to the ESP, turn on the Nectarsun.
4. In the update script, go to `Configure programmers > ESP programmer` select the COM port that the ESP programmer is connected to.
5. Then go to `Update software > ESP`. The script will then start the update.
6. When it's done programming, you can turn off the Nectarsun, and disconnect the USB-to-Serial converter from the Nectarsun.

Your Nectarsun's ESP module is up to date.

#### Updating the Main board
1. Cut off the top half of the Nucleo board (if you haven't done so yet). Make sure that the jumper connectors are removed.
2. Connect the programmer to your PC with the USB cable.
3. Connect the programmer to the Main board programming port (J11 port) on the Nectarsun using the jumper wires and the reference diagrams below:

Main board connector pinout (J11 port):
![Main board connector pinout][main-port-pinout]

ST-link programmer pinout:
![ST-link programmer pinout][st-link-pinout]

4. When you've connected the programmer to the Nectarsun, turn on the Nectarsun.
4. In the update script, go to `Configure programmers > Main board programmer` and select the drive that the ST-link programmer shows up as.
5. Then, go to `Update software > Main board`. The script will start updating the main board.
6. When it's done programming, you can turn off the Nectarsun and disconnect the programmer from the Nectarsun.

Your Nectarsun's Main board is up to date.

#### Updating the Power board
1. Cut off the top half of the Nucleo board (if you haven't done so yet). Make sure that the jumper connectors are removed.
3. Remove the bottom cover of the Nectarsun by removing the four screws in the corners. This will expose the radiator and the Power board programming port (J4) on the bottom.
2. Connect the programmer to your PC with the USB cable.
3. Connect the programmer to the Power board programming port (J4 port) on the Nectarsun using the jumper wires and the reference diagrams below:

Power board connector pinout (J4 port):
![Power board connector pinout][power-port-pinout]

ST-link programmer pinout:
![ST-link programmer pinout][st-link-pinout]

4. When you've connected the programmer to the Nectarsun, turn on the Nectarsun.
4. In the update script, go to `Configure programmers > Power board programmer` and select the drive that the ST-link programmer shows up as.
5. Then, go to `Update software > Power board`. The script will start updating the power board.
6. When it's done programming, you can turn off the Nectarsun and disconnect the programmer from the Nectarsun.
7. You can now put the back cover in place.

Your Nectarsun's Power board is up to date.

#### Calibration
After updating all the boards and turning on the Nectarsun, you might see the `ERROR 232` message on the screen. This simply means that the Nectarsun needs calibrating.

To calibrate the Nectarsun follow these steps:
1. While on the `ERROR 232` or the `Select Language` screen press and hold the up and down arrows for a few seconds. You will enter the engineering menu.

Enter the engineering menu:
![Engineering menu][engineering-menu]

2. Short the DC+ and the DC- inputs:
![Shorted DC][shorted-dc]

3. Using the arrows navigate to the `Calibrate` screen and select `Yes`.
4. After a moment you will be returned to the main Debug screen where you should see the calibration values on the second line of the screen.
5. You can now turn off the Nectarsun, or go to `Settings > Reset > Yes` to boot the Nectarsun in normal mode again.
6. That's it, you can now connect the DC power from your PV panels, plug the boiler power cable into the Nectarsun and start heating water using the power of the Sun!

## Feedback & Information
- More information at [http://www.nectarsun.com](http://www.nectarsun.com)
- Latest software release notes at [https://nectarsun.github.io](https://nectarsun.github.io)
- Request a new feature on GitHub.
- File a bug in GitHub Issues.
- Email us at [support@nectarsun.com](mailto:support@nectarsun.com) with other feedback, or fill in our support form at [http://www.nectarsun.com/support.html](http://www.nectarsun.com/support.html)

## License
Copyright &copy; Nectarsun. All rights reserved.

Licensed under the Apache 2.0 License.

[top-cover-screws]: https://github.com/NectarSun/nectarsun-update-package/raw/master/img/ns-1.png "Top cover screws"
[engineering-menu]: https://github.com/NectarSun/nectarsun-update-package/raw/master/img/ns-2.png "Engineering menu"
[esp-pinout]: https://github.com/NectarSun/nectarsun-update-package/raw/master/img/ns-3.png "ESP pinout"
[main-port-pinout]: https://github.com/NectarSun/nectarsun-update-package/raw/master/img/ns-4.png "Main board pinout"
[usb-to-serial-pinout]: https://github.com/NectarSun/nectarsun-update-package/raw/master/img/ns-5.png "USB-to-Serial pinout"
[st-link-pinout]: https://github.com/NectarSun/nectarsun-update-package/raw/master/img/ns-6.png "ST-link pinout"
[power-port-pinout]: https://github.com/NectarSun/nectarsun-update-package/raw/master/img/ns-7.png "Power board pinout"
[shorted-dc]: https://github.com/NectarSun/nectarsun-update-package/raw/master/img/ns-8.jpg "Shorted DC"
[nectarsun]: https://github.com/NectarSun/nectarsun-update-package/raw/master/img/hero-device.png "Nectarsun S"