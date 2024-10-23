<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:template match="Game_Info">
		<Game_Info>
			<xsl:apply-templates select="*" mode="game_info"/>
		</Game_Info>
	</xsl:template>
	<xsl:template match="*[@FromCoin != '']" mode="game_info">
		<xsl:choose>			
			<xsl:when test="@MaxHold != ''">
				<Hold>
					<FROM type="int">
						<xsl:value-of select="@FromCoin"/>
					</FROM>
					<TO type="int">
						<xsl:value-of select="@ToCoin"/>
					</TO>
					<VALUE type="double">
						<xsl:value-of select="@MinHold"/>
					</VALUE>
				</Hold>
				<Hold>
					<FROM type="int">
						<xsl:value-of select="@FromCoin"/>
					</FROM>
					<TO type="int">
						<xsl:value-of select="@ToCoin"/>
					</TO>
					<VALUE type="double">
						<xsl:value-of select="@MaxHold"/>
					</VALUE>
				</Hold>
			</xsl:when>
			<xsl:otherwise>
				<Hold>
					<FROM type="int">
						<xsl:value-of select="@FromCoin"/>
					</FROM>
					<TO type="int">
						<xsl:value-of select="@ToCoin"/>
					</TO>
					<VALUE type="double">
					       <xsl:choose>
						    <xsl:when test="string-length(text()) > 0"><xsl:value-of select="normalize-space(text())"/></xsl:when>
						    <xsl:otherwise><xsl:value-of select="@Min"/></xsl:otherwise>
						</xsl:choose>						
					</VALUE>
					<xsl:choose>
						<xsl:when test="@Min"><MIN type="double"><xsl:value-of select="@Min"/></MIN></xsl:when>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="@Max"><MAX type="double"><xsl:value-of select="@Max"/></MAX></xsl:when>
					</xsl:choose>
				</Hold>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="text()" mode="game_info">
		<xsl:value-of select="normalize-space(.)"/>
	</xsl:template>
	<xsl:template match="*" mode="game_info">
		<xsl:copy>
			<xsl:apply-templates select="*|text()" mode="game_info"/>
		</xsl:copy>
	</xsl:template>
	<!-- Convert sourceStr parameter to upper case and write out. -->
	<xsl:template name="upper">
		<xsl:param name="sourceStr"/>
		<xsl:value-of select="translate($sourceStr,
			'abcdefghijklmnopqrstuvwxyz',
			'ABCDEFGHIJKLMNOPQRSTUVWXYZ')" disable-output-escaping="yes"/>
	</xsl:template>
	<!-- Convert sourceStr parameter to lower case and write out. -->
	<xsl:template name="lower">
		<xsl:param name="sourceStr"/>
		<xsl:value-of select="translate($sourceStr,
			'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
			'abcdefghijklmnopqrstuvwxyz')" disable-output-escaping="yes"/>
	</xsl:template>
	<!-- Generate the glow mask based on the award mask. -->
	<xsl:template name="glowMask">
		<xsl:param name="mask"/>
		<xsl:param name="payType"/>
		<xsl:choose>
			<xsl:when test="$payType = 'Line' or $payType = 'Bonus' or $payType = 'Right2Left' or $payType = 'Right2LeftBonus'">
				<xsl:value-of select="normalize-space(translate($mask, 'X-', '10'))"/>
			</xsl:when>
			<xsl:when test="$payType = 'Scatter'">
				<xsl:value-of select="'Scatter glow mask not defined yet.'"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat('Unknown pay type: ', $payType)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Removes spaces and tabs from the string and writes out. -->
	<xsl:template name="trim">
		<xsl:param name="sourceStr"/>
		<xsl:value-of select="normalize-space($sourceStr)"/>
	</xsl:template>
	<!-- Add equally weighted stops with "symbols" 1 to stopNum -->
	<xsl:template name="addEqualStops">
		<xsl:param name="stopNum"/>
		<xsl:param name="maxball"/>
		<STOP node="node">
			<SYMBOL type="int">
				<xsl:value-of select="$stopNum"/>
			</SYMBOL>
			<WEIGHT type="int">1</WEIGHT>
		</STOP>
		<xsl:if test="$maxball > $stopNum">
			<xsl:call-template name="addEqualStops">
				<xsl:with-param name="stopNum" select="$stopNum+1"/>
				<xsl:with-param name="maxball" select="$maxball"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<!-- Unwind a number of the same stops -->
	<xsl:template name="unwindStops">
		<xsl:param name="stopCount"/>
		<xsl:param name="symbol"/>
		<STOP node="node">
			<SYMBOL type="String">
				<xsl:value-of select="$symbol"/>
			</SYMBOL>
			<WEIGHT type="int">1</WEIGHT>
		</STOP>
		<xsl:if test="$stopCount > 1">
			<xsl:call-template name="unwindStops">
				<xsl:with-param name="stopCount" select="$stopCount - 1"/>
				<xsl:with-param name="symbol" select="$symbol"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
