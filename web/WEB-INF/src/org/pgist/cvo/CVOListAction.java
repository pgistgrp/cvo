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
public class CVOListAction extends Action {

    
    private CVODAO1 cvoDAO;
    
    
    public CVOListAction() {
    }
    
    
    public void setCvoDAO(CVODAO1 cvoDAO) {
        this.cvoDAO = cvoDAO;
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
        CVOForm cvoform = (CVOForm) form;
        cvoform.setCvoList(cvoDAO.getCVOList());
        
        return mapping.findForward("list");
    }//execute()


}//class CVOListAction
