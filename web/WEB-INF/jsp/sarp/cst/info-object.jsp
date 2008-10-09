<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.pgist.org/pgtaglib" prefix="pg" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<div id="col-left" style="float:left;width:30%;overflow:auto;height:300px;border-right:1px solid #B4D579;">
  <b>Categories:</b>
  <table id="catTable" width="100%" cellpadding="2" cellspacing="0">
  <c:forEach var="category" items="${infoObject.target.winnerCategory.children}" varStatus="loop">
    <c:choose>
      <c:when test="${loop.first}">
      <tr id="catRow-${category.id}">
        <td style="width:4em;"><a id="catcmp-${category.id}" style="display:none;cursor:pointer;" href="javascript:catTree.category1Clicked(${category.id});">compare</a></td>
        <td style="width:3px;"></td>
        <td id="catCol-${category.id}" align="left" style="font-weight:bold;cursor:pointer;" onclick="catTree.category0Clicked(${category.id})">${pg:purify(category.catRef.category.name)}</td>
      </tr>
      </c:when>
      <c:otherwise>
      <tr id="catRow-${category.id}">
        <td style="width:4em;border-top:1px dotted red;"><a id="catcmp-${category.id}" style="display:none;cursor:pointer;" href="javascript:catTree.category1Clicked(${category.id});">compare</a></td>
        <td style="width:3px;border-top:1px dotted red;"></td>
        <td id="catCol-${category.id}" align="left" style="border-top:1px dotted red;font-weight:bold;cursor:pointer;" onclick="catTree.category0Clicked(${category.id})">${pg:purify(category.catRef.category.name)}</td>
      </tr>
      </c:otherwise>
    </c:choose>
  </c:forEach>
  </table>
</div>

<div id="col-right1" style="overflow:auto;height:300px;text-align:center;">
  <div style="width:49%;overflow:none;height:298px;float:left;border-right:1px solid #B4D579;">
    <div style="background-color:#D6E7EF;font-weight:bold;">Category: "<span id="catTop"></span>":</div>
    <div id="tagsTop"></div>
  </div>
  <div style="width:49%;overflow:none;height:298px;float:left;">
    <div style="background-color:#FFF1DC;font-weight:bold;">Category: "<span id="catBottom"></span>":</div>
    <div id="tagsBottom"></div>
  </div>
</div>

<div id="col-right2" style="overflow:hidden;clear:both;height:20px;border-top:1px solid #B4D579;">
  <div style="float:left;overflow:hidden;">
    Moderator Announcements: &nbsp;&nbsp;&nbsp;&nbsp;
    <span style="cursor:pointer;color:blue;text-decoration:underline;" onclick="infoObject.getAnnouncements();">Refresh</span>
  </div>
	<pg:show roles="moderator">
    <div style="float:right;clear:right;">
      <span style="cursor:pointer;color:blue;text-decoration:underline;" onclick="$('announceEditor').style.display = 'block';">Create Announcements</span>
    </div>
	</pg:show>
</div>
<div id="col-right3" style="overflow:auto;clear:both;height:270px;border-top:1px solid #B4D579;">
	<pg:show roles="moderator">
    <div id="announceEditor" style="display:none;position:relative;clear:both;width:98%;height:80%;">
    Title: <br><input id="announceEditor_title" type="text" size="32"><br>
    Description: <br><textarea id="announceEditor_description" rows="5" style="width:600px;"></textarea><br>
    <input type="button" value="Submit" onclick="infoObject.createAnnouncement();">
    <input type="button" value="Cancel" onclick="$('announceEditor').style.display = 'none';">
    </div>
	</pg:show>
  <center>
    <div id="announcements" style="clear:both;padding:2px;overflow:auto;width:98%;height:80%;">
      <jsp:include page="../drt/drtAnnouncements.jsp" />
    </div>
  </center>
</div>
