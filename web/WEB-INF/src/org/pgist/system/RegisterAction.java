package org.pgist.system;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.pgist.exceptions.UserExistException;
import org.pgist.users.User;


/**
 * Register Action.
 * 
 * @author kenny
 *
 */
public class RegisterAction extends Action {

    
    private SystemService systemService;
    
    
    public RegisterAction() {
    }
    
    
    public void setSystemService(SystemService systemService) {
        this.systemService = systemService;
    }
    
    
    /*
     * ------------------------------------------------------------------------
     */

    
    /**
     * When call this action, the following parameters are required:<br>
     * <ul>
     *   <li>save           - string, the only valid value is "true". It means to save the given information to a new User object. Any other value will turn the page to register.jsp again.</li>
     *   <li>user.loginname - string, login name of the new user.</li>
     *   <li>user.password  - string, password of the new user.</li>
     *   <li>password1      - string, password1 of the new user, it must be matched with password.</li>
     *   <li>user.firstname - string, first name of the new user.</li>
     *   <li>user.lastname  - string, last name of the new user.</li>
     *   <li>user.email     - string, email of the new user.</li>
     *   <li>user.homeAddr  - string, home address of the new user.</li>
     *   <li>user.city      - string, city of the new user.</li>
     *   <li>user.state     - string, state of the new user.</li>
     *   <li>user.zipcode   - string, zip code of the new user.</li>
     *   <li>user.ethnicity - string, ethnicity of the new user. (intented to be used on a HTML select element)<br>
     *                        it can be "other", and in this situation, ethnicity1 must be valid.<br>
     *                        else it must contain a value other than -1 or empty.</li>
     *   <li>ethnicity1     - string, ethnicity1 of the new user. When user.ethnicity is "other", ethnicity1 must be provided.</li>
     * </ul>
     */
    public ActionForward execute(
            ActionMapping mapping,
            ActionForm form,
            javax.servlet.http.HttpServletRequest request,
            javax.servlet.http.HttpServletResponse response
    ) throws java.lang.Exception {
        UserForm uform = (UserForm) form;
        
        if (!uform.isSave()) {
            request.setAttribute("PGIST_SERVICE_SUCCESSFUL", true);
            return mapping.findForward("register");
        }
        
        User user = uform.getUser();
        
        String firstname = user.getFirstname();
        if (firstname==null || "".equals(firstname)) {
            uform.setReason("First Name is required.");
            return mapping.findForward("register");
        }
        
        String lastname = user.getLastname();
        if (lastname==null || "".equals(lastname)) {
            uform.setReason("Last Name is required.");
            return mapping.findForward("register");
        }
        
        String email = user.getEmail();
        if (email==null || "".equals(email)) {
            uform.setReason("Email is Required.");
            return mapping.findForward("register");
        } else if (email.indexOf("@")== -1 || email.indexOf(".")==-1){
        	uform.setReason("Please Enter a valid Email Address.");
            return mapping.findForward("register");
        }        
       
        String loginname = user.getLoginname();
        
        if (loginname==null || "".equals(loginname)) {
            uform.setReason("Preferred LIT ID is Required.");
            return mapping.findForward("register");
        }
        
        String password = user.getPassword();
        if (password==null || "".equals(password)) {
            uform.setReason("Password is Required.");
            return mapping.findForward("register");
        }
        
        String password1 = uform.getPassword1();
        if (password1==null || "".equals(password1)) {
            uform.setReason("Re-type Password is Required.");
            return mapping.findForward("register");
        }
        
        if (!password.equals(password1)) {
            uform.setReason("Both Password Fields Must Match.");
            return mapping.findForward("register");
        }
        
        String homeAddr = user.getHomeAddr();
        if (homeAddr==null || "".equals(homeAddr)) {
            uform.setReason("Home Address is Required.");
            return mapping.findForward("register");
        }
        
        String city = user.getCity();
        if (city==null || "".equals(city)) {
            uform.setReason("City is Required.");
            return mapping.findForward("register");
        }
        
        String state = user.getState();
        if (state==null || "".equals(state)) {
            uform.setReason("State is Required.");
            return mapping.findForward("register");
        }
        
        String zipcode = user.getZipcode();
        if (zipcode==null || "".equals(zipcode)) {
            uform.setReason("ZIP/Postal Code is Required.");
            return mapping.findForward("register");
        }
        
        String ethnicity = user.getEthnicity();
        if (ethnicity==null || "".equals(ethnicity) || "-1".equals(ethnicity)) {
            uform.setReason("Ethnicity is Required.");
            return mapping.findForward("register");
        } else if ("other".equals(ethnicity)) {
            String eth = uform.getEthnicity1();
            if (eth==null || "".equals(eth.trim())) {
                uform.setReason("Ethnicity (other) is Required.");
                return mapping.findForward("register");
            }
            user.setEthnicity(eth);
        }
        
        user.setDeleted(false);
        user.setEnabled(true);
        user.setInternal(false);
        user.encodePassword();
        
        try {
            systemService.createUser(user);
            request.setAttribute("PGIST_SERVICE_SUCCESSFUL", true);
        } catch (UserExistException uee) {
            uform.setReason(uee.getMessage());
            return mapping.findForward("register");
        } catch (Exception e) {
            uform.setReason(e.getMessage());
            return mapping.findForward("register");
        }
        
        return mapping.findForward("login");
    }//execute()
    
    
}//class RegisterAction
