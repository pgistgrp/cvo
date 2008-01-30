package org.pgist.sarp.drt;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.hibernate.Query;
import org.pgist.system.BaseDAOImpl;
import org.pgist.util.PageSetting;


/**
 * @author kenny
 *
 */
public class DRTDAOImpl extends BaseDAOImpl implements DRTDAO {
	
	
	@Override
	public InfoObject getInfoObjectById(Long oid) throws Exception {
		return (InfoObject) load(InfoObject.class, oid);
	}//getInfoObjectById()
	
	
	private static final String hql_getComments1 = "select count(id) from Comment c where c.target.id=?";
	private static final String hql_getComments2 = "from Comment c where c.target.id=? order by c.id desc";
	
	
	@Override
	public Collection<Comment> getComments(Long oid, PageSetting setting) throws Exception {
        List<Comment> list = new ArrayList<Comment>();
        
        //get total rows number
        Query query = getSession().createQuery(hql_getComments1);
        query.setLong(0, oid);
        int count = ((Number) query.uniqueResult()).intValue();
        
        if (count==0) return list;
        
        if (setting.getRowOfPage()==-1) setting.setRowOfPage(count);
        setting.setRowSize(count);
        
        //get records
        query = getSession().createQuery(hql_getComments2);
        query.setLong(0, oid);
        query.setFirstResult(setting.getFirstRow());
        query.setMaxResults(setting.getRowOfPage());
        
        return query.list();
	}//getComments()


    private static final String hql_increaseVoting_1 = "update InfoObject i set i.numVote=i.numVote+1 where i.id=?";
    
    private static final String hql_increaseVoting_2 = "update InfoObject i set i.numAgree=i.numAgree+1 where i.id=?";
    
    
	@Override
    public void increaseVoting(InfoObject object, boolean agree) throws Exception {
        getSession().createQuery(hql_increaseVoting_1).setLong(0, object.getId()).executeUpdate();
        if (agree) {
            getSession().createQuery(hql_increaseVoting_2).setLong(0, object.getId()).executeUpdate();
        }
    }//increaseVoting()
	
	
}//class DRTDAOImpl
