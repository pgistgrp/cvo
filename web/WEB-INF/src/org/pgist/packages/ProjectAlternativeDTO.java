package org.pgist.packages;

import org.pgist.projects.ProjectAlternative;

/**
 * Passes information about a project alternative DTO
 * 
 * @author Matt Paulin
 */
public class ProjectAlternativeDTO implements Comparable<ProjectAlternativeDTO> {

	private String name;
	private Long projectAlternativeID;
	private double moneyNeeded;
	private String projGrade;
	private String yourGrade;
	private String avgGrade;
	private String fpids;
	private Integer transMode;

	public ProjectAlternativeDTO(ProjectAlternative tempAlt) {
		this.name = tempAlt.getName();
		this.projectAlternativeID = tempAlt.getId();
		this.setAvgGrade("NA");
		this.setProjGrade("NA");
		this.setAvgGrade("NA");
		this.setMoneyNeeded(tempAlt.getCost());
		this.setFpids(tempAlt.getFpids());
		this.setTransMode(tempAlt.getProject().getTransMode());
	}

	/**
	 * @return the avgGrade
	 */
	public String getAvgGrade() {
		return avgGrade;
	}
	/**
	 * @param avgGrade the avgGrade to set
	 */
	public void setAvgGrade(String avgGrade) {
		this.avgGrade = avgGrade;
	}
	/**
	 * @return the moneyNeeded
	 */
	public double getMoneyNeeded() {
		return moneyNeeded;
	}
	/**
	 * @param moneyNeeded the moneyNeeded to set
	 */
	public void setMoneyNeeded(double moneyNeeded) {
		this.moneyNeeded = moneyNeeded;
	}
	/**
	 * @return the name
	 */
	public String getName() {
		return name;
	}
	/**
	 * @param name the name to set
	 */
	public void setName(String name) {
		this.name = name;
	}
	/**
	 * @return the projectAlternativeID
	 */
	public Long getProjectAlternativeID() {
		return projectAlternativeID;
	}
	/**
	 * @param projectAlternativeID the projectAlternativeID to set
	 */
	public void setProjectAlternativeID(Long projectAlternativeID) {
		this.projectAlternativeID = projectAlternativeID;
	}
	/**
	 * @return the projGrade
	 */
	public String getProjGrade() {
		return projGrade;
	}
	/**
	 * @param projGrade the projGrade to set
	 */
	public void setProjGrade(String projGrade) {
		this.projGrade = projGrade;
	}
	/**
	 * @return the yourGrade
	 */
	public String getYourGrade() {
		return yourGrade;
	}
	/**
	 * @param yourGrade the yourGrade to set
	 */
	public void setYourGrade(String yourGrade) {
		this.yourGrade = yourGrade;
	}
	/* (non-Javadoc)
	 * @see java.lang.Comparable#compareTo(java.lang.Object)
	 */
	public int compareTo(ProjectAlternativeDTO o) {
		return this.getName().compareTo(o.getName());
	}
	
	/**
	 * Just to keep a copy of the footprint IDs.
	 * @return
	 */
	public String getFpids() {
		return fpids;
	}

	public void setFpids(String fpids) {
		this.fpids = fpids;
	}

	public Integer getTransMode() {
		return transMode;
	}

	public void setTransMode(Integer transMode) {
		this.transMode = transMode;
	}
}
