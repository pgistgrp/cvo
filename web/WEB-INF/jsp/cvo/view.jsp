<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://www.pgist.org/pgtaglib" prefix="pg" %>
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<html:html>
<head>
<title>CVO</title>
<link rel="stylesheet" type="text/css" href="<html:rewrite page='/styles/default.css'/>">
<script type='text/javascript' src='<html:rewrite page="/scripts/base.js"/>'></script>
<script type='text/javascript' src='<html:rewrite page="/dwr/engine.js"/>'></script>
<script type='text/javascript' src='<html:rewrite page="/dwr/util.js"/>'></script>
<script type='text/javascript' src='<html:rewrite page="/dwr/interface/CVOAgent.js"/>'></script>
<script>
  var pgistTimer = {
    start : function() {
      setTimeout(this.run, 60000, this);
    },
    stop : function() {
      clearTimeout(timer);
    },
    run : function(timer) {
      var params = {
        cvoId : $('cvoId').value,
        myPost : '1'
      };
      CVOAgent.getPostGroups(reloadPostGroups, params);
      timer.start();
    }
  };
  function extractConcern() {
    var reply = $('reply');
    if (reply.value=='') {
      alert('Please give your reply.');
      return;
    }
    reply.disabled = true;
    CVOAgent.extractConcern(extractConcern_callback, reply.value);
  }
  function extractConcern_callback(data) {
    $('concern').value = data['concern'];
    $('step2').style.display='inline';
  }
  function sendReply() {
    CVOAgent.createConcern($('cvoId').value, $('reply').value, $('concern').value, createConcern_callback);
  }
  function createConcern_callback(data) {
    if (data['result']=='true') {
      $('reply').value = '';
      $('concern').value = '';
      $('step2').style.display='none';
      $('reply').disabled = false;
      var params = {
        cvoId : $('cvoId').value,
        myPost : '0'
      };
      CVOAgent.getPostGroups(reloadMyPostGroups, params);
      params['myPost'] = '1';
      CVOAgent.getPostGroups(reloadPostGroups, params);
    } else {
      alert(data['alert']);
    }
  }
  function reloadPostGroups(text) {
    $('postGroups').innerHTML = text;
  }
  function reloadMyPostGroups(text) {
    $('myPostGroups').innerHTML = text;
  }
  function postReply(id) {
    CVOAgent.getPost(id, getPost_callback);
  }
  function getPost_callback(data) {
    var post = data['post'];
    $('createCommentDialog_id').value = post['id'];
    $('createCommentDialog_title').innerHTML = 'User '+post.owner.loginname+' said:';
    $('createCommentDialog_replyto').value = post.content;
    $('createCommentDialog_reply').value = '';
    createCommentDialog.popup();
  }
  function createReply() {
    var content = $('createCommentDialog_reply').value;
    if (content.length<1) {
      alert('Please input your comment.');
      return;
    }
    CVOAgent.createPost($('cvoId').value, $('createCommentDialog_id').value, content, createPost_callback);
  }
  function createPost_callback(data) {
    if (data['result']=='true') {
      createCommentDialog.close();
      var params = {
        cvoId : $('cvoId').value,
        myPost : '0'
      };
      CVOAgent.getPostGroups(reloadMyPostGroups, params);
      params['myPost'] = '1';
      CVOAgent.getPostGroups(reloadPostGroups, params);
    } else {
      alert(data['alert']);
    }
  }
</script>
<event:pageunload />
</head>
<body bgcolor="white" onLoad="pgistTimer.start();">

<pg:dialog id="createCommentDialog" width="400" height="500">
  <input type="hidden" id="createCommentDialog_id" value="">
  <table width="100%" cellpadding="0" cellspacing="0">
    <tr>
      <td id="createCommentDialog_title"></td>
    </tr>
    <tr>
      <td><textarea id="createCommentDialog_replyto" style="width:100%;height:150px;color:red;" class="inputbox" readonly value=""></textarea></td>
    </tr>
    <tr>
      <td>Please input your comment:</td>
    </tr>
    <tr>
      <td><textarea id="createCommentDialog_reply" style="width:100%;height:200px;color:blue;" class="inputbox" value=""></textarea></td>
    </tr>
    <tr>
      <td align="center"><input type="button" value="Submit" onClick="createReply();"/></td>
    </tr>
  </table>
</pg:dialog>

<form>
<input type="hidden" id="cvoId" value="${cvoForm.cvo.id}">
<div class="cvotitle">CVO: <bean:write name="cvoForm" property="cvo.name"/></div>
<table width="100%" cellpadding="10">
  <tr>
    <td width="50%" valign="top">
      <table width="100%">
        <tr>
          <td width="100%">
            <div width="100%">
              <span>Q: <bean:write name="cvoForm" property="root.content"/></span>
              <textarea id="reply" style="width:100%;height:80px;" class="inputbox"></textarea>
            </div>
            <center>
              <input type="button" value="OK" onClick="extractConcern();">
            </center>
          </td>
        </tr>
      </table>
      <table width="100%" id="step2" style="display:none;">
        <tr>
          <td>
            <table width="100%">
            <tr>
              <td>Do you mean your concern can be summarized as follows?</td>
            </tr>
            <tr>
              <td nowrap>
                <input type="text" id="concern" style="width:400px;" value="">
                <input type="button" value="Submit" onClick="sendReply();">
              </td>
            </tr>
            </table>
          </td>
        </tr>
      </table>
      <table width="100%">
        <tr>
          <td width="100%">
            <div style="border-top:1px solid blue; padding-top:10px;">
              Your concerns:
            </div>
          </td>
        </tr>
        <tr>
          <td id="myPostGroups" width="100%">
            <jsp:include page="myPostGroups.jsp"/>
          </td>
        </tr>
      </table>
    </td>
    <td valign="top">
      <table width="100%">
      <tr>
        <td id="postGroups" width="100%">
        <jsp:include page="postGroups.jsp"/>
        </td>
      </tr>
      </table>
    </td>
  </tr>
</table>
</form>

</body>
</html:html>

