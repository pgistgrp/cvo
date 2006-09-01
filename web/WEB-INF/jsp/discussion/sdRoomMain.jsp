<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.pgist.org/pgtaglib" prefix="pg" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<html:html>
<head>
<title>Structured Discussion Main</title>
<!-- Site Wide CSS -->
<style type="text/css" media="screen">@import "styles/position.css";</style>
<style type="text/css" media="screen">@import "styles/styles.css";</style>
<!-- Temporary Borders used for testing <style type="text/css" media="screen">@import "styles/tempborders.css";</style>-->
<!-- End Site Wide CSS -->


<!-- Site Wide JavaScript -->
<script src="scripts/tags.js" type="text/javascript"></script>
<script src="scripts/prototype.js" type="text/javascript"></script>
<script src="scripts/scriptaculous.js?load=effects,dragdrop" type="text/javascript"></script>
<script src="scripts/search.js" type="text/javascript"></script>
<!-- End Site Wide JavaScript -->

<!-- DWR JavaScript Libraries -->
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<!-- End DWR JavaScript Libraries -->

<!--SDX Specific  Libraries-->
<script type='text/javascript' src='/dwr/interface/SDAgent.js'></script>
<!--End SDX Specific  Libraries-->


<script type="text/javascript">
	//Start Global Variables

	 function InfoObject(){
	 	 this.objectDiv =  'object-content';
	 	 this.discussionDiv = 'discussion';
	 	 this.sidebarDiv = 'sidebar_object';
	 	 this.roomsTitle = "All Concern Themes"; //used to display the room selector title (for link back to all rooms)

	 	this.assignTargetHeaders = function(){
	 			var targetTitle = "${object.object}";
				$('targetTitle').innerHTML = '<html:link action="/sd.do" paramId="isid" paramName="structure" paramProperty="id">'+ this.roomsTitle +'</html:link>  &raquo; ' + targetTitle; //object title div id
				$('targetDiscussionTitle').innerHTML = targetTitle;//discussion title div id
				if (${object.numDiscussion} == 1){
				 	$('targetDiscussionTitle').innerHTML += ' - ${object.numDiscussion} Discussion';
				}else{
					$('targetDiscussionTitle').innerHTML += ' - ${object.numDiscussion} Discussions';
				}
				$('targetSideBarTitle').innerHTML = 'filtered by: ' + targetTitle;//sidebar title div id
				this.getTargets();
		};
	 	this.getTargets = function(){
	 		//if (${object.id} != null){
	 		displayIndicator(true);
	 		SDAgent.getSummary({ioid: ${object.id}}, {
					callback:function(data){
							if (data.successful){
	              				 $(infoObject.objectDiv).innerHTML = data.source.html; 
	              				
	              			  if(data.voting == null || data.voting == undefined){
						           $('structure_question').innerHTML = '<span class="smalltext">Does this summary adequately reflect concerns expressed by participants? <a href="javascript:infoObject.setVote(true);"><img src="images/btn_yes_s.gif" alt="YES" border="0"><a href="javascript:infoObject.setVote(false);"><img src="images/btn_no_s.gif" alt="NO" border="0"></a></span>';
					          }else{
						           $('structure_question').innerHTML = '<span class="smalltext">Your vote has been recorded. Thank you for your participation.</span>';
						      }
						      displayIndicator(false);
							}else{
								alert(data.reason);
								 displayIndicator(false);
							}
						},
					errorHandler:function(errorString, exception){ 
							alert("get targets error:" + errorString + exception);
					}
					});
	 			//}else{
	 			//	$(infoObject.objectDiv).innerHTML ="list of concern themes";
	 			//}

	 	};
	 

	 	 this.setVote = function(agree){
	 	 			displayIndicator(true);
					SDAgent.setVoting({ioid: ${object.id}, agree:agree}, {
					callback:function(data){
							if (data.successful){ 
	              				 new Effect.Fade('structure_question', {afterFinish: function(){infoObject.getTargets(); new Effect.Appear('structure_question');}});
	              				 displayIndicator(false);
							}else{
								alert(data.reason);
								displayIndicator(false);
							}
						},
					errorHandler:function(errorString, exception){ 
							alert("get targets error:" + errorString + exception);
					}
					});
			};
	 	 this.createPost = function(){
	 	 		displayIndicator(true);
	 	 		var newPostTitle = $('txtNewPostTitle').value;
	 	 		var newPost = $('txtNewPost').value;
	 	 		var newPostTags = $('txtNewPostTags').value;
	 	 		//validation
	 	 		if(newPostTitle == '' || newPost == ''){
	 	 			alert("Either your title or post was left blank.  Please fill it in.");
	 	 			return
	 	 		}//end validation

				
				SDAgent.createPost({isid:${structure.id}, ioid: ${object.id}, title: newPostTitle, content: newPost, tags:newPostTags}, {
				callback:function(data){
						if (data.successful){
							 infoObject.getPosts();
							 //clear new discussion textfields
							 $('txtNewPostTitle').value = '';
							 $('txtNewPost').value = '';
							 $('txtNewPostTags').value = '';
							 toggleNewDiscussion();
							 displayIndicator(false);
						}else{
							alert(data.reason);
							 toggleNewDiscussion();
							 displayIndicator(false);
						}
					},
				errorHandler:function(errorString, exception){ 
						alert("create post error:" + errorString + exception);
				}
				});
			};
			
		this.getPosts = function(){
		    displayIndicator(true);
	    	var page = 1;
	 		if (<%= request.getParameter("page") %> != null){
	 			page = <%= request.getParameter("page") %>;	
	 		}
		    SDAgent.getPosts({isid:${structure.id}, ioid:${object.id}, page: page, count: 10}, {
		      callback:function(data){
		          if (data.successful){
		          $(infoObject.discussionDiv).innerHTML = data.html;
		           displayIndicator(false);
		          }else{
		            alert(data.reason);
		            displayIndicator(false);
		          }
		      },
		      errorHandler:function(errorString, exception){
		          alert("get posts error:" + errorString + exception);
		      }
		    });
		  };
	};
	
	function Discussion(){
		this.discussionDivSort = "header_cat";
		displayIndicator(true);
		this.deletePost = function(postId){
		var destroy = confirm ("Are you sure you want to delete this post? Note: there is no undo.")
		if (destroy){
			    SDAgent.deletePost({pid: postId}, {
			      callback:function(data){
			          if (data.successful){
								
			          			$('discussion-post'+postId).innerHTML = "deleting...";
			          			setTimeout("new Effect.DropOut('discussion-post-cont"+postId+"', {afterFinish: function(){infoObject.getPosts(infoObject.targetId)}});", 1000);
			          			displayIndicator(false);
								
			          }else{
			           	 alert(data.reason);
			           	 displayIndicator(false);
			          }
			      },
			      errorHandler:function(errorString, exception){
			          alert("delete post error:" + errorString + exception);
			      }
			    });
	  	}
		}
		/*
		this.getPost = function(postId){
		if(objExpanded){
				moreDiscussion();
		}
		displayIndicator(true);
	    SDAgent.getPostById({id: postId}, {
	      callback:function(data){
	          if (data.successful){
	          		new Effect.BlindUp(discussion.discussionDivSort, {duration: 0.3});
	          		var tags = '';
	          		for(i=0; i<data.post.tags.length; i++){
	          			tags += '<li class="tagsList">' +data.post.tags[i].name+ '</li>';	
	          		}
	          		
	          		$(infoObject.discussionDiv).innerHTML = '<div id="discussion-post-cont'+data.post.id+'"><p><a href="javascript:infoObject.getPosts('+infoObject.targetId+')">Back to list of discussions</a></p><div id="discussion-post'+data.post.id+'" class="whiteBlueBB"><h5>'+data.post.title+'</h5><p>Posted by: '+data.post.owner.loginname+' on '+data.post.createTime+' <br /><strong>Author Actions: </strong> <a href="javascript:discussion.deletePost('+data.post.id+')">delete discussion</a> | edit discussion (actions available until commented on)</p><p>'+data.post.content+'</p><p><strong>Tags:</strong> <ul class="tagsList">'+tags+'</ul></p></div><p><a href="javascript:infoObject.getPosts('+infoObject.targetId+')">Back to list of discussions</a></p></div>';
	          		//$(infoObject.discussionDiv).innerHTML += '
	          		displayIndicator(false);
	          }else{
	           	 alert(data.reason);
	           	 displayIndicator(false);
	          }
	      },
	      errorHandler:function(errorString, exception){
	          alert("get post error:" + errorString + exception);
	          displayIndicator(false);
	      }
	    });
		}*/
	};
	
	//End Global Variables
	
	function displayIndicator(show){
		if (show){
			$('loading-indicator').style.display = "inline";	
		}else{
			$('loading-indicator').style.display = "none";	
		}
	}
	/*
	function closeAllContentsExcept(id, className){
		var activeRecord = className + id;
		var allRecords = document.getElementsByClassName(className);
		
		for(i = 0; i < allRecords.length; i++){
			if(allRecords[i].id == activeRecord){
				new Effect.toggle(allRecords[i].id,'blind', {duration: 0.4});
			}else{
				if(allRecords[i].style.display != 'none'){
				new Effect.BlindUp(allRecords[i].id, {duration: 0.4});
				}
			}
		}
		//new Effect.toggle('quickPostContents${post.id}', 'blind', {duration: 0.3}); void(0);"	
	}
	*/
	function toggleNewDiscussion(){
		if ($('newDiscussion').style.display == 'none'){
			displayIndicator(true);
			new Effect.toggle('newDiscussion', 'blind', {duration: 0.5});
			$('sidebarbottom_disc').style.display = 'none';	
			$('sidebarbottom_newdisc').style.display = 'block';	
			displayIndicator(false);
		}else{
			displayIndicator(true);
			new Effect.toggle('newDiscussion', 'blind', {duration: 0.5, afterFinish: function(){
			$('sidebarbottom_disc').style.display = 'block';	
			$('sidebarbottom_newdisc').style.display = 'none';	
			displayIndicator(false);	
			}});		
		}
	}
 
