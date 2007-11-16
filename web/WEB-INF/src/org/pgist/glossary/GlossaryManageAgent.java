package org.pgist.glossary;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

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
public class GlossaryManageAgent {

    
    private GlossaryService glossaryService;
    
    
    public void setGlossaryService(GlossaryService glossaryService) {
        this.glossaryService = glossaryService;
    }
    
    
    /*
     * ------------------------------------------------------------------------
     */
    
    
    /**
     * Get glossary terms with the given conditions.
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
     *           <li>html - a HTML source segment. (Generated by /WEB-INF/jsp/glossary/glossaryManage.jsp)<br>
     *                  The following variables are available for use in the jsp:
     *                  <ul>
     *                    <li>terms - A list of Term objects</li>
     *                    <li>setting - A PageSetting objects</li>
     *                  </ul>
     *           </li>
     *         </ul>
     */
    public Map getTerms(HttpServletRequest request, Map params) {
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
            map.put("html", WebContextFactory.get().forwardToString("/WEB-INF/jsp/glossary/gmTerms.jsp"));
            
            map.put("successful", true);
        } catch (Exception e) {
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//getTerms()
    
    
    /**
     * Get term object with the given termId.
     * 
     * @param params - A map contains:<br>
     *         <ul>
     *           <li>id - int, id of term object</li>
     *           <li>type - string, 'view' | 'edit'</li>
     *         </ul>
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *           <li>html - a HTML source segment.
     *                  if type=='view', generated by /WEB-INF/jsp/glossary/viewTerm.jsp<br>
     *                  else if type=='edit', generated by /WEB-INF/jsp/glossary/editTerm.jsp<br>
     *                  The following variables are available for use in the jsp:
     *                  <ul>
     *                    <li>term - A Term object</li>
     *                  </ul>
     *           </li>
     *         </ul>
     */
    public Map getTerm(HttpServletRequest request, Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        try {
            Long id = new Long((String) params.get("id"));
            String type = (String) params.get("type");
            
            Term term = glossaryService.getTermById(id);
            if (term==null) {
                map.put("reason", "term with id "+id+" is not found!");
                return map;
            }
            
            request.setAttribute("term", term);
            
            if ("view".equals(type)) {
                map.put("html", WebContextFactory.get().forwardToString("/WEB-INF/jsp/glossary/viewTerm.jsp"));
            } else if ("edit".equals(type)) {
                map.put("html", WebContextFactory.get().forwardToString("/WEB-INF/jsp/glossary/editTerm.jsp"));
            } else {
                map.put("reason", "type must be either 'view' or 'edit'");
                return map;
            }
            
            map.put("successful", true);
        } catch (Exception e) {
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//getTerm()
    
    
    /**
     * Save the given term object.
     * 
     * @param params - A map contains:<br>
     *         <ul>
     *           <li>id - int, id of term object, -1 denotes to create a new term, else modify an existing term</li>
     *           <li>name - string, the name of term</li>
     *           <li>shortDefinition - string, the short definition of term</li>
     *           <li>extDefinition - string, the extended definition of term</li>
     *         </ul>
     * @param relatedTerms - array of string, array of related terms
     * @param links - array of string, array of term links
     * @param sources - array of string, array of term sources
     * @param categories - array of string, array of term categories
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *         </ul>
     */
    public Map saveTerm(Map params, String[] relatedTerms, String[] links, String[] sources, String[] categories) {
        Map map = new HashMap();
        map.put("successful", false);
        
        try {
            Term term;
            Long id = new Long((String) params.get("id"));
            if (id==-1) {
                term = new Term();
                term.setRefCount(0);
                term.setHitCount(0);
                term.setCommentCount(0);
            } else {
                term = glossaryService.getTermById(id);
                if (term==null) {
                    map.put("reason", "term with id "+id+" is not found!");
                    return map;
                }
            }
            
            String name = (String) params.get("name");
            if (name==null || "".equals(name)) {
                map.put("reason", "name is required for term");
                return map;
            }
            term.setName(name);
            
            String shortDefinition = (String) params.get("shortDefinition");
            term.setShortDefinition(shortDefinition);
            
            String extDefinition = (String) params.get("extDefinition");
            term.setExtDefinition(extDefinition);
            
            glossaryService.saveTerm(term, relatedTerms, links, sources, categories);
            
            map.put("successful", true);
        } catch (Exception e) {
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//saveTerm()
    
    
}//class GlossaryManageAgent
