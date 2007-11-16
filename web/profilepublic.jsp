<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html:html>
<head>
<title>Let's Improve Transportation: Eros Profile</title>

<style type="text/css" media="screen">
@import "styles/lit.css";

/* HTML */
/* ---- */

body{font-size:12pt;}

div.heading h4 {margin:0em;}

.heading {margin:.5em 0em;}

/* CONTAINER */
/* --------- */

#container h3.headerColor {margin-right:1em}

#container {margin-bottom:2em}

/* PROFILE-FIELDS */
/* -------------- */

#profile-fields
{
float:left;
}

.label 
{
float:left;
font-size:.9em;
font-weight:bold;
width:150px;
margin-right:2em;
}

#profile-fields p {padding-bottom:0px;}

span.value span {margin-right:4em;}

.value {float:left;}


.profile-col1
{
width:490px;
margin-left:1em;
}

.profile-col2
{
width:100px;
text-align:center;
}

/* STATISTICS */
/* ---------- */

#statistics
{
width:400px;
float:right;
padding:.5em;
}

#statistics .label{width:200px;}

#statistics .value{}

#statistics p {margin:0px;padding:0px;}

#statistics h4{text-align:center;margin:.5em 0em 1em 0em;}

/* CONCERNS */
/* -------- */

#concerns-keywords {font-size:.9em}

.tagSize1{font-size:.9em;}
.tagSize2{font-size:1.1em;}
.tagSize3{font-size:1.3em;}
.tagSize4{font-size:1.5em;}
.tagSize5{fontis-ze:1.6em;}

#concerns-keywords span 
{
float:left;
font-weight:bold;
margin:10px 0px;
}

.concern 
{
width:600px;
padding:.5em;
font-size:.9em;
margin-bottom:.5em;
}

/* WEIGHTS */
/* ------- */


#weights 
{
width:400px;
float:left;
}

#weights .label {width:150px;}

.weights-col1
{
width:290px;
margin-left:1em;
}

.weights-col2
{
width:100px;
text-align:center;
}


/* KEYWORDS */
/* -------- */

#keywords ul, #concerns-keywords ul
{
margin:10px 0px;
padding:0px;
}

#keywords li, #concerns-keywords li
{
list-style-type:none;
display:inline;
padding:.2em;
margin:.2em;
line-height:2em;
border:1px solid #FFE3B9;
background:#FFF1DC;
}

</style>

<script type="text/javascript">

</script>

</head>
<body>
	<!--[if IE]>
		<style type="text/css">
			fieldset p {padding-bottom:1px;}
		</style>
	<![endif]-->
<!-- Begin header -->
<div id="header"> [Load from separate file] </div>
<!-- End header -->
<!-- Begin header menu - The wide ribbon underneath the logo -->
<div id="headerMenu">
	<div id="headerContainer">
		<div id="headerTitle" class="floatLeft">
			<h3 class="headerColor">Learn More</h3>
		</div>
		<div class="headerButton floatLeft currentBox"> <a href="#">About LIT</a> </div>
		<div class="headerButton floatLeft"> <a href="#">FAQ</a></div>
		<a href="#"> </a>
		<div class="headerButton floatLeft"><a href="#"> </a><a href="#">Tutorial</a></div>
		<a href="#"> </a>
		<div class="headerButton floatLeft"><a href="#"> </a><a href="#">Proposed
				Projects</a></div>
		<a href="#"> </a>
		<div class="headerButton floatLeft"><a href="#"> </a><a href="#">Glossary</a></div>
		<a href="#"> </a>
		<div class="headerButton floatLeft"><a href="#"> </a><a href="#">Additional
				Resources</a></div>
		<a href="#"> </a>
		<div id="headerNext" class="floatRight box5"><a href="#"> </a><a href="#">Next
				Step</a> </div>
	</div>
