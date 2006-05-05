package org.pgist.cvo;

import java.util.Collection;

import org.pgist.util.PageSetting;


/**
 * 
 * @author kenny
 *
 */
public interface CSTDAO extends CVODAO {
    
    
    Category getCategoryByName(String name) throws Exception;
    
    CategoryReference getCategoryReferenceByName(Long cctId, String name) throws Exception;

    Collection getConcernsByTag(Long cctId, Long tagRefId, PageSetting setting) throws Exception;
    
    
}//interface CSTDAO
