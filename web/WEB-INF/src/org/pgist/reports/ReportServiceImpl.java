package org.pgist.reports;

import java.util.Collection;

import org.pgist.packages.ClusteredPackage;


public class ReportServiceImpl implements ReportService{
	
	private ReportDAO reportDAO;

	public void setReportDAO(ReportDAO reportDAO) {
		this.reportDAO = reportDAO;
	}
	
	
	public void createStatistics(Long workflowId, Long cctId, Long projSuiteId, Long fundSuiteId, Long critSuiteId, Long projISID, Long fundISID) throws Exception {
		reportDAO.createStatistics(workflowId, cctId, projSuiteId, fundSuiteId, critSuiteId, projISID, fundISID);
	}
	
	
	public ClusteredPackage getPreferredClusteredPackage(Long pkgSuiteId) throws Exception {
		return reportDAO.getPreferredClusteredPackage(pkgSuiteId);
	}
	
	
	public Collection getVoteSuiteStats(Long pkgSuiteId) throws Exception {
		return reportDAO.getVoteSuiteStats(pkgSuiteId);
	}
	
}
