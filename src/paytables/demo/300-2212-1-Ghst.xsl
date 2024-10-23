<?xml version="1.0" encoding="UTF-8"?><xsl:stylesheet version="1.0" exclude-result-prefixes="java" extension-element-prefixes="my-ext" xmlns:lxslt="http://xml.apache.org/xslt" xmlns:java="http://xml.apache.org/xslt/java" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:my-ext="ext1">
<xsl:import href="HTML-CCFR.xsl"/>
<xsl:output indent="no" method="xml" omit-xml-declaration="yes"/>
<xsl:template match="/">
<xsl:apply-templates select="*"/>
<xsl:apply-templates select="/output/root[position()=last()]" mode="last"/>
<br/>
</xsl:template>
<lxslt:component prefix="my-ext" functions="formatJson retrievePrizeTable">
<lxslt:script lang="javascript">
					
	
function formatJson(jsonContext, translations, prizeValues, prizeNamesDesc) {
	var scenario = getScenario(jsonContext);
	var tranMap = parseTranslations(translations);
	var prizeMap = parsePrizes(prizeNamesDesc, prizeValues);
	return doFormatJson(scenario, tranMap, prizeMap);

}
function ScenarioConvertor(scenario) {
	this.gridCells = {
		'baseGame':{'A':0,'B':0,'C':0,'D':0,'E':0,'F':0,},
		'actionBonusGame':{'A':0,'B':0,'C':0,'D':0,'E':0,'F':0,},
		'standardBonusGame':{}
	};
	this.actionBonusEffect = {
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
	}
	this.startIndex = 0;
	this.scenario = scenario;
	this.scenarioDelimits = this.scenario.split("|");
	this.columnDetails = this.scenarioDelimits[0].split(',').map(function(item){
		return item.match(/\w{2}/g);
	});
	this.revealDetails = this.scenarioDelimits[this.scenarioDelimits.length-1];
	if(this.scenarioDelimits[1]!==""){
		if(this.scenarioDelimits[1].indexOf(',')&gt;-1){
			this.standardBonus = this.scenarioDelimits[1].split(',');
		}else{
			this.standardBonus = [this.scenarioDelimits[1]];
		}
	}else{
		this.standardBonus=[];
	}
	if(this.scenarioDelimits[2]!==""){
		if(this.scenarioDelimits[2].indexOf(',')&gt;-1){
			this.actionsBonus = this.scenarioDelimits[2].split(',');
		}else{
			this.actionsBonus = [this.scenarioDelimits[2]];
		}
	}else{
		this.actionsBonus=[];
	}

	this.removalData = this.getRemoval();
	this.getPlanetFromGame();
	if(this.standardBonus.length&gt;=1){
		this.getResultFromStadardBonus();
	}
}

ScenarioConvertor.prototype.getRemoval = function(){
	var revealDelimites = this.revealDetails.split(',');
	var removalData = {};
	var actionRemovel = false;
	var num=0;
	var actionFlag = 0;
	for(var i=0;i&lt;revealDelimites.length;i++){
		var cv = revealDelimites[i];
		if(cv.indexOf("38") &lt;= -1 &amp;&amp; cv.indexOf("00") &lt;= -1 &amp;&amp; cv.indexOf("39") &lt;= -1){
			removalData[num] = {};
			removalData[num].data = [];
			removalData[num].data.push(cv);
			removalData[num].flag = actionRemovel;
			if(actionRemovel){actionRemovel=false;}
			num++;
		}
		if(cv.indexOf("39") &gt; -1){
			actionRemovel = true;
			var at = this.actionsBonus.slice(actionFlag,++actionFlag)[0];
			if(at.charAt(0)==="R"){
				removalData[num] = {};
				removalData[num].data = this.actionBonusEffect[at].source[0];
				removalData[num].flag = actionRemovel;
				removalData[num].actionRType = true;
				num++;
				actionRemovel = false;
			}
		}
	}
	return removalData;
}


