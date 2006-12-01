<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.pgist.org/pgtaglib" prefix="pg" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<html:html>
<head>
<title style="text-transform:capitalize;">Step 1b: ${post.title}</title>
<!-- Site Wide CSS -->
<style type="text/css" media="screen">@import "styles/lit.css";</style>

<style type="text/css">
#discussionHeader{width:100%}
.sectionTitle{width:100%}
</style>
<!-- Temporary Borders used for testing <style type="text/css" media="screen">@import "styles/tempborders.css";</style>-->
<!-- End Site Wide CSS -->

<script language="javascript" type="text/javascript" src="scripts/tinymce/jscripts/tiny_mce/tiny_mce.js"></script>
<script language="JavaScript" src="scripts/qtip.js" type="text/JavaScript"></script>

<!-- Site Wide JavaScript -->
<script src="scripts/tags.js" type="text/javascript"></script>
<script src="scripts/prototype.js" type="text/javascript"></script>
<script src="scripts/scriptaculous.js?load=effects,dragdrop" type="text/javascript"></script>
<script src="scripts/globalSnippits.js" type="text/javascript"></script>
<!-- End Site Wide JavaScript -->

<!-- DWR JavaScript Libraries -->
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<!-- End DWR JavaScript Libraries -->

<!--SDX Specific  Libraries-->
<script type='text/javascript' src='/dwr/interface/SDAgent.js'></script>
<script type='text/javascript' src='/dwr/interface/CCTAgent.js'></script>
<!--End SDX Specific  Libraries-->


