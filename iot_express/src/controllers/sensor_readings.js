const express = require('express');
const router = express.Router();
const prisma = require('../../libs/prisma');

// Route untuk mendapatkan sensor readings
router.get('/', async (req, res) => {
    try {
        const sensorReadings = await prisma.sensor_readings.findMany();
        res.json(sensorReadings);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Something went wrong' });
    }
});

// Route untuk membuat sensor reading baru
router.post('/', async (req, res) => {
    try {
        const { temperature, humidity } = req.body;
        const sensorReading = await prisma.sensor_readings.create({
            data: {
                temperature,
                humidity,
            },
        });
        res.json(sensorReading);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Something went wrong' });
    }
});

// Route untuk mendapatkan aktuator
router.get('/aktuator', async (req, res) => {
    try {
        const aktuator = await prisma.aktuator.findMany();
        res.json(aktuator);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Something went wrong' });
    }
});

// Route untuk memperbarui aktuator
router.put('/aktuator/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { status } = req.body;
        const aktuator = await prisma.aktuator.update({
            where: {
                id: parseInt(id),
            },
            data: {
                status,
            },
        });
        res.json(aktuator);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Something went wrong' });
    }
});

module.exports = router;
