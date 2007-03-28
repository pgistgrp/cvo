<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.pgist.org/pgtaglib" prefix="pg" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!--####
	Project: Let's Improve Transportation!
	Page: Project Grading
	Description: This page is to grade projects on criteria in the given decision situation.
	Author(s): 
	     Front End: Jordan Isip, Adam Hindman, Issac Yang
	     Back End: Zhong Wang, John Le
	Todo Items:
		[x] Initial Skeleton Code (Jordan)
		[x] Javascript (Jordan)
		[ ] So the next thing was that in Task3 you are going to need to be working off of the ProjectAltRef, not the project Alternative
		[ ] You can get the ProjectAlternative out of the ProjectAltRef, but the ProjectAltRef will also have all the grading and whatnot
		So anyway, I need to go back to task 3 and look at how this would work exactally, but when you tell me a grade in the ProjectAgent.setGrading, before you were sending me the AltID, now you will need to send me the AltRefId
		3:17
		I think that means that you will have a list of ProjectRef's, in the ProjectGradingPage
		3:18
		Then you will cycle through those pulling the Projects out for the top level nodes, and then use the project alt refs and their corrisponding project alternatives to form the next level
		3:18
		To be honest, this is not solidified at all in my head
		3:19
		So I'm hoping this makes sense to you on some level

#### -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
	"http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		<meta http-equiv="Content-type" content="text/html; charset=utf-8">
		<title>Manage Projects</title>
		<!-- Site Wide JavaScript -->
		<script src="scripts/tags.js" type="text/javascript"></script>
		<script src="scripts/prototype.js" type="text/javascript"></script>
		<script src="scripts/scriptaculous.js?load=effects,dragdrop" type="text/javascript"></script>
		<script src="scripts/search.js" type="text/javascript"></script>
		<!-- End Site Wide JavaScript -->

		<!-- mapping JavaScript -->
		<script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAADmWGO07Q7ZeAHCvFNooqIxTwM0brOpm-All5BF6PoaKBxRWWERTgXzfGnh96tes2zXXrBXrWwWigIQ"
		      type="text/javascript"></script>
		<script src="scripts/pgistmap2.js"></script>
		<!-- End of mapping JavaScript -->

		<!-- DWR JavaScript Libraries -->
		<script type='text/javascript' src='/dwr/engine.js'></script>
		<script type='text/javascript' src='/dwr/util.js'></script>
		<!-- End DWR JavaScript Libraries -->

		<!--Project Specific  Libraries-->
		<script type='text/javascript' src='/dwr/interface/ProjectAgent.js'></script>
		<style type="text/css" media="screen">
			li{margin: 10px 0; list-style: none;}
			.project{font-size: 1.3em;}
		</style>
		<style type="text/css">
		    v\:* {
		      behavior:url(#default#VML);
		    }
		</style>

		<script type="text/javascript" charseut="utf-8">
			function setGrading(altId, critId, objId, value){
				alert("altId: " + altId + " critId: " + critId + " objId: " + objId +" value: " +value ); 
				ProjectAgent.setGrading({altId:altId,critId:critId,objId:objId,value:value},{
					callback:function(data){
						if (data.successful){
							alert("grade set! Setting Criteria Grade to: " + data.grade)  //testing
							$('critGrade-' + critId).innerHTML = data.grade; //returned grade
							new Effect.Highlight('critGrade-' + critId); //highlight reflecting change
						}else{
							alert(data.reason);
						}
					},
					errorHandler:function(errorString, exception){ 
					alert("ProjectAgent.setGrading( error:" + errorString + exception);
					}
				});
			}
			

		</script>
	</head>
	<body>
		<h1>Grade Projects on Criteria Objectives ${critSuite}</h1>
		<ul>
		<c:forEach var="projectRef" items="${projSuite.references}" varStatus="loop">
			<li><span class="project">${projectRef.project.name}</span><ul>
				<c:forEach var="altRef" items="${projectRef.altRefs}" varStatus="loop">
					<li><a href="javascript:window.open('projectAlt.do?altrefId=${altRef.id}','width=730,height=500,resizable=yes,scrollbars=yes'); void(0);">${altRef.alternative.name} <img src="images/external.png" alt="(new window)" border="0" /></a><ul>
					<c:forEach var="critGrade" items="${altRef.gradedCriteria}" varStatus="loop">
						<li>Name: ${critGrade.criteria.name}</li>
						<li>Description: ${critGrade.criteria.na}</li>
						<li>Grade: <b id="critGrade-${critGrade.criteria.id}">${critGrade.grade}</b></li>
						<li>Objectives (${fn:length(critGrade.criteria.objectives)}):</li>
						<ul>
							<c:forEach var="objective" items="${critGrade.criteria.objectives}" varStatus="loop">
								<li>${objective.description} - Grade: 
									<select id="objGrade-${objective.id}" onchange="setGrading(${altRef.id},${critGrade.criteria.id},${objective.id}, this.value);">
										<option>3</option>
										<option>2</option>
										<option>1</option>
										<option selected="true"></option>
										<option>-1</option>
										<option>-2</option>
										<option>-3</option>
									</select>
								</li>	
							</c:forEach>
						</ul>
					</c:forEach>
				</ul></li>
				</c:forEach>
				</ul></li>
		</c:forEach>
		</ul>
	</body>
</html>

