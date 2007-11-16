/**
 * 
 */
package org.pgist.projects;

import java.sql.Connection;
import java.util.List;
import java.util.Map;

/**
 * @author Guirong
 *
 */
public interface ProjectService {
	public Project getProject(Long pId) throws Exception;
	public List getProjects(String criteria) throws Exception;
	public Map getFootprints(String criteria) throws Exception;
	public void saveProject(Project project) throws Exception;
	public void saveProject(Project project, ProjectAlternative alternative) throws Exception;
	public void saveFootprint(Connection conn, Project project, double[][] coords, int[] parts, String geoType) throws Exception;
}
