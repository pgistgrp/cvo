package org.pgist.criteria;

import java.util.Collection;
import java.util.Set;
import org.pgist.cvo.CCT;
import java.util.Map;

import org.pgist.system.BaseDAO;
import org.pgist.cvo.Theme;

/**
 * 
 * @author kenny
 *
 */
public interface CriteriaDAO extends BaseDAO {
    
	
	Criteria addCriterion(Boolean bool_themes, Boolean bool_objectives, String name, Set themes,  Set objectives, String na) throws Exception;
    
	
	void addAssocCriterion(Long critId, Long critSuiteId, boolean checked) throws Exception;
	
	
	void deleteCriterion(Long id) throws Exception;
    
	
	boolean getContainsCriteria(Long critId, Long critSuiteId) throws Exception; 
	
	
	void editCriterion(boolean bool_name, boolean bool_themes, boolean bool_objectives, Criteria c, String name, Set themes, Set objectives, String na) throws Exception;
	
	
	Criteria getCriterionById(Long id) throws Exception;
	
	
	Set getCriterions(String[] criteriaIdList) throws Exception;
	
	
	Set getAllCriterion(Long critSuiteId) throws Exception;
	
	
	Collection getAllCriterion() throws Exception;
	
	
	Objective addObjective(String description) throws Exception;
	
	
	Set<Theme> getThemeObjects(String[] themeIdList)throws Exception;
	
	
	Set getObjectiveObjects(String[] objectivesIdList)throws Exception;
	
	
	void deleteObjective(Long id) throws Exception;
	
	
	Collection getObjectives() throws Exception;
	
	
	int getWeight(Long critSuiteId, Long critId) throws Exception;
	
	
	void setWeight(Long suiteId, Criteria criteria, int weight) throws Exception;
	
	
	CriteriaSuite getCriteriaSuiteById(Long id) throws Exception;
	
	
	Collection getCriteriaSuites() throws Exception;

	
	Long checkPublished(Long cctId) throws Exception;
	

}//interface CriteriaDAO
