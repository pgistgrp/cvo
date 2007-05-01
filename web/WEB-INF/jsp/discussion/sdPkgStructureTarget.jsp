<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.pgist.org/pgtaglib" prefix="pg" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>



<pg:fragment type="html">
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
			[x] Integrate Adam's Layout (Jordan) 
			[ ] Test with backend contractor code (Jordan)
			[ ] Highlight User's related package (Jordan)
			[ ] Dynamic info in overview and instructions (Jordan)
	#### -->

		<!-- begin "overview and instructions" area -->
		<div id="overview" class="box2">
			<h3>Overview and Instructions</h3>
			<p>Participants created <strong>283</strong> unique packages in Step 3 In order
				to narrow down the field of packages under consideration we automatically created
				five new packages that collectively represent the diversity of packages created
				in Step 3 (<a href="#">read more about how we did this</a>). Now you can review
				and discuss the five new candidate packages and determine which one we wish to
				collectively endore as our recommendation.</p>
			<p>Periodically during this step, the moderator will poll participants to determine
				which packages have the greatest level of collective support. This poll information
				will help us to decide which package to collectively recommend. <strong>A final
				vote will occur on Thursday, Oct. 19</strong>.</p>
			<p>While the goal of this step is to find as high a level of consensus as possible,
				participants who strongly disagree with the winning package will have an opportunity
				to vote for a minority endorsement.</p>
		</div>
		<!-- end overview -->
		<!-- begin Object -->
		<div id="object">
		<h3 class="headerColor">All Packages</h3>
			<!-- begin obj-left -->
			<div id="obj-left" class="floatLeft clearBoth">
				<!-- begin list of funding options -->
				<div id="allListHeader">
					<div class="listHeaderHeader">
						<h4 class="headerColor">L.I.T. packages automatically generated by clustering
							participants' personal packages.</h4>
						<br/>
						<small>The package associated with your own personal package is <span class="highlight">highlighted</span></small>
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
					
					<c:forEach var="package" items="${structure.infoObjects}" varStatus="loop">
						<c:if test="${package.manual == false}">
							<div class="listRow row"> <!-- use 'highlight' css class to highlight user's related package -->
								<div class="col1 floatLeft">
									<div class="floatLeft"><a href="package.do?id=${package.id}">Package ${loop.index}</a></div>
								</div>
								<div class="col2 floatLeft">$${package.totalCost} billion</div>
								<div class="col3 floatLeft">$${package.userCost}/year</div>
								<div class="col4 floatLeft">$${package.avgCost}/year</div>
								<div class="clearBoth"></div>
							</div>
						</c:if>
					</c:forEach>

					<p>
						
					<c:forEach var="package" items="${structure.infoObjects}" varStatus="loop">
						<c:if test="${package.manual}">
							<div class="listRow row">
								<div class="col1 floatLeft">
									<div class="floatLeft"><a href="#">${package.package.description}</a></div>
								</div>
								<div class="col2 floatLeft">$${package.totalCost} billion</div>
								<div class="col3 floatLeft">$${package.userCost}/year</div>
								<div class="col4 floatLeft">$${package.avgCost}/year</div>
								<div class="clearBoth"></div>
							</div>
						</c:if>
					</c:forEach>
					
					</p>

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
		<div style="border:1px solid #000;width:100%;">Pie charts!</div>
	</div>
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
	io.loadDynamicFile('/styles/step4-start.css');
	io.loadDynamicFile('/dwr/interface/ProjectAgent.js');
</pg:fragment>
