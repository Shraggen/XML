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

app.post('/convertToPdf', async (req, res) => {
    const response = await fetch('https://fop.xml.hslu-edu.ch/fop.php', {
        method: "POST",
        mode: "cors",
        cache: "no-cache",
        credentials: "same-origin",
        body: req.body,
    });
    const responseText = await (await response.blob()).arrayBuffer()
    const buffer = Buffer.from(responseText)
    fs.writeFileSync(path.resolve('temp.pdf'), buffer)
    res.sendFile(path.resolve('temp.pdf'))
})

app.post('/updateData', (req, res) => {
    const dataToUpdate = req.body
    // read database xml
    const databasePath = path.resolve('xml-content', 'database', 'database.xml');
    const databaseXml = fs.readFileSync(databasePath, 'utf-8')
    const xmlDocDatabase = libxmljs.parseXml(databaseXml)
    // select node to update
    const plantStatistics = xmlDocDatabase.get(`//plant[name="${dataToUpdate.plant}"]/statistics`);

    // create new node with attribute etc.
    plantStatistics.node('price', dataToUpdate.price).attr('date', dataToUpdate.date)

    console.log(xmlDocDatabase.toString())

    // validate new database against schema
    const valid = validateDatabase(xmlDocDatabase)
    if (!valid) {
        res.status(400).send('Invalid XML')
        return
    }

    // write new database.xml
    fs.writeFileSync(databasePath, xmlDocDatabase.toString(), 'utf-8')

    res.sendStatus(200)
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

app.post('/plants/:id/statistics', (req, res) => {
    const plantId = req.params.id;
    const newStat = req.body;
    const databasePath = path.resolve('xml-content', 'database', 'database.xml');
    const xmlDoc = libxmljs.parseXml(fs.readFileSync(databasePath, 'utf-8'));
    const plant = xmlDoc.get(`//plant[id="${plantId}"]`);

    if (plant) {
        const stats = plant.get('statistics');
        stats.node('price', newStat.price).attr('date', newStat.date);

        // Validate and save
        if (validateDatabase(xmlDoc)) {
            fs.writeFileSync(databasePath, xmlDoc.toString());
            res.sendStatus(201);
        } else {
            res.status(400).send('Invalid XML');
        }
    } else {
        res.status(404).send('Plant not found');
    }
});

app.get('/plants', (req, res) => {
    const databasePath = path.resolve('xml-content', 'database', 'database.xml');
    const xmlDoc = libxmljs.parseXml(fs.readFileSync(databasePath, 'utf-8'));

    console.log(xmlDoc.toString())
    const plants = xmlDoc.find('//plant').map(p => {
        const idNode = p.get('id');
        const nameNode = p.get('name');
        const typeNode = p.get('type');
        const statusNode = p.get('status');
        const statisticsNodes = p.find('statistics/price');

        console.log(idNode.text())

        return {
            id: idNode ? idNode.text() : null,
            name: nameNode ? nameNode.text() : null,
            type: typeNode ? typeNode.text() : null,
            status: statusNode ? statusNode.text() : null,
            statistics: statisticsNodes.map(price => ({
                date: price.attr('date') ? price.attr('date').value() : null,
                price: price.text()
            }))
        };
    });
    res.json(plants);
});

app.put('/plants/:id/status', (req, res) => {
    const plantId = req.params.id;
    const newStatus = req.body.status;
    const databasePath = path.resolve('xml-content', 'database', 'database.xml');
    const xmlDoc = libxmljs.parseXml(fs.readFileSync(databasePath, 'utf-8'));
    const plant = xmlDoc.get(`//plant[id="${plantId}"]`);

    if (plant) {
        plant.get('status').text(newStatus);

        // Validate and save
        if (validateDatabase(xmlDoc)) {
            fs.writeFileSync(databasePath, xmlDoc.toString());
            res.sendStatus(200);
        } else {
            res.status(400).send('Invalid XML');
        }
    } else {
        res.status(404).send('Plant not found');
    }
});

function validateDatabase(xmlDocDatabase) {
    const databaseXsd = fs.readFileSync(path.resolve('xml-content', 'database', 'database.xsd'), 'utf-8')
    const xmlDocDatabaseXsd = libxmljs.parseXml(databaseXsd)
    return xmlDocDatabase.validate(xmlDocDatabaseXsd)
}

app.listen(3000, () => {
    console.log(`Server is running on http://localhost:3000`)
})
