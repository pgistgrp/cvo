package org.pgist.system;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.pgist.exceptions.UserExistException;
import org.pgist.users.User;


/**
 * RecoverPasswordAction
 * 
 * @author John
 *
 */
public class RecoverPasswordResetAction extends Action {

    
    private RegisterService registerService;

	public RecoverPasswordResetAction() {
    }
    
    public void setRegisterService(RegisterService registerService) {
		this.registerService = registerService;
	}
    
    /*
     * ------------------------------------------------------------------------
     */

    
    /**
     * When call this action, the following parameters are required:<br>
     * <ul>
     *   <li>rc - string, recovery code</li>

     * </ul>
     */
    public ActionForward execute(
            ActionMapping mapping,
            ActionForm form,
            javax.servlet.http.HttpServletRequest request,
            javax.servlet.http.HttpServletResponse response
    ) throws java.lang.Exception {
    	
    	UserForm uform = (UserForm) form;

    	if(uform.isEditPassword()) {
    		String password1 = uform.getPassword1();
    		String password2 = uform.getPassword2();
    		String code = uform.getCode();
    		
    		if(password1.equals(password2) && password1.length() > 5) {
    			boolean valid = registerService.validatePasswordRecoveryCode(code);
    			if(valid) {
	    			boolean changed = registerService.changePassword(code, password1);
	    			request.setAttribute("passwordupdated", changed);
	    			
	    			//email them here?
	    			
	    			if(changed){
	    				registerService.deleteRecoverPassword(code);
	    				request.setAttribute("sysmsg", "Password successfully changed.");
	    				request.setAttribute("PGIST_SERVICE_SUCCESSFUL", true);
	    			} else {
	    				request.setAttribute("sysmsg", "Password update failed.");
	    				request.setAttribute("PGIST_SERVICE_SUCCESSFUL", false);	    				
	    			}
	    			
	    			return mapping.findForward("resetpassword");
    			}
    		}
    		request.setAttribute("sysmsg", "passwords do not match or the password is not at least six characters long");
    		request.setAttribute("PGIST_SERVICE_SUCCESSFUL", false);
    		return mapping.findForward("resetpassword"); 
    	}
    	
    	request.setAttribute("valid", false);
    	request.setAttribute("PGIST_SERVICE_SUCCESSFUL", false);
        return mapping.findForward("resetpassword");
    }//execute()
    
    
}//class RecoverPasswordResetAction
