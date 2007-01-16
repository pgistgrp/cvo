package org.pgist.funding;

import java.util.Collection;


/**
 * 
 * @author kenny
 *
 */
public interface FundingService {
    
    
    FundingSource getFundingSourceById(Long id) throws Exception;
    
    
    FundingSourceAlternative getFundingSourceAltById(Long id) throws Exception;
    
    
    Collection getFundingSources() throws Exception;


    FundingSource createFundingSource(String name) throws Exception;


    void editFundingSource(Long id, String name) throws Exception;


    FundingSourceAlternative createFundingSourceAlt(String name, float revenue, float taxRate) throws Exception;


    void editFundingSourceAlt(Long id, String name, float revenue, float taxRate) throws Exception;


    void deleteFundingSource(Long id) throws Exception;
    
    
    void deleteFundingSourceAlt(Long id) throws Exception;
    
    
    void setupFundingSourcesForCCT(Long cctId, String[] ids) throws Exception;


}//interface FundingService