<script type="text/javascript">
	
	tinyMCE.init({
	mode : "exact",
	theme : "advanced",
	theme_advanced_buttons1 : "bold, italic, bullist, numlist,undo, redo,link",
	theme_advanced_buttons2 : "",
	theme_advanced_buttons3 : "",
	content_css : "/scripts/tinymce/jscripts/tiny_mce/themes/simple/css/bigmce.css",
	extended_valid_elements : "blockquote[style='']"
});

	
			///////////////////////////////////////// START INFO OBJECT //////////////////////////////////////

		var io = new Object;
		//Global Var Settings
		io.structureId = "${structure.id}";
		io.objectId = "${object.id}";
		io.postId = "${post.id}";
		io.currentFilter = '';
		io.currentPage = 1;

		io.replyCount = 15; //per page
		io.contextPostCount = 3;

		
		/*----Input ID's - these id's of input elements have changing content or gets read by the javascript ---- */
	 	 io.newReplyTagsInput = "txtNewReplyTags"; //new post tags input box
	 	 io.newReplyTitleInput = "txtNewReplyTitle";
		 io.newReplyNotifier = "newReplyNotifier";
	 	 
	 	 /*----Divs - these divs have changing content or gets read by the javascript ---- */
	 	 io.objectDiv =  'object-content'; //div that contains the object
	 	 io.discussionDiv = 'container-include'; //div that contains the discussion
	 	 io.divFilteredBy = 'filteredBy';
	 	 io.votingQuestionDiv = 'structure_question' //div that contains the voting question
	 	 io.filterAnchor = '#filterJump';
		
		/*************** Get Targets - If IOID is ommitted, return sdcSummary.jsp::else, returns sdcStructureSummary.jsp************** */
		io.getTargets = function(){
			displayIndicator(true);
			SDAgent.getSummary({isid: io.structureId, ioid: io.objectId  }, {
				callback:function(data){
					if (data.successful){
							displayIndicator(false);
							$(io.objectDiv).innerHTML = data.source.html;
						}else{
							displayIndicator(false);
							alert(data.reason);
						}
					},
					errorHandler:function(errorString, exception){
						alert("get targets error:" + errorString + exception);
					}
				});
			};
			
		io.changeCurrentFilter = function(tagName){
			io.getReplies(tagName, io.currentPage, true);
			if(tagName != ""){
				$(io.divFilteredBy).innerHTML = '<h3 class="contrast1">Filtered By: ' + tagName + ' <a href="javascript: io.changeCurrentFilter(\'\');"><img src="images/close.gif" alt="clear filter" /></a>';
			}else{
				$(io.divFilteredBy).innerHTML = "";
			}
		}	
			
		io.getReplies = function(tag, page, jump){
			displayIndicator(true);
				if(jump){
					location.href = io.filterAnchor;
				}
				io.currentFilter = tag;
			   io.currentPage = page;
			  //alert("isid: " + io.structureId + " ioid: " + io.objectId + " postID: " + io.postId + " page " + io.currentPage + " count: " + io.replyCount + " filter: " + io.currentFilter);
		      SDAgent.getReplies({isid: io.structureId, ioid:io.objectId, postid: io.postId, page: io.currentPage, count: io.replyCount, filter: io.currentFilter}, {
		      callback:function(data){
		          if (data.successful){
		          			$(io.discussionDiv).innerHTML = data.html;         
		          			displayIndicator(false);
		          }else{
		            alert("get replies error " + data.reason);
		            displayIndicator(false);
		          }
		      },
			  async:false,
		      errorHandler:function(errorString, exception){
		          alert("getReplies Error" + errorString + exception);
		      }
		    });
			tinyMCE.idCounter=0;
			tinyMCE.execCommand('mceAddControl',false,'txtnewReply');
		  }
		  
		  	function goToPage(type,page){
		  		if(type=='replies'){
					io.getReplies(io.currentFilter,page,true); 
				}else{
					io.getContextPosts(page);	
				}
				//new Effect.Highlight('discussion-cont',{startcolor: "#D6E7EF"});
			}
			
			
		/*
		function removeDoubleQuotes(str){
		charToRemove = '"';
		regExp = new RegExp("["+charToRemove+"]","g");
		return str.replace(regExp,"");
		
		}*/

		io.createReply = function(){
			displayIndicator(true);
			var title = $(io.newReplyTitleInput).value;
			var newReply = tinyMCE.getContent();
			var tags = $(io.newReplyTagsInput).value;
		    var notify = $(io.newReplyNotifier).checked;
			var emailNotify = notify.toString();
			SDAgent.createReply({isid:${structure.id}, pid:${post.id}, title:title, content:newReply, tags: tags, emailNotify: emailNotify}, {
		      callback:function(data){
		          if (data.successful){     
		          		displayIndicator(false);
						resetNewReplyForm();
						//io.setVote('reply', data.id, 'true');	
						io.getReplies(io.currentFilter, io.currentPage, true);	
						location.href="#replyAnchor" + data.id;
						if(($('discussionText'+data.id)==undefined)){
						
						//goToPage('replies',9);
						//9 = page.setting.lastPage
						
						}
						//alert($("discussionText"+data.id).name);
						
						window.setTimeout('new Effect.Highlight("discussionText'+ data.id +'", {duration: 4.0});',500);
		          }else{
		          	 displayIndicator(false);
		            alert(data.reason);
		          }
		      },
		      errorHandler:function(errorString, exception){
		          alert("createReply Error" + errorString + exception);
		      }
		    });
		  }
		  
		  	io.deleteReply =  function(rid){
		  	displayIndicator(true);
			var destroy = confirm ("Are you sure you want to delete this reply? Note: there is no undo.")
			if (destroy){
					SDAgent.deleteReply({rid:rid}, {
						callback:function(data){
								if (data.successful){
								   		 new Effect.Puff('reply' + rid, {afterFinish: function(){io.getReplies();}});
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
		};	
		
		io.setQuote = function(replyId){
			var currentReply = tinyMCE.getContent();
			var currentReplyContent = $('replyContent'+replyId).innerHTML;
			var currentReplyOwner = $('replyOwner'+replyId).innerHTML;
			tinyMCE.setContent(currentReply + '<blockquote style="color:#3B4429;background: #EEF7DD;border: 2px solid #B4D579;margin-left: 10px;padding:0px 5px 5px 5px;line-height: 10px;">' + currentReplyContent + currentReplyOwner +'</blockquote><p>');
			location.href="#replyAnchor";
			new Effect.Highlight('newReply');
		};
		
		io.getContextPosts =  function(page){
					displayIndicator(true);
					//alert("structureID: " + io.structureId + " pid: " + io.postId + " page: "+ page + " count: "+ io.contextPostCount);
					SDAgent.getContextPosts({isid:io.structureId, pid: io.postId, page: page, count: io.contextPostCount}, {
						callback:function(data){
								if (data.successful){
								   		 $('contextPosts').innerHTML = data.source.html;			
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
		};	
		
		function resetNewReplyForm(){
			$(io.newReplyTitleInput).value = '';
			tinyMCE.setContent('');
			$(io.newReplyTagsInput).value = '';	
		}
		
	
		/*************** Set Vote************** */
	 	 io.setVote = function(target, id, agree){
					//alert("target: " + target + " id: " + id + " agree: " + agree);
					SDAgent.setVoting({target: target, id: id, agree:agree}, {
					callback:function(data){
							if (data.successful){
								var votingDiv = 'voting-'+target+id;
								if($(votingDiv) != undefined){
	              				 	new Effect.Fade(votingDiv, {afterFinish: function(){io.getReplies(io.currentFilter, io.currentPage, false); io.getTargets(); new Effect.Appear(votingDiv);}});
	              				}else{
	              					io.getReplies(io.currentFilter, io.currentPage, false);	
									io.getTargets();
	              				}
							}else{
								alert(data.reason);
							}
						},
					errorHandler:function(errorString, exception){ 
							alert("setVote error:" + errorString + exception);
					}
					});
		};

		/*************** Set Email Notificaiton************** */
	 	 io.setupEmailNotify = function(id, type, status){
					//alert("id" + id + "type " + type + "turnon " + status);
					SDAgent.setupEmailNotify({id: id, type: type, turnon: status}, {
					callback:function(data){
							if (data.successful){
								if (status){
									alert("Email notification has been turned on!")
								}else{
									alert("Email notification has been turned off!")
								}
							}else{
								alert(data.reason);
							}
						},
					errorHandler:function(errorString, exception){ 
							alert("setVote error:" + errorString + exception);
					}
					});
		};	
-->
</script>
</head>
<body> 
  <!-- Begin the header - loaded from a separate file -->
  <div id="header">
	<!-- Begin header -->
	<jsp:include page="/header.jsp" />
	<!-- End header -->
  </div>
  <!-- End header -->
	

<!-- Begin header menu - The wide ribbon underneath the logo -->
	<jsp:include page="sdcHeader.jsp" />
<!-- End header menu -->
<div style="display: none;" id="loading-indicator">Loading... <img src="/images/indicator_arrows.gif"></div>
<div id="container">

<!-- Begin Breadcrumbs -->
	<div id="breadCrumbs" class="floatLeft">
<a href="sd.do?isid=${structure.id}">Select a Theme</a> &rarr; <a style="text-transform:capitalize;" href="/sdRoom.do?isid=${structure.id}&ioid=${object.id}">${object.object}</a> &rarr; ${post.title}
	</div>
<!-- End Breadcrumbs -->

<!-- jump to other room selection menu -->
	<div class="floatRight">
	  Jump To:
	  <select name="selecttheme" id="selecttheme" onChange="javascript: location.href='sdRoom.do?isid=${structure.id}&ioid=' + this.value;">		  
	    <option value = "${object.id}">Select a Theme</option>
	    <option value = "">Discussion of All Themes</option>
	   <c:forEach var="infoObject" items="${structure.infoObjects}">
	       <option value="${infoObject.id}">${infoObject.object}</option>
	    </c:forEach>	
	    </select>
	</div>
<!-- end jump to other room selection menu -->

  <script type="text/javascript">
				<c:choose>
				<c:when test="${object.id==null}">
				document.write("<h3 class=\"headerColor clearBoth\">Summarization of Participant Concerns</h3>");
				</c:when>
				<c:otherwise>
				document.write("<h3 class=\"headerColor clearBoth\">Summarization of Participant Concerns about ${object.object}</h3>");
				</c:otherwise>
				</c:choose>
			</script>
  <div id="object">

    <h5 id = "targetTitle"></h5>
    <div id="object-content">
      <!-- load object here -->
    </div>
    <!--end object content -->
  </div>
  <!-- end object -->
  <div class="clearBoth"></div><a name="filterJump"></a>
	<div id="container-include">
		<!-- load sdReplies.jsp via AJAX-->
	</div>
	
<div id="relatedDiscussion" style="margin-top: 20px;">
	<h3 class="headerColor">Related Posts in All Discussion Rooms</h3>
	<div id="contextPosts" class="box8 padding5">
		<!-- load context posts here -->
	</div>
</div>
<!-- start feedback form -->
<pg:feedback id="feedbackDiv" action="sdRoom.do" />
<!-- end feedback form --><!-- end container -->


</div>
<!-- start the bottom header menu -->

<!-- Begin header menu - The wide ribbon underneath the logo -->
	<jsp:include page="sdcHeader.jsp" />
<!-- End header menu -->

<!-- end the bottom header menu -->
	<!-- Begin footer -->
	<div id="footer">
		<jsp:include page="/footer.jsp" />
	</div>
	<!-- End footer -->
<script type="text/javascript">
	io.getReplies(io.currentFilter, 1, true);
	io.getTargets();
	io.getContextPosts(1);
	</script>

</html:html>


