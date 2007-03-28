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
		[ ] Project Alt sorting (Matt)
		[ ] reason:"Error: this objective could not be assigned the specified grade",successful:false} (Matt)
		[x] Tree with Unobtrusive JS

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

		<!--Project Grades Specific  Libraries-->
		<script type='text/javascript' src='/dwr/interface/ProjectAgent.js'></script>
		<script src="scripts/simpletreemenu.js" type="text/javascript"></script>
		<style type="text/css" media="screen">
			@import "styles/simpletree.css";
		</style>
		
		<style type="text/css" media="screen">
			li{margin: 10px 0;}
			.project{font-size: 1.3em;}
		</style>

		<script type="text/javascript" charseut="utf-8">
			function setGrading(altRefId, critId, objId, value){
				alert("altRefId: " + altRefId + " critId: " + critId + " objId: " + objId +" value: " +value ); 
				ProjectAgent.setGrading({altRefId:altRefId,critId:critId,objId:objId,value:value},{
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
		
		<a href="javascript:ddtreemenu.flatten('treemenu1', 'expand')">Expand All</a> | 
		<a href="javascript:ddtreemenu.flatten('treemenu1', 'contact')">Collapse All</a>
		
		<ul id="treemenu1" class="treeview">
			<c:forEach var="projectRef" items="${projSuite.references}" varStatus="loop">
				<li><span class="project"><a href="#">Project: ${projectRef.project.name}</a></span><ul>
					<c:forEach var="altRef" items="${projectRef.altRefs}" varStatus="loop">
						<li><small><a href="projectAlt.do?altrefId=${altRef.id}" target="_blank">Alt ${altRef.alternative.name} info page <img src="/images/external.png" border="0" /></a></small></li>
						<li><a href="#">Alt: ${altRef.alternative.name}</a>
						<ul>
						<c:forEach var="critGrade" items="${altRef.gradedCriteria}" varStatus="loop">
							<li><a href="#">Factor: ${critGrade.criteria.name} (Grade: <b id="critGrade-${critGrade.criteria.id}">${critGrade.grade}</b>):</a>
								<ul>
									<c:forEach var="objective" items="${critGrade.criteria.objectives}" varStatus="loop">
										<li>${objective.description} - Grade: 
											<select id="objGrade-${objective.id}" onchange="setGrading(${altRef.id},${critGrade.criteria.id},${objective.id}, this.value);">
												<option value="3">3</option>
												<option value="2">2</option>
												<option value="1">1</option>
												<option value="NULL" selected="true"></option>
												<option value="-1">-1</option>
												<option value="-2">-2</option>
												<option value="-3">-3</option>
											</select>
										</li>	
									</c:forEach>
								</ul>
							</li>
						</c:forEach>
					</ul></li>
					</c:forEach>
					</ul></li>
			</c:forEach>
		</ul>
		
		<script type="text/javascript">
			//ddtreemenu.createTree(treeid, enablepersist, opt_persist_in_days (default is 1))
			ddtreemenu.createTree("treemenu1", false);
			ddtreemenu.flatten('treemenu1', 'contact');
			//ddtreemenu.flatten('treemenu1', 'expand');
		</script>
	</body>
</html>

