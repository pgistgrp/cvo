package org.pgist.glossary;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

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
public class GlossaryPublicAgent {

    
    private GlossaryService glossaryService;
    
    
    public void setGlossaryService(GlossaryService glossaryService) {
        this.glossaryService = glossaryService;
    }
    
    
    /*
     * ------------------------------------------------------------------------
     */
    
    
    /**
     * Get glossary terms with the given filter and sorting conditions.
     * 
     * @param params - A map contains:<br>
     *         <ul>
     *           <li>filter - string</li>
     *           <li>sort - string, ['name' | 'views' | 'comments', 'createtime'], optional, default is 'name'</li>
     *           <li>direction - string, ['asc' | 'desc'], optional, default is 'asc'</li>
     *         </ul>
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *           <li>html - a HTML source segment. (if sorting by name, it's generated by /WEB-INF/jsp/glossary/gpTermsAlpha.jsp; 
     *           else it's generated by /WEB-INF/jsp/glossary/gpTerms.jsp)<br>
     *                  The following variables are available for use in the jsp:
     *                  <ul>
     *                    <li>terms - A list of Term objects</li>
     *                    <li>filter - string</li>
     *                    <li>sort - string, ['name' | 'views' | 'comments', 'createtime']</li>
     *                    <li>direction - string, ['asc' | 'desc']</li>
     *                  </ul>
     *           </li>
     *         </ul>
     */
    public Map getTerms(HttpServletRequest request, Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        try {
            String filter = (String) params.get("filter");
            if (filter==null) filter = "";
            
            String sort = (String) params.get("sort");
            if (sort==null) sort = "name";
            
            String direction = (String) params.get("direction");
            if (direction==null) direction = "asc";
            
            Collection terms = glossaryService.getTerms(filter, sort, direction, new int[] {Term.STATUS_OFFICIAL});
            
            request.setAttribute("filter", filter);
            request.setAttribute("sort", sort);
            request.setAttribute("direction", direction);
            request.setAttribute("terms", terms);
            
            if (sort==null || "".equals(sort) || "name".equalsIgnoreCase(sort)) {
                map.put("html", WebContextFactory.get().forwardToString("/WEB-INF/jsp/glossary/gpTermsAlpha.jsp"));
            } else {
                map.put("html", WebContextFactory.get().forwardToString("/WEB-INF/jsp/glossary/gpTerms.jsp"));
            }
            
            map.put("successful", true);
        } catch (Exception e) {
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//getTerms()
    
    
    /**
     * Get term as html with the given id.
     * 
     * @param params - A map contains:<br>
     *         <ul>
     *           <li>id - int, id of term object</li>
     *         </ul>
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *           <li>html - a HTML source segment, generated by /WEB-INF/jsp/glossary/gpTermView.jsp.
     *                  The following variables are available for use in the jsp:
     *                  <ul>
     *                    <li>term - A Term object</li>
     *                  </ul>
     *           </li>
     *         </ul>
     */
    public Map getTermHTML(HttpServletRequest request, Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        try {
            Long id = new Long((String) params.get("id"));
            
            Term term = glossaryService.getTermById(id);
            if (term==null) {
                map.put("reason", "term with id "+id+" is not found!");
                return map;
            }
            
            request.setAttribute("term", term);
            
            map.put("html", WebContextFactory.get().forwardToString("/WEB-INF/jsp/glossary/gpTermView.jsp"));
            
            map.put("successful", true);
        } catch (Exception e) {
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//getTermHTML()
    
    
    /**
     * Get term as object with the given id.
     * 
     * @param params - A map contains:<br>
     *         <ul>
     *           <li>id - int, id of term object</li>
     *         </ul>
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *           <li>term - a javascript object for Term.</li>
     *           <li>relatedTerms - array of javascript objects, each element is the related Term object.</li>
     *         </ul>
     */
    public Map getTermObject(Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        try {
            Long id = new Long((String) params.get("id"));
            
            Term term = glossaryService.getTermById(id);
            if (term==null) {
                map.put("reason", "term with id "+id+" is not found!");
                return map;
            }
            
            map.put("term", term);
            map.put("relatedTerms", term.getRelatedTerms());
            map.put("successful", true);
        } catch (Exception e) {
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//getTermObject()
    
    
    /**
     * Participants propose new glossary term.
     * 
     * @param params - A map contains:<br>
     *         <ul>
     *           <li>name - string, name of term</li>
     *           <li>shortDef - string, short definition of term</li>
     *           <li>fullDef - string, full definition of term</li>
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
    public Map proposeTerm(Map params, String[] relatedTerms, String[] links, String[] sources, String[] categories) {
        Map map = new HashMap();
        map.put("successful", false);
        
        try {
            Term term = new Term();
            term.setRefCount(0);
            term.setHitCount(0);
            term.setCommentCount(0);
            
            String name = (String) params.get("name");
            if (name==null || "".equals(name)) {
                map.put("reason", "name is required for term");
                return map;
            }
            term.setName(name);
            
            String shortDefinition = (String) params.get("shortDef");
            term.setShortDefinition(shortDefinition);
            
            String extDefinition = (String) params.get("fullDef");
            term.setExtDefinition(extDefinition);
            
            glossaryService.createTerm(term, relatedTerms, links, sources, categories, Term.STATUS_PENDING);
            
            map.put("successful", true);
        } catch (Exception e) {
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//proposeTerm()
    
    
    /**
     * Get the comments to the specified term.
     * 
     * @param params - A map contains:<br>
     *         <ul>
     *           <li>id - int, id of the term object</li>
     *         </ul>
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *           <li>html - a HTML source segment, generated by /WEB-INF/jsp/glossary/gpComments.jsp.
     *                  The following variables are available for use in the jsp:
     *                  <ul>
     *                    <li>term - A Term object</li>
     *                    <li>comments - array of DiscussionPost objects</li>
     *                  </ul>
     *           </li>
     *         </ul>
     */
    public Map getComments(HttpServletRequest request, Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        try {
            Long id = new Long((String) params.get("id"));
            
            Term term = glossaryService.getTermById(id);
            if (term==null) {
                map.put("reason", "term with id "+id+" is not found!");
                return map;
            }
            
            //TODO: get comments
        } catch (Exception e) {
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//getComments()
    
    
    /**
     * Create a new comment to the specified term.
     * 
     * @param params - A map contains:<br>
     *         <ul>
     *           <li>id - int, id of the term object</li>
     *           <li>comment - string, content of comment</li>
     *         </ul>
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *         </ul>
     */
    public Map createComment(Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        try {
            Long id = new Long((String) params.get("id"));
            
            Term term = glossaryService.getTermById(id);
            if (term==null) {
                map.put("reason", "term with id "+id+" is not found!");
                return map;
            }
            
            //TODO: create comments
        } catch (Exception e) {
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//createComment()
    
    
}//class GlossaryPublicAgent
