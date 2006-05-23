package org.pgist.cvo;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

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
public class CSTAgent {
    
    
    private CCTService cctService = null;
    
    private CSTService cstService = null;


    /**
     * This is not an AJAX service method.
     *
     * @param cctService
     */
    public void setCctService(CCTService cctService) {
        this.cctService = cctService;
    }


    /**
     * This is not an AJAX service method.
     *
     * @param cstService
     */
    public void setCstService(CSTService cstService) {
        this.cstService = cstService;
    }


    /*
     * ------------------------------------------------------------------------
     */


    /**
     * Get categories in a given CCT.
     *
     * @param params A map contains:<br>
     *         <ul>
     *           <li>cctId - long int, the current CCT instance id</li>
     *         </ul>
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>html - a HTML source segment. (Generated by /WEB-INF/jsp/cvo/cstCategories.jsp)<br>
     *                  The following variables are available for use in the jsp:
     *                  <ul>
     *                    <li>cct - A CCT object</li>
     *                    <li>categories - A list of CategoryReference objects</li>
     *                  </ul>
     *           </li>
     *           <li>rootId - int, the root CategoryReference object id (valid when successful==true)</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *         </ul>
     * @throws Exception
     */
    public Map getCategories(HttpServletRequest request, Map params) {
        Map map = new HashMap();
        
        Long cctId = new Long((String) params.get("cctId"));
        try {
            CCT cct = cctService.getCCTById(cctId);
            if (cct!=null) {
                Set set = cct.getRootCategory().getChildren();
                
                request.setAttribute("cct", cct);
                request.setAttribute("categories", set);
                map.put("html", WebContextFactory.get().forwardToString("/WEB-INF/jsp/cvo/cstCategories.jsp"));
                map.put("successful", true);
            } else {
                map.put("successful", false);
                map.put("reason", "no such cct!");
            }
        } catch(Exception e) {
            e.printStackTrace();
            map.put("successful", false);
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//getCategories()
    
    
    /**
     * Get tags related/unrelated with a given category.
     *
     * @param params A map contains:<br>
     *         <ul>
     *           <li>cctId - long int, the current CCT instance id</li>
     *           <li>categoryId - long int, the id of a CategoryReference object</li>
     *           <li>page - int, the page to be displayed of unrelated tags</li>
     *         </ul>
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>html1 - a HTML source segment for related tags. (Generated by /WEB-INF/jsp/cvo/cstTags1.jsp)<br>
     *                  The following variables are available for use in the jsp:
     *                  <ul>
     *                    <li>cct - A CCT object</li>
     *                    <li>catRef - A CategoryReference object</li>
     *                    <li>relatedTags - A list of related TagReference objects</li>
     *                  </ul>
     *           </li>
     *           <li>html2 - a HTML source segment for unrelated tags. (Generated by /WEB-INF/jsp/cvo/cstTags2.jsp)<br>
     *                  The following variables are available for use in the jsp:
     *                  <ul>
     *                    <li>cct - A CCT object</li>
     *                    <li>catRef - A CategoryReference object</li>
     *                    <li>unrelatedTags - A list of unrelated TagReference objects</li>
     *                  </ul>
     *           </li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *         </ul>
     * @throws Exception
     */
    public Map getTags(HttpServletRequest request, Map params) {
        Map map = new HashMap();
        
        Long cctId = new Long((String) params.get("cctId"));
        try {
            CCT cct = cctService.getCCTById(cctId);
            if (cct!=null) {
                Long categoryId = (Long) params.get("categoryId");
                CategoryReference ref = cstService.getCategoryReferenceById(categoryId);
                if (ref==null) {
                    map.put("successful", false);
                    map.put("reason", "CategoryReference doesn't exist.");
                    return map;
                }
                if (ref.getCct().getId().longValue()!=cct.getId().longValue()) {
                    map.put("successful", false);
                    map.put("reason", "CategoryReference object is not in this CCT object");
                    return map;
                }
                
                Set relatedTags = ref.getTags();
                Set unrelatedTags = cct.getTagRefs();
                unrelatedTags.removeAll(relatedTags);
                
                request.setAttribute("cct", cct);
                request.setAttribute("relatedTags", relatedTags);
                request.setAttribute("unrelatedTags", unrelatedTags);
                request.setAttribute("catRef", ref);
                
                map.put("html1", WebContextFactory.get().forwardToString("/WEB-INF/jsp/cvo/cstTags1.jsp"));
                map.put("html2", WebContextFactory.get().forwardToString("/WEB-INF/jsp/cvo/cstTags2.jsp"));
                
                map.put("successful", true);
            } else {
                map.put("successful", false);
                map.put("reason", "no such cct!");
            }
        } catch(Exception e) {
            e.printStackTrace();
            map.put("successful", false);
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//getTags()
    
    
    /**
     * Add a new category to the given CCT.
     *
     * @param params A map contains:<br>
     *         <ul>
     *           <li>cctId - long int, the current CCT instance id</li>
     *           <li>category - string, name of the new category</li>
     *           <li>parentId - long int, the parent CategoryReference instance id, if invalid, rootId will be used.</li>
     *         </ul>
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *         </ul>
     * @throws Exception
     */
    public Map addCategory(Map params) {
        Map map = new HashMap();
        
        map.put("successful", false);
        try {
            Long cctId = new Long((String) params.get("cctId"));
            Long parentId = new Long((String)params.get("parentId"));
            String name = (String) params.get("category");
            
            if (name==null || "".equals(name.trim())) {
                map.put("reason", "can't create a category which name is empty.");
                return map;
            }
            
            cstService.addChildCategoryReference(cctId, parentId, name);
            map.put("successful", true);
        } catch(Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//addCategory()
    
    
    /**
     * Edit the category (name) in the given CCT.
     *
     * @param params A map contains:<br>
     *         <ul>
     *           <li>cctId - long int, the current CCT instance id</li>
     *           <li>categoryId - long int, id of the CategoryReference object</li>
     *           <li>category - the new category name</li>
     *         </ul>
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *         </ul>
     * @throws Exception
     */
    public Map editCategory(Map params) {
        Map map = new HashMap();
        
        map.put("successful", false);
        try {
            Long cctId = new Long((String) params.get("cctId"));
            Long categoryId = new Long((String) params.get("categoryId"));
            String name = (String) params.get("category");
            
            if (name==null || "".equals(name.trim())) {
                map.put("reason", "can't create a category which name is empty.");
                return map;
            }
            
            cstService.editCategoryReference(cctId, categoryId, name);
            map.put("successful", true);
        } catch(Exception e) {
            e.printStackTrace();
            map.put("successful", false);
            map.put("reason", e.getMessage());
            return map;
        }
        
        return map;
    }//editCategory()
    
    
    /**
     * Delete the specified CategoryReference object in the given CCT.
     *
     * @param params A map contains:<br>
     *         <ul>
     *           <li>cctId - long int, the current CCT instance id</li>
     *           <li>parentId - long int, id of the parent CategoryReference object</li>
     *           <li>categoryId - long int, id of the CategoryReference object</li>
     *         </ul>
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *         </ul>
     * @throws Exception
     */
    public Map deleteCategory(Map params) {
        Map map = new HashMap();
        
        map.put("successful", false);
        try {
            Long cctId = new Long((String) params.get("cctId"));
            Long parentId = new Long((String) params.get("parentId"));
            Long categoryId = new Long((String) params.get("categoryId"));
            
            cstService.deleteCategoryReference(cctId, parentId, categoryId);
            map.put("successful", true);
        } catch(Exception e) {
            e.printStackTrace();
            map.put("successful", false);
            map.put("reason", e.getMessage());
            return map;
        }
        
        return map;
    }//deleteCategory()
    
    
    /**
     * Relate a TagReferrence to the give CategoryReference.
     *
     * @param params A map contains:<br>
     *         <ul>
     *           <li>cctId - long int, the current CCT instance id</li>
     *           <li>categoryId - long int, id of the CategoryReference object</li>
     *           <li>tagId - long int, id of the TagReference object</li>
     *         </ul>
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *         </ul>
     * @throws Exception
     */
    public Map relateTag(Map params) {
        Map map = new HashMap();
        
        map.put("successful", false);
        try {
            Long cctId = new Long((String) params.get("cctId"));
            Long categoryId = new Long((String) params.get("categoryId"));
            Long tagId = new Long((String) params.get("tagId"));
            
            cstService.relateTagToCategory(cctId, categoryId, tagId);
            map.put("successful", true);
        } catch(Exception e) {
            e.printStackTrace();
            map.put("successful", false);
            map.put("reason", e.getMessage());
            return map;
        }
        
        return map;
    }//relateTag()
    
    
    /**
     * De-Relate a TagReferrence with the give CategoryReference.
     *
     * @param params A map contains:<br>
     *         <ul>
     *           <li>cctId - long int, the current CCT instance id</li>
     *           <li>categoryId - long int, id of the CategoryReference object</li>
     *           <li>tagId - long int, id of the TagReference object</li>
     *         </ul>
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *         </ul>
     * @throws Exception
     */
    public Map derelateTag(Map params) {
        Map map = new HashMap();
        
        map.put("successful", false);
        try {
            Long cctId = new Long((String) params.get("cctId"));
            Long categoryId = new Long((String) params.get("categoryId"));
            Long tagId = new Long((String) params.get("tagId"));
            
            cstService.deleteTagFromCategory(cctId, categoryId, tagId);
            map.put("successful", true);
        } catch(Exception e) {
            e.printStackTrace();
            map.put("successful", false);
            map.put("reason", e.getMessage());
            return map;
        }
        
        return map;
    }//derelateTag()
    
    
    /**
     * Get concerns related to a given tag.
     *
     * @param params A map contains:<br>
     *         <ul>
     *           <li>cctId - long int, the current CCT instance id</li>
     *           <li>tagId - long int, id of the TagReference object</li>
     *           <li>page - int, page of concerns to be displayed</li>
     *         </ul>
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>html - a HTML source segment. (Generated by /WEB-INF/jsp/cvo/cstConcerns.jsp)<br>
     *                  The following variables are available for use in the jsp:
     *                  <ul>
     *                    <li>cct - the current CCT object</li>
     *                    <li>tag - the current TagReference objects</li>
     *                    <li>concerns - A list of Concern objects</li>
     *                  </ul>
     *           </li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *         </ul>
     * @throws Exception
     */
    public Map getConcerns(HttpServletRequest request, Map params) {
        Map map = new HashMap();
        
        map.put("successful", false);
        try {
            Long cctId = new Long((String) params.get("cctId"));
            Long tagId = new Long((String) params.get("tagId"));
            
            int page = 1;
            try {
                String pageStr = (String) params.get("page");
                page = Integer.parseInt(pageStr);
            } catch(Exception e) {
            }
            
            PageSetting setting = new PageSetting(20);
            setting.setPage(page);
            
            Object[] values = cstService.getConcernsByTag(cctId, tagId, setting);
            
            request.setAttribute("cct", values[0]);
            request.setAttribute("tag", values[1]);
            request.setAttribute("concerns", values[2]);
            
            map.put("html", WebContextFactory.get().forwardToString("/WEB-INF/jsp/cvo/cstConcerns.jsp"));
            
            map.put("successful", true);
        } catch(Exception e) {
            e.printStackTrace();
            map.put("successful", false);
            map.put("reason", e.getMessage());
            return map;
        }
        
        return map;
    }//getConcerns()
    
    
    /**
     * Get concerns related to a given tag.
     *
     * @param params A map contains:<br>
     *         <ul>
     *           <li>cctId - long int, the current CCT instance id</li>
     *           <li>summary - string, the new summary to be saved</li>
     *         </ul>
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *         </ul>
     * @throws Exception
     */
    public Map saveSummary(Map params) {
        Map map = new HashMap();
        
        map.put("successful", false);
        try {
            Long cctId = new Long((String) params.get("cctId"));
            String summary = (String) params.get("summary");
            
            cstService.saveSummary(cctId, summary);
            
            map.put("successful", true);
        } catch(Exception e) {
            e.printStackTrace();
            map.put("successful", false);
            map.put("reason", e.getMessage());
            return map;
        }
        
        return map;
    }//saveSummary()
    
    
}//class CSTAgent
