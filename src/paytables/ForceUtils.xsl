<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">

	<xsl:template name="ForceUtils.ImportJSUtils">
	
		<!-- Wrap all ForceUtils variables and functions an anonymous function to act as a namespace -->
		<xsl:text>var ForceUtils = new function() {</xsl:text>
	
		<!-- 
		// Associative array containing all entries for each population info in paytable.
		// Example data:
		// { 'Reeler3x3x3x3x3':['Reel0','Reel1','Reel2','Reel3','Reel4'], ... }
		// Can be accessed like this:
		// var entryNames = this.populationInfoData['Reeler3x3x3x3x3']; // entryNames == ['Reel0','Reel1',...]
		 -->
		<xsl:text>this.populationInfoData = {</xsl:text>
		<xsl:apply-templates select="/Paytable/PaytableData/PopulationInfo" mode="ForceUtils.JS.PopulationInfo"/>
		<xsl:text>};</xsl:text>
		
		<!-- 
		// Nested associative array containing symbol id to name mappings for all symbol infos.
		// Example data:
		// {'BaseGame.Symbols':{'s01':'Goddess','s02':'Horse'}, 'FreeSpin.Symbols':{'s01':'Goddess','s02':'Horse'}}
		// Can be accessed like this:
		// var symbolId = this.symbolInfoData['BaseGame.Symbols']['s01'];
		 -->
		<xsl:text>this.symbolInfoData = {</xsl:text>
		<xsl:apply-templates select="/Paytable/PaytableData/SymbolInfo" mode="ForceUtils.JS.SymbolInfo"/>
		<xsl:text>};</xsl:text>
		
		<![CDATA[
		
		//
		// Sets the selected index of all select objects in a specific force tool section and submits the form.
		// param - executionModelName - Name of execution model for force tool section (string)
		// param - populationInfoName - Name of population info for force tool section (string)
		// param - symbolIdArray - Array of strings holding target symbol Ids to be selected. Array size must match number of
		//         entries in population info. If a symbol matches string 'XX', the respective select object will not be altered.
		// param - symbolInfoName (optional) - Name of symbol info for translating symbol IDs. Will find first match if none is supplied.
		// returns - nothing
		//
		// Example Usage: ForceUtils.SetMultipleSelectedSymbolsByIdAndSubmit('BaseGame', 'Reeler3x3x3x3x3', ['XX','b01','b01','b01','XX'])
		//                ForceUtils.SetMultipleSelectedSymbolsByIdAndSubmit('BaseGame', 'Reeler3x3x3x3x3', ['XX','b01','b01','b01','XX'], 'BaseGame.Symbols')
		//
		this.SetMultipleSelectedSymbolsByIdAndSubmit = function(executionModelName, populationInfoName, symbolIdArray, symbolInfoName) {
			this.SetMultipleSelectedSymbolsById(executionModelName, populationInfoName, symbolIdArray, symbolInfoName);
			this.GetFormObject().submit();
		};
		
		//
		// Sets the selected index of all select objects in a specific force tool section. Does NOT submit the form.
		// param - executionModelName - Name of execution model for force tool section (string)
		// param - populationInfoName - Name of population info for force tool section (string)
		// param - symbolIdArray - Array of strings holding target symbol Ids to be selected. Array size must match number of
		//         entries in population info.  If a symbol matches string 'XX', the respective select object will not be altered.
		//         If a symbol contains one or more '|' characters, the symbol will be split and the first matching symbol will be used.   
		// param - symbolInfoName (optional) - Name of symbol info for translating symbol IDs. Will find first match if none is supplied.
		// returns - nothing
		//
		// Example Usage: ForceUtils.SetMultipleSelectedSymbolsById('BaseGame', 'Reeler3x3x3x3x3', ['XX','b01','b01','b01','XX'])
		//                ForceUtils.SetMultipleSelectedSymbolsById('BaseGame', 'Reeler3x3x3x3x3', ['XX','b01','b01|b02','b01','XX'])
		//                ForceUtils.SetMultipleSelectedSymbolsById('BaseGame', 'Reeler3x3x3x3x3', ['XX','b01','b01','b01','XX'], 'BaseGame.Symbols')
		//
		this.SetMultipleSelectedSymbolsById = function(executionModelName, populationInfoName, symbolIdArray, symbolInfoName) {
			var entryNames = this.populationInfoData[populationInfoName];
			if(entryNames.length == symbolIdArray.length) {
				for(var entryIndex = 0; entryIndex < entryNames.length; ++entryIndex) {
					var selectId = executionModelName + '.' + entryNames[entryIndex];
					var select = document.getElementById(selectId);
					if(select != null) {
						this.SetSelectedSymbolById(select, symbolIdArray[entryIndex], symbolInfoName);
					} else {
						alert("Error: could not find select object with ID " + selectId);
					}
				}
			} else {
				alert("Error: entry name count (" + entryNames.length + ") not equal to symbol count (" +
					symbolIdArray.length + ") for symbols: " + symbolIdArray);
			}
		};
		
		//
		// Sets the selected index of a specific select object using a symbol ID.
		// param - selectObj - select object of which to set the selected index
		// param - symbolId - Id of symbol to select. First occurrence of symbol Id will be selected.
		//         If the symbol id matches string 'XX', the select object will not be altered.
		//         If the symbol contains one or more '|' characters, the symbol will be split and the first matching symbol will be used.
		// param - symbolInfoName (optional) - Name of symbol info for translating symbol IDs. Will find first match if none is supplied.
		// returns - nothing
		//
		// Example Usage: ForceUtils.SetSelectedSymbolById(selectObj, 's01')
		//
		this.SetSelectedSymbolById = function(selectObj, symbolId, symbolInfoName) {
			if(symbolId != 'XX') {
				var splitSymbols = symbolId.split('|');
				var translatedSymbolNames = [];
				var symbolCount = splitSymbols.length;
				for(var i = 0; i < symbolCount; ++i)
				{
					translatedSymbolNames.push(this.TranslateSymbolIdToName(splitSymbols[i], symbolInfoName));
				}
				for(var index = 0; index < selectObj.options.length; ++index) {
					var selectOptionText = selectObj.options[index].text;
					// Select option text will either be symbol name (if symbol has mapping in SymbolInfo) or symbol ID
					if(translatedSymbolNames.indexOf(selectOptionText) >= 0) {
						selectObj.selectedIndex = index;
						return;
					}
				}
			}
		};
				
		//
		// Sets the selected index of all select objects in a specific force tool section. Does NOT submit the form.
		// param - executionModelName - Name of execution model for force tool section (string)
		// param - populationInfoName - Name of population info for force tool section (string)
		// param - indexArray - Array of integers holding target indices to be selected. Array size must match number of
		//         entries in population info.
		// returns - nothing
		//
		// Example Usage: SetMultipleSelectedSymbolsByStripIndex('BaseGame', 'Reeler3x3x3x3x3', indexArray)
		//
		this.SetMultipleSelectedSymbolsByStripIndex = function(executionModelName, populationInfoName, indexArray) {
			var entryNames = this.populationInfoData[populationInfoName];
			if(entryNames.length == indexArray.length) {
				for(var entryIndex = 0; entryIndex < entryNames.length; ++entryIndex) {
					var selectId = executionModelName + '.' + entryNames[entryIndex];
					var select = document.getElementById(selectId);
					if(select != null) {
						select.selectedIndex = indexArray[entryIndex];
					} else {
						alert("Error: could not find select with ID " + selectId);
					}
				}
			} else {
				alert("Error: entry name count not equal to index count for indices: " + indexArray);
			}
		};
		
		//
		// Sets the selected index of all select objects in a specific force tool section and submits the form.
		// param - executionModelName - Name of execution model for force tool section (string)
		// param - populationInfoName - Name of population info for force tool section (string)
		//  param - indexArray - Array of integers holding target indices to be selected. Array size must match number of
		//         entries in population info.
		// returns - nothing
		//
		// Example Usage: ForceUtils.SetMultipleSelectedSymbolsByStripIndexAndSubmit('BaseGame', 'Reeler3x3x3x3x3', indexArray)
		//
		
		this.SetMultipleSelectedSymbolsByStripIndexAndSubmit = function(executionModelName, populationInfoName, symbolIdArray, symbolInfoName) {
			this.SetMultipleSelectedSymbolsByStripIndex(executionModelName, populationInfoName, symbolIdArray, symbolInfoName);
			this.GetFormObject().submit();
		};
		
		
		
		//
		// Returns form object used in force tool. Requires that the form object have the ID 'Force.Form'.
		// Displays an alert if the form does not have the required ID.
		//
		this.GetFormObject = function() {
			var forceForm = document.forms["Force.Form"];
			if(forceForm == null) {
				alert("Error: could not find form with ID 'Force.Form'. Check to make sure that the HTML in ForceHtml.xsl defines a form with this ID.");
			}
			return forceForm;
		}
		
		//
		// Hides a section of the force tool so it is not visible when displayed in a browser.
		// Useful when random numbers are grabbed for a game, but the user does not need to have the power to force these numbers.
		// param - executionModelName - Name of executionModel for force tool section (string)
		// param - populationInfo - Name of population info used for force tool section (string)
		// returns - nothing
		//
		// Example usage: ForceUtils.HideForceToolSection('BaseGame', 'Reeler8x8x8x8x8')
		//
		this.HideForceToolSection = function(executionModelName, populationInfoName) {
			var elementId = "Section." + executionModelName + "." + populationInfoName;
			document.getElementById(elementId).style.display = 'none';
		}
		
		//
		// Shows a section of the force tool so it is visible when displayed in a browser.
		// Useful to show a section that is hidden.
		// param - executionModelName - Name of executionModel for force tool section (string)
		// param - populationInfoName - Name of population info used for force tool section (string)
		// returns - nothing
		//
		// Example usage: ForceUtils.ShowForceToolSection('BaseGame', 'Reeler8x8x8x8x8')
		//
		this.ShowForceToolSection = function(executionModelName, populationInfoName) {
			var elementId = "Section." + executionModelName + "." + populationInfoName;
			document.getElementById(elementId).style.display = 'block';
		}
		
		//
		// Attempts to translate symbol id to a symbol name using symbol info stored in paytable.
		// If a specific symbol info name is supplied, only mappings from this symbol info will be used. Otherwise,
		// symbol mappings will be used from all symbol infos in paytable (first match will be returned).
		// param - symbolId - Symbol ID to be translated
		// param - symbolInfoName (optional) - Name of SymbolInfo to use for translation
		// returns - Translated symbol name if translation is found, symbolId otherwise.
		//
		// Example Usage: ForceUtils.TranslateSymbolIdToName('s01', 'FreeSpin.Symbols');
		//                ForceUtils.TranslateSymbolIdToName('s01');
		//
		this.TranslateSymbolIdToName = function(symbolId, symbolInfoName)
		{
			var translation = symbolId;
			if(symbolInfoName == undefined) {
				for(var symbolInfoName in this.symbolInfoData) {
					if(this.symbolInfoData[symbolInfoName][symbolId] !== undefined) {
						translation = this.symbolInfoData[symbolInfoName][symbolId];
						break;
					}
				}
			} else {
				if(this.symbolInfoData[symbolInfoName][symbolId] !== undefined) {
					translation = this.symbolInfoData[symbolInfoName][symbolId];
				}
			}
			return translation;
		}
		
		//
		// Returns an array of select objects for the specified execution model and population info.
		// param - executionModelName - Name of executionModel for force tool section (string)
		// param - populationInfo - Name of population info used for force tool section (string)
		//
		this.GetSelectObjectsInForceToolSection = function(executionModelName, populationInfoName) {
			var selectObjs = new Array();
			var entryNames = this.populationInfoData[populationInfoName];
			for(var entryIndex = 0; entryIndex < entryNames.length; ++entryIndex) {
				var selectId = executionModelName + '.' + entryNames[entryIndex];
				var select = document.getElementById(selectId);
				selectObjs[entryIndex] = select;
			}
			return selectObjs;
		};
		
		//
		// Sets a random selected index for each select object in the force tool section.
		// param - executionModelName - Name of executionModel for force tool section (string)
		// param - populationInfo - Name of population info used for force tool section (string)
		//
		this.SelectRandomIndicesInForceToolSection = function(executionModelName, populationInfoName) {
			var selects = this.GetSelectObjectsInForceToolSection(executionModelName, populationInfoName);
			for(var selectIndex = 0; selectIndex < selects.length; ++selectIndex)
			{
				var select = selects[selectIndex];
				var optionCount = select.options.length;
				var randomIndex = Math.floor((Math.random()*optionCount));
				select.selectedIndex = randomIndex;
			}
		};
		
		//
		// Sets a random selected index, within a range with exclusion, for each select object in the 
		// force tool section. The generated random values will exclude any number contained in the 
		// exclusion list. When a random value is set as an index it is also added to the exclusion 
		// list to eliminate the possibility of a duplicate value.  
		// param - executionModelName - Name of executionModel for force tool section (string)
		// param - populationInfo - Name of population info used for force tool section (string)
		// param - excludeList - A list of numbers to exclude when generating the random value 
		this.SelectRandomIndicesWithExclusion = function(executionModelName, populationInfoName, excludeList) {
			var selects = ForceUtils.GetSelectObjectsInForceToolSection(executionModelName, populationInfoName);		
			for(var selectIndex = 0; selectIndex < selects.length; ++selectIndex)
			{					
				var select = selects[selectIndex];
				var optionCount = select.options.length;
				var randomIndex = Math.floor((Math.random()*optionCount));				
				while (excludeList.indexOf(randomIndex) > -1) {
					randomIndex = Math.floor((Math.random()*optionCount));
				}
				select.selectedIndex = randomIndex;	
				excludeList.push(randomIndex);										
			}
		};
		
		//
		// Provides a workaround since IE 8 does not implement the ECMAScript function for Array.prototype.indexOf().
		Array.prototype.indexOf = function(obj, start) {
     		for (var i = (start || 0), j = this.length; i < j; i++) {
         		if (this[i] === obj) { return i; }
     		}
     		return -1;
		}
		
		
		//
		// ForceTool UI enhancement code
		//
		
		//
		// Toggles the class "collapse" on the HTML element surround each force section
		// 
		this.ToggleClass = function(_id, className, isStored) {	
			var forceSection = document.getElementById(_id);
			forceSection.classList.toggle(className);
			//if true, store the state in sessionStorage
			if(isStored == true){
				sessionStorage.setItem(_id, forceSection.classList.contains(className) ? className : '');
			}
		}
		
		//
		// This is a helper function for section highlighting
		// This will clear all highlights currently in the forcetool. This is used when a new highlight needs to be shown and previous highlights need to be cleared.
		// Can be used on its own as well.
		//
		this.ClearHighlights = function(){
			var els = document.getElementsByClassName("highlight");
			var spanList = document.getElementsByTagName("SPAN");	
			while(els.length){
				els[0].classList.remove("highlight");
				spanList[0].parentNode.removeChild(spanList[0]);
			}
		}
		
		//
		// Function that adds highlights to force sections. THis allows a visual indicator for what users need to change in order to force an outcome.
		// params - a list of table id's for each section that needs a highlight [<id 1>, <id 2>, <etc>]
		// When this function it is called it will remove all current highlights from the html before creating new ones. 
		//
		this.HighlightSections = function(sectionsArray){
			ForceUtils.ClearHighlights();
			
			for(var i = 0; i < sectionsArray.length; i++){
				var span = document.createElement("SPAN");
				var val = document.createTextNode("" + (i + 1));
				span.appendChild(val);                                              
				document.getElementById(sectionsArray[i]).prepend(span); 
				document.getElementById(sectionsArray[i]).classList.add("highlight");
			}
		}
		
		// TOOLTIPS 
		// Requirements: 
		// ToolTipText {} Obj - text for the titles of the select menus
		// CSS - deals with style and positioning for modal
		
		//
		// Toggle function that is added to the HTML via eventListener
		// If a ToolTipText exists for the table id that corresponds to a force section, this will automatically be applied to that section on page load.
		// param - id of force section (done automatically by passing "this.id")
		//
		this.ToggleTooltip = function(that)
		{
			var tooltipTextIndex = that.parentNode.parentNode.parentNode.parentNode.id;
			document.getElementById('tooltip').style.display = 'block';
			document.getElementById('tooltip_text').innerHTML = toolTipText[tooltipTextIndex];
			document.getElementById('tooltip_header').innerHTML = tooltipTextIndex;
		}
		
		//
		// 	On page refresh this function applies the saved data 
		//	This only applies to the open/closed state on a stage section
		//
		this.ApplySessionStorageData = function(){
			for(var i = 0, len = sessionStorage.length; i < len; i++){
				var ele = document.getElementById(sessionStorage.key(i));
				if(sessionStorage.getItem(sessionStorage.key(i)) == ""){
					//ele.classList.add(sessionStorage.getItem(sessionStorage.key(i)));
					ForceUtils.ToggleClass(ele.id, 'collapse', true);
				}
			}
		}
		
		//
		// Applies localStorage data on page load
		// Only applies to custom force buttons in the help-section
		//
		this.ApplylocalStorageData = function(){
			for(var i = 0, len = localStorage.length; i < len; i++){
				if(localStorage.key(i).indexOf('force') >=0 && localStorage.getItem(i) != ""){
					ForceUtils.CreateForceButton(localStorage.key(i).split("force-")[1]);
				}
			}
		}
		
		//
		// put into ForceUtils when finished
		// creates an HTML button the user can use whenever
		//
		this.CreateCustomForceButton = function(){
			console.log('creating custom force');
			var exampleName = "ex: bonus force";
			var newForceName = prompt('Input a name for your new custom force button', exampleName)
			if(newForceName != null && newForceName != "" && newForceName != exampleName){
				//Save the name and url
				//console.log('saving force button');
				var forceString = window.location.href.split('?')[1];
				//console.log(forceString)
				if(forceString == "" || forceString == "undefined" || forceString == null){
					alert('No previous force was available. Please force a desired outcome before creating a button.');
				}else{
					window.localStorage.setItem("force-" + newForceName, "?" + window.location.href.split('?')[1]);
					ForceUtils.CreateForceButton(newForceName);
				}
			}else{
				//User cancelled button creation or did not create new name
				console.log('cancelling force button creation');
			}
		}
		
		//
		// function to remove custom force buttons
		//
		this.RemoveCustomForceButton = function(ele){
			var state = ele.innerHTML;
			console.log(state);
			if(state == 'Remove'){
				ele.innerHTML = 'Done';
				ele.style.backgroundColor = 'lightcoral';
			}else{
				ele.innerHTML = 'Remove';
				ele.style.backgroundColor = 'buttonface';
			}
		}
		
		//
		// when the user clicks the custom button it will submit the href url from localstorage info
		//
		this.HandleCustomForceClick = function(forceButtonName){
			var isRemovable = document.getElementById('removeCustomForce').innerHTML == "Done";
			if(isRemovable){
				var ele = document.getElementById(forceButtonName);
				ele.parentNode.removeChild(ele);
				localStorage.removeItem('force-' + forceButtonName);
			}else{
				window.location.href = window.localStorage.getItem('force-' + forceButtonName);
			}
		}
		
		//
		// Creates a button(s) for custom force buttons
		//
		this.CreateForceButton = function(forceButtonName){
			var newButton = document.createElement("button");
			var attr = document.createAttribute("type");
			attr.value = "button";
			newButton.setAttributeNode(attr);
			attr = document.createAttribute("id");
			attr.value = forceButtonName;
			newButton.setAttributeNode(attr);
			newButton.innerHTML = forceButtonName;
			newButton.addEventListener('click', function(){ForceUtils.HandleCustomForceClick(forceButtonName)});
			//var br = document.createElement("br");
			//document.querySelector('#help-section').appendChild(br);
			document.querySelector('#help-section').appendChild(newButton);	
		}
		
		
		//
		// EventListeners and other features
		// This function needs to be called on page load (window.onload()) to enable all the UI features 
		//
		this.InitUIFeatures = function(){
			
			//
			// Adds eventlisteners to Section button to collapse each force section
			//
			var collapseButtons = document.getElementsByClassName('navbar-toggle');
			if(collapseButtons !== 'undefined' || collapseButtons !== null){
				for(let i = 0; i < collapseButtons.length; i++)
				{
					collapseButtons[i].addEventListener('click', function(){ForceUtils.ToggleClass((this.id.split('-')[0] + '-section'), 'collapse', true)}, false);
				}
			}else{
				console.log("Cannot find navbar-toggle class in HTML. Make sure you have the correct HTML surrounding each stage.");
			}	

			//
			// inits the tool tip modal to be hidden if it is added to the force tool html.
			//
			var modal = document.getElementById('tooltip');
			if(modal !== 'undefined' || modal !== null){
				modal.addEventListener('click', function(){modal.style.display = 'none'});
			}else{
				console.log("Cannot find modal template. make sure you are using '<xsl:call-template name='ToolTipModal' />' in your html.");
			}
			
			//
			// Function that applies an event handler to each force table title, if a toolTipText exists for it
			// param - ToolTipText, while not directly passed as a parameter, it is needed if a tooltip should exist for a force selection
			//
			if(toolTipText != null){
				var tableElements = document.getElementsByTagName('table');
				
				for(var i = 0; i < tableElements.length; i++){
					//console.log(tableElements[i].id);
					if(toolTipText[tableElements[i].id] != null){
						var title = tableElements[i].querySelector('strong');
						var infoDiv = document.createElement('DIV');
						infoDiv.className = 'info';
						infoDiv.innerHTML = '\u2148';
						title.append(infoDiv);
						title.addEventListener('click', function(){ ForceUtils.ToggleTooltip(this);}, false);
					}
				}
			}
			
			//init Local and Session Storage Data
			//
			ForceUtils.ApplySessionStorageData();
			ForceUtils.ApplylocalStorageData();	
		}
		
		]]>
		
		<!-- End anonymous javascript function used for namespace purposes -->
		<xsl:text>};</xsl:text>
		
		<!-- START Test Code  -->
		<![CDATA[			
			
		]]>
		<!-- END Test Code  -->
		
	</xsl:template>
	
	<!-- CSS for forceUtils -->
	
	<xsl:template name="ForceUtils.CSS">
		<style>
			html.no-js{ 
				visibility: hidden;
			}
			html, body{
				margin: 0;
				padding: 0px;
				border: 0px;
				width: 100%;
				min-width: fit-content;
				font-family: Arial;
			}
			body{
				box-sizing: content-box;
				color: #333;
			}
			
			input[type="submit"]{
				    border: none;
					color: #fff;
					font-size: 20px;
				    width: 98%;
				    line-height: 50px;
				    box-shadow: 0px 1px 2px;
				    border-radius: 4px;
				    margin: 0 10px;
				    -webkit-appearance: none;
			}
			input[type="submit"]{
				background-color: #03a9f4;
			}
			input[type="submit"]:active{
				background-color: ##57f53b;
			}
			strong{
				cursor: pointer;
			}
			table span{
				display: inline-block;
				background-color: #c000ff;
				color: #fff;
				font-weight:bold;
				padding: 4px;
				border-radius: 4px;
			}
			
			.navbar-toggle{
				line-height: 40px;
				padding: 0 10px;
				font-size: 20px;
				margin: 0px 10px 10px;
				border: none;
				background-color: #ededed;
				color: #111;
				text-align:left;
				cursor: pointer;
			}
			.collapse{
				/* display:none; */
				visibility: hidden;
				height: 0px;
				margin: -10px 0;
			}
			.collapse p{
				margin: 0;
				padding: 0;
			}
			.content-section{
				margin-bottom: 10px;
				padding: 0 20px;
			}
			.highlight{
				background-color: #cefff8;
			}
			.info{
				display: inline-block;
				background-color: #ddd;
				padding: 0 7px;
				border-radius: 10px;
			}
			.modal_wrapper{
				position: relative;
				z-index: 1;
				display: none;
			}
			.modal{
				position: fixed;
				padding-top: 200px;
				width: 100%;
				height: 100%;
				top: 0;
				left: 0;
			}
			.modal_content{
				background-color: fefefe;
				margin: 0 auto;
				padding: 10px 20px;
				border: 1px solid #ccc;
				width: 80%;
				border-radius: 10px;
			}
			
			#fade{
				background-color: #111;
				height: 100%;
				width: 100%;
				opacity: .2;
				position: fixed;
				top: 0;
				left: 0;
			}
			#customForceControl{
				background-color: #dedede;
				display: inline-block;
				width: fit-content;
				padding: 4px
			}
			@media only screen and (max-device-width: 700px) and (orientation : portrait){
				select{
					font-size: 16px;
				}
			}
		</style>
	</xsl:template>
	
	<!-- END CSS for ForceUtils -->
	
	<!-- ToolTipModal - optional use -->
	<xsl:template name="ForceUtils.ToolTipModal">
		<div id="tooltip" class="modal_wrapper">
			<div id="fade"></div>
			<div class="modal"> 
				<div class="modal_content">
					<h4 id="tooltip_header"></h4>
					<p id="tooltip_text"></p>
				</div>
			</div>
		</div>
	</xsl:template>
	
	<!-- ************************************************************************************************************************** -->
	<!-- Force Tool Select Object (Drop-Down) Creation Templates (meant to be "public" and directly called by force tool xsl files) -->
	<!-- ************************************************************************************************************************** -->
	
	<!--
	// Creates Select objects for each Entry mapping defined in the PopulationStripMapping.
	// All html objects created in this template will be wrapped in a table with id "Section.<execution model name>.<population info name>"
	// (this is useful if you want to be able to hide a force tool section using Javascript).
	// All select object IDs have the following naming scheme: "<execution model name>.<entry name>".
	-->
	<xsl:template name="ForceUtils.CreateForceToolSection.PopulatorWithStripMapping">
		<xsl:param name="executionModelName"/>
		<xsl:param name="stageComponentName"/>
        <!-- Optional parameter to use a given strip info name if multiple strip infos are mapped -->
        <xsl:param name="optionalStripInfoName" select="''"/>
		<!-- Optional parameter. Use if same symbol ID is translated to different names in different stages. -->
		<xsl:param name="symbolInfoName" select="''"/>
		<!-- Optional parameter to use a prefixed group name for the ID -->
        <xsl:param name="optionalGroupID" select="''"/>
		<xsl:variable name="stageComponentDataName"
			select="/Paytable/PaytableData/PaytableVariation/Variation/ExecutionModelMapping/ExecutionModel[@name=$executionModelName]/Data[@type=$stageComponentName]/@name"/>
		<xsl:variable name="stripInfoName">
            <xsl:choose>
                <xsl:when test="$optionalStripInfoName = ''">
                    <xsl:value-of select="/Paytable/PaytableData/ComponentsDataMapping/ComponentData[@name=$stageComponentDataName]/Data[@type='StripInfo']/@name"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$optionalStripInfoName" />
                </xsl:otherwise>			
            </xsl:choose>
        </xsl:variable>
		<xsl:variable name="stripMappingName"
			select="/Paytable/PaytableData/ComponentsDataMapping/ComponentData[@name=$stageComponentDataName]/Data[@type='PopulationStripMapping']/@name"/>
		<xsl:variable name="populationInfoName"
			select="/Paytable/PaytableData/ComponentsDataMapping/ComponentData[@name=$stageComponentDataName]/Data[@type='PopulationInfo']/@name"/>
		<xsl:variable name="groupID">
			<xsl:choose>
                <xsl:when test="$optionalGroupID = ''">
                    <xsl:value-of select="''"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($optionalGroupID,'.')" />
                </xsl:otherwise>			
            </xsl:choose>
		</xsl:variable>
		<table id="Section.{$executionModelName}.{$populationInfoName}">
			<tr>
				<td>
					<strong>
						<xsl:value-of select="concat($executionModelName, ' - ', $populationInfoName)"/>
					</strong>
				</td>
			</tr>
			<xsl:apply-templates select="/Paytable/PaytableData/PopulationStripMapping[@name=$stripMappingName]" mode="ForceUtils.StripMapping">
				<xsl:with-param name="stripInfoName" select="$stripInfoName"/>
				<xsl:with-param name="stripMappingName" select="$stripMappingName"/>
				<xsl:with-param name="executionModelName" select="$executionModelName"/>
				<xsl:with-param name="symbolInfoName" select="$symbolInfoName"/>
				<xsl:with-param name="groupID" select="$groupID"/>
			</xsl:apply-templates>
		</table>
	</xsl:template>
	
	<xsl:template name="ForceUtils.CreateForceToolSection.PopulatorWithStripInfo">
		<xsl:param name="executionModelName"/>
		<xsl:param name="stageComponentName"/>
		<xsl:param name="stripInfoName"/>
		<!-- Optional parameter. Use if same symbol ID is translated to different names in different stages. -->
		<xsl:param name="symbolInfoName" select="''"/>
		<!-- Optional parameter to use a prefixed group name for the ID -->
        <xsl:param name="optionalGroupID" select="''"/>
		<xsl:variable name="stageComponentDataName"
			select="/Paytable/PaytableData/PaytableVariation/Variation/ExecutionModelMapping/ExecutionModel[@name=$executionModelName]/Data[@type=$stageComponentName]/@name"/>
		<xsl:variable name="stripMappingName"
			select="/Paytable/PaytableData/ComponentsDataMapping/ComponentData[@name=$stageComponentDataName]/Data[@type='PopulationStripMapping']/@name"/>
		<xsl:variable name="populationInfoName"
			select="/Paytable/PaytableData/ComponentsDataMapping/ComponentData[@name=$stageComponentDataName]/Data[@type='PopulationInfo']/@name"/>
		<xsl:variable name="groupID">
			<xsl:choose>
                <xsl:when test="optionalGroupID = ''">
                    <xsl:value-of select="''"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($optionalGroupID,'.')" />
                </xsl:otherwise>			
            </xsl:choose>
		</xsl:variable>	
		<table id="Section.{$executionModelName}.{$populationInfoName}">
			<tr>
				<td>
					<strong>
						<xsl:value-of select="concat($executionModelName, ' - ', $populationInfoName)"/>
					</strong>
				</td>
			</tr>
			<xsl:apply-templates select="/Paytable/PaytableData/PopulationStripMapping[@name=$stripMappingName]" mode="ForceUtils.StripMapping">
				<xsl:with-param name="stripInfoName" select="$stripInfoName"/>
				<xsl:with-param name="stripMappingName" select="$stripMappingName"/>
				<xsl:with-param name="executionModelName" select="$executionModelName"/>
				<xsl:with-param name="symbolInfoName" select="$symbolInfoName"/>
				<xsl:with-param name="groupID" select="$groupID"/>
			</xsl:apply-templates>
		</table>
	</xsl:template>
	
	<!-- *************************************************************************************** -->
	<!-- Javascript Templates (meant to be "public" and directly called by force tool xsl files) -->
	<!-- *************************************************************************************** -->
	
	<!--
	// Creates a nested associative array containing StripInfo data for a specific StripInfo.
	// The associative array has an entry for each Strip (key is Strip name).
	// Each Strip entry value is an associative array with two keys:
	// - 'symbolNames' - maps to an array of symbol names
	// - 'forceValues' - maps to an array of integers corresponding to the force values for each symbol
	//
	// param - symbolInfoName (optional) - Name of symbol info for translating symbol IDs. Will find first match if none is supplied.
	//
	// Example: {'Reel0':{'symbolNames':['Goddess','Horse','Man'],'forceValues':[2,5,8]},'Reel1':{...}}
	-->
	<xsl:template match="StripInfo" mode="ForceUtils.JS.StripInfo">
		<xsl:param name="symbolInfoName"/>
		<xsl:text>{</xsl:text>
		<xsl:apply-templates select="Strip" mode="ForceUtils.JS.StripInfoStrip">
			<xsl:with-param name="symbolInfoName" select="$symbolInfoName"/>
		</xsl:apply-templates>
		<xsl:text>}</xsl:text>
	</xsl:template>

	<xsl:template match="LongStripInfo" mode="ForceUtils.JS.LongStripInfo">
		<xsl:param name="symbolInfoName"/>
		<xsl:text>{</xsl:text>
		<xsl:apply-templates select="Strip" mode="ForceUtils.JS.StripInfoStrip">
			<xsl:with-param name="symbolInfoName" select="$symbolInfoName"/>
		</xsl:apply-templates>
		<xsl:text>}</xsl:text>
	</xsl:template>
	
	<!-- **************************************************************** -->
	<!-- Javascript Helper Templates (meant to be "private" to this file) -->
	<!-- **************************************************************** -->

	<xsl:template match="PopulationInfo" mode="ForceUtils.JS.PopulationInfo">
		<xsl:text>'</xsl:text>
		<xsl:value-of select="@name"/>
		<xsl:text>':[</xsl:text>
		<xsl:apply-templates select="Entry" mode="ForceUtils.JS.PopulationInfo.Entry"/>
		<xsl:text>]</xsl:text>
		<xsl:if test="position() != last()">
			<xsl:text>,</xsl:text>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="Entry" mode="ForceUtils.JS.PopulationInfo.Entry">
		<xsl:text>'</xsl:text>
		<xsl:value-of select="@name"/>
		<xsl:text>'</xsl:text>
		<xsl:if test="position() != last()">
			<xsl:text>,</xsl:text>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="SymbolInfo" mode="ForceUtils.JS.SymbolInfo">
		<xsl:text>'</xsl:text>
		<xsl:value-of select="@name"/>
		<xsl:text>':{</xsl:text>
		<xsl:apply-templates select="Symbol" mode="ForceUtils.JS.MapSymbolIdToName"/>
		<xsl:text>}</xsl:text>
		<xsl:if test="position() != last()">
			<xsl:text>,</xsl:text>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="Symbol" mode="ForceUtils.JS.MapSymbolIdToName">
		<xsl:text>'</xsl:text>
		<xsl:value-of select="@id"/>
		<xsl:text>':'</xsl:text>
		<xsl:value-of select="@name"/>
		<xsl:text>'</xsl:text>
		<xsl:if test="position() != last()">
			<xsl:text>,</xsl:text>
		</xsl:if>
	</xsl:template>
	
	<!-- Create an entry in an associative array. Maps strip name to strip data. -->
	<xsl:template mode="ForceUtils.JS.StripInfoStrip" match="Strip">
		<xsl:param name="symbolInfoName"/>
		<xsl:text>'</xsl:text>
		<xsl:value-of select="@name"/>
		<xsl:text>':</xsl:text>
		<xsl:apply-templates select="." mode="ForceUtils.JS.Strip">
			<xsl:with-param name="symbolInfoName" select="$symbolInfoName"/>
		</xsl:apply-templates>
		<xsl:if test="position() != last()">
			<xsl:text>,</xsl:text>
		</xsl:if>
	</xsl:template>
	
	<!-- Create an associative array containing all strip information. -->
	<!-- Example: {'symbolNames':['s01','s01','s02'], 'forceValues':[2,5,8]} -->
	<xsl:template mode="ForceUtils.JS.Strip" match="Strip">
		<xsl:param name="symbolInfoName"/>
		<xsl:text>{'symbolNames':</xsl:text>
		<xsl:call-template name="ForceUtils.JS.StripStopNameArray">
			<xsl:with-param name="symbolInfoName" select="$symbolInfoName"/>
		</xsl:call-template>
		<xsl:text>,'forceValues':</xsl:text>
		<xsl:call-template name="ForceUtils.JS.StripStopWeightArray" />
		<xsl:text>}</xsl:text>
	</xsl:template>
	
	<xsl:template name="ForceUtils.JS.StripStopNameArray">
		<xsl:param name="symbolInfoName"/>
		<xsl:text>[</xsl:text>
		<xsl:call-template name="ForceUtils.JS.StripNameValues">
			<xsl:with-param name="index" select="1"/>
			<xsl:with-param name="stripLength" select="count(Stop)"/>
			<xsl:with-param name="symbolInfoName" select="$symbolInfoName"/>
		</xsl:call-template>
		<xsl:text>]</xsl:text>
	</xsl:template>
	
	<xsl:template name="ForceUtils.JS.StripStopWeightArray">
		<xsl:text>[</xsl:text>
		<xsl:call-template name="ForceUtils.JS.StripWeightValues">
			<xsl:with-param name="index" select="1"/>
			<xsl:with-param name="weightedIndex" select="0"/>
			<xsl:with-param name="stripLength" select="count(Stop)"/>
		</xsl:call-template>
		<xsl:text>]</xsl:text>
	</xsl:template>
	
	<xsl:template name="ForceUtils.JS.StripNameValues">
		<xsl:param name="index"/>
		<xsl:param name="stripLength"/>
		<xsl:param name="symbolInfoName"/>
		<xsl:variable name="stop" select="Stop[$index]"/>
		<xsl:variable name="symbolID" select="$stop/@symbolID"/>
		<xsl:text>'</xsl:text>
		<xsl:call-template name="ForceUtils.TranslateSymbolId">
			<xsl:with-param name="symbolID" select="$symbolID"/>
			<xsl:with-param name="symbolInfoName" select="$symbolInfoName"/>
		</xsl:call-template>	
		<xsl:text>'</xsl:text>
		<xsl:if test="$index &lt; $stripLength">
			<xsl:text>,</xsl:text>
			<xsl:call-template name="ForceUtils.JS.StripNameValues">
				<xsl:with-param name="index" select="$index + 1"/>
				<xsl:with-param name="stripLength" select="$stripLength"/>
				<xsl:with-param name="symbolInfoName" select="$symbolInfoName"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="ForceUtils.JS.StripWeightValues">
		<xsl:param name="index"/>
		<xsl:param name="weightedIndex"/>
		<xsl:param name="stripLength"/>
		<xsl:variable name="stop" select="Stop[$index]"/>
		<xsl:variable name="weight" select="$stop/@weight"/>
		<xsl:variable name="tempWeightedIndex" select="$weight + $weightedIndex"/>
		<xsl:value-of select="$tempWeightedIndex - 1"/>
		<xsl:if test="$index &lt; $stripLength">
			<xsl:text>,</xsl:text>
			<xsl:call-template name="ForceUtils.JS.StripWeightValues">
				<xsl:with-param name="index" select="$index + 1"/>
				<xsl:with-param name="weightedIndex" select="$tempWeightedIndex"/>
				<xsl:with-param name="stripLength" select="$stripLength"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!-- **************************************************************** -->
	<!-- Force Tool Template Helpers (meant to be "private" to this file) -->
	<!-- **************************************************************** -->
	
	<xsl:template match="PopulationStripMapping" mode="ForceUtils.StripMapping">
		<xsl:param name="stripInfoName"/>
		<xsl:param name="stripMappingName"/>
		<xsl:param name="executionModelName"/>
		<xsl:param name="symbolInfoName"/>
		<xsl:param name="groupID"/>
		<tr>
			<td>
				<table border="0" cellpadding="4" cellspacing="0">
					<tr>
