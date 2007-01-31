package org.pgist.funding;

import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

import org.pgist.cvo.CCT;
import org.pgist.users.User;


/**
 * @author Kenny
 * 
 * @hibernate.class table="pgist_user_commute" lazy="true"
 */
public class UserCommute implements Serializable {
    
    
    private Long id;
    
    private User user;
    
    private CCT cct;
    
    private Set tolls = new HashSet();
    
    private Set costs = new HashSet();
    
    private float annualConsume;
    
    
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
     * @hibernate.many-to-one column="cct_id" cascade="none"
     */
    public CCT getCct() {
        return cct;
    }


    public void setCct(CCT cct) {
        this.cct = cct;
    }


    public Set getTolls() {
        return tolls;
    }


    public void setTolls(Set tolls) {
        this.tolls = tolls;
    }


    public Set getCosts() {
        return costs;
    }


    public void setCosts(Set costs) {
        this.costs = costs;
    }


    public float getAnnualConsume() {
        return annualConsume;
    }


    public void setAnnualConsume(float annualConsume) {
        this.annualConsume = annualConsume;
    }


}//class UserCommute