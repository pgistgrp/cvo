package org.pgist.system;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

public class UsermgrAction extends Action{
	
	
	private SystemService systemService;
	
	
	public void setSystemService(SystemService systemService) {
		this.systemService = systemService;
	}
	
	
	/*
	 * ------------------------------------------------------------------------
	 */
	
	
	public ActionForward execute(
            ActionMapping mapping,
            ActionForm form,
            javax.servlet.http.HttpServletRequest request,
            javax.servlet.http.HttpServletResponse response
    ) throws java.lang.Exception {
        return mapping.findForward("usermgr");
    }//execute()
	
	
}//UsermgrAction()
