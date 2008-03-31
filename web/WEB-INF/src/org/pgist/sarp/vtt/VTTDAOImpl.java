package org.pgist.sarp.vtt;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.hibernate.Query;
import org.pgist.system.BaseDAOImpl;
import org.pgist.users.User;
import org.pgist.util.PageSetting;
import org.pgist.util.WebUtils;


/**
 * 
 * @author kenny
 *
 */
public class VTTDAOImpl extends BaseDAOImpl implements VTTDAO {
    
    
    @Override
    public VTT getVTTById(Long vttId) throws Exception {
        return (VTT) load(VTT.class, vttId);
    } //getVTTById()
    
    
    private static final String hql_getComments1 = "select count(id) from VTTComment c where c.deleted=false and c.catRef.id=?";
    private static final String hql_getComments2 = "from VTTComment c where c.deleted=false and c.catRef.id=? order by c.id desc";
    
    
    @Override
    public Collection<VTTComment> getComments(Long catRefId, PageSetting setting) throws Exception {
        List<VTTComment> list = new ArrayList<VTTComment>();
        
        //get total rows number
        Query query = getSession().createQuery(hql_getComments1);
        query.setLong(0, catRefId);
        int count = ((Number) query.uniqueResult()).intValue();
        
        if (count==0) return list;
        
        if (setting.getRowOfPage()==-1) setting.setRowOfPage(count);
        setting.setRowSize(count);
        
        //get records
        query = getSession().createQuery(hql_getComments2);
        query.setLong(0, catRefId);
        query.setFirstResult(setting.getFirstRow());
        query.setMaxResults(setting.getRowOfPage());
        
        return query.list();
    } //getComments()


    private static final String hql_increaseVoting_21 = "update VTTComment c set c.numVote=c.numVote+1 where c.id=?";
    
    private static final String hql_increaseVoting_22 = "update VTTComment c set c.numAgree=c.numAgree+1 where c.id=?";
    
    
    @Override
    public void increaseVoting(VTTComment comment, boolean agree) throws Exception {
        getSession().createQuery(hql_increaseVoting_21).setLong(0, comment.getId()).executeUpdate();
        if (agree) {
            getSession().createQuery(hql_increaseVoting_22).setLong(0, comment.getId()).executeUpdate();
        }
    } //increaseVoting()


    private static final String hql_getOtherUsers = "from User u where u.id in (select indices(vtt.categories) from VTT vtt where vtt.id=?) and u.id<>? order by u.loginname";
    
    
    @Override
    public List<User> getOtherUsers(VTT vtt) throws Exception {
        return getHibernateTemplate().find(hql_getOtherUsers, new Object[] {
                vtt.getId(),
                WebUtils.currentUserId(),
        });
    } //getOtherUsers()


    @Override
    public CategoryValue getCategoryValueById(Long id) throws Exception {
        return (CategoryValue) getHibernateTemplate().load(CategoryValue.class, id);
    } //getCategoryValueById()
    
    
} //class VTTDAOImpl
