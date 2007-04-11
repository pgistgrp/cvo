package org.pgist.funding;

import java.io.Serializable;

import org.pgist.users.User;


/**
 * A UserCommute object hold the commute information for one user.
 * 
 * @author Kenny
 * 
 * @hibernate.class table="pgist_funding_user_commute" lazy="true"
 */
public class UserCommute implements Serializable {
    
    
    private Long id;
    
    private FundingSourceSuite fundingSuite;
    
    private User user;
    
    private float annualConsume;
    
    private float costPerGallon;
    
    /**
     * @return
     * 
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
     * 
     * @hibernate.many-to-one column="suite_id" cascade="none"
     */
    public FundingSourceSuite getFundingSuite() {
        return fundingSuite;
    }


    public void setFundingSuite(FundingSourceSuite fundingSuite) {
        this.fundingSuite = fundingSuite;
    }


    /**
     * @return
     * 
     * @hibernate.many-to-one column="user_id" cascade="none"
     */
    public User getUser() {
        return user;
    }


    public void setUser(User user) {
        this.user = user;
    }

    /**
     * @return
     * 
     * @hibernate.property not-null="true"
     */
    public float getAnnualConsume() {
        return annualConsume;
    }


    public void setAnnualConsume(float annualConsume) {
        this.annualConsume = annualConsume;
    }


    /**
     * @return
     * 
     * @hibernate.property not-null="true"
     */
	public float getCostPerGallon() {
		return costPerGallon;
	}


	public void setCostPerGallon(float costPerGallon) {
		this.costPerGallon = costPerGallon;
	}


}//class UserCommute
