package org.pgist.cvo;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;


/**
 * 
 * @author kenny
 *
 */
public class CVOPostGroupsAction extends Action {
    
    
    private CVODAO cvoDAO;
    
    
    public void setCvoDAO(CVODAO cvoDAO) {
        this.cvoDAO = cvoDAO;
    }
    
    
    public ActionForward execute(
            ActionMapping mapping,
            ActionForm form,
            javax.servlet.http.HttpServletRequest request,
            javax.servlet.http.HttpServletResponse response
    ) throws java.lang.Exception {
        CVOForm cvoform = (CVOForm) form;
        
        CVO cvo = cvoDAO.getCVOById(cvoform.getId());
        cvoform.setRoot(cvo.getDiscourseObject().getRoot());
        
        return mapping.findForward("display");
    }//execute()


}
