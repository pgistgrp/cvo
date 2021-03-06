<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.pgist.org/pgtaglib" prefix="pg" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">

<!--####
	Project: Let's Improve Transportation!
	Page: Package Manager
	Description: View all auto generated packages and access to CRUD Events on All Manual Packages.
	Author(s): 
	     Front End: Jordan Isip, Adam Hindman
	     Back End: Matt Paulin, Zhong Wang
	Todo Items:
		[x] Initial Skeleton Code (Jordan)
		[ ] BareBones JavaScript/JSTL (Jordan)
		[ ] CRUD on manual packages (Jordan)
		[ ] Test and Refine (Jordan)
#### -->
<html:html>
<head>
<title>LIT - Moderator Package Manager</title>
<!-- Site Wide JS -->
<script src="scripts/prototype.js" type="text/javascript"></script>
<script src="scripts/scriptaculous.js?load=effects,dragdrop" type="text/javascript"></script>
<script src="scripts/search.js" type="text/javascript"></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<script src="scripts/prototype.js" type="text/javascript"></script>
<script src="scripts/scriptaculous.js?load=effects,dragdrop" type="text/javascript"></script>

<script type='text/javascript' src='/dwr/interface/PackageAgent.js'></script>
<script type="text/javascript">

myPackages = [];
var pkgSuiteId = "${pkgSuiteId}";
var projSuiteId = "${projSuiteId}";
var fundSuiteId = "${fundSuiteId}";
var critSuiteId = "${critSuiteId}";

function addMyPackage(){
	var myPackage = $F('packageDesc');
	myNewPackages = myPackages.push(myPackage);
	listMyPackages(myPackages);
}

function listMyPackages(myPackages){
	var manualPackagesList = $('manualPackages')
	manualPackagesList.innerHTML = '';
	for (var i = 0; i < myPackages.length; i++){
		manualPackagesList.innerHTML += '<br>' + 
		'<p class="floatLeft clearfix"> <span class="floatLeft" style="width:75%"> <a href="#">' + myPackages[i] + '</a></span> <span class="floatRight">[ <a href="#">Edit</a> ] [ <a href="#">Delete</a> ]</span> </p>';
	}
}

function createClusteredPackages(){
	$('newtable').innerHTML = '<img src="/images/indicator_arrows.gif" /> Clustering Packages';
	var pkgCount = $F('pkgCount');
	//alert("pkgSuiteId: " + pkgSuiteId + " pkgCount: " + pkgCount + "projSuiteId: " + projSuiteId + " fundSuiteID: "+ fundSuiteId);
	PackageAgent.createClusteredPackages({pkgSuiteId:pkgSuiteId, pkgCount:pkgCount, projSuiteId: projSuiteId, fundSuiteId:fundSuiteId}, {
		callback:function(data){
			if (data.successful){
				getClusteredPackages();
			}else{
				alert(data.reason);
			}
		},
		errorHandler:function(errorString, exception){ 
		alert("PackageAgent.createClusteredPackages( error:" + errorString + exception);
		}
	});
}

function createClusteredPackage(){
	var description = $F('packageDesc');
	//alert("description: " + description)
	if(description.length > 0){
		PackageAgent.createClusteredPackage({suiteId:pkgSuiteId,description:description}, {
			callback:function(data){
				if (data.successful){
					location.href="editClusteredPackage.do?pkgSuiteId="+pkgSuiteId+"&projSuiteId="+projSuiteId+"&fundSuiteId="+fundSuiteId+"&critSuiteId="+critSuiteId+"&pkgId="+data.pkgId;
				}else{
					alert(data.reason);
				}
			},
			errorHandler:function(errorString, exception){ 
			alert("PackageAgent.createClusteredPackage( error:" + errorString + exception);
			}
		});
	}else{
		alert("Please enter a description for your manual package.")
	}
}


function getClusteredPackages(){
	//alert("ProjSuiteId: " + projSuiteId + " fundSuiteId: " + fundSuiteId + " critSuiteId: " + critSuiteId + " pkgSuiteId: " + pkgSuiteId)
	PackageAgent.getAutocreatedClusteredPackages({pkgSuiteId:pkgSuiteId, projSuiteId:projSuiteId,fundSuiteId:fundSuiteId,critSuiteId:critSuiteId}, {
		callback:function(data){
			if (data.successful){
				$('newtable').innerHTML= data.html;
			}else{
				alert(data.reason);
			}
		},
		errorHandler:function(errorString, exception){ 
		alert("PackageAgent.getAutocreatedClusteredPackages( error:" + errorString + exception);
		}
	});
}

function getManualPackages(){
	PackageAgent.getManualPackages({pkgSuiteId:pkgSuiteId,projSuiteId:projSuiteId,fundSuiteId:fundSuiteId,critSuiteId:critSuiteId}, {
		callback:function(data){
			if (data.successful){
				$('manualPackages').innerHTML= data.html;
			}else{
				alert(data.reason);
			}
		},
		errorHandler:function(errorString, exception){ 
		alert("PackageAgent.getManualPackages( error:" + errorString + exception);
		}
	});
}

