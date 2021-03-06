package org.pgist.discussion;

import java.util.Collection;
import java.util.Set;

import org.pgist.cvo.Concern;
import org.pgist.tagging.Tag;
import org.pgist.util.PageSetting;


/**
 * 
 * @author kenny
 *
 */
public interface SDService {
    
    
    InfoStructure getInfoStructureById(Long isid) throws Exception;
    
    
    InfoObject getInfoObjectById(Long ioid) throws Exception;


    Discussion getDiscussionById(Long did) throws Exception;


    DiscussionPost getPostById(Long postid) throws Exception;


    DiscussionReply getReplyById(Long rid) throws Exception;


    Collection getPosts(InfoStructure structure, InfoObject infoObj, PageSetting setting, int sorting) throws Exception;
    
    
    Collection getPosts(InfoStructure structure, InfoObject infoObj, PageSetting setting, String filter, int sorting) throws Exception;
    
    
    Collection getReplies(DiscussionPost post, PageSetting setting) throws Exception;


    Collection getReplies(DiscussionPost post, PageSetting setting, String filter) throws Exception;


    DiscussionPost createPost(InfoStructure structure, String title, String content, String[] tags, boolean emailNotify) throws Exception;
    
    
    DiscussionPost createPost(InfoObject object, String title, String content, String[] tags, boolean emailNotify) throws Exception;
    
    
    DiscussionReply createReply(Long parentId, Long parentReplyId, String title, String content, String[] tags, boolean emailNotify) throws Exception;


    void deletePost(DiscussionPost post) throws Exception;


    void deleteReply(DiscussionReply reply) throws Exception;


    void editPost(DiscussionPost post, String title, String content, String[] tags) throws Exception;


    void increaseViews(DiscussionPost post) throws Exception;


    Concern getConcernById(Long Id) throws Exception;
    
    
    Collection getConcerns(InfoStructure structure, String ids, PageSetting setting, boolean tagId) throws Exception;


    Collection getConcerns(InfoObject object, String ids, PageSetting setting, boolean tagId) throws Exception;


    int getConcernTagCount(InfoStructure structure) throws Exception;


    int getConcernTagCount(InfoObject object) throws Exception;


    Collection getContextPosts(Long isid, Long pid, String ids, PageSetting setting, boolean tagId, int sorting) throws Exception;


    int getPostTagCount(Long isid, Long postId) throws Exception;


    Collection searchTags(InfoStructure structure, String tag, PageSetting setting) throws Exception;


    Collection searchTags(InfoStructure structure, InfoObject infoObject, String tag, PageSetting setting) throws Exception;


    Collection getTagCloud(InfoStructure structure, PageSetting setting) throws Exception;


    Tag findTagById(Long tagId) throws Exception;
    
    
    DiscussionPost getDiscussionPostById(Long id) throws Exception;


    DiscussionReply getDiscussionReplyById(Long id) throws Exception;


    boolean setVoting(int targetType, Long targetId, boolean agree) throws Exception;
    
    
    Set getEmailUsers(DiscussionReply reply) throws Exception;


    InfoObject getInfoObjectByDiscussionId(Long did) throws Exception;


    void setupEmailNotify(Long id, String type, boolean turnon) throws Exception;


    //temp
    Collection getInfoStructures() throws Exception;


}//interface SDService
