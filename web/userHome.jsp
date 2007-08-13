<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://www.pgist.org/pgtaglib" prefix="pg" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib prefix="wf" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html:html>
<!--####
	Project: Let's Improve Transportation!
	Page: User Home
	Description: This page serves as a single instance of a user home portal.  This will have
					links to all available components along with a user's discussion and tags.
	Author(s): 
	     Front End: Jordan Isip, Adam Hindman
	     Back End: Zhong Wang, John Le
#### -->  
	<head> 
	<title>Let's Improve Transportation - Home</title>
	<!-- Site Wide CSS -->
	<style type="text/css" media="screen">
		@import "styles/lit.css";
		@import "styles/user-home.css";
		@import "styles/workflow.css";
	</style>
	<!-- End Site Wide CSS -->
	<!-- Site Wide JS -->
	<script type="text/javascript" src="scripts/tinymce/jscripts/tiny_mce/tiny_mce.js"></script>
	<script src="scripts/prototype.js" type="text/javascript"></script>
	<script src="scripts/scriptaculous.js?load=effects,dragdrop" type="text/javascript"></script>
	<script src="scripts/search.js" type="text/javascript"></script>
	<script src="scripts/util.js" type="text/javascript"></script>
	<script type='text/javascript' src='/dwr/engine.js'></script>
	<script type='text/javascript' src='/dwr/util.js'></script>
	<script type='text/javascript' src='/dwr/interface/WorkflowAgent.js'></script>
	<script type='text/javascript' src='/scripts/workflow.js'></script>
	<script>
	  var workflow = new Workflow('workflow-panel');
	</script>
	<script type="text/javascript">
		var wfId = "${param.workflowId}";
		
		if(!wfId){location.href="main.do"}
		function getAnnouncements(){
			Util.loading(true, "Loading Announcements");
			SystemAgent.getAnnouncements({workflowId:wfId}, {
				callback:function(data){
					if (data.successful){
						$('announcements').innerHTML = data.html;
					}else{
						alert(data.reason);
					}
					Util.loading(false);
				},
				errorHandler:function(errorString, exception){ 
				alert("SystemAgent.getAnnouncements( error:" + errorString + exception);
				}
			});
		}
		
		function addAnnouncement(){
			var email = $F("email");
			if(email == "" || email == null) {
				email = "false";
			} else {
				email = email.toString();
			}
			Util.loading(true, "Saving Announcement");
			var message = tinyMCE.getContent();
			SystemAgent.addAnnouncement({workflowId:wfId,message:message,email:email}, {
				callback:function(data){
					if (data.successful){
						getAnnouncements();
					}else{
						alert(data.reason);
					}
					Util.loading(false);
				},
				errorHandler:function(errorString, exception){ 
				alert("SystemAgent.getAnnouncements( error:" + errorString + exception);
				}
			});
		}
	
		function deleteAnnouncement(id){
			Util.loading(true, "Deleting Announcement");
			SystemAgent.deleteAnnouncement({id:id}, {
				callback:function(data){
					if (data.successful){
						new Effect.DropOut('announcement' + id)
						alert(data.reason);
					}else{
					}
					Util.loading(false);
				},
				errorHandler:function(errorString, exception){ 
				alert("SystemAgent.deleteAnnouncement( error:" + errorString + exception);
				}
			});
		}
		
		function addAnnouncementPrep(){
			Element.toggle($('announce-editor'));
			showPubBtn();
			// Remove the existing control before adding a new one (kludgey!)
			tinyMCE.execCommand('mceRemoveControl',true,'modAnnounce');
			// Have to add the control before setting content
			tinyMCE.execCommand('mceAddControl',true,'modAnnounce');
			tinyMCE.setContent('');
		}
		
		/* Have to use mceAddControl to instantiate editor onclick or else
		   tinyMCE can't find it */
		function editAnnouncementPrep(id){
			$('announce-editor').style.display="";
			tinyMCE.execCommand('mceRemoveControl',true,'modAnnounce');
			tinyMCE.execCommand('mceAddControl',true,'modAnnounce');
			var old = $('message' + id).innerHTML;
			tinyMCE.setContent(old);
			$('editBtn').name = id;
			showEditBtn();
		}
		
		function editAnnouncement(id){
			Util.loading(true, "Saving Announcement");
			var message="default text";
			var message = tinyMCE.getContent();
			SystemAgent.editAnnouncement({id:id, message:message}, {
				callback:function(data){
					if (data.successful){
						tinyMCE.setContent("");
						getAnnouncements();
					}else{
						alert(data.reason);
					}
					Util.loading(false);
				},
				errorHandler:function(errorString, exception){ 
				alert("SystemAgent.deleteAnnouncement( error:" + errorString + exception);
				}
			});
		}	
		
		function showPubBtn(){
			$('pubBtn').style.display="";
			$('editBtn').style.display="none";
		}
		
		function showEditBtn(){
			$('editBtn').style.display="";
			$('pubBtn').style.display="none";
		}
		
   function initialise() {
   		var editor = tinyMCE.selectedInstance.editorId;
      tinyMCE.execCommand('mceFocus', false, editor);
   }

		tinyMCE.init({
		theme : "advanced",
		theme_advanced_buttons1 : "bold, italic, bullist, numlist,undo, redo,link",
		theme_advanced_buttons2 : "",
		theme_advanced_buttons3 : "",
		content_css : "/scripts/tinymce/jscripts/tiny_mce/themes/simple/css/bigmce.css",
		extended_valid_elements : "blockquote[style='']",
    setupcontent_callback : "initialise",
		//mode : "textareas",
		height: "100",
		width: "430"
		});
	
	//tinyMCE.execCommand('mceFocus',false,'content');
	</script>
	<event:pageunload />
	</head>
	<body onload="workflow.getWorkflow(${param.workflowId});">
        <!-- Start Global Headers  -->
        <wf:nav />
        <wf:subNav />
        <!-- End Global Headers -->
	<!-- End header menu -->
	<!-- #container is the container that wraps around all the main page content -->
	<div id="container">
		<h2 class="headerColor">Welcome, ${baseuser.loginname}</h2>
		<a href="publicprofile.do?user=${baseuser.loginname}">View / Edit your profile</a>
		<div id="left-col">
			<h3 class="headerColor">Overview of all steps</h3>
			<div class="box12 clearfix">
				<div id="workflow-panel"><img src="/images/indicator_arrows.gif" alt="Please wait..."/> Loading overview...</div>
				<pg:show roles="moderator">
					<!--
					<h5>** The following section is for testing purposes only. It will be removed
						when the workflow is fully integrated. **</h5>
					<h3>Public Components</h3>
					<h4 class="headerColor clearBoth step-header">Step 1: Discuss Concerns</h4>
					<div class="home-row clearfix">
						<div class="step"><a href="travelMap.do">1a: Map your Daily Travel</a><br />
							<small>Information about this step</small></div>
						<div class="date">11/15 - 11/25</div>
					</div>
					<div class="home-row clearfix">
						<div class="step"><a href="cctlist.do">1b: Brainstorm Concerns</a><br />
							<small>Information about this step</small></div>
						<div class="date">11/15 - 11/25</div>
					</div>
					<div class="home-row clearfix">
						<div class="step"><a href="sdlist.do">1c: Review Summaries</a><br />
							<small>Information about this step</small></div>
						<div class="date">11/15 - 11/25</div>
					</div>
					<h4 class="headerColor clearBoth step-header">Step 2: Review Planning Factors</h4>
					<div class="home-row clearfix">
						<div class="step"><a href="sdlist.do">2a: Review Planning Factors</a><br />
							<small>Information about this step</small></div>
						<div class="date">11/15 - 11/25</div>
					</div>
					<div class="home-row clearfix">
						<div class="step"><a href="criteriaWeigh.do?suiteId=200">2b: Weigh Planning
								Factors</a><br />
							<small>Information about this step</small></div>
						<div class="date">11/15 - 11/25</div>
					</div>
					<h4 class="headerColor clearBoth step-header">Step 3: Review Projects</h4>
					<div class="home-row clearfix">
						<div class="step"><a href="sdlist.do">3a: Review Projects</a><br />
							<small>Information about this step</small></div>
						<div class="date">11/15 - 11/25</div>
					</div>
					<div class="home-row clearfix">
						<div class="step"><a href="sdlist.do">3b: Review Funding</a><br />
							<small>Information about this step</small></div>
						<div class="date">11/15 - 11/25</div>
					</div>
					<div class="home-row clearfix">
						<div class="step"><a href="fundingCalc.do?fundSuiteId=200">3c: Funding "Tax
								Calculator" Game</a><br />
							<small>Information about this step</small></div>
						<div class="date">11/15 - 11/25</div>
					</div>
					<div class="home-row clearfix">
						<div class="step"><a href="createPackage.do?pkgSuiteId=200&projSuiteId=200&fundSuiteId=200&critSuiteId=200">3d:
								Create Personal Package</a><br />
							<small>Information about this step</small></div>
						<div class="date">11/15 - 11/25</div>
					</div>
					<div class="home-row clearfix">
						<div class="step"><a href="criteriaList.do">Re-weigh Planning Factors</a><br />
							<small>Information about this step</small></div>
						<div class="date">11/15 - 11/25</div>
					</div>
					<h4 class="headerColor clearBoth step-header">Step 4: Review Packages</h4>
					<div class="home-row clearfix">
						<div class="step"><a href="sdlist.do">4a: Review Packages</a><br />
							<small>Information about this step</small></div>
						<div class="date">11/15 - 11/25</div>
					</div>
					<div class="home-row clearfix">
						<div class="step"><a href="packageVote.do?voteSuiteId=200">4b: Package Voting</a><br />
							<small>Information about this step</small></div>
						<div class="date">11/15 - 11/25</div>
					</div>
					<h4 class="headerColor clearBoth step-header">Step 5: Review Report</h4>
					<div class="home-row clearfix">
						<div class="step"><a href="sdlist.do">5a: Review Report</a><br />
							<small>Information about this step</small></div>
						<div class="date">11/15 - 11/25</div>
					</div>
					<h3>Moderator Tools</h3>
					<h4 class="headerColor clearBoth step-header">Global Components</h4>
					<div class="home-row clearfix">
						<div class="step"><a href="usermgr.do">Manage Users</a><br />
							<small>Information about this step</small></div>
						<div class="date">11/15 - 11/25</div>
					</div>
					<div class="home-row clearfix">
						<div class="step"><a href="glossaryManage.do">Manage Glossary</a><br />
							<small>Information about this step</small></div>
						<div class="date">11/15 - 11/25</div>
					</div>
					<div class="home-row clearfix">
						<div class="step"><a href="tagging.do">Manage Tags/Stopwords</a><br />
							<small>Information about this step</small></div>
						<div class="date">11/15 - 11/25</div>
					</div>
					<div class="home-row clearfix">
						<div class="step"><a href="criteriaMgr.do">Manage Planning Factors</a><br />
							<small>Information about this step</small></div>
						<div class="date">11/15 - 11/25</div>
					</div>
					<div class="home-row clearfix">
						<div class="step"><a href="projectManage.do">Manage Projects</a><br />
							<small>Information about this step</small></div>
						<div class="date">11/15 - 11/25</div>
					</div>
					<div class="home-row clearfix">
						<div class="step"><a href="fundingManage.do">Manage Funding</a><br />
							<small>Information about this step</small></div>
						<div class="date">11/15 - 11/25</div>
					</div>
					<div class="home-row clearfix">
						<div class="step"><a href="feedback.do">Manage Feedbacks</a><br />
							<small>Information about this step</small></div>
						<div class="date">11/15 - 11/25</div>
					</div>
					<h4 class="headerColor clearBoth step-header">Step 1</h4>
					<div class="home-row clearfix">
						<div class="step"><a href="cstlist.do">Concerns Synthesis Tool</a><br />
							<small>Information about this step</small></div>
						<div class="date">11/15 - 11/25</div>
					</div>
					<h4 class="headerColor clearBoth step-header">Step 2</h4>
					<div class="home-row clearfix">
						<div class="step"><a href="criteriaDefine.do?suiteId=200&cctId=1187">Define
								Planning Factors</a><br />
							<small>Information about this step</small></div>
						<div class="date">11/15 - 11/25</div>
					</div>
					<h4 class="headerColor clearBoth step-header">Step 3</h4>
					<div class="home-row clearfix">
						<div class="step"><a href="projectDefine.do?suiteId=200">Define Projects</a><br />
							<small>Information about this step</small></div>
						<div class="date">11/15 - 11/25</div>
					</div>
					<div class="home-row clearfix">
						<div class="step"><a href="fundingDefine.do?suiteId=200">Define Funding</a><br />
							<small>Information about this step</small></div>
						<div class="date">11/15 - 11/25</div>
					</div>
					<div class="home-row clearfix">
						<div class="step"><a href="projectGrading.do?projsuiteId=200&critsuiteId=200">Grade
								Projects</a><br />
							<small>Information about this step</small></div>
						<div class="date">11/15 - 11/25</div>
					</div>
					<h4 class="headerColor clearBoth step-header">Step 4</h4>
					<div class="home-row clearfix">
						<div class="step"><a href="packageMgr.do?pkgSuiteId=200&projSuiteId=200&fundSuiteId=200&critSuiteId=200">Manage
								Packages</a><br />
							<small>Information about this step</small></div>
						<div class="date">11/15 - 11/25</div>
					</div>
					<h4 class="headerColor clearBoth step-header disabled">Step 5</h4>
					<div class="home-row clearfix disabled">
						<div class="step"><a href="#">Manage Report</a><br />
							<small>Information about this step</small></div>
						<div class="date">11/15 - 11/25</div>
					</div>
					-->

				</pg:show>
			</div>
		</div>
		<div id="right-col">
			<h3 class="headerColor">Moderator announcements</h3>
			<div id="mod-announcements" class="box9">
				<div id="announcements">
					<img src="/images/indicator_arrows.gif" alt="Please wait..."/> Loading Moderator Announcements...
					<!--load via DWR -->
				</div>
			</div>
			<pg:show roles="moderator">
				<input type="button" id="btnEdit" class="padding5" value="Add Announcement" 
				onclick="addAnnouncementPrep()" />
				<div id="announce-editor" style="display:none">
					<textarea name="content" id="modAnnounce"></textarea>
					<br/>
					<div class="floatRight"><input id="email" type="checkbox" value="true" /><label for="email">Email Participants</div>
					<input type="button" id="pubBtn" 
						onclick="addAnnouncement();Element.toggle($('announce-editor'));" 
						class="padding5" value="Publish" />
					<input type="button" id="editBtn" 
						onclick="editAnnouncement(name);Element.toggle($('announce-editor'));" 
						class="padding5" style="display:none" value="Save" />
					<a href="javascript:Element.toggle($('announce-editor'));void(0);">Cancel</a> </div>
			</pg:show>
		</div>
		<div class="clearBoth"></div>
		<!-- begin RECENT DISCUSSIONS -->
		<div id="recent-wrapper">
			<h3 class="headerColor floatLeft">Recent discussions</h3>
			<div class="floatRight"><span><a href="#">Previous</a></span>
			<span><a href="#">Next</a></span></div>
			<div class="clearBoth"></div>
			<div id="recent-discussions" class="box3">
				<!-- begin RECENT DISCUSSIONS HEADER -->
				<div class="listRow headingColor heading clearfix">
					<div class="home-col1 floatLeft" style="margin-left:.2em">
						<div class="floatLeft">
							<h4>Topic</h4>
						</div>
					</div>
					<div class="home-col2 floatRight">
						<h4>Last Post</h4>
					</div>
				</div>
				<!-- end RECENT DISCUSSIONS HEADER -->
				<!-- begin A RECENT DISCUSSION -->
				<div class="list clearfix">
					<div class="home-col1 floatLeft">
						<div class="floatLeft"><a href="#">Rebuild the viaduct!</a><br />
							<span>Step 3a: Review Projects</span></div>
					</div>
					<div class="home-col2 floatRight">1/31</div>
				</div>
				<!-- end A RECENT DISCUSSION -->
				<div class="listRow odd clearfix">
					<div class="home-col1 floatLeft">
						<div class="floatLeft"><a href="#">Rebuild the viaduct but don't spend any
								more money</a><br />
							<span>Step 3a: Review Projects</span></div>
					</div>
					<div class="home-col2 floatRight">1/31</div>
				</div>
				<div class="listRow  clearfix">
					<div class="home-col1 floatLeft">
						<div class="floatLeft"><a href="#">Rebuild the viaduct!</a><br />
							<span>Step 3a: Review Projects</span></div>
					</div>
					<div class="home-col2 floatRight">1/31</div>
				</div>
				<div class="listRow odd clearfix">
					<div class="home-col1 floatLeft">
						<div class="floatLeft"><a href="#">Rebuild the viaduct!</a><br />
							<span>Step 3a: Review Projects</span></div>
					</div>
					<div class="home-col2 floatRight">1/31</div>
				</div>
				<div class="listRow  clearfix">
					<div class="home-col1 floatLeft">
						<div class="floatLeft"><a href="#">Rebuild the viaduct!</a><br />
							<span>Step 3a: Review Projects</span></div>
					</div>
					<div class="home-col2 floatRight">1/31</div>
				</div>
			</div>
			
		</div>
		<!-- end RECENT DISCUSSIONS -->
		<!--begin POPULAR DISCUSSIONS -->
		<div id="popular-wrapper">
			<h3 class="headerColor">Popular discussions</h3>
			<div id="popular-discussions" class="box3">
				<!-- begin POPULAR DISCUSSIONS HEADER -->
				<div class="listRow headingColor heading clearfix">
					<div class="home-col1 floatLeft" style="margin-left:.2em">
						<div class="floatLeft">
							<h4>Topic</h4>
						</div>
					</div>
					<div class="home-col2 floatRight">
						<h4>Last Post</h4>
					</div>
				</div>
				<!-- end POPULAR DISCUSSIONS HEADER -->
				<!-- begin A POPULAR DISCUSSION -->
				<div class="listRow clearfix">
					<div class="home-col1 floatLeft">
						<div class="floatLeft"><a href="#">Rebuild the viaduct!</a><br />
							<span>Step 3a: Review Projects</span></div>
					</div>
					<div class="home-col2 floatRight">1/31</div>
				</div>
				<!-- end A POPULAR DISCUSSION -->
				<div class="listRow odd clearfix">
					<div class="home-col1 floatLeft">
						<div class="floatLeft"><a href="#">Rebuild the viaduct!</a><br />
							<span>Step 3a: Review Projects</span></div>
					</div>
					<div class="home-col2 floatRight">1/31</div>
				</div>
				<div class="listRow clearfix">
					<div class="home-col1 floatLeft">
						<div class="floatLeft"><a href="#">Rebuild the viaduct!</a><br />
							<span>Step 3a: Review Projects</span></div>
					</div>
					<div class="home-col2 floatRight">1/31</div>
				</div>
				<div class="listRow odd clearfix">
					<div class="home-col1 floatLeft">
						<div class="floatLeft"><a href="#">Rebuild the viaduct!</a><br />
							<span>Step 3a: Review Projects</span></div>
					</div>
					<div class="home-col2 floatRight">1/31</div>
				</div>
				<div class="listRow clearfix">
					<div class="home-col1 floatLeft">
						<div class="floatLeft"><a href="#">Rebuild the viaduct!</a><br />
							<span>Step 3a: Review Projects</span></div>
					</div>
					<div class="home-col2 floatRight">1/31</div>
				</div>
				
				<!-- end POPULAR DISCUSSIONS -->
			</div>
		</div>
		<!-- end POPULAR DISCUSSIONS -->
		<div class="clearBoth"></div>
		<pg:show roles="participant">
			<h3 class="headerColor">My keywords</h3>
			<div id="keywords" class="clearfix">
				<ul>
					<li class="tagSize2">accidents</li>
					<li class="tagSize4">automobiles</li>
					<li class="tagSize3">Snohomish</li>
					<li class="tagSize2">bike</li>
					<li class="tagSize3">bicycle</li>
					<li class="tagSize1">Density</li>
					<li class="tagSize4">disagreement</li>
					<li class="tagSize2">environment</li>
					<li class="tagSize1">I-405</li>
					<li class="tagSize5">federal</li>
					<li class="tagSize3">taxes</li>
					<li class="tagSize1">community</li>
					<li class="tagSize1">Transit</li>
					<li class="tagSize2">commuting</li>
					<li class="tagSize4">Viaduct</li>
				</ul>
			</div>
		</pg:show>
	</div>
	<!-- end container -->
	<!-- start feedback form -->
	<pg:feedback id="feedbackDiv" action="cctView.do"/>
	<!-- end feedback form -->
	<!-- Begin header menu - The wide ribbon underneath the logo -->
    <!-- Start Global Headers  -->
    <wf:subNav />
    <!-- End Global Headers -->
	<!-- Begin footer -->
	<div id="footer"> 
		<jsp:include page="/footer.jsp" />
	</div>
	<!-- End footer -->
	<script type="text/javascript" charset="utf-8"> 
		getAnnouncements();
	</script>
	</body>
</html:html>
