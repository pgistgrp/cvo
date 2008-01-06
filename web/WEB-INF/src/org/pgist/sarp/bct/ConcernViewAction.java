package org.pgist.sarp.bct;

import java.util.Collection;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.pgist.system.SystemService;
import org.pgist.system.YesNoVoting;
import org.pgist.util.PageSetting;


/**
 * 
 * @author kenny
 *
 */
public class ConcernViewAction extends Action {

    
    private BCTService bctService;
    
    private SystemService systemService;
    
    
    public ConcernViewAction() {
    }
    
    
    public void setBctService(BCTService bctService) {
        this.bctService = bctService;
    }


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
        Long id = new Long(request.getParameter("id"));
        
        PageSetting setting = new PageSetting();
        setting.setPage(request.getParameter("page"));
        setting.setRowOfPage((String) request.getParameter("count"));
        
        Concern concern = bctService.getConcernById(id);
        YesNoVoting voting = systemService.getVoting(YesNoVoting.TYPE_CONCERN, id);
        if (voting!=null) concern.setObject(voting);
        
        Collection comments = bctService.getComments(id, setting);
        for (Comment comment : (Collection<Comment>) comments) {
            voting = systemService.getVoting(YesNoVoting.TYPE_COMMENT, comment.getId());
            if (voting!=null) comment.setObject(voting);
        }
        
        /*
         * increase the view times
         */
        bctService.increaseViews(id);
        
        request.setAttribute("concern", concern);
        request.setAttribute("comments", comments);
        
        request.setAttribute("PGIST_SERVICE_SUCCESSFUL", true);
        
        return mapping.findForward("main");
    }//execute()


}//class ConcernViewAction