ScenarioConvertor.prototype.getCurrentMap = function(){
	var columnsLength = [4,5,6,7,6,5,4];
	var key,value,currentMap={};
	for(var i=0;i&lt;this.columnDetails.length;i++){
		key = i;
		value = this.columnDetails[i].slice(0,columnsLength[i]).reverse();
		currentMap[key] = value;
	}
	return currentMap;
}

ScenarioConvertor.prototype.getCurrentRemoval = function(){
	return this.removalData[this.startIndex].data[0];
}

ScenarioConvertor.prototype.getCurrentActionFlag = function(){
	return this.removalData[this.startIndex].flag;
}

ScenarioConvertor.prototype.getCurrentActionType = function(){
	return this.removalData[this.startIndex].actionRType;
}

ScenarioConvertor.prototype.getTotalCollect = function(){
	var collectSymbols = [];
	var keys = Object.keys(this.gridCells.baseGame);
	var standardkeys = Object.keys(this.gridCells.standardBonusGame);
	for(var i=0;i&lt;keys.length;i++){
		var num = this.gridCells.baseGame[keys[i]];
		num+=this.gridCells.actionBonusGame[keys[i]];
		for(var j=0;j&lt;standardkeys.length;j++){
			if(this.gridCells.standardBonusGame[standardkeys[j]][keys[i]]){
				num+=this.gridCells.standardBonusGame[standardkeys[j]][keys[i]];
			}
		}
		collectSymbols.push(num);
	}
	
	return collectSymbols;
}

ScenarioConvertor.prototype.getTotalWins = function(){
	var collectSymbols = this.getTotalCollect();
	var _map = {
		'0':'A',
		'1':'B',
		'2':'C',
		'3':'D',
		'4':'E',
		'5':'F',
	};
	var totalWins = collectSymbols.map(function(item,key){
		if(item&gt;=16){
			return _map[key]+'1';
		}else if(item&gt;=13&amp;&amp;item&lt;=15){
			return _map[key]+'2';
		}else if(item&gt;=10&amp;&amp;item&lt;=12){
			return _map[key]+'3';
		}else{
			return '--';
		}
	});
	
	return totalWins;
}



ScenarioConvertor.prototype.getPlanetFromGame = function(){
	var columnsLength = [4,5,6,7,6,5,4];
	var columnDetails = this.columnDetails;
	var _actionFlag = 0;
	var removalDataLen = 0,
		removalData = this.removalData;
	for(var key in removalData){
		removalDataLen++;
	}
	while(removalDataLen--){
		// map to array
		var mapToArray = [];
		mapToArray.push(null);
		var currentMap = this.getCurrentMap();
		for(var key in currentMap){
			currentMap[key].forEach(function(item){
				mapToArray.push(item);
			});
		}
		
		var actionFlag = this.getCurrentActionFlag();
		var removalArray = this.getCurrentRemoval();
		if(actionFlag){
			var actionType = this.actionsBonus.slice(_actionFlag,++_actionFlag);
			var actionArray = this.actionBonusEffect[actionType].source;
			if(!this.getCurrentActionType()){
				for(var i=0;i&lt;actionArray.length;i++){
					var regulation1 = actionArray[i];
					for(var j=0,len=regulation1.length/2;j&lt;len;j++){
						var temp = regulation1[j];
						var temp1 = regulation1[j+len];
						var value = mapToArray[temp];
						mapToArray[temp] = mapToArray[temp1];
						mapToArray[temp1] = value;
					}
				}
			}else{
				removalArray = this.actionBonusEffect[actionType].source[0]+"";
			}
		}
		if(removalArray.indexOf(":") &gt; -1){
			removalArray = removalArray.split(':');
		}else{
			removalArray = [removalArray];
		}
		for(var i=0;i&lt;removalArray.length;i++){
			var item = removalArray[i].match(/\w{2}/g);
			var len = item.length;
			var itemInMaps = item.map(function(_item){
				_item = Number(_item);
				var __item = mapToArray[_item];
				mapToArray[_item] = null;
				return __item;
			});
			if(this.getCurrentActionType()){
				var _actionBonusGamePoint = this.gridCells.actionBonusGame;
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
					if(this.gridCells.actionBonusGame[type]){
						this.gridCells.actionBonusGame[type] = this.gridCells.actionBonusGame[type] + len;
					}else{
						this.gridCells.actionBonusGame[type] = len;
					}
				}else{
					if(this.gridCells.baseGame[type]){
						this.gridCells.baseGame[type] = this.gridCells.baseGame[type] + len;
					}else{
						this.gridCells.baseGame[type] = len;
					}
				}
			}
		}
		
		mapToArray.shift();
		
		var arrayToMap = {};
		for(var i=0;i&lt;columnDetails.length;i++){
			var _item = mapToArray.splice(0,columnsLength[i]).reverse();
			arrayToMap[i] = _item;
		}
		
		for(var key1 in arrayToMap){
			arrayToMap[key1].forEach(function(item1,index1){
				columnDetails[key1][index1] = item1;
			});
		}
		
		for(var i=0;i&lt;columnDetails.length;i++){
			var _columnData = columnDetails[i];
			
			for(var j=0;j&lt;_columnData.length;j++){
				while(_columnData[j]===null){
					_columnData.splice(j,1);
					_columnData.push(undefined);
				}
			}
		}		
		this.startIndex++;
	}
}

