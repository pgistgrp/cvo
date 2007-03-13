<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.pgist.org/pgtaglib" prefix="pg" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">

<!--####
	Project: Let's Improve Transportation!
	Page: Projects Partial
	Description: Partial page to get all projects
	Author(s): 
	     Front End: Jordan Isip, Adam Hindman, Issac Yang
	     Back End: Zhong Wang, John Le
	Todo Items:
		[x] Initial Skeleton Code (Jordan)
		[x] loop through all projects

		
#### -->
<c:if test="${fn:length(projects) == 0}">
	<p>No projects have been created yet.</p>
</c:if>
<c:forEach var="project" items="${projects}">
	<li id="project-${project.id}">${project.name} - ${project.description} (${project.transMode}) (${project.inclusive})
		<small> <a href="javascript:prepareProject(${project.id});">edit</a> | <a href="javascript:deleteProject(${project.id});">delete</a></small>
		<!-- for editing project -->
		<div id="projectForm${project.id}" style="display:none">
			<h4>Editing ${project.name}</h4>
			<form id="frmProject${project.id}">
				<!--form inserted from js -->
			</form>	
		</div>
		<!-- end for editing project -->
		<ul>
			<c:forEach var="alternative" items="${project.alternatives}">
				<li>${alternative.name}  
					<small><a href="javascript: mapAlternative(${alternative.id});">map</a> | <a href="javascript: editAlternative(${alternative.id});">edit</a> | <a href="javascript:deleteProjectAlt(${alternative.id});">delete</a></small>
				</li>
			</c:forEach>
			<li>[ <a href="javascript:Element.toggle('newAlternativeForm${project.id}');">Add an Alternative</a> ]</li>
		</ul>
		<div id="newAlternativeForm${project.id}" style="display: none">
				<h4>New ${project.name} Alternative</h4>
				<form id="frmNewAlternative${project.id}">
					<label>Project Alternative Name:</label>
					<input id="txtAltName" type="text" value="" size="25"><br />
					
					<label>Agency:</label>
					<input id="txtAltAgency" type="text" value="" size="25"><br />
					
					<label>Cost:</label>
					<input id="txtAltCost" type="text" value="" size="25"><br />
					
					<label>County:</label>
					<input id="txtCounty" type="text" value="" size="25"><br />
					
					<label>Short Description:</label>
					<input id="txtAltDesc" type="text" value="" size="25"><br />
					
					<label>Links:</label> <!--this will be converted to a rich text box editor -->
					<input id="txtAltLinks" type="text" value="" size="25">
					<br />
					<label>Statement For:</label>
					<input id="txtAltFor" type="text" value="" size="25">
					<br />
					<label>Statement Against:</label>
					<input id="txtAltAgainst" type="text" value="" size="25">
					<br />
					<p><input type="button" onclick="createProjectAlt(${project.id});" value="Create New Alternative"></p>
				</form>
		</div>
		<div id="editAlternativeForm${project.id}" style="display: none"></div>
	</li>
</c:forEach>

<li>[ <a href="javascript:prepareProject();">Add a Project</a> ]
	<div id="projectForm" style="display: none;">
		<h4>Add a New Project</h4>
		<form id="frmProject">
			<!-- form loaded via js-->
		</form>
	</div>
</li>


