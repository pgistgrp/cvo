package org.pgist.sarp.cht;

import org.pgist.wfengine.EnvironmentInOuts;
import org.pgist.wfengine.WorkflowInfo;
import org.pgist.wfengine.WorkflowTask;


/**
 * Automatic workflow task for custering categories.
 * 
 * @author kenny
 */
public class CHTCateogryClusterTask implements WorkflowTask {
    
    
    public static final String IN_CHT_ID = "cht_id";
    
    
    private CHTService chtService;
    
    
    public void setChtService(CHTService chtService) {
        this.chtService = chtService;
    }
    
    
    /*
     * ------------------------------------------------------------------------
     */
    
    
    public void execute(WorkflowInfo info, EnvironmentInOuts inouts) throws Exception {
        System.out.println("\n@ CHTCateogryClusterTask.execute()\n");
        
        Long chtId = new Long(inouts.getIntValue(IN_CHT_ID));
        
        //chtService.setClusteredCategory(chtId);
    } //execute()
    
    
} //class CHTCateogryClusterTask
