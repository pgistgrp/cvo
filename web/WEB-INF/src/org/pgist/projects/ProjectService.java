package org.pgist.projects;

import java.util.Collection;
import java.util.List;
import java.util.Map;


/**
 * @author Guirong
 *
 */
public interface ProjectService {
    
    
    Project getProjectById(Long pid) throws Exception;
    
	Project getProject(Long pId) throws Exception;
    
    Collection getProjects() throws Exception;
    
	List getProjects(String criteria) throws Exception;
    
	double[][][] getFootprint(Long fpid) throws Exception;
    
	Map getFootprints(String criteria) throws Exception;
    
	void saveProject(Project project) throws Exception;
    
	void saveProject(Project project, ProjectAlternative alternative) throws Exception;
    
	void saveFootprint(ProjectAlternative pa, double[][][] coords,String geoType) throws Exception;
    
    void publishProjects(String criteria) throws Exception;
    
    
    Project createProject(String name, String description) throws Exception;
    
    
}//interface ProjectService
