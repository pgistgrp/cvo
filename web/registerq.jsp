<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.pgist.org/pgtaglib" prefix="pg" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="wf" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html:html>
	<head>
	<title>Let's Improve Transportation - Registration</title>
	<!-- Site Wide CSS -->
<style type="text/css" media="screen">
@import "styles/lit.css";
@import "styles/registration-questionnaire.css";
</style>
<!-- End Site Wide CSS -->
<!-- Site Wide JS -->
<script src="scripts/prototype.js" type="text/javascript"></script>
<script src="scripts/scriptaculous.js?load=effects,dragdrop" type="text/javascript"></script>
<script src="scripts/search.js" type="text/javascript"></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<script type='text/javascript' src='/dwr/interface/SystemAgent.js'></script>
<script type='text/javascript' src='/dwr/interface/RegisterAgent.js'></script>
<script type='text/javascript' src='/dwr/interface/FundingAgent.js'></script>

<script type='text/javascript'> 

function addVehicle() {
	var mpg = $F('vehicleMpg');
	var value = $F('vehicleValue');
	var mpy = $F('vehicleMpy');
	
	//alert("milesPerGallon: " + mpg + " value: " + value + " milesPerYear: " + mpy); 
	FundingAgent.addVehicle({milesPerGallon:mpg,value:value,milesPerYear:mpy}, {
		callback:function(data){
			if (data.successful){
				getVehicles();
				//Form.reset('addVehicle');
			}else{
				alert(data.reason);
			}
		},
		errorHandler:function(errorString, exception){ 
		//alert("FundingAgent.addVehicle( error:" + errorString + exception);
		}
	});
}

function getVehicles(){
	FundingAgent.getVehicles({}, {
		callback:function(data){
			if (data.successful){
				$('vehicles').innerHTML = data.html;
			}else{
				alert(data.reason);
			}
		},
		errorHandler:function(errorString, exception){ 
			//for (var x in exception){alert(x + exception[x]);}
			//alert('hey');
		alert("FundingAgent.getVehicles( error:" + errorString + exception);
		}
	});
}

function toggleEditField(item, id) {
	Element.toggle(item + "Edit" + id);
	Element.toggle(item + id);
}

function editVehicle(vehicleId){
	var mpg = $F('vehicleMpg' + vehicleId);
	var value = $F('vehicleValue' + vehicleId);
	var mpy = $F('vehicleMpy'+ vehicleId);

	FundingAgent.updateVehicle({vehicleId:vehicleId,milesPerGallon:mpg,value:value,milesPerYear:mpy}, {
		callback:function(data){
			if (data.successful){
				getVehicles();
			}else{
				alert(data.reason);
			}
		},
		errorHandler:function(errorString, exception){ 
		alert("FundingAgent.updateVehicle( error:" + errorString + exception);
		}
	});
}

function deleteVehicle(vehicleId){
	FundingAgent.deleteVehicle({vehicleId:vehicleId}, {
		callback:function(data){
			if (data.successful){
				new Effect.DropOut('vehicle' + vehicleId)
			}else{
				alert(data.reason);
			}
		},
		errorHandler:function(errorString, exception){ 
		alert("FundingAgent.deleteVehicle( error:" + errorString + exception);
		}
	});
}

function submitQ(form) {
	document.questionnaire.submitq.disabled=true;
	var errordiv = document.getElementById("errors");
	var errormsg = "";

	var income = form.income.value;	
	var householdsize = parseInt(form.householdsize.value);
	var drive = form.drive.value;
	var carpool = form.carpool.value;
	var carpoolpeople = form.carpoolpeople.value;
	var bus = form.bus.value;
	var bike = form.bike.value;
	var walk = form.walk.value;
	
	RegisterAgent.addQuestionnaire({income:income, householdsize:householdsize, drive:drive, carpool:carpool, carpoolpeople:carpoolpeople, bus:bus, bike:bike, walk:walk}, {
		callback:function(data){
			if (data.successful){
				window.location = "main.do";
			}else{
				alert(data.reason);
			}
		},
		errorHandler:function(errorString, exception){ 
		alert("RegisterAgent.addQuestionnaire( error:" + errorString + exception);
		}
	});
}

