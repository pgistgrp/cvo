<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Step 1 - Let's Improve Transportation</title>

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
<script type='text/javascript' src='/dwr/interface/CCTAgent.js'></script>
<!-- End DWR JavaScript Libraries -->


<script type="text/javascript">
  var cctId = ${cctForm.cct.id};
  var concernTags = "";
  window.onload(doOnLoad());
  

	function doOnLoad(){
		showConcerns(2);
		showMyConcerns();
		//showTagCloud();
	}
	function validateForm()
	{
		if(""==document.forms.brainstorm.addConcern.value)
		{
			document.getElementById('validation').innerHTML = 'Please fill in your concern above.';
			new Effect.BlindDown('validation');
			new Effect.BlindUp('tagConcerns');
			new Effect.Highlight('validation', {duration: 4, endcolor:'#EEF3D8'});
			new Effect.Highlight('theTag', {duration: 10, endcolor:'#EEF3D8'});
			return false;
			
		}else{
			new Effect.BlindUp('validation');
			new Effect.BlindDown('tagConcerns');
			new Effect.Highlight('tags', {duration: 4, endcolor:'#FFFFFF'});
			//$('theTag').value = "add tag";
			//$('theTag').focus();
			return true;
		}
	}
	
	function resetForm()
	{
		$('addConcern').value = '';
		$('btnContinue').disabled=false;
		Effect.BlindUp('tagConcerns');
		Effect.BlindUp('validation');
		$('addConcern').style.background="#FFF";
		$('addConcern').style.color="#333";
	}
	
	function prepareConcern(){
		concernTags = "";
		potentialTags = "";
		tagHolderId = 0;
		if (validateForm()){
			$('btnContinue').disabled=true;
			$('addConcern').style.background="#EEE";
			$('addConcern').style.color="#CCC";
			var concern = $('addConcern').value;
			$('indicator').style.visibility = "visible";
			
			CCTAgent.prepareConcern({cctId:cctId,concern:concern}, function(data) {
				if (data.successful){
					for(i=0; i < data.tags.length; i++){
						concernTags += data.tags[i] + ',';
					}
					for(i=0; i < data.potentialtags.length; i++){
          	potentialTags += data.potentialtags[i] + ',';
					}
					document.getElementById('tagsList').innerHTML = renderTags( concernTags, 1);  // + renderTags( data.suggested, 0);
					document.getElementById('tagsList').innerHTML += renderTags(potentialTags, 1);
					concernTags += potentialTags;
				}
				document.getElementById("indicator").style.visibility = "hidden";
			} );
		}
	}
	
	var tagHolderId = 1;
	function removeFromGeneratedTags(name){
		if(name == "")return;
		var indexNum = concernTags.indexOf(name +',');
		if (indexNum > 0){
			firstpart = concernTags.substring(0, indexNum);
			secondpart = concernTags.substring(indexNum + name.length + 1, concernTags.length);
			concernTags = firstpart + secondpart;
		}else if (indexNum == 0){
			concernTags = concernTags.substring(indexNum + name.length +1, concernTags.length);
		}

		if (tagHolderId == 0){
			document.getElementById('tagsList').innerHTML = renderTags( concernTags, 1);
		}else{
			document.getElementById('editTagsList').innerHTML = renderTags( concernTags, 1);
		}
	}
	
	function renderTags(tags,type){
		sty = (type == 1)?"tagsList":"suggestedTagsList";
		var str= "";
		tagtemp = tags.split(",");
		
		for(i=0; i < tagtemp.length; i++){
			if(tagtemp [i] != ""){
				str += '<li class="' + sty + '">'+ tagtemp [i] +'</span><span class="tagsList_controls">&nbsp;<a href="javascript:removeFromGeneratedTags(\''+ tagtemp [i] +'\');"><img src="/images/trash.gif" alt="Delete this Tag!" border="0"></a></span></li>';	
			}
		}	
		return str;
	}
	
	var editingTags = new Array();
	function removeFromList(tagId){
		if (tagHolderId == 1){
			d = document.getElementById('editTagsList'); 
		}else{
			d = document.getElementById('tagsList'); 
		}
		d_nested = document.getElementById(tagId); 
		
		if (editingTags[tagId] != null){
			var indexNum = concernTags.indexOf(editingTags[tagId]+',');
			if (indexNum > 0){
				firstpart = concernTags.substring(0, indexNum);
				secondpart = concernTags.substring(indexNum + editingTags[tagId].length + 1, concernTags.length);
				concernTags = firstpart + secondpart;
			}else if (indexNum == 0){
				concernTags = concernTags.substring(indexNum + editingTags[tagId].length +1, concernTags.length);
			}
		}
		
		throwaway_node = d.removeChild(d_nested);

	}
	
	var uniqueTagCounter = 0;
	function addTagToList(theListId,theTagTextboxId,validationId){
		
		if(""==$(theTagTextboxId).value)
		{
			$(validationId).innerHTML = 'Please add your tag above.  Tag can not be blank.';
			new Effect.BlindDown(validationId);
			new Effect.Highlight(validationId, {duration: 20, endcolor:'#FFFFFF'});			
		}else{
			new Effect.BlindUp(validationId);
			uniqueTagCounter++;
			newTagId = 'userTag' + uniqueTagCounter;
			editingTags[newTagId] = document.getElementById(theTagTextboxId).value;
			document.getElementById(theListId).innerHTML += '<li id="'+ newTagId +'" class="tagsList">'+ document.getElementById(theTagTextboxId).value +'</span><span class="tagsList_controls">&nbsp;<a href="javascript:removeFromList(\''+ newTagId +'\');"><img src="/images/trash.gif" alt="Delete this Tag!" border="0"></a></span></li>';
			concernTags += document.getElementById(theTagTextboxId).value + ',';
			new Effect.Highlight(theTagTextboxId, {duration: 4, endcolor:'#FFFFFF'});
			$(theTagTextboxId).value = "";
		}
	}
	
