<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml">

    <xsl:output method="html" indent="yes"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>Sortierte Kraftwerke</title>
                <link rel="stylesheet" type="text/css" href="../theme.css"/>
                <script>
                    function fetchPlants() {
                    const filterBy = document.getElementById("statusFilter").value;
                    const sortBy = document.getElementById("sortFilter").value;
                    const sortOrder = document.getElementById("orderFilter").value;

                    const url = `/plants?filterBy=${filterBy}&amp;sortBy=${sortBy}&amp;sortOrder=${sortOrder}`;

                    const xhr = new XMLHttpRequest();
                    xhr.open("GET", url, true);
                    xhr.onreadystatechange = function () {
                    if (xhr.readyState === 4 &amp;&amp; xhr.status === 200) {
                    const xml = xhr.responseXML;
                    if (!xml) {
                    console.error("Fehler beim Parsen des XML");
                    return;
                    }

                    const plantTable = document.getElementById("plantTable");
                    plantTable.innerHTML = ""; // Leere vorherige Daten

                    const plants = xml.getElementsByTagName("plant");
                    for (let i = 0; i &lt; plants.length; i++) {
                    const plant = plants[i];

                    const id = plant.getElementsByTagName("id")[0].textContent;
                    const name = plant.getElementsByTagName("name")[0].textContent;
                    const status = plant.getElementsByTagName("status")[0].textContent;
                    const price = plant.getElementsByTagName("price")[0]?.textContent || "N/A";

                    // Neue Tabellenreihe erstellen (XSL-freundlich)
                    const row = document.createElement("tr");
                    row.innerHTML = "&lt;td&gt;" + id + "&lt;/td&gt;" +
                    "&lt;td&gt;" + name + "&lt;/td&gt;" +
                    "&lt;td&gt;" + price + " CHF&lt;/td&gt;" +
                    "&lt;td&gt;" + (status === "true" ? "Aktiv" : "Inaktiv") + "&lt;/td&gt;";
                    plantTable.appendChild(row);
                    }
                    }
                    };
                    xhr.send();
                    }
                </script>

            </head>
            <body onload="fetchPlants()">
                <h1>Sortierte Kraftwerke</h1>
                <small><a href="../index.xml">Home</a></small>
                <br/><br/>

                <label for="statusFilter">Status:</label>
                <select id="statusFilter" onchange="fetchPlants()">
                    <option value="all">Alle</option>
                    <option value="true">Aktiv</option>
                    <option value="false">Inaktiv</option>
                </select>

                <label for="sortFilter">Sortieren nach:</label>
                <select id="sortFilter" onchange="fetchPlants()">
                    <option value="id">ID</option>
                    <option value="name">Name</option>
                    <option value="price">Letzter Preis</option>
                </select>

                <label for="orderFilter">Reihenfolge:</label>
                <select id="orderFilter" onchange="fetchPlants()">
                    <option value="asc">Aufsteigend</option>
                    <option value="desc">Absteigend</option>
                </select>

                <br/><br/>

                <!-- Dynamically populated table -->
                <table border="1">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Letzter Preis</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody id="plantTable">
                        <!-- API Data will be inserted here -->
                    </tbody>
                </table>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>