package org.pgist.tagging;

import java.util.HashSet;
import java.util.Set;
import java.util.SortedSet;
import java.util.TreeSet;

import org.pgist.model.Node;


/**
 * 
 * @author kenny
 *
 * @hibernate.class table="pgist_categories" lazy="true"
 */
public class Category implements Node {
    
    
    protected Long id;
    
    protected String name;
    
    protected Category parent;
    
    protected Set children = new HashSet();
    
    protected SortedSet tags = new TreeSet(new TagComparator());
    
    protected boolean deleted = false;
    
    
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
     * @hibernate.many-to-one column="parent_id" lazy="true"
     */
    public Category getParent() {
        return parent;
    }


    public void setParent(Category parent) {
        this.parent = parent;
    }


    /**
     * @return
     * 
     * @hibernate.set lazy="true" table="pgist_categories" order-by="name"
     * @hibernate.collection-key column="parent_id"
     * @hibernate.collection-one-to-many class="org.pgist.tagging.Category"
     */
    public Set getChildren() {
        return children;
    }


    public void setChildren(Set children) {
        this.children = children;
    }


    /**
     * @return
     * 
     * @hibernate.set lazy="true" table="pgist_cat_tag_link" order-by="tag_id" sort="org.pgist.tagging.TagComparator"
     * @hibernate.collection-key column="category_id"
     * @hibernate.collection-many-to-many column="tag_id" class="org.pgist.tagging.Tag"
     */
    public SortedSet getTags() {
        return tags;
    }


    public void setTags(SortedSet tags) {
        this.tags = tags;
    }


    /**
     * @return
     * 
     * @hibernate.property not-null="true"
     */
    public boolean isDeleted() {
        return deleted;
    }


    public void setDeleted(boolean deleted) {
        this.deleted = deleted;
    }

    
    /*
     * ------------------------------------------------------------------------
     */
    
    
    public String toString() {
        return name;
    }
    
    
    public String getCaption() {
        return name;
    }
    
    
}//class Category