function saveTheConcern(){
		
		var concern = $('addConcern').value;
		//concernTags = '\"' + concernTags +'\"';
		$('indicator').style.visibility = "visible";
		alert('cctId:' + cctId + ', concern: ' + concern + ', tags: ' + concernTags);
		CCTAgent.saveConcern({cctId:cctId,concern:concern,tags:concernTags}, {
			callback:function(data){
				if (data.successful){
					//alert(concernTags);
					new Effect.BlindUp('tagConcerns');
					$('btnContinue').disabled=false;
					$('addConcern').value = "";
					$('addConcern').style.background="#FFF";
					$('addConcern').style.color="#333";
					$('addConcern').focus();
					//showTagCloud();
					//alert(concernTags);
					showMyConcerns(data.concern.id);
					concernTags = '';
					$('theTag').value = '';
					
				}
			},
			errorHandler:function(errorString, exception){ 
				alert(data.reason);
			}
	});
	$("indicator").style.visibility = "hidden";
}

function showTagCloud(){
		CCTAgent.getTagCloud({cctId:cctId,type:0,count:25}, {
			callback:function(data){
				if (data.successful){
					$('sidebar_tags').innerHTML = data.html;
					//<p><textarea class="textareaAddConcern" name="addConcern" cols="50" rows="2" id="addConcern"></textarea></p>
				}
			},
			errorHandler:function(errorString, exception){ 
				showTheError();
			}
			//$("indicator").style.visibility = "hidden";
	});
}

function getRandomConcerns(){
	//$("sidebar_concerns").style.display = "none";
	//Effect.FadeIn('sidebar_concerns');
	new Effect.Highlight('sidebar_concerns');
	showConcerns(2);
}

function showConcerns(theType){
	CCTAgent.getConcerns({cctId:cctId,type:theType,count:7}, {
		callback:function(data){
			if (data.successful){
				$('sidebar_concerns').innerHTML = data.html;
			}
		},
		errorHandler:function(errorString, exception){ 
				showTheError();
		}
	});
}

function showMyConcerns(id){
	CCTAgent.getConcerns({cctId:cctId,type:0,count:-1}, {
			callback:function(data){
					if (data.successful){
						$('myConcernsList').innerHTML = data.html;
						if (id != undefined){
							new Effect.Highlight('concernId' + id, {duration: 4, endcolor:'#EEF3D8', afterFinish: function(){showMyConcerns();}})
						}
						if (data.total == 0){
							document.getElementById("myConcernsList").innerHTML = '<p><small>None created yet.  Please add a concern above.  Please refer to other participant\'s concerns on the right column for examples.</small></p>';
						}
					}
			},
			errorHandler:function(errorString, exception){ 
					showTheError();
			}
		});
	}

