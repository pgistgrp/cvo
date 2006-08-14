<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.pgist.org/pgtaglib" prefix="pg" %>
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<html:html>
<head>
<title>Structured Discussion Main</title>
<!-- Site Wide CSS -->
<style type="text/css" media="screen">@import "styles/position.css";</style>
<style type="text/css" media="screen">@import "styles/styles.css";</style>
<style type="text/css" media="screen">@import "styles/tabs.css";</style>
<style type="text/css" media="screen">@import "styles/headertabs.css";</style>
<!-- Temporary Borders used for testing <style type="text/css" media="screen">@import "styles/tempborders.css";</style>-->
<!-- End Site Wide CSS -->


<!-- Site Wide JavaScript -->
<script src="scripts/headercookies.js" type="text/javascript"></script>
<script src="scripts/headertabs.js" type="text/javascript"></script>
<script src="scripts/tabcookies.js" type="text/javascript"></script>
<script src="scripts/tabs.js" type="text/javascript"></script>
<script src="scripts/tags.js" type="text/javascript"></script>
<script src="scripts/prototype.js" type="text/javascript"></script>
<script src="scripts/scriptaculous.js?load=effects,dragdrop" type="text/javascript"></script>
<script src="scripts/findxy.js" type="text/javascript"></script>
<script src="scripts/search.js" type="text/javascript"></script>
<!-- End Site Wide JavaScript -->

<!-- DWR JavaScript Libraries -->
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<!-- End DWR JavaScript Libraries -->

<!--SDX Specific  Libraries-->
<script src="scripts/resize.js" type="text/javascript"></script>
<script src="scripts/expand.js" type="text/javascript"></script>
<script type='text/javascript' src='/dwr/interface/SDAgent.js'></script>
<style type="text/css" media="screen">@import "styles/toggle_sdc.css";</style>
<!--End SDX Specific  Libraries-->


