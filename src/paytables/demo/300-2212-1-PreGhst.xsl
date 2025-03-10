<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:x="anything">
	<xsl:namespace-alias stylesheet-prefix="x" result-prefix="xsl" />
	<xsl:output encoding="UTF-8" indent="yes" method="xml" />
	<xsl:include href="../utils.xsl" />

	<xsl:template match="/Paytable">
		<x:stylesheet version="1.0" xmlns:java="http://xml.apache.org/xslt/java" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
			exclude-result-prefixes="java" xmlns:lxslt="http://xml.apache.org/xslt" xmlns:my-ext="ext1" extension-element-prefixes="my-ext">
			<x:import href="HTML-CCFR.xsl" />
			<x:output indent="no" method="xml" omit-xml-declaration="yes" />

			<!-- TEMPLATE Match: -->
			<x:template match="/">
				<x:apply-templates select="*" />
				<x:apply-templates select="/output/root[position()=last()]" mode="last" />
				<br />
			</x:template>

			<!--The component and its script are in the lxslt namespace and define the implementation of the extension. -->
			<lxslt:component prefix="my-ext" functions="formatJson,retrievePrizeTable,getType">
				<lxslt:script lang="javascript">
					<![CDATA[
	
var debugFeed = [];
var gridCells = {
	'baseGame':{'A':0,'B':0,'C':0,'D':0,'E':0,'F':0,},
	'actionBonusGame':{'A':0,'B':0,'C':0,'D':0,'E':0,'F':0,},
	'standardBonusGame':{}
};
var actionBonusEffect = {
	"S1":{ "source":[[18,25,26,20,13,12]]},
	"S2":{ "source":[[17,24,30,31,32,27,21,14,8,7,6,11]]},
	"S3":{ "source":[[16,23,29,34,35,36,37,33,28,22,15,9,4,3,2,1,5,10]]}, 
	"S4":{ "source":[[16,23,29,34,35,36,37,33,28,22,15,9,4,3,2,1,5,10],[18,25,26,20,13,12]]}, 
	"S5":{ "source":[[16,23,24,18,11,10],[31,36,37,33,27,26],[7,13,14,9,4,3]]}, 
	"S6":{ "source":[[23,29,30,25,18,17],[26,32,33,28,21,20],[6,12,13,8,3,2]]}, 
	"S7":{ "source":[[29,34,35,31,25,24],[20,27,28,22,15,14],[5,11,12,7,2,1]]}, 
	"S8":{ "source":[[30,35,36,32,26,25],[13,20,21,15,9,8],[10,17,18,12,6,5]]}, 
	"S9":{ "source":[[16,23,24,18,11,10],[30,35,36,32,26,25],[20,27,28,22,15,14],[6,12,13,8,3,2]]}, 
	"S10":{ "source":[[23,29,30,25,18,17],[31,36,37,33,27,26],[13,20,21,15,9,8],[5,11,12,7,2,1]]},
	"S11":{ "source":[[29,34,35,31,25,24],[26,32,33,28,21,20],[7,13,14,9,4,3],[10,17,18,12,6,5]]}, 

	"R1":{ "source":[["37322619120601"]]}, 
	"R2":{ "source":[["16171819202122"]]}, 
	"R3":{ "source":[["34302519130804"]]}, 
	"R4":{ "source":[["182526201312"]]},
	"R5":{ "source":[["24312714071119"]]},
	"R6":{ "source":[["17303221080619"]]}, 
	"R7":{ "source":[["16343722040119"]]}
};
var startIndex = 0;
function formatJson(jsonContext, translations, prizeValues, prizeNamesDesc) {
	var scenario = getScenario(jsonContext);
	var tranMap = parseTranslations(translations);
	var prizeMap = parsePrizes(prizeNamesDesc, prizeValues);
	return doFormatJson(scenario, tranMap, prizeMap);

}
function scenarioConvertor(scenario) {
	var scenarioDelimits = scenario.split("|");
	var columnDetails = scenarioDelimits[0].split(',').map(function(item){
		return item.match(/\w{2}/g);
	});
	var revealDetails = scenarioDelimits[scenarioDelimits.length-1];
	var standardBonus = [];
	var actionsBonus = [];
	if(scenarioDelimits[1]!==""){
		if(scenarioDelimits[1].indexOf(',')>-1){
			standardBonus = scenarioDelimits[1].split(',');
		}else{
			standardBonus = [scenarioDelimits[1]];
		}
	}
	if(scenarioDelimits[2]!==""){
		if(scenarioDelimits[2].indexOf(',')>-1){
			actionsBonus = scenarioDelimits[2].split(',');
		}else{
			actionsBonus = [scenarioDelimits[2]];
		}
	}

	var removalData = getRemoval(revealDetails, actionsBonus);
	getPlanetFromGame(columnDetails, removalData, actionsBonus, actionBonusEffect);
	if(standardBonus.length>=1){
		getResultFromStadardBonus(standardBonus);
	}
	return {
		columnDetails: columnDetails,
		revealDetails: revealDetails,
		standardBonus: standardBonus,
		actionsBonus: actionsBonus,
		removalData: removalData
	}
}

function getRemoval(revealDetails, actionsBonus){
	var revealDelimites = revealDetails.split(',');
	var removalData = {};
	var actionRemovel = false;
	var num=0;
	var actionFlag = 0;
	for(var i=0;i<revealDelimites.length;i++){
		var cv = revealDelimites[i];
		if(cv.indexOf("38") <= -1 && cv.indexOf("00") <= -1 && cv.indexOf("39") <= -1){
			removalData[num] = {};
			removalData[num].data = [];
			removalData[num].data.push(cv);
			removalData[num].flag = actionRemovel;
			if(actionRemovel){actionRemovel=false;}
			num++;
		}
		if(cv.indexOf("39") > -1){
			actionRemovel = true;
			var at = actionsBonus.slice(actionFlag,++actionFlag)[0];
			if(at.charAt(0)==="R"){
				removalData[num] = {};
				removalData[num].data = actionBonusEffect[at].source[0];
				removalData[num].flag = actionRemovel;
				removalData[num].actionRType = true;
				num++;
				actionRemovel = false;
			}
		}
	}
	return removalData;
}


function getCurrentMap(columnDetails){
	var columnsLength = [4,5,6,7,6,5,4];
	var key,value,currentMap={};
	for(var i=0;i<columnDetails.length;i++){
		key = i;
		value = columnDetails[i].slice(0,columnsLength[i]).reverse();
		currentMap[key] = value;
	}
	return currentMap;
}

function getCurrentRemoval(removalData){
	return removalData[startIndex].data[0];
}

function getCurrentActionFlag(removalData){
	return removalData[startIndex].flag;
}

function getCurrentActionType(removalData){
	return removalData[startIndex].actionRType;
}

function getTotalCollect(){
	var collectSymbols = [];
	var keys = Object.keys(gridCells.baseGame);
	var standardkeys = Object.keys(gridCells.standardBonusGame);
	for(var i=0;i<keys.length;i++){
		var num = gridCells.baseGame[keys[i]];
		num+=gridCells.actionBonusGame[keys[i]];
		for(var j=0;j<standardkeys.length;j++){
			if(gridCells.standardBonusGame[standardkeys[j]][keys[i]]){
				num+=gridCells.standardBonusGame[standardkeys[j]][keys[i]];
			}
		}
		collectSymbols.push(num);
	}
	
	return collectSymbols;
}

function getTotalWins(){
	var collectSymbols = getTotalCollect();
	var _map = {
		'0':'A',
		'1':'B',
		'2':'C',
		'3':'D',
		'4':'E',
		'5':'F',
	};
	var totalWins = collectSymbols.map(function(item,key){
		if(item>=16){
			return _map[key]+'1';
		}else if(item>=13&&item<=15){
			return _map[key]+'2';
		}else if(item>=10&&item<=12){
			return _map[key]+'3';
		}else{
			return '--';
		}
	});
	
	return totalWins;
}



function getPlanetFromGame(columnDetails, removalData, actionsBonus, actionBonusEffect){
	var columnsLength = [4,5,6,7,6,5,4];
	var _columnDetails = columnDetails;
	var _actionFlag = 0;
	var removalDataLen = 0,
		_removalData = removalData;
	for(var key in _removalData){
		removalDataLen++;
	}
	while(removalDataLen--){
		// map to array
		var mapToArray = [];
		mapToArray.push(null);
		var currentMap = getCurrentMap(columnDetails);
		for(var key in currentMap){
			currentMap[key].forEach(function(item){
				mapToArray.push(item);
			});
		}
		
		var actionFlag = getCurrentActionFlag(removalData);
		var removalArray = getCurrentRemoval(removalData);
		if(actionFlag){
			var actionType = actionsBonus.slice(_actionFlag,++_actionFlag);
			var actionArray = actionBonusEffect[actionType].source;
			if(!getCurrentActionType(removalData)){
				for(var i=0;i<actionArray.length;i++){
					var regulation1 = actionArray[i];
					for(var j=0,len=regulation1.length/2;j<len;j++){
						var temp = regulation1[j];
						var temp1 = regulation1[j+len];
						var value = mapToArray[temp];
						mapToArray[temp] = mapToArray[temp1];
						mapToArray[temp1] = value;
					}
				}
			}else{
				removalArray = actionBonusEffect[actionType].source[0]+"";
			}
		}
		if(removalArray.indexOf(":") > -1){
			removalArray = removalArray.split(':');
		}else{
			removalArray = [removalArray];
		}
		for(var i=0;i<removalArray.length;i++){
			var item = removalArray[i].match(/\w{2}/g);
			var len = item.length;
			var itemInMaps = item.map(function(_item){
				_item = Number(_item);
				var __item = mapToArray[_item];
				mapToArray[_item] = null;
				return __item;
			});
			if(getCurrentActionType(removalData)){
				var _actionBonusGamePoint = gridCells.actionBonusGame;
				itemInMaps.forEach(function(item){
					var type = item.charAt(0);
					if(_actionBonusGamePoint[type]){
						_actionBonusGamePoint[type] = _actionBonusGamePoint[type] + 1;
					}else{
						_actionBonusGamePoint[type] = 1;
					}
				});
			}else{
				var type = itemInMaps[0].charAt(0);
				if(actionFlag){
					if(gridCells.actionBonusGame[type]){
						gridCells.actionBonusGame[type] = gridCells.actionBonusGame[type] + len;
					}else{
						gridCells.actionBonusGame[type] = len;
					}
				}else{
					if(gridCells.baseGame[type]){
						gridCells.baseGame[type] = gridCells.baseGame[type] + len;
					}else{
						gridCells.baseGame[type] = len;
					}
				}
			}
		}
		
		mapToArray.shift();
		
		var arrayToMap = {};
		for(var i=0;i<_columnDetails.length;i++){
			var _item = mapToArray.splice(0,columnsLength[i]).reverse();
			arrayToMap[i] = _item;
		}
		
		for(var key1 in arrayToMap){
			arrayToMap[key1].forEach(function(item1,index1){
				_columnDetails[key1][index1] = item1;
			});
		}
		
		for(var i=0;i<_columnDetails.length;i++){
			var _columnData = _columnDetails[i];
			
			for(var j=0;j<_columnData.length;j++){
				while(_columnData[j]===null){
					_columnData.splice(j,1);
					_columnData.push(undefined);
				}
			}
		}		
		startIndex++;
	}
}

function getResultFromStadardBonus(standardBonus){
	for(var i=0;i<standardBonus.length;i++){
		gridCells.standardBonusGame[i]={};
		var _standardBonusGame = gridCells.standardBonusGame[i];
		var _arr = [];
		_arr = standardBonus[i].split("").map(function(item){
			if(item==='X'){
				return ""; 
			}else if(isNaN(item)){
				if(_standardBonusGame[item]){
					_standardBonusGame[item]++;
				}else{
					_standardBonusGame[item]=1;
				}
				return item;
			}else{
				return item;
			}
		});
		 
		gridCells.standardBonusGame[i]["standardBonusData"] = _arr;
	}
}

function labelText(r,condition,baseGameLabel,prizeMap){
	switch(condition){
		case "":
		r.push("&nbsp;");
		break;
		case 'A':
		r.push(baseGameLabel[5]);
		break;
		case 'B':
		r.push(baseGameLabel[4]);
		break;
		case 'C':
		r.push(baseGameLabel[3]);
		break;
		case 'D':
		r.push(baseGameLabel[2]);
		break;
		case 'E':
		r.push(baseGameLabel[1]);
		break;
		case 'F':
		r.push(baseGameLabel[0]);
		break;
		case '1':
		r.push(prizeMap['IW1']);
		break;
		case '2':
		r.push(prizeMap['IW2']);
		break;
		case '3':
		r.push(prizeMap['IW3']);
		break;
		
		default:
		break;
	}
}

function doFormatJson(scenario, tranMap, prizeMap) {
	var baseGameLabel = [
		tranMap.redPlanet,
		tranMap.orangePlanet,
		tranMap.greenPlanet,
		tranMap.purplePlanet,
		tranMap.yellowPlanet,
		tranMap.bluePlanet
	];
	var _map={'0':'F','1':'E','2':'D','3':'C','4':'B','5':'A',};
	var scenarioDelimits = scenario.split('|');
	
	var columnDetails = scenarioDelimits[0].split(',');
	
	var result = scenarioConvertor(scenario);
	var r = [];
	r.push('<table border="0" cellpadding="2" cellspacing="1" width="100%" class="gameDetailsTable" style="table-layout:fixed">');
	r.push('<tr>');
	r.push('<td class="tablehead" width="100%" colspan="8">');
	r.push(tranMap.outcomeLabel);
	r.push('</td>');
	r.push('</tr>');
	
	r.push('<tr>');
	r.push('<td class="tablehead" width="100%" colspan="8">');
	r.push(tranMap.baseGameTitle);
	r.push('</td>');
	r.push('</tr>');

	r.push('<tr>');
	r.push('<td class="tablebody" colspan="2" width="22%">');
	r.push(tranMap.symbol);
	r.push('</td>');
	for(var i=0;i<6;i++){
		r.push('<td class="tablebody" width="13%">');
		r.push(baseGameLabel[i]);
		r.push('</td>');
	}
	r.push('</tr>');
	r.push('<tr>');
	r.push('<td class="tablebody" colspan="2" width="22%">');
	r.push(tranMap.collectedNumber);
	r.push('</td>');
	for(var i=0;i<6;i++){
		r.push('<td class="tablebody" width="13%">');
		r.push(gridCells.baseGame[_map[i]]);
		r.push('</td>');
	}
	r.push('</tr>');
	r.push('</table>');
	
	var standardBonusLength = result.standardBonus.length||1;
	var _width = 18*standardBonusLength+'%';
	var str = '<table border="0" cellpadding="2" cellspacing="1" width='+_width+' class="gameDetailsTable" style="table-layout:fixed">';
	r.push(str);
	
	r.push('<tr>');
	str = '<td class="tablehead" width="13%" colspan='+ standardBonusLength +'>';
	r.push(str);
	r.push(tranMap.warpBonusTitle);
	r.push('</td>');
	r.push('</tr>');
	
	str = '<td class="tablebody" width="13%" colspan='+ standardBonusLength +'>';
	if(result.standardBonus.length >= 1){
		if(result.standardBonus.length > 1){
			var _standardBonusGameArr = [];
			for(var i=0;i<5;i++){
				_standardBonusGameArr[i]=[];
				for(var j=0;j<result.standardBonus.length;j++){
					var __standardBonusGameArr = gridCells.standardBonusGame[j].standardBonusData;
					_standardBonusGameArr[i].push(__standardBonusGameArr[i]);
				}
			}
			
			for(var i=0;i<5;i++){
				r.push('<tr>');
				for(var j=0;j<_standardBonusGameArr[i].length;j++){
					r.push('<td class="tablebody" width="13%">');
					labelText(r,_standardBonusGameArr[i][j],baseGameLabel,prizeMap);
					r.push('</td>');
				}
				
				r.push('</tr>');
			}	
		}else{
			var _standardBonusGameArr = gridCells.standardBonusGame[0].standardBonusData;
			for(var i=0;i<_standardBonusGameArr.length;i++){
				r.push('<tr>');
				r.push(str);
				labelText(r,_standardBonusGameArr[i],baseGameLabel,prizeMap);
				r.push('</td>');
				r.push('</tr>');
			}
		}
	}else{
		r.push('<tr>');
		r.push(str);
		r.push(tranMap.noWinLabel);
		r.push('</td>');
		r.push('</tr>');
	}
	
	r.push('</table>');
	
	if(result.actionsBonus.length){

		r.push('<table border="0" cellpadding="2" cellspacing="1" width="100%" class="gameDetailsTable" style="table-layout:fixed">');
		r.push('<tr>');
		r.push('<td class="tablehead" width="100%" colspan="8">');
		r.push(tranMap.whirlBonusTitle);
		r.push('</td>');
		r.push('</tr>');
		
		r.push('<tr>');
		r.push('<td class="tablebody" colspan="2" width="22%">');
		r.push(tranMap.symbol);
		r.push('</td>');
		for(var i=0;i<6;i++){
			r.push('<td class="tablebody" width="13%">');
			r.push(baseGameLabel[i]);
			r.push('</td>');
		}
		r.push('</tr>');
		
		r.push('<tr>');
		r.push('<td class="tablebody" colspan="2" width="22%">');
		r.push(tranMap.collectedNumber);
		r.push('</td>');
		for(var i=0;i<6;i++){
			r.push('<td class="tablebody" width="13%">');
			r.push(gridCells.actionBonusGame[_map[i]]);
			r.push('</td>');
		}
		r.push('</tr>');
		
		r.push('</table>');
		
	}else{
		r.push('<table border="0" cellpadding="2" cellspacing="1" width="18%" class="gameDetailsTable" style="table-layout:fixed">');
		r.push('<tr>');
		r.push('<td class="tablehead" width="100%">');
		r.push(tranMap.whirlBonusTitle);
		r.push('</td>');
		r.push('</tr>');
		
		r.push('<tr>');
		r.push('<td class="tablebody" width="100%">');
		r.push(tranMap.noWinLabel);
		r.push('</td>');
		r.push('</tr>');
		
		r.push('</table>');
	}
	
	
	r.push('<table border="0" cellpadding="2" cellspacing="1" width="100%" class="gameDetailsTable" style="table-layout:fixed">');
	r.push('<tr>');
	r.push('<td class="tablehead" width="100%" colspan="8">');
	r.push(tranMap.Summary);
	r.push('</td>');
	r.push('</tr>');
	
	r.push('<tr>');
	r.push('<td class="tablebody" colspan="2" width="22%">');
	r.push(tranMap.symbol);
	r.push('</td>');
	
	for(var i=0;i<6;i++){
		r.push('<td class="tablebody" width="13%">');
		r.push(baseGameLabel[i]);
		r.push('</td>');
	}
	r.push('</tr>');
	
	r.push('<tr>');
	r.push('<td class="tablebody" colspan="2" width="22%">');
	r.push(tranMap.collectedNumber);
	r.push('</td>');
	getTotalCollect().reverse().forEach(function(item){
		r.push('<td class="tablebody" width="13%">');
		r.push(item);
		r.push('</td>');
	});
	r.push('</tr>');
	
	r.push('<tr>');
	r.push('<td class="tablebody" colspan="2" width="22%">');
	r.push(tranMap.winPrizeLabel);
	r.push('</td>');
	getTotalWins().reverse().forEach(function(item){
		r.push('<td class="tablebody" width="13%">');
		if(item !== '--'){
			r.push(prizeMap[item]);	
		}else{
			r.push(item);	
		}
		r.push('</td>');
	});
	r.push('</tr>');
	
	r.push('</table>');
	
	return r.join('');
}
function getScenario(jsonContext) {
	var jsObj = JSON.parse(jsonContext);
	var scenario = jsObj.scenario;
	scenario = scenario.replace(/\0/g, '');
	return scenario;
}
function parsePrizes(prizeNamesDesc, prizeValues) {
	var prizeNames = (prizeNamesDesc.substring(1)).split(',');
	var convertedPrizeValues = (prizeValues.substring(1)).split('|');
	var map = [];
	for (var idx = 0; idx < prizeNames.length; idx++) {
		map[prizeNames[idx]] = convertedPrizeValues[idx];
	}
	return map;
}
function parseTranslations(translationNodeSet) {
	var map = [];
	var list = translationNodeSet.item(0).getChildNodes();
	for (var idx = 1; idx < list.getLength(); idx++) {
		var childNode = list.item(idx);
		if (childNode.name == "phrase") {
			map[childNode.getAttribute("key")] = childNode.getAttribute("value");
		}
	}
	return map;
}
// Input: A list of Price Points and the available Prize Structures for the game as well as the wagered price point
// Output: A string of the specific prize structure for the wagered price point
function retrievePrizeTable(pricePoints, prizeStructures, wageredPricePoint)
{
	var pricePointList = pricePoints.split(",");
	var prizeStructStrings = prizeStructures.split("|");


	for(var i = 0; i < pricePoints.length; ++i)
	{
		if(wageredPricePoint == pricePointList[i])
		{
			return prizeStructStrings[i];
		}
	}

	return "";
}
////////////////////////////////////////////////////////////////////////////////////////
function registerDebugText(debugText)
{
	debugFeed.push(debugText);
}
/////////////////////////////////////////////////////////////////////////////////////////
function getTranslationByName(keyName, translationNodeSet)
{
	var index = 1;
	while(index < translationNodeSet.item(0).getChildNodes().getLength())
	{
		var childNode = translationNodeSet.item(0).getChildNodes().item(index);
		
		if(childNode.name == "phrase" && childNode.getAttribute("key") == keyName)
		{
			registerDebugText("Child Node: " + childNode.name);
			return childNode.getAttribute("value");
		}
		
		index += 1;
	}
}


// Grab Wager Type
// @param jsonContext String JSON results to parse and display.
// @param translation Set of Translations for the game.
function getType(jsonContext, translations)
{
	// Parse json and retrieve wagerType string.
	var jsObj = JSON.parse(jsonContext);
	var wagerType = jsObj.wagerType;
	
	return parseTranslations(translations)[wagerType];
}
					]]>
				</lxslt:script>
			</lxslt:component>

			<x:template match="root" mode="last">
				<table border="0" cellpadding="1" cellspacing="1" width="100%" class="gameDetailsTable">
					<tr>
						<td valign="top" class="subheader">
							<x:value-of select="//translation/phrase[@key='totalWager']/@value" />
							<x:value-of select="': '" />
							<x:call-template name="Utils.ApplyConversionByLocale">
								<x:with-param name="multi" select="/output/denom/percredit" />
								<x:with-param name="value" select="//ResultData/WagerOutcome[@name='Game.Total']/@amount" />
								<x:with-param name="code" select="/output/denom/currencycode" />
								<x:with-param name="locale" select="//translation/@language" />
							</x:call-template>
						</td>
					</tr>
					<tr>
						<td valign="top" class="subheader">
							<x:value-of select="//translation/phrase[@key='totalWins']/@value" />
							<x:value-of select="': '" />
							<x:call-template name="Utils.ApplyConversionByLocale">
								<x:with-param name="multi" select="/output/denom/percredit" />
								<x:with-param name="value" select="//ResultData/PrizeOutcome[@name='Game.Total']/@totalPay" />
								<x:with-param name="code" select="/output/denom/currencycode" />
								<x:with-param name="locale" select="//translation/@language" />
							</x:call-template>
						</td>
					</tr>
				</table>
			</x:template>

			<!-- TEMPLATE Match: digested/game -->
			<x:template match="//Outcome">
				<x:if test="OutcomeDetail/Stage = 'Scenario'">
					<x:call-template name="Scenario.Detail" />
				</x:if>
			</x:template>

			<!-- TEMPLATE Name: Scenario.Detail (base game) -->
			<x:template name="Scenario.Detail">
				<x:variable name="odeResponseJson" select="string(//ResultData/JSONOutcome[@name='ODEResponse']/text())" />
				<x:variable name="translations" select="lxslt:nodeset(//translation)" />
				<x:variable name="wageredPricePoint" select="string(//ResultData/WagerOutcome[@name='Game.Total']/@amount)" />
				<x:variable name="prizeTable" select="lxslt:nodeset(//lottery)" />

				<table border="0" cellpadding="0" cellspacing="0" width="100%" class="gameDetailsTable">
					<tr>
						<td class="tablebold" background="">
							<x:value-of select="//translation/phrase[@key='wagerType']/@value" />
							<x:value-of select="': '" />
							<x:value-of select="my-ext:getType($odeResponseJson, $translations)" disable-output-escaping="yes" />
						</td>
					</tr>
					<tr>
						<td class="tablebold" background="">
							<x:value-of select="//translation/phrase[@key='transactionId']/@value" />
							<x:value-of select="': '" />
							<x:value-of select="OutcomeDetail/RngTxnId" />
						</td>
					</tr>
				</table>
				<br />			
				
				<x:variable name="convertedPrizeValues">
					<x:apply-templates select="//lottery/prizetable/prize" mode="PrizeValue"/>
				</x:variable>

				<x:variable name="prizeNames">
					<x:apply-templates select="//lottery/prizetable/description" mode="PrizeDescriptions"/>
				</x:variable>

			<x:value-of select="my-ext:formatJson($odeResponseJson, $translations, string($convertedPrizeValues), string($prizeNames))" disable-output-escaping="yes" />
			</x:template>

			<x:template match="prize" mode="PrizeValue">
					<x:text>|</x:text>
					<x:call-template name="Utils.ApplyConversionByLocale">
						<x:with-param name="multi" select="/output/denom/percredit" />
					<x:with-param name="value" select="text()" />
						<x:with-param name="code" select="/output/denom/currencycode" />
						<x:with-param name="locale" select="//translation/@language" />
					</x:call-template>
			</x:template>
			<x:template match="description" mode="PrizeDescriptions">
				<x:text>,</x:text>
				<x:value-of select="text()" />
			</x:template>

			<x:template match="text()" />
		</x:stylesheet>
	</xsl:template>

	<xsl:template name="TemplatesForResultXSL">
		<x:template match="@aClickCount">
			<clickcount>
				<x:value-of select="." />
			</clickcount>
		</x:template>
		<x:template match="*|@*|text()">
			<x:apply-templates />
		</x:template>
	</xsl:template>
</xsl:stylesheet>
