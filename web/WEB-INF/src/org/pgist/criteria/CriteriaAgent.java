package org.pgist.criteria;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Collection;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import org.directwebremoting.WebContextFactory;
import org.pgist.cvo.CCTService;


/**
 * 
 * @author kenny
 *
 */
public class CriteriaAgent {
    
    
    private CriteriaService criteriaService;
    
    private CCTService cctService = null;

	public CCTService getCctService() {
		return cctService;
	}


	public void setCctService(CCTService cctService) {
		this.cctService = cctService;
	}


	public void setCriteriaService(CriteriaService criteriaService) {
        this.criteriaService = criteriaService;
    }
    
    
    /*
     * ------------------------------------------------------------------------
     */
    
    
    /**
     * Add one new criterion to the system.
     * 
     * @param params a Map contains:
     *   <ul>
     *     <li>name - string, name of the criteia</li>
     *     <li>themeIds - string, name of the themeid's separated by commas</li>
     *     <li>objectiveIds - string, list of Object Id's</li>	
     *     <li>cctId - string, cctId.</li>
     *     <li>na - string, descript. Optional.</li>
     *   </ul>
     * @return a Map contains:
     *   <ul>
     *     <li>successful - a boolean value denoting if the operation succeeds</li>
     *     <li>reason - reason why operation failed (valid when successful==false)</li>
     *     <li>id - int, the id for the new Criteria object.</li>
     *   </ul>
     */
    public Map addCriterion(Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        String name = (String) params.get("name");
    	String themeIds = (String) params.get("themeIds");
    	String objectiveIds = (String) params.get("objectiveIds");
    	String strCctId = (String) params.get("cctId");
    	String na = (String) params.get("na");
    	
    	if(name==null || "".equals(name.trim())){
    		map.put("reason", "Criterion name cannot be empty.");
    		return map;
    	}
    	if(themeIds==null || "".equals(themeIds.trim())){
    		map.put("reason", "themeIds cannot be empty.");
    		return map;
    	}
    	if(strCctId==null || "".equals(strCctId.trim())){
    		map.put("reason", "cctId cannot be empty.");
    		return map;
    	}
    	if(objectiveIds==null || "".equals(objectiveIds.trim())){
    		map.put("reason", "objectiveIds cannot be empty.");
    		return map;
    	}
    	if(objectiveIds==null || "".equals(objectiveIds.trim())){
    		na = "NONE";
    	}
    	Long cctId = new Long((String) params.get("cctId"));
    	
        try {
        	String[] themeIdList = themeIds.split(",");
        	Set themes = criteriaService.getThemeObjects(themeIdList);
        	String[] objectiveIdList = objectiveIds.split(",");
        	Set objectives = criteriaService.getObjectiveObjects(objectiveIdList);
        	
        	Criteria c = criteriaService.addCriterion(name, cctId, themes, objectives, na);
        	map.put("id", c.getId());
            map.put("successful", true);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//addCriterion()
    
    
    /**
     * Delete a criterion from the system.
     * 
     * @param params a Map contains:
     *   <ul>
     *     <li>id - String, the id of the criterion to be deleted</li>
     *   </ul>
     * @return a Map contains:
     *   <ul>
     *     <li>successful - a boolean value denoting if the operation succeeds</li>
     *     <li>reason - reason why operation failed (valid when successful==false)</li>
     *   </ul>
     */
    public Map deleteCriterion(Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        String strId = (String)params.get("id");
        
        if(strId==null || "".equals(strId.trim())){
        	map.put("reason", "Criterion id cannot be null.");
    		return map;	
        }
        
        Long id = Long.parseLong(strId); 
        
        try {
        	criteriaService.deleteCriterion(id);
            map.put("successful", true);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//deleteCriterion()
    
    
    /**
     * Edit an existing criterion.
     * 
     * @param params a Map contains:
     *   <ul>
     *     <li>id - string, id of the criterion</li>
     *     <li>name - string, name of the criteia</li>
     *     <li>themeIds - string, name of the themeid's separated by commas</li>
     *     <li>objectiveIds - string, list of Object Id's</li>	
     *     <li>cctId - string, cctId.</li>
     *     <li>na - string, descript. Optional.</li>
     *   </ul>
     * @return a Map contains:
     *   <ul>
     *     <li>successful - a boolean value denoting if the operation succeeds</li>
     *     <li>reason - reason why operation failed (valid when successful==false)</li>
     *   </ul>
     */
    public Map editCriterion(Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        String strId = (String) params.get("id");
        String name = (String) params.get("name");
    	String themeIds = (String) params.get("themeIds");
    	String objectiveIds = (String) params.get("objectiveIds");
    	String strCctId = (String) params.get("cctId");
    	String na = (String) params.get("na");
    	
    	if(strId==null || "".equals(strId.trim())){
    		map.put("reason", "Criterion id cannot be empty.");
    		return map;
    	}
    	if(name==null || "".equals(name.trim())){
    		map.put("reason", "Criterion name cannot be empty.");
    		return map;
    	}
    	if(themeIds==null || "".equals(themeIds.trim())){
    		map.put("reason", "themeIds cannot be empty.");
    		return map;
    	}
    	if(strCctId==null || "".equals(strCctId.trim())){
    		map.put("reason", "cctId cannot be empty.");
    		return map;
    	}
    	if(objectiveIds==null || "".equals(objectiveIds.trim())){
    		map.put("reason", "objectiveIds cannot be empty.");
    		return map;
    	}
    	if(objectiveIds==null || "".equals(objectiveIds.trim())){
    		na = "NONE";
    	}
    	Long cctId = new Long(strCctId);
    	Long id = new Long(strId);
       
        try {
        	Criteria c = criteriaService.getCriterionById(id);
        	
        	String[] themeIdList = themeIds.split(",");
        	Set themes = criteriaService.getThemeObjects(themeIdList);
        	String[] objectiveIdList = objectiveIds.split(",");
        	Set objectives = criteriaService.getObjectiveObjects(objectiveIdList);
        	
        	criteriaService.editCriterion(c, name, cctId, themes, objectives, na);
            map.put("successful", true);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//editCriterion()
    
    
    /**
     * Get the theme list for the given cct.
     * 
     * @param params a Map contains:
     *   <ul>
     *     <li>cctId - int, the id of an CCT object</li>
     *   </ul>
     * 
     * @return a Map contains:
     *   <ul>
     *     <li>successful - a boolean value denoting if the operation succeeds</li>
     *     <li>reason - reason why operation failed (valid when successful==false)</li>
     *     <li>
     *       html - a HTML source segment. (Generated by /WEB-INF/jsp/criteria/criteriaAssoc_themes.jsp)<br>
     *       The following variables are available for use in the jsp:
     *         <ul>
     *           <li>cct - A CCT objects</li>
     *           <li>themesList - A list of theme objects</li>
     *         </ul>
     *     </li>
     *   </ul>
     */
    public Map getThemes(Map params) {
        Map map = new HashMap();
        map.put("successful", false);    
        
        
        Long cctId = new Long((String) params.get("cctId"));
  
        try {        	
            List themes = criteriaService.getThemes(cctId);
            
            map.put("themeList", themes);
            map.put("successful", true);   
            
        } catch (Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
            return map;
        }
        
        return map;
    }//getThemes()
    
    
    /**
     * Get a Criteria object with the given id.
     * 
     * @param params a Map contains:
     *   <ul>
     *     <li>id - int, id of the Criteia object</li>
     *   </ul>
     * @return a Map contains:
     *   <ul>
     *     <li>successful - a boolean value denoting if the operation succeeds</li>
     *     <li>reason - reason why operation failed (valid when successful==false)</li>
     *     <li>criterion - if successful the criteria object</li>
     *   </ul>
     */
    public Map getCriterionById(Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        String strId = (String)params.get("id");
        
        if(strId==null || "".equals(strId.trim())){
        	map.put("reason", "Criterion id cannot be null.");
    		return map;	
        }
        
        Long id = Long.parseLong(strId);
        
        try {
        	Criteria c = criteriaService.getCriterionById(id);
        	map.put("criterion", c);
            map.put("successful", true);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//getCriterionById()
    
    
    /**
     * Publish the current association of the given cct.
     * 
     * @param params a Map contains:
     *   <ul>
     *     <li>cctId - int, the id of an CCT object</li>
     *     <li>citeriaIds - list, of criterion ids separated by a comma</li>
     *   </ul>
     * @return a Map contains:
     *   <ul>
     *     <li>successful - a boolean value denoting if the operation succeeds</li>
     *     <li>reason - reason why operation failed (valid when successful==false)</li>
     *   </ul>
     */
    public Map publish(Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        String criteriaIds = (String) params.get("criteriaIds");
        
    	if(criteriaIds==null || "".equals(criteriaIds.trim())){
    		map.put("reason", "objectiveIds cannot be empty.");
    		return map;
    	}
    	
        try {
            Long cctId = new Long((String) params.get("cctId"));
            String[] criteriaIdList = criteriaIds.split(",");
            
            criteriaService.publish(cctId, criteriaIdList);
           
            map.put("successful", true);
        } catch(Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
            return map;
        }
        
        return map;
    }//publish()
    
    
    /**
     * Get all the weights of the current participant to the given cctId
     * 
     * @param params a Map contains:
     *   <ul>
     *     <li>cctId - string, the cctId</li>
     *   </ul>
     * @return a Map contains:
     *   <ul>
     *     <li>successful - a boolean value denoting if the operation succeeds</li>
     *     <li>reason - reason why operation failed (valid when successful==false)</li>
     *     <li>weights - a list of CriteriaWeight object</li>
     *   </ul>
     */
    public Map getWeights(Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        Long cctId = new Long((String) params.get("cctId"));
        
        try {
        	Set weights = criteriaService.getWeights(cctId);
        	
        	map.put("weights", weights);
            map.put("successful", true);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//getWeights()
    
    
    /**
     * Get all the weights of the current participant to the given InfoStructure
     * 
     * @param params a Map contains:
     *   <ul>
     *     <li>cctId - int, the id of an InfoStructure object</li>
     *     <li>critId - int, the id of an Criteria object</li>
     *     <li>weight - int, weight value</li>
     *   </ul>
     * @return a Map contains:
     *   <ul>
     *     <li>successful - a boolean value denoting if the operation succeeds</li>
     *     <li>reason - reason why operation failed (valid when successful==false)</li>
     *   </ul>
     */
    public Map setWeight(Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        String strCctId = (String) params.get("cctId");
        String strCritId= (String) params.get("critId");
    	String strWeight = (String) params.get("weight");
    	
    	if(strCctId==null || "".equals(strCctId.trim())){
    		map.put("reason", "CCT id cannot be empty.");
    		return map;
    	}
    	if(strCritId==null || "".equals(strCritId.trim())){
    		map.put("reason", "Criterion id cannot be empty.");
    		return map;
    	}
    	if(strWeight==null || "".equals(strWeight.trim())){
    		map.put("reason", "Weight id cannot be empty.");
    		return map;
    	}
    	
    	Long cctId = Long.parseLong(strCctId);
    	Long critId = Long.parseLong(strCritId);
    	int weight = Integer.parseInt(strWeight);
    	
        try {      	
        	criteriaService.setWeight(cctId, critId, weight);
            map.put("successful", true);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//setWeight()
    
    
    /**
     * Get all the Criterion Available
     * @param params An empty map.
     * <ul>
     *     <li>cctId - string, cctId</li>
     * </ul>
     * @return a Map contains:
     *   <ul>
     *     <li>criteria - A list of Criteria objects</li>
     *     <li>successful - a boolean value denoting if the operation succeeds</li>
     *     <li>reason - reason why operation failed (valid when successful==false)</li>
     *     <li>html- </li>
     *   </ul>
     */
    public Map getAllCriterion(HttpServletRequest request, Map params) {
    	
    	Map map = new HashMap();
        map.put("successful", false);
        
        Long cctId = new Long((String) params.get("cctId"));
        
        try {
        	Collection criteria = criteriaService.getAllCriterion(cctId);
        	request.setAttribute("criteria", criteria); 
        	map.put("criteria", criteria);
        	map.put("html", WebContextFactory.get().forwardToString("/WEB-INF/jsp/criteria/criteria.jsp"));
        	map.put("successful", true);
        	
        } catch (Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
        }
        
        return map;
    } //getAllCriterion()
    
    
    /**
	  * add Objective 
	 * @param params a Map contains:
	 *   <ul>
	 *     <li>description - string, name</li>
	 *   </ul>
	 * @return a Map contains:
	 *   <ul>
	 *     <li>successful - a boolean value denoting if the operation succeeds</li>
	 *     <li>reason - reason why operation failed (valid when successful==false)</li>
	 *   </ul>
	  */
	  public Map addObjective(Map params) {
		  Map map = new HashMap();
		  map.put("successful", false);
		  String description = (String) params.get("description");
	    
		  if(description==null || "".equals(description.trim())){
			  map.put("reason", "Objective name cannot be empty.");
			  return map;
		  }
		  
		  try {  	
			  criteriaService.addObjective(description);
			  map.put("successful", true);	
		  } catch (Exception e) {
			  e.printStackTrace();
			  map.put("reason", e.getMessage());
		  }
	    
		  return map;    	 
	  } //addObjective();

	  
	/**
     * Get all objectives
     * @param params An empty map.
     * @return a Map contains:
     *   <ul>
     *     <li>objectives - A set of Objective objects</li>
     *     <li>successful - a boolean value denoting if the operation succeeds</li>
     *     <li>reason - reason why operation failed (valid when successful==false)</li>
     *     <li>html- </li>
     *   </ul>
     */
     public Map getObjectives(HttpServletRequest request, Map params) {
     	Map map = new HashMap();
        map.put("successful", false);
        
        try {
        	Collection objectives = criteriaService.getObjectives();

        	request.setAttribute("objectives", objectives); 
        	map.put("objectsives", objectives);
        	map.put("html", WebContextFactory.get().forwardToString("/WEB-INF/jsp/criteria/criteria.jsp"));
        	map.put("successful", true);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
        }
        return map;    	 
     } //getObjectives();
     
     
     /**
     * deleteObjective
     * @param params a Map contains:
     *   <ul>
     *     <li>id - id object</li>
     *   </ul>
     * @return a Map contains:
     *   <ul>
     *     <li>successful - a boolean value denoting if the operation succeeds</li>
     *     <li>reason - reason why operation failed (valid when successful==false)</li>
     *   </ul>
     */
     public Map deleteObjective(Map params) {
	   Map map = new HashMap();
       map.put("successful", false);
       
       String strId = (String)params.get("id");
       
       if(strId==null || "".equals(strId.trim())){
       		map.put("reason", "Objective id cannot be null.");
       		return map;	
       }
       
       Long id = Long.parseLong(strId); 
       
       try {
       		criteriaService.deleteObjective(id);
       		map.put("successful", true);
       } catch (Exception e) {
           	e.printStackTrace();
           	map.put("reason", e.getMessage());
       } 
       
       return map;
     } //deleteObjective();
   
       
}//class CriteriaAgent
