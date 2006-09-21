package org.pgist.system;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.directwebremoting.WebContextFactory;
import org.pgist.util.PageSetting;


/**
 * DWR AJAX Agent class.<br>
 * Provide AJAX services to client programs.<br>
 * In this document, all the NON-AJAX methods are marked out. So all methods
 * <span style="color:red;">without</span> such a description
 * <span style="color:red;">ARE</span> AJAX service methods.<br>
 *
 * @author kenny
 *
 */
public class SystemAgent {
    
    
    private SystemService systemService;
    
    
    /**
     * This is not an AJAX service method.
     *
     * @param systemService
     */
    public void setSystemService(SystemService systemService) {
        this.systemService = systemService;
    }
    
    
    /*
     * ------------------------------------------------------------------------
     */
    
    
    /**
     * Create a new Feedback for the current user.
     * 
     * @param a map contains:
     *   <ul>
     *     <li>feedback - string, the feedback from the user</li>
     *     <li>action - string, the action where the feedback is created</li>
     *   </ul>
     * 
     * @return a map contains:
     *   <ul>
     *     <li>successful - a boolean value denoting if the operation succeeds</li>
     *     <li>reason - reason why operation failed (valid when successful==false)</li>
     *   </ul>
     */
    public Map createFeedback(Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        try {
            String s = (String) params.get("feedback");
            String action = (String) params.get("action");
            
            if (s==null || "".equals(s.trim())) {
                map.put("reason", "The content of feedback can't be empty!");
                return map;
            }
            
            if (action==null || "".equals(action.trim())) {
                map.put("reason", "Unknown Action!");
                return map;
            }
            
            systemService.createFeedback(action, s);
            
            map.put("successful", true);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//createFeedback()
    
    
    /**
     * Get a feedback list
     * 
     * @param a map contains:
     *   <ul>
     *     <li>count - int, the number of feedbacks shown on each page</li>
     *     <li>page - int, current page</li>
     *   </ul>
     * 
     * @return a map contains:
     *   <ul>
     *     <li>successful - a boolean value denoting if the operation succeeds</li>
     *     <li>reason - reason why operation failed (valid when successful==false)</li>
     *     <li>html - a HTML source segment generated by file "/WEB-INF/jsp/system/feedbackMain.jsp", the following variables available:
     *       <ul>
     *         <li>feedbacks - a list of Feedback objects</li>
     *         <li>setting - a PageSetting object</li>
     *       </ul>
     *     </li>
     *   </ul>
     */
    public Map getFeedbacks(HttpServletRequest request, Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        try {
            PageSetting setting = new PageSetting();
            setting.setRowOfPage((String) params.get("count"));
            setting.setPage((String) params.get("page"));
            
            Collection feedbacks = systemService.getFeedbacks(setting);
            
            request.setAttribute("feedbacks", feedbacks);
            request.setAttribute("setting", setting);
            
            map.put("html", WebContextFactory.get().forwardToString("/WEB-INF/jsp/system/feedbackMain.jsp"));
            
            map.put("successful", true);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//getFeedbacks()
    
    
}//class SystemAgent
