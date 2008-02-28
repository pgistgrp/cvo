package org.pgist.sarp.drt;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.lucene.index.IndexReader;
import org.apache.lucene.search.Hits;
import org.apache.lucene.search.IndexSearcher;
import org.directwebremoting.WebContextFactory;
import org.pgist.search.SearchHelper;
import org.pgist.system.EmailSender;
import org.pgist.system.SystemService;
import org.pgist.system.YesNoVoting;
import org.pgist.util.PageSetting;
import org.pgist.util.WebUtils;
import org.pgist.wfengine.EnvironmentHandler;
import org.pgist.wfengine.EnvironmentInOuts;
import org.pgist.wfengine.WorkflowEngine;
import org.pgist.wfengine.web.WorkflowUtils;


/**
 * 
 * @author kenny
 *
 */
public class DRTAgent {
    
    
    /**
     * Spring Injected
     */
    private DRTService drtService;
    
    private SystemService systemService;
    
    private EmailSender emailSender;
    
    private SearchHelper searchHelper;
    
    private WorkflowUtils workflowUtils;
    
    private WorkflowEngine engine;
    
    
    public void setDrtService(DRTService drtService) {
        this.drtService = drtService;
    }
    
    
    public void setSystemService(SystemService systemService) {
        this.systemService = systemService;
    }


    public void setEmailSender(EmailSender emailSender) {
        this.emailSender = emailSender;
    }


    public void setSearchHelper(SearchHelper searchHelper) {
        this.searchHelper = searchHelper;
    }


    public void setWorkflowUtils(WorkflowUtils workflowUtils) {
        this.workflowUtils = workflowUtils;
    }


