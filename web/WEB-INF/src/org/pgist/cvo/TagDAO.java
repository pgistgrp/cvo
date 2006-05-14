package org.pgist.cvo;

import java.util.*;
import org.pgist.util.PageSetting;


/**
 * Data Access Object for Tag.
 *
 * @author kenny
 *
 */
public interface TagDAO extends CVODAO {


    /**
     * Add the given tags to the database, return a list of corresponding Tag objects.<br>
     * Each tag string will be check if it's already in the tag library. If it's already in the
     * library, get the Tag object from database; if not, create a new Tag object and save it to
     * the database.
     *
     * @param tags A list of string, each is a tag.
     * @return A list of Tag object
     * @throws Exception
     */
    List addTags(String[] tags) throws Exception;


    /**
     * Get all valid tags in the system.
     *
     * @return A collection of Tag objects.
     * @throws Exception
     */
    Collection getAllTags() throws Exception;


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
     * Add the given string into the database, return a StopWord insance.
     * @param s String
     * @return StopWord
     */
    StopWord createStopWord(String s);

    /**
     * Delete the stopWord whose id is the parameter id
     * if id is out of the boundary, return false; otherwise, delete the
     * stopword and return true;
     * @param id Long
     */
    boolean deleteStopWord(Long id);

    /**
     * Get the result on the setting page and return the result.
     *
     * @param setting PageSetting
     * @return List
     */
    List getStopWords(PageSetting setting);

    Collection searchStopWord(String stopWord) throws Exception;
    List getAllStopWords();

} //interface TagDAO
