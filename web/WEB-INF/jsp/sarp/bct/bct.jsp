<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.pgist.org/pgtaglib" prefix="pg" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="wf" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Step 1a: Brainstorm</title>
<!-- Site Wide CSS -->
<style type="text/css" media="screen">
@import "styles/lit.css";
#sortingMenu{width:680px;padding-right:0px;}
</style>
<!-- End Site Wide CSS -->
<!-- Site Wide JavaScript -->
<script language="JavaScript" src="scripts/qtip.js" type="text/JavaScript"></script>
<script src="scripts/tags.js" type="text/javascript"></script>
<script src="scripts/prototype.js" type="text/javascript"></script>
<script src="scripts/scriptaculous.js?load=effects,dragdrop" type="text/javascript"></script>
<script src="scripts/search.js" type="text/javascript"></script>
<!-- End Site Wide JavaScript -->

<!-- DWR JavaScript Libraries -->
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<!-- End DWR JavaScript Libraries -->

<!--BCT Specific  Libraries-->
<script type='text/javascript' src='/dwr/interface/BCTAgent.js'></script>
<!--End BCT Specific  Libraries-->
<script type="text/javascript">
//START Global Variables

var bct = new Object;
var newConcernTagsArray = new Array();
var newConcernSelectedTagsArray = new Array();
var allNewConcernTags = new Array;
//Element IDs - allows for easier maintanence.
  bct.divDiscussionCont = 'discussion-cont';
  bct.divTagNewConcern = 'tagNewConcern';
  bct.divAddConcernTagsList = 'addConcernTagsList';
  bct.divFilteredBy = 'filteredBy';
  bct.divSearchResults = 'searchResults';
  bct.filterAnchor = "#filterJump";
  bct.divTagCloud = 'tagCloud';
  bct.divDiscussionTitle = "discussionTitle";
  bct.discussionTitle = "All participants' concerns";
  bct.discussionTitleOnChk = "Your concerns";
    
//Input Element IDs
  bct.txtAddConcern = 'txtAddConcern';
  bct.btnContinueCont = 'btnContinueCont';
  bct.chbxMyConcerns = 'myconcerns';
  
//Settings
  bct.currentPage = 0;
  bct.currentSort = 1; //Initial sorting
  bct.currentFilter = '';  //Default tag filter
  bct.numTagsInNewConcern = 2;
  bct.concernsPerPage = 8;
  bct.showOnlyMyConcerns = false; 
  bct.concernsDesc = true; //concern order
  bct.bctId = "${bct.id}";
  bct.tagCloudCount = 20;
  bct.currentTagCloudPage = 1;


