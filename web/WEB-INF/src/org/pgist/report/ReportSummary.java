package org.pgist.report;

import java.io.Serializable;

/**
 * <span style="color:red;">POJO</span>: PGIST Report Summary Class<br>
 * <span style="color:red;">TABLE</span>: pgist_crit
 * 
 * <p>ReportSummary class contains Report Summary text for each package
 * 
 * @author John
 * 
 * @hibernate.class table="pgist_report_summary" lazy="true"
 */
public class ReportSummary implements Serializable {

    /**
     * <span style="color:blue;">(Column.)</span>
     * id of the announcement. Unique id number used to identify each announcement.
     */
	private Long id;

	private String executiveSummary;
	
	private String participantsSummary; 
	
	private String concernSummary;
	
	private String criteriaSummary;
	
	private String projectSummary;
	
	private String packageSummary;
	
	private boolean finalized = false;
	
	
    /**
     * @return
     * @hibernate.property not-null="true"
     */
    public boolean isFinalized() {
		return finalized;
	}

	public void setFinalized(boolean finalized) {
		this.finalized = finalized;
	}

	/**
     * @hibernate.id generator-class="native"
     */
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

    /**
     * @return
     * @hibernate.property type="text" not-null="false"
     */
	public String getConcernSummary() {
		return concernSummary;
	}

	public void setConcernSummary(String concernSummary) {
		this.concernSummary = concernSummary;
	}

    /**
     * @return
     * @hibernate.property type="text" not-null="false"
     */
	public String getCriteriaSummary() {
		return criteriaSummary;
	}

	public void setCriteriaSummary(String criteriaSummary) {
		this.criteriaSummary = criteriaSummary;
	}

    /**
     * @return
     * @hibernate.property type="text" not-null="false"
     */
	public String getExecutiveSummary() {
		return executiveSummary;
	}

	public void setExecutiveSummary(String executiveSummary) {
		this.executiveSummary = executiveSummary;
	}

    /**
     * @return
     * @hibernate.property type="text" not-null="false"
     */
	public String getPackageSummary() {
		return packageSummary;
	}

	public void setPackageSummary(String packageSummary) {
		this.packageSummary = packageSummary;
	}

    /**
     * @return
     * @hibernate.property type="text" not-null="false"
     */
	public String getParticipantsSummary() {
		return participantsSummary;
	}

	public void setParticipantsSummary(String participantsSummary) {
		this.participantsSummary = participantsSummary;
	}

    /**
     * @return
     * @hibernate.property type="text" not-null="false"
     */
	public String getProjectSummary() {
		return projectSummary;
	}

	public void setProjectSummary(String projectSummary) {
		this.projectSummary = projectSummary;
	}
	
	
} //class ReportSummary
