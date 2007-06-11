package org.pgist.other;

import org.pgist.wfengine.EnvironmentInOuts;
import org.pgist.wfengine.WorkflowInfo;
import org.pgist.wfengine.WorkflowTask;


/**
 * Automatic workflow task for creating CCT instance.
 * 
 * @author kenny
 */
public class ImportTemplateTask implements WorkflowTask {
    
    
    public static final String IN_TEMPLATE_ID = "template_id";
    
    
    private ImportService importService;
    
    
    public void setImportService(ImportService importService) {
        this.importService = importService;
    }
    
    
    /*
     * ------------------------------------------------------------------------
     */
    
    
    public void execute(WorkflowInfo info, EnvironmentInOuts inouts) throws Exception {
        System.out.println("@ ImportTemplateTask.execute()");
        
        //Get template name
        Long templateId = new Long(inouts.getIntValue(IN_TEMPLATE_ID));
        System.out.println("    template_id: "+templateId);
        
        //if template name is -1, ignore it
        if (templateId==-1) return;
        
        importService.importTemplate(templateId);
    }//execute()
    
    
}//class ImportTemplateTask
