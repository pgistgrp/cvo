<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://www.pgist.org/pgtaglib" prefix="pg" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Glossary Management View</title>

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

<script type='text/javascript' src='/dwr/interface/GlossaryManageAgent.js'></script>

<script type="text/javascript">

		var direction = "asc";
	
		function doOnLoad(){
			direction = "asc";
			getProposedTerms();
			getTerms("", "name");
			isTermsGotten();
			
			
		}
		var agt=navigator.userAgent.toLowerCase();
function sz(t) {
a = t.value.split('\n');
b=1;
for (x=0;x < a.length; x++) {
 if (a[x].length >= t.cols) b+= Math.floor(a[x].length/t.cols);
 }
b+= a.length;
if (b > t.rows && agt.indexOf('opera') == -1) t.rows = b;
}
		
		
		
		var yscrollPos=0;
		var xscrollPos=0;
		function getScrollPos(){
			if (self.pageYOffset) {
				yscrollPos = self.pageYOffset;
				xscrollPos = self.pageXOffset;
			} else if (document.documentElement && document.documentElement.scrollTop){
				yscrollPos = document.documentElement.scrollTop; 
				xscrollPos = document.documentElement.scrollLeft;
			} else if (document.body) {
				yscrollPos = document.body.scrollTop;
				xscrollPos = document.body.scrollLeft;
			}
		}
		
		function setScrollPos(){
			window.scrollTo(xscrollPos,yscrollPos);
		}
		
		function deleteConfirm(termstring,tid){
			var dletebox=confirm("Do you really wish to delete \""+termstring+"\"?");
			if(dletebox==true){
				deleteTerm(tid);
			}
		
		}
		
		function deleteTerm(termid){
		GlossaryManageAgent.deleteTerm({id:termid},{
		callback:function(data){
			if (data.successful){
				new Effect.Fade('glossaryTerm' + termid);
				new Effect.Fade('editbox'+termid);
				new Effect.Fade('editrow'+termid);
			}else{
			alert("deleteTerm failure reason: "+data.reason);
			}
		},
			errorHandler:function(errorString, exception){
			alert(errorString+" "+exception);
			}
		});
		}
		
		function getProposedTerms(){
		
			GlossaryManageAgent.getProposedTerms({},{
				callback:function(data){
					if (data.successful){
						$('proposedList').innerHTML="";
						$('proposedList').innerHTML+=data.html;
					}else{
						alert("getProposedTerms failure reason: "+data.reason);
					}
				},
				errorHandler:function(errorString, exception){
				alert(errorString+" "+exception);
				}
			
		
			});
		}
		
		
		
		var gotTerms=false;
		function getTerms(term,sortby){
		$('loading-indicator').style.display="inline";
				GlossaryManageAgent.getTerms({filter:term, sort:sortby, direction:direction}, {
				callback:function(data){
					if (data.successful){ 	
						$('list').innerHTML = "";
						$('list').innerHTML += data.html;
						setSort(sortby, term);
						direction = "asc";
						
						
						gotTerms=true;
						//isTermsGotten();
					}else{
						alert("getTerms failure reason: "+data.reason);
						$('loading-indicator').style.display = "none";
					}
					
				},
				errorHandler:function(errorString, exception){ 
				alert(errorString+" "+exception);
						
				}
			});
		
		}
		
		function saveNewTerm(termname, shortdef, extdef,  termlinklist, sourcelist){
		
		$('saving-indicator').style.display='inline';
			GlossaryManageAgent.saveTerm({id:-1, name:termname, shortDefinition:shortdef, extDefinition:extdef}, [], termlinklist, sourcelist, globalCategoryLinks,{
			callback:function(data){
			if(data.successful){
			
			saveFinished=true;
			//isNewTermSaved();
			}else{
			alert("saveNewTerm failure reason: "+data.reason);
			$('saving-indicator').style.display='none';
			}
			},
			errorHandler:function(errorString, exception){
			alert(errorString+" "+exception);
			}
			
		});
		
		
		
		}	
		
		
		
		
		var globalSourceLinks=new Array();
		var globalTermLinks = new Array();
		var globalCategoryLinks=new Array();
		
		
		var saveFinished=false;
		function saveEditedAttributes(tid){
		$('saving-indicator').style.display = "inline";
		
			GlossaryManageAgent.saveTerm({id:tid, name:$('edtermname'+tid).value, shortDefinition:$('edtermshortdef'+tid).value, extDefinition:document.getElementById('edtermextdef'+tid).value}, [], globalTermLinks, globalSourceLinks, globalCategoryLinks,{
			callback:function(data){
				if (data.successful){
				refreshSavedTerm(tid,$('edtermname'+tid).value, $('edtermshortdef'+tid).value);
				saveFinished=true;
				//isSaved();
				}else{
					alert("saveEditedAttributes failure reason: "+data.reason);
					$('saving-indicator').style.display="none";
				}
			},
			errorHandler:function(errorString, exception){
			alert(errorString+" "+exception);
			}
			
		});
		
		
		
		}		
		function refreshSavedTerm(tid,name,shortDef){
			$('glossaryViewLink'+tid).innerHTML=name;
			$('termShortDefinitionCell'+tid).innerHTML=shortDef;
		
		}
		
		
		
		
		function openUp(id, className){
		
			var activeRecord = className+id;
			
			if(currentopenbox==''){
			$(activeRecord).style.backgroundColor='white';
			new Effect.BlindDown(activeRecord, {duration: 0.4});
			currentopenbox=activeRecord;
			}else{
			if(currentopenbox!=activeRecord){
			new Effect.BlindUp(currentopenbox,{duration:0.4});
			$(activeRecord).style.backgroundColor='white';
			new Effect.BlindDown(activeRecord, {duration: 0.4});
			currentopenbox=activeRecord;
			
			}else{
			
			
			}
			}
			
			
		var t = setTimeout('jumpTo("'+activeRecord+'");',500);
		
		
		}
	
 
		function saveClose(tid){
			closeEdit(tid,'editbox'); 
			saveEditedAttributes(tid);
			isSaved();
			highlightChanged('glossaryTerm'+tid,'yellow');
//			$('glossaryTerm'+tid).style.backgroundColor='yellow';
			
		}
		
		function saveNewTermClose(tid, tname, shortd, extd){
		
			closeEdit(tid,'newTerm');
			
			saveNewTerm(tname, shortd, extd, globalTermLinks, globalSourceLinks);
			isNewTermSaved();
			
			getTerms();
			isTermsGottenJump('edit',tname);
			//alert(tname.charAt(0).toUpperCase()+tname.substr(1));
			//new Effect.toggle('newTerm'+tid,'blind',{duration:0.4});
			$('newTerm'+tid).style.display='none';
			
			//jumpTo('edit'+tename);
			
			
		}
		
		function isTermsGottenJump(prefix,tname){
		
		if(gotTerms){
		gotTerms=false;
		$('saving-indicator').style.display='none';
		
		var tename=tname.charAt(0).toUpperCase()+tname.substr(1).toLowerCase();
			jumpTo('edit'+tename);
			}else{
			var t =setTimeout("isTermsGottenJump(\""+prefix+"\",\""+tname+"\")",5000);
			}
		}
		
		function openCreateTermBox(tid){
		
		globalSourceLinks=new Array();
		globalTermLinks = new Array();
		globalCategoryLinks=new Array();
			//new Effect.toggle('newTerm'+tid, 'blind',{duration:0.4});
			
			$('newTerm'+tid).style.display='block';
			jumpTo('newTerm'+tid);
		}
		
		
		function jumpTo(href){
		
		location.hash=href;
		
		}
		
		function highlightChanged(id,col){
		//$(id).style.backgroundColor=col;
		new Effect.Highlight(id,{duration:5.0, endcolor:'#EEEEEE'});
		}
		
		function openEditBox(tid){
			changeEditBoxContent(tid);
			isContentChanged(tid);
			
		
		}
		
		
		var currentopenbox='';
		function isContentChanged(tid){
		
			if(changedContent){
				changedContent=false;
		
				openUp(tid, 'editbox');
		
			}else{
		
		
				var t =setTimeout('isContentChanged('+tid+');',100);
		
			}
			
		}
		
		function isNewTermSaved(){
		if(saveFinished){
		saveFinished=false;
		$('saving-indicator').style.display="none";
		
		getTerms();
		isTermsGotten();
		
		}else{
		var t =setTimeout('isNewTermSaved();',100);
		
		}
		}
		
		function isSaved(){
		
		if(saveFinished){
		saveFinished=false;
		$('saving-indicator').style.display = "none";
		
		}else{
		
		var t =setTimeout('isSaved();',100);
		
		}
		
		
		}
		
		
		
		function isTermsGotten(){
		
		if(gotTerms){
		gotTerms=false;
		$('loading-indicator').style.display = "none";
		}else{
		
		var t =setTimeout('isTermsGotten();',100);
		
		}
			
		
		}
		

		
		function deleteSourceLink(arrid,tid){
			globalSourceLinks.splice(arrid,1);
			generateSourceLinks(tid);
		}
		
		
		function generateSourceLinks(tid){
			var gsl="";
			for (var sa=0; sa<globalSourceLinks.length; sa++){
					gsl+="<a href='"+globalSourceLinks[sa][1]+"'>"+globalSourceLinks[sa][0]+"</a><br /><br /><button type='button' onclick='deleteSourceLink("+sa+","+tid+"); return false;'>Delete Source</button><br /><br />";
					
				}
		
			$('sourcelinks'+tid).innerHTML=gsl;
		}
		
		function deleteTermLink(arrid,tid){
			globalTermLinks.splice(arrid,1);
			generateTermLinks(tid);
		
		
		}
		
		function generateTermLinks(tid){
			var gtl="";
			for (var tl=0; tl<globalTermLinks.length; tl++){
					
					gtl+="<a href='"+globalTermLinks[tl]+"'>"+globalTermLinks[tl]+"</a>&nbsp;&nbsp; <button type='button' onclick='deleteTermLink("+tl+","+tid+"); return false;'>Delete Term Link</button><br />";
				}
			$('termlinks'+tid).innerHTML=gtl;
		
		}
		
		function addSourceLink(tid){
			var cit=$('edaddsourcecitation'+tid).value;
			var url=$('edaddsource'+tid).value;
			globalSourceLinks.push([cit,url]);
			$('edaddsourcecitation'+tid).value="Citation";
			$('edaddsource'+tid).value="Http://";
			generateSourceLinks(tid);
		}
		
		function addTermLink(tid){
			var url=$('edaddtermlink'+tid).value;
			globalTermLinks.push(url);
			$('edaddtermlink'+tid).value="Http://";
			generateTermLinks(tid);
		
		}
		
		var changedContent=false;
		function changeEditBoxContent(termid){
			GlossaryManageAgent.getTerm({id:termid, type:"edit"}, {
			callback:function(data){
				if(data.successful){
					globalTermLinks=new Array();
					globalSourceLinks=new Array();
					var sourcearray=data.term.sources;
					var termlinkarray=data.term.links;
				
					var lboxhtml = $('editbox'+termid);
				
					var satml="";
				
					for (var sa=0; sa<sourcearray.length; sa++){
						satml+="<a href='"+sourcearray[sa].url+"'>"+sourcearray[sa].citation+"</a><br /><br /><button type='button' onclick='deleteSourceLink("+sa+","+termid+"); return false;'>Delete Source</button><br /><br />";
						globalSourceLinks.push([sourcearray[sa].citation,sourcearray[sa].url]);
					}
				
					var tatml="";
				
					for (var tl=0; tl<termlinkarray.length; tl++){
					
						tatml+="<a href='"+termlinkarray[tl].link+"'>"+termlinkarray[tl].link+"</a>&nbsp;&nbsp; <button type='button' onclick='deleteTermLink("+tl+","+termid+"); return false;'>Delete Term Link</button><br />";
						globalTermLinks.push(termlinkarray[tl].link);
					}
				
					lboxhtml.innerHTML="<div style='border:thick solid #C0C0C0;'><table style='width:100%;' rules='all'><tbody><tr><td cellspacing=10 style=''><div style='margin:2%;'><label><strong>Term Name:</strong></label><br /><input style='width:50%;' id='edtermname"+termid+"' type='text' value=\""+data.term.name+"\"/><br />"+
				"<label><strong>Short Definition</strong></label><br /><textarea style='width:90%; height:100%;' rows=3 cols=40 onclick='sz(this);' onkeyup='sz(this);' id='edtermshortdef"+termid+"'>"+data.term.shortDefinition+"</textarea></div></td>"+
				"<td rowspan=2><div style='margin:2%;'><label><strong>Sources</strong></label><br /><div id='sourcelinks"+termid+"'>"+satml+
				"</div><br /><label><strong>Add Source</strong></label><br /><textarea style='width:90%;' rows=3 cols=40 onclick='sz(this);' onkeyup='sz(this);' id='edaddsourcecitation"+termid+"'>Citation</textarea><br /><input style='width:50%;' id='edaddsource"+termid+"' type='text' value='Http:"+'//'+"'/>"+
				"<br /><button type='button' onclick='addSourceLink("+termid+"); return false;'>Add Source</button><br /><br /><label><strong>Term Links</strong></label><br /><div id='termlinks"+termid+"'>"+tatml+
				"</div><br /><label>Add Link</label><br /><input style='width:50%;' id='edaddtermlink"+termid+"' type='text' value='Http:"+'//'+"'/><br /><button type='button' onclick='addTermLink("+termid+"); return false;'>Add Link</button></div></td></tr><tr><td><div style='margin:2%;'><label><strong>Extended Definition</strong></label><br />"+
				"<textarea rows=3 cols=40 onclick='sz(this);' onkeyup='sz(this);' style='width:90%; height:100%;' id='edtermextdef"+termid+"'>"+data.term.extDefinition+"</textarea></div></td></tr><tr><td style='width:50%;'></td><td style=''><div style='margin:0.5%; float:right;'><button type='button' onclick='closeEdit("+termid+",\"editbox\"); return false;'>Cancel</button>&nbsp;<button type='button' onclick='saveClose("+termid+"); return false;'>Save and Close</button></div></td></tr></tbody></table></div>";
					changedContent=true;
					//isContentChanged(termid);
				}else{
					alert("changeEditBoxContent failure reason: "+data.reason);
				}
			},
			errorHandler:function(errorString, exception){
			alert(errorString+" "+exception);
			}
			
			
		});
		
	}		
		function setSort(thisSort, term){
			headings = document.getElementsByTagName("th"); 
			for (var i = 0; i < headings.length; i++) { 
				if (headings[i].id != 'def' && headings[i].id!='actions'){
			    if (headings[i].id == thisSort){
			    	if(direction == 'asc'){
			    		headings[i].innerHTML = thisSort + '&nbsp;&nbsp;<a href="javascript:sortDir(\'desc\',\'' + thisSort + '\', \''+ term +'\');"><img src="/images/sort_' + direction +'.gif" border="0"></a>';
			   		}else{
			   			headings[i].innerHTML = thisSort + '&nbsp;&nbsp;<a href="javascript:sortDir(\'asc\',\'' + thisSort + '\', \''+ term +'\');"><img src="/images/sort_' + direction +'.gif" border="0"></a>';
			   		}
			    }else{
			    	headings[i].innerHTML = '<a href="javascript: getTerms(\''+ term +'\',\''+ headings[i].id +'\'); isTermsGotten();">'+ headings[i].innerHTML +'</a>';
			    }
			  }  
			}
		}	
		
		function sortDir(switchTo, thisSort, term){
				direction = switchTo;
				getTerms(term, thisSort); 
				isTermsGotten();
		}
