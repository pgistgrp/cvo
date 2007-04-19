<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://www.pgist.org/pgtaglib" prefix="pg" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html:html>
	<head>
	<title>Let's Improve Transportation - Registration</title>
	<!-- Site Wide CSS -->
<style type="text/css" media="screen">
@import "styles/lit.css";
@import "styles/registration-1.css";
@import "styles/registration-2a.css";
@import "styles/registration-2b.css";
@import "styles/registration-questionnaire.css";
</style>
<!-- End Site Wide CSS -->
<!-- Site Wide JS -->
<script src="scripts/prototype.js" type="text/javascript"></script>
<script src="scripts/scriptaculous.js?load=effects,dragdrop" type="text/javascript"></script>
<script src="scripts/search.js" type="text/javascript"></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<script type='text/javascript' src='/dwr/interface/SystemAgent.js'></script>
<script type='text/javascript' src='/dwr/interface/RegisterAgent.js'></script>

<script type="text/javascript">
function submit2A() {
	var errordiv = document.getElementById("errors");
	var errormsg = "";

	var interview1 = document.formreg2a.interview[0].checked;
	var interview2 = document.formreg2a.interview[1].checked;
	//var observation = form.observation.value;
	var observation1 = document.formreg2a.observation[0].checked;
	var observation2 = document.formreg2a.observation[1].checked;

	RegisterAgent.addQuotaInfo({interview:interview1, observation:observation1});
	Element.toggle('reg2a');
	Element.toggle('regq');
	getVehicles();
}
</script>
</head>
<body>

<!--[if IE]>
	<style type="text/css">
		fieldset p {padding-bottom:1px;}
	</style>
<![endif]-->

<!-- Begin the header - loaded from a separate file -->
<div id="header">
	<!-- Begin header -->
	<jsp:include page="/header.jsp" />
	<!-- End header -->
</div>
<!-- End header -->
<!-- Begin header menu - The wide ribbon underneath the logo -->
<div id="headerMenu"> </div>
<!-- End header menu -->
<!-- #container is the container that wraps around all the main page content -->
<div id="container">

	
<!-- start #reg2a -->
<div id="reg2a" style="display:none">
	<div>
		<h3>Welcome SUVdriver. You qualify to participate in Let's Improve Transportation!</h3>
		<p>Congratulations! You are eligible to receive $50 if you participate in the
			entire Let�s Improve Transportation decision process (AKA the �LIT Challenge�).
			To receive payment you must complete two questionnaires and participate in each
			of 5 steps in the LIT Challenge. You can participate at your own convenience
			wherever you have access to the Internet. The LIT Challenge will take place over
			a 4 week period, starting October 1, 2007 and concluding October 29, 2007. We
			estimate that full participation will take about 8 hours of your time, spread
			out over the 4-week period. However you are encouraged to spend as much time
			on the LIT website as you like. Details about the requirements for payment can
			be found in the participant consent form at the bottom of this page. If you prefer,
			you can also choose to participate as an <a href="#">unpaid volunteer</a>, with
			no requirements for your participation.</p>
	</div>
	<!-- begin OPPORTUNITIES -->
	<form name="formreg2a">
	<fieldset>
	<legend>Additional opportunities for paid participation in our research study</legend>
	<p>In addition to your participation in the LIT challenge you are invited to also
		participate in these other parts of our research study. Payment would be made
		upon completion of both the LIT Challenge and the extra activities selected. Please
		indicate your interest in additional research study opportunities below. </p>
	<p>
		<span class="consent-label">1 hour, face-to-face interview on UW Seattle Campus:</span> 
		<span class="consent-value">
			<label>
				<input type="radio" name="interview" value="yes" checked="checked" /> Yes, I'm interested
			</label>
			<label>
				<input type="radio" name="interview" value="no" /> No, I'm not interested
			</label><br/>
			<small>Must meet on campus for 1 hour, audiotaped interview. A researcher will contact
			you to schedule an appointment; $50</small>
		</span>
	</p><br />
	
	<div class="clearBoth"></div>
			
	<p>
		<span class="consent-label">30 minute observation of you using the website: </span> 
		<span class="consent-value">
			<label>
				<input type="radio" name="observation" value="yes" checked="checked" /> Yes, I'm interested
			</label>
			<label>
				<input type="radio" name="observation" value="no" /> No, I'm not interested
			</label><br/>
			<small>Must meet on campus for 30 minutes, video/audio recorded interview. A researcher will contact you to schedule an appointment; $20</small>
		</span>
	</p><br/>
	</fieldset>
	
	<fieldset>
		<legend>Review the Informed Consent Agreement</legend>
		<p>If you wish to be a paid participant in our research study, you must review and accept this Informed Consent Agreement.</p>
		<div id="agreement" class="box3">
		<h3>1. INVESTIGATORS STATEMENT</h3>
		
		<p>We are asking you to be in a research study. The purpose of this consent form
			is to give you the information you will need to help you decide whether or not
			to be in the study. Please read the form carefully. When you are finished reading
			this form, you can decide if you want to be in the study or not. This process
			is called �informed consent�.</p>
		<h3>2. PURPOSE OF THE STUDY</h3>
		<p>We want to better understand the opinions and feelings of the public regarding
			transportation improvement decision-making in the Seattle metropolitan area.
			We would like to ask that you participate fully in this decision-making situation,
			and could ask you to.</p>
		<h3>3. MORE STUFF</h3>
		<p>We are asking you to be in a research study. The purpose of this consent form
			is to give you the information you will need to help you decide whether or not
			to be in the study. Please read the form carefully. When you are finished reading
			this form, you can decide if you want to be in the study or not. This process
			is called �informed consent�.</p>
		</div>
	</fieldset>
	<!-- end OPPORTUNITIES -->
	<div class="clearBoth"></div>
	
	<div id="step-bar" class="box5 padding5 clearfix">
			<p class="floatLeft" id="step-progress">Step 2 of 3</p>
			<p class="floatLeft" id="submit-description" style="width:420px;">By clicking �I Agree� you (a) agree to the �informed consent� above and (b) agree to receive required notices from Let�s Improve Transportation electronically.</p>
			<p class="floatRight" id="submit-button"><input type="button" value="I Agree" style="font-size:1.5em;" onClick="submit2A()" /> <input type="button" value="I Do Not Agree" style="font-size:1.5em;" onClick="cancel()"/></p>
		</div>
	
</div>
<!-- end #reg2a -->	
	
	
</div>
<!-- end container -->
<!-- start feedback form -->
<pg:feedback id="feedbackDiv" action="cctView.do"/>
<!-- end feedback form -->
<!-- Begin header menu - The wide ribbon underneath the logo -->
<div id="headerMenu"> </div>
<!-- Begin footer -->
<div id="footer">
	<jsp:include page="/footer.jsp" />
</div>
<!-- End footer -->

</body>
</html:html>