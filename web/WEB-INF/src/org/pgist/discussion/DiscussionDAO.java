package org.pgist.discussion;

import java.util.Collection;

import org.pgist.system.BaseDAO;
import org.pgist.users.User;
import org.pgist.util.PageSetting;



/**
 * 
 * @author kenny
 *
 */
public interface DiscussionDAO extends BaseDAO {
    
    
    Discussion getDiscussion(Class klass, Long targetId) throws Exception;
    
    
    Discussion getDiscussion(String targetType, Long targetId) throws Exception;
    
    
    DiscussionPost getPostById(Long id) throws Exception;
    
    
    Collection getPosts(Discussion discussion, boolean order) throws Exception;
    
    
    Collection getPosts(Discussion discussion, PageSetting setting, boolean order) throws Exception;
    
    
    Collection getReplies(DiscussionPost post) throws Exception;
    
    
    Collection getReplies(DiscussionPost post, PageSetting setting) throws Exception;
    
    
    Discussion createDiscussion(String targetType, Long targetId) throws Exception;
    
    
    DiscussionPost createPost(Discussion discussion, String title, String content, String[] tags) throws Exception;
    
    
    DiscussionReply createReply(DiscussionPost post, String title, String content, String[] tags) throws Exception;
    
    
    void editPost(DiscussionPost post, String title, String content, String[] tags) throws Exception;


    void deleteDiscussion(Discussion discussion) throws Exception;
    
    
    void deletePost(DiscussionPost post) throws Exception;
    
    
    void increaseDiscussions(InfoStructure structure) throws Exception;


    void increaseDiscussions(InfoObject object) throws Exception;


    void increaseViews(DiscussionPost post) throws Exception;


    InfoVoting getVoting(InfoStructure structure, User user) throws Exception;


    InfoVoting getVoting(InfoObject infoObject, User user) throws Exception;


    void increaseVoting(InfoStructure structure, boolean agree) throws Exception;


    void increaseVoting(InfoObject object, boolean agree) throws Exception;


    Collection getConcerns(InfoStructure structure, PageSetting setting) throws Exception;


    Collection getConcerns(InfoStructure structure, String ids, PageSetting setting) throws Exception;
    

    Collection getConcerns(InfoObject object, PageSetting setting) throws Exception;


    Collection getConcerns(InfoObject object, String ids, PageSetting setting) throws Exception;


    int getConcernTagCount(InfoStructure structure) throws Exception;


    int getConcernTagCount(InfoObject object) throws Exception;


    Collection getContextPosts(Long isid, Long pid, PageSetting setting) throws Exception;


    Collection getContextPosts(Long isid, Long pid, String ids, PageSetting setting) throws Exception;


    int getPostTagCount(Long isid, Long postId) throws Exception;


    //temp
    
    Collection getInfoStructures() throws Exception;


}//interface DiscussionDAO
