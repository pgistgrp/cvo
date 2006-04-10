package org.pgist.cvo;

import java.util.Collection;
import java.util.List;


/**
 * 
 * @author kenny
 *
 */
public class TagDAOImpl extends CVODAOImpl implements TagDAO {
    
    
    public List addTags(String[] tags) throws Exception {
        return null;
    }//addTags()
    
    
    private static String hql_getTagsByRank = "from TagReference tr where tr.cct=? order by tr.times desc";
    
    
    public Collection getTagsByRank(CCT cct, int count) throws Exception {
        getHibernateTemplate().setMaxResults(count);
        return getHibernateTemplate().find(hql_getTagsByRank, cct);
    }//getTagsByRank()


    private static String getTagsByThreshold = "from TagReference tr where tr.cct=? and tr.times>? order by tr.times desc";
    
    
    public Collection getTagsByThreshold(CCT cct, int threshold) throws Exception {
        return getHibernateTemplate().find(
                getTagsByThreshold,
                new Object[] {
                        cct,
                        new Integer(threshold),
                }
        );
    }//getTagsByThreshold()

    
    private static String hql_getAllTags = "from Tag t where t.status!=?";
    
    
    public Collection getAllTags() throws Exception {
        return getHibernateTemplate().find(hql_getAllTags, new Integer(Tag.STATUS_REJECTED));
    }//getAllTags
    
    
}//class TagDAOImpl
