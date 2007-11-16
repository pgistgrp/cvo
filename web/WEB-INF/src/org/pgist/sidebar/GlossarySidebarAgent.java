package org.pgist.sidebar;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.pgist.glossary.GlossaryService;
import org.pgist.glossary.Term;
import org.pgist.util.PageSetting;

import uk.ltd.getahead.dwr.WebContextFactory;


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
public class GlossarySidebarAgent {

    
    private GlossaryService glossaryService;
    
    
    public void setGlossaryService(GlossaryService glossaryService) {
        this.glossaryService = glossaryService;
    }
    
    
    /*
     * ------------------------------------------------------------------------
     */
    
    
    /**
     * Search glossary terms with the given conditions.
     * 
     * @param params - A map contains:<br>
     *         <ul>
     *           <li>prefix - String, prefix to filtering terms</li>
     *           <li>count - int, the term number to be displayed in a page</li>
     *           <li>page - int, the page number to be displayed</li>
     *         </ul>
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *           <li>html - a HTML source segment. (Generated by /WEB-INF/jsp/sidebar/searchTerms.jsp)<br>
     *                  The following variables are available for use in the jsp:
     *                  <ul>
     *                    <li>terms - A list of Term objects</li>
     *                    <li>setting - A PageSetting objects</li>
     *                  </ul>
     *           </li>
     *         </ul>
     */
    public Map searchTerms(HttpServletRequest request, Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        try {
            PageSetting setting = new PageSetting();
            
            setting.setFilter((String) params.get("prefix"));
            setting.setRowOfPage((String) params.get("count"));
            setting.setPage((String) params.get("page"));
            
            Collection terms = glossaryService.getTerms(setting);
            
            request.setAttribute("setting", setting);
            request.setAttribute("terms", terms);
            map.put("html", WebContextFactory.get().forwardToString("/WEB-INF/jsp/sidebar/searchTerms.jsp"));
            
            map.put("successful", true);
        } catch (Exception e) {
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//searchTerms()
    
    
    /**
     * Get term object with the given termId.
     * 
     * @param params - A map contains:<br>
     *         <ul>
     *           <li>id - int, id of term object</li>
     *         </ul>
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *           <li>html - a HTML source segment, generated by /WEB-INF/jsp/sidebar/viewTerm.jsp
     *                  The following variables are available for use in the jsp:
     *                  <ul>
     *                    <li>term - A Term object</li>
     *                  </ul>
     *           </li>
     *         </ul>
     */
    public Map getTerm(HttpServletRequest request, Long id) {
        Map map = new HashMap();
        map.put("successful", false);
        
        try {
            Term term = glossaryService.getTermById(id);
            if (term==null) {
                map.put("reason", "term with id "+id+" is not found!");
                return map;
            }
            
            request.setAttribute("term", term);
            
            map.put("html", WebContextFactory.get().forwardToString("/WEB-INF/jsp/sidebar/viewTerm.jsp"));
            
            map.put("successful", true);
        } catch (Exception e) {
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//getTerm()
    
    
    /**
     * Get the comments on the term with the given id.
     * 
     * @param id the id of the term
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *           <li>html - a HTML source segment, generated by /WEB-INF/jsp/sidebar/getTermComments.jsp
     *                  The following variables are available for use in the jsp:
     *                  <ul>
     *                    <li>term - A Term object</li>
     *                  </ul>
     *           </li>
     *         </ul>
     */
    public Map getTermComments(HttpServletRequest request, Long id) {
        Map map = new HashMap();
        map.put("successful", false);
        
        try {
            Term term = glossaryService.getTermById(id);
            if (term==null) {
                map.put("reason", "term with id "+id+" is not found!");
                return map;
            }
            
            
            
            request.setAttribute("term", term);
            
            map.put("html", WebContextFactory.get().forwardToString("/WEB-INF/jsp/sidebar/getTermComments.jsp"));
            
            map.put("successful", true);
        } catch (Exception e) {
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//getTermComments()
    
    
}//class GlossaryAgent
