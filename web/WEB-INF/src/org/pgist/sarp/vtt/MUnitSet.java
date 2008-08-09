package org.pgist.sarp.vtt;

import java.util.HashMap;
import java.util.Map;

import org.pgist.sarp.cht.CategoryPath;


/**
 * Measurement Unit Set for one CategoryPath.
 * 
 * @author kenny
 *
 * @hibernate.class table="sarp_vtt_munit_set" lazy="true"
 */
public class MUnitSet {
    
    
    private Long id;
    
    private CategoryPath path;
    
    // map: unit --> frequency
    private Map<String, Integer> freqs = new HashMap<String, Integer>();
    
    // map: expert id --> expert unit
    private Map<Long, EUnitSet> expUnits = new HashMap<Long, EUnitSet>();
    
    // map: expert id --> comment
    private Map<Long, String> expComments = new HashMap<Long, String>();
    
    // map: user id --> unit selected by this user
    private Map<Long, String> userSelections= new HashMap<Long, String>();
    
    
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
     * @hibernate.many-to-one column="path_id" lazy="true"
     */
    public CategoryPath getPath() {
        return path;
    }
    
    
    public void setPath(CategoryPath path) {
        this.path = path;
    }


    /**
     * @return
     * 
     * @hibernate.map table="sarp_munitset_unit_freq_map"
     * @hibernate.collection-key column="munitset_id"
     * @hibernate.collection-index column="unit" type="string" length="32"
     * @hibernate.collection-element type="int" column="freq"
     */
    public Map<String, Integer> getFreqs() {
        return freqs;
    }
    public void setFreqs(Map<String, Integer> freqs) {
        this.freqs = freqs;
    }


    /**
     * @return
     * 
     * @hibernate.map table="sarp_munitset_exp_eunitset_map"
     * @hibernate.collection-key column="munitset_id"
     * @hibernate.collection-index column="exp_id" type="long"
     * @hibernate.collection-many-to-many column="eunitset_id" class="org.pgist.sarp.vtt.EUnitSet"
     */
    public Map<Long, EUnitSet> getExpUnits() {
        return expUnits;
    }
    public void setExpUnits(Map<Long, EUnitSet> expUnits) {
        this.expUnits = expUnits;
    }


    /**
     * @return
     * 
     * @hibernate.map table="sarp_munitset_exp_comment_map"
     * @hibernate.collection-key column="munitset_id"
     * @hibernate.collection-index column="exp_id" type="long"
     * @hibernate.collection-element type="string" column="comment" length="256"
     */
    public Map<Long, String> getExpComments() {
        return expComments;
    }
    public void setExpComments(Map<Long, String> expComments) {
        this.expComments = expComments;
    }


    
    
    /**
     * @return
     * 
     * @hibernate.map table="sarp_munitset_user_eunitset_map"
     * @hibernate.collection-key column="munitset_id"
     * @hibernate.collection-index column="user_id" type="long"
     * @hibernate.collection-element type="string" column="selected_unit" length="256"
     */
    public Map<Long, String> getUserSelections() {
        return userSelections;
    }


    public void setUserSelections(Map<Long, String> userSelections) {
        this.userSelections = userSelections;
    }
    
    
} //class MUnitSet
