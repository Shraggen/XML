const express = require('express')
const path = require('path')
const fs = require('fs')
const libxmljs = require('libxmljs2')
const app = express()

app.use(express.static(path.join(__dirname, 'xml-content')));
app.use(express.text());
app.use(express.urlencoded({ extended: false }));

app.get('/', (req, res) => {
    res.sendFile(path.resolve('xml-content', 'index.xml'));
})

//Done and tested with Feature 7
app.post('/plants', (req, res) => {
    const newPlant = req.body;
    const databasePath = path.resolve('xml-content', 'database', 'database.xml');
    const xmlDoc = libxmljs.parseXml(fs.readFileSync(databasePath, 'utf-8'));
    const energiePlant = xmlDoc.get('//energie-plant');

    // Generate unique ID
    const plants = xmlDoc.find('//plant');
    const newId = plants.length > 0 ? Math.max(...plants.map(p => parseInt(p.get('id').text(), 10))) + 1 : 1;

    // Append new plant
    const plant = energiePlant.node('plant');
    plant.node('id', String(newId));
    plant.node('name', newPlant.name);
    plant.node('status', newPlant.status === "true" ? "true" : "false");

    // Add statistics with initial price
    const statistics = plant.node('statistics');
    if (newPlant.price && newPlant.date) {
        statistics.node('price', newPlant.price).attr('date', newPlant.date);
    }

    console.log(plant.toString())

    // Validate and save
    if (validateDatabase(xmlDoc)) {
        fs.writeFileSync(databasePath, xmlDoc.toString());
        res.status(201).send({ id: newId });
    } else {
        res.status(400).send('Invalid XML');
    }
});

app.post('/plants/statistics', (req, res) => {
    const { plantId, date, price } = req.body;

    if (!plantId || !date || !price) {
        return res.status(400).send("Missing required fields: plantId, date, or price.");
    }

    const databasePath = path.resolve('xml-content', 'database', 'database.xml');
    const xmlDoc = libxmljs.parseXml(fs.readFileSync(databasePath, 'utf-8'));
    const plant = xmlDoc.get(`//plant[id="${plantId}"]`);

    if (!plant) {
        return res.status(404).send('Plant not found');
    }

    const stats = plant.get('statistics');
    const existingPrices = stats.find('price');

    // Get the most recent date in the statistics
    const latestDate = existingPrices.length > 0
        ? existingPrices[existingPrices.length - 1].attr('date').value()
        : null;

    // Validate: New statistics must be after the latest recorded date
    if (latestDate && new Date(date) <= new Date(latestDate)) {
        return res.status(400).send('New statistic must be newer than the latest one.');
    }

    // Ensure no duplicate date exists
    const dateExists = existingPrices.some(p => p.attr('date').value() === date);
    if (dateExists) {
        return res.status(400).send('A statistic for this date already exists.');
    }

    // Append new price
    stats.node('price', price).attr('date', date);

    // Validate against XSD before saving
    if (validateDatabase(xmlDoc)) {
        fs.writeFileSync(databasePath, xmlDoc.toString());
        res.sendStatus(201);
    } else {
        res.status(400).send('Invalid XML');
    }
});

app.get('/plants', (req, res) => {
    const { filterBy = "all", sortBy = "id", sortOrder = "asc" } = req.query;
    const databasePath = path.resolve('xml-content', 'database', 'database.xml');
    const xmlDoc = libxmljs.parseXml(fs.readFileSync(databasePath, 'utf-8'));

    let plants = xmlDoc.find('//plant');

    // Filter by status
    if (filterBy === "true" || filterBy === "false") {
        plants = plants.filter(p => p.get('status').text() === filterBy);
    }

    // Sort function
    const compare = (a, b) => {
        let valueA, valueB;

        switch (sortBy) {
            case "name":
                valueA = a.get('name').text();
                valueB = b.get('name').text();
                return valueA.localeCompare(valueB);
            case "price":
                valueA = parseFloat(a.get('statistics/price[last()]')?.text() || "0");
                valueB = parseFloat(b.get('statistics/price[last()]')?.text() || "0");
                return valueA - valueB;
            default: // Sort by id
                valueA = parseInt(a.get('id').text(), 10);
                valueB = parseInt(b.get('id').text(), 10);
                return valueA - valueB;
        }
    };

    // Apply sorting
    plants.sort(compare);
    if (sortOrder === "desc") plants.reverse();

    // Create XML response
    let responseXml = `<?xml version="1.0" encoding="UTF-8"?>\n<plants>`;
    plants.forEach(plant => {
        responseXml += `<plant>
            <id>${plant.get('id').text()}</id>
            <name>${plant.get('name').text()}</name>
            <status>${plant.get('status').text()}</status>
            <price>${plant.get('statistics/price[last()]')?.text() || "N/A"}</price>
        </plant>`;
    });
    responseXml += `</plants>`;

    res.header("Content-Type", "application/xml");
    res.send(responseXml);
});

function validateDatabase(xmlDocDatabase) {
    const databaseXsd = fs.readFileSync(path.resolve('xml-content', 'database', 'database.xsd'), 'utf-8')
    const xmlDocDatabaseXsd = libxmljs.parseXml(databaseXsd)
    return xmlDocDatabase.validate(xmlDocDatabaseXsd)
}

app.listen(3000, () => {
    console.log(`Server is running on http://localhost:3000`)
})
