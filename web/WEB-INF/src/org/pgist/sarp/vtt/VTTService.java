package org.pgist.sarp.vtt;

import java.util.Collection;
import java.util.Set;

import org.pgist.sarp.cht.CategoryPath;
import org.pgist.sarp.cst.CategoryReference;
import org.pgist.sarp.drt.InfoObject;
import org.pgist.users.User;
import org.pgist.util.PageSetting;


/**
 * 
 * @author kenny
 *
 */
public interface VTTService {
    
    
    void toggleVTT(Long vttId, boolean closed) throws Exception;

    InfoObject publish(Long vttId, String title) throws Exception;

    VTT getVTTById(Long vttId) throws Exception;

    VTT createVTT(Long id, Long chtId, String name, String purpose, String instruction) throws Exception;

    Collection<VTTComment> getComments(Long userId, Long vttId, PageSetting setting) throws Exception;

    VTTComment createComment(Long workflowId, Long userId, Long vttId, String title, String content, boolean emailNotify) throws Exception;

    void deleteComment(VTTComment comment) throws Exception;

    VTTComment getCommentById(Long cid) throws Exception;

    VTTComment setVotingOnComment(Long cid, boolean agree) throws Exception;

    CategoryReference getCategoryReferenceById(Long id) throws Exception;
    
    CategoryPathValue getCategoryPathValueByPathId(Long userId, Long pathId) throws Exception;
    
    void saveCategoryPathValue(Long userId, Long pathId, String name, String unit, boolean isTag) throws Exception;
    
    void publish(Long vttId, Long userId) throws Exception;

    VTTSpecialistComment createSpecialistComment(Long workflowId, Long vttId, Long targetUserId, String title, String content, boolean emailNotify) throws Exception;

    void setClusteredPaths(Long vttId) throws Exception;

    CategoryPath getCategoryPathById(Long pathId) throws Exception;

    MUnitSet getMUnitSetByPathId(Long pathId) throws Exception;

    Collection<VTTSpecialistComment> getSpecialistComments(Long targetUserId, Long vttId, PageSetting setting) throws Exception;

    VTTSpecialistComment getSpecialistCommentById(Long cid) throws Exception;

    void deleteSpecialistComment(VTTSpecialistComment comment) throws Exception;

    VTTSpecialistComment setVotingOnSpecialistComment(Long cid, boolean agree) throws Exception;

    MUnitSet getMUnitSetById(Long id) throws Exception;

    void setToggleSelection(Long musetId, String type, String criterion, boolean checked) throws Exception;

    void publishExpertUnits(Long vttId) throws Exception;

    void setUnitComment(Long musetId, String content) throws Exception;

    void setClusteredExpertsSelections(Long vttId) throws Exception;

    void saveSelection(Long pathId, Long userId, String unit) throws Exception;

    CategoryPath createPath(Long vttId, String pathIds) throws Exception;

    void deletePathById(Long vttId, Long pathId) throws Exception;

    void saveUnit(Long pathId, String indicator, String measurement,
            boolean appr, boolean avail, boolean dup, boolean reco) throws Exception;

    Set<User> getThreadUsers(Long ownerId, Long vttId) throws Exception;

    
}//interface VTTService
