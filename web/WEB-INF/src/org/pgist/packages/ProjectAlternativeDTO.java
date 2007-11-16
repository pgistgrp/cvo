package org.pgist.packages;

/**
 * Passes information about a project alternative DTO
 * 
 * @author Matt Paulin
 */
public class ProjectAlternativeDTO {

	private String name;
	private Long projectAlternativeID;
	private float moneyNeeded;
	private String projGrade;
	private String yourGrade;
	private String avgGrade;
	 
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
	public float getMoneyNeeded() {
		return moneyNeeded;
	}
	/**
	 * @param moneyNeeded the moneyNeeded to set
	 */
	public void setMoneyNeeded(float moneyNeeded) {
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
	
	
}
