<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" exclude-result-prefixes="java" xmlns:java="http://xml.apache.org/xslt/java" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:decimal-format name="default" grouping-separator="," decimal-separator="." NaN="0"/>
	<xsl:decimal-format name="ARS" decimal-separator="," grouping-separator="." NaN="0"/>
	<xsl:decimal-format name="AUD" decimal-separator="." grouping-separator=" " NaN="0"/>
	<xsl:decimal-format name="BGN" decimal-separator="," grouping-separator=" " NaN="0"/>
	<xsl:decimal-format name="BRL" decimal-separator="," grouping-separator="." NaN="0"/>
	<xsl:decimal-format name="CAD" decimal-separator="." grouping-separator="," NaN="0"/>
	<xsl:decimal-format name="FR-CACAD" decimal-separator="," grouping-separator=" " NaN="0"/>
	<xsl:decimal-format name="CHF" decimal-separator="." grouping-separator="'" NaN="0"/>
	<xsl:decimal-format name="CNY" decimal-separator="." grouping-separator="," NaN="0"/>
	<xsl:decimal-format name="CZK" decimal-separator="," grouping-separator="." NaN="0"/>
	<xsl:decimal-format name="DKK" decimal-separator="," grouping-separator="." NaN="0"/>
	<xsl:decimal-format name="EUR" decimal-separator="." grouping-separator="," NaN="0"/>
	<xsl:decimal-format name="NL-BEEUR" decimal-separator="," grouping-separator="." NaN="0"/>
	<xsl:decimal-format name="FR-BEEUR" decimal-separator="," grouping-separator="." NaN="0"/>
	<xsl:decimal-format name="DE-BEEUR" decimal-separator="," grouping-separator="." NaN="0"/>	
	<xsl:decimal-format name="FPY" decimal-separator="." grouping-separator="," NaN="0"/>
	<xsl:decimal-format name="FUN" decimal-separator="." grouping-separator="," NaN="0"/>
	<xsl:decimal-format name="GBP" decimal-separator="." grouping-separator="," NaN="0"/>
	<xsl:decimal-format name="HKD" decimal-separator="." grouping-separator="," NaN="0"/>
	<xsl:decimal-format name="HUF" decimal-separator="," grouping-separator="." NaN="0"/>
	<xsl:decimal-format name="INR" decimal-separator="." grouping-separator="," NaN="0"/>
	<xsl:decimal-format name="ISK" decimal-separator="." grouping-separator="," NaN="0"/>
	<xsl:decimal-format name="JPY" decimal-separator="." grouping-separator="," NaN="0"/>
	<xsl:decimal-format name="MXN" decimal-separator="." grouping-separator="," NaN="0"/>
	<xsl:decimal-format name="MYR" decimal-separator="." grouping-separator="," NaN="0"/>
	<xsl:decimal-format name="NOK" decimal-separator="," grouping-separator="." NaN="0"/>
	<xsl:decimal-format name="NZD" decimal-separator="." grouping-separator="," NaN="0"/>
	<xsl:decimal-format name="PLN" decimal-separator="," grouping-separator=" " NaN="0"/>
	<xsl:decimal-format name="RMB" decimal-separator="." grouping-separator="," NaN="0"/>
	<xsl:decimal-format name="RON" decimal-separator="," grouping-separator="." NaN="0"/>
	<xsl:decimal-format name="SEK" decimal-separator="," grouping-separator="." NaN="0"/>
	<xsl:decimal-format name="SGD" decimal-separator="." grouping-separator="," NaN="0"/>
	<xsl:decimal-format name="THB" decimal-separator="." grouping-separator="," NaN="0"/>
	<xsl:decimal-format name="TWD" decimal-separator="." grouping-separator="," NaN="0"/>
	<xsl:decimal-format name="UAH" decimal-separator="," grouping-separator=" " NaN="0"/>
	<xsl:decimal-format name="USD" decimal-separator="." grouping-separator="," NaN="0"/>
	<xsl:decimal-format name="ZAR" decimal-separator="." grouping-separator=" " NaN="0"/>
   <xsl:decimal-format name="PHP" decimal-separator="." grouping-separator=" " NaN="0"/>
	<xsl:decimal-format name="COP" decimal-separator="." grouping-separator="," NaN="0"/>

	<xsl:variable name="VALID_LOCALE" select="'ARS,AUD,BGN,BRL,CAD,FR-CACAD,CHF,CNY,CZK,DKK,EUR,NL-BEEUR,FR-BEEUR,DE-BEEUR,FPY,FUN,GBP,HKD,HUF,INR,ISK,JPY,MXN,MYR,NOK,NZD,PLN,RMB,RON,SEK,SGD,THB,TWD,UAH,USD,ZAR,PHP,COP'"/>
	<xsl:template name="Utils.ApplyConversionByLocale">
		<xsl:param name="multi"/>
		<xsl:param name="value"/>
		<xsl:param name="code"/>
		<xsl:param name="locale" />
		<xsl:variable name="lowerCase" select="'abcdefghijklmnopqrstuvwxyz_'"/>
		<xsl:variable name="upperCase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ-'"/>
		<xsl:variable name="localeU" select="translate($locale, $lowerCase, $upperCase)" />
		<xsl:variable name="currencyU" select="translate($code, $lowerCase, $upperCase)" />
		<xsl:variable name="combinationU" select="concat($localeU, $currencyU)" />
		<xsl:variable name="locale_currency">
			<xsl:choose>
				<xsl:when test="string-length($localeU) = 5 and contains($VALID_LOCALE, $combinationU)">
					<xsl:value-of select="$combinationU" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$currencyU" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:call-template name="Utils.ApplyConversion">
			<xsl:with-param name="multi" select="$multi" />
			<xsl:with-param name="value" select="$value" />
			<xsl:with-param name="code" select="$locale_currency" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="Utils.ApplyConversion">
		<xsl:param name="multi"/>
		<xsl:param name="value"/>
		<xsl:param name="code"/>
		<xsl:variable name="nonNanValue">
			<xsl:choose>
				<xsl:when test="contains(number($value),'NaN')">
					<xsl:text>0</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$value"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$code = 'ARS'">
				<xsl:variable name="symbol">$</xsl:variable>
				<xsl:variable name="side">left</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="$code"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat">#.##0,00</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$code = 'AUD'">
				<xsl:variable name="symbol">$</xsl:variable>
				<xsl:variable name="side">left</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="$code"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat"># ##0.00</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$code = 'BGN'">
				<xsl:variable name="symbol"><xsl:value-of select="' '"/>&#1083;&#1074;</xsl:variable>
				<xsl:variable name="side">right</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="$code"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat"># ##0,00</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$code = 'BRL'">
				<xsl:variable name="symbol">R$<xsl:value-of select="' '"/></xsl:variable>
				<xsl:variable name="side">left</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="$code"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat">#.##0,00</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$code = 'CAD'">
				<xsl:variable name="symbol">$</xsl:variable>
				<xsl:variable name="side">left</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="$code"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat">#,##0.00</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$code = 'FR-CACAD'">
				<xsl:variable name="symbol"><xsl:value-of select="' '"/>$</xsl:variable>
				<xsl:variable name="side">right</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="$code"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat"># ##0,00</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$code = 'CHF'">
				<xsl:variable name="symbol">CHF<xsl:value-of select="' '"/></xsl:variable>
				<xsl:variable name="side">left</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="$code"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat">#'##0.00</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$code = 'CNY'">
				<xsl:variable name="symbol">&#165;</xsl:variable>
				<xsl:variable name="side">left</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="$code"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat">#,##0.00</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$code = 'CZK'">
				<xsl:variable name="symbol"><xsl:value-of select="' '"/>K&#269;</xsl:variable>
				<xsl:variable name="side">right</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="$code"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat">#.##0,00</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$code = 'DKK'">
				<xsl:variable name="symbol">kr<xsl:value-of select="' '"/></xsl:variable>
				<xsl:variable name="side">left</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="$code"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat">#.##0,00</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$code = 'EUR'">
				<xsl:variable name="symbol">&#8364;<xsl:value-of select="' '"/></xsl:variable>
				<xsl:variable name="side">left</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="$code"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat">#,##0.00</xsl:with-param>
				</xsl:call-template>
			</xsl:when>			
			<xsl:when test="$code = 'NL-BEEUR'">
				<xsl:variable name="symbol">&#8364;<xsl:value-of select="' '"/></xsl:variable>
				<xsl:variable name="side">left</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="$code"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat">#.##0,00</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$code = 'FR-BEEUR'">
				<xsl:variable name="symbol"><xsl:value-of select="' '"/>&#8364;</xsl:variable>
				<xsl:variable name="side">right</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="$code"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat">#.##0,00</xsl:with-param>
				</xsl:call-template>
			</xsl:when>			
			<xsl:when test="$code = 'DE-BEEUR'">
				<xsl:variable name="symbol"><xsl:value-of select="' '"/>&#8364;</xsl:variable>
				<xsl:variable name="side">right</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="$code"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat">#.##0,00</xsl:with-param>
				</xsl:call-template>
			</xsl:when>						
			<xsl:when test="$code = 'FPY'">
				<xsl:variable name="symbol"></xsl:variable>
				<xsl:variable name="side">left</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="$code"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat">###0.00</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$code = 'FUN'">
				<xsl:variable name="symbol"></xsl:variable>
				<xsl:variable name="side">left</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="$code"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat">###0.00</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$code = 'GBP'">
				<xsl:variable name="symbol">&#163;</xsl:variable>
				<xsl:variable name="side">left</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="$code"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat">#,##0.00</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$code = 'HKD'">
				<xsl:variable name="symbol">$</xsl:variable>
				<xsl:variable name="side">left</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="$code"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat">#,##0.00</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$code = 'HUF'">
				<xsl:variable name="symbol"><xsl:value-of select="' '"/>Ft</xsl:variable>
				<xsl:variable name="side">right</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="$code"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat">#.##0</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$code = 'INR'">
				<xsl:variable name="symbol">INR<xsl:value-of select="' '"/></xsl:variable>
				<xsl:variable name="side">left</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="$code"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat">#,##0.00</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$code = 'ISK'">
				<xsl:variable name="symbol"><xsl:value-of select="' '"/>kr</xsl:variable>
				<xsl:variable name="side">right</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="$code"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat">#,##0</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$code = 'JPY'">
				<xsl:variable name="symbol">&#165;</xsl:variable>
				<xsl:variable name="side">left</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="$code"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat">#,##0</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$code = 'MXN'">
				<xsl:variable name="symbol">$</xsl:variable>
				<xsl:variable name="side">left</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="$code"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat">#,##0.00</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$code = 'MYR'">
				<xsl:variable name="symbol">RM</xsl:variable>
				<xsl:variable name="side">left</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="$code"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat">#,##0.00</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$code = 'NOK'">
				<xsl:variable name="symbol">kr<xsl:value-of select="' '"/></xsl:variable>
				<xsl:variable name="side">left</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="$code"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat">#.##0,00</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$code = 'NZD'">
				<xsl:variable name="symbol">$</xsl:variable>
				<xsl:variable name="side">left</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="$code"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat">#,##0.00</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$code = 'PLN'">
				<xsl:variable name="symbol"><xsl:value-of select="' '"/>z&#322;</xsl:variable>
				<xsl:variable name="side">right</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="$code"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat"># ##0,00</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$code = 'RMB'">
				<xsl:variable name="symbol">RMB<xsl:value-of select="' '"/></xsl:variable>
				<xsl:variable name="side">left</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="$code"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat">#,##0.00</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$code = 'RON'">
				<xsl:variable name="symbol"><xsl:value-of select="' '"/>lei</xsl:variable>
				<xsl:variable name="side">right</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="$code"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat">#.##0,00</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$code = 'SEK'">
				<xsl:variable name="symbol"><xsl:value-of select="' '"/>kr</xsl:variable>
				<xsl:variable name="side">right</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="$code"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat">#.##0,00</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$code = 'SGD'">
				<xsl:variable name="symbol">$</xsl:variable>
				<xsl:variable name="side">left</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="$code"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat">#,##0.00</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$code = 'THB'">
				<xsl:variable name="symbol">&#3647;</xsl:variable>
				<xsl:variable name="side">left</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="$code"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat">#,##0.00</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$code = 'TWD'">
				<xsl:variable name="symbol">NT$</xsl:variable>
				<xsl:variable name="side">left</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="$code"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat">#,##0.00</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$code = 'UAH'">
				<xsl:variable name="symbol">UAH<xsl:value-of select="' '"/></xsl:variable>
				<xsl:variable name="side">left</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="$code"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat"># ##0,00</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$code = 'USD'">
				<xsl:variable name="symbol">$</xsl:variable>
				<xsl:variable name="side">left</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="$code"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat">#,##0.00</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$code = 'ZAR'">
				<xsl:variable name="symbol">R</xsl:variable>
				<xsl:variable name="side">left</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="$code"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat"># ##0.00</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$code = 'PHP'">
				<xsl:variable name="symbol">₱</xsl:variable>
				<xsl:variable name="side">left</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="$code"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat">#,##0.00</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$code = 'COP'">
				<xsl:variable name="symbol">$</xsl:variable>
				<xsl:variable name="side">left</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="$code"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat">#,##0.00</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="symbol"/>
				<xsl:variable name="side">left</xsl:variable>
				<xsl:call-template name="Utils.PrintConversion">
					<xsl:with-param name="symbol" select="$symbol"/>
					<xsl:with-param name="side" select="$side"/>
					<xsl:with-param name="code" select="default"/>
					<xsl:with-param name="nonNanValue" select="$nonNanValue"/>
					<xsl:with-param name="multi" select="$multi"/>
					<xsl:with-param name="numberFormat">###0</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="Utils.PrintConversion">
		<xsl:param name="symbol"/>
		<xsl:param name="side"/>
		<xsl:param name="code"/>
		<xsl:param name="nonNanValue"/>
		<xsl:param name="multi"/>
		<xsl:param name="numberFormat"/>
		<xsl:choose>
			<xsl:when test="$side = 'right'">
				<xsl:value-of select="concat(format-number(($multi * $nonNanValue), $numberFormat, $code), $symbol)" disable-output-escaping="yes"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($symbol, format-number(($multi * $nonNanValue), $numberFormat, $code))" disable-output-escaping="yes"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
