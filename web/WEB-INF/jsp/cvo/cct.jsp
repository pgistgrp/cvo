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
			Effect.Yellow('validation', {duration: 4, endcolor:'#EEEEEE'});
			Effect.Yellow('theTag', {duration: 10, endcolor:'#EEEEEE'});
			return false;
			
		}else{
			Effect.CloseDown('validation');
			Effect.OpenUp('tagConcerns');
			Effect.Yellow('tags', {duration: 4, endcolor:'#DDDDDD'});
			return true;
		}
	}
	
	function resetForm()
	{
		Effect.CloseDown('tagConcerns');
		Effect.CloseDown('validation');
	}
	
	function prepareConcern(){
		if (validateForm()){
			var concern = $('addConcern').value;
			document.getElementById("indicator").style.visibility = "visible";
			CCTAgent.prepareConcern({cctId:cctId,concern:concern}, function(data) {
				if (data.successful){
					var str= "";
					for(i=0; i < data.tags.length; i++){
						str += '<li class="tagsList"><span class="tagsList_tag">'+ data.tags[i] +'</span><span class="tagsList_controls">&nbsp;<a href="null"><img src="/images/trash.gif" alt="Delete this Tag!" border="0"></a></span>&nbsp;|&nbsp;</li>';
						concernTags += data.tags[i] + ',';
					}
					document.getElementById('tagsList').innerHTML = str;

				}
				document.getElementById("indicator").style.visibility = "hidden";
			} );
		}
	}
	
	function addTagToList(){
		document.getElementById('tagsList').innerHTML += '<li class="tagsList"><span class="tagsList_tag">'+ document.getElementById("theTag").value +'</span><span class="tagsList_controls">&nbsp;<a href="null"><img src="/images/trash.gif" alt="Delete this Tag!" border="0"></a></span>&nbsp;|&nbsp;</li>';
		concernTags += document.getElementById("theTag").value + ',';
		Effect.Yellow('theTag', {duration: 4, endcolor:'#EEEEEE'});
		$('theTag').value = "";
	}
	
	function saveTheConcern(){
		var concern = $('addConcern').value;
		$("indicator").style.visibility = "visible";
		//$('explaination').innerHTML = "";
		CCTAgent.saveConcern({cctId:cctId,concern:concern,tags:concernTags}, function(data){
			if (data.successful){
				showMyConcerns();
				
				Effect.Yellow('myConcerns', {duration: 4, endcolor:'#EEEEEE'});
				Effect.CloseDown('tagConcerns');
				//Reset add concerns textbox and Clear comma separated concerns tag list
				concernTags = "";
				document.forms.brainstorm.addConcern.value = "";
				document.forms.brainstorm.addConcern.focus();
			}
		$("indicator").style.visibility = "hidden";
	});
}

	function showTagCloud(){
		CCTAgent.getTagCloud({cctId:cctId,type:0,count:20}, function(data){
			if (data.successful){
				var s = '';
				for (i=0; i<data.tags.length; i++){
					s += data.tags[i].tag.name + ' ';
				}
				$("sidebar_tags").innerHTML += s;
			}

		$("indicator").style.visibility = "hidden";
	});
}

function showConcerns(theType){
	CCTAgent.getConcerns({cctId:cctId,type:theType,count:7}, function(data){
		if (data.successful){
			$('sidebar_concerns').innerHTML = data.html;
		}
	});
}

function showMyConcerns(){
	CCTAgent.getConcerns({cctId:cctId,type:0,count:-1}, function(data){
			if (data.successful){
				$('myConcernsList').innerHTML += data.html;
			}
			if (data.total == 0){
				document.getElementById("myConcernsList").innerHTML = '<p class="explaination">None created yet.  Please add a concern above.  Please refer to other participant\'s concerns on the right column for examples.</p>';
			}
		});
	}

	
	
</script>
</head>
<body>