<script type="text/javascript">
	//Start Global Variables
     //var isid = ${structure.id};
	 var targetObject = null;
	 function InfoStructure(){
	 	 this.isid = ${structure.id};
	 	 this.type = "${structure.type}";
	 	 this.instructions = "These are the instructions for blah blah";
	 	 this.data = null;
	 	 this.isDivTargetNavText = 'targetNavText';
	 	 this.isDivTargetTitle = 'targetTitle';
	 	 this.isDivTargetDiscussionTitle = "targetDiscussionTitle";
	 	 this.isDivTargetSideBarTitle = "targetSideBarTitle";
	 	 this.isDivElement =  'object_column';
	 	 this.isDivDiscussion = 'discussion';
	 	 this.targetType = 'structure';
	 	 this.targetId = null;
	 	 
	 	 this.getTargetPanes = function(ioid){
	 	 	this.getPosts(ioid);
	 	 	this.getDetails(ioid);
	 		
	 	};
	 	
	 	this.assignTargetHeaders = function(targetTitle){
	 		if(targetTitle){
				$(this.isDivTargetTitle).innerHTML = targetTitle;
				$(this.isDivTargetDiscussionTitle).innerHTML = "Discussion about " + targetTitle;
				$(this.isDivTargetSideBarTitle).innerHTML = this.sideBarTheme+ ' ' + targetTitle;
			}else{
				$(this.isDivTargetTitle).innerHTML = this.defaultObjectTitle; 
				$(this.isDivTargetDiscussionTitle).innerHTML = "Discussion about " + this.defaultDiscussionTitle;
				$(this.isDivTargetSideBarTitle).innerHTML = this.sideBarTheme + ' ' +  this.defaultSidebarTitle;
			}
		};
	 	
	 	 this.getTargets = function(){
	 	 		displayIndicator(true);
				SDAgent.getTargets({isid:${structure.id}}, {
				callback:function(data){
						if (data.successful){
							$(infoStructure.isDivElement).innerHTML = data.source.html;
              				eval(data.source.script);
              				 displayIndicator(false);
              				 infoStructure.assignTargetHeaders();
              				 $(infoStructure.isDivTargetNavText).innerHTML =  infoStructure.defaultTargetNavText;  //reset navText
              				 infoStructure.targetId = null; //reset targetId
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
	 	 		var newPostTitle = $('txtNewPostTitle').value;
	 	 		var newPost = $('txtNewPost').value;
	 	 		var newPostTags = $('txtNewPostTags').value;
	 	 		//validation
	 	 		if(newPostTitle == '' || newPost == ''){
	 	 			alert("Either your title or post was left blank.  Please fill it in.");
	 	 			return;
	 	 		}//end validation
				SDAgent.createPost({isid:${structure.id}, target: infoStructure.targetType, targetId: infoStructure.targetId, title: newPostTitle, content: newPost, tags:newPostTags}, {
				callback:function(data){
						if (data.successful){
							 infoStructure.getPosts(infoStructure.targetId);
							 //clear new discussion textfields
							 $('txtNewPostTitle').value = '';
							 $('txtNewPost').value = '';
							 $('txtNewPostTags').value = '';
							 new Effect.toggle('newDiscussion', 'blind', {duration: 0.5});
						}else{
							alert(data.reason);
							new Effect.toggle('newDiscussion', 'blind', {duration: 0.5});
						}
					},
				errorHandler:function(errorString, exception){ 
						alert("create post error:" + errorString + exception);
				}
				});
			};
			
		this.getPosts = function(ioid){
			if($(discussion.discussionDivSort).style.display == "none"){
				new Effect.BlindDown(discussion.discussionDivSort, {duration: 0.5});
			}
			if(ioid != undefined){
				infoStructure.targetType = 'object';
				infoStructure.targetId = ioid;
		  	}
		    displayIndicator(true);
		    SDAgent.getPosts({isid:${structure.id}, ioid:ioid}, {
		      callback:function(data){
		          if (data.successful){
		          $(infoStructure.isDivDiscussion).innerHTML = data.html;
		           displayIndicator(false);
		          }else{
		          	 displayIndicator(false);
		            alert(data.reason);
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
		
		this.deletePost = function(postId){
		var destroy = confirm ("Are you sure you want to delete this post? Note: there is no undo.")
		if (destroy){
			    SDAgent.deletePost({pid: postId}, {
			      callback:function(data){
			          if (data.successful){
								displayIndicator(true);
			          			$('discussion-post'+postId).innerHTML = "deleting...";
			          			setTimeout("new Effect.DropOut('discussion-post-cont"+postId+"', {afterFinish: function(){infoStructure.getPosts(infoStructure.targetId)}});", 1000);
			          			displayIndicator(false);
								
			          }else{
			           	 alert(data.reason);
			          }
			      },
			      errorHandler:function(errorString, exception){
			          alert("get post error:" + errorString + exception);
			      }
			    });
	  	}
		}
		
		
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
	          		
	          		$(infoStructure.isDivDiscussion).innerHTML = '<div id="discussion-post-cont'+data.post.id+'"><p><a href="javascript:infoStructure.getPosts('+infoStructure.targetId+')">Back to list of discussions</a></p><div id="discussion-post'+data.post.id+'" class="whiteBlueBB"><h5>'+data.post.title+'</h5><p>Posted by: '+data.post.owner.loginname+' on '+data.post.createTime+' <br /><strong>Author Actions: </strong> <a href="javascript:discussion.deletePost('+data.post.id+')">delete discussion</a> | edit discussion (actions available until commented on)</p><p>'+data.post.content+'</p><p><strong>Tags:</strong> <ul class="tagsList">'+tags+'</ul></p></div><p><a href="javascript:infoStructure.getPosts('+infoStructure.targetId+')">Back to list of discussions</a></p></div>';
	          		//$(infoStructure.isDivDiscussion).innerHTML += '
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
		}
	};
	
	//End Global Variables
	
	function displayIndicator(show){
		if (show){
			$('loading-indicator').style.display = "inline";	
		}else{
			$('loading-indicator').style.display = "none";	
		}
	}

 
</script>
</head>


<body onResize="dosize()">

<div id="container">
	<!-- START LIGHTBOX -->
	<div id="overlay" style="display: none;"></div>
	<div id="lightbox" style="display: none;" class="blueBB"></div>
	<!-- END LIGHTBOX -->
   <div id="loading-indicator">Loading... <img src="/images/indicator_arrows.gif"></div>
	
	<!-- Sub Title -->
	<div id="subheader">
	<h1>Step 1:</h1> <h2>Brainstorm Concerns</h2>
	</div>
	<div id="footprints">
	<p>LIT Process >> Step 1: Brainstorm >> Concerns</p>
	</div>
	<!-- End Sub Title -->
	
	<!-- Overview SpiffyBox -->
	<div class="cssbox">
	<div class="cssbox_head">
	<h3>Overview and Instructions</h3>
	</div>
	<div class="cssbox_body">
		<p>Before we can determine how to best improve the transportation system, we need to know what the problems are. Our first task is to brainstorm concerns about the transportation system.</p><p>[ Read more about how this step fits into the bigger picture. ]</p>
	</div>
	</div>
	<!-- End Overview -->
	


<div id="cont-resize">
<div>
</div>
<h4>Summary of Participant Concerns</h4>
	<div id="col-left">
	
	<div id="cont-toggle">
		<div id="header_object" class="allBlue">
		<div id="header_title">
		<h5 id="targetTitle"></h5>
		</div>
		<div id="themeSelector">
		<form id="Tselector" name="ThemeSelector" method="post" action="">
		  <label>
		  Jump To:
		  <select name="selecttheme" id="selecttheme" onChange="getTargetPanes(this.value);">		  
		    <option value = "-1">Select a Theme</option>
	      </select>
		  </label>
		  </form>
		  </div>
		  <div class="clear">
		  <span class="smalltext">Last modified: June 2, 2006 by the Moderator</span>
</div>
		</div>
		<div id="object" class="blueBB">
		<span class="smalltext">4 of 15 participants have said that this list of concern themes adequately reflects concerns expressed by participants.</span><br />
		<p id="targetNavText"></p>
		<div id="object_column">
			<div id="object_column_left">
				<ul
				><li><a href="#">Argue</a> <span class="smalltext">(5 Disscussions)</span></li
				><li><a href="#">Donec</a> <span class="smalltext">(5 Disscussions)</span></li
				><li><a href="#">Dictum</a> <span class="smalltext">(7 Disscussions)</span></li
				></ul>
			</div>
			<div id="object_column_center">
				<ul
				><li><a href="#">Pollution</a> <span class="smalltext">(0 Disscussions)</span></li
				><li><a href="#">Public Transportation</a> <span class="smalltext">(0)</span></li
				><li><a href="#">Safety</a> <span class="smalltext">(17 Disscussions)</span></li
				></ul>
			</div>
			<div id="object_column_right">
				<ul
				><li><a href="#">Utellus</a> <span class="smalltext">(0 Disscussions)</span></li
				><li><a href="#">Viverra</a> <span class="smalltext">(0 Disscussions)</span></li
				><li><a href="#">Zip</a> <span class="smalltext">(17 Disscussions)</span></li
				></ul>
			</div>
			<div class="clear">
			</div>
		</div>
		<div id="object_question" class="smalltext">
			Does this list of concern themes adequately reflect concerns expressed by participants? <img src="images/btn_yes_s.gif" alt="YES"> <img src="images/btn_no_s.gif" alt="NO">
		</div>
		</div>
		<div id="toggle"><a href="javascript:moreObject();"><img src="images/slideDown.gif" alt="More Discussion Space!" width="82" height="9" border="0"></a></div>
		<div id="header_discussion" class="allBlue">
			<div class="sidepadding">
			  <div id="disc_title"><h5 id="targetDiscussionTitle"></h5></div>
			  <div id="btnNewDiscussion"><a href="javascript:new Effect.toggle('newDiscussion', 'blind', {duration: 0.5}); void(0); "><img src="images/btn_newdiscussion.gif" border="0" alt="New Discussion"></a>&nbsp;</div>
			  <br />
			  <span class="smalltext">Feel like a theme is missing from the above list? Have a question about the summary process? Discuss here.</span>
		  	</div>
			<div id="newDiscussion" class="greenBB" style="display: none;">
				<div id="header_newDiscussion" class="allGreen">New Discussion<span id="closeNewDiscussion" class="closeBox"><a href="javascript:new Effect.toggle('newDiscussion', 'blind', {duration: 0.5}); void(0);">Close</a></span></div>
				<p><strong>SDC New Discussion Title</strong><p>SDC New Discussion Paragraph</p></p>
				<form>
					<p><label>Post Title</label><br><input style="width:90%" type="text" id="txtNewPostTitle"/></p>
					<p><label>Your Thoughts</label><br><textarea style="width:90%" id="txtNewPost"></textarea></p>
					<p><label>Tag your post (comma separated)</label><br><input style="width:90%" id="txtNewPostTags" type="text" /></p>
					<input type="button" onclick="infoStructure.createPost();" value="Create Discussion">
				</form>
			</div>

		</div>
		<div id="header_cat">
			<div class="sidepadding">
			<div class="header_cat_title" ><a href="#">Title</a></div><div class="header_cat_replies"><a href="#">Replies</a></div><div class="header_cat_author"><a href="#">Author</a></div><div class="header_cat_lastpost"><a href="#">Last Post</a></div>
			<div class="clear">
			</div>
			</div>
		</div>
		<div id="discussion" class="blueBB">

			

		</div>
		<br />
		<div id="finished">Finished? (We need some style for this)</div>
	  </div>
	  
	  
	</div>
	
	<div id="col-right">
	
		<!--START SIDEBAR -->
<div id="bar">
<a id="SideConcernsTop" name="SideConcernsTop"></a>
	<div class="tabber" id="myTab">
	<!--START Tag Selector -->
	<div id="tagSelector">
		Tag Selected: <b>Safety</b> [ <a href="javascript:goPage(${setting.page});">Clear Selected</a> ]
		<div id="pullDown" style="text-align:right;"><a href="javascript: expandTagSelector();">Pull My Finger</a></div>
		<div id="allTags" style="display: none;">
			<h1>All Currently Available Tags</h1>
				<p>Tag Selector</p>
		</div>
	</div>
		
<!--END Tag Selector -->

			<div id="sidebar_currentTaskContainer" class="tabbertab">
	    	<h2>Concerns</h2>
				<div id="sidebar_concerns"><h4 id="targetSideBarTitle">Concerns</h4>
					 Quisque lobortis placerat felis. Vivamus nisi orci, suscipit sed, semper non, nonummy quis, ligula. Etiam condimentum mauris vitae nisl. Curabitur sem. Quisque eget velit quis dolor convallis tempor. Nulla facilisis hendrerit orci. Nam laoreet enim a erat. Nullam hendrerit ligula eu eros. Suspendisse viverra magna id dui. Nulla dictum ornare velit. Duis a sem. Etiam pulvinar. Nunc at purus at diam eleifend vulputate. Maecenas ullamcorper velit ut leo. Aliquam erat volutpat. Integer leo elit, vehicula at, tempor et, ornare a, augue. Phasellus sagittis. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aenean aliquet faucibus tellus. Donec ipsum. Nullam scelerisque. Etiam lacus. Fusce enim risus, vulputate sed, egestas et, euismod vel, augue. Vestibulum eget turpis. Integer nonummy magna a massa. Sed consectetuer pharetra augue. Praesent dolor. Curabitur ullamcorper.				</div>
	    </div>
			
			<div id="sidebar_discussionContainer" class="tabbertab">
	    	<h2>Other Discussion</h2>
				<div id="sidebar_concerns"><h4>Other Discussion</h4>
					<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Morbi dictum velit eget nunc hendrerit volutpat. Aliquam egestas purus in eros. Quisque lobortis placerat felis. Vivamus nisi orci, suscipit sed, semper non, nonummy quis, ligula. Etiam condimentum mauris vitae nisl.. </p>
				</div>
	    </div>
	    
	    <div id="sidebar_resourcesContainer" class="tabbertab">
	    	<h2>Resources</h2>
				<div id="sidebar_discussion"><h4>Resources</h4>
					<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Morbi dictum velit eget nunc hendrerit volutpat. Aliquam egestas purus in eros. Quisque lobortis placerat felis. Vivamus nisi orci, suscipit sed, semper non, nonummy quis, ligula. Etiam condimentum mauris vitae nisl. Curabitur sem. Quisque eget velit quis dolor convallis tempor. Nulla facilisis hendrerit orci. Nam laoreet enim a erat. Nullam hendrerit ligula eu eros. Suspendisse viverra magna id dui. Nulla dictum ornare velit. Duis a sem. Etiam pulvinar. Nunc at purus at diam eleifend vulputate. Maecenas ullamcorper velit ut leo. Aliquam erat volutpat. Integer leo elit, vehicula at, tempor et, ornare a, augue. Phasellus sagittis. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aenean aliquet faucibus tellus. Donec ipsum. Nullam scelerisque. Etiam lacus. Fusce enim risus, vulputate sed, egestas et, euismod vel, augue. Vestibulum eget turpis. Integer nonummy magna a massa. Sed consectetuer pharetra augue. Praesent dolor. Curabitur ullamcorper. </p>
				</div>
	    </div>
	</div>
</div>
<div id="caughtException"><h4>A Problem has Occured</h4><br>We are sorry but there was a problem accessing the server to complete your request.  <b>Please try refreshing the page.</b></div>
<!--END SIDEBAR -->
	</div>
<div id="clear">
</div>

	
</div>

</div>
<!-- Start Footer -->
<div id="footer_clouds">

	<div id="footer_text">
	<img src="images/footerlogo.png" alt="PGIST Logo" width="156" height="51" class="imgright"/><br />This research is funded by National Science Foundation, Division of Experimental and Integrative Activities, Information Technology Research (ITR) Program, Project Number EIA 0325916, funds managed within the Digital Government Program.    </div>

</div>
<!-- End Footer -->
<!-- Run javascript function after most of the page is loaded, work around for onLoad functions quirks with tabs.js -->
<script type="text/javascript">
	var infoStructure = new InfoStructure(); 
	var discussion = new Discussion();
	infoStructure.getTargets();
	infoStructure.getPosts();
	dosize();
	moreObject();

</script>

</body>

</html:html>