ScenarioConvertor.prototype.getResultFromStadardBonus = function(){
	for(var i=0;i&lt;this.standardBonus.length;i++){
		this.gridCells.standardBonusGame[i]={};
		var _standardBonusGame = this.gridCells.standardBonusGame[i];
		var _arr = [];
		_arr = this.standardBonus[i].split("").map(function(item){
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
		 
		this.gridCells.standardBonusGame[i]["standardBonusData"] = _arr;
	}
}

function labelText(r,condition,baseGameLabel,prizeMap){
	switch(condition){
		case "":
		r.push("&amp;nbsp");
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
	
	var result = new ScenarioConvertor(scenario);
	var r = [];
	r.push('&lt;table border="0" cellpadding="2" cellspacing="1" width="100%" class="gameDetailsTable" style="table-layout:fixed"&gt;');
	r.push('&lt;tr&gt;');
	r.push('&lt;td class="tablehead" width="100%" colspan="8"&gt;');
	r.push(tranMap.outcomeLabel);
	r.push('&lt;/td&gt;');
	r.push('&lt;/tr&gt;');
	
	r.push('&lt;tr&gt;');
	r.push('&lt;td class="tablehead" width="100%" colspan="8"&gt;');
	r.push(tranMap.baseGameTitle);
	r.push('&lt;/td&gt;');
	r.push('&lt;/tr&gt;');

	r.push('&lt;tr&gt;');
	r.push('&lt;td class="tablebody" colspan="2" width="22%"&gt;');
	r.push(tranMap.symbol);
	r.push('&lt;/td&gt;');
	for(var i=0;i&lt;6;i++){
		r.push('&lt;td class="tablebody" width="13%"&gt;');
		r.push(baseGameLabel[i]);
		r.push('&lt;/td&gt;');
	}
	r.push('&lt;/tr&gt;');
	r.push('&lt;tr&gt;');
	r.push('&lt;td class="tablebody" colspan="2" width="22%"&gt;');
	r.push(tranMap.collectedNumber);
	r.push('&lt;/td&gt;');
	for(var i=0;i&lt;6;i++){
		r.push('&lt;td class="tablebody" width="13%"&gt;');
		r.push(result.gridCells.baseGame[_map[i]]);
		r.push('&lt;/td&gt;');
	}
	r.push('&lt;/tr&gt;');
	r.push('&lt;/table&gt;');
	
	r.push('&lt;div width="100%" class="blankStyle"&gt;');
	r.push('&lt;div/&gt;');
	
	var standardBonusLength = result.standardBonus.length||1;
	var _width = 18*standardBonusLength+'%';
	var str = '&lt;table border="0" cellpadding="2" cellspacing="1" width='+_width+' class="gameDetailsTable" style="table-layout:fixed"&gt;';
	r.push(str);
	
	r.push('&lt;tr&gt;');
	str = '&lt;td class="tablehead" width="13%" colspan='+ standardBonusLength +'&gt;';
	r.push(str);
	r.push(tranMap.warpBonusTitle);
	r.push('&lt;/td&gt;');
	r.push('&lt;/tr&gt;');
	
	str = '&lt;td class="tablebody" width="13%" colspan='+ standardBonusLength +'&gt;';
	if(result.standardBonus.length &gt;= 1){
		if(result.standardBonus.length &gt; 1){
			var _standardBonusGameArr = [];
			for(var i=0;i&lt;5;i++){
				_standardBonusGameArr[i]=[];
				for(var j=0;j&lt;result.standardBonus.length;j++){
					var __standardBonusGameArr = result.gridCells.standardBonusGame[j].standardBonusData;
					_standardBonusGameArr[i].push(__standardBonusGameArr[i]);
				}
			}
			
			for(var i=0;i&lt;5;i++){
				r.push('&lt;tr&gt;');
				for(var j=0;j&lt;_standardBonusGameArr[i].length;j++){
					r.push('&lt;td class="tablebody" width="13%"&gt;');
					labelText(r,_standardBonusGameArr[i][j],baseGameLabel,prizeMap);
					r.push('&lt;/td&gt;');
				}
				
				r.push('&lt;/tr&gt;');
			}	
		}else{
			var _standardBonusGameArr = result.gridCells.standardBonusGame[0].standardBonusData;
			for(var i=0;i&lt;_standardBonusGameArr.length;i++){
				r.push('&lt;tr&gt;');
				r.push(str);
				labelText(r,_standardBonusGameArr[i],baseGameLabel,prizeMap);
				r.push('&lt;/td&gt;');
				r.push('&lt;/tr&gt;');
			}
		}
	}else{
		r.push('&lt;tr&gt;');
		r.push(str);
		r.push(tranMap.noWinLabel);
		r.push('&lt;/td&gt;');
		r.push('&lt;/tr&gt;');
	}
	
	r.push('&lt;/table&gt;');
	r.push('&lt;div width="100%" class="blankStyle"&gt;');
	r.push('&lt;div/&gt;');
	
	
	if(result.actionsBonus.length){

		r.push('&lt;table border="0" cellpadding="2" cellspacing="1" width="100%" class="gameDetailsTable" style="table-layout:fixed"&gt;');
		r.push('&lt;tr&gt;');
		r.push('&lt;td class="tablehead" width="100%" colspan="8"&gt;');
		r.push(tranMap.whirlBonusTitle);
		r.push('&lt;/td&gt;');
		r.push('&lt;/tr&gt;');
		
		r.push('&lt;tr&gt;');
		r.push('&lt;td class="tablebody" colspan="2" width="22%"&gt;');
		r.push(tranMap.symbol);
		r.push('&lt;/td&gt;');
		for(var i=0;i&lt;6;i++){
			r.push('&lt;td class="tablebody" width="13%"&gt;');
			r.push(baseGameLabel[i]);
			r.push('&lt;/td&gt;');
		}
		r.push('&lt;/tr&gt;');
		
		r.push('&lt;tr&gt;');
		r.push('&lt;td class="tablebody" colspan="2" width="22%"&gt;');
		r.push(tranMap.collectedNumber);
		r.push('&lt;/td&gt;');
		for(var i=0;i&lt;6;i++){
			r.push('&lt;td class="tablebody" width="13%"&gt;');
			r.push(result.gridCells.actionBonusGame[_map[i]]);
			r.push('&lt;/td&gt;');
		}
		r.push('&lt;/tr&gt;');
		
		r.push('&lt;/table&gt;');
		
	}else{
		r.push('&lt;table border="0" cellpadding="2" cellspacing="1" width="18%" class="gameDetailsTable" style="table-layout:fixed"&gt;');
		r.push('&lt;tr&gt;');
		r.push('&lt;td class="tablehead" width="100%"&gt;');
		r.push(tranMap.whirlBonusTitle);
		r.push('&lt;/td&gt;');
		r.push('&lt;/tr&gt;');
		
		r.push('&lt;tr&gt;');
		r.push('&lt;td class="tablebody" width="100%"&gt;');
		r.push(tranMap.noWinLabel);
		r.push('&lt;/td&gt;');
		r.push('&lt;/tr&gt;');
		
		r.push('&lt;/table&gt;');
	}
	
	r.push('&lt;div width="100%" class="blankStyle"&gt;');
	r.push('&lt;div/&gt;');
	
	
	r.push('&lt;table border="0" cellpadding="2" cellspacing="1" width="100%" class="gameDetailsTable" style="table-layout:fixed"&gt;');
	r.push('&lt;tr&gt;');
	r.push('&lt;td class="tablehead" width="100%" colspan="8"&gt;');
	r.push(tranMap.Summary);
	r.push('&lt;/td&gt;');
	r.push('&lt;/tr&gt;');
	
	r.push('&lt;tr&gt;');
	r.push('&lt;td class="tablebody" colspan="2" width="22%"&gt;');
	r.push(tranMap.symbol);
	r.push('&lt;/td&gt;');
	
	for(var i=0;i&lt;6;i++){
		r.push('&lt;td class="tablebody" width="13%"&gt;');
		r.push(baseGameLabel[i]);
		r.push('&lt;/td&gt;');
	}
	r.push('&lt;/tr&gt;');
	
	r.push('&lt;tr&gt;');
	r.push('&lt;td class="tablebody" colspan="2" width="22%"&gt;');
	r.push(tranMap.collectedNumber);
	r.push('&lt;/td&gt;');
	result.getTotalCollect().reverse().forEach(function(item){
		r.push('&lt;td class="tablebody" width="13%"&gt;');
		r.push(item);
		r.push('&lt;/td&gt;');
	});
	r.push('&lt;/tr&gt;');
	
	r.push('&lt;tr&gt;');
	r.push('&lt;td class="tablebody" colspan="2" width="22%"&gt;');
	r.push(tranMap.winPrizeLabel);
	r.push('&lt;/td&gt;');
	result.getTotalWins().reverse().forEach(function(item){
		r.push('&lt;td class="tablebody" width="13%"&gt;');
		if(item !== '--'){
			r.push(prizeMap[item]);	
		}else{
			r.push(item);	
		}
		r.push('&lt;/td&gt;');
	});
	r.push('&lt;/tr&gt;');
	
	r.push('&lt;/table&gt;');

	r.push('&lt;div width="100%" class="blankStyle"&gt;');
	r.push('&lt;div/&gt;');
	
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
	for (var idx = 0; idx &lt; prizeNames.length; idx++) {
		map[prizeNames[idx]] = convertedPrizeValues[idx];
	}
	return map;
}
function parseTranslations(translationNodeSet) {
	var map = [];
	var list = translationNodeSet.item(0).getChildNodes();
	for (var idx = 1; idx &lt; list.getLength(); idx++) {
		var childNode = list.item(idx);
		if (childNode.name == "phrase") {
			map[childNode.getAttribute("key")] = childNode.getAttribute("value");
		}
	}
	return map;
}
					
				</lxslt:script>
</lxslt:component>
<xsl:template match="root" mode="last">
<table border="0" cellpadding="1" cellspacing="1" width="100%" class="gameDetailsTable">
<tr>
<td valign="top" class="subheader">
<xsl:value-of select="//translation/phrase[@key='totalWager']/@value"/>
<xsl:value-of select="': '"/>
<xsl:call-template name="Utils.ApplyConversionByLocale">
<xsl:with-param name="multi" select="/output/denom/percredit"/>
<xsl:with-param name="value" select="//ResultData/WagerOutcome[@name='Game.Total']/@amount"/>
<xsl:with-param name="code" select="/output/denom/currencycode"/>
<xsl:with-param name="locale" select="//translation/@language"/>
</xsl:call-template>
</td>
</tr>
<tr>
<td valign="top" class="subheader">
<xsl:value-of select="//translation/phrase[@key='totalWins']/@value"/>
<xsl:value-of select="': '"/>
<xsl:call-template name="Utils.ApplyConversionByLocale">
<xsl:with-param name="multi" select="/output/denom/percredit"/>
<xsl:with-param name="value" select="//ResultData/PrizeOutcome[@name='Game.Total']/@totalPay"/>
<xsl:with-param name="code" select="/output/denom/currencycode"/>
<xsl:with-param name="locale" select="//translation/@language"/>
</xsl:call-template>
</td>
</tr>
</table>
</xsl:template>
<xsl:template match="//Outcome">
<xsl:if test="OutcomeDetail/Stage = 'Scenario'">
<xsl:call-template name="Scenario.Detail"/>
</xsl:if>
</xsl:template>
<xsl:template name="Scenario.Detail">
<xsl:variable name="odeResponseJson" select="string(//ResultData/JSONOutcome[@name='ODEResponse']/text())"/>
<xsl:variable name="translations" select="lxslt:nodeset(//translation)"/>
<xsl:variable name="wageredPricePoint" select="string(//ResultData/WagerOutcome[@name='Game.Total']/@amount)"/>
<xsl:variable name="prizeTable" select="lxslt:nodeset(//lottery)"/>
<table border="0" cellpadding="0" cellspacing="0" width="100%" class="gameDetailsTable">
<tr>
<td class="tablebold" background="">
<xsl:value-of select="//translation/phrase[@key='wagerType']/@value"/>
<xsl:value-of select="': '"/>
<xsl:value-of select="my-ext:getType($odeResponseJson, $translations)" disable-output-escaping="yes"/>
</td>
</tr>
<tr>
<td class="tablebold" background="">
<xsl:value-of select="//translation/phrase[@key='transactionId']/@value"/>
<xsl:value-of select="': '"/>
<xsl:value-of select="OutcomeDetail/RngTxnId"/>
</td>
</tr>
</table>
<br/>
<xsl:variable name="convertedPrizeValues">
<xsl:apply-templates select="//lottery/prizetable/prize" mode="PrizeValue"/>
</xsl:variable>
<xsl:variable name="prizeNames">
<xsl:apply-templates select="//lottery/prizetable/description" mode="PrizeDescriptions"/>
</xsl:variable>
<xsl:value-of select="my-ext:formatJson($odeResponseJson, $translations, $prizeTable, string($convertedPrizeValues), string($prizeNames))" disable-output-escaping="yes"/>
</xsl:template>
<xsl:template match="prize" mode="PrizeValue">
<xsl:text>|</xsl:text>
<xsl:call-template name="Utils.ApplyConversionByLocale">
<xsl:with-param name="multi" select="/output/denom/percredit"/>
<xsl:with-param name="value" select="text()"/>
<xsl:with-param name="code" select="/output/denom/currencycode"/>
<xsl:with-param name="locale" select="//translation/@language"/>
</xsl:call-template>
</xsl:template>
<xsl:template match="description" mode="PrizeDescriptions">
<xsl:text>,</xsl:text>
<xsl:value-of select="text()"/>
</xsl:template>
<xsl:template match="text()"/>
</xsl:stylesheet>
