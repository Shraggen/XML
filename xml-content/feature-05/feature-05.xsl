<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml">
    
    <xsl:param name="sortBy">price</xsl:param>
    <xsl:param name="filterByStatus">all</xsl:param> <!-- 'active', 'inactive', 'all' -->

    <xsl:output method="html" indent="yes"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>Sorted Power Plants</title>
                <link rel="stylesheet" type="text/css" href="../theme.css"/>
                <script>
                    function applyFilter() {
                        const statusFilter = document.getElementById("statusFilter").value;
                        window.location.href = "?filterByStatus=" + statusFilter;
                    }
                </script>
            </head>
            <body>
                <h1>Sorted Power Plants</h1>
                <small><a href="../index.xml">Home</a></small>

                <br/><br/>

                <!-- Dropdown zur Filterung -->
                <label for="statusFilter">Filter:</label>
                <select id="statusFilter" onchange="applyFilter()">
                    <option value="all">
                        <xsl:if test="$filterByStatus='all'"><xsl:attribute name="selected"/></xsl:if> Alle
                    </option>
                    <option value="active">
                        <xsl:if test="$filterByStatus='active'"><xsl:attribute name="selected"/></xsl:if> Nur aktive
                    </option>
                    <option value="inactive">
                        <xsl:if test="$filterByStatus='inactive'"><xsl:attribute name="selected"/></xsl:if> Nur inaktive
                    </option>
                </select>

                <br/><br/>

                <table border="1">
                    <tr>
                        <th>Name</th>
                        <th>Typ</th>
                        <th>Ø Preis</th>
                        <th>Status</th>
                    </tr>

                    <!-- Kraftwerke mit Filter und Sortierung -->
                    <xsl:apply-templates select="energie-data/energie-plant/plant[
                        ($filterByStatus='all') or 
                        ($filterByStatus='active' and status='true') or 
                        ($filterByStatus='inactive' and status='false')
                    ]">
                        <xsl:sort select="statistics/price[last()]" data-type="number" order="ascending"/>
                    </xsl:apply-templates>

                </table>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="plant">
        <tr>
            <td><xsl:value-of select="name"/></td>
            <td><xsl:value-of select="type"/></td>
            <td>
                <xsl:variable name="sum" select="sum(statistics/price)"/>
                <xsl:variable name="count" select="count(statistics/price)"/>
                <xsl:value-of select="format-number($sum div $count, '0.00')"/> CHF
            </td>
            <td>
                <xsl:choose>
                    <xsl:when test="status='true'">✅ Aktiv</xsl:when>
                    <xsl:otherwise>❌ Inaktiv</xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
    </xsl:template>

</xsl:stylesheet>