function deleteClusteredPackage(pkgId){
	//alert("suiteId: " + pkgSuiteId + " pkgId: " + pkgId); 
	PackageAgent.deleteClusteredPackage({suiteId:pkgSuiteId,pkgId:pkgId}, {
		callback:function(data){
			if (data.successful){
				alert("Package successfully deleted!")
				getManualPackages();
			}else{
				alert(data.reason);
			}
		},
		errorHandler:function(errorString, exception){ 
		alert("PackageAgent.deleteClusteredPackage( error:" + errorString + exception);
		}
	});
}

function publishPackages(){
	PackageAgent.publishPackages({pkgSuiteId:pkgSuiteId}, {
		callback:function(data){
			if (data.successful){
				alert("Package successfully published! VoteSuiteId = " + data.voteSuiteId);
				location.href = "packageVote.do?voteSuiteId=" + data.voteSuiteId + "&pkgSuiteId="+pkgSuiteId+"&projSuiteId="+projSuiteId+"&fundSuiteId="+fundSuiteId+"&critSuiteId="+critSuiteId;
			}else{
				alert(data.reason);
			}
		},
		errorHandler:function(errorString, exception){ 
		alert("PackageAgent.publishPackages( error:" + errorString + exception);
		}
	});
}

</script>
<style type="text/css">
@import "styles/lit.css";
@import "styles/table.css";

#newtable th, #newtable td {padding:5px;text-align:center;}<br>
h3 {text-transform:none;}
p {margin-left:5px;}
tr:hover {background:#E4F1F5;}
td.col1 a {display:block;text-decoration:underline;}
.box12 {padding:5px;}

</style>
<event:pageunload />
</head>
<body>
<!-- #container is the container that wraps around all the main page content -->

<div id="container">
    <p><a href="userhome.do?workflowId=${requestScope['org.pgist.wfengine.WORKFLOW_ID']}">Back to Moderator Control Panel</a></p>
	<!-- begin "overview and instructions" area -->
	<div id="overview" class="box2">
		<h3>Overview and Instructions</h3>
		<p>These are the packages that will be discussed by participants in step 4a.</p>
	</div>
	<!-- end overview -->
	<h2 class="headerColor">Moderator Package Manager</h2>
	<br>
	<span class="floatLeft" style="width:49%;border-right:1px solid #ccc;padding-right:1%;">
	<h3 class="headerColor">Automatically Created Packages </h3>
	<p>Participant packages will be clustered on 11/06/07 (Beginning of Step 4a)</p>
	<p>[On 11/06/07, participant packages were clustered into 6 packages below]</p>
	<div id="newtable">
		<!-- load clustered packages via js-->
	</div>
	<br>
	<h3 class="headerColor">Cluster Packages Automatically</h3>
	<p class="floatLeft">
		<span class="floatLeft padding5"> How many packages do you want? </span> 
		<span class="floatRight">
			<select id="pkgCount">
				<option>3</option>
				<option>4</option>
				<option>5</option>
				<option>6</option>
				<option>7</option>
			</select>
			<input type="button" class="padding5" onClick="createClusteredPackages();" value="Cluster Packages">
		</span> </p>
	</span> <span class="floatRight" style="width:49%">
	<h3 class="headerColor">Manually Created Packages</h3>
	<div id="manualPackages"> 
		<!-- load manual packages via js -->
	</div>
	<h3 class="clearBoth headerColor"><br />
		Add Package Manually <small>(enter package description)</small></h3>
	<div id="newPackage" style="width:100%" class="clearfix">
		<form action="javascript:createClusteredPackage();">
		<input type="text" name="packagedescription" 
			style="width:100%;" id="packageDesc">
		<p class="floatRight">
			<input type="submit" value="Add Package" class="padding5">
		</p>
		</form>
	</div>
	</span>
	<!--
	<h3 class="headerColor clearBoth"><br />
		Finished?</h3>
	<p>When you are ready to allow participants to begin discussing these packages,
		click the button below to create the discussion rooms</p>
	<input type="button" value="Publish Packages" onClick="publishPackages();" class="padding5">-->
		<h3>Finished managing packages?</h3>
	<!-- this button just redirects - saves are occuring on check. -->
	<p align="right"><input type="button" style="padding:5px;" onClick="location.href='userhome.do?workflowId=${requestScope['org.pgist.wfengine.WORKFLOW_ID']}'" value="Finished!"/></p>
</div>
<script type="text/javascript" charset="utf-8">
	getManualPackages()
	getClusteredPackages();
</script>
<!-- end container -->
<!-- End footer -->
</body>
</html:html>
