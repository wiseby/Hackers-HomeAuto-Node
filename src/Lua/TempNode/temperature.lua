-- ###############################################################
-- temperature.lua
-- Simple script that reads a DHT sensor and publishes the result.
-- ###############################################################
-- ###############################################################
-- Global variables and parameters.
-- ###############################################################
clientId = "livingroom_dht" -- Identification for the device. Make it unique
tgtHost = "192.168.1.64" -- target host (broker)
tgtPort = 1883 -- target port (broker listening on) default 1883
mqttTimeOut = 120 -- connection timeout
eventTriggerTime = 10 -- data transmission interval in minutes
topicQueue = "hha-server" -- topic to use. Broker intercepts on topic "hha-server"
dhtPin = 4 -- Pin which the sensor is hooked up to. Read gpio module for correct definitions
temperature = "" -- variable to store sensor temperature
humidity = "" -- variable to store sensor humidity

-- You shouldn't need to change anything below this line. -Phil --

-- ###############################################################
-- Functions
-- ###############################################################

-- Function pubEvent() publishes the sensor value to the defined queue.

function pubEvent()
    readSensor()
    jsonValues = "\"temperature\":\"" .. temperature .. "\",\"humidity\":\"" ..
                     humidity .. "\""
    pubValue = "{" .. jsonValues .. "}" -- build buffer
    print("Publishing to " .. topicQueue .. ": " .. pubValue) -- print a status message
    mqttBroker:publish(topicQueue, pubValue, 0, 0) -- publish
end

-- Reconnect to MQTT when we receive an "offline" message.

function reconn()
    print("Disconnected, reconnecting....")
    conn()
end

-- Establish a connection to the MQTT broker with the configured parameters.

function conn()
    print("Making connection to MQTT broker")
    mqttBroker:connect(tgtHost, tgtPort, false,
                       function(client) print("connected") end, function(client,
                                                                         reason)
        print("failed reason: " .. reason)
    end)
end

-- makeConn is triggered in init.lua when wifi has been established.
-- This initializes a global MQTT Client and starts a alarm event that triggers
-- reading sensor and publish event to broker.

function makeConn()
    -- Instantiate a global MQTT client object
    print("Instantiating mqttBroker")
    mqttBroker = mqtt.Client(clientId, mqttTimeOut)

    -- Set up the event callbacks
    print("Setting up callbacks")
    mqttBroker:on("connect", function(client) print("connected") end)
    mqttBroker:on("offline", reconn)

    -- Connect to the Broker
    conn()

    tmr.create():alarm((eventTriggerTime * 60000), tmr.ALARM_AUTO, pubEvent)
end

function readSensor()
    status, temp, humi, temp_dec, humi_dec = dht.read(dhtPin)
    if status == dht.OK then
        print("Reading sensor...")
        temperature = temp .. "." .. temp_dec
        humidity = humi .. "." .. humi_dec
        print("Temperature: " .. temperature)
        print("Humidity: " .. humidity)

        print(string.format("DHT Temperature:%d.%03d;Humidity:%d.%03d\r\n",
                            math.floor(temp), temp_dec, math.floor(humi),
                            humi_dec))

    elseif status == dht.ERROR_CHECKSUM then
        print("DHT Checksum error.")
    elseif status == dht.ERROR_TIMEOUT then
        print("DHT timed out.")
    end
end

-- ###############################################################
-- "Main"
-- ###############################################################

-- No content
