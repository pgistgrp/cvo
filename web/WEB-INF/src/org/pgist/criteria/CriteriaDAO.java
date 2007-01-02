package org.pgist.criteria;

import java.util.Collection;
import java.util.Set;
import org.pgist.cvo.CCT;

import org.pgist.system.BaseDAO;


/**
 * 
 * @author kenny
 *
 */
public interface CriteriaDAO extends BaseDAO {
    
	
	Criteria addCriterion(String name, CCT cct, Set themes,  Set objectives, String na) throws Exception;
    
	
	void deleteCriterion(Long id) throws Exception;
    
	
	void editCriterion(Criteria c, String name, CCT cct, Set themes, Set objectives, String na) throws Exception;
	
	
	Criteria getCriterionById(Long id) throws Exception;
	
	
	Collection getAllCriterion(CCT cct) throws Exception;
	
	
	Objective addObjective(String description) throws Exception;
	
	
	Set getThemeObjects(String[] themeIdList)throws Exception;
	
	
	Set getObjectiveObjects(String[] objectivesIdList)throws Exception;
	
	
	void deleteObjective(Long id) throws Exception;
	
	
	Collection getObjectives() throws Exception;
	
	
	void setWeight(CCT cct, Criteria criteria, int weight) throws Exception;
	
	
	Set getWeights(CCT cct) throws Exception;
	
	
}//interface CriteriaDAO