function getTolls() {
	RegisterAgent.getTolls({}, {
		callback:function(data){
			if (data.successful){
				var tolls = new Array();
				tolls = data.tolls;
				var tolloutput = "";
				for(var i = 0; i<tolls.length; i++) {
					if(tolls[i].location != null) {
					tolloutput += "<input name=\"toll" + tolls[i].id + "\" id=\"" + tolls[i].id + "\" type=\"checkbox\" onchange=\"selectToll(" + tolls[i].id + ")\"/>" + tolls[i].location + "<br />";
					}
				}
				document.getElementById('mytolls').innerHTML = tolloutput;
			}else{
				alert(data.reason);
			}
		},
		errorHandler:function(errorString, exception){ 
		alert("RegisterAgent.getTolls( error:" + errorString + exception);
		}
	});
}

function selectToll(tollid) {
	var boolvalue = new Boolean();
	boolvalue = document.getElementById(tollid).checked;
	if(boolvalue) {
		RegisterAgent.setToll({tollid:tollid, boolvalue:"true"});
	} else {
		RegisterAgent.setToll({tollid:tollid, boolvalue:"false"});
	}
}

function filterNum(str) {
	re = /[^0-9|\.]/g;
	// remove everything but numbers
	return str.replace(re, "");
}

</script>
</head>
<body onload="getVehicles();getTolls();">
	<!--[if IE]>
		<style type="text/css">
			fieldset p {padding-bottom:1px;}
		</style>
	<![endif]-->
	
	<div id="header">
  <!-- Start Global Headers  -->
  <wf:nav />
  <!-- End Global Headers -->
	</div>
	<!-- End header -->
	<!-- Begin header menu - The wide ribbon underneath the logo -->
	<div id="headerMenu"> </div>
	<!-- End header menu -->
	
	<!-- #container is the container that wraps around all the main page content -->

	<div id="container">
		<h4 class="headerColor">Please answer a few questions about yourself</h4><p>The answers to these question will help us later on to estimate the cost of transportation improvements to you. All of this information will remain confidential. You may choose to to not answer any of the questions.</p>
		<!-- Begin calculator options -->
		<form name="questionnaire">
		<div id="myIncome">
			What is your approximate annual household income?
			<span id="annualIncome">
			<c:choose>	
				<c:when test="${fn:length(annualIncome) == 0}">
					<p>Error No household income found</p>
				</c:when>
				<c:otherwise>
				<select id="income" style="margin-left:1em;">
				<c:forEach var="income" items="${annualIncome}" varStatus="loop">
					<option value="${income.id}">${income.value}</option>			
				</c:forEach>
				</select>
				</c:otherwise>
			</c:choose>
			
			</span>
			 </div>
		<div id="myHousehold">
			How many people live in your household?
			<span id="household"><select id="householdsize" style="margin-left:1em;">
				<option value="1">1</option>
				<option value="2">2</option>
				<option value="3">3</option>
				<option value="4">4</option>
				<option value="5">5</option>
				<option value="6 or more">6 or more</option>				
			</select>
			</span>
			 </div>
		<div id="myVehicles">
			<p>Tell us about the motor vehicles which are registered to your household.</p>
				<div id="vehicles">
					<img src="/images/indicator_arrows.gif" /> Loading your vehicles...
					<!-- vehicles rendered by separate jsp page -->
				</div>		
			</div>
		<div id="myCommute" class="peekaboobugfix">
			<p>Please provide the following information about your commute to and from work</p>
			<div id="myCommute-center" class="floatLeft"> I <strong>drive alone</strong> to work 
				<select id="drive">
				  <option value="0">0</option>
				  <option value="1">1</option>
				  <option value="2">2</option>
				  <option value="3">3</option>
				  <option value="4">4</option>
				  <option value="5">5</option>
				  <option value="6">6</option>
				  <option value="7">7</option>
			    </select>

				days per week<br/>
				I <strong>carpool</strong> to work 
				<select id="carpool">
				  <option value="0">0</option>
				  <option value="1">1</option>
				  <option value="2">2</option>
				  <option value="3">3</option>
				  <option value="4">4</option>
				  <option value="5">5</option>
				  <option value="6">6</option>
				  <option value="7">7</option>
			    </select>
				days per week with
				<select id="carpoolpeople">
				  <option value="0" selected="selected">0</option>
				  <option value="1">1</option>
				  <option value="2">2</option>
				  <option value="3">3</option>
				  <option value="4">4</option>
				  <option value="5">5</option>
				  <option value="6">6</option>
				  <option value="7">7+</option>
			                                    </select>
				people<br/>

				I <strong>ride the bus</strong> to work 
				<select id="bus">
				  <option value="0">0</option>
				  <option value="1">1</option>
				  <option value="2">2</option>
				  <option value="3">3</option>
				  <option value="4">4</option>
				  <option value="5">5</option>
				  <option value="6">6</option>
				  <option value="7">7</option>
			    </select>
				days per week<br/>
				I <strong>bike</strong> to work 
				<select id="bike">
				  <option value="0">0</option>
				  <option value="1">1</option>
				  <option value="2">2</option>
				  <option value="3">3</option>
				  <option value="4">4</option>
				  <option value="5">5</option>
				  <option value="6">6</option>
				  <option value="7">7</option>
			    </select>
				days per week<br/>
				
			I <strong>walk</strong> to work
				<select id="walk">
				  <option value="0">0</option>
				  <option value="1">1</option>
				  <option value="2">2</option>
				  <option value="3">3</option>
				  <option value="4">4</option>
				  <option value="5">5</option>
				  <option value="6">6</option>
				  <option value="7">7</option>
				</select>
				days per week<br/>
			</div>
			<div id="myCommute-right" class="floatLeft"> My daily commute includes:<br />
				<div id="mytolls">
				Loading
				</div>
			</div>
			<div class="clearBoth"></div>
		</div>
		<!-- End calculator options -->
			<fieldset>
				<legend>Please complete our detailed participant questionnaire</legend>
				<p>Please take some time to complete our questionnaire. This is the first, and longest, of 3 questionnaires you will be asked to complete during the <em>Let's Improve Transportation Challenge</em>. It will take about 30 minutes to complete. To access the questionnaire, you will be asked for your participant ID number, which is displayed below. (FYI: Your participant ID number will also be displayed on your personal LIT homepage when you visit this website in the future.)</p>
				<p>When you click the "Go to questionnaire" button below, the questionnaire will launch in a new window. When you are done filling out he questionnaire, simply close the window and return to this page.</p>
				<p>Your participant ID is: <code>${user.webQ.value}</code></p>
				<c:choose>
				    <c:when test="${user.quota}">
        				<input type="button" value="Go to questionnaire" 
        					onclick="window.open('https://catalysttools.washington.edu/survey/mwarrenw/40839');"/>
				    </c:when>
				    <c:otherwise>
				        <input type="button" value="Go to questionnaire" onclick="window.open('https://catalysttools.washington.edu/survey/mwarrenw/40868');" />
				    </c:otherwise>
				</c:choose>
			</fieldset>
			
		<div id="step-bar" class="box5 padding5 clearfix">
				<p class="floatLeft" id="step-progress">Step 3 of 3</p>
				<p class="floatLeft" id="submit-description" style="width:450px;">When you are finished with the questionnaire Click &quot;complete registration&quot; get started on the Lets Improve Transportation challenge!</p>
				<p class="floatRight" id="submit-button"><input type="button" name="submitq" value="Complete registration" style="font-size:14pt;" onclick="submitQ(this.form)"/></p>
		</div>
		</form>
		</div>
	<!-- end container -->
	<!-- start feedback form -->
	<pg:feedback id="feedbackDiv" action="cctView.do"/>
	<!-- end feedback form -->
	<!-- Begin header menu - The wide ribbon underneath the logo -->
	<div id="headerMenu"> </div>
	<!-- End header menu -->

</body>
</html:html>
