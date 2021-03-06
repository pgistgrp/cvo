package org.pgist.criteria;

import java.util.Collection;
import java.util.Date;
import java.util.Set;
import java.util.SortedSet;

import org.pgist.cvo.CCT;
import org.pgist.cvo.CCTDAO;
import org.pgist.discussion.DiscussionDAO;
import org.pgist.discussion.InfoObject;
import org.pgist.discussion.InfoStructure;


/**
 * 
 * @author kenny
 *
 */
public class CriteriaServiceImpl implements CriteriaService {
    
    
    private CriteriaDAO criteriaDAO;
    
    private DiscussionDAO discussionDAO;
    
    private CCTDAO cctDAO;
    

	public void setCriteriaDAO(CriteriaDAO criteriaDAO) {
        this.criteriaDAO = criteriaDAO;
    }


	public void setCctDAO(CCTDAO cctDAO) {
		this.cctDAO = cctDAO;
	}
    

	public DiscussionDAO getDiscussionDAO() {
        return discussionDAO;
    }


    public void setDiscussionDAO(DiscussionDAO discussionDAO) {
        this.discussionDAO = discussionDAO;
    }
    
    
    /*
     * ------------------------------------------------------------------------
     */


    public Collection getCriterias() throws Exception {
        return null;
    }//getCriterias()
    
    
    public Criteria addCriterion(Boolean bool_infoObjects, Boolean bool_objectives, String name, Set infoObjects,  SortedSet objectives, String na) throws Exception {
    		
    	return criteriaDAO.addCriterion(bool_infoObjects, bool_objectives, name, infoObjects, objectives, na);
    }//addCriterion()
    
    
    public void addAssocCriterion(Long critId, Long critSuiteId, boolean checked) throws Exception {
    	criteriaDAO.addAssocCriterion(critId, critSuiteId, checked);
    } //assocCriterion()
    
    
    public void deleteCriterion(Long id) throws Exception {
    	criteriaDAO.deleteCriterion(id);
    }//deleteCriterion
    
    
    public boolean getContainsCriteria(Long critId, Long critSuiteId) throws Exception {
    	return criteriaDAO.getContainsCriteria(critId, critSuiteId);
    }
    
    public void editCriterion(boolean bool_name, boolean bool_infoObjects, boolean bool_objectives, Criteria c, String name, Set infoObjects, SortedSet objectives, String na) throws Exception {	
    	criteriaDAO.editCriterion(bool_name, bool_infoObjects, bool_objectives, c, name, infoObjects, objectives, na);
    }//editCriterion()
    
    
    public Criteria getCriterionById(Long id) throws Exception {
    	return criteriaDAO.getCriterionById(id);
    }//getCriterionById()
    
    
    public Collection getAllCriterion(Long critSuiteId) throws Exception {  
    	return criteriaDAO.getAllCriterion(critSuiteId);
    }//getAllCriterion()

    
    public Collection getAllCriterion() throws Exception { 
    	return criteriaDAO.getAllCriterion();
    }//getAllCriterion()
    
    
    public Objective addObjective(Long critId, String description) throws Exception {
    	return criteriaDAO.addObjective(critId, description);
    }//addCriterion()
    
    /*
    public List getThemes(Long cctId) throws Exception {
    	CCT cct = cctDAO.getCCTById(cctId);           
        Set refs = cct.getRootCategory().getChildren();          
        List themes = new ArrayList(refs.size());           
        Map themesMap = new HashMap();
        
        for (CategoryReference ref : (Set<CategoryReference>) refs) {
            Theme theme = ref.getTheme();
            themesMap.put(ref.getId(), theme);
            themes.add(theme);
        }//for
        return themes;
    }//getThemes()
    */
    