</div>
<!-- End header menu -->
<!-- Begin container - Main page content begins here -->
<div id="container" class="clearfix">
	<p><h3 class="headerColor" style="display:inline">LIT Participant Profile</h3>
	<pg:show roles="participant"><a href="#">Edit my profile and settings</a></p></pg:show>
	<!-- start PROFILE-FIELDS section -->
	<div id="profile-fields">
		<div id="statistics" class="box9">
			<h4 class="headerColor">My statistics</h4>
			<p>
				<span class="label">Last visit to LIT website:</span>
				<span class="value">10/24/06, 3:45pm</span>
			</p><br />
			<p>
				<span class="label">Total Visits to LIT website:</span>
				<span class="value">22</span>
			</p><br />
			<p>
				<span class="label"># of discussion posts:</span>
				<span class="value">3</span>
			</p><br />
		</div>
		<p>
			<span class="label">Username</span>
			<span class="value">${user.loginname}</span>
		</p><br />
		<p>
			<span class="label">Home location</span>
			<span class="value">${user.city}, ${user.zipcode} [map]</span>
		</p><br />
		<p>
			<span class="label">Work Location</span>
			<span class="value">${user.workCity}, ${user.workZipcode}[map]</span>
		</p><br />
		<p>
			<span class="label">Vocation</span>
			<span class="value">${user.vocation}</span>
		</p><br />
		<p>
			<span class="label">Methods of transportation</span>
			<span class="value"><span>${user.primaryTransport}</span>
		</p><br />
		<div class="clearBoth"></div>
		<p>
			<span class="label">Why I'm here</span> 
			<span class="value" style="width:700px;">${user.profileDesc}</span> 
		</p>
		<br />
	
		<div class="clearBoth"></div>

		<p>
			<span class="label">My tags</span>
	  <span class="value" id="keywords" style="width:600px;">
				<ul>
					<li class="tagSize5">Accidents</li>
					<li class="tagSize3">Assurance</li>
					<li class="tagSize3">engineering</li>
					<li class="tagSize3">Fatalities</li>
					<li class="tagSize2">Highway</li>
					<li class="tagSize3">Injuries</li>
					<li class="tagSize5">Insurance</li>
					<li class="tagSize2">investigation</li>
					<li class="tagSize3">records</li>
					<li class="tagSize5">statistics</li>
					<li class="tagSize3">systems</li>
					<li class="tagSize3">Traffic</li>
				</ul>
	  </span>
		</p><br />
		
		<div class="clearBoth"></div>
		<p>
			<span class="label">My concerns</span> 
	  <span class="value">
				<div id="concerns">
					<div class="concern box7">
						There are no bike lanes in any of the "regionally significant" projects. 
						This is absurd.  When are we going to consider bikes a viable means of 
						daily transportation?
						<br />
						<div id="concerns-keywords">
							<span>Keywords:</span>
							<ul>
								<li>Amet</li>
								<li>Dolor</li>
								<li>Ipsum</li>
								<li>Lorem</li>
								<li>Sit</li>
							</ul>
						</div>
					</div>

					<div class="concern box7">
						There are no bike lanes in any of the "regionally significant" projects. 
						This is absurd.  When are we going to consider bikes a viable means of 
						daily transportation?
						<br />
						<div id="concerns-keywords">
							<span>Keywords:</span>
							<ul>
								<li>Amet</li>
								<li>Dolor</li>
								<li>Ipsum</li>
								<li>Lorem</li>
								<li>Sit</li>
							</ul>
						</div>
					</div>
					
					<div class="concern box7">
						There are no bike lanes in any of the "regionally significant" projects. 
						This is absurd.  When are we going to consider bikes a viable means of 
						daily transportation?
						<br />
						<div id="concerns-keywords">
							<span>Keywords:</span>
							<ul>
								<li>Amet</li>
								<li>Dolor</li>
								<li>Ipsum</li>
								<li>Lorem</li>
								<li>Sit</li>
							</ul>
						</div>
					</div>

				</div>
	  </span> 
		</p><br />
		
		<div class="clearBoth"></div>
		<p>
			<span class="label">My recent discussion activity</span>
	  <span class="value">
				<div id="profile-recent" style="width:600px;">
	
					<!-- begin RECENT DISCUSSIONS HEADER -->
					<div>
						<div class="floatLeft clearfix"><a href="#">Prev</a></div>
						<div class="floatRight clearfix"><a href="#">Next</a></div>
					</div>
					
					<div class="clearBoth"></div>
				
					<div class="listRow headingColor heading clearfix">
						<div class="profile-col1 floatLeft" style="margin-left:.2em">
							<div class="floatLeft">
								<h4>Topic</h4>
							</div>
						</div>
						<div class="profile-col2 floatRight">
							<h4>Last Post</h4>
	
						</div>
					</div>
					<!-- end RECENT DISCUSSIONS HEADER -->
					<!-- begin A RECENT DISCUSSION -->
					<div class="listRow clearfix">
						<div class="profile-col1 floatLeft">
							<div class="floatLeft">
								<a href="#">Rebuild the viaduct!</a><br />
	
								<span>Step 3a: Review Projects</span>
							</div>
						</div>
						<div class="profile-col2 floatRight">1/31</div>
					</div>
					<!-- end A RECENT DISCUSSION -->
					<div class="listRow odd clearfix">
						<div class="profile-col1 floatLeft">
	
							<div class="floatLeft">
								<a href="#">Rebuild the viaduct but don't spend any more money</a><br />
								<span>Step 3a: Review Projects</span>
							</div>
						</div>
						<div class="profile-col2 floatRight">1/31</div>
					</div>
	
					<div class="listRow  clearfix">
						<div class="profile-col1 floatLeft">
							<div class="floatLeft">
								<a href="#">Rebuild the viaduct!</a><br />
								<span>Step 3a: Review Projects</span>
							</div>
						</div>
						<div class="profile-col2 floatRight">1/31</div>
	
					</div>
					<div class="listRow odd clearfix">
						<div class="profile-col1 floatLeft">
							<div class="floatLeft">
								<a href="#">Rebuild the viaduct!</a><br />
								<span>Step 3a: Review Projects</span>
							</div>
						</div>
	
						<div class="profile-col2 floatRight">1/31</div>
					</div>
					<div class="listRow  clearfix">
						<div class="profile-col1 floatLeft">
							<div class="floatLeft">
								<a href="#">Rebuild the viaduct!</a><br />
								<span>Step 3a: Review Projects</span>
	
							</div>
						</div>
						<div class="profile-col2 floatRight">1/31</div>
					</div>
				</div>
				<!-- end RECENT DISCUSSIONS -->
	
	</div>
			</span>
		</p><br />				
		<div class="clearBoth"></div>
		
		<p>
			<span class="label">My planning factor weights</span>
	<span class="value">
				<div id="weights" style="width:600px;">

					<!-- begin RECENT DISCUSSIONS HEADER -->				
					<div class="listRow headingColor heading clearfix">
						<div class="profile-col1 floatLeft" style="margin-left:.2em">
							<div class="floatLeft">
								<h4>Planning Factor</h4>
							</div>
						</div>
						<div class="profile-col2 floatRight">
							<h4>Weights</h4>
						</div>
					</div>
					<!-- end RECENT DISCUSSIONS HEADER -->
					<!-- begin A RECENT DISCUSSION -->
					<div class="listRow clearfix">
						<div class="profile-col1 floatLeft">
							<div class="floatLeft">
								Economic Vitality
							</div>
						</div>
						<div class="profile-col2 floatRight">10</div>
					</div>
					<!-- end A RECENT DISCUSSION -->
					<div class="listRow odd clearfix">
						<div class="profile-col1 floatLeft">
	
							<div class="floatLeft">
								Security
							</div>
						</div>
						<div class="profile-col2 floatRight">13</div>
					</div>
	
					<div class="listRow  clearfix">
						<div class="profile-col1 floatLeft">
							<div class="floatLeft">
								Accessibility and Mobility
							</div>
						</div>
						<div class="profile-col2 floatRight">23</div>
	
					</div>
					<div class="listRow odd clearfix">
						<div class="profile-col1 floatLeft">
							<div class="floatLeft">
								Environmental / Energy / QOL
							</div>
						</div>
	
						<div class="profile-col2 floatRight">3</div>
					</div>
					<div class="listRow  clearfix">
						<div class="profile-col1 floatLeft">
							<div class="floatLeft">
								Integration and Connectivity
							</div>
						</div>
						<div class="profile-col2 floatRight">8</div>
					</div>
				</div>
				<!-- end RECENT DISCUSSIONS -->

  </div>
			</span>
	</div>
	</p><br />
	<div class="clearBoth"></div>
	<!-- end PROFILE-FIELDS section -->
