<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.pgist.org/pgtaglib" prefix="pg" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<html:html>
<pg:show roles="moderator">
<head>
<title>Let's Improve Transportation - User Management</title>
<!-- Site Wide CSS -->
<style type="text/css" media="screen">@import "styles/lit.css";</style>

<!-- End Site Wide CSS -->
<style type="text/css">
.center {
	text-align:center;
}
.rowcolor {
	background-color: #BBDDFF;
} 
.rowfont {
	font-size: .8em;
	vertical-align:text-top;
}
</style>
<!-- Site Wide JS -->
<script src="scripts/prototype.js" type="text/javascript"></script>
<script src="scripts/scriptaculous.js?load=effects,dragdrop" type="text/javascript"></script>
<script src="scripts/search.js" type="text/javascript"></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<script type='text/javascript' src='/dwr/interface/SystemAgent.js'></script>

<script type="text/javascript" charset="utf-8">
window.onLoad = doOnLoad();
		
function doOnLoad(){
	getAllUsers();
	getQuotaStats();
}

function getAllUsers() {
	SystemAgent.getAllUsers({}, {
		callback:function(data){
			if (data.successful){
				$('userList').innerHTML = data.html;
				
			}else{
				$('userList').innerHTML = "<b>Error in SystemAgent.getAllUsers Method: </b>" + data.reason; 
			}
		},
		errorHandler:function(errorString, exception){ 
		alert("SystemAgent.getAllUsers( error:" + errorString + exception);
		}
	});
}

function getQuotaStats() {
	SystemAgent.createQuotaStats({}, {
		callback:function(data){
			if (data.successful){
				$('quota').innerHTML = data.html;
				
			}else{
				$('quota').innerHTML = "<b>Error in SystemAgent.createQuotaStats Method: </b>" + data.reason; 
			}
		},
		errorHandler:function(errorString, exception){ 
		alert("SystemAgent.createQuotaStats( error:" + errorString + exception);
		}
	});
}

function getAllCounties() {
		SystemAgent.getAllCounties({}, {
		callback:function(data){
			if (data.successful){
				$('allcounties').innerHTML = data.html;
				
			}else{
				$('allcounties').innerHTML = "<b>Error in SystemAgent.getAllCounties Method: </b>" + data.reason; 
			}
		},
		errorHandler:function(errorString, exception){ 
		alert("SystemAgent.getAllCounties( error:" + errorString + exception);
		}
	});
}

function disableUsers(myid) {
	SystemAgent.disableUsers({ids:myid});
}

function enableUsers(myId) {
	SystemAgent.enableUsers({ids:myId});
}

function getEmailList(mychoice) {
	var enable = "";
	var disable = "";
	if(mychoice=="enabled") {
		enable="true";
		disable ="false";
	} else if (mychoice == "disabled") {
		disable ="true";
		enable="false";
	}
	
	SystemAgent.getEmailList({enabled:enable, disabled:disable}, {
		callback:function(data){
			if (data.successful){
				$('EmailList').value = data.emaillist;
			}else{
				$('allUsersList').innerHTML = "<b>Error in SystemAgent.getEmailList Method: </b>" + data.reason; 
			}
		},
		errorHandler:function(errorString, exception){ 
		alert("SystemAgent.getEmailList( error:" + errorString + exception);
		}
	});
}
function quota(myid, mybool) {
	SystemAgent.setQuota({id:myid, quota:mybool});
}

function hide(divid){
	if(document.getElementById(divid).style.display!="none") {
		document.getElementById(divid).style.display="none";
	} else {
		document.getElementById(divid).style.display="block";
	}
}

function saveQuotaLimit(count) {
	var limitfieldname = "limitvalue" + count;
	var idfieldname = "countyid" + count;
	var limit = document.getElementById(limitfieldname).value;
	var id = document.getElementById(idfieldname).value;
	SystemAgent.setQuotaLimit({countyId:id, limit:limit});
	setTimeout("getQuotaStats()",100);
}

function addCounty() {
	var countyname = document.getElementById('countyname').value;
	SystemAgent.addCounty({name:countyname});
	setTimeout("getQuotaStats()",100);
}

function resetPassword(myid) {
	SystemAgent.resetPassword({ids:myid});
}

function deleteCounty(countyid) {
	SystemAgent.deleteCounty({countyid:countyid});
	setTimeout("getQuotaStats()",100);
}

function deleteZip(countyid, zipcode) {
	SystemAgent.deleteZipCodes({countyid:countyid, zips:zipcode});
	setTimeout("getQuotaStats()",100);
}

function addZipCodes(countyid, count) {
	var idfieldname = "zipcodesinput" + count;

	var zipcode = $F(idfieldname).toString()
	SystemAgent.addZipCodes({countyid:countyid, zips:zipcode});
	setTimeout("getQuotaStats()",100);
}
</script>


</head>

<body>
 <!-- Begin the header - loaded from a separate file -->
  <div id="header">
	<!-- Begin header -->
	<jsp:include page="/header.jsp" />
	<!-- End header -->
  </div>
  <!-- End header -->
  <!-- Begin header menu - The wide ribbon underneath the logo -->
  <div id="headerMenu">
	
  </div>
  <!-- End header menu -->
  <!-- #container is the container that wraps around all the main page content -->
  <div id="container">
  <h2>Moderator Tools</h2>
	<p>&nbsp;</p>
	
	
	<h3>System Management</h3>
  	<div id="quota">
	
	</div>
	<p>&nbsp;</p>
	
	<h3>User Management</h3>
	<p><a href="javascript:getEmailList();hide('emailList');">Export All E-mail Addresses (plain text)</a></p>
  	<div id="emailList">
	<form name="emaillist">
	  <p>Email List: (Ctrl + A to select All, Ctrl + C to copy to clipboard) <br/>
	    <textarea id="EmailList" cols="75" rows="8"></textarea><br/>
		
		Filter Email List:
		<label>
		<input name="userfilter" type="radio" value="all" checked="checked" onChange="getEmailList('');">
			All Users</label>
		<label>
		<input type="radio" name="userfilter" value="enabled" onChange="getEmailList('enabled');">
			Enabled Only</label>
		<label>
		<input type="radio" name="userfilter" value="enabled" onChange="getEmailList('disabled');">
			Disabled Only</label>
		<br>
      </p>
    </form>
	<p>&nbsp;</p>
	</div>
	<div id="userList">
	
	</div>
	
	<p>&nbsp;</p>
	
	
	
	
  </div>
  <!-- end container -->
  
<!-- start feedback form -->
  <pg:feedback id="feedbackDiv" action="cctView.do"/>
<!-- end feedback form -->

  <!-- Begin header menu - The wide ribbon underneath the logo -->
  <div id="headerMenu">

  </div>

	<!-- Begin footer -->
	<div id="footer">
		<jsp:include page="/footer.jsp" />
	</div>
	<!-- End footer -->
	<script type="text/javascript">
		hide('emailList');
	</script>
</body>
</pg:show>
</html:html>

