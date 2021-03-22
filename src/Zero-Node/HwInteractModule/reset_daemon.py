from gpiozero.pins.mock import MockFactory
from gpiozero import Device, LED, Button
from time import sleep
from sys import argv

args = argv
ENVIRONMENT = ''
running = True

if(len(args) > 1):
    ENVIRONMENT = args[1]

if(ENVIRONMENT == 'development'):
    Device.pin_factory = MockFactory()

redLed = LED(2)
blueLed = LED(3)
greenLed = LED(4)

while(running):
    greenLed.toggle()