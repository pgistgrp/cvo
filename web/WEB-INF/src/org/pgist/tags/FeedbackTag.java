package org.pgist.tags;

import java.io.IOException;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.SimpleTagSupport;


/**
 * 
 * @author kenny
 *
 */
public class FeedbackTag extends SimpleTagSupport {
    
    
    private static final long serialVersionUID = 1L;
    
    
    private String id = "feedback";
    
    private String style = "";
    
    private String styleClass = "";
    
    private String action = "";
    
    
    public void setId(String id) {
        this.id = id;
    }


    public void setStyle(String style) {
        this.style = style;
    }


    public void setStyleClass(String styleClass) {
        this.styleClass = styleClass;
    }


    public void setAction(String action) {
        this.action = action;
    }


    /*
     * ------------------------------------------------------------------------
     */
    
    
    public void doTag() throws JspException, IOException {
        JspWriter writer = getJspContext().getOut();
        
        writer.write("<div id=\"feedbackForm\" style=\"display:none;\">");
        writer.write("<div style='float:right;'><a href=\"javascript:Effect.toggle('feedbackForm','blind');\"><img src=\"/images/closeinactivesm.gif\" alt=\"close Feedback Form\" onmouseover=\"javascript:this.src='/images/closeactivesm.gif'; this.style.cursor='pointer'; \" onmouseout=\"javascript:this.src='/images/closeinactivesm.gif'; this.style.cursor='auto';\" border=\"0\"></a></div>");
       
        writer.write("<h3>Feedback/Bug Report Form</h3>");
        writer.write("<p>If you came across a bug, please help us by reporting it to our development team. Please describe bugs and issues in as much detail as possible.</p>");
        
        //      external js files
        writer.write("<script src=\"/dwr/interface/SystemAgent.js\"></script>");
        
        writer.write("<script>");
        writer.write("function createFeedback() {");
        writer.write("  s = $('feedback_input').value;");
        writer.write("  if (s.length==0) { alert('Please input your feedback.'); return; }");
        writer.write("  action = '"+action+"';");
        writer.write("  SystemAgent.createFeedback(");
        writer.write("    {feedback:s, action:action}, function(data) {");
        writer.write("      if (data.successful) { alert('You feedback is submitted. Thank you.'); $('feedback_input').value=''; }");
        writer.write("      else { alert(data.reason); }");
        writer.write("    }");
        writer.write("  );");
        writer.write("}");
        writer.write("</script>");
        
        writer.write("<div id=\"feedbackDiv\">Feedback:<br><textarea id=\"feedback_input\"></textarea><br><input value=\"Submit\" onclick=\"createFeedback();javascript:Effect.toggle('feedbackForm','blind')\" type=\"button\"></div>");

        writer.write("</div>");
        
        //user msg
        writer.write("<p>Found a bug? Problem accessing a part of the page? <a href=\"#feedbackForm\" onclick=\"javascript:Effect.toggle('feedbackForm','blind'); setTimeout('location.hash=\\\'#feedbackDiv\\\';',900);\">Send us feedback.</a></p>"); 
 
    }//doTag()
    
    
}//class FeedbackTag
