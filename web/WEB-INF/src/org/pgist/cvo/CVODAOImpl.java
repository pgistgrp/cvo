package org.pgist.cvo;

import java.util.Collection;
import java.util.List;

import org.hibernate.Query;
import org.pgist.model.DiscourseObject;
import org.pgist.model.Post;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;


public class CVODAOImpl extends HibernateDaoSupport implements CVODAO {
    
    
    public void savePost(Post post) throws Exception {
        getSession().save(post);
    }
    
    
    public void saveDO(DiscourseObject dobj) throws Exception {
        getSession().save(dobj);
    }
    
    
    public void saveCVO(CVO cvo) throws Exception {
        getSession().save(cvo);
    }
    
    
    private final static String hql_getCVOList = "from CVO cvo where cvo.deleted=:deleted";
    
    
    public Collection getCVOList() throws Exception {
        Query query = getSession().createQuery(hql_getCVOList);
        query.setBoolean("deleted", false);
        return query.list();
    }//getCVOList()
    
    
    private final static String hql_getCVOById = "from CVO cvo where cvo.deleted=:deleted and cvo.id=:id";
    
    
    public CVO getCVOById(Long id) {
        CVO cvo = null;
        Query query = getSession().createQuery(hql_getCVOById);
        query.setBoolean("deleted", false);
        query.setLong("id", id.longValue());
        List list = query.list(); 
        if (list.size()>0) {
            cvo = (CVO) list.get(0);
        }
        return cvo;
    }//getCVOById()


    private final static String hql_getPostById = "from Post post where post.id=:id";
    
    
    public Post getPostById(Long id) {
        Post post = null;
        Query query = getSession().createQuery(hql_getPostById);
        query.setLong("id", id.longValue());
        List list = query.list(); 
        if (list.size()>0) {
            post = (Post) list.get(0);
        }
        return post;
    }//getPostById()
    
    
}
