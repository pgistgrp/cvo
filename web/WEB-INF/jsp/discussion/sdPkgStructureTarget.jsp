<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.pgist.org/pgtaglib" prefix="pg" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!--####
	Project: Let's Improve Transportation!
	Page: Object for Structured Discussion for Packages
	Description: This page will list and map out all of the clustered packages in the given decision situation.
	Author(s): 
	     Front End: Jordan Isip, Adam Hindman
	     Back End: Zhong Wang
	Todo Items:
		[x] Initial Skeleton Code (Jordan)
		[x] Integrate Structured Discussion (Jordan)
		[ ] Integrate Layout (Adam) 
		[ ] Test with backend contractor code (Jordan)
#### -->

<pg:fragment type="html">
<!-- begin "overview and instructions" area -->

<div id="overview" class="box2">
	<h3 class="headerColor">Instructions</h3>
	<p>Participants created ${participant_packages} in Step 3. In order to narrow down the field of packages under cosideration we automatically
		created ${fn:length(clusteredPackages)} new packages that collectively represnt the diversity of packages created by participants in Step 3
		(<a href="#">read more about how we did this</a>).  Now you can review and discuss the five new candidtate packages and determine which one we ish to 
		collectively endorse as our recommendation.</p>
		
	<p>At a later point in this step, the moderator will ask participants to determine which packages have the greatest level of collective support.  
		this vote information will help us decidewhich package to collectively recommend and <b>will occur on <!-- insert workflow date --></b>.</p>