</div>
<!-- End Container -->
<!-- Begin header menu - The wide ribbon underneath the logo -->
<div id="headerMenu">
	<div id="headerContainer">
		<div id="headerTitle" class="floatLeft">
			<h3 class="headerColor">Learn More</h3>
		</div>
		<div class="headerButton floatLeft currentBox"> <a href="#">About LIT</a> </div>
		<div class="headerButtonCurrent floatLeft"> <a href="#">FAQ</a></div>
		<a href="#"> </a>
		<div class="headerButtonCurrent floatLeft"><a href="#"> </a><a href="#">Tutorial</a></div>
		<a href="#"> </a>
		<div class="headerButtonCurrent floatLeft"><a href="#"> </a><a href="#">Proposed
				Projects</a></div>
		<a href="#"> </a>
		<div class="headerButtonCurrent floatLeft"><a href="#"> </a><a href="#">Glossary</a></div>
		<a href="#"> </a>
		<div class="headerButtonCurrent floatLeft"><a href="#"> </a><a href="#">Additional
				Resources</a></div>
		<a href="#"> </a>
		<div id="headerNext" class="floatRight box5"><a href="#"> </a><a href="#">Next
				Step</a> </div>
	</div>
</div>
<!-- End header menu -->
<!-- end the bottom header menu -->
<!-- Begin footer -->
<div id="footer"> </div>
<!-- End footer -->
</body>
</html:html>
