import paho.mqtt.client as mqtt
import asyncio
import asyncpg
import threading
import json
from collections import defaultdict

# MQTT Broker details
BROKER = "broker.hivemq.com"
PORT = 1883
TEMPERATURE_TOPIC = "iotAgro/temperature"
HUMIDITY_TOPIC = "iotAgro/humidity"
MOTOR_TOPIC = "iotAgro/motor"

# PostgreSQL Database details
DB_HOST = "localhost"
DB_PORT = 5432
DB_NAME = "iot_agro"
DB_USER = "postgres"
DB_PASSWORD = "123"

# Global variables
db_pool = None  # Database connection pool
loop = None  # Main asyncio event loop
data_cache = defaultdict(dict)  # Temporary cache for sensor data

async def insert_to_db(temperature=None, humidity=None, topic=None):
    """Insert data into PostgreSQL database."""
    global db_pool
    async with db_pool.acquire() as connection:
        try:
            await connection.execute(
                """
                INSERT INTO sensor_readings (temperature, humidity, topic, timestamp)
                VALUES ($1, $2, $3, NOW())
                """,
                temperature, humidity, topic
            )
            print(f"Data inserted: Temp={temperature}, Humidity={humidity}, Topic={topic}")
        except Exception as e:
            print(f"Failed to insert data: {e}")

async def fetch_aktuator_status(client):
    """Fetch aktuator status from the database and publish to MQTT topic."""
    global db_pool
    async with db_pool.acquire() as connection:
        try:
            result = await connection.fetchrow(
                """
                SELECT status FROM aktuator
                ORDER BY timestamp DESC
                LIMIT 1
                """
            )
            if result:
                aktuator_status = result["status"]
                print(f"Fetched aktuator status: {aktuator_status}")

                # Format the message as JSON
                message = json.dumps({"message": aktuator_status})
                # Publish the JSON-formatted status
                client.publish(MOTOR_TOPIC, message)
                print(f"Published to {MOTOR_TOPIC}: {message}")
        except Exception as e:
            print(f"Failed to fetch aktuator status: {e}")

def on_connect(client, userdata, flags, rc):
    """Handle MQTT connection."""
    if rc == 0:
        print("Connected to MQTT Broker!")
        client.subscribe([(TEMPERATURE_TOPIC, 0), (HUMIDITY_TOPIC, 0)])
        print(f"Subscribed to {TEMPERATURE_TOPIC} and {HUMIDITY_TOPIC}")
    else:
        print(f"Failed to connect, return code {rc}")

def on_message(client, userdata, msg):
    """Handle incoming MQTT messages."""
    global loop, data_cache
    print(f"Message received on topic {msg.topic}: {msg.payload.decode()}")
    try:
        payload = float(msg.payload.decode())
        print(f"Decoded payload as float: {payload}")

        # Store the payload in the cache
        if msg.topic == TEMPERATURE_TOPIC:
            data_cache["temperature"] = payload
        elif msg.topic == HUMIDITY_TOPIC:
            data_cache["humidity"] = payload

        # Check if both temperature and humidity are available
        if "temperature" in data_cache and "humidity" in data_cache:
            # Insert data into the database
            asyncio.run_coroutine_threadsafe(
                insert_to_db(
                    temperature=data_cache["temperature"],
                    humidity=data_cache["humidity"],
                    topic="iotAgro/sensors"
                ),
                loop
            )
            # Clear the cache after insertion
            data_cache.clear()
    except ValueError:
        print(f"Invalid payload received: {msg.payload.decode()}")

def mqtt_loop(client):
    """Run the MQTT client loop in a separate thread."""
    client.loop_forever()

async def publish_aktuator_status_periodically(client):
    """Periodically fetch aktuator status and publish it."""
    while True:
        await fetch_aktuator_status(client)
        await asyncio.sleep(5)  # Publish every 5 seconds

async def main():
    """Main async function to set up MQTT and PostgreSQL connections."""
    global db_pool, loop

    # Set up the PostgreSQL connection pool
    db_pool = await asyncpg.create_pool(
        host=DB_HOST,
        port=DB_PORT,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )
    print("Connected to PostgreSQL Database!")

    # Create an asyncio event loop reference
    loop = asyncio.get_event_loop()

    # Initialize the MQTT client
    client = mqtt.Client()
    client.on_connect = on_connect
    client.on_message = on_message

    # Connect to the MQTT broker
    client.connect(BROKER, PORT, 60)

    # Run the MQTT client loop in a separate thread
    mqtt_thread = threading.Thread(target=mqtt_loop, args=(client,))
    mqtt_thread.daemon = True
    mqtt_thread.start()

    # Start the task to publish aktuator status periodically
    asyncio.create_task(publish_aktuator_status_periodically(client))

    # Keep the asyncio loop running
    try:
        await asyncio.Event().wait()
    except asyncio.CancelledError:
        print("Shutting down...")

# Run the main function
if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print("Exiting...")