function getConcernsByTag(id){
		CCTAgent.getConcernsByTag({tagRefId:id,count:-1}, {
		callback:function(data){
				if (data.successful){
					new Effect.Highlight('sidebar_concerns');
					$('sidebar_concerns').innerHTML = data.html;
					$('myTab').tabber.tabShow(0);
					new Element.scrollTo('SideConcernsTop'); //location.href='#SideConcernsTop';
				}
			},
		errorHandler:function(errorString, exception){ 
				showTheError();
		}
		});
}

function goPage(pageNum){
	CCTAgent.getConcerns({cctId:cctId,type:2,count:7, page:pageNum}, {
		callback:function(data){
				if (data.successful){
					$('sidebar_concerns').innerHTML = data.html;
					new Effect.Highlight('sidebar_concerns', {duration: 0.5});
				}
			},
		errorHandler:function(errorString, exception){ 
				showTheError();
		}
		});
}

function tabFocus(num){
	$('myTab').tabber.tabShow(num);
}

function tagSearch(theTag){
CCTAgent.searchTags({cctId:cctId,tag:theTag},{
		callback:function(data){
			  $('tagIndicator').style.visibility = 'visible';
				if (data.successful){
					if ($('txtSearch').value == ""){
						$('searchTag_title').innerHTML = '<span class="title_section2">Tag Query:</span>'; 
						$('topTags').innerHTML = "";
						$('tagSearchResults').innerHTML = '<span class="highlight">Please type in your query or <a href="javascript:showTagCloud();">clear query</a>&nbsp;to view top tags again.</span>';
					  $('tagIndicator').style.visibility = 'hidden';
					  
					}
					
					if ($('txtSearch').value != ""){
						$('searchTag_title').innerHTML = '<span class="title_section2">Tag Query:</span>'; 
						$('tagSearchResults').innerHTML = '<span class="highlight">' + data.count +' tags match your query&nbsp;&nbsp;(<a href="javascript:showTagCloud();">clear query</a>)</span>';
						$('topTags').innerHTML = data.html;
						$('tagIndicator').style.visibility = 'hidden';
					}
					
					if (data.count == 0 || $('txtSearch').value == "_"){
						$('tagSearchResults').innerHTML = '<span class=\"highlight\">No tag matches found! Please try a different search or <a href="javascript:showTagCloud();">clear the query</a>&nbsp;to view top tags again.</span>';
						$('topTags').innerHTML = "";
						$('tagIndicator').style.visibility = 'hidden';
					}
				}
		},
		errorHandler:function(errorString, exception){ 
					showTheError();
		}		
	});
}


function lightboxDisplay(action){
	$('overlay').style.display = action;
	$('lightbox').style.display = action;
}

function glossaryPopup(term){
	lightboxDisplay('inline');
	os = "";
	os += '<span class="closeBox"><a href="javascript: lightboxDisplay(\'none\');"><img src="/images/closelabel.gif" border="0"></a></span>'
	os += '<br><h4>Glossary Term: '+ term +'</h4>';
	os += '<p>Tags helps make your concerns easier to find, since all this info is searchable later. Imagine this applied to thousands of concerns!</p>';
	$('lightbox').innerHTML = os;
}
function editConcernPopup(concernId){
  var currentConcern = '';
	lightboxDisplay('inline');
	CCTAgent.getConcernById(concernId, {
		callback:function(data){
			if (data.successful){
					currentConcern = data.concern.content;
					os = "";
					os += '<span class="closeBox"><a href="javascript: lightboxDisplay(\'none\');"><img src="/images/closelabel.gif" border="0"></a></span>'
					os += '<h4>Edit My Concern</h4><br>';
					os += '<form><textarea style="height: 150px; width: 100%;" name="editConcern" id="editConcern" cols="50" rows="5" id="addConcern">' +currentConcern+ '</textarea></p></form>';
					os += '<input type="button" id="modifyConcern" value="Submit Edits!" onClick="editConcern('+concernId+')">';
					os += '<input type="button" value="Cancel" onClick="lightboxDisplay(\'none\')">';
					$('lightbox').innerHTML = os;
			}
		},
		errorHandler:function(errorString, exception){ 
				showTheError();
		}
	
	});

}
	
