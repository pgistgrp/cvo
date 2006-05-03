package org.pgist.cvo;

import java.util.Collection;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import org.pgist.system.UserDAO;
import org.pgist.util.PageSetting;
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


    public void setAnalyzer(TagAnalyzer analyzer) {
        this.analyzer = analyzer;
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


    public void save(Concern concern) throws Exception {
        cctDAO.save(concern);
    }//save()
    
    
    public CCT getCCTById(Long cctId) throws Exception {
        return cctDAO.getCCTById(cctId);
    }//getCCTById()


    public Concern createConcern(CCT cct, Concern concern, String[] tagStrs) throws Exception {
        concern.setCct(cct);
        concern.setCreateTime(new Date());

        synchronized (this) {
            Tag tag = null;
            TagReference ref = null;
            for (String tagName : tagStrs) {
                tag = analyzer.tagExists(tagName);
                if (tag!=null) {
                    ref = cctDAO.getTagReferenceByTagId(cct.getId(), tag.getId());
                } else {
                    tag = new Tag();
                    tag.setName(tagName);
                    tag.setDescription(tagName);
                    tag.setStatus(Tag.STATUS_CANDIDATE);
                    cctDAO.save(tag);
                    
                    analyzer.addTag(tag);
                    
                    ref = new TagReference();
                    ref.setTag(tag);
                    ref.setTimes(0);
                    ref.setCctId(cct.getId());
                    cctDAO.save(ref);
                }
                ref.setTimes(ref.getTimes()+1);
                cctDAO.save(ref);
                concern.getTags().add(ref);
            }//for
        }//synchronized
        
        cctDAO.save(concern);
        cctDAO.save(cct);

        return concern;
    }//createConcern()


    public Collection getMyConcerns(CCT cct) throws Exception {
        return cctDAO.getMyConcerns(cct.getId(), WebUtils.currentUserId());
    }//getMyConcerns()


    public Collection getOthersConcerns(CCT cct, int count) throws Exception {
        return cctDAO.getOthersConcerns(cct.getId(), WebUtils.currentUserId(), count);
    }//getOthersConcerns()


    public Collection getRandomConcerns(CCT cct, PageSetting setting) throws Exception {
        return cctDAO.getRandomConcerns(cct.getId(), WebUtils.currentUserId(), setting);
    }//getRandomConcerns()


    public Collection getTagsByRank(CCT cct, int count) throws Exception {
        return tagDAO.getTagsByRank(cct, count);
    }//getTagsByRank()


    public Collection getTagsByThreshold(CCT cct, int threshold) throws Exception {
        return tagDAO.getTagsByThreshold(cct, threshold);
    }//getTagsByThreshold()


    public Collection getConcernsByTag(Long tagRefId, int count) throws Exception {
        TagReference tagRef = tagDAO.getTagReferenceById(tagRefId);
        if (tagRef==null) throw new Exception("Requested TagReference doesn't exist.");
        return cctDAO.getConcernsByTag(tagRef, count);
    }//getConcernsByTag()

    public Collection getSuggestedTags(String statement) throws Exception{
    	return analyzer.parseTextTokenized(statement);
    }//getSuggestedTags


    public Concern getConcernById(Long concernId) throws Exception {
        return cctDAO.getConcernById(concernId);
    }//getConcernById()


    public void deleteConcern(Concern concern) throws Exception {
        CCT cct = concern.getCct();
        
        synchronized (this) {
            Set oldTags = new HashSet(concern.getTags());
            concern.getTags().clear();
            
            for (Object object : oldTags) {
                TagReference ref = (TagReference) object;
                ref.setTimes(ref.getTimes()-1);
                if (ref.getTimes()<1) {
                    cctDAO.delete(ref);
                } else {
                    cctDAO.save(ref);
                }
            }//for
        }//synchronized
        
        concern.setDeleted(true);
        concern.setCreateTime(new Date());
        
        cctDAO.save(concern);
        cctDAO.save(cct);
    }//deleteConcern()


    public void editConcernTags(Concern concern, String[] tagStrs) throws Exception {
        System.out.println("tag array: ");
        for (int i = 0; i < tagStrs.length; i++) {
            System.out.print("---> "+tagStrs[i]);
        }
        System.out.println();
        
        //Collection tags = analyzer.ensureTags(tagStrs);
        
        CCT cct = concern.getCct();
        
        synchronized (this) {
            Set oldTags = new HashSet(concern.getTags());
            concern.getTags().clear();
            
            Tag tag = null;
            TagReference ref = null;
            for (String tagName : tagStrs) {
                tag = analyzer.tagExists(tagName);
                if (tag!=null) {
                    tag = cctDAO.getTagById(tag.getId());
                    ref = cctDAO.getTagReferenceByTagId(cct.getId(), tag.getId());
                    if (oldTags.contains(ref)) {
                        oldTags.remove(ref);
                    } else {
                        ref.setTimes(ref.getTimes()+1);
                    }
                } else {
                    tag = new Tag();
                    tag.setName(tagName);
                    tag.setDescription(tagName);
                    tag.setStatus(Tag.STATUS_CANDIDATE);
                    cctDAO.save(tag);
                    ref = new TagReference();
                    ref.setTag(tag);
                    ref.setTimes(1);
                    ref.setCctId(cct.getId());
                    cctDAO.save(ref);
                }
                cctDAO.save(concern);
                cctDAO.save(ref);
                concern.getTags().add(ref);
            }//for
            
            for (Object object : oldTags) {
                ref = (TagReference) object;
                ref.setTimes(ref.getTimes()-1);
                if (ref.getTimes()<1) {
                    cctDAO.delete(ref);
                } else {
                    cctDAO.save(ref);
                }
            }//for
            
        }//synchronized
        
        concern.setCreateTime(new Date());
        
        cctDAO.save(concern);
        cctDAO.save(cct);
    }//editConcernTags()


    public int getConcernsTotal(CCT cct, int whose) throws Exception {
        return cctDAO.getConcernsTotal(cct, whose, WebUtils.currentUserId());
    }//getConcernsTotal()


    public TagReference getTagReferenceById(Long tagRefId) throws Exception {
        return tagDAO.getTagReferenceById(tagRefId);
    }//getTagReferenceById()


    public Collection searchTags(CCT cct, String tag) throws Exception {
        return cctDAO.searchTags(cct.getId(), tag);
    }//searchTags()


}//class CCTServiceImpl
