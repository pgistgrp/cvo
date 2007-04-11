package org.pgist.funding;

import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

import org.pgist.users.User;
import org.pgist.users.Vehicle;

/**
 * Special DTO for transfering information about the users tax information back and forth between
 * the java script and the java server
 *  
 * @author Matt Paulin
 */
public class UserTaxInfoDTO implements Serializable {

    private Long userId;
	
    private Set<Vehicle> vehicles = new HashSet<Vehicle>();
	
    protected int familyCount = 1;
    
    protected float income;

    protected int driveDays;
    
    protected int carpoolDays;
    
    protected int carpoolPeople;
    
    protected int busDays;
    
    protected int walkDays;
    
    protected int bikeDays;
    
    protected String zipcode = "";
    
    protected String workZipcode = "";
    
    protected UserTolls userTolls = new UserTolls();
        
    private float annualConsume;
    
    private float costPerGallon;
    
    private Set<PersonalFundingCost> costs = new HashSet<PersonalFundingCost>();
    
	/**
     * Loads the provided User Object with all the information contained in this tax DTO
     */
    public void loadUserWithData(User user) {
    	user.setIncome(this.getIncome());
    	user.setFamilyCount(this.getFamilyCount());

    	user.setWorkZipcode(this.getWorkZipcode());
    	user.setZipcode(this.getZipcode());

    	user.setDriveDays(this.getDriveDays());
    	user.setCarpoolDays(this.getCarpoolDays());
    	user.setCarpoolPeople(this.getCarpoolPeople());
    	user.setBusDays(this.getBusDays());
    	user.setWalkDays(this.getWalkDays());
    	user.setBikeDays(this.getBikeDays());
    }
    
    /**
     * Loads this DTO with the information from the provided User
     * 
     * @param	user	The user to get the information from
     */
    public void loadWithUserInfo(User user) {
    	this.setUserId(user.getId());
    	this.setIncome(user.getIncome());
    	this.setFamilyCount(user.getFamilyCount());
    	
    	this.setWorkZipcode(user.getWorkZipcode());
    	this.setZipcode(user.getZipcode());
    	
    	this.setDriveDays(user.getDriveDays());
    	this.setCarpoolDays(user.getCarpoolDays());
    	this.setCarpoolPeople(user.getCarpoolPeople());
    	this.setBusDays(user.getBusDays());
    	this.setWalkDays(user.getWalkDays());
    	this.setBikeDays(user.getBikeDays());
    	
    	this.setVehicles(user.getVehicles());
    }
    
    //---------------------Getters and Setters-----------------------------
    /**
	 * @return the costs
	 */
	public Set<PersonalFundingCost> getCosts() {
		return costs;
	}

	/**
	 * @param costs the costs to set
	 */
	public void setCosts(Set<PersonalFundingCost> costs) {
		this.costs = costs;
	}	
    
    /**
	 * @return the bikeDays
	 */
	public int getBikeDays() {
		return bikeDays;
	}

	/**
	 * @param bikeDays the bikeDays to set
	 */
	public void setBikeDays(int bikeDays) {
		this.bikeDays = bikeDays;
	}

	/**
	 * @return the busDays
	 */
	public int getBusDays() {
		return busDays;
	}

	/**
	 * @param busDays the busDays to set
	 */
	public void setBusDays(int busDays) {
		this.busDays = busDays;
	}

	/**
	 * @return the carpoolDays
	 */
	public int getCarpoolDays() {
		return carpoolDays;
	}

	/**
	 * @param carpoolDays the carpoolDays to set
	 */
	public void setCarpoolDays(int carpoolDays) {
		this.carpoolDays = carpoolDays;
	}

	/**
	 * @return the carpoolPeople
	 */
	public int getCarpoolPeople() {
		return carpoolPeople;
	}

	/**
	 * @param carpoolPeople the carpoolPeople to set
	 */
	public void setCarpoolPeople(int carpoolPeople) {
		this.carpoolPeople = carpoolPeople;
	}

	/**
	 * @return the driveDays
	 */
	public int getDriveDays() {
		return driveDays;
	}

	/**
	 * @param driveDays the driveDays to set
	 */
	public void setDriveDays(int driveDays) {
		this.driveDays = driveDays;
	}

	/**
	 * @return the familyCount
	 */
	public int getFamilyCount() {
		return familyCount;
	}

	/**
	 * @param familyCount the familyCount to set
	 */
	public void setFamilyCount(int familyCount) {
		this.familyCount = familyCount;
	}

	/**
	 * @return the income
	 */
	public float getIncome() {
		return income;
	}

	/**
	 * @param income the income to set
	 */
	public void setIncome(float income) {
		this.income = income;
	}

	/**
	 * @return the userId
	 */
	public Long getUserId() {
		return userId;
	}

	/**
	 * @param userId the userId to set
	 */
	public void setUserId(Long userId) {
		this.userId = userId;
	}

	/**
	 * @return the userTolls
	 */
	public UserTolls getUserTolls() {
		return userTolls;
	}

	/**
	 * @param userTolls the userTolls to set
	 */
	public void setUserTolls(UserTolls userTolls) {
		this.userTolls = userTolls;
	}

	/**
	 * @return the vehicles
	 */
	public Set<Vehicle> getVehicles() {
		return vehicles;
	}

	/**
	 * @param vehicles the vehicles to set
	 */
	public void setVehicles(Set<Vehicle> vehicles) {
		this.vehicles = vehicles;
	}

	/**
	 * @return the walkDays
	 */
	public int getWalkDays() {
		return walkDays;
	}

	/**
	 * @param walkDays the walkDays to set
	 */
	public void setWalkDays(int walkDays) {
		this.walkDays = walkDays;
	}

	/**
	 * @return the workZipcode
	 */
	public String getWorkZipcode() {
		return workZipcode;
	}

	/**
	 * @param workZipcode the workZipcode to set
	 */
	public void setWorkZipcode(String workZipcode) {
		this.workZipcode = workZipcode;
	}

	/**
	 * @return the zipcode
	 */
	public String getZipcode() {
		return zipcode;
	}

	/**
	 * @param zipcode the zipcode to set
	 */
	public void setZipcode(String zipcode) {
		this.zipcode = zipcode;
	}

	/**
	 * @return the annualConsume
	 */
	public float getAnnualConsume() {
		return annualConsume;
	}

	/**
	 * @param annualConsume the annualConsume to set
	 */
	public void setAnnualConsume(float annualConsume) {
		this.annualConsume = annualConsume;
	}

	/**
	 * @return the costPerGallon
	 */
	public float getCostPerGallon() {
		return costPerGallon;
	}

	/**
	 * @param costPerGallon the costPerGallon to set
	 */
	public void setCostPerGallon(float costPerGallon) {
		this.costPerGallon = costPerGallon;
	}
    
}