function editConcern(concernId){
	newConcern = $('editConcern').value;
	CCTAgent.editConcern({concernId:concernId, concern:newConcern}, {
		callback:function(data){
				if (data.successful){
					lightboxDisplay('none');
					showMyConcerns(concernId);
				}
		},
		errorHandler:function(errorString, exception){ 
				showTheError();
		}
	});
}

function editTagsPopup(concernId){
		tagHolderId = 1;
		concernTags = "";
		
		CCTAgent.getConcernById(concernId, {
		callback:function(data) {
				if (data.successful){
					
							lightboxDisplay('inline');
							os = "";
							os += '<span class="closeBox"><a href="javascript: lightboxDisplay(\'none\');"><img src="/images/closelabel.gif" border="0"></a></span>'
							os += '<h4>Edit My Concern\'s Tags</h4><p></p>';
							os += '<ul id="editTagsList" class="tagsList"> '+data.id+ '</ul>';
							os += '<p></p><form name="editTagList" action="" onsubmit="addTagToList(\'editTagsList\',\'theNewTag\',\'editTagValidation\'); return false;"><input type="text" id="theNewTag" class="tagTextbox" name="theNewTag" size="15"><input type="button" name="addTag" id="addTag" value="Add Tag!" onClick="addTagToList(\'editTagsList\',\'theNewTag\',\'editTagValidation\');"></p>';
							//os += '<a href="javascript:editTags('+concernId+');">TestIt</a>';
							os += '<div style="display: none;" id="editTagValidation"></div>';
							os += '<hr><input type="button" value="Submit Edits" onClick="editTags('+concernId+')">';
							os += '<input type="button" value="Cancel" onClick="lightboxDisplay(\'none\')"></form>';
								$('lightbox').innerHTML = os;
								var str= "";
								for(i=0; i < data.concern.tags.length; i++){
									str += '<li id="tag'+data.concern.tags[i].tag.id+'" class="tagsList">'+ data.concern.tags[i].tag.name +'&nbsp;<a href="javascript:removeFromGeneratedTags(\'' + data.concern.tags[i].tag.name + '\');"><img src="/images/trash.gif" alt="Delete this Tag!" border="0"></a></li>';
									concernTags += data.concern.tags[i].tag.name + ',';
								}
								document.getElementById('editTagsList').innerHTML = str;
				}
		},
		errorHandler:function(errorString, exception){ 
				showTheError();
		}
	});

}

function removeLastComma(str){
	str = str.replace(/[\,]$/,'');
	concernTags = str;
}

function editTags(concernId){
	removeLastComma(concernTags);
	CCTAgent.editTags({concernId:concernId, tags:concernTags}, {
		callback:function(data){
			if (data.successful){ 
				lightboxDisplay('none');
				showMyConcerns(concernId);
				concernTags = "";
			}
			
			if (data.successful != true){
				alert(data.reason);
				concernTags = "";
			}
		},
		errorHandler:function(errorString, exception){ 
				showTheError();
		}
	});
}

function delConcern(concernId){
	var destroy = confirm ("Are you sure you want to delete this concern? Note: there is no undo.")
	if (destroy){
			CCTAgent.deleteConcern({concernId:concernId}, {
			callback:function(data){	
					if (data.successful){
						showMyConcerns();
					}
			},
			errorHandler:function(errorString, exception){ 
				showTheError();
			}
			});
	}
}

function ifEnter(field,event) {
	var theCode = event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;
	if (theCode == 13){
	prepareConcern();
	$('theTag').focus();
	return false;
	} 
	else
	return true;
}   

function showFinished(){
	location.href = '#finished';
	new Effect.Highlight('suppSlate', {duration: 4, endcolor:'#EEF3D8'});
}

