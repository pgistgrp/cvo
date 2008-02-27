package org.pgist.sarp.cht;

import java.util.HashMap;
import java.util.Map;

import org.pgist.sarp.cst.CST;
import org.pgist.sarp.cst.CategoryReference;


/**
 * @author kenny
 *
 * @hibernate.class table="sarp_cht" lazy="true"
 */
public class CHT {
	
	
	private Long id;
	
    private String name = "";
    
    private String purpose = "";
    
    private String instruction = "";
    
    private Map<Long, CategoryReference> categories = new HashMap<Long, CategoryReference>();
    
    private Map<Long, CategoryReference> favorites = new HashMap<Long, CategoryReference>();
    
    private CST cst;
    
    private boolean closed;
    
	
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
    public String getName() {
        return name;
    }


    public void setName(String name) {
        this.name = name;
    }


    /**
     * @return
     * 
     * @hibernate.property type="text" not-null="true"
     */
    public String getInstruction() {
        return instruction;
    }


    public void setInstruction(String instruction) {
        this.instruction = instruction;
    }


    /**
     * @return
     * 
     * @hibernate.property type="text" not-null="true"
     */
    public String getPurpose() {
        return purpose;
    }


    public void setPurpose(String purpose) {
        this.purpose = purpose;
    }


    /**
     * @return
     * 
     * @hibernate.map table="sarp_cht_user_category_map"
     * @hibernate.collection-key column="cht_id"
     * @hibernate.collection-index column="user_id" type="long"
     * @hibernate.collection-many-to-many column="root_catref_id" class="org.pgist.sarp.cst.CategoryReference"
     */
	public Map<Long, CategoryReference> getCategories() {
		return categories;
	}


	public void setCategories(Map<Long, CategoryReference> categories) {
		this.categories = categories;
	}


    /**
     * @return
     * 
     * @hibernate.map table="sarp_cht_user_favorite_map"
     * @hibernate.collection-key column="cht_id"
     * @hibernate.collection-index column="user_id" type="long"
     * @hibernate.collection-many-to-many column="favorite_catref_id" class="org.pgist.sarp.cst.CategoryReference"
     */
	public Map<Long, CategoryReference> getFavorites() {
		return favorites;
	}


	public void setFavorites(Map<Long, CategoryReference> favorites) {
		this.favorites = favorites;
	}


    /**
     * @return
     * 
     * @hibernate.many-to-one column="cst_id" lazy="true" class="org.pgist.sarp.cst.CST"
     */
    public CST getCst() {
		return cst;
	}


	public void setCst(CST cst) {
		this.cst = cst;
	}


	/**
     * @return
     * 
     * @hibernate.property not-null="true"
     */
	public boolean isClosed() {
		return closed;
	}


	public void setClosed(boolean closed) {
		this.closed = closed;
	}


}//class CHT
