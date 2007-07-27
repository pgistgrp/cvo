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
	Page: Full Report
	Description: This is a full report of the entire challenge.
	Author(s): 
	     Front End: Jordan Isip, Adam Hindman
	     Back End: John Q Le, Zhong Wang
#### -->

<html:html>
<head>
<title>Report Summary Form</title>
<style type="text/css" media="screen">
        @import "styles/lit.css";
				@import "styles/step4b-voteresults.css";
				@import "styles/step5-report.css";
</style>
<script src="scripts/prototype.js" type="text/javascript"></script>
<script src="scripts/scriptaculous.js?load=effects,dragdrop" type="text/javascript"></script>
</head>
<body>
	

	<!--
		Themes for summaries: ***${summaries}***<br />
		Criteria References: ***${cr}***<br>
		Project References: ***${pr}***
	-->

<div id="container">


	<p>report summary form page  </p>
	<html:form action="/reportsummary.do?suite_id=${suite_id}" method="POST">
	<html:hidden property="save" value="true"/>

	<p>System Msg: ${reportForm.reason}</p>
	<p>Executive Summary<html:textarea property="executiveSummary" value="${rSummary.executiveSummary}"/></p>
	<p>Participants Summary<html:textarea property="part1a" value="${rSummary.part1a}"/></p>
	<p>Concern Summary<html:textarea property="part1b" value="${rSummary.part1b}"/></p>
	<p>Criteria Summary<html:textarea property="part2a" value="${rSummary.part2a}"/></p>
	<p>Project Summary<html:textarea property="part3a" value="${rSummary.part3a}"/></p>
	<p>Package Summary<html:textarea property="part4a" value="${rSummary.part4a}"/></p>
	
	<p>Finalize Report? Yes <html:radio property="finalized" value="true" />  No <html:radio property="finalized" value="false" /></p>
	
	<p>Final Vote Date: 
	  <html:textarea property="finalVoteDate" value="${rSummary.finalVoteDate}"/></p>
	  
	  <p>Final Report Date: 
	  <html:textarea property="finalReportDate" value="${rSummary.finalReportDate}"/></p>
	  
	<html:submit value="submit" />
	</html:form>
</div>
	<!-- End Appendix C -->
</body>
</html:html>