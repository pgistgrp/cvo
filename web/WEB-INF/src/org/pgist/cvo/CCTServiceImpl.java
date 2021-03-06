package org.pgist.cvo;

import java.util.Collection;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import org.pgist.system.SystemDAO;
import org.pgist.system.UserDAO;
import org.pgist.system.YesNoVoting;
import org.pgist.tagging.Tag;
import org.pgist.tagging.TagAnalyzer;
import org.pgist.tagging.TagDAO;
import org.pgist.users.User;
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

    private SystemDAO systemDAO;
    

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


    public void setSystemDAO(SystemDAO systemDAO) {
        this.systemDAO = systemDAO;
    }


    /*
     * ------------------------------------------------------------------------
     */


    public Collection getCCTs() throws Exception {
        return cctDAO.getCCTs();
    } //getCCTs()


    public CCT createCCT(Long workflowId, String name, String purpose, String instruction) throws Exception {
        Date time = new Date();
        CCT cct = new CCT();

        CategoryReference catRef = new CategoryReference();
        catRef.setCct(cct);
        
        cct.setRootCategory(catRef);
        
        cct.setWorkflowId(workflowId);
        cct.setName(name);
        cct.setPurpose(purpose);
        cct.setInstruction(instruction);
        cct.setCreateTime(time);
        
        cctDAO.save(cct);
        
        return cct;
    } //createCCT()


    public void save(CCT cct) throws Exception {
        cctDAO.save(cct);
    } //save()


    public void save(Concern concern) throws Exception {
        cctDAO.save(concern);
    } //save()


    public CCT getCCTById(Long cctId) throws Exception {
        return cctDAO.getCCTById(cctId);
    } //getCCTById()


    public Concern createConcern(Long cctId, String concern, String[] tagStrs) throws Exception {
        CCT cct = cctDAO.getCCTById(cctId);
        if (cct == null) throw new Exception("cct not found");

        Concern c = new Concern();
        c.setCct(cct);
        c.setCreateTime(new Date());
        c.setContent(concern);
        c.setReplyTime(c.getCreateTime());

        Long id = WebUtils.currentUserId();
        User user = userDAO.getUserById(id, true, false);
        c.setAuthor(user);

        Tag tag = null;
        TagReference ref = null;
        for (String tagName : tagStrs) {
            if (tagName == null || "".equals(tagName.trim())) continue;

            tag = analyzer.getTag(tagName.trim());
            if (tag != null) {
                ref = cctDAO.getTagReferenceByTagId(cct.getId(), tag.getId());
                if (ref == null) {
                    ref = new TagReference();
                    ref.setCctId(cct.getId());
                    ref.setTag(tag);
                    ref.setTimes(1);
                } else {
                    cctDAO.increaseRefTimes(ref);
                }
            } else {
                tag = new Tag();
                tag.setName(tagName);
                tag.setStatus(Tag.STATUS_CANDIDATE);
                tagDAO.save(tag);
                
                analyzer.addTag(tag);
                
                ref = new TagReference();
                ref.setTag(tag);
                ref.setTimes(1);
                ref.setCctId(cct.getId());
                cctDAO.save(ref);
            }
            
            c.getTags().add(ref);
        } //for

        cctDAO.save(c);

        /*
         * the author of the concern always agrees.
         */
        systemDAO.setVoting(YesNoVoting.TYPE_CONCERN, c.getId(), true);
        cctDAO.increaseVoting(c, true);
        
        return c;
    } //createConcern()


    public Collection getMyConcerns(CCT cct) throws Exception {
        return cctDAO.getMyConcerns(cct.getId(), WebUtils.currentUserId());
    } //getMyConcerns()


    public Collection getOthersConcerns(CCT cct, int count) throws Exception {
        return cctDAO.getOthersConcerns(cct.getId(), WebUtils.currentUserId(),
                                        count);
    } //getOthersConcerns()


    public Collection getRandomConcerns(CCT cct, PageSetting setting) throws Exception {
        return cctDAO.getRandomConcerns(cct.getId(), WebUtils.currentUserId(), setting);
    } //getRandomConcerns()


    public Collection getTagsByRank(CCT cct, int count) throws Exception {
        return cctDAO.getTagsByRank(cct, count);
    } //getTagsByRank()


    public Collection getTagsByThreshold(CCT cct, int threshold) throws Exception {
        return cctDAO.getTagsByThreshold(cct, threshold);
    } //getTagsByThreshold()


    public Collection getConcernsByTag(Long tagRefId, int count) throws Exception {
        TagReference tagRef = cctDAO.getTagReferenceById(tagRefId);
        if (tagRef == null)throw new Exception(
                "Requested TagReference doesn't exist.");
        return cctDAO.getConcernsByTag(tagRef, count);
    } //getConcernsByTag()
    
    
    public String[][] getSuggestedTags(String statement) throws Exception {
        return analyzer.suggest(statement);
    } //getSuggestedTags


    public Concern getConcernById(Long concernId) throws Exception {
        return cctDAO.getConcernById(concernId);
    } //getConcernById()


    public Comment getCommentById(Long commentId) throws Exception {
        return cctDAO.getCommentById(commentId);
    }//getCommentById()


    public void deleteConcern(Long concernId) throws Exception {
        Concern concern = cctDAO.getConcernById(concernId);
        
        if (concern==null) {
            throw new Exception("can't find the specified concern");
        }
        
        if (concern.isDeleted()) {
            throw new Exception("This concern is already deleted.");
        }
        
        if (!WebUtils.checkUser(concern.getAuthor().getId())) {
            throw new Exception("You have no right to edit this concern.");
        }
        
        CCT cct = concern.getCct();
        
        Set oldTags = new HashSet(concern.getTags());
        concern.getTags().clear();
        
        for (Object object : oldTags) {
            TagReference ref = (TagReference) object;
            if (ref.getTimes() > 0) {
                cctDAO.decreaseRefTimes(ref);
                cctDAO.save(ref);
            }
        } //for
        
        concern.setDeleted(true);
        concern.setCreateTime(new Date());
        
        cctDAO.deleteComments(concern);
        cct.getConcerns().remove(concern);
        
        cctDAO.save(concern);
        
        cctDAO.save(cct);
    } //deleteConcern()


    public void editConcernTags(Concern concern, String[] tagStrs) throws Exception {
        CCT cct = concern.getCct();
        
        Set tags = new HashSet();
        for (String one : tagStrs) {
            tags.add(one);
        }//for
        
        Set set = new HashSet();
        
        for (TagReference one : (Set<TagReference>) concern.getTags()) {
            if (!tags.contains(one.getTag().getName())) {
                set.add(one);
                cctDAO.decreaseRefTimes(one);
            }
        }//for
        
        concern.getTags().removeAll(set);
        
        tags.clear();
        
        for (TagReference one : (Set<TagReference>) concern.getTags()) {
            tags.add(one.getTag().getName());
        }//for
        
        Tag tag;
        TagReference ref;
        
        for (String one : tagStrs) {
            if (!tags.contains(one)) {
                if (one == null || "".equals(one.trim()))continue;
                
                tag = analyzer.getTag(one);
                if (tag != null) {
                    tag = tagDAO.getTagById(tag.getId());
                    ref = cctDAO.getTagReferenceByTagId(cct.getId(), tag.getId());
                    if (ref == null) {
                        ref = new TagReference();
                        ref.setCctId(cct.getId());
                        ref.setTag(tag);
                        ref.setTimes(1);
                    } else {
                        cctDAO.increaseRefTimes(ref);
                    }
                } else {
                    tag = tagDAO.addTag(one, Tag.STATUS_CANDIDATE, true);
                    analyzer.addTag(tag);
                    ref = new TagReference();
                    ref.setTag(tag);
                    ref.setTimes(1);
                    ref.setCctId(cct.getId());
                }
                cctDAO.save(ref);
                concern.getTags().add(ref);
            }
        }//for
        
        concern.setCreateTime(new Date());
        cctDAO.save(concern);
    } //editConcernTags()


    public int getConcernsTotal(CCT cct, int whose) throws Exception {
        return cctDAO.getConcernsTotal(cct, whose, WebUtils.currentUserId());
    } //getConcernsTotal()


    public TagReference getTagReferenceById(Long tagRefId) throws Exception {
        return cctDAO.getTagReferenceById(tagRefId);
    } //getTagReferenceById()


    public Collection searchTags(CCT cct, String tag) throws Exception {
        return cctDAO.searchTags(cct.getId(), tag);
    } //searchTags()


    public Collection getTagCloud(CCT cct, PageSetting setting) throws Exception {
        return cctDAO.getTagCloud(cct, setting);
    }//getTagCloud()


    public Collection getContextConcerns(CCT cct, PageSetting setting, String filter, String type, int sorting) throws Exception {
        Collection concerns = null;
        
        if (filter==null || "".equals(filter.trim())) {
            concerns = cctDAO.getContextConcerns(cct, setting, type, sorting);
        } else {
            concerns = cctDAO.getContextConcerns(cct, setting, filter, type, sorting);
        }
        
        /**
         * put the voting object for current user to concern
         */
        for (Concern one : (Collection<Concern>) concerns) {
            YesNoVoting voting = systemDAO.getVoting(YesNoVoting.TYPE_CONCERN, one.getId());
            one.setObject(voting);
        }
        
        return concerns;
    }//getContextConcerns()


    public boolean setVotingOnConcern(Long id, boolean agree) throws Exception {
        if (!systemDAO.setVoting(YesNoVoting.TYPE_CONCERN, id, agree)) return false;
        
        Concern concern = cctDAO.getConcernById(id);
        
        cctDAO.increaseVoting(concern, agree);
        
        return true;
    }//setVotingOnConcern()


    public Comment createComment(Long concernId, String title, String content, String[] tags) throws Exception {
        Concern concern = cctDAO.getConcernById(concernId);
        
        if (concern==null) throw new Exception("can't find the specified concern");
            
        Comment comment = new Comment();
        comment.setConcern(concern);
        comment.setTitle(title);
        comment.setContent(content);
        comment.setDeleted(false);
        comment.setCreateTime(WebUtils.getDate());
        
        User owner = userDAO.getUserById(WebUtils.currentUserId(), true, false);
        comment.setOwner(owner);
        
        for (String tagStr : tags) {
            Tag tag = analyzer.getTag(tagStr.trim());
            
            if (tag==null) {
                tag = tagDAO.addTag(tagStr.trim(), Tag.STATUS_CANDIDATE, true);
            } else {
                tag = tagDAO.getTagByName(tag.getName());
            }
            
            comment.getTags().add(tag);
        }
        
        cctDAO.save(comment);
        
        cctDAO.increaseReplies(concern);
        
        /*
         * the author of the comment always agrees.
         */
        systemDAO.setVoting(YesNoVoting.TYPE_COMMENT, comment.getId(), true);
        cctDAO.increaseVoting(comment, true);
        
        return comment;
    }//createComment()


    public Comment editComment(Long commentId, String title, String content, String[] tags) throws Exception {
        Comment comment = cctDAO.getCommentById(commentId);
        
        if (comment==null) throw new Exception("can't find the specified comment");
            
        User owner = userDAO.getUserById(WebUtils.currentUserId(), true, false);
        
        if (owner.getId().equals(comment.getOwner().getId())) {
            throw new Exception("You are not the owner of this comment");
        }
        
        comment.setTitle(title);
        comment.getTags().clear();
        
        for (String tagStr : tags) {
            Tag tag = analyzer.getTag(tagStr.trim());
            
            if (tag==null) {
                tag = tagDAO.addTag(tagStr.trim(), Tag.STATUS_CANDIDATE, true);
            } else {
                tag = tagDAO.getTagByName(tag.getName());
            }
            
            comment.getTags().add(tag);
        }
        
        cctDAO.save(comment);
        
        return comment;
    }//editComment()


    public void deleteComment(Long commentId) throws Exception {
        Comment comment = cctDAO.getCommentById(commentId);
        
        if (comment==null) throw new Exception("can't find the specified comment");
        
        User owner = userDAO.getUserById(WebUtils.currentUserId(), true, false);
        
        if (!owner.getId().equals(comment.getOwner().getId())) {
            throw new Exception("You are not the owner of this comment");
        }
        
        comment.setDeleted(true);
        
        cctDAO.decreaseReplies(comment.getConcern());
        
        cctDAO.save(comment);
    }//deleteComment()


    public Collection getComments(Long concernId, PageSetting setting) throws Exception {
        return cctDAO.getComments(concernId, setting);
    }//getComments()


    public boolean setVotingOnComment(Long id, boolean agree) throws Exception {
        if (!systemDAO.setVoting(YesNoVoting.TYPE_COMMENT, id, agree)) return false;
        
        Comment comment = cctDAO.getCommentById(id);
        
        cctDAO.increaseVoting(comment, agree);
        
        return true;
    }//setVotingOnComment()


    public void increaseViews(Long concernId) throws Exception {
        cctDAO.increaseViews(concernId);
    }//increaseViews()


}//class CCTServiceImpl
