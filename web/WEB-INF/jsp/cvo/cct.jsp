<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>PGIST Portal - Let's Improve Transportation</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<style type="text/css" media="screen">@import "/styles/tabs.css";</style>
<style type="text/css" media="screen">@import "/styles/pgist.css";</style>

<script type="text/javascript">

/* Optional: Temporarily hide the "tabber" class so it does not "flash"
   on the page as plain HTML. After tabber runs, the class is changed
   to "tabberlive" and it will appear. */

document.write('<style type="text/css">.tabber{display:none;}<\/style>');

/*==================================================
  Set the tabber options (must do this before including tabber.js)
  ==================================================*/
var tabberOptions = {

  'cookie':"tabber", /* Name to use for the cookie */

  'onLoad': function(argsObj)
  {
    var t = argsObj.tabber;
    var i;

    /* Optional: Add the id of the tabber to the cookie name to allow
       for multiple tabber interfaces on the site.  If you have
       multiple tabber interfaces (even on different pages) I suggest
       setting a unique id on each one, to avoid having the cookie set
       the wrong tab.
    */
    if (t.id) {
      t.cookie = t.id + t.cookie;
    }

    /* If a cookie was previously set, restore the active tab */
    i = parseInt(getCookie(t.cookie));
    if (isNaN(i)) { return; }
    t.tabShow(i);
    
  },

  'onClick':function(argsObj)
  {
    var c = argsObj.tabber.cookie;
    var i = argsObj.index;
    
    setCookie(c, i);
  }
};

/*==================================================
  Cookie functions
  ==================================================*/
function setCookie(name, value, expires, path, domain, secure) {
    document.cookie= name + "=" + escape(value) +
        ((expires) ? "; expires=" + expires.toGMTString() : "") +
        ((path) ? "; path=" + path : "") +
        ((domain) ? "; domain=" + domain : "") +
        ((secure) ? "; secure" : "");
}

function getCookie(name) {
    var dc = document.cookie;
    var prefix = name + "=";
    var begin = dc.indexOf("; " + prefix);
    if (begin == -1) {
        begin = dc.indexOf(prefix);
        if (begin != 0) return null;
    } else {
        begin += 2;
    }
    var end = document.cookie.indexOf(";", begin);
    if (end == -1) {
        end = dc.length;
    }
    return unescape(dc.substring(begin + prefix.length, end));
}
function deleteCookie(name, path, domain) {
    if (getCookie(name)) {
        document.cookie = name + "=" +
            ((path) ? "; path=" + path : "") +
            ((domain) ? "; domain=" + domain : "") +
            "; expires=Thu, 01-Jan-70 00:00:01 GMT";
    }
}

</script>

<script src="/scripts/tabs.js" type="text/javascript"></script>
<script src="/scripts/prototype.js" type="text/javascript"></script>
<script src="/scripts/effects.js" type="text/javascript"></script>
<script src="/scripts/combo.js" type="text/javascript"></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<script type='text/javascript' src='/dwr/interface/CCTAgent.js'></script>