<div id="decorBar"></div>
<div id="header"><img src="/images/logo.jpg"></div>

<div id="navigation">
	<div id="bread">
	<ul>
		<li class="first">LIT Process
			<ul>
				<li>&#187; Brainstorm Concerns</li>
			</ul>
		</li>
	</ul>
	</div>
</div>
<br>
<div id="container">
<span class="title_page">Brainstorm Concerns</span>
  <div id="overview"><span class="title_overview">Overview and Instructions</span> 
  	<p><strong>Instructions:</strong>${cctForm.cct.instruction}</p>
  </div>
  <br>
  
 <div id="slate">
    <span class="title_section">Add your concern</span>

		    <form name="brainstorm" method="post" onSubmit="addTagToList(); return false;">
			    	
			      <p><textarea class="textareaAddConcern" name="addConcern" cols="50" rows="5" id="addConcern"></textarea></p>
			      <p class="indent">
				      <input type="reset" name="Submit2" value="Reset" onClick="resetForm();"> 
				      <input type="button" name="Continue" value="Continue" onclick="prepareConcern();">
				      <span id="indicator" style="visibility:hidden;"><img src="/images/indicator.gif"></span>
			      </p>
			      <div style="display: none; padding-left: 20px;" id="validation"></div>
			  
				    <div id="tagConcerns" style="display: none; padding-left: 20px;">
						    <div id="tags" style="background-color: #DDDDDD; border: 1px solid #BBBBBB; padding: 5px;"><span class="title_section">Tag Your Concern</span>
						    	<p>The tags below are suggested tags for your concern.  Please delete those that do not apply to your concern and use the textbox below to add more tags (if needed). <span class="smallHelp">[ <a href="null">why are tags important?</a> ]</span></p>
									<ul class="tagsList" id="tagsList">
									</ul>	    
									
									<p><input type="text" id="theTag" name="theTag" size="15"><input type="button" name="addTag" id="addTag" value="Add Tag!" onclick="addTagToList();"></p>
						    </div>
						    <p><b class="blue">Finished Tagging? </b><input type="button" name="saveConcern" value="Add Concern to List!" onclick="saveTheConcern();"></p>
				    </div>
				    <hr><span class="title_section">List of Created Concerns</span><br>
			      <div id="myConcernsList" class="indent">
				      <ol id="myConcerns">
					  	</ol>
				  	</div>
				  	<hr>
						<span class="title_section">Finished Brainstorming Concerns?</span><br>
						<div id="finished_container" class="indent">
							<div id="finished_p"><p>When you are staisfied with your concerns list above, please use the button on the right to continue to the next step!</p></div>
							<div id="finished_img"><a href="nextStep"><img src="/images/submission_brainstorm.gif" border="0" align="right"></a></div>
						</div>
		    </form>

  </div>
<!--START SIDEBAR -->
<div id="bar">
	<div class="tabber">
	
	    <div id="sidebar_tags" class="tabbertab">
	    	<H2>Tags</H2>
	    </div>
	
	
	    <div id="sidebar_concernsContainer" class="tabbertab">
	    	<h2>Other Concerns</h2>
				<span class="title_section">Other Participant's Concerns</span>
				<p>To help you create your concerns, below are examples of other participant concerns in random order.</p>
				<p><a href="JavaScript:showConcerns(2);">Get more random concerns!</a></p>
				<div id="sidebar_concerns">
				</div>
	    </div>
	
	</div>
</div>
</div>
<!--END SIDEBAR -->
<div id="footerContainer">
	<div id="footer"><a href="http://www.pgist.org" target="_blank"><img src="/images/footer_pgist.jpg" alt="Powered by the PGIST Portal" border="0" align="right"></a></div>
	<div id="nsf">This research is funded by National Science Foundation, Division of Experimental and Integrative Activities, Information Technology Research (ITR) Program, Project Number EIA 0325916, funds managed within the Digital Government Program.</div>
</div>
</body>
</html>
