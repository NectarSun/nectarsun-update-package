# Nectarsun Software Updater
Nectarsun software updater tool for the distributors of the Nectarsun to help maintain up-to-date software on shipped devices. 

Currently this application only runs on Windows. 

## Tools needed
To update your Nectarsun, first of all, you will need these tools:
- An ST-link programmer. We're using the top half of an ST Nucleo board as our programmer: [https://bit.ly/2KuabNp](https://bit.ly/2KuabNp)
- A USB-to-Serial converter. We're using the one in the link, but any generic USB-to-Serial converter will work: [https://ebay.to/2IS7Ypg](https://ebay.to/2IS7Ypg)
- Female to female jumper wires. E.g.: [https://bit.ly/2lSrAkc](https://bit.ly/2lSrAkc)
- 2 x mini USB cables to connect the ST-link programmer and the USB-to-Serial converter to your PC

## Getting started
1. Install the ST-link and the FTDI drivers from the `drivers` folder. If you're using a different USB-to-Serial converter, you will have to find and install the required drivers yourself. Go to the `Control Panel > Devices and Printers` and check that your drivers installed properly, and both devices show up.
2. Run the `ns-updater.bat` script. If you get a warning from Windows about an unrecognized app, select `More info > Run anyway`. The next time you run this application Windows won't throw this warning again.
3. Connect the programmer to one of the programming ports on the Nectarsun (check the section below for detailed instructions), and follow the instructions on the updater script.

## Using

## Feedback
- Request a new feature on GitHub.
- File a bug in GitHub Issues.
- Email us at [support@nectarsun.com](mailto:support@nectarsun.com) with other feedback.

## License
Copyright (c) Nectarsun. All rights reserved.

Licensed under the Apache 2.0 License.