//END Global Variables

  function getContextConcerns(filter, page, jump, showMyConcerns, sorting){
    //alert("filter" + filter + " page: " + page + " jump: " + jump + " showMyConcerns: " + showMyConcerns + " sorting: " + sorting)
    if(jump){
      location.href = bct.filterAnchor; //set anchor if need be
    }
    bct.showOnlyMyConcerns = showMyConcerns;
    type = (bct.showOnlyMyConcerns) ? "owner" : "all"; //determine type
    bct.currentPage = page; //set current page
    bct.currentSort = sorting; 
    
      //  alert("bct: " + bct.bctId + " filter: " + filter + " count: " + bct.concernsPerPage + " page: " + page + " sorting: " + bct.currentSort + " type: " + type);
    BCTAgent.getContextConcerns({bctId: bct.bctId,filter: filter, count: bct.concernsPerPage, page: page, sorting: bct.currentSort, type: type},<pg:wfinfo/>, {
      callback:function(data){
          if (data.successful){
            $(bct.divDiscussionCont).innerHTML = data.html;
          }else{
            alert(data.reason);
          }
        },
        async:false,
      errorHandler:function(errorString, exception){ 
          alert("getContextConcerns error:" + errorString + exception);
      }
    });  
    return true
  }
    
  function goToPage(page, section){
    if(section=="tagCloud"){
      bct.currentTagCloudPage=page;
      getNextTagCloud();
    }else{
    getContextConcerns(bct.currentFilter,page,true, bct.showOnlyMyConcerns, bct.currentSort); 
    //new Effect.Highlight('discussion-cont',{startcolor: "#D6E7EF"});
    }
  }
  
  
  function checkMyConcerns(){
    if($(bct.chbxMyConcerns).checked != true){
      $(bct.divFilteredBy).style.display = 'inline';
      getContextConcerns(bct.currentFilter, bct.currentPage, false, false, bct.currentSort);
      location.href= bct.filterAnchor;
      $(bct.divDiscussionTitle).innerHTML = bct.discussionTitle;
    }else{ //when it is checked
      $(bct.divFilteredBy).style.display = 'none';
      getContextConcerns('', bct.currentPage, false, true, bct.currentSort);
      location.href= bct.filterAnchor;
      $(bct.divDiscussionTitle).innerHTML = bct.discussionTitleOnChk;
    }
  }

  
  //ADD Concern Functions
  function validateForm(){
    if($(bct.txtAddConcern).value == "" ||$(bct.txtAddConcern).value  == $(bct.txtAddConcern).defaultValue ){ 
        alert('Please fill in your concern above.');
        return false;
    }else{
        new Effect.BlindDown(bct.divTagNewConcern, {duration: 0.2});
        
        return true;
    }
  }
  
  function resetForm(){
    $(bct.txtAddConcern).value = '';
  }

  function cancelSubmit(){
    Effect.BlindUp(bct.divTagNewConcern, {duration: 0.2});
  }
  
  function swapContinue(showContinue){
    if(!showContinue){
      $(bct.btnContinueCont).innerHTML = '<input id="btnContinue" type="button" value="Continue" onClick="prepareConcern(); swapContinue(true);" />';
      $(bct.txtAddConcern).disabled = false;
    }else{
      $(bct.btnContinueCont).innerHTML = '<input id="btnCancelNewConcern" type="button" value="Cancel" onClick="cancelSubmit(); swapContinue();" /><input id="btnSubmitNewConcern" type="button" value="Submit" onClick="saveConcern();" />';
      $(bct.txtAddConcern).disabled = true;
    }
  }

  function prepareConcern(){  //Find tags and potential tags to render
    var concernTags = new Array;
    var potentialTags = new Array;
    var concern = $(bct.txtAddConcern).value;
    
    if (validateForm()){  
      BCTAgent.prepareConcern({bctId:bct.bctId,concern:concern}, function(data) {
        if (data.successful){
          swapContinue(true);
          newConcernTagsArray = [];
          for(i=0; i< data.tags.length; i++){
            concernTags.push(data.tags[i]);
          }
          for(i=0; i < data.potentialtags.length; i++){
            potentialTags.push(data.potentialtags[i]);
          }
          allNewConcernTags = concernTags.concat(potentialTags);
          for(i=0; i < allNewConcernTags.length; i++){
            addToConcernTagsArray(allNewConcernTags[i], "unchecked");
          }
        
          $(bct.divAddConcernTagsList).innerHTML = renderTags();  
        }else{
          alert(data.reason);  
        }
      } );
    }
  }
  

  function renderTags(){
    var str= "";
    for(i=0; i < newConcernTagsArray.length; i++){
      if(newConcernTagsArray[i] != ""){
        str += '<li><label><input type="checkbox" '+newConcernTagsArray[i].status+' onclick="checkNewConcernTag('+ i +');" />'+ newConcernTagsArray[i].tagName +'</label></li>';
      }
    }  
    return str;
  }
  
  function checkNewConcernTag(index){
    if(newConcernTagsArray[index].status == "unchecked"){
      newConcernTagsArray[index].status = "checked";
    }else{
      newConcernTagsArray[index].status = "unchecked";
    }
  }
  
  function NewConcernTag(tagName, status){
    this.tagName = tagName;
    this.status = status;
  }
  
  function addToConcernTagsArray(tagName, status){
    var newConcernTagInstance = new NewConcernTag(tagName, status);
    newConcernTagsArray.push(newConcernTagInstance);
  }
  
  function getTagCloud(){
    //alert('bctId: ' + bct.bctId + ' count: ' + bct.tagCloudCount + ' page: ' + bct.currentTagCloudPage);
      BCTAgent.getTagCloud({bctId:bct.bctId,type:2,count:bct.tagCloudCount, page: bct.currentTagCloudPage},{
        callback:function(data){
            if (data.successful){      
              $(bct.divTagCloud).innerHTML = data.html;
              if (data.count == 0){
                $(bct.divTagCloud).innerHTML = '<a href="javascript:Effect.Fade(\''+bct.divTagCloud+'\', {duration: 0.5}); void(0);"><img src="images/close1.gif" border=0 class="floatRight"></a><p>No tag matches found! Please try a different search.</p> ';
              }
              if($(bct.divTagCloud).style.display == 'none'){
                new Effect.BlindDown(bct.divTagCloud, {duration: 0.5});    
              }else{
                new Effect.BlindUp(bct.divTagCloud, {duration: 0.5});  
              }    
            }else{
              alert(data.reason);
            }
        },
        errorHandler:function(errorString, exception){ 
              alert("getTagCloud: "+errorString+" "+exception);
        }    
      });  
  };
  
  function getNextTagCloud(){
    
      BCTAgent.getTagCloud({bctId:bct.bctId,type:2,count:bct.tagCloudCount, page: bct.currentTagCloudPage},{
        callback:function(data){
            if (data.successful){      
              $(bct.divTagCloud).innerHTML = data.html;
              if (data.count == 0){
                $(bct.divTagCloud).innerHTML = '<a href="javascript:Effect.Fade(\''+bct.divTagCloud+'\', {duration: 0.5}); void(0);"><img src="images/close1.gif" border=0 class="floatRight"></a><p>No tag matches found! Please try a different search.</p> ';
              }
              
            }else{
              alert(data.reason);
            }
        },
        errorHandler:function(errorString, exception){ 
              alert("getNextTagCloud: "+errorString+" "+exception);
        }    
      });  
  };
  
  
  
  function addManualTag(){
    var manualTag = $('manualTag').value;
    if(manualTag != $('manualTag').defaultValue){  //couldn't get the or operator working for some reason?
      if(manualTag != ""){
        addToConcernTagsArray(manualTag, "checked");  
        $(bct.divAddConcernTagsList).innerHTML = renderTags();
        $('manualTag').value = ""; //clear textbox
      }else{
        alert("Keyword/phase cannot be blank!");  
      }
    }else{
      alert("Keyword/phase cannot be blank!");  
    }
    //for(i=0; i< newConcernTagsArray.length; i++){
    //  alert(newConcernTagsArray[i].tagName + " status:" + newConcernTagsArray[i].status);  
    //}
  }
  

  
  function getSelectedTags(){
    newConcernSelectedTagsArray = [];
    for(i=0; i<newConcernTagsArray.length; i++){
      if(newConcernTagsArray[i].status == 'checked'){
        newConcernSelectedTagsArray.push(newConcernTagsArray[i].tagName);
      }
    }  
    //alert(newConcernSelectedTagsArray);
  }
        
  function saveConcern(){
    getSelectedTags();
    if(newConcernSelectedTagsArray.length<bct.numTagsInNewConcern){
    alert("You must use at least "+ bct.numTagsInNewConcern +" keywords/phrases");
    }else{
    var concern = $(bct.txtAddConcern).value;
    var newConcernSelectedTagsString = '';
    for (i=0; i<newConcernSelectedTagsArray.length; i++){
      newConcernSelectedTagsString += newConcernSelectedTagsArray[i] + ',';  
    }
    //alert(newConcernSelectedTagsString);
    //alert('bctId:' + bctId + ', concern: ' + concern + ', tags: ' + newConcernSelectedTagsString);
    //alert(newConcernSelectedTagsString);
    
    BCTAgent.saveConcern({bctId:bct.bctId,concern:concern,tags:newConcernSelectedTagsString},<pg:wfinfo/>, {
      callback:function(data){
        if (data.successful){
          getContextConcerns(bct.currentFilter, 0, true, bct.showOnlyMyConcerns, bct.currentSort);   
          //setVote(data.concern.id, "true")
          swapContinue(false);
          $(bct.txtAddConcern).value = '';
          new Effect.BlindUp(bct.divTagNewConcern);
          window.setTimeout('new Effect.Highlight("concern'+ data.concern.id +'", {duration: 4.0});',1000);
          //new Effect.Highlight("concern"+data.concern.id, {duration:4.0});
        }else{
          alert(data.reason)
        }
      },
      errorHandler:function(errorString, exception){ 
        alert("saveTheConcern: "+errorString+" "+exception);
      }
  });

  }
  }
  
  function setVote(id, agree){
    BCTAgent.setVoting({id: id, agree:agree}, {
    callback:function(data){
        if (data.successful){ 
          if($('concernVote'+id) != undefined){
                    new Effect.Fade('concernVote'+id, {afterFinish: function(){getContextConcerns(bct.currentFilter,bct.currentPage, false, bct.showOnlyMyConcerns, bct.currentSort); new Effect.Appear('concernVote'+id);}});
                 }else{ //newly created concern
                   getContextConcerns(bct.currentFilter, bct.currentPage, false, bct.showOnlyMyConcerns, bct.currentSort);   
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
  //END ADD Concern Functions
  
  function deleteConcern(concernId){
    var destroy = confirm ("Are you sure you want to delete this comment? There is no way to undo this action.")
    if (destroy){
        BCTAgent.deleteConcern({concernId:concernId}, {
        callback:function(data){  
            if (data.successful){
              new Effect.Puff('concern'+concernId, {afterFinish:function(){getContextConcerns(bct.currentFilter,bct.currentPage,false, bct.showOnlyMyConcerns, bct.currentSort);}});
            }else{
              alert(data.reason);  
            }
        },
        errorHandler:function(errorString, exception){ 
          alert("delConcern: "+errorString+" "+exception);
          //showTheError();
        }
        });
    }
  }
  
  function changeCurrentFilter(tagRefId){
    $(bct.chbxMyConcerns).checked = false; //a user's concerns can not be filtered.
    checkMyConcerns();
    if (tagRefId != ''){
        BCTAgent.getTagByTagRefId(tagRefId, {
        callback:function(data){
        if (data.successful){
              var tagName = data.tag.name;
              getContextConcerns(tagName, 0, true, bct.showOnlyMyConcerns, bct.currentSort);
              bct.currentFilter = tagName;
                    
              $(bct.divFilteredBy).innerHTML = '<h3 class="contrast1">Filtered By: ' + tagName + ' <a href="javascript: changeCurrentFilter(\'\');"><img src="images/close.gif" alt="clear filter" /></a>';
            }else{
              alert(data.reason);
            }
        },
        errorHandler:function(errorString, exception){ 
            alert("get tagbytagref error:" + errorString + exception);
        }
        });
    }else{  
      bct.currentFilter='';
      getContextConcerns('', 0, true, bct.showOnlyMyConcerns, bct.currentSort);
      $(bct.divFilteredBy).innerHTML = '';
      
    }
  }
  
  function customFilter(query, key){
    if (key.keyCode == 8 && query.length < 1){
      return false;  
    }
    if(query.length > 3){
      customFilterAction(query);  
    }
  }
  
  function customFilterAction(query){
      BCTAgent.searchTags({bctId:bct.bctId,tag:query},{
        callback:function(data){
            if (data.successful){
              if($(bct.divSearchResults).style.display == 'none'){
                new Effect.Appear(bct.divSearchResults, {duration: 0.5});    
              }    
              
              $(bct.divSearchResults).innerHTML = $(bct.divSearchResults).innerHTML = data.html;
              if (data.count == 0){
                $(bct.divSearchResults).innerHTML = '<a href="javascript:Effect.Fade(\''+bct.divSearchResults+'\', {duration: 0.5}); void(0);"><img src="images/close1.gif" border=0 class="floatRight"></a><p>No tag matches found! Please try a different search.</p> ';
              }
            }
        },
        errorHandler:function(errorString, exception){ 
              alert("sidebarSearchTagsAction: "+errorString+" "+exception);
              //showTheError();
        }    
      });  
  };


  //END BCT Cleanup


function toggleEditing(component, concernId){
  var concernBody = 'discussionText' + concernId;
  var concernTags = 'tagsUL' + concernId;
  var editConcern = 'editingArea' +concernId;
  var editTags = 'tagEditingArea' +concernId;  
  
  if(component == "concern"){
    ($(editTags).style.display != "none") ? Element.toggle(editTags) : '';
    Element.toggle(concernTags);
    Element.toggle(concernBody);
    Element.toggle(editConcern);
  }
  if(component == "tags"){
    ($(editConcern).style.display != "none") ? Element.toggle(editConcern) : '';
    ($(concernBody).style.display == "none") ? Element.toggle(concernBody) : '';
    ($(concernTags).style.display != "none") ? Element.toggle(concernTags) : '';
    Element.toggle(editTags);
  }  
}


function editConcernPopup(concernId){
var currentConcern = '';
BCTAgent.getConcernById(concernId, {

  callback:function(data){
    if (data.successful){
        currentConcern = data.concern.content;
        toggleEditing('concern', concernId);
        var editConcern = 'editingArea' +concernId;
          os = "";
          os += '<textarea style="" name="editConcern" id="editConcern" cols="50" rows="5">' +currentConcern+ '</textarea>';
          os += '<input type="button" id="modifyConcern" value="Submit Edits!" onclick="javascript:editConcern('+concernId+');"/>';
          os += '<input type="button" value="Cancel" onClick="javascript:toggleEditing(\'concern\', '+concernId+');">';
        $(editConcern).innerHTML = os;    
    }
  },
  errorHandler:function(errorString, exception){ 
      alert("editConcernPopup: "+errorString+" "+exception);
      //showTheError();
  }

});

}


function editConcern(concernId){
  var newConcern = $('editConcern').value;
  var concernBody = 'discussionText' + concernId;
  BCTAgent.editConcern({concernId:concernId, concern:newConcern}, <pg:wfinfo/>,{
    callback:function(data){
        if (data.successful){
          getContextConcerns(bct.currentFilter, bct.currentPage, false, bct.showOnlyMyConcerns, bct.currentSort);
        
        }  
    },
    errorHandler:function(errorString, exception){ 
      alert("editConcern: "+errorString+" "+exception);
      //showTheError();
    }
  });
}
  

function editTagsPopup(concernId){
  tagHolderId = 1;
  concernTags = "";

  BCTAgent.getConcernById(concernId, {
  callback:function(data) {
      if (data.successful){
      var tagDiv = 'tagEditingArea' +concernId;
      toggleEditing('tags', concernId);
          
      //Find Current Tags
          newConcernTagsArray = [];
          editingTags = data.concern.tags;
          for(i=0; i < editingTags.length; i++){
            addToConcernTagsArray(editingTags[i].tag.name, "checked");
          }
          $(tagDiv).innerHTML = renderEditingTags(concernId);  
        }
    },
    errorHandler:function(errorString, exception){ 
        alert("editTagsPopup: "+errorString+" "+exception);
        //showTheError();
    }
  });
}

  function renderEditingTags(concernId){
    os = '<ul  class="tagsList">' + renderTags(); + '</ul>';
    os += '<form action="javascript: addManualEditTag('+concernId+');"><input id="manualEditTag" type="text" />';
        os += '<input type="button" value="Add Tag" onClick="addManualEditTag('+concernId+');" /></form>';
        os += '<p><small>You must use at least 2 or more keywords/phrases to continue.</small></p>';
         os += '<div><hr><input type="button" id="subeditTags" value="Submit Edits" onClick="editTags('+concernId+')">';
    os += '<input type="button" value="Cancel" onClick="javascript:toggleEditing(\'tags\', '+concernId+');"></div>';
       return os;
  }

  function addManualEditTag(concernId){
    var tagDiv = 'tagEditingArea' + concernId;
    var manualTag = $('manualEditTag').value;
    if(manualTag != ""){
      addToConcernTagsArray(manualTag, "checked");  
      $('manualEditTag').value = ""; //clear textbox
      $(tagDiv).innerHTML = renderEditingTags(concernId);  
    }else{
      alert("Keyword/phase cannot be blank.");
    }
    
    //alert(tagDiv);
    //alert(manualTag);
    //for(i=0; i< newConcernTagsArray.length; i++){
    //  alert(newConcernTagsArray[i].tagName + " status:" + newConcernTagsArray[i].status);  
    //}
    
  }

function removeLastComma(str){
str = str.replace(/[\,]$/,'');
concernTags = str;
}

function editTags(concernId){
  getSelectedTags();
  if(newConcernSelectedTagsArray.length<bct.numTagsInNewConcern){
    alert("You must use at least "+ bct.numTagsInNewConcern +" keywords/phrases");
  }else{
  var newConcernSelectedTagsString = newConcernSelectedTagsArray.toString();
  //for (i=0; i<newConcernSelectedTagsArray.length; i++){
    //newConcernSelectedTagsString += newConcernSelectedTagsArray[i] + ',';  
  //}
  BCTAgent.editTags({concernId:concernId, tags:newConcernSelectedTagsString}, <pg:wfinfo/>,{
    callback:function(data){
      if (data.successful){ 
        getContextConcerns(bct.currentFilter, bct.currentPage, false, false, bct.currentSort);
      }else{
        alert(data.reason);  
      }
      
    },
    errorHandler:function(errorString, exception){ 
        alert("editTags: "+errorString+" "+exception);
        //showTheError();
    }
  });
  }
}

</script>

  <event:pageunload />
</head>
  
<body>
  <!-- Start Global Headers  -->
  <wf:nav />
  <wf:subNav />
  <!-- End Global Headers -->
  <!-- #container is the container that wraps around all the main page content -->
  <div id="container">
    <!-- begin "overview and instructions" area -->
    <div id="overview" class="box2">
      <h3>Overview and instructions</h3>
      <c:set var="current" value="${requestScope['org.pgist.wfengine.CURRENT']}" />
      <pg:narrow name="current"/>
      <pg:termHighlight styleClass="glossHighlight" url="glossaryView.do?id=">This is the �Brainstorm concern tool� section of the site. You have <strong>three</strong> tasks.<br><br>
      If you had the chance to tell someone your personal concerns about the regional impacts of global climate change on the Oregon coast, in 10 words or less, what would you say?
      <br><br>Please click �<strong>Read More</strong>� below to see how to use the �Brainstorm concern tool� to submit keywords/phrases, filter and deliberate about keywords/phrases, and modify your original concern keywords/phrases.</pg:termHighlight>
      <p>
        <a href="#" onclick="Effect.toggle('hiddenRM','blind'); return false"><pg:termHighlight styleClass="glossHighlight" url="glossaryView.do?id=">Read more</pg:termHighlight></a>
      </p>
      <p id="hiddenRM" style="display:none">
        <pg:termHighlight styleClass="glossHighlight" url="glossaryView.do?id="><i>Task one: Add your own keywords or keyphrases.</i> Consider a short but specific and personal concern keyword or keyphrase. For example, instead of just saying �coastal erosion,� you might say �paying more for my insurance because of risk of coastal erosion.� See the �Learn More� section of the VCC website for a list of possible coastal impacts of regional climate change. Remember that only the concern keywords/phrases will be used later on. Whatever you write as a concern is just an additional explanation about your keywords/phrases, provided to others to help them understand your concern. The system offers you �Previously suggested keywords/keyphrases,� which you can select using the checkboxes. However, we strongly suggest that you type in your own specific and personal 3 or 4 word or less concern keyphrase into the box labeled �Add Keyphrase.�
	<br><br><i>Task two: Filter and deliberate about other�s concern keywords/phrases.</i> Your second task is to filter down concern keywords/phrases to the ones you are most interested in, vote on them, and then provide comments to others. Vote as often as you can. Try to make comments on at least three other concerns, if not more. If someone comments on your concern, reply back to them and get a discussion going. To filter everyone else�s keywords/phrases, there are three different tools on the toolbar just above all the concerns. On the far left tool, you can enter a word into �Search concerns:� and search all keywords. In the middle tool, you can click �Browse keywords� in alphabetical order. In the far right tool, you can sort concerns and keyphrases in several different ways: by date added; by vote; and finally, by comments. To make a comment, click on �Comments,� which will take you to a new window.<br><br>
	<i>Task three: Re-evaluate your own concern keywords/phrases.</i> To filter only your own keywords/phrases and see if you have any comments yet, click the checkbox underneath �All participant�s concerns� labeled �Show only my concerns.� Look to see how many people voted to agree or disagree with your concern. Click on the �Comments� link to read other�s comments. After looking at other�s votes and comments on your concern, you have the option of modifying your original concern keywords/phrases or the text of your concern. To edit your concern keywords, click �Edit keywords� and enter a new keyword or keyphrase. You can delete a previous concern keyword or keyphrase by unchecking the box next to it. You will still need at least two keyword/phrases. To edit whatever you typed in to explain your concern, click �Edit concern,� edit the text, then click �Submit Edits!� To permanently delete a concern, click �Delete concern.� Your original keywords/phrases will not be deleted.</pg:termHighlight>
      </p>
    </div>
    <a name="filterJump"></a>
    <pg:show condition="${!bct.closed}">
    <div id="discussion" style="background-image: url('images/addConcern.gif'); background-repeat: no-repeat; background-position: 730px 0;">
    </pg:show>
    <pg:show condition="${bct.closed}">
    <div id="discussion">
    </pg:show>
      <div id="discussionHeader">
        <div class="sectionTitle">
          <h3 id="discussionTitle">All participants' concerns</h3>
          <div id="filteredBy"></div>
          <input type="checkbox" id="myconcerns" onClick="checkMyConcerns();"/>
          Show only my concerns </div>
        
    
        <!-- Begin sorting menu -->
        <div id="sortingMenu" class="box4"> 
          <form style="display:inline" 
        action="javascript: customFilterAction($('txtCustomFilter').value);">
            <span id="sm-left">Search concerns:
            <input type="text" id="txtCustomFilter" value="Add a filter" 
          onKeyUp="customFilter(this.value, event);"  onKeyUp="customFilter(this.value, event);" 
          onClick="javascript:if(this.value==this.defaultValue){this.value = ''}"/>
            </span> <span id="sm-middle"> <a href="javascript:getTagCloud();">Browse
            keywords</a> <a href="javascript:getTagCloud();"><img src="images/keyword-cloud.gif" alt="Click here for the Keyword Cloud" /></a></span>
          </form>
          <span id="sm-right"> Sort concerns by:
          <select name="selectsort" id="selectsort" 
        onChange="javascript:getContextConcerns(bct.currentFilter, 1, true, bct.showOnlyMyConcerns, this.value);  ">
            <option value="1">Newest to oldest</option>
            <option value="2">Oldest to newest</option>
            <option value="3">Most agreement</option>
            <option value="4">Least agreement</option>
            <option value="5">Most comments</option>
            <option value="6">Most views</option>
            <option value="7">Most votes</option>
          </select>
          </span>
          <div id="searchResults" style="display: none;"></div>
          <div class="clearBoth"></div>
        </div>
        <!-- End sorting menu -->
</div>
    
    <!-- start tag cloud -->
    <div id="tagCloud" class="discussion-left box2" style="display: none;">
      <!-- load "browse all tags" tag cloud -->
    </div>  
<!-- end tag cloud -->

      <div id="discussion-cont" class="floatLeft">
        <!-- left col -->
      </div>
      <!-- end left col -->
      <pg:show condition="${!bct.closed}">
      <div id="colRight" class="floatLeft box6 colRight">
        <!-- right col -->
        <h3>
          <textarea id="txtAddConcern" style="width:100%; border: 1px solid #FFC978; height: 100px;" onClick="if(this.value==this.defaultValue){this.value = ''}">Type in one concern about regional climate change. You can enter more later.</textarea>
        </h3>
        <div id="tagNewConcern" class="box6 padding5" style="display:none;">
          <h3>Keyword/phrase your concern</h3>
    <p><a href="litfaq.jsp#whattag" target="_blank" class="glossHighlight" title="Think of keywords as labels for quick understanding.">What is a keyword?</a> <img src="images/external.png" alt="(new window)"></p>
          <p>Previously suggested keywords/phrases:</p>
          <ul id="addConcernTagsList" class="tagsList">
            <!-- render suggested tags here -->
          </ul>
          <form action="javascript: addManualTag();">
            <input id="manualTag" type="text" size="10" value="Add keyword/phrase" onClick="if(this.value==this.defaultValue){this.value = ''}"/>
            <input type="button" value="Add Keyphrase" onClick="addManualTag();" />
          </form>
          <p><small>You must use at least 2 or more keywords to continue.</small></p>
        </div>
        <div id="btnContinueCont">
          <input id="btnContinue" type="button" value="Continue" onClick="prepareConcern();" />
        </div>
      </div>
      <!-- end right col -->
      </pg:show>
      <div class="clearBoth"></div>
    </div>
    <!-- end discussion -->
  </div>
  <!-- end container -->
  
<!-- start feedback form -->
  <pg:feedback id="feedbackDiv" action="bctView.do"/>
<!-- end feedback form -->

<!-- Start Global Headers  -->
    <wf:subNav />
<!-- End Global Headers -->

  <!-- Begin footer -->
  <div id="footer">
    <jsp:include page="/footer.jsp" />
  </div>
  <!-- End footer -->
  
   
  <script type="text/javascript">
    getContextConcerns('', 1, false, bct.showOnlyMyConcerns, bct.currentSort);
  </script>
  </body>
</html>
