<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE uridef[
	<!ENTITY owl "http://www.w3.org/2002/07/owl#">
	<!ENTITY rdf "http://www.w3.org/1999/02/22-rdf-syntax-ns#">
	<!ENTITY rdfs "http://www.w3.org/2000/01/rdf-schema#">
	<!ENTITY xsd "http://www.w3.org/2001/XMLSchema#">
	<!ENTITY dom "http://www.itu.dk/people/martynas/Thesis/whatsup.owl#">
	<!ENTITY sys "http://www.xml.lt/system-ont.owl#">
	<!ENTITY geo "http://www.w3.org/2003/01/geo/wgs84_pos#">
	<!ENTITY sparql "http://www.w3.org/2005/sparql-results#">
]>
<xsl:stylesheet version="1.0"
xmlns="http://www.w3.org/1999/xhtml"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:owl="&owl;"
xmlns:rdf="&rdf;"
xmlns:rdfs="&rdfs;"
xmlns:xsd="&xsd;"
xmlns:sparql="&sparql;"
exclude-result-prefixes="owl rdf rdfs xsd sparql">

	<xsl:include href="../master.xsl"/>

	<xsl:param name="query-result"/>
	<xsl:param name="chart-result"/>
	<xsl:param name="query-string" select="''"/>
	<xsl:param name="chart-url"/>

	<xsl:template name="title">
		Query
	</xsl:template>

	<xsl:template name="content">
		<div id="main">
			<h2><xsl:call-template name="title"/></h2>
			<form action="{$resource//sparql:binding[@name = 'resource']/sparql:uri}" method="get" accept-charset="UTF-8">
				<p>
					<textarea cols="80" rows="20" name="query-string">
						<xsl:value-of select="$query-string"/>
					</textarea>
					<br/>
					<!-- <input type="hidden" name="action" value="query"/> -->
					<button type="submit">Query</button>
				</p>
			</form>

			<xsl:if test="$query-result">
				<h3>Results (<xsl:value-of select="count(document('arg://results')//sparql:result)"/>)</h3>
				<xsl:if test="document('arg://results')//sparql:result">
					<table>
						<thead>
							<tr>
								<xsl:for-each select="document('arg://results')//sparql:variable">
									<td>
										<xsl:value-of select="@name"/>
									</td>
								</xsl:for-each>
							</tr>
						</thead>
						<tbody>
							<xsl:apply-templates select="document('arg://results')//sparql:result" mode="results-table-body"/>
						</tbody>
					</table>
				</xsl:if>
				<!-- <xsl:copy-of select="document('arg://results')"/> -->
				<h3>Chart</h3>
				<form action="" method="get" accept-charset="UTF-8" >
					<p>
						<label for="x-axis">X axis</label>
						<select name="x-axis" id="x-axis">
							<xsl:variable name="selected">
								<xsl:if test="$chart-result">
									<xsl:value-of select="document('arg://chart-form')//XAxis"/>
								</xsl:if>
							</xsl:variable>
							<xsl:apply-templates select="document('arg://results')/sparql:sparql/sparql:head/sparql:variable" mode="variable-option">
								<xsl:with-param name="selected" select="$selected"/>
							</xsl:apply-templates>
						</select>
						<br/>
						<label for="y-axis">Y axis</label>
						<select name="y-axis" id="y-axis">
							<xsl:variable name="selected">
								<xsl:if test="$chart-result">
									<xsl:value-of select="document('arg://chart-form')//YAxis"/>
								</xsl:if>
							</xsl:variable>
							<xsl:apply-templates select="document('arg://results')/sparql:sparql/sparql:head/sparql:variable" mode="variable-option">
								<xsl:with-param name="selected" select="$selected"/>
							</xsl:apply-templates>
						</select>
						<br/>
						<label for="label">Label</label>
						<select name="label" id="label">
							<option value="label">label</option>
						</select>
						<br/>
						<label for="chart-type">Chart type</label>
						<select name="type" id="chart-type">
							<option value="s">Scatter plot</option>	
						</select>
						<br/>
						<label for="chart-title">Chart title</label>
						<input type="text" name="title"/>
						<br/>
						<button type="submit">Set</button>
						<input type="hidden" name="query-string" value="{$query-string}"/>
					</p>
				</form>
<!-- <xsl:copy-of select="document('arg://results')"/> -->
				<p>
					<img src="{$chart-url}" alt="Chart"/>
				</p>
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template match="sparql:variable" mode="variable-option">
		<xsl:param name="selected"/>
		<xsl:if test="//sparql:binding[@name = current()/@name]/sparql:literal[string(number(.)) != 'NaN']">
			<option value="{@name}">
				<xsl:if test="@name = $selected">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="@name"/>
			</option>
		</xsl:if>
	</xsl:template>

	<xsl:template match="sparql:result" mode="results-table-body">
		<tr>
			<xsl:variable name="current" select="."/>
			<xsl:for-each select="document('arg://results')//sparql:variable">
				<xsl:variable name="name" select="@name"/>
				<xsl:choose>
					<xsl:when test="$current/sparql:binding[@name=$name]">
						<!-- apply template for the correct value type (bnode, uri, literal) -->
						<xsl:apply-templates select="$current/sparql:binding[@name=$name]"/>
					</xsl:when>
					<xsl:otherwise>
						<!-- no binding available for this variable in this solution -->
					  </xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</tr>
	</xsl:template>

	<xsl:template match="sparql:binding">
		<td>
			<xsl:apply-templates/>
		</td>
	</xsl:template>

	<xsl:template match="sparql:literal">
		&quot;<xsl:value-of select="text()"/>&quot;
	</xsl:template>

	<xsl:template match="sparql:uri">
		&lt;<a href="{text()}">
				<xsl:value-of select="text()"/>
			</a>&gt;
	</xsl:template>

	<xsl:template match="sparql:bnode">
		_:<xsl:value-of select="text()"/>
	</xsl:template>

</xsl:stylesheet>