package org.pgist.packages;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.pgist.funding.FundingService;
import org.pgist.projects.ProjectService;
import org.pgist.users.User;
import org.pgist.util.WebUtils;


/**
 * Shows the details of a specified package to participant.<br>
 * 
 * The action accepts two parameters:
 * <ul>
 *   <li>pkgId - int, an id of a ClusteredPackage object</li>
 *   <li>pkgSuiteId - the id of a specified PackageSuite object</li>
 *   <li>projSuiteId - the id of a specified PackageSuite object</li>
 *   <li>fundSuiteId - the id of a specified FundingSuite object</li>
 *   <li>critSuiteId - the id of a specified CriteriaSuite object</li>
 * </ul>
 * 
 * The action will always forward to the jsp page specified in struts-config.xml
 * with the forward name as "view".
 * In that jsp page, the following request attributes are available:
 * <ul>
 *   <li>package - a ClusteredPackage object</li>
 * </ul>
 * 
 * @author kenny
 */
public class PackageAction extends Action {
    
    
    private PackageService packageService;
    
    
    public void setPackageService(PackageService packageService) {
        this.packageService = packageService;
    }

    private ProjectService projectService;
    
    public void setProjectService(ProjectService projectService) {
        this.projectService = projectService;
    }

    private FundingService fundingService;
    
    public void setFundingService(FundingService fundingService) {
        this.fundingService = fundingService;
    }
    
    /*
     * ------------------------------------------------------------------------
     */
    
    
    public ActionForward execute(
            ActionMapping mapping,
            ActionForm form,
            javax.servlet.http.HttpServletRequest request,
            javax.servlet.http.HttpServletResponse response
    ) throws Exception {
    	String tempPkgId = request.getParameter("pkgId");
    	String tempPackageSuiteId = request.getParameter("pkgSuiteId");
    	String tempProjSuiteId = request.getParameter("projSuiteId");
    	String tempFundSuiteId = request.getParameter("fundSuiteId");
    	String tempCritSuiteId = request.getParameter("critSuiteId");
    	
    	Long pkgId = new Long(tempPkgId);
		Long packSuite = new Long(tempPackageSuiteId);
		Long projSuite = new Long(tempProjSuiteId);
		Long fundSuite = new Long(tempFundSuiteId);
		Long critSuite = new Long(tempCritSuiteId);    	

		ClusteredPackage uPack = this.packageService.getClusteredPackage(pkgId);   
		//Grade it
    	User user = this.packageService.getUser(WebUtils.currentUser());		
		
		request.setAttribute("package", uPack);    		
		request.setAttribute("packageRoadProjects", this.packageService.createPackageRoadProjectDTOs(uPack, critSuite, projSuite, user));
		request.setAttribute("packageTransitProjects", this.packageService.createPackageTransitProjectDTOs(uPack, critSuite, projSuite, user));
		request.setAttribute("packageFunding", this.packageService.createPackageFundingDTOs(uPack, user, fundSuite));
		
    	System.out.println("***uPackid" + uPack.getId() + " crit " + critSuite + " proj " + projSuite + " user " + user.getLoginname() + "crap " + this.packageService.createPackageTransitProjectDTOs(uPack, critSuite, projSuite, user));
    	
        request.setAttribute("PGIST_SERVICE_SUCCESSFUL", true);
        
        return mapping.findForward("view");
    }//execute()
    
    
}//class PackageAction
