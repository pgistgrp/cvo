package org.pgist.tags;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.SimpleTagSupport;

import org.pgist.wfengine.EnvironmentInOuts;
import org.pgist.wfengine.RunningContext;
import org.pgist.wfengine.activity.PGameActivity;


/**
 * 
 * @author kenny
 *
 */
public class WorkflowPropertyTag extends SimpleTagSupport {
    
    
    private static final long serialVersionUID = 1L;
    
    private PGameActivity activity;
    
    private String var;
    
    private String name;
    
    
    public void setActivity(PGameActivity activity) {
        this.activity = activity;
    }


    public void setVar(String var) {
        this.var = var;
    }


    public void setName(String name) {
		this.name = name;
	}
    
    
    /*
     * ------------------------------------------------------------------------
     */
    
    
	public void doTag() throws JspException, IOException {
        PageContext context = (PageContext) getJspContext();
        HttpServletRequest request = (HttpServletRequest) context.getRequest();
        JspWriter writer = getJspContext().getOut();
        
        EnvironmentInOuts inouts = null;
        
        if (activity!=null) {
            inouts = new EnvironmentInOuts(
                (RunningContext) request.getAttribute("org.pgist.wfengine.CONTEXT"),
                activity.getDeclaration()
            );
        } else {
            inouts = (EnvironmentInOuts) request.getAttribute("org.pgist.wfengine.INOUTS");
        }
        
        String property = null;
        
        if (inouts!=null) {
        	property = inouts.getProperty(name);
        }
        
        if (var!=null) {
            request.setAttribute(var, property);
        } else {
            writer.write(property);
        }
    }//doTag()
    
    
}//class WorkflowPropertyTag