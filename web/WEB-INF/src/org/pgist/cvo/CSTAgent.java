package org.pgist.cvo;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

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
     * Get tags related OR (but not BOTH) unrelated with a given category.
     *
     * @param params A map contains:<br>
     *         <ul>
     *           <li>cctId - int, the current CCT instance id</li>
     *           <li>categoryId - int, the id of a CategoryReference object</li>
     *           <li>page - int, the page to be displayed of unrelated tags</li>
     *           <li>count - int, tag number to be displayed on a page, -1 denotes all</li>
     *           <li>type - int, type==0 denotes related tags; type==1 denotes unrelated tags.</li>
     *           <li>orphanPage - int, the page to be displayed of orphan tags</li>
     *           <li>orphanCount - int, orphan tag number to be displayed on a page, -1 denotes all</li>
     *         </ul>
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>html - a HTML source segment for related tags. (valid when successful==true)<br>
     *                  for type==0, it's generated by /WEB-INF/jsp/cvo/cstTags0.jsp,<br>
     *                  for type==1, it's generated by /WEB-INF/jsp/cvo/cstTags1.jsp,<br>
     *                  The following variables are available for use in jsp page:
     *                  <ul>
     *                    <li>cct - A CCT object</li>
     *                    <li>catRef - A CategoryReference object</li>
     *                    <li>tags - A list of related TagReference objects</li>
     *                    <li>orphanTags - A list of related TagReference objects (only for type==1)</li>
     *                    <li>setting - A PageSetting object</li>
     *                    <li>orphanSetting - A PageSetting object for orphan tags</li>
     *                  </ul>
     *           </li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *         </ul>
     */
    public Map getTags(HttpServletRequest request, Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        Long cctId = new Long((String) params.get("cctId"));
        try {
            CCT cct = cctService.getCCTById(cctId);
            if (cct==null) {
                map.put("reason", "no such cct!");
                return map;
            }
            
            Long categoryId = new Long( (String) params.get("categoryId") );
            
            CategoryReference ref = cstService.getCategoryReferenceById(categoryId);
            if (ref==null) {
                map.put("reason", "CategoryReference doesn't exist.");
                return map;
            }
            if (ref.getCct().getId().longValue()!=cct.getId().longValue()) {
                map.put("reason", "CategoryReference object is not in this CCT object");
                return map;
            }
            
            PageSetting setting = new PageSetting();
            
            String countStr = (String) params.get("count");
            int count = -1;
            try {
                count = Integer.parseInt(countStr);
            } catch (Exception e) {
            }
            setting.setRowOfPage(count);
            
            String pageStr = (String) params.get("page");
            int page = Integer.parseInt(pageStr);
            setting.setPage(page);
            
            Collection tags = null;
            
            String type = (String) params.get("type");
            if ("0".equals(type)) {
                tags = cstService.getRealtedTags(cctId, categoryId, setting);
            } else if ("1".equals(type)) {
                tags = cstService.getUnrelatedTags(cctId, categoryId, setting);
                
                PageSetting orphanSetting = new PageSetting();
                
                String orphanPageStr = (String) params.get("orphanPage");
                int orphanPage = Integer.parseInt(orphanPageStr);
                orphanSetting.setPage(orphanPage);
                
                String orphanCountStr = (String) params.get("orphanCount");
                int orphanCount = -1;
                if (orphanCountStr!=null && !"".equals(orphanCountStr)) {
                    orphanCount = Integer.parseInt(orphanPageStr);
                }
                orphanSetting.setRowOfPage(orphanCount);
                
                Collection orphanTags = cstService.getOrphanTags(cctId, orphanSetting);
                request.setAttribute("orphanTags", orphanTags);
            } else {
                map.put("reason", "unknown type: "+type);
                return map;
            }
            
            request.setAttribute("cct", cct);
            request.setAttribute("catRef", ref);
            request.setAttribute("tags", tags);
            request.setAttribute("setting", setting);
            
            if ("0".equals(type)) {
                map.put("html", WebContextFactory.get().forwardToString("/WEB-INF/jsp/cvo/cstTags0.jsp"));
            } else {
                map.put("html", WebContextFactory.get().forwardToString("/WEB-INF/jsp/cvo/cstTags1.jsp"));
            }
            
            map.put("successful", true);
        } catch(Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//getTags()
    
    
    /**
     * Get tags which are not related to any category in the speicified CCT (Orphan Tags).
     *
     * @param params A map contains:<br>
     *         <ul>
     *           <li>cctId - int, the current CCT instance id</li>
     *           <li>page - int, the page to be displayed of unrelated tags, optional, default is 1</li>
     *           <li>count - int, the rows number per page, optional, default is -1, which means to get all tags</li>
     *         </ul>
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>html - a HTML source segment for tags. (Generated by /WEB-INF/jsp/cvo/orphanTags.jsp)<br>
     *                  The following variables are available for use in the jsp:
     *                  <ul>
     *                    <li>cct - A CCT object</li>
     *                    <li>tags - A list of TagReference object</li>
     *                    <li>setting - A PageSetting object</li>
     *                  </ul>
     *           </li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *         </ul>
     */
    public Map getOrphanTags(HttpServletRequest request, Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        Long cctId = new Long((String) params.get("cctId"));
        try {
            CCT cct = cctService.getCCTById(cctId);
            if (cct==null) {
                map.put("reason", "no such cct!");
                return map;
            }
            
            int page = 1;
            try {
                page = Integer.parseInt((String) params.get("page"));
            } catch (Exception e) {
            }
            
            int count = -1;
            try {
                count = Integer.parseInt((String) params.get("count"));
            } catch (Exception e) {
            }
            
            PageSetting setting = new PageSetting();
            setting.setRowOfPage(count);
            setting.setPage(page);
            
            Collection tags = cstService.getOrphanTags(cctId, setting);
            
            request.setAttribute("cct", cct);
            request.setAttribute("tags", tags);
            request.setAttribute("setting", setting);
            
            map.put("html", WebContextFactory.get().forwardToString("/WEB-INF/jsp/cvo/orphanTags.jsp"));
            
            map.put("successful", true);
        } catch(Exception e) {
            e.printStackTrace();
            map.put("successful", false);
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//getOrphanTags()
    
    
    /**
     * Add a new category to the given CCT.<br>
     * <ul>
     *    <li>
     *       if a category with this name exists, use it directly (in this case, addCategory() works the same as copyCategory());<br>
     *       else create a new category.
     *    </li>
     *    <li>
     *       add the category to the tree, if parent is specified, the category will be added to be child of this parent;<br>
     *       otherwise, it will be added to the root category of cct. Root category is invisible to user.
     *    </li>
     * <ul>
     * @param params A map contains:<br>
     *         <ul>
     *           <li>cctId - int, the current CCT instance id</li>
     *           <li>parentId - int, the parent CategoryReference instance id, if null or invalid, rootId will be used.</li>
     *           <li>name - string, name of the new category</li>
     *         </ul>
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *         </ul>
     */
    public Map addCategory(Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        Long parentId = null;
        try {
            parentId = new Long((String)params.get("parentId"));
        } catch (Exception e) {
        }
        
        try {
            Long cctId = new Long((String) params.get("cctId"));
            String name = (String) params.get("name");
            
            if (name==null || "".equals(name.trim())) {
                map.put("reason", "can't create a category which name is empty.");
                return map;
            }
            
            cstService.addCategoryReference(cctId, parentId, name);
            map.put("successful", true);
        } catch(Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//addCategory()
    
    
    /**
     * Copy one category from one parent to another parent.
     * 
     * @param params A map contains:<br>
     *         <ul>
     *           <li>cctId - int, the current CCT instance id</li>
     *           <li>categoryId - int, id of the CategoryReference to be copied</li>
     *           <li>parentId - int, the new parent CategoryReference instance id, if null or invalid, rootId will be used.</li>
     *         </ul>
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *         </ul>
     */
    public Map copyCategory(Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        Long categoryId = null;
        try {
            categoryId = new Long((String)params.get("categoryId"));
        } catch (Exception e) {
            map.put("reason", "invalid categoryId");
            return map;
        }
        
        Long parentId = null;
        try {
            parentId = new Long((String)params.get("parentId"));
        } catch (Exception e) {
        }
        
        Long cctId = null;
        try {
            cctId = new Long((String)params.get("cctId"));
        } catch (Exception e) {
            map.put("reason", "invalid cctId");
            return map;
        }
        
        try {
            cstService.copyCategoryReference(cctId, parentId, categoryId);
            map.put("successful", true);
        } catch(Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//copyCategory()
    
    
    /**
     * Duplicate from the specified category and add the new category to be child of the specified parent.<br>
     * 
     * Duplicate is difference from Copy in that, duplicate will create a new category with a new name,
     * but Copy just use the existed category.<br>
     * 
     * Note that the new category by duplicate will own the same tags as the original cateogry.<br>
     * 
     * @param params A map contains:<br>
     *         <ul>
     *           <li>cctId - int, the current CCT instance id</li>
     *           <li>categoryId - int, id of the CategoryReference to be duplicate</li>
     *           <li>name - string, name of the new CategoryReference</li>
     *           <li>parentId - int, the parent CategoryReference instance id, if null or invalid, rootId will be used.</li>
     *         </ul>
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *         </ul>
     */
    public Map duplicateCategory(Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        String name = (String) params.get("name");
        if (name==null || "".equals(name.trim())) {
            map.put("reason", "can't create a category which name is empty.");
            return map;
        }
        
        Long categoryId = null;
        try {
            categoryId = new Long((String)params.get("categoryId"));
        } catch (Exception e) {
            map.put("reason", "invalid categoryId");
            return map;
        }
        
        Long parentId = null;
        try {
            parentId = new Long((String)params.get("parentId"));
        } catch (Exception e) {
        }
        
        Long cctId = null;
        try {
            cctId = new Long((String)params.get("cctId"));
        } catch (Exception e) {
            map.put("reason", "invalid cctId");
            return map;
        }
        
        try {
            cstService.duplicateCategoryReference(cctId, parentId, categoryId, name);
            map.put("successful", true);
        } catch(Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//duplicateCategory()
    
    
    /**
     * Move one category from parent0 to parent1.
     * 
     * @param params A map contains:<br>
     *         <ul>
     *           <li>cctId - int, the current CCT instance id</li>
     *           <li>categoryId - int, id of the CategoryReference to be copied</li>
     *           <li>parent0Id - int, the old parent CategoryReference instance id</li>
     *           <li>parent1Id - int, the new parent CategoryReference instance id, if null or invalid, rootId will be used.</li>
     *         </ul>
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *         </ul>
     */
    public Map moveCategory(Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        Long categoryId = null;
        try {
            categoryId = new Long((String)params.get("categoryId"));
        } catch (Exception e) {
            map.put("reason", "invalid categoryId");
            return map;
        }
        
        Long parent0Id = null;
        try {
            parent0Id = new Long((String)params.get("parent0Id"));
        } catch (Exception e) {
        }
        
        Long parent1Id = null;
        try {
            parent1Id = new Long((String)params.get("parent1Id"));
        } catch (Exception e) {
        }
        
        Long cctId = null;
        try {
            cctId = new Long((String)params.get("cctId"));
        } catch (Exception e) {
            map.put("reason", "invalid cctId");
            return map;
        }
        
        try {
            cstService.moveCategoryReference(cctId, parent0Id, parent1Id, categoryId);
            map.put("successful", true);
        } catch(Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//moveCategory()
    
    
    /**
     * Edit the name of the specified category
     *
     * @param params A map contains:<br>
     *         <ul>
     *           <li>cctId - int, the current CCT instance id</li>
     *           <li>categoryId - int, id of the CategoryReference object</li>
     *           <li>name - the new category name</li>
     *         </ul>
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *         </ul>
     */
    public Map editCategory(Map params) {
        Map map = new HashMap();
        
        map.put("successful", false);
        try {
            Long cctId = new Long((String) params.get("cctId"));
            Long categoryId = new Long((String) params.get("categoryId"));
            String name = (String) params.get("name");
            
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
     *           <li>cctId - int, the current CCT instance id</li>
     *           <li>parentId - int, id of the parent CategoryReference object</li>
     *           <li>categoryId - int, id of the CategoryReference object</li>
     *         </ul>
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *         </ul>
     */
    public Map deleteCategory(Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        try {
            Long cctId = new Long((String) params.get("cctId"));
            
            Long parentId = null;
            try {
                parentId = new Long((String)params.get("parentId"));
            } catch (Exception e) {
            }
            
            Long categoryId = new Long((String) params.get("categoryId"));
            
            cstService.deleteCategoryReference(cctId, parentId, categoryId);
            map.put("successful", true);
        } catch(Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//deleteCategory()
    
    
    /**
     * Relate a TagReferrence to the give CategoryReference.
     *
     * @param params A map contains:<br>
     *         <ul>
     *           <li>cctId - int, the current CCT instance id</li>
     *           <li>categoryId - int, id of the CategoryReference object</li>
     *           <li>tagId - int, id of the TagReference object</li>
     *         </ul>
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *         </ul>
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
     *           <li>cctId - int, the current CCT instance id</li>
     *           <li>categoryId - int, id of the CategoryReference object</li>
     *           <li>tagId - int, id of the TagReference object</li>
     *         </ul>
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *         </ul>
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
     *           <li>cctId - int, the current CCT instance id</li>
     *           <li>tagId - int, id of the TagReference object</li>
     *           <li>page - int, page of concerns to be displayed</li>
     *         </ul>
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *           <li>html - a HTML source segment. (Generated by /WEB-INF/jsp/cvo/cstConcerns.jsp)<br>
     *                  The following variables are available for use in the jsp:
     *                  <ul>
     *                    <li>cct - the current CCT object</li>
     *                    <li>tag - the current TagReference objects</li>
     *                    <li>concerns - A list of Concern objects</li>
     *                    <li>setting - A PageSetting objects</li>
     *                  </ul>
     *           </li>
     *         </ul>
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
            request.setAttribute("setting", setting);
            
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
     * Get the valid themes of a cct object
     * 
     * @param params A map contains:<br>
     *         <ul>
     *           <li>cctId - int, the current CCT instance id</li>
     *           <li>
     *               asHTML - boolean, optional, default is false.
     *                      if html==true, return a string generated from a jsp file;
     *                      else return javascript objects of Theme object
     *           </li>
     *         </ul>
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *           <li>html - a HTML source segment, valid when asHTML==true. (Generated by /WEB-INF/jsp/cvo/cstThemes.jsp)<br>
     *                  The following variables are available for use in the jsp:
     *                  <ul>
     *                    <li>cct - the current CCT object</li>
     *                    <li>themes - a list of Theme objects</li>
     *                  </ul>
     *           </li>
     *           <li>themes - array of Theme objects (valid when asHTML==false)</li>
     *         </ul>
     */
    public Map getThemes(HttpServletRequest request, Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        try {
            Long cctId = new Long((String) params.get("cctId"));
            CCT cct = cctService.getCCTById(cctId);
            
            if (cct==null) {
                map.put("reason", "cct not exists.");
                return map;
            }
            
            List themes = new ArrayList(20);
            for (CategoryReference ref : (Set<CategoryReference>) cct.getRootCategory().getChildren()) {
                themes.add(ref.getTheme());
            }
            
            if ("true".equals((String) params.get("asHTML"))) {
                request.setAttribute("cct", cct);
                request.setAttribute("themes", themes);
                map.put("html", WebContextFactory.get().forwardToString("/WEB-INF/jsp/cvo/cstThemes.jsp"));
            } else {
                map.put("themes", themes);
            }
            
            map.put("successful", true);
        } catch(Exception e) {
            e.printStackTrace();
            map.put("successful", false);
            map.put("reason", e.getMessage());
            return map;
        }
        
        return map;
    }//getThemes()
    
    
    /**
     * Save summary of a theme.
     *
     * @param params A map contains:<br>
     *         <ul>
     *           <li>cctId - int, the current CCT instance id</li>
     *           <li>themeId - int, theme id</li>
     *           <li>summary - string, the new summary to be saved</li>
     *         </ul>
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *         </ul>
     */
    public Map saveSummary(Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        try {
            Long cctId = new Long((String) params.get("cctId"));
            Long themeId = new Long((String) params.get("themeId"));
            String summary = (String) params.get("summary");
            
            cstService.saveSummary(cctId, themeId, summary);
            
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