</script>
</head>


<body>

<div id="container">
	<jsp:include page="/header.jsp" />
		
   <div id="loading-indicator">Loading... <img src="/images/indicator_arrows.gif"></div>
	
	<!-- Sub Title -->
	<div id="subheader">
	<h1>Step 1b:</h1> <h2>Review Summaries</h2>
	</div>
	<div id="footprints">
	<span class="smalltext"><a href="#">Participate</a> &raquo; <a href="#">Step 1 Brainstorm Concerns</a> &raquo; <a href="sd.do?isid=${structure.id}">Step 1b Review Summaries</a> &raquo; ${object.object}</span>
	</div>
	<!-- End Sub Title -->
	
	<!-- Overview SpiffyBox -->
	<div class="cssbox">
		<div class="cssbox_head">
			<h3>Overview and Instructions</h3>
		</div>
		<div class="cssbox_body">
			<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Nam interdum. Donec accumsan, purus ut viverra pharetra, augue tellus vehicula orci, eget consectetuer neque tortor id
			ante. Proin vehicula imperdiet ante. Mauris vehicula velit sed arcu. Ut aliquam pede ac arcu. Phasellus dictum condimentum nisl. Quisque elementum dictum nibh. Curabitur
			auctor faucibus libero. Suspendisse eu dui ut sem nonummy egestas. Praesent luctus lorem a magna.</p>
		</div>
	</div>
	<!-- End Overview -->
	
	<div class="backToDiscussion">
		<div id="tselector">
			<label>
			Jump To:
			 <select name="selecttheme" id="selecttheme" onChange="javascript: location.href='sdRoom.do?isid=${structure.id}&ioid=' + this.value;">		  
				<option value = "${object.id}">Select a Theme</option>
				<c:forEach var="infoObject" items="${structure.infoObjects}">
					   <option value="${infoObject.id}">${infoObject.object}</option>
				</c:forEach>	
		 	 </select>
			</label>
		</div>	<!-- end tselector -->
		<div id="backdisc"><a href="sd.do?isid=${structure.id}">Back to All Concern Themes</a></div>	  
	</div> <!-- end backtodiscussion -->
	<div id="cont-main">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
						<td id="maintop"><img src="" alt="" height="1" width="1"/></td>
						<td><img src="images/sidebar_top.gif" alt="sidebartop" /></td>
				</tr>
				<tr>
						<td valign="top" id="maincontent">
							<!-- Main Content starts Here-->
							<h4>Summarization of Participant Concerns </h4>
							<div id="object">
								<div class="padding">
									<h5 id = "targetTitle"></h5>
									<div id="object-content">
										<!-- load object here -->
									</div><!--end object content -->
								</div> <!-- end padding -->
							</div> <!-- end object -->
							<p class="textalignright">&nbsp;</p>
						</td> <!-- end td main content -->
						
						<td width="280" valign="top" id="sidebarmiddle"><!-- This is the Right Col -->
							<div id="sidebar_container">
									<div id="tagSelector">
										<div id="tagform">
											<h6>Sidebar filtered by:</h6>
											[Tags ] [Tags] [Tags]<br />
											<form action="" method="get">
												Sidebar Filter: 
												 <input name="tagSearch" id="txtmanualFilter" type="text" onKeyDown="sidebarTagSearch(this.value)" />
											</form>
										</div><!-- end tagform -->
										<div id="pullDown" class="textright"><a href="javascript: expandTagSelector();">Expand</a></div>
										<div id="allTags" style="display: none;"><!--load tags --></div>
										<div class="clear"></div>
									</div> <!-- end tag selector -->
									<div id="tagSelector_spacer" style="display: none;"><!-- Duplicate tagSelector to work as a spacer during expand effect -->
									<h6>Sidebar filtered by:</h6>
									[Tags ] [Tags] [Tags]<br />
									<form action="" method="get">
									Sidebar Filter: 
									  <input name="tagSearch" id="tagSearch_spacer" type="text" style="visibility: hidden;"/>
									</form>
									<div id="pullDown_spacer" class="textright" style="visibility: hidden;">Expand</div>
									<div id="allTags_spacer" style="visibility: hidden;"></div>
									<div class="clear"></div>
								</div>
								
								<div id="sidebarSearchResults" style="display: none;"></div>
								  <div id="sidebar_content">
									<h5 id="targetSideBarTitle"></h5>
												<!-- Fake concerns -->
												<div id="concernId887" class="theConcern">
										            <span class="participantName"><a href="userProfile887.jsp">DoeDiane</a></span>&nbsp;said:
										            <br>
										            <span class="concerns">"The transportation system should be more accessible to all citizens"</span><br>
										            <span class="tags"><a href="javascript:getConcernsByTag(864);">accessibility</a></span>            
										        </div>
										
										        <div id="concernId918" class="theConcern">
										            <span class="participantName"><a href="userProfile918.jsp">MurphyMary</a></span>&nbsp;said:
										            <br>
										            <span class="concerns">"Non-commuter vehicles shouldn't drive in commuter lanes"</span><br>
										            <span class="tags"><a href="javascript:getConcernsByTag(902);">commuting</a></span>
										            <span class="tags"><a href="javascript:getConcernsByTag(885);">congestion</a></span>
										            <span class="tags"><a href="javascript:getConcernsByTag(894);">hov lanes</a></span>
										            <span class="tags"><a href="javascript:getConcernsByTag(917);">law enforcement</a></span>
										            <span class="tags"><a href="javascript:getConcernsByTag(868);">safety</a></span>    
										        </div>
										
										        <div id="concernId878" class="theConcern">
										            <span class="participantName"><a href="userProfile878.jsp">JonesJane</a></span>&nbsp;said:
										            <br>
										            <span class="concerns">"Transportation systems should promote livability and walkability"</span><br>
										            <span class="tags"><a href="javascript:getConcernsByTag(873);">density</a></span>
										            <span class="tags"><a href="javascript:getConcernsByTag(874);">downtown</a></span>
										            <span class="tags"><a href="javascript:getConcernsByTag(877);">health</a></span>
										            <span class="tags"><a href="javascript:getConcernsByTag(871);">livability</a></span>
										            <span class="tags"><a href="javascript:getConcernsByTag(875);">sprawl</a></span>
										            <span class="tags"><a href="javascript:getConcernsByTag(855);">transportation planning</a></span>
										            <span class="tags"><a href="javascript:getConcernsByTag(872);">walkability</a></span>                    
										        </div>
										
										        <div id="concernId891" class="theConcern">
										            <span class="participantName"><a href="userProfile891.jsp">JohnsonJohn</a></span>&nbsp;said:
										            <br>
										            <span class="concerns">"We should not continue to fund a reliance on motor vehicles"</span><br>
										            <span class="tags"><a href="javascript:getConcernsByTag(890);">alternative</a></span>
										            <span class="tags"><a href="javascript:getConcernsByTag(888);">car</a></span>
										            <span class="tags"><a href="javascript:getConcernsByTag(882);">funding</a></span>
										            <span class="tags"><a href="javascript:getConcernsByTag(889);">taxes</a></span>
										            <span class="tags"><a href="javascript:getConcernsByTag(855);">transportation planning</a></span>        
										        </div>
										
										        <div id="concernId866" class="theConcern">
										            <span class="participantName"><a href="userProfile866.jsp">BrownBob</a></span>&nbsp;said:<br>
										            <span class="concerns">"Restrooms at Metro transit stations need to be handicapped accessible"</span><br>
										            <span class="tags"><a href="javascript:getConcernsByTag(860);">Metro</a></span>
										            <span class="tags"><a href="javascript:getConcernsByTag(864);">accessibility</a></span>
										        </div>
												<!-- end fake concerns -->
								
								<div id="caughtException"><h4>A Problem has Occured</h4><br>We are sorry but there was a problem accessing the server to complete your request.  <b>Please try refreshing the page.</b></div>
								
								</div><!-- End sidebarcontents-->
								</div><!-- sidebar container-->
					</td>
				<!-- End Right Col -->
				</tr>
		</table>
		<div id="sidebarbottom_disc" style="text-align:right; display: block;"><img src="/images/sidebar_bottom.gif" alt="sidebarbottom" /></div>
		<div id="sidebarbottom_newdisc" style="text-align:right; display: none;"><img src="/images/sidebar_bottom.gif" alt="sidebarbottom" /></div>
	</div><!-- End cont-main -->
	<div id="newDiscussion" style="display: none">
		<div id="newdisc_title" >
			New Discussion
			<span id="closeNewDiscussion" class="closeBox"><a href="javascript:toggleNewDiscussion();">Close</a></span>
		</div> <!-- End newdisc_title -->
		<div id="newdisc_content" class="greenBB">
			<p>SDC New Discussion Paragraph</p>
			<form>
				<p><label>Post Title</label><br><input style="width:100%" type="text" id="txtNewPostTitle"/></p>
				<p><label>Your Thoughts</label><br><textarea style="width:100%; height: 200px;" id="txtNewPost"></textarea></p>
				<p><label>Tag your post (comma separated)</label><br><input style="width:100%" id="txtNewPostTags" type="text" /></p>
				<input type="button" onClick="infoObject.createPost();" value="Create Discussion">
			</form>
		</div>
	</div>
		
	<div id="discussion-cont">
		<span class="padding"><h4 id="targetDiscussionTitle"></h4></span><span id="closeNewDiscussion" class="closeBox"><a href="javascript:toggleNewDiscussion();">New Discussion</a></span>
		<div id="discussion"><!-- load discussion posts --></div>
	</div>
		
	<div id="finished" class="greenBB">
		<h4>Step 4. Finished?</h4><br />
		Go back or continue... [add buttons] [Cancel]
	</div>

</div> <!-- End container -->
<!-- Start Footer -->
<jsp:include page="/footer.jsp" />

<!-- End Footer -->
<!-- Run javascript function after most of the page is loaded, work around for onLoad functions quirks with tabs.js -->
<script type="text/javascript">
	var infoObject = new InfoObject(); 
	var discussion = new Discussion();

	infoObject.getPosts();
	infoObject.assignTargetHeaders();

</script>

</body>

</html:html>