</script>

<style type='text/css'>
#saving-indicator{
	display: none;
	background-color: red;
	color: white;
	position: fixed;
	top: 0;
	left:0;
	padding: 3px;
	z-index: 500;
}



</style>
<script type='text/javascript'>
function edit(boxid){
var editid='editbox'+boxid;
var editrowid='editrow'+boxid;

var editrow=document.getElementById(editrowid);
var editbox=document.getElementById(editid);





editbox.style.display='block';
editbox.style.backgroundColor='white';

$('overlay').style.display='inline';
new Effect.toggle(editid,'blind');

//new Effect.toggle(editrowid,'blind');

//document.getElementsByClassName

}
function closeEdit(boxid,boxname){
var editid=boxname+boxid;
var editbox=document.getElementById(editid);
//editbox.style.display='none';
new Effect.BlindUp(editbox,{duration:0.4});
//editrow.style.visibility='hidden';
currentopenbox='';
if(boxname=='editbox'){
var t=setTimeout('jumpTo("glossaryTerm'+boxid+'");',500);
}else if(boxname=='newTerm'){

var t = setTimeout('jumpTo("'+editid+'");',500);
}
}




</script>

</head>

<style>
#slate ul{display:inline; margin:0; padding:0}
#slate li{list-style: none; display:inline; padding: 3px;}
tr:hover {background-color: #F1F7FF;}


</style>
<body>
	<jsp:include page="/header.jsp" />
<div style="display: inline;" id="loading-indicator">Loading... <img src="glossaryTermManagement_files/indicator_arrows.gif"></div>
<div style="display: none;" id="saving-indicator">Saving... <img src="glossaryTermManagement_files/indicator_arrows.gif"></div>

<div id="container">

		
		<!-- Header -->
		<div id="cont-top">
		<!-- Sub Title -->
		<div id="subheader">
		<h1>Moderator Tools:</h1> 
		<h2>Glossary Term Management</h2>
		</div>
		<div id="footprints">
		<span class="smalltext"><a href="#">Participate</a> &raquo; <a href="#">Moderator Tools</a> &raquo; Glossary Term Management</span>
		</div>
		<!-- End Sub Title -->
		<!-- Overview SpiffyBox -->
		<div class="cssbox">
			<div class="cssbox_head">
				<h3>Overview</h3>
			</div>
			<div class="cssbox_body">
				<p>Glossary term management instructions</p>
				
			</div>
		</div>
		<!-- End Overview -->
		
		</div> <!-- End cont-top -->
	
	
	<!--Proposed Glossary Terms-->

	<div id="proposedList">
	<!-- load proposed terms here -->
	</div>
	
	<!-- Sub Title -->
	<div id="subheader">
	<h1>Listing of All Glossary Terms</h1> 
	</div>
	<!-- End Sub Title -->
	<!--new glossary term button-->
	<br />
	<div style="background-color: rgb(204, 255, 51); "><a href="javascript:openCreateTermBox(1);">new glossary term</a></div>
	<div id='newTerm1' style='display:none; border:thick solid #C0C0C0;'><div ><table style='width:100%; height:100%;' rules='all'><tbody><tr><td cellspacing=10 style=''><div style='margin:2%;'><label><strong>Term Name:</strong></label><br /><input style='width:50%;' id='edtermname-1' type='text' value=''/><br />
				<label><strong>Short Definition</strong></label><br /><textarea style='width:90%; height:100%;' rows=3 cols=40 onclick='sz(this);' onkeyup='sz(this);' id='edtermshortdef-1'></textarea></div></td>
				<td rowspan=2><div style='margin:2%;'><label><strong>Sources</strong></label><br /><div id='sourcelinks-1'>
				</div><br /><label><strong>Add Source</strong></label><br /><textarea style='width:90%;' rows=3 cols=40 onclick='sz(this);' onkeyup='sz(this);' id='edaddsourcecitation-1'>Citation</textarea><br /><input style='width:50%;' id='edaddsource-1' type='text' value='Http://'/>
				<br /><button type='button' onclick='addSourceLink(-1); return false;'>Add Source</button><br /><br /><label><strong>Term Links</strong></label><br /><div id='termlinks-1'>
				</div><br /><label>Add Link</label><br /><input style='width:50%;' id='edaddtermlink-1' type='text' value='Http://'/><br /><button type='button' onclick='addTermLink(-1); return false;'>Add Link</button></div></td></tr><tr style=''><td style=''><div style='min-height:100%; margin:2%;'><label><strong>Extended Definition</strong></label><br />
				<textarea rows=3 cols=40 onclick='sz(this);' onkeyup='sz(this);' style='width:90%; height:100%;' id='edtermextdef-1'></textarea></div></td></tr><tr style=''><td style='width:50%;'></td><td style=''><div style='margin:0.5%; float:right;'><button type='button' onclick='closeEdit(1,"newTerm"); return false;'>Cancel</button>&nbsp;<button type='button' onclick='saveNewTermClose(1,$("edtermname-1").value, $("edtermshortdef-1").value, $("edtermextdef-1").value); $("edtermname-1").value=""; $("edtermshortdef-1").value=""; $("edtermextdef-1").value=""; $("sourcelinks-1").innerHTML=""; $("termlinks-1").innerHTML=""; return false;'>Save and Close</button></div></td></tr></tbody></table></div></div>
	<br />
	<!-- Overview SpiffyBox -->
	<!-- End Overview -->
<div id="slate">
		<div id="filterTerms">
		<form id="form1" name="form1" method="post" action="">
		  <label>Filter Glossary 
		  <input id="txtSearch" name="txtSearch" style="background: rgb(255, 255, 255) url(/images/search_light.gif) no-repeat scroll right center; width: 120px; padding-left: 1px; padding-right: 20px; margin-right: 5px; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; color: rgb(153, 153, 153);" class="txtSearch" value="Search Terms" type="text"></label><div id="txtSearchIndicator" style="visibility: hidden; position: absolute; right: 0pt; margin-right: 150px;"><img src="glossaryTermManagement_files/indicator.gif"></div>
		  
		  <div id="clearSearch" style="display: none;"></div>
		</form>
		
	</div>
	  <div id="list"><!--Load glossary terms-->
	<div>
	
	
	</div>
	<br>
	<br>
	
    
</div>
  </div>

	
	
<br>
	<!--new glossary term button-->
	<div style="background-color: rgb(204, 255, 51); "><a href="javascript:openCreateTermBox(2);">new glossary term</a></div>
		<div id='newTerm2' style='display:none; border:thick solid #C0C0C0;'><div ><table style='width:100%;' rules='all'><tbody><tr><td cellspacing=10 style=''><div style='margin:2%;'><label><strong>Term Name:</strong></label><br /><input style='width:50%;' id='edtermname-2' type='text' value=''/><br />
				<label><strong>Short Definition</strong></label><br /><textarea style='width:90%; height:100%;' rows=3 cols=40 onclick='sz(this);' onkeyup='sz(this);' id='edtermshortdef-2'></textarea></div></td>
				<td rowspan=2><div style='margin:2%;'><label><strong>Sources</strong></label><br /><div id='sourcelinks-2'>
				</div><br /><label><strong>Add Source</strong></label><br /><textarea style='width:90%;' rows=3 cols=40 onclick='sz(this);' onkeyup='sz(this);' id='edaddsourcecitation-2'>Citation</textarea><br /><input style='width:50%;' id='edaddsource-2' type='text' value='Http://'/>
				<br /><button type='button' onclick='addSourceLink(-2); return false;'>Add Source</button><br /><br /><label><strong>Term Links</strong></label><br /><div id='termlinks-2'>
				</div><br /><label>Add Link</label><br /><input style='width:50%;' id='edaddtermlink-2' type='text' value='Http://'/><br /><button type='button' onclick='addTermLink(-2); return false;'>Add Link</button></div></td></tr><tr><td><div style='margin:2%;'><label><strong>Extended Definition</strong></label><br />
				<textarea rows=3 cols=40 onclick='sz(this);' onkeyup='sz(this);' style='width:90%; height:100%;' id='edtermextdef-2'></textarea></div></td></tr><tr><td style='width:50%;'></td><td style=''><div style='margin:0.5%; float:right;'><button type='button' onclick='closeEdit(2,"newTerm"); return false;'>Cancel</button>&nbsp;<button type='button' onclick='saveNewTermClose(2,$("edtermname-2").value, $("edtermshortdef-2").value, $("edtermextdef-2").value); $("edtermname-2").value=""; $("edtermshortdef-2").value=""; $("edtermextdef-2").value=""; $("sourcelinks-2").innerHTML=""; $("termlinks-2").innerHTML=""; return false;'>Save and Close</button></div></td></tr></tbody></table></div></div>
<br>
<!-- Start Footer -->
<div id="footer_clouds">

<pg:feedback id="feedbackDiv" action="glossaryManage.do" />



	<div id="footer_text">
	<a href="http://www.pgist.org/"><img src="glossaryTermManagement_files/footerlogo.png" alt="PGIST Logo" class="imgright" border="0" height="51" width="156"></a><br>This
research is funded by National Science Foundation, Division of
Experimental and Integrative Activities, Information Technology
Research (ITR) Program, Project Number EIA 0325916, funds managed
within the Digital Government Program. </div>

</div>
<!-- End Footer -->

			  
			  
			 	
			  
		

				
<!-- Run javascript function after most of the page is loaded, work around for onLoad functions quirks with tabs.js -->


</div>

<!-- Run javascript function after most of the page is loaded, work around for onLoad functions quirks with tabs.js -->
<script type="text/javascript">
	doOnLoad();
</script>
</body>
</html>
