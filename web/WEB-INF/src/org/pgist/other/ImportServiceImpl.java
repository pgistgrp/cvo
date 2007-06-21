package org.pgist.other;

import java.io.File;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;
import org.pgist.criteria.Criteria;
import org.pgist.criteria.CriteriaDAO;
import org.pgist.criteria.CriteriaRef;
import org.pgist.criteria.CriteriaSuite;
import org.pgist.criteria.CriteriaUserWeight;
import org.pgist.criteria.Objective;
import org.pgist.cvo.CCTDAO;
import org.pgist.funding.FundingDAO;
import org.pgist.funding.FundingSourceSuite;
import org.pgist.packages.PackageDAO;
import org.pgist.projects.GradedCriteria;
import org.pgist.projects.GradedObjective;
import org.pgist.projects.Project;
import org.pgist.projects.ProjectAltRef;
import org.pgist.projects.ProjectAlternative;
import org.pgist.projects.ProjectDAO;
import org.pgist.projects.ProjectRef;
import org.pgist.projects.ProjectSuite;
import org.pgist.util.WebUtils;


/**
 * The service class for importing situation template.
 * 
 * @author kenny
 */
public class ImportServiceImpl implements ImportService {
    
    
    private CCTDAO cctDAO;
    
    private CriteriaDAO criteriaDAO;
    
    private ProjectDAO projectDAO;
    
    private FundingDAO fundingDAO;
    
    private PackageDAO packageDAO;
    
    private ImportDAO importDAO;
    
    
    public void setCctDAO(CCTDAO cctDAO) {
        this.cctDAO = cctDAO;
    }


    public void setCriteriaDAO(CriteriaDAO criteriaDAO) {
        this.criteriaDAO = criteriaDAO;
    }


    public void setPackageDAO(PackageDAO packageDAO) {
        this.packageDAO = packageDAO;
    }


    public void setProjectDAO(ProjectDAO projectDAO) {
        this.projectDAO = projectDAO;
    }


    public void setFundingDAO(FundingDAO fundingDAO) {
        this.fundingDAO = fundingDAO;
    }


    public void setImportDAO(ImportDAO importDAO) {
        this.importDAO = importDAO;
    }


