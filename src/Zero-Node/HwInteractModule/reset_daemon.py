from gpiozero.pins.mock import MockFactory
from gpiozero import Device, LED, Button
from time import sleep
from sys import argv

args = argv
ENVIRONMENT = ''

if(len(args) > 1):
    ENVIRONMENT = args[1]

if(ENVIRONMENT == 'development'):
    Device.pin_factory = MockFactory()

redLed = LED(2)
blueLed = LED(3)
greenLed = LED(4)

while(True):
    print('Green')
    greenLed.toggle()
    sleep(1)
    greenLed.toggle()
    sleep(1)

    print('Blue')
    blueLed.toggle()
    sleep(1)
    blueLed.toggle()
    sleep(1)

    print('Red')
    redLed.toggle()
    sleep(1)
    redLed.toggle()
    sleep(1)