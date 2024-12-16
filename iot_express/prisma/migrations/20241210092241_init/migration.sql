-- CreateTable
CREATE TABLE "sensor_readings" (
    "id" SERIAL NOT NULL,
    "temperature" DOUBLE PRECISION,
    "humidity" DOUBLE PRECISION,
    "timestamp" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "topic" VARCHAR(255),

    CONSTRAINT "sensor_readings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "aktuator" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL DEFAULT 'Aktuator',
    "status" TEXT NOT NULL DEFAULT 'OFF',
    "timestamp" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "aktuator_pkey" PRIMARY KEY ("id")
);
