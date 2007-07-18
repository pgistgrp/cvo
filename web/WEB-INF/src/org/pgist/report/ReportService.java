package org.pgist.report;

import java.util.Collection;
import java.util.Map;

import org.pgist.discussion.InfoStructure;
import org.pgist.packages.ClusteredPackage;

public interface ReportService {

	
	void createStatistics(Long workflowId, Long cctId, Long repoSuiteId, Long packSuiteId) throws Exception;
	
	ClusteredPackage getPreferredClusteredPackage(Long pkgSuiteId) throws Exception;
	
	Collection getVoteSuiteStats(Long pkgSuiteId) throws Exception;
	
	ReportSuite getReportSuiteById(Long id) throws Exception;
	
	void editReportSummary(Long reportSummaryId, String executiveSummary, String participantsSummary, String concernSummary, String criteriaSummary, String projectSummary, String packageSummary, boolean finalized) throws Exception;
	
	ReportSuite createReportSuite() throws Exception;
	
	InfoStructure publish(Long workflowId, Long cctId, Long suiteId, String title) throws Exception;
	
	void createReportVote(Long suiteId, boolean vote) throws Exception;
	
	boolean getUserVoted(Long suiteId, Long userId) throws Exception;
	
	Map getVoteStats(Long suiteId) throws Exception;
	
}
 