<script type="text/javascript">
  var cctId = ${cctForm.cct.id};
  var concernTags = "";
  window.onload(doOnLoad());
  

	function doOnLoad(){
		showConcerns(2);
		showMyConcerns();
		showTagCloud();
	}
	function validateForm()
	{
		if(""==document.forms.brainstorm.addConcern.value)
		{
			document.getElementById('validation').innerHTML = 'Please fill in your concern above.';
			Effect.OpenUp('validation');
			Effect.CloseDown('tagConcerns');
			Effect.Yellow('validation', {duration: 4, endcolor:'#EEF3D8'});
			Effect.Yellow('theTag', {duration: 10, endcolor:'#EEF3D8'});
			return false;
			
		}else{
			Effect.CloseDown('validation');
			Effect.OpenUp('tagConcerns');
			Effect.Yellow('tags', {duration: 4, endcolor:'#FFFFFF'});
			//$('theTag').value = "add tag";
			//$('theTag').focus();
			return true;
		}
	}
	
	function resetForm()
	{
		$('btnContinue').disabled=false;
		Effect.CloseDown('tagConcerns');
		Effect.CloseDown('validation');
		$('addConcern').style.background="#FFF";
		$('addConcern').style.color="#333";
	}
	
	function prepareConcern(){
		concernTags = "";
		tagHolderId = 0;
		if (validateForm()){
			$('btnContinue').disabled=true;
			$('addConcern').style.background="#EEE";
			$('addConcern').style.color="#CCC";
			var concern = $('addConcern').value;
			document.getElementById("indicator").style.visibility = "visible";
			CCTAgent.prepareConcern({cctId:cctId,concern:concern}, function(data) {
				if (data.successful){
					for(i=0; i < data.tags.length; i++){
						concernTags += data.tags[i] + ',';
					}
					document.getElementById('tagsList').innerHTML = renderTags( concernTags, 1);  // + renderTags( data.suggested, 0);
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
			Effect.OpenUp(validationId);
			Effect.Yellow(validationId, {duration: 20, endcolor:'#FFFFFF'});			
		}else{
			Effect.CloseDown(validationId);
			uniqueTagCounter++;
			newTagId = 'userTag' + uniqueTagCounter;
			editingTags[newTagId] = document.getElementById(theTagTextboxId).value;
			document.getElementById(theListId).innerHTML += '<li id="'+ newTagId +'" class="tagsList">'+ document.getElementById(theTagTextboxId).value +'</span><span class="tagsList_controls">&nbsp;<a href="javascript:removeFromList(\''+ newTagId +'\');"><img src="/images/trash.gif" alt="Delete this Tag!" border="0"></a></span></li>';
			concernTags += document.getElementById(theTagTextboxId).value + ',';
			Effect.Yellow(theTagTextboxId, {duration: 4, endcolor:'#FFFFFF'});
			$(theTagTextboxId).value = "";
		}
	}
	
function saveTheConcern(){
		var concern = $('addConcern').value;
		$("indicator").style.visibility = "visible";
		//$('explaination').innerHTML = "";
		CCTAgent.saveConcern({cctId:cctId,concern:concern,tags:concernTags}, {
			callback:function(data){
				if (data.successful){
					
					Effect.CloseDown('tagConcerns');
					//Reset add concerns textbox and Clear comma separated concerns tag list
					$('btnContinue').disabled=false;
					$('addConcern').value = "";
					$('addConcern').style.background="#FFF";
					$('addConcern').style.color="#333";
					$('addConcern').focus();
					//showTagCloud();
					showMyConcerns(data.concern.id);
					
				}
			},
			errorHandler:function(errorString, exception){ 
				showTheError();
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
	Effect.Yellow('sidebar_concerns');
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
							Effect.Yellow('concernId' + id, {duration: 4, endcolor:'#EEF3D8', afterFinish: function(){showMyConcerns();}})
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
					//$("sidebar_concerns").style.display = "none";
					Effect.Yellow('sidebar_concerns');
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
					Effect.Yellow('sidebar_concerns');
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
	os += '<span class="closeBox"><a href="javascript: lightboxDisplay(\'none\');"><img src="/images/close.gif" border="0"></a></span>'
	os += '<br><h2>Glossary Term: '+ term +'</h2>';
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
					os += '<span class="closeBox"><a href="javascript: lightboxDisplay(\'none\');"><img src="/images/close.gif" border="0"></a></span>'
					os += '<h2>Edit My Concern</h2><br>';
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
							os += '<span class="closeBox"><a href="javascript: lightboxDisplay(\'none\');"><img src="/images/close.gif" border="0"></a></span>'
							os += '<h2>Edit My Concern\'s Tags</h2><p></p>';
							os += '<ul id="editTagsList" class="tagsList"> '+data.id+ '</ul>';
							os += '<p></p><form name="editTagList" onsubmit="addTagToList(\'editTagsList\',\'theNewTag\',\'editTagValidation\'); return false;"><input type="text" id="theNewTag" class="tagTextbox" name="theNewTag" size="15"><input type="submit" name="addTag" id="addTag" value="Add Tag!"></p>';
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
	Effect.Yellow('btnNextStep', {duration: 4, endcolor:'#EEF3D8'});
	Effect.Yellow('h2Finished', {duration: 4, endcolor:'#EEF3D8'});
}

function showTheError(errorString, exception){
					$('overview').style.display = 'none';
				$('slate').style.display = 'none';
				$('bar').style.display = 'none';
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

<div id="searchNavContiner">
		<div id="logo" style="top: 30px;"><img src="/images/logo2.png"></div>
		<div id="authentication">Welcome, ${baseuser.firstname} [&nbsp;<a href="/logout.do">logout</a>&nbsp;]</div>
		<div id="mainSearch">
				<form name="mainSearch" method="post" onSubmit="search();">
					<input type="text" ID="tbx1" class="searchBox" style="padding-left: 5px; padding-right:20px; background: url('/images/search.gif') no-repeat right;" value="Search" onfocus="this.value = ( this.value == this.defaultValue ) ? '' : this.value;return true;">
				</form>	
		</div>
	  <div id="navContent" class="navigation">
	  	<ul>
	  		<li><a href="modHome.jsp">Home</a></li>
				<li><span class="active"><a href-"modAgendaManager.jsp">Current Task</a></span></li>
				<li><a href="modDiscussion.jsp">Resource Library</a></li>
			</ul>
		</div>
</div>
<!-- END HEADER -->
<!-- LIGHTBOX -->
<div id="overlay"></div>
<div id="lightbox"></div>
<!-- LIGHTBOX -->
<div id="pageTitle">
<h2>Current Task: </h2><h3>Brainstorm Concerns</h3>
	<div id="bread">
	<ul>
		<li class="first"><a href="null">Home</a>
			<ul>
				<li>&#187; <a href="null">Current Task</a></li>
				<ul>
					<li>&#187; <a href="null">Brainstorm Concerns</a></li>
				</ul>
			</ul>
		</li>
	</ul>
	</div>
</div>	

 <div id="overview">
	  	<h4>Overview</h4> 
	  	<p class="indent"><!--${cctForm.cct.purpose}-->Before we can determine how to best improve the transportation system, we need to know what the problems are. Our first task is to brainstorm concerns about the transportation system.</p>
	  	<p class="indent"><small>[ <a href="allSteps.jsp">Read more</a> about how this step fits into the bigger picture. ]</small></p>
</p>
 </div>

 <div id="caughtException"><h4>A Problem has Occured</h4><br>We are sorry but there was a problem accessing the server to complete your request.  <b>Please try refreshing the page.</b></div>
 <div id="slate" class="slate leftBox">
  		<h4>Add your concern</h4><br>What problems do you encounter in your daily trips to work outside the home, shopping, and errands? In what ways do you feel our current transportation system fails to meet the needs of our growing region? <p>Describe <strong>one</strong> problem with our transportation system. You can add more concerns later</p>
		    <form name="brainstorm" method="post" onSubmit="addTagToList('tagsList', 'theTag','tagValidation'); return false;">
			      <p><textarea class="textareaAddConcern" onkeypress="ifEnter(this,event);" name="addConcern" cols="20" rows="2" id="addConcern"></textarea></p>
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
									<b>Suggested Tags for your concern:</b>  <ul class="tagsList" id="tagsList">
									</ul>	 
									<p><input type="text" id="theTag" class="tagTextbox" name="theTag" size="15"><input type="button" name="addTag" id="addTag" value="Add Tag!" onclick="addTagToList('tagsList','theTag','tagValidation');return false;"></p>
									<div style="display: none; padding-left: 20px;" id="tagValidation"></div>
									<hr>
									<span class="title_section">Finished Tagging? <br><input type="button" name="saveConcern" value="Add Concern to List!" onclick="saveTheConcern();"></span><input type="button" value="Cancel - back to edit my concern" onclick="javascript:resetForm();">
						    </div>
						    <br>
				    </div>
				
				<h4>Concerns you've contributed so far</h4><br>Finished? Click 'continue to next step' <a href="javascript:showFinished();">below</a>.<p></p>
			      <div id="myConcernsList" class="indent">
				      <ol id="myConcerns">
					  	</ol>
				  	</div>
						<a name="finished"></a><h4 style="float: left;" id="h4Finished">Finished brainstorming concerns?</h4>
						<div id="finished_img"><input type="button" id="btnNextStep" value="Continue to Next Step"></div>
		    </form>

  </div>
<!--START SIDEBAR -->
<!--
<div id="tagSelector">
	Tag Selected:
	<span class="closeBox">[ <a href="javascript:goPage(${setting.page});">Clear Selected</a> ]</span>
	<div class="pullDown" style="left: 50%;"><span class="pullDown"><img src="/images/pulldown.gif"></span></div>
</div>
-->
<div id="bar"><a id="SideConcernsTop" name="SideConcernsTop"></a>
	<div class="tabber" id="myTab">
			<div id="sidebar_currentTaskContainer" class="tabbertab">
	    	<h2>Concerns</h2>
				<div id="sidebar_concerns">
				</div>
	    </div>
	    <div id="sidebar_tags" class="tabbertab">
	    	<H2>Tags</H2>
	    </div>

			<!--
			<div id="sidebar_discussionContainer" class="tabbertab">
	    	<h2>Discussion</h2>
				<div id="sidebar_concerns"><h4>Discussion...</h4>
				</div>
	    </div>
	    
	    <div id="sidebar_resourcesContainer" class="tabbertab">
	    	<h2>Resources</h2>
				<div id="sidebar_discussion"><h4>Resources</h4>
				</div>
	    </div>
			-->
	</div>
</div>

<!--END SIDEBAR -->
</div>

<div id="footerContainer">
	<div id="footer"><a href="http://www.pgist.org" target="_blank"><img src="/images/footer_pgist.jpg" alt="Powered by the PGIST Portal" border="0" align="right"></a></div>
	<div id="nsf">This research is funded by National Science Foundation, Division of Experimental and Integrative Activities, Information Technology Research (ITR) Program, Project Number EIA 0325916, funds managed within the Digital Government Program.</div>
</div>

</body>
</html>
