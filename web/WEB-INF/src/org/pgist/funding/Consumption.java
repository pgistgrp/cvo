package org.pgist.funding;

import java.io.Serializable;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import org.pgist.users.User;


/**
 * A zip code object that corrilates gas tax with the zip code
 * 
 * @author Matt Paulin
 * @hibernate.class table="pgist_consumption" lazy="true"
 */
public class Consumption implements Serializable {
    
	private Float incomeUpper;
	private Float incomeLower;
	private Float size1;
	private Float size2;
	private Float size3;
	private Float size4;
	private Float size5;

    private Long id;
	
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
     * @hibernate.property not-null="true"
     */
	public Float getIncomeLower() {
		return incomeLower;
	}
	public void setIncomeLower(Float incomeLower) {
		this.incomeLower = incomeLower;
	}

    /**
     * @return
     * 
     * @hibernate.property not-null="true"
     */
	public Float getIncomeUpper() {
		return incomeUpper;
	}
	public void setIncomeUpper(Float incomeUpper) {
		this.incomeUpper = incomeUpper;
	}
	
    /**
     * @return
     * 
     * @hibernate.property not-null="true"
     */	
	public Float getSize1() {
		return size1;
	}
	public void setSize1(Float size1) {
		this.size1 = size1;
	}
	
    /**
     * @return
     * 
     * @hibernate.property not-null="true"
     */	
	public Float getSize2() {
		return size2;
	}
	public void setSize2(Float size2) {
		this.size2 = size2;
	}
	
    /**
     * @return
     * 
     * @hibernate.property not-null="true"
     */	
	public Float getSize3() {
		return size3;
	}
	public void setSize3(Float size3) {
		this.size3 = size3;
	}
	
    /**
     * @return
     * 
     * @hibernate.property not-null="true"
     */	
	public Float getSize4() {
		return size4;
	}
	public void setSize4(Float size4) {
		this.size4 = size4;
	}
	
    /**
     * @return
     * 
     * @hibernate.property not-null="true"
     */	
	public Float getSize5() {
		return size5;
	}
	public void setSize5(Float size5) {
		this.size5 = size5;
	}

	
	
}//class UserCommute