</div>
<!-- end overview -->
<!-- begin Object -->
		<div id="object">
			
			<div class="box4 padding5">
				<div class="floatLeft" id="packageHeader"><h3 class="headerColor">All Packages</h3></div>
			</div>
			<!-- begin obj-left -->
			<div id="obj-left" class="floatLeft clearBoth">
				<!-- begin list of funding options -->
				<div id="allListHeader">
					<div class="listHeaderHeader">
						<h4 class="headerColor">L.I.T. packages automatically generated by clustering
							participants' personal packages.</h4><br/>
							<small>The package associated with your own personal package is 
							<span class="highlight">highlighted</span></small>	
						</p>
						<div class="clearBoth"></div>
					</div>
					
					
					<div class="listRow row headingColor">
						<div class="col1 floatLeft">
							<div class="floatLeft">&nbsp;</div>
						</div>
						<div class="col2 floatLeft">Total</div>
						<div class="col3 floatLeft">Cost for you</div> 
						<div class="col4 floatLeft">Cost for avg. resident</div>
						<div class="clearBoth"></div>
					</div>
					
					<c:forEach var="package" items="${infoStructure.infoObjects}" varStatus="loop">
						<c:if test="${package.manual}">
							<!-- HACK - userpackage is not currently defined - waiting for Mike -->
							<div class="listRow row ${((loop.index % 2) == 0) ? 'even' : 'odd'} ${(userPackage.id == package.id) ? 'highlight' : 'nil'}">
								<div class="col1 floatLeft">
									<div class="floatLeft"><a href="#">Package ${package.id}</a></div>
								</div>
								<div class="col2 floatLeft">$${package.totalCost}</div>
								<div class="col3 floatLeft">$${package.userCost}/year</div> 
								<div class="col4 floatLeft">$${package.avgCost}/year</div>
								<div class="clearBoth"></div>
							</div>
						</c:if>
					</c:forEach>
					
					<c:forEach var="package" items="${infoStructure.infoObjects}" varStatus="loop">
						<c:if test="${package.manual}">
							<div class="listRow row ${((loop.index % 2) == 0) ? 'even' : 'odd'}">
								<p><h4 class="headerColor">${package.description}</h4></p>
								<div class="col1 floatLeft">
									<div class="floatLeft"><a href="#">Package ${package.id}</a></div>
								</div>
								<div class="col2 floatLeft">$${package.totalCost}</div>
								<div class="col3 floatLeft">$${package.userCost}/year</div> 
								<div class="col4 floatLeft">$${package.avgCost}/year</div>
								<div class="clearBoth"></div>
							</div>
						</c:if>
					</c:forEach>
				</div>
				<!-- end list of funding options -->
			</div>
			<!-- end obj-left -->
		<!-- begin cell containing Google Map object -->
		<div id="obj-right" class="floatRight"> <img src="images/gmaps.gif"> </div>
		<!-- end cell containing Google Map object -->
		<!-- begin firefox height hack -->
		<div class="clearBoth"></div>
		<!-- end firefox height hack -->
	</div>
	<!-- end Object-->
	
	<!-- Begin foldable Average Grades Table -->
	
	<div class="floatRight" id="weightingSelector" style="margin-bottom:1em;">
				Display using <select style="margin-left:1.5em;">
						<option> Equal weighting </option>
						<option> My weighting </option>
						<option> Group weighting </option>
					</select>
	</div>
	
		<div id="avgGradesTable" class="clearBoth">
		<table border="0">
  <tr>
    <th scope="col">Package</th>
    <th scope="col">Economic Vitality</th>
    <th scope="col">Security</th>
    <th scope="col">Accessibility and Mobility </th>
    <th scope="col">Environmental / Energy / QOL </th>
    <th scope="col">Integration and Connectivity </th>
    <th scope="col">Efficient System Management </th>
    <th scope="col">System Preservation </th>
    <th scope="col">Safety</th>
    <th scope="col">Local / Regional Objectives </th>
    <th scope="col">Overall Average </th>
  </tr>  <tr class="factorOdd">
    <th scope="row">1</th>
    <td>B</td>
    <td>C</td>
    <td>D</td>
    <td>F</td>
    <td>B</td>
    <td>C</td>
    <td>A</td>
    <td>B</td>
    <td>D</td>
    <td>C</td>
  </tr>
  <tr class="factorEven">
    <th scope="row">2</th>
    <td>B</td>
    <td>C</td>
    <td>D</td>
    <td>F</td>
    <td>B-</td>
    <td>C+</td>
    <td>A</td>
    <td>B</td>
    <td>D</td>
    <td>C</td>
  </tr>  <tr class="factorOdd">
    <th scope="row">3</th>
    <td>B</td>
    <td>C</td>
    <td>D</td>
    <td>F</td>
    <td>B</td>
    <td>C</td>
    <td>A</td>
    <td>A-</td>
    <td>D</td>
    <td>C</td>
  </tr>
  <tr class="factorEven">
    <th scope="row">4</th>
    <td>B</td>
    <td>C</td>
    <td>D</td>
    <td>F</td>
    <td>A</td>
    <td>C</td>
    <td>A</td>
    <td>B</td>
    <td>B</td>
    <td>C</td>
  </tr>  <tr class="factorOdd">
    <th scope="row">5</th>
    <td>B</td>
    <td>C</td>
    <td>D</td>
    <td>F</td>
    <td>B</td>
    <td>C</td>
    <td>A</td>
    <td>F</td>
    <td>D</td>
    <td>C</td>
  </tr>
  <tr class="factorEven">
    <th scope="row">RTID</th>
    <td>B</td>
    <td>C</td>
    <td>D</td>
    <td>F</td>
    <td>B</td>
    <td>C</td>
    <td>A</td>
    <td>C</td>
    <td>D</td>
    <td>C</td>
  </tr>
</table>

		</div>
	<!-- End foldable average grades table -->


</pg:fragment>

<pg:fragment type="script">
	//All Javascript that is internal to this page must go here - not sdRoomMain.
	//Add Javascript to build tree list

	/* *************** load a dynamic javascript or css file ****************/

	io.loadDynamicFile = function(file){
		var start = file.indexOf('.') + 1
		var finish = file.length
		var type = file.substring(start,finish)
		
		var headElem = document.getElementsByTagName('head')[0];
		if(type == "css"){
			var cssLinkElem = document.createElement('link');
			cssLinkElem.setAttribute('href', file);
			cssLinkElem.setAttribute('type', 'text/css');
			cssLinkElem.setAttribute('rel', 'stylesheet');
			headElem.appendChild(cssLinkElem);
		}else{ //javascript
			var jsLinkElem = document.createElement('script');
			jsLinkElem.setAttribute('src', file);
			jsLinkElem.setAttribute('type', 'text/javascript');
			headElem.appendChild(jsLinkElem);
		}
		
	}
	
	/* *************** loading on getTargets() in SDRoomMain *************** */
	io.loadDynamicFile('styles/step4a.css');
	io.loadDynamicFile('/dwr/interface/ProjectAgent.js');
</pg:fragment>