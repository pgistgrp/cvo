package org.pgist.cvo;

import java.util.Collection;
import java.util.Date;

import org.pgist.system.UserDAO;
import org.pgist.util.WebUtils;


/**
 * 
 * @author kenny
 *
 */
public class CCTServiceImpl implements CCTService {
    
    
    private UserDAO userDAO = null;
    
    private CCTDAO cctDAO = null;

    private TagDAO tagDAO = null;
    
    private TagAnalyzer analyzer = null;
    
    
    public void setUserDAO(UserDAO userDAO) {
        this.userDAO = userDAO;
    }


    public void setCctDAO(CCTDAO cctDAO) {
        this.cctDAO = cctDAO;
    }


    public void setTagDAO(TagDAO tagDAO) {
        this.tagDAO = tagDAO;
    }
    
    
    /*
     * ------------------------------------------------------------------------
     */
    
    
    public Collection getCCTs() throws Exception {
        return cctDAO.getCCTs();
    }//getCCTs()


    public void save(CCT cct) throws Exception {
        cctDAO.save(cct);
    }//save()


    public CCT getCCTById(Long cctId) throws Exception {
        return cctDAO.getCCTById(cctId);
    }//getCCTById()


    public Concern createConcern(CCT cct, Concern concern, String[] tagStrs) throws Exception {
        concern.setCct(cct);
        concern.setCreateTime(new Date());
        
        Collection tags = analyzer.ensureTags(tagStrs);
        cct.addConcern(concern, tags);
        
        cctDAO.save(cct);
        
        return concern;
    }//createConcern()


    public Collection getMyConcerns(CCT cct) throws Exception {
        return cctDAO.getMyConcerns(cct.getId(), WebUtils.currentUserId());
    }//getMyConcerns()


    public Collection getOthersConcerns(CCT cct, int count) throws Exception {
        return cctDAO.getOthersConcerns(cct.getId(), WebUtils.currentUserId(), count);
    }//getOthersConcerns()


    public Collection getTagsByRank(CCT cct, int count) throws Exception {
        return tagDAO.getTagsByRank(cct, count);
    }//getTagsByRank()


    public Collection getTagsByThreshold(CCT cct, int threshold) throws Exception {
        return tagDAO.getTagsByThreshold(cct, threshold);
    }//getTagsByThreshold()
    
    
}//class CCTServiceImpl