    public Set<InfoObject> getInfoObjects(String[] infoObjectsIdList)throws Exception {
        return criteriaDAO.getInfoObjects(infoObjectsIdList);
    }//getInfoObjects()
    
    
    public SortedSet getObjectiveObjects(String[] objectiveIdList) throws Exception {
        return criteriaDAO.getObjectiveObjects(objectiveIdList);
    }//getObjectiveObjects()
    
    
    public void deleteObjective(Long id) throws Exception {
    	criteriaDAO.deleteObjective(id);
    }//deleteObjective
    
   
    public Collection getObjectives() throws Exception {
    	return criteriaDAO.getObjectives();
    }//getObjectives()
    
    
    public int getWeight(Long critSuiteId, Long critId) throws Exception {
    	return criteriaDAO.getWeight(critSuiteId, critId);
    }//getWeights()
    
    
    public CCT getCCTById(Long cctId) throws Exception {
    	CCT cct = cctDAO.getCCTById(cctId);
    	return cct;
    } //getCctById();
    
    
    public Collection getCCTs() throws Exception {
    	Collection ccts = cctDAO.getCCTs();
    	return ccts;
    }


    public void setWeight(Long suiteId, Long critId, int weight) throws Exception {
    	Criteria criteria = criteriaDAO.getCriterionById(critId);
    	criteriaDAO.setWeight(suiteId, criteria, weight);
    }
    
    
    public CriteriaSuite getCriteriaSuiteById(Long id) throws Exception {
    	
    	return criteriaDAO.getCriteriaSuiteById(id);
    }//getCriteriaSuiteById()
    
    
    public Collection getCriteriaSuites() throws Exception {
    	return criteriaDAO.getCriteriaSuites();
    }//getCriteriaSuiteById()


    public CriteriaSuite createCriteriaSuite() throws Exception {
        CriteriaSuite suite = new CriteriaSuite();
        
        criteriaDAO.save(suite);
        return suite;
    }//createCriteriaSuite()


    public InfoStructure publish(Long workflowId, Long cctId, Long suiteId, String title) throws Exception {
        CCT cct = cctDAO.getCCTById(cctId);
        
        CriteriaSuite suite = criteriaDAO.getCriteriaSuiteById(suiteId);
        
        Date date = new Date();
        
        Long checkId = criteriaDAO.checkPublished(cctId);
        InfoStructure structure = null;
        
        if(checkId == null) {         
	        structure = new InfoStructure();
            structure.getDiscussion().setWorkflowId(workflowId);
        } else {
        	structure = (InfoStructure) criteriaDAO.load(InfoStructure.class, checkId);
        	structure.deleteInfoObjects();
        }
        
        structure.setSuiteId(suiteId);
        structure.setType("sdcrit");
        structure.setTitle(title);
        structure.setRespTime(date);
        structure.setCctId(cct.getId());
        discussionDAO.save(structure);
        
        for (CriteriaRef ref : suite.getReferences()) {
            ref.getCriterion();
            ref.getGrade();
            ref.getId();
            ref.getObjectiveGrades();
            ref.getSuite();
            
            InfoObject obj = new InfoObject();
            obj.getDiscussion().setWorkflowId(workflowId);
            obj.setObject(ref);
            obj.setRespTime(date);
            discussionDAO.save(obj);
            
            structure.getInfoObjects().add(obj);
        }//for ref
        
        discussionDAO.save(structure);
        
        return structure;
    }//publish()
    
    
    public void editObjective(Long objectiveId, String description) throws Exception {
    	criteriaDAO.editObjective(objectiveId, description);
    }
    
    
    public Collection getOrphanInfoObjects(Long suiteId, Long isid) throws Exception {
        /*
         * Search the isid for sdc from the given isid for sdcrit
         */
        isid = criteriaDAO.getSDCIsidFromSDCritIsid(isid);
        
    	Collection infoObjects = criteriaDAO.getInfoObjects(isid);
    	
    	return criteriaDAO.getOrphanInfoObjects(suiteId, infoObjects);
    }
    
    
    public Set getInfoObjects(Long isid) throws Exception {
    	return criteriaDAO.getInfoObjects(isid);
    }
    
    
}//class CriteriaServiceImpl
