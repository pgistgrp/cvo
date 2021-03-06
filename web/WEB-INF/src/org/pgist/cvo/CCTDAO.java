package org.pgist.cvo;

import java.util.Collection;

import org.pgist.system.BaseDAO;
import org.pgist.util.PageSetting;


/**
 * Data Access Object for CCT.
 * 
 * @author kenny
 *
 */
public interface CCTDAO extends BaseDAO {
    
    
    CCT getCCTById(Long cctId) throws Exception;
    
    
    Concern getConcernById(Long concernId) throws Exception;
    
    
    TagReference getTagReferenceById(Long tagRefId) throws Exception;


    Comment getCommentById(Long commentId) throws Exception;


    /**
     * Get a collection of all the CCT objects.
     * 
     * @return A collection of CCT objects.
     * @throws Exception
     */
    Collection getCCTs() throws Exception;

    /**
     * Get all concerns belong to the given user.
     * 
     * @param cctId The id of the CCT object.
     * @param userId The id of the given user.
     * @return A collection of Concern objects.
     * @throws Exception
     */
    Collection getMyConcerns(Long cctId, Long userId) throws Exception;

    /**
     * Get all concerns nbelong to the given user.
     * 
     * @param cctId The id of the CCT object.
     * @param userId The id of the given user.
     * @param count The max number of concerns to retrieve.
     * @return A collection of Concern objects.
     * @throws Exception
     */
    Collection getOthersConcerns(Long cctId, Long userId, int count) throws Exception;

    /**
     * Randomly get other people's concerns.
     * 
     * @param cctId The id of the CCT object.
     * @param userId The id of the given user.
     * @param setting The page setting.
     * @return A collection of Concern objects.
     * @throws Exception
     */
    Collection getRandomConcerns(Long cctId, Long userId, PageSetting setting) throws Exception;

    /**
     * Get concerns with the given tagRefId.
     * 
     * @param tagRef the TagReference object.
     * @param count the max amount of concerns to get.
     * @return A collection of Concern objects.
     * @throws Exception
     */
    Collection getConcernsByTag(TagReference tagRef, int count) throws Exception;

    /**
     * Get the total number of concerns in a CCT object.
     * 
     * @param cctId A CCT object which the current user is working on.
     * @param whose The mode to count the total number of concerns.<br>
     *        <ul>
     *          <li>whose==0: all concerns</li>
     *          <li>whose==1: my concerns</li>
     *          <li>whose==2: other's concerns</li>
     *        </ul>
     * @param user
     * @return
     * @throws Exception
     */
    int getConcernsTotal(CCT cct, int whose, Long userId) throws Exception;

    void delete(TagReference ref) throws Exception;

    Collection searchTags(Long id, String tag) throws Exception;
    
    
    TagReference getTagReferenceByTagId(Long cctId, Long tagId) throws Exception;


    /**
     * Search in the given CCT, and find those tags appeared in this CCT and which are the top count
     * being referenced.
     *
     * @param cctId
     * @param count
     * @return
     * @throws Exception
     */
    Collection getTagsByRank(CCT cct, int count) throws Exception;

    /**
     * Get the top N tags in the given cctId according to the frequency of reference.
     *
     * @param cctId A CCT object which the current user is working on.
     * @param setting The page setting.
     * @return A collection of Tag objects.
     * @throws Exception
     */
    Collection getTagCloud(CCT cct, PageSetting setting) throws Exception;
    
    /**
     * Search in the given CCT, and find those tags appeared in this CCT and which are referenced at least
     * threshold times.
     *
     * @param cctId
     * @param threshold
     * @return
     * @throws Exception
     */
    Collection getTagsByThreshold(CCT cct, int threshold) throws Exception;
    
    
    /**
     * Increase the reference times of the given TagReference object.
     * 
     * @param ref
     * @throws Exception
     */
    void increaseRefTimes(TagReference ref) throws Exception;
    

    /**
     * Decrease the reference times of the given TagReference object.
     * 
     * @param ref
     * @throws Exception
     */
    void decreaseRefTimes(TagReference ref) throws Exception;
    
    
    Collection getContextConcerns(CCT cct, PageSetting setting, String type, int sorting) throws Exception;
    
    
    Collection getContextConcerns(CCT cct, PageSetting setting, String filter, String type, int sorting) throws Exception;

    
    void increaseVoting(Concern concern, boolean agree) throws Exception;


    void increaseReplies(Concern concern) throws Exception;
    
    
    void decreaseReplies(Concern concern) throws Exception;


    void deleteComments(Concern concern) throws Exception;


    Collection getComments(Long concernId, PageSetting setting) throws Exception;


    void increaseVoting(Comment comment, boolean agree) throws Exception;


    void increaseViews(Long concernId) throws Exception;


}//interface CCTDAO
