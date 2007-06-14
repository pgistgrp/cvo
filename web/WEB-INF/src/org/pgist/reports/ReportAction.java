package org.pgist.reports;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.pgist.criteria.CriteriaService;
import org.pgist.criteria.CriteriaSuite;
import org.pgist.cvo.CSTService;
import org.pgist.cvo.CCTService;
import org.pgist.cvo.CCT;
import org.pgist.projects.ProjectService;
import org.pgist.projects.ProjectSuite;
import org.pgist.projects.ProjectRef;
import org.pgist.funding.FundingService;
import org.pgist.funding.FundingSourceSuite;
import org.pgist.packages.PackageService;
import org.pgist.packages.PackageSuite;
import org.pgist.packages.UserPackage;
import org.pgist.users.User;
import org.pgist.users.UserInfo;
import org.pgist.util.WebUtils;

import java.util.SortedSet;
import java.util.Collection;
import java.util.Set;
import java.util.Iterator;


/**
 * An action for step 5 reports<br>
 * 
 * This action accepts such parameters:<br>
 * <ul>
 *   <li>cctId - long, Id of the CCT object</li>
 *   <li>critSuiteId - long, id of the criteria suite</li>
 *   <li>packSuiteId - long, id of the package suite</li>
 * </ul>
 * 
 * The control will be forwarded to page with the mapping name of "reports", with the following variables available:<br>
 * <ul>
 *   <li>cr - a list or criteria references</li>
 *   <li>summaries - a list of themes</li>
 *   <li>pr - a list of project references</li>
 * </ul>
 * 
 * @author kenny
 *
 */

public class ReportAction extends Action {

	private CCTService cctService;
	private CSTService cstService;
	private CriteriaService criteriaService;
//	private ProjectService projectService;
//	private FundingService fundingService;
	private PackageService packageService;
	

	public void setCstService(CSTService cstService) {
		this.cstService = cstService;
	}
	
	public void setCctService(CCTService cctService) {
		this.cctService = cctService;
	}
	
	public void setCriteriaService(CriteriaService criteriaService) {
		this.criteriaService = criteriaService;
	}
	
//	public void setProjectService(ProjectService projectService) {
//		this.projectService = projectService;
//	}
//
//	public void setFundingService(FundingService fundingService) {
//		this.fundingService = fundingService;
//	}

	public void setPackageService(PackageService packageService) {
		this.packageService = packageService;
	}
	
    public ActionForward execute(
            ActionMapping mapping,
            ActionForm form,
            javax.servlet.http.HttpServletRequest request,
            javax.servlet.http.HttpServletResponse response
    ) throws java.lang.Exception {
    	
    	String strCctId = request.getParameter("cctId");
    	String strCritSuiteId = request.getParameter("critSuiteId");
//    	String strProjSuiteId = request.getParameter("projSuiteId");
//    	String strFundSuiteId = request.getParameter("fundSuiteId");
    	String strPackSuiteId = request.getParameter("packSuiteId");
    	
        if (strCctId==null || "".equals(strCctId.trim())) {
            request.setAttribute("error", "cctId cannot be empty");
            return mapping.findForward("reports");
        }     
        if (strCritSuiteId==null || "".equals(strCritSuiteId.trim())) {
            request.setAttribute("error", "critSuiteId cannot be empty");
            return mapping.findForward("reports");
        }
//        if (strProjSuiteId==null || "".equals(strProjSuiteId.trim())) {
//            request.setAttribute("error", "projSuiteId cannot be empty");
//            return mapping.findForward("reports");
//        }
//        if (strFundSuiteId==null || "".equals(strFundSuiteId.trim())) {
//            request.setAttribute("error", "fundSuiteId cannot be empty");
//            return mapping.findForward("reports");
//        }
        if (strPackSuiteId==null || "".equals(strPackSuiteId.trim())) {
            request.setAttribute("error", "packSuiteId cannot be empty");
            return mapping.findForward("reports");
        }
        
        Long cctId = Long.parseLong(strCctId);
        Long critSuiteId = Long.parseLong(strCritSuiteId);
//        Long projSuiteId = Long.parseLong(strProjSuiteId);
//        Long fundSuiteId = Long.parseLong(strFundSuiteId);
        Long packSuiteId = Long.parseLong(strPackSuiteId);

        //1, get Concern Summaries
        CCT cct = cctService.getCCTById(cctId);
        Collection summaries = cstService.getThemes(cct);
        
        //2, get Criteria
    	CriteriaSuite cs = criteriaService.getCriteriaSuiteById(critSuiteId);
    	Collection cr = cs.getReferences();
    	
    	//3, get Project - not needed?
//    	ProjectSuite ps = projectService.getProjectSuite(projSuiteId);
//    	Collection pr = ps.getReferences();
//    	
//    	//4, get Funding - not needed?
//    	FundingSourceSuite fs = fundingService.getFundingSuite(fundSuiteId);
//    	Collection fr = fs.getReferences();
    	
    	//5, get Packages
    	PackageSuite pkgSuite = packageService.getPackageSuite(packSuiteId);
    	Collection userPkgs = pkgSuite.getUserPkgs();
    	UserInfo userInfo = WebUtils.currentUser();
    	Iterator it = userPkgs.iterator();
    	UserPackage up = new UserPackage();
    	
    	while(it.hasNext()) {
    		UserPackage userPackage = (UserPackage) it.next();
    		if(userPackage.getAuthor().getId().equals(userInfo.getId())) {
    			up = userPackage;
    			break;
    		}
    	}
    	
    	// get cluster packages
    	Collection cp = pkgSuite.getClusteredPkgs();
    	
    	
    	//Sets the Criteria References which contain criteria and grades.
    	request.setAttribute("summaries", summaries);
    	request.setAttribute("cr", cr);
//    	request.setAttribute("pr", pr);
//    	request.setAttribute("fr", fr);
    	request.setAttribute("up", up);
    	request.setAttribute("cp", cp);
    	
    	
        return mapping.findForward("reports");
    }//execute()


} //ReportAction
