<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.pgist.org/pgtaglib" prefix="pg" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">

<!--####
	Source: Let's Improve Transportation!
	Page: Funding Source Manager Partial
	Description: Partial page to get all funding sources
	Author(s): 
	     Front End: Jordan Isip, Adam Hindman, Isaac Yang
	     Back End: Zhong Wang, John Le
	Todo Items:
		[x] Initial Skeleton Code (Jordan)
		[ ] loop through all funding sources (jordan)

		
#### -->
	<h1>FUNDING = ${fundings}</h1>
	<c:if test="${fn:length(fundings) == 0}">
		<p>No funding sources have been created yet.</p>
	</c:if>

	<c:forEach var="source" items="${fundings}" varStatus="loop">
		<li class="sourceList" id="source-${source.id}"><span class="source">${source.name}</span>
			<small> <a href="javascript:prepareSource(${source.id});">edit</a> | <a href="javascript:deleteSource(${source.id});">delete</a></small>
			<!-- for editing source -->
			<div id="sourceForm${source.id}" style="display:none">
				<h4>Editing ${source.name}</h4>
				<form action="javascript:editSource(${source.id});" id="frmSource${source.id}">
					<!--form inserted from js renderSourceForm();-->
				</form>	
			</div>
			<!-- end for editing source -->
			<ul>
				<c:forEach var="alternative" items="${source.alternatives}">
					<li id="alt-${alternative.id}">${alternative.name}  
						<small><a href="javascript: mapAlternative(${alternative.id});">map</a> | <a href="javascript:prepareSourceAlt(${alternative.id}, 'altId');">edit</a> | <a href="javascript:deleteSourceAlt(${alternative.id});">delete</a></small>
						<div id="alternativeForm${alternative.id}" style="display:none;">
							<form action="javascript:editSourceAlt(${alternative.id});" id="frmSourceAlt${alternative.id}">
								<!--form inserted from js renderSourceAltForm();-->
							</form>
						</div>
						<div id="alternativeMap${alternative.id}">
							<!-- map for this alt goes here -->
						</div>
					</li>
				</c:forEach>
		
				<!-- for creating source alt-->
				<li><small>[ <a href="javascript:prepareSourceAlt(${source.id},'projId');">Add an Alternative</a> ]</small>
					<div id="alternativeForm${source.id}" style="display:none;">
						<form action="javascript:createSourceAlt(${source.id});" id="frmSourceAlt${source.id}">
							<!--form inserted from js renderSourceAltForm();-->
						</form>
					</div>
				</li>
				<!-- end for creating source alt -->
		
			</ul>
			<div id="editAlternativeForm${source.id}" style="display: none"></div>
		</li>
	</c:forEach>

<li>[ <a href="javascript:prepareSource();">Add a Source</a> ]
	<div id="sourceForm" style="display: none;">
		<h4>Add a New Source</h4>
		<form id="frmSource" name="frmSource" action="javascript:createSource();">
			<!--load form here-->
		</form>
	</div>
</li>


