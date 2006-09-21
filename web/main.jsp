<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://www.pgist.org/pgtaglib" prefix="pg" %>
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<html:html>
<head>
<title>PGIST main page</title>
<!-- Site Wide CSS -->
<style type="text/css" media="screen">@import "styles/position.css";</style>
<style type="text/css" media="screen">@import "styles/styles.css";</style>
<!-- End Site Wide CSS -->
<!-- Site Wide JS -->
<script src="scripts/prototype.js" type="text/javascript"></script>
<script src="scripts/scriptaculous.js?load=effects,dragdrop" type="text/javascript"></script>
<script src="scripts/search.js" type="text/javascript"></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
</head>

<body>
<!-- Header -->
<jsp:include page="/header.jsp" />
<!-- End Header -->

<h3>Public View</h3>
<ul>
<li><pg:show roles="participant, moderator"><html:link page="/cctlist.do">Concerns Collector Tool</html:link></pg:show> 
* 
</li>
<li><html:link page="/glossaryPublic.do">Glossary Public View</html:link> 
* 
</li>
<li><pg:show roles="participant, moderator">
  <html:link page="/sdlist.do">Structured Discussion List * </html:link>
</pg:show></li>
</ul>

<pg:show roles="moderator">
<h3>Moderator Tools</h3>
<ul>
<pg:show users="admin"><li><a href="/userlist.do">User Management</a></li></pg:show>
<li><html:link page="/tagging.do">Tags/StopWords Management Tool</html:link></li>
<li><html:link page="/cstlist.do">Concerns Synthesis Tool</html:link>*</li>
<li><html:link page="/glossaryManage.do">Glossary Management Tool</html:link></li>
<li><html:link page="/feedback.do">Reviewing Feedbacks</html:link></li>
</ul>

<h3>Developement Tools</h3>
<ul>
<li><html:link page="/test.jsp">Test</html:link></li>
<li><html:link page="/concernManagement.do">Concern Management</html:link></li>
<li><html:link page="/search.do">Search</html:link></li>
<li><html:link page="/situationList.do">Situation List</html:link></li>
</ul>
</pg:show>
</div>

<p>Found a bug?  Problem accessing a part on the page?  <a href="javascript:Effect.toggle('feedbackForm','blind');">Send us feedback.</a></p>
<div id="feedbackForm" style="display: none;">
	<h3>Feedback/Bug Report Form</h3>
	<p>If you came across a bug, please help us by reporting it to our development team.  blah blah blah blah.....please describe in as much detail as possible....blah blah</p>
	<pg:feedback id="feedbackDiv" action="login.do" />
</div>

</body>
</html:html>