    /*
     * ------------------------------------------------------------------------
     */
    
    
    public Collection getTemplates() throws Exception {
        return importDAO.getTemplates();
    }//getTemplates()
    
    
    public void importTemplate(Long templateId, Long projSuiteId, Long fundSuiteId, Long critSuiteId) throws Exception {
        //load needed template
        SituationTemplate template = importDAO.getTemplateById(templateId);
        if (template==null) throw new Exception("can't find template with id: "+templateId);
        
        //load needed project suite
        ProjectSuite projSuite = projectDAO.getProjectSuite(projSuiteId);
        if (projSuite==null) throw new Exception("can't find project suite with id: "+projSuiteId);
        
        //load needed funding suite
        FundingSourceSuite fundSuite = fundingDAO.getFundingSuite(fundSuiteId);
        if (fundSuite==null) throw new Exception("can't find funding source suite with id: "+fundSuiteId);
        
        //load needed criteria suite
        CriteriaSuite critSuite = criteriaDAO.getCriteriaSuiteById(critSuiteId);
        if (critSuite==null) throw new Exception("can't find criteria suite with id: "+critSuiteId);
        
        SAXReader reader = new SAXReader();
        Document document = reader.read(new File(WebUtils.getContextPath(), template.getPath()));
        
        Map<String, CriteriaRef> critMap = new HashMap<String, CriteriaRef>();
        
        /*
         * Import criteria
         */
        for (Element critEle : (List<Element>) document.selectNodes("/template/projects/project/alternative/criterion")) {
            String name = critEle.attributeValue("name");
            
            System.out.println("process criterion ---> "+name);
            
            CriteriaRef ref = (CriteriaRef) critMap.get(name);
            
            if (ref==null) {
                Criteria crit = new Criteria();
                crit.setName(name);
                crit.setSuite(critSuite);
                
                criteriaDAO.save(crit);
                
                ref = new CriteriaRef();
                ref.setCriterion(crit);
                ref.setSuite(critSuite);
                
                criteriaDAO.save(ref);
                
                CriteriaUserWeight cuw = new CriteriaUserWeight();
                cuw.setSuite(critSuite);
                
                criteriaDAO.save(cuw);
                
                critSuite.getReferences().add(ref);
                critSuite.getWeights().put(ref, cuw);
                
                critMap.put(name, ref);
            }
            
            /*
             * Import objective
             */
            Map<String, Objective> objectives = new HashMap<String, Objective>();
            ref.getCriterion().setObject(objectives);
            
            for (Element objEle : (List<Element>) document.selectNodes("//criterion[@name='"+name+"']/objective")) {
                String description = objEle.attributeValue("description");
                
                System.out.println("process objective ---> "+description);
                
                Objective objective = objectives.get(description);
                
                if (objective==null) {
                    objective = new Objective();
                    objective.setDescription(description);
                    
                    ref.getCriterion().getObjectives().add(objective);
                    
                    objectives.put(description, objective);
                }
            }//for objEle
            
            criteriaDAO.save(ref);
        }//for critEle
        
        criteriaDAO.save(critSuite);
        
        /*
         * Import projects
         */
        for (Element projEle : (List<Element>) document.selectNodes("/template/projects/project")) {
            String projName = projEle.attributeValue("name");
            if (projName==null || projName.trim().length()==0) throw new Exception("project name is required!");
            
            Project project = projectDAO.getProjectByName(projName);
            if (project==null) throw new Exception("can't find project named \""+projName+"\"");
            
            ProjectRef projRef = new ProjectRef();
            projRef.setSuite(projSuite);
            projRef.setProject(project);
            projSuite.getReferences().add(projRef);
            
            for (Element altEle : (List<Element>) projEle.selectNodes("alternative")) {
                String projAltName = altEle.attributeValue("name");
                if (projAltName==null || projAltName.trim().length()==0) throw new Exception("project alternative name is required!");
                
                ProjectAlternative projAlt = projectDAO.getProjectAlternativeByName(projAltName);
                if (projAlt==null) throw new Exception("can't find project alternative named \""+projAltName+"\"");
                
                ProjectAltRef altRef = new ProjectAltRef();
                altRef.setAlternative(projAlt);
                altRef.setProjectRef(projRef);
                
                projRef.getAltRefs().add(altRef);
                
                for (Element critEle : (List<Element>) altEle.selectNodes("criterion")) {
                    String critName = critEle.attributeValue("name");
                    if (critName==null || critName.trim().length()==0) throw new Exception("criterion name is required!");
                    
                    CriteriaRef critRef = critMap.get(critName);
                    Map<String, Objective> objectives = (Map<String, Objective>) critRef.getCriterion().getObject();
                    
                    GradedCriteria gc = new GradedCriteria();
                    gc.setCriteria(critRef.getCriterion());
                    altRef.getGradedCriteria().add(gc);
                    
                    for (Element objEle : (List<Element>) critEle.selectNodes("objective")) {
                        String description = objEle.attributeValue("description");
                        if (description==null || description.trim().length()==0) throw new Exception("objective description is required!");
                        
                        Objective objective = objectives.get(description);
                        GradedObjective go = new GradedObjective();
                        go.setObjective(objective);
                        go.setGrade(Integer.parseInt(objEle.getTextTrim()));
                        
                        gc.getObjectives().add(go);
                    }//for objEle
                }//for critEle
            }//for altEle
            
            projectDAO.save(projSuite);
        }//for projEle
        
        /*
         * Import funding sources
         */
        //TODO
    }//importTemplate()


}//ImportService