    public void setEngine(WorkflowEngine engine) {
        this.engine = engine;
    }
    
    
    /*
     * ------------------------------------------------------------------------
     */
    
    
    /**
     * Get a DRT Comment object by the given id.
     * 
     * @param params A map contains:
     *   <ul>
     *     <li>id - int, id of a DiscussionObject object</li>
     *   </ul>
     * 
     * @return A map contains:<br>
     *   <ul>
     *     <li>successful - a boolean value denoting if the operation succeeds</li>
     *     <li>reason - reason why operation failed (valid when successful==false)</li>
     *     <li>comment - a Comment object (valid when successful==true)</li>
     *     <li>voting - a YesNoVoting object (may be null if the current user hasn't voted yet.)</li>
     *   </ul>
     */
    public Map getCommentById(Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        Long id = null;
        try {
            id = new Long((String) params.get("id"));
            if (id==null) {
                map.put("reason", "can't find this Comment");
                return map;
            }
        } catch (Exception e) {
            map.put("reason", "can't find this Comment");
            return map;
        }
        
        try {
            Comment comment = drtService.getCommentById(id);
            
            if (comment==null) {
                map.put("reason", "can't find this comment");
                return map;
            }
            
            map.put("comment", comment);
            
            YesNoVoting voting = systemService.getVoting(YesNoVoting.TYPE_SARP_DRT_COMMENT, id);
            if (voting!=null) {
                map.put("voting", voting);
            }
            
            map.put("successful", true);
        } catch (Exception e) {
            map.put("reason", e.getMessage());
            return map;
        }
        
        return map;
    }//getCommentById()
    
    
    /**
     * Get DRT comments for the given drt id.
     * 
     * @param params A map contains:
     *   <ul>
     *     <li>oid - int, id of a InfoObject object</li>
     *     <li>page - int, page number of the requestd page of comments</li>
     *   </ul>
     * 
     * @param wfinfo A map contains:
     *   <ul>
     *   <li>workflowId - long</li>
     *   <li>contextId - long</li>
     *   <li>activityId - long</li>
     * </ul>
     * 
     * @return A map contains:<br>
     *   <ul>
     *     <li>successful - a boolean value denoting if the operation succeeds</li>
     *     <li>reason - reason why operation failed (valid when successful==false)</li>
     *     <li>html - a HTML source segment. (Generated by /WEB-INF/jsp/cvo/concerns.jsp)<br>
     *           The following variables are available for use in the jsp:
     *           <ul>
     *             <li>comments - A list of Comment objects</li>
     *             <li>setting - A PageSetting objects</li>
     *           </ul>
     *     </li>
     *     <li>page - page number of the returned page</li>
     *   </ul>
     */
    public Map getComments(HttpServletRequest request, Map params, Map wfinfo) {
        Map map = new HashMap();
        map.put("successful", false);
        
        Long oid = null;
        try {
            request.setAttribute("wfinfo", wfinfo);
            
            oid = new Long((String) params.get("oid"));
            if (oid==null) {
                map.put("reason", "can't find this InfoObject");
                return map;
            }
        } catch (Exception e) {
            map.put("reason", "can't find this InfoObject");
            return map;
        }
        
        try {
        	PageSetting setting = new PageSetting(10);
        	setting.setPage((String) params.get("page"));
        	
            Collection<Comment> comments = drtService.getComments(oid, setting);
            
            request.setAttribute("comments", comments);
            request.setAttribute("setting", setting);
            
            map.put("html", WebContextFactory.get().forwardToString("/WEB-INF/jsp/sarp/drt/drtComments.jsp"));
            map.put("page", setting.getPage());
            map.put("successful", true);
            
        } catch (Exception e) {
            map.put("reason", e.getMessage());
            return map;
        }
        
        return map;
    }//getComments()
    
    
    /**
     * Create a DRT comment for the given drt id.
     * 
     * @param params A map contains:
     *   <ul>
     *     <li>oid - int, id of a InfoObject object</li>
     *     <li>title - string, comment title</li>
     *     <li>content - string, comment content</li>
     *   </ul>
     * 
     * @param wfinfo A map contains:
     *   <ul>
     *   <li>workflowId - long</li>
     *   <li>contextId - long</li>
     *   <li>activityId - long</li>
     * </ul>
     * 
     * @return A map contains:<br>
     *   <ul>
     *     <li>successful - a boolean value denoting if the operation succeeds</li>
     *     <li>reason - reason why operation failed (valid when successful==false)</li>
     *   </ul>
     */
    public Map createComment(HttpServletRequest request, Map params, Map wfinfo) {
        Map map = new HashMap();
        map.put("successful", false);
        
        Long oid = null;
        try {
            request.setAttribute("wfinfo", wfinfo);
            
            oid = new Long((String) params.get("oid"));
            if (oid==null) {
                map.put("reason", "can't find this InfoObject");
                return map;
            }
        } catch (Exception e) {
            map.put("reason", "can't find this InfoObject");
            return map;
        }
        
        try {
        	String title = (String) params.get("title");
        	String content = (String) params.get("content");
        	
        	if (title.length()>100) throw new Exception("title can't exceeds 100 chars");
        	if (content.length()>8192) throw new Exception("content can't exceeds 8192 chars");
        	
            Comment comment = drtService.createComment(oid, title, content, false);
            
            map.put("successful", true);
            
        } catch (Exception e) {
            map.put("reason", e.getMessage());
            return map;
        }
        
        return map;
    }//createComment()
    
    
    /**
     * Delete the given Comment object. Only used by moderator.
     * 
     * @param params A map contains:
     *   <ul>
     *     <li>cid - int, id of the Comment object</li>
     *   </ul>
     *   
     * @param wfinfo A map contains:
     *   <ul>
     *   <li>workflowId - long</li>
     *   <li>contextId - long</li>
     *   <li>activityId - long</li>
     * </ul>
     * 
     * @return A map contains:<br>
     *   <ul>
     *     <li>successful - a boolean value denoting if the operation succeeds</li>
     *     <li>reason - reason why operation failed (valid when successful==false)</li>
     *   </ul>
     */
    public Map deleteComment(Map params, Map wfinfo) {
        Map map = new HashMap();
        map.put("successful", false);
        
        Long cid = null;
        Comment comment = null;
        
        try {
        	cid = new Long((String) params.get("cid"));
            if (cid==null) {
                map.put("reason", "no such Comment object");
                return map;
            }
            
            comment = drtService.getCommentById(cid);
            if (comment==null) {
                map.put("reason", "no such Comment object");
                return map;
            }
            
            //check if it's moderator, TODO
            if (comment.getAuthor().getId().equals(WebUtils.currentUserId())) {
                drtService.deleteComment(comment);
                
                /*
                 * delete from lucene
                 */
                IndexSearcher searcher = null;
                IndexReader reader = null;
                try {
                    searcher = searchHelper.getIndexSearcher();
                    
                    Hits hits = searcher.search(searchHelper.getParser().parse(
                        "workflowid:"+wfinfo.get("workflowId")
                       +" AND type:infoobjcomment AND commentid:"+cid
                    ));
                    
                    if (hits.length()>0) {
                        reader = searchHelper.getIndexReader();
                        reader.deleteDocument(hits.id(0));
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (searcher!=null) searcher.close();
                    if (reader!=null) reader.close();
                }
            } else {
                map.put("reason", "You are not the owner of this comment");
                return map;
            }
            
            map.put("successful", true);
        } catch (Exception e) {
            map.put("reason", e.getMessage());
            return map;
        }
        
        return map;
    }//deleteComment()
    
    
    /**
     * Set the voting choice on the given InfoObject object.
     * 
     * @param params A map contains:
     *   <ul>
     *     <li>oid - int, id of the InfoObject object. Required.</li>
     *     <li>agree - string, "true" or "false". Whether or not the current user agree with the current object.</li>
     *   </ul>
     *   
     * @return A map contains:<br>
     *   <ul>
     *     <li>successful - a boolean value denoting if the operation succeeds</li>
     *     <li>reason - reason why operation failed (valid when successful==false)</li>
     *     <li>numAgree - int</li>
     *     <li>numVote - int</li>
     *   </ul>
     */
    public Map setVotingOnInfoObject(Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        Long oid = null;
        try {
            oid = new Long((String) params.get("oid"));
        } catch (Exception e) {
            map.put("reason", "oid is required.");
            return map;
        }
        
        boolean agree = "true".equalsIgnoreCase((String) params.get("agree"));
        
        try {
        	InfoObject infoObject = null;
        	
            YesNoVoting voting = systemService.getVoting(YesNoVoting.TYPE_SARP_DRT_INFOOBJ, oid);
            if (voting!=null) {
            	infoObject = drtService.getInfoObjectById(oid);
            } else {
            	infoObject = drtService.setVotingOnInfoObject(oid, agree);
            }
            
            map.put("numAgree", infoObject.getNumAgree());
            map.put("numVote", infoObject.getNumVote());
            map.put("voted", true);
            
            map.put("successful", true);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
            return map;
        }
        
        return map;
    }//setVotingOnInfoObject()
    
    
    /**
     * Set the voting choice on the given Comment object.
     * 
     * @param params A map contains:
     *   <ul>
     *     <li>cid - int, id of the Comment object. Required.</li>
     *     <li>agree - string, "true" or "false". Whether or not the current user agree with the current object.</li>
     *   </ul>
     *   
     * @return A map contains:<br>
     *   <ul>
     *     <li>successful - a boolean value denoting if the operation succeeds</li>
     *     <li>reason - reason why operation failed (valid when successful==false)</li>
     *     <li>numAgree - int</li>
     *     <li>numVote - int</li>
     *   </ul>
     */
    public Map setVotingOnComment(Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        Long cid = null;
        try {
            cid = new Long((String) params.get("cid"));
        } catch (Exception e) {
            map.put("reason", "cid is required.");
            return map;
        }
        
        boolean agree = "true".equalsIgnoreCase((String) params.get("agree"));
        
        try {
        	Comment comment = null;
        	
            YesNoVoting voting = systemService.getVoting(YesNoVoting.TYPE_SARP_DRT_COMMENT, cid);
            if (voting!=null) {
            	comment = drtService.getCommentById(cid);
            } else {
            	comment = drtService.setVotingOnComment(cid, agree);
            }
            
            map.put("numAgree", comment.getNumAgree());
            map.put("numVote", comment.getNumVote());
            map.put("voted", true);
            
            map.put("successful", true);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
            return map;
        }
        
        return map;
    }//setVotingOnComment()
    
    
    /**
     * Set the exit condition for repeat/until loop.
     * 
     * @param params a Map contains:
     *   <ul>
     *     <li>workflowId - int, id of the Workflow object</li>
     *     <li>contextId - int, id of the WorkflowContext object</li>
     *     <li>activityId - int, id of the Activity object</li>
     *     <li>exitCondition - string, "true" | "false" | ""</li>
     *   </ul>
     *   
     * @param wfinfo A map contains:
     *   <ul>
     *   <li>workflowId - long</li>
     *   <li>contextId - long</li>
     *   <li>activityId - long</li>
     * </ul>
     * 
     * @return a Map contains:
     *   <ul>
     *     <li>successful - a boolean value denoting if the operation succeeds</li>
     *     <li>reason - reason why operation failed (valid when successful==false)</li>
     *   </ul>
     */
    public Map setExitCondition(final Map params, final Map wfinfo) {
        Map results = new HashMap();
        results.put("successful", false);
        
        try {
            Long workflowId = new Long((String) wfinfo.get("workflowId"));
            Long contextId = new Long((String) wfinfo.get("contextId"));
            Long activityId = new Long((String) wfinfo.get("activityId"));
            
            engine.setEnvVars(
                workflowId, contextId, activityId,
                new EnvironmentHandler() {
                    public void handleEnvVars(EnvironmentInOuts inouts) throws Exception {
                        String exitCondition = (String) params.get("exitCondition");
                        if ("true".equalsIgnoreCase(exitCondition)) {
                            exitCondition = "true";
                        } else if ("false".equalsIgnoreCase(exitCondition)) {
                            exitCondition = "false";
                        } else {
                            //clear
                            exitCondition = null;
                        }
                        inouts.setStrValue("exitCondition", exitCondition);
                    }//handleEnvVars()
                }
            );
            
            results.put("successful", true);
        } catch (Exception e) {
            e.printStackTrace();
            results.put("reason", e.getMessage());
        }
        
        return results;
    }//setExitCondition()
    
    
}//class DRTAgent