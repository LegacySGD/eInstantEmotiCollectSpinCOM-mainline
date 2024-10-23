<?xml version="1.0" encoding="UTF-8"?>
<!--
	USAGE: To use this style sheet include it and call it from the game ghst.xsl file:		<xsl:include href="../GhstUtils.xsl"/> < At the beginning of the file
		<xsl:call-template name="GhstUtils"/> <- Within the stylsheet
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:x="anything">
	<xsl:template name="GhstUtils">
			<x:decimal-format name="default" grouping-separator="," decimal-separator="." NaN="0"/>
			<x:decimal-format name="ARS" decimal-separator="," grouping-separator="." NaN="0"/>
			<x:decimal-format name="AUD" decimal-separator="." grouping-separator=" " NaN="0"/>
			<x:decimal-format name="BGN" decimal-separator="," grouping-separator=" " NaN="0"/>
			<x:decimal-format name="BRL" decimal-separator="," grouping-separator="." NaN="0"/>
			<x:decimal-format name="CAD" decimal-separator="." grouping-separator="," NaN="0"/>
			<x:decimal-format name="CHF" decimal-separator="." grouping-separator="'" NaN="0"/>
			<x:decimal-format name="CNY" decimal-separator="." grouping-separator="," NaN="0"/>
			<x:decimal-format name="CZK" decimal-separator="," grouping-separator="." NaN="0"/>
			<x:decimal-format name="DKK" decimal-separator="," grouping-separator="." NaN="0"/>
			<x:decimal-format name="EUR" decimal-separator="." grouping-separator="," NaN="0"/>
			<x:decimal-format name="FPY" decimal-separator="." grouping-separator="," NaN="0"/>
			<x:decimal-format name="FUN" decimal-separator="." grouping-separator="," NaN="0"/>
			<x:decimal-format name="GBP" decimal-separator="." grouping-separator="," NaN="0"/>
			<x:decimal-format name="HKD" decimal-separator="." grouping-separator="," NaN="0"/>
			<x:decimal-format name="HUF" decimal-separator="," grouping-separator="." NaN="0"/>
			<x:decimal-format name="INR" decimal-separator="." grouping-separator="," NaN="0"/>
			<x:decimal-format name="ISK" decimal-separator="." grouping-separator="," NaN="0"/>
			<x:decimal-format name="JPY" decimal-separator="." grouping-separator="," NaN="0"/>
			<x:decimal-format name="MXN" decimal-separator="." grouping-separator="," NaN="0"/>
			<x:decimal-format name="MYR" decimal-separator="." grouping-separator="," NaN="0"/>
			<x:decimal-format name="NOK" decimal-separator="," grouping-separator="." NaN="0"/>
			<x:decimal-format name="NZD" decimal-separator="." grouping-separator="," NaN="0"/>
			<x:decimal-format name="PLN" decimal-separator="," grouping-separator=" " NaN="0"/>
			<x:decimal-format name="RMB" decimal-separator="." grouping-separator="," NaN="0"/>
			<x:decimal-format name="RON" decimal-separator="," grouping-separator="." NaN="0"/>
			<x:decimal-format name="SEK" decimal-separator="," grouping-separator="." NaN="0"/>
			<x:decimal-format name="SGD" decimal-separator="." grouping-separator="," NaN="0"/>
			<x:decimal-format name="TCS" decimal-separator="." grouping-separator="," NaN="0"/>
			<x:decimal-format name="THB" decimal-separator="." grouping-separator="," NaN="0"/>
			<x:decimal-format name="TWD" decimal-separator="." grouping-separator="," NaN="0"/>
			<x:decimal-format name="UAH" decimal-separator="," grouping-separator=" " NaN="0"/>
			<x:decimal-format name="USD" decimal-separator="." grouping-separator="," NaN="0"/>
			<x:decimal-format name="ZAR" decimal-separator="." grouping-separator=" " NaN="0"/>

			<x:template name="Utils.ApplyConversion">
				<x:param name="multi"/>
				<x:param name="value"/>
				<x:param name="code"/>
				<x:variable name="nonNanValue">
					<x:choose>
						<x:when test="contains(number($value),'NaN')">
							<x:text>0</x:text>
						</x:when>
						<x:otherwise>
							<x:value-of select="$value"/>
						</x:otherwise>
					</x:choose>
				</x:variable>
				<x:choose>
					<x:when test="$code = 'ARS'">
						<x:variable name="symbol">$</x:variable>
						<x:variable name="side">left</x:variable>
						<x:call-template name="Utils.PrintConversion">
							<x:with-param name="symbol" select="$symbol"/>
							<x:with-param name="side" select="$side"/>
							<x:with-param name="code" select="$code"/>
							<x:with-param name="nonNanValue" select="$nonNanValue"/>
							<x:with-param name="multi" select="$multi"/>
							<x:with-param name="numberFormat">#.##0,00</x:with-param>
						</x:call-template>
					</x:when>
					<x:when test="$code = 'AUD'">
						<x:variable name="symbol">$</x:variable>
						<x:variable name="side">left</x:variable>
						<x:call-template name="Utils.PrintConversion">
							<x:with-param name="symbol" select="$symbol"/>
							<x:with-param name="side" select="$side"/>
							<x:with-param name="code" select="$code"/>
							<x:with-param name="nonNanValue" select="$nonNanValue"/>
							<x:with-param name="multi" select="$multi"/>
							<x:with-param name="numberFormat"># ##0.00</x:with-param>
						</x:call-template>
					</x:when>
					<x:when test="$code = 'BGN'">
						<x:variable name="symbol"><x:value-of select="' '"/>&#1083;&#1074;</x:variable>
						<x:variable name="side">right</x:variable>
						<x:call-template name="Utils.PrintConversion">
							<x:with-param name="symbol" select="$symbol"/>
							<x:with-param name="side" select="$side"/>
							<x:with-param name="code" select="$code"/>
							<x:with-param name="nonNanValue" select="$nonNanValue"/>
							<x:with-param name="multi" select="$multi"/>
							<x:with-param name="numberFormat"># ##0,00</x:with-param>
						</x:call-template>
					</x:when>
					<x:when test="$code = 'BRL'">
						<x:variable name="symbol">R$<x:value-of select="' '"/></x:variable>
						<x:variable name="side">left</x:variable>
						<x:call-template name="Utils.PrintConversion">
							<x:with-param name="symbol" select="$symbol"/>
							<x:with-param name="side" select="$side"/>
							<x:with-param name="code" select="$code"/>
							<x:with-param name="nonNanValue" select="$nonNanValue"/>
							<x:with-param name="multi" select="$multi"/>
							<x:with-param name="numberFormat">#.##0,00</x:with-param>
						</x:call-template>
					</x:when>
					<x:when test="$code = 'CAD'">
						<x:variable name="symbol">$</x:variable>
						<x:variable name="side">left</x:variable>
						<x:call-template name="Utils.PrintConversion">
							<x:with-param name="symbol" select="$symbol"/>
							<x:with-param name="side" select="$side"/>
							<x:with-param name="code" select="$code"/>
							<x:with-param name="nonNanValue" select="$nonNanValue"/>
							<x:with-param name="multi" select="$multi"/>
							<x:with-param name="numberFormat">#,##0.00</x:with-param>
						</x:call-template>
					</x:when>
					<x:when test="$code = 'CHF'">
						<x:variable name="symbol">CHF<x:value-of select="' '"/></x:variable>
						<x:variable name="side">left</x:variable>
						<x:call-template name="Utils.PrintConversion">
							<x:with-param name="symbol" select="$symbol"/>
							<x:with-param name="side" select="$side"/>
							<x:with-param name="code" select="$code"/>
							<x:with-param name="nonNanValue" select="$nonNanValue"/>
							<x:with-param name="multi" select="$multi"/>
							<x:with-param name="numberFormat">#'##0.00</x:with-param>
						</x:call-template>
					</x:when>
					<x:when test="$code = 'CNY'">
						<x:variable name="symbol">&#165;</x:variable>
						<x:variable name="side">left</x:variable>
						<x:call-template name="Utils.PrintConversion">
							<x:with-param name="symbol" select="$symbol"/>
							<x:with-param name="side" select="$side"/>
							<x:with-param name="code" select="$code"/>
							<x:with-param name="nonNanValue" select="$nonNanValue"/>
							<x:with-param name="multi" select="$multi"/>
							<x:with-param name="numberFormat">#,##0.00</x:with-param>
						</x:call-template>
					</x:when>
					<x:when test="$code = 'CZK'">
						<x:variable name="symbol"><x:value-of select="' '"/>K&#269;</x:variable>
						<x:variable name="side">right</x:variable>
						<x:call-template name="Utils.PrintConversion">
							<x:with-param name="symbol" select="$symbol"/>
							<x:with-param name="side" select="$side"/>
							<x:with-param name="code" select="$code"/>
							<x:with-param name="nonNanValue" select="$nonNanValue"/>
							<x:with-param name="multi" select="$multi"/>
							<x:with-param name="numberFormat">#.##0,00</x:with-param>
						</x:call-template>
					</x:when>
					<x:when test="$code = 'DKK'">
						<x:variable name="symbol">kr<x:value-of select="' '"/></x:variable>
						<x:variable name="side">left</x:variable>
						<x:call-template name="Utils.PrintConversion">
							<x:with-param name="symbol" select="$symbol"/>
							<x:with-param name="side" select="$side"/>
							<x:with-param name="code" select="$code"/>
							<x:with-param name="nonNanValue" select="$nonNanValue"/>
							<x:with-param name="multi" select="$multi"/>
							<x:with-param name="numberFormat">#.##0,00</x:with-param>
						</x:call-template>
					</x:when>
					<x:when test="$code = 'EUR'">
						<x:variable name="symbol">&#8364;<x:value-of select="' '"/></x:variable>
						<x:variable name="side">left</x:variable>
						<x:call-template name="Utils.PrintConversion">
							<x:with-param name="symbol" select="$symbol"/>
							<x:with-param name="side" select="$side"/>
							<x:with-param name="code" select="$code"/>
							<x:with-param name="nonNanValue" select="$nonNanValue"/>
							<x:with-param name="multi" select="$multi"/>
							<x:with-param name="numberFormat">#,##0.00</x:with-param>
						</x:call-template>
					</x:when>
					<x:when test="$code = 'FPY'">
						<x:variable name="symbol"></x:variable>
						<x:variable name="side">left</x:variable>
						<x:call-template name="Utils.PrintConversion">
							<x:with-param name="symbol" select="$symbol"/>
							<x:with-param name="side" select="$side"/>
							<x:with-param name="code" select="$code"/>
							<x:with-param name="nonNanValue" select="$nonNanValue"/>
							<x:with-param name="multi" select="$multi"/>
							<x:with-param name="numberFormat">###0.00</x:with-param>
						</x:call-template>
					</x:when>
					<x:when test="$code = 'FUN'">
						<x:variable name="symbol"></x:variable>
						<x:variable name="side">left</x:variable>
						<x:call-template name="Utils.PrintConversion">
							<x:with-param name="symbol" select="$symbol"/>
							<x:with-param name="side" select="$side"/>
							<x:with-param name="code" select="$code"/>
							<x:with-param name="nonNanValue" select="$nonNanValue"/>
							<x:with-param name="multi" select="$multi"/>
							<x:with-param name="numberFormat">###0.00</x:with-param>
						</x:call-template>
					</x:when>
					<x:when test="$code = 'GBP'">
						<x:variable name="symbol">&#163;</x:variable>
						<x:variable name="side">left</x:variable>
						<x:call-template name="Utils.PrintConversion">
							<x:with-param name="symbol" select="$symbol"/>
							<x:with-param name="side" select="$side"/>
							<x:with-param name="code" select="$code"/>
							<x:with-param name="nonNanValue" select="$nonNanValue"/>
							<x:with-param name="multi" select="$multi"/>
							<x:with-param name="numberFormat">#,##0.00</x:with-param>
						</x:call-template>
					</x:when>
					<x:when test="$code = 'HKD'">
						<x:variable name="symbol">$</x:variable>
						<x:variable name="side">left</x:variable>
						<x:call-template name="Utils.PrintConversion">
							<x:with-param name="symbol" select="$symbol"/>
							<x:with-param name="side" select="$side"/>
							<x:with-param name="code" select="$code"/>
							<x:with-param name="nonNanValue" select="$nonNanValue"/>
							<x:with-param name="multi" select="$multi"/>
							<x:with-param name="numberFormat">#,##0.00</x:with-param>
						</x:call-template>
					</x:when>
					<x:when test="$code = 'HUF'">
						<x:variable name="symbol"><x:value-of select="' '"/>Ft</x:variable>
						<x:variable name="side">right</x:variable>
						<x:call-template name="Utils.PrintConversion">
							<x:with-param name="symbol" select="$symbol"/>
							<x:with-param name="side" select="$side"/>
							<x:with-param name="code" select="$code"/>
							<x:with-param name="nonNanValue" select="$nonNanValue"/>
							<x:with-param name="multi" select="$multi"/>
							<x:with-param name="numberFormat">#.##0</x:with-param>
						</x:call-template>
					</x:when>
					<x:when test="$code = 'INR'">
						<x:variable name="symbol">INR<x:value-of select="' '"/></x:variable>
						<x:variable name="side">left</x:variable>
						<x:call-template name="Utils.PrintConversion">
							<x:with-param name="symbol" select="$symbol"/>
							<x:with-param name="side" select="$side"/>
							<x:with-param name="code" select="$code"/>
							<x:with-param name="nonNanValue" select="$nonNanValue"/>
							<x:with-param name="multi" select="$multi"/>
							<x:with-param name="numberFormat">#,##0.00</x:with-param>
						</x:call-template>
					</x:when>
					<x:when test="$code = 'ISK'">
						<x:variable name="symbol"><x:value-of select="' '"/>kr</x:variable>
						<x:variable name="side">right</x:variable>
						<x:call-template name="Utils.PrintConversion">
							<x:with-param name="symbol" select="$symbol"/>
							<x:with-param name="side" select="$side"/>
							<x:with-param name="code" select="$code"/>
							<x:with-param name="nonNanValue" select="$nonNanValue"/>
							<x:with-param name="multi" select="$multi"/>
							<x:with-param name="numberFormat">#,##0</x:with-param>
						</x:call-template>
					</x:when>
					<x:when test="$code = 'JPY'">
						<x:variable name="symbol">&#165;</x:variable>
						<x:variable name="side">left</x:variable>
						<x:call-template name="Utils.PrintConversion">
							<x:with-param name="symbol" select="$symbol"/>
							<x:with-param name="side" select="$side"/>
							<x:with-param name="code" select="$code"/>
							<x:with-param name="nonNanValue" select="$nonNanValue"/>
							<x:with-param name="multi" select="$multi"/>
							<x:with-param name="numberFormat">#,##0</x:with-param>
						</x:call-template>
					</x:when>
					<x:when test="$code = 'MXN'">
						<x:variable name="symbol">$</x:variable>
						<x:variable name="side">left</x:variable>
						<x:call-template name="Utils.PrintConversion">
							<x:with-param name="symbol" select="$symbol"/>
							<x:with-param name="side" select="$side"/>
							<x:with-param name="code" select="$code"/>
							<x:with-param name="nonNanValue" select="$nonNanValue"/>
							<x:with-param name="multi" select="$multi"/>
							<x:with-param name="numberFormat">#,##0.00</x:with-param>
						</x:call-template>
					</x:when>
					<x:when test="$code = 'MYR'">
						<x:variable name="symbol">RM</x:variable>
						<x:variable name="side">left</x:variable>
						<x:call-template name="Utils.PrintConversion">
							<x:with-param name="symbol" select="$symbol"/>
							<x:with-param name="side" select="$side"/>
							<x:with-param name="code" select="$code"/>
							<x:with-param name="nonNanValue" select="$nonNanValue"/>
							<x:with-param name="multi" select="$multi"/>
							<x:with-param name="numberFormat">#,##0.00</x:with-param>
						</x:call-template>
					</x:when>
					<x:when test="$code = 'NOK'">
						<x:variable name="symbol">kr<x:value-of select="' '"/></x:variable>
						<x:variable name="side">left</x:variable>
						<x:call-template name="Utils.PrintConversion">
							<x:with-param name="symbol" select="$symbol"/>
							<x:with-param name="side" select="$side"/>
							<x:with-param name="code" select="$code"/>
							<x:with-param name="nonNanValue" select="$nonNanValue"/>
							<x:with-param name="multi" select="$multi"/>
							<x:with-param name="numberFormat">#.##0,00</x:with-param>
						</x:call-template>
					</x:when>
					<x:when test="$code = 'NZD'">
						<x:variable name="symbol">$</x:variable>
						<x:variable name="side">left</x:variable>
						<x:call-template name="Utils.PrintConversion">
							<x:with-param name="symbol" select="$symbol"/>
							<x:with-param name="side" select="$side"/>
							<x:with-param name="code" select="$code"/>
							<x:with-param name="nonNanValue" select="$nonNanValue"/>
							<x:with-param name="multi" select="$multi"/>
							<x:with-param name="numberFormat">#,##0.00</x:with-param>
						</x:call-template>
					</x:when>
					<x:when test="$code = 'PLN'">
						<x:variable name="symbol"><x:value-of select="' '"/>z&#322;</x:variable>
						<x:variable name="side">right</x:variable>
						<x:call-template name="Utils.PrintConversion">
							<x:with-param name="symbol" select="$symbol"/>
							<x:with-param name="side" select="$side"/>
							<x:with-param name="code" select="$code"/>
							<x:with-param name="nonNanValue" select="$nonNanValue"/>
							<x:with-param name="multi" select="$multi"/>
							<x:with-param name="numberFormat"># ##0,00</x:with-param>
						</x:call-template>
					</x:when>
					<x:when test="$code = 'RMB'">
						<x:variable name="symbol">RMB<x:value-of select="' '"/></x:variable>
						<x:variable name="side">left</x:variable>
						<x:call-template name="Utils.PrintConversion">
							<x:with-param name="symbol" select="$symbol"/>
							<x:with-param name="side" select="$side"/>
							<x:with-param name="code" select="$code"/>
							<x:with-param name="nonNanValue" select="$nonNanValue"/>
							<x:with-param name="multi" select="$multi"/>
							<x:with-param name="numberFormat">#,##0.00</x:with-param>
						</x:call-template>
					</x:when>
					<x:when test="$code = 'RON'">
						<x:variable name="symbol"><x:value-of select="' '"/>lei</x:variable>
						<x:variable name="side">right</x:variable>
						<x:call-template name="Utils.PrintConversion">
							<x:with-param name="symbol" select="$symbol"/>
							<x:with-param name="side" select="$side"/>
							<x:with-param name="code" select="$code"/>
							<x:with-param name="nonNanValue" select="$nonNanValue"/>
							<x:with-param name="multi" select="$multi"/>
							<x:with-param name="numberFormat">#.##0,00</x:with-param>
						</x:call-template>
					</x:when>
					<x:when test="$code = 'SEK'">
						<x:variable name="symbol"><x:value-of select="' '"/>kr</x:variable>
						<x:variable name="side">right</x:variable>
						<x:call-template name="Utils.PrintConversion">
							<x:with-param name="symbol" select="$symbol"/>
							<x:with-param name="side" select="$side"/>
							<x:with-param name="code" select="$code"/>
							<x:with-param name="nonNanValue" select="$nonNanValue"/>
							<x:with-param name="multi" select="$multi"/>
							<x:with-param name="numberFormat">#.##0,00</x:with-param>
						</x:call-template>
					</x:when>
					<x:when test="$code = 'SGD'">
						<x:variable name="symbol">$</x:variable>
						<x:variable name="side">left</x:variable>
						<x:call-template name="Utils.PrintConversion">
							<x:with-param name="symbol" select="$symbol"/>
							<x:with-param name="side" select="$side"/>
							<x:with-param name="code" select="$code"/>
							<x:with-param name="nonNanValue" select="$nonNanValue"/>
							<x:with-param name="multi" select="$multi"/>
							<x:with-param name="numberFormat">#,##0.00</x:with-param>
						</x:call-template>
					</x:when>
					<x:when test="$code = 'TCS'">
						<x:variable name="symbol">&#20803;</x:variable>
						<x:variable name="side">right</x:variable>
						<x:call-template name="Utils.PrintConversion">
							<x:with-param name="symbol" select="$symbol"/>
							<x:with-param name="side" select="$side"/>
							<x:with-param name="code" select="$code"/>
							<x:with-param name="nonNanValue" select="$nonNanValue"/>
							<x:with-param name="multi" select="$multi"/>
							<x:with-param name="numberFormat">#,##0.00</x:with-param>
						</x:call-template>
					</x:when>
					<x:when test="$code = 'THB'">
						<x:variable name="symbol">&#3647;</x:variable>
						<x:variable name="side">left</x:variable>
						<x:call-template name="Utils.PrintConversion">
							<x:with-param name="symbol" select="$symbol"/>
							<x:with-param name="side" select="$side"/>
							<x:with-param name="code" select="$code"/>
							<x:with-param name="nonNanValue" select="$nonNanValue"/>
							<x:with-param name="multi" select="$multi"/>
							<x:with-param name="numberFormat">#,##0.00</x:with-param>
						</x:call-template>
					</x:when>
					<x:when test="$code = 'TWD'">
						<x:variable name="symbol">NT$</x:variable>
						<x:variable name="side">left</x:variable>
						<x:call-template name="Utils.PrintConversion">
							<x:with-param name="symbol" select="$symbol"/>
							<x:with-param name="side" select="$side"/>
							<x:with-param name="code" select="$code"/>
							<x:with-param name="nonNanValue" select="$nonNanValue"/>
							<x:with-param name="multi" select="$multi"/>
							<x:with-param name="numberFormat">#,##0.00</x:with-param>
						</x:call-template>
					</x:when>
					<x:when test="$code = 'UAH'">
						<x:variable name="symbol">UAH<x:value-of select="' '"/></x:variable>
						<x:variable name="side">left</x:variable>
						<x:call-template name="Utils.PrintConversion">
							<x:with-param name="symbol" select="$symbol"/>
							<x:with-param name="side" select="$side"/>
							<x:with-param name="code" select="$code"/>
							<x:with-param name="nonNanValue" select="$nonNanValue"/>
							<x:with-param name="multi" select="$multi"/>
							<x:with-param name="numberFormat"># ##0,00</x:with-param>
						</x:call-template>
					</x:when>
					<x:when test="$code = 'USD'">
						<x:variable name="symbol">$</x:variable>
						<x:variable name="side">left</x:variable>
						<x:call-template name="Utils.PrintConversion">
							<x:with-param name="symbol" select="$symbol"/>
							<x:with-param name="side" select="$side"/>
							<x:with-param name="code" select="$code"/>
							<x:with-param name="nonNanValue" select="$nonNanValue"/>
							<x:with-param name="multi" select="$multi"/>
							<x:with-param name="numberFormat">#,##0.00</x:with-param>
						</x:call-template>
					</x:when>
					<x:when test="$code = 'ZAR'">
						<x:variable name="symbol">R</x:variable>
						<x:variable name="side">left</x:variable>
						<x:call-template name="Utils.PrintConversion">
							<x:with-param name="symbol" select="$symbol"/>
							<x:with-param name="side" select="$side"/>
							<x:with-param name="code" select="$code"/>
							<x:with-param name="nonNanValue" select="$nonNanValue"/>
							<x:with-param name="multi" select="$multi"/>
							<x:with-param name="numberFormat"># ##0.00</x:with-param>
						</x:call-template>
					</x:when>
					<x:otherwise>
						<x:variable name="symbol"/>
						<x:variable name="side">left</x:variable>
						<x:call-template name="Utils.PrintConversion">
							<x:with-param name="symbol" select="$symbol"/>
							<x:with-param name="side" select="$side"/>
							<x:with-param name="code" select="default"/>
							<x:with-param name="nonNanValue" select="$nonNanValue"/>
							<x:with-param name="multi" select="$multi"/>
							<x:with-param name="numberFormat">###0</x:with-param>
						</x:call-template>
					</x:otherwise>
				</x:choose>
			</x:template>

			<x:template name="Utils.PrintConversion">
				<x:param name="symbol"/>
				<x:param name="side"/>
				<x:param name="code"/>
				<x:param name="nonNanValue"/>
				<x:param name="multi"/>
				<x:param name="numberFormat"/>
				<x:choose>
					<x:when test="$side = 'right'">
						<x:value-of select="concat(format-number(($multi * $nonNanValue), $numberFormat, $code), $symbol)" disable-output-escaping="yes"/>
					</x:when>
					<x:otherwise>
						<x:value-of select="concat($symbol, format-number(($multi * $nonNanValue), $numberFormat, $code))" disable-output-escaping="yes"/>
					</x:otherwise>
				</x:choose>
			</x:template>
	</xsl:template>
</xsl:stylesheet>