function showTheError(errorString, exception){
				$('container').style.display = 'none';
				$('caughtException').style.display = 'block';
				$('caughtException').innerHTML +='<p>If this problem persists, please <A HREF="mailto:webmaster@pgist.org?subject=LIT Website Problem>contact our webmaster</a></p>';
}

var winH;
function getWinH(){
	if (parseInt(navigator.appVersion)>3) {
	 if (navigator.appName=="Netscape") {
	  winH = window.innerHeight;
	 }
	 if (navigator.appName.indexOf("Microsoft")!=-1) {
	  winH = document.body.offsetHeight;
	 }
	}
	
	alert(winH);
	$('slate').style.Height = winH;
}
</script>
</Head>
<body>
<!-- HEADER -->
<div id="decorBar"></div>
<div id="container">
	<!-- START LIGHTBOX -->
	<div id="overlay"></div>
	<div id="lightbox" class="blueBB"></div>
	<!-- END LIGHTBOX -->
	<!--START Title Header -->
	
	<div id="headerbar">
	<!-- Search -->
	  <form id="mysearch" name="form1" method="post" action="">
	    
	<div id="searchbox">
		<input name="search" type="text" class="search" value="Search" />
	</div>
	<div id="submit">
	        <img src="images/btn_search_1.png" name="Image1" width="19" height="19" border="0" id="Image1" onClick="sendForm();return false;" onMouseDown="MM_swapImage('Image1','','images/btn_search_3.png',1)" onMouseOver="MM_swapImage('Image1','','images/btn_search_2.png',1)" onMouseOut="MM_swapImgRestore()">    
	</div>
	<div id="searchresults"></div>
	  </form>
	<!-- End Search -->
	<a id="TitleHeader" name="TitleHeader"></a>
	
		<div class="header" id="myHeader">
			<div id="header_currentMenuContainer" class="headertab">
		    	<h2>Tab 1</h2>
					<div id="header_submenu1" class="submenulinks">
						<a href="#">Sub Navigation 1a</a> <a href="#">Sub Navigation 2a</a> <a href="#">Sub Navigation 3a</a> <a href="#">Sub Navigation 4a</a>
					</div>
		    </div>			
				<div id="sidebar_tab2" class="headertab">
		    	<h2>Tab 2</h2>
					<div id="header_submenu2" class="submenulinks">
						<a href="#">Sub Navigation 1b</a> <a href="#">Sub Navigation 2b</a> <a href="#">Sub Navigation 3b</a> <a href="#">Sub Navigation 4b</a> 
					</div>
		    </div>	    
		    <div id="sidebar_tab3" class="headertab">
		    	<h2>Tab 3</h2>
					<div id="header_submenu3" class="submenulinks">
						<a href="#">Sub Navigation 1c</a> <a href="#">Sub Navigation 2c</a> <a href="#">Sub Navigation 3c</a> <a href="#">Sub Navigation 4c</a> 
					</div>
		    </div>
		</div>
	</div>
	<!--END Title Header -->
	
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
	
	
	<div id="col-left">
		<div id="slate" class="blueBB">
	  		<h4>Add your concern</h4><br>What problems do you encounter in your daily trips to work outside the home, shopping, and errands? In what ways do you feel our current transportation system fails to meet the needs of our growing region? <p>Describe <strong>one</strong> problem with our transportation system. You can add more concerns later</p>
			    <form name="brainstorm" method="post" onSubmit="addTagToList('tagsList', 'theTag','tagValidation'); return false;">
				      <p><textarea class="addConcern" onkeypress="ifEnter(this,event);" name="addConcern" cols="20" rows="2" id="addConcern"></textarea></p>
				      <p class="indent">
					      <input type="button" id="btnContinue" name="Continue" value="Submit Concern" onclick="prepareConcern();">
					      <input type="reset" name="Reset" value="Reset" onClick="resetForm();"> 
					      <span id="indicator" style="visibility:hidden;"><img src="/images/indicator.gif"></span>
				      </p>
				      
				      <div style="display: none;" id="validation"></div>
				      
				      
					    <div id="tagConcerns" style="display: none;">
							    <div id="tags" style="background-color: #FFF; border: 5Px solid #BBBBBB; margin:auto; padding: 5px; width: 70%;">
							    	<h4>Tag Your Concern</h4>
							    	<p></p>   
										<p>Please delete those that do not apply to your concern and use the textbox below to add more tags (if needed).  <span class="glossary">[ what are <a href="javascript:glossaryPopup('tag');">tags</a>? ]</span></p>
										<b>Suggested Tags for your Concern:</b>  <ul class="tagsList" id="tagsList">
										</ul>	 
										<p><input type="text" id="theTag" class="tagTextbox" name="theTag" size="15"><input type="button" name="addTag" id="addTag" value="Add Tag!" onclick="addTagToList('tagsList','theTag','tagValidation');return false;"></p>
										<div style="display: none; padding-left: 20px;" id="tagValidation"></div>
									
										<span class="title_section">Finished Tagging? <br><a href="javascript:saveTheConcern();">DO IT</a><input type="button" name="saveConcern" value="Add Concern to List!" onclick="saveTheConcern(); void(0);"></span><input type="button" value="Cancel - back to edit my concern" onclick="javascript:resetForm();">
							    </div>
							    <br>
					    </div>
					
					<h4>Concerns you've contributed so far</h4><br>Finished? Click 'continue to next step' <a href="javascript:showFinished();">below</a>.<p></p>
				      <div id="myConcernsList" class="indent">
					      <ol id="myConcerns">
						  	</ol>
					  	</div>

			    </form>
		</div>
	
		<div id="suppSlate">
   		<a name="finished"></a><h4 id="h4Finished">Finished brainstorming concerns?</h4>
   		<p>The next step in the process is to discuss your concerns with other participants [...]</p>
			<input type="button" id="btnNextStep" value="Continue to Next Step">
		</div>
	</div>
	
	<div id="col-right">
		<!--START Tabs -->
	<div id="bar">
	<a id="SideConcernsTop" name="SideConcernsTop"></a>
		<div class="tabber" id="myTab">
		<!--START Tag Selector -->
		<div id="tagSelector">
			Tag Selected: <b>Safety</b> [ <a href="javascript:goPage(${setting.page});">Clear Selected</a> ]
			<div id="pullDown" style="text-align:right;"><a href="javascript: expandTagSelector();">Browse All Tags</a></div>
			<div id="allTags" style="display: none;">
				<h1>All Currently Available Tags</h1>
		
			</div>
		</div>
			
	<!--END Tag Selector -->
	
				<div id="sidebar_currentTaskContainer" class="tabbertab">
		    	<h2>Concerns</h2>
					<div id="sidebar_concerns"><h4>Concerns</h4>
						<p> Quisque lobortis placerat felis. Vivamus nisi orci, suscipit sed, semper non, nonummy quis, ligula. Etiam condimentum mauris vitae nisl. Curabitur sem. Quisque eget velit quis dolor convallis tempor. Nulla facilisis hendrerit orci. Nam laoreet enim a erat. Nullam hendrerit ligula eu eros. Suspendisse viverra magna id dui. Nulla dictum ornare velit. Duis a sem. Etiam pulvinar. Nunc at purus at diam eleifend vulputate. Maecenas ullamcorper velit ut leo. Aliquam erat volutpat. Integer leo elit, vehicula at, tempor et, ornare a, augue. Phasellus sagittis. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aenean aliquet faucibus tellus. Donec ipsum. Nullam scelerisque. Etiam lacus. Fusce enim risus, vulputate sed, egestas et, euismod vel, augue. Vestibulum eget turpis. Integer nonummy magna a massa. Sed consectetuer pharetra augue. Praesent dolor. Curabitur ullamcorper. </p>
					</div>
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
	<!--END Tabs -->
	</div>
	
	<div id="clear">
	</div>

</div>

<!-- Start Footer -->
<div id="footer_clouds">

	<div id="footer_text">
	<img src="/images/footerlogo.png" alt="PGIST Logo" width="156" height="51" class="imgright"/><br />This research is funded by National Science Foundation, Division of Experimental and Integrative Activities, Information Technology Research (ITR) Program, Project Number EIA 0325916, funds managed within the Digital Government Program.    </div>

</div>
<!-- End Footer -->
<!-- Run javascript function after most of the page is loaded, work around for onLoad functions quirks with tabs.js -->
<script type="text/javascript">
	findxy();
</script>
</body>
</html>
