package org.pgist.packages;

import java.util.HashMap;
import java.util.Map;


/**
 * 
 * @author kenny
 *
 */
public class PackageAgent {
    
    
    private PackageService packageService;
    
    
    public void setPackageService(PackageService packageService) {
        this.packageService = packageService;
    }
    
    
    /*
     * ------------------------------------------------------------------------
     */
    
    
    /**
     * Set (Add/Delete) a project from a package for the current participant
     * 
     * @param params a Map contains:<br>
     *   <ul>
     *     <li>id - int, id of the ProjectAlternative object</li>
     *     <li>deleting - boolean, true | false. If deleting==true, delete the project alternative
     *         from package, else add the project alternative to package
     *     </li>
     *   </ul>
     *   
     * @return a Map contains:<br>
     *   <ul>
     *     <li>successful - a boolean value denoting if the operation succeeds</li>
     *     <li>reason - reason why operation failed (valid when successful==false)</li>
     *   </ul>
     */
    public Map setProjectToPkg(Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        try {
            
            map.put("successful", true);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
            return map;
        }
        
        return map;
    }//setProjectToPkg()
    
    
    /**
     * Set (Add/Delete) a funding source from a package for the current participant
     * 
     * @param params a Map contains:<br>
     *   <ul>
     *     <li>id - int, id of the FundingAlternative object</li>
     *     <li>deleting - boolean, true | false. If deleting==true, delete the funding source alternative
     *         from package, else add the funding source alternative to package
     *     </li>
     *   </ul>
     *   
     * @return a Map contains:<br>
     *   <ul>
     *     <li>successful - a boolean value denoting if the operation succeeds</li>
     *     <li>reason - reason why operation failed (valid when successful==false)</li>
     *   </ul>
     */
    public Map setFundingToPkg(Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        try {
            
            map.put("successful", true);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
            return map;
        }
        
        return map;
    }//setFundingToPkg()
    
    
}//class PackageAgent
