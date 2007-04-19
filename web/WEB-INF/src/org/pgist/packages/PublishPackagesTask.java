package org.pgist.packages;

import org.pgist.discussion.InfoStructure;
import org.pgist.wfengine.EnvironmentInOuts;
import org.pgist.wfengine.WorkflowTask;


/**
 * Automatic workflow task for publishing projects.
 * 
 * @author kenny
 */
public class PublishPackagesTask implements WorkflowTask {
    
    
    public static final String IN_CCT_ID = "cctId";
    
    public static final String IN_SUITE_ID = "suiteId";
    
    public static final String OUT_ISID = "is_id";
    
    
    private PackageService packageService;
    
    
    public void setPackageService(PackageService packageService) {
        this.packageService = packageService;
    }


    /*
     * ------------------------------------------------------------------------
     */
    
    
    public void execute(EnvironmentInOuts inouts) throws Exception {
        System.out.println("@ PublishPackagesTask.execute()");
        
        Long suiteId = new Long(inouts.getIntValue(IN_SUITE_ID));
        
        Long cctId = new Long(inouts.getIntValue(IN_CCT_ID));
        
        InfoStructure structure = packageService.publish(cctId, suiteId);
        
        inouts.setIntValue(OUT_ISID, structure.getId().intValue());
    }//execute()
    
    
}//class PublishPackagesTask