<!-- 						<td> -->
							<xsl:apply-templates select="Map" mode="ForceUtils.Map">
								<xsl:with-param name="stripInfoName" select="$stripInfoName"/>
								<xsl:with-param name="stripMappingName" select="$stripMappingName"/>
								<xsl:with-param name="executionModelName" select="$executionModelName"/>
								<xsl:with-param name="symbolInfoName" select="$symbolInfoName"/>
								<xsl:with-param name="groupID" select="$groupID"/>
							</xsl:apply-templates>
<!-- 						</td> -->
					</tr>
				</table>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="Map" mode="ForceUtils.Map">
		<xsl:param name="stripInfoName"/>
		<xsl:param name="stripMappingName"/>
		<xsl:param name="executionModelName"/>
		<xsl:param name="symbolInfoName"/>
		<xsl:param name="groupID"/>
		<xsl:variable name="nameStrip" select="@strip"/>
		<td>
			<select name="{$groupID}{$executionModelName}.{@entry}" title="{$groupID}{$executionModelName}.{@entry}" id="{$groupID}{$executionModelName}.{@entry}">
				<xsl:variable name="strip" select="/Paytable/PaytableData/StripInfo[@name=$stripInfoName]/Strip[@name=$nameStrip]"/>
				<xsl:call-template name="ForceUtils.WeightedSymbols">
					<xsl:with-param name="index" select="1"/>
					<xsl:with-param name="weightedIndex" select="0"/>
					<xsl:with-param name="strip" select="$strip"/>
					<xsl:with-param name="stripLength" select="count($strip/Stop)"/>
					<xsl:with-param name="symbolInfoName" select="$symbolInfoName"/>
				</xsl:call-template>
			</select>
		</td>
	</xsl:template>
	
	<xsl:template name="ForceUtils.WeightedSymbols">
		<xsl:param name="index"/>
		<xsl:param name="weightedIndex"/>
		<xsl:param name="strip"/>
		<xsl:param name="stripLength"/>
		<xsl:param name="symbolInfoName"/>
		<xsl:variable name="stop" select="$strip/Stop[$index]"/>
		<xsl:variable name="symbolID" select="$stop/@symbolID"/>
		<xsl:variable name="weight" select="$stop/@weight"/>
		<xsl:variable name="tempWeightedIndex" select="$weight + $weightedIndex"/>
		<xsl:if test="$weight &gt; 0">
			<xsl:element name="option">
				<xsl:attribute name="value">
					<xsl:value-of select="$tempWeightedIndex - 1"/>
				</xsl:attribute>
				<xsl:call-template name="ForceUtils.TranslateSymbolId">
					<xsl:with-param name="symbolID" select="$symbolID"/>
					<xsl:with-param name="symbolInfoName" select="$symbolInfoName"/>
				</xsl:call-template>		
			</xsl:element>
		</xsl:if>
		<xsl:if test="$index &lt;= $stripLength">
			<xsl:call-template name="ForceUtils.WeightedSymbols">
				<xsl:with-param name="index" select="$index + 1"/>
				<xsl:with-param name="weightedIndex" select="$tempWeightedIndex"/>
				<xsl:with-param name="strip" select="$strip"/>
				<xsl:with-param name="stripLength" select="$stripLength"/>
				<xsl:with-param name="symbolInfoName" select="$symbolInfoName"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="ForceUtils.TranslateSymbolId">
		<xsl:param name="symbolID"/>
		<xsl:param name="symbolInfoName"/>
		<xsl:variable name="nameValue">
			<xsl:choose>
				<xsl:when test="string-length($symbolInfoName) = 0">
					<xsl:value-of select="//SymbolInfo/Symbol[@id=$symbolID]/@name"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="//SymbolInfo[@name=$symbolInfoName]/Symbol[@id=$symbolID]/@name"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="string-length($nameValue) = 0">
				<xsl:value-of select="$symbolID"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$nameValue"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>