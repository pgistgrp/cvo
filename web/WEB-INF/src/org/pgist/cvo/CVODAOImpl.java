package org.pgist.cvo;

import org.springframework.orm.hibernate3.support.HibernateDaoSupport;


/**
 * 
 * @author kenny
 *
 */
public class CVODAOImpl extends HibernateDaoSupport implements CVODAO {
    
    
    public CCT getCCTById(Long cctId) throws Exception {
        return (CCT) getHibernateTemplate().get(CCT.class, cctId);
    }//getCCTById()


    public Concern getConcernById(Long concernId) throws Exception {
        return (Concern) getHibernateTemplate().get(Concern.class, concernId);
    }//getConcernById()


    public Tag getTagById(Long tagId) throws Exception {
        return (Tag) getHibernateTemplate().get(Tag.class, tagId);
    }//getTagById()
    
    
    public void save(CCT cct) throws Exception {
        getHibernateTemplate().saveOrUpdate(cct);
    }//save()


    public void save(Concern concern) throws Exception {
        getHibernateTemplate().saveOrUpdate(concern);
    }//save()


    public void save(Tag tag) throws Exception {
        getHibernateTemplate().saveOrUpdate(tag);
    }//save()


}//class CVODAOImpl
