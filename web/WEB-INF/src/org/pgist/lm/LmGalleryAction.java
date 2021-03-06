package org.pgist.lm;

import java.util.Collection;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

/**
 * 
 * @author John
 *
 */
public class LmGalleryAction extends Action {

	public LmGalleryAction() {
    }
	
	private LmService lmService;
	
    
    public void setLmService(LmService lmService) {
		this.lmService = lmService;
	}


	public ActionForward execute(
            ActionMapping mapping,
            ActionForm form,
            javax.servlet.http.HttpServletRequest request,
            javax.servlet.http.HttpServletResponse response
    ) throws java.lang.Exception {
        
		Collection projects = lmService.getProjects();
    	
		request.setAttribute("projects", projects);
		request.setAttribute("PGIST_SERVICE_SUCCESSFUL", true);
    	return mapping.findForward("main");
    }//execute()
    
    
}//class LmGalleryAction
