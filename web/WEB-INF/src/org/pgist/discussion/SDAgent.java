package org.pgist.discussion;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.directwebremoting.WebContextFactory;
import org.pgist.tags.FragmentTag;
import org.pgist.util.PageSetting;
import org.pgist.util.PageSource;
import org.pgist.util.WebUtils;


/**
 * 
 * @author kenny
 *
 */
public class SDAgent {
    
    
    /**
     * Spring Injected
     */
    private SDService sdService;
    
    
    public void setSdService(SDService sdService) {
        this.sdService = sdService;
    }
    
    
    /*
     * ------------------------------------------------------------------------
     */
    
    
    /**
     * Get a DiscussionPost object by the given id.
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
     *     <li>post - a DiscussionPost object (valid when successful==true)</li>
     *   </ul>
     */
    public Map getPostById(Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        Long id = null;
        try {
            id = new Long((String) params.get("id"));
            if (id==null) {
                map.put("reason", "can't find this DiscussionPost");
                return map;
            }
        } catch (Exception e) {
            map.put("reason", "can't find this DiscussionPost");
            return map;
        }
        
        
        try {
            DiscussionPost post = sdService.getPostById(id);
            
            if (post==null) {
                map.put("reason", "can't find this DiscussionPost");
                return map;
            }
            
            map.put("post", post);
            
            map.put("successful", true);
        } catch (Exception e) {
            map.put("reason", e.getMessage());
            return map;
        }
        
        return map;
    }//getPostById()
    
    
    /**
     * Get first level discussion (posts) with the given conditions.
     * 
     * @param params A map contains:
     *   <ul>
     *     <li>isid - int, id of a InfoStructure object</li>
     *     <li>ioid - int, id of a InfoObject object. Optional, default value is null, means the discussion is on InfoStructure object</li>
     *     <li>page - int, current page to get. Optional, default value is 1.</li>
     *     <li>count - int, number of posts to be displayed in a page. Optional, default value is -1, means to get all posts.</li>
     *   </ul>
     * 
     * @return A map contains:<br>
     *   <ul>
     *     <li>successful - a boolean value denoting if the operation succeeds</li>
     *     <li>reason - reason why operation failed (valid when successful==false)</li>
     *     <li>html - a HTML source segment. (valid when successful==true)<br>
     *         generated by /WEB-INF/jsp/discussion/sdPosts.jsp<br>
     *         the following variables are available for use in jsp page:
     *             <ul>
     *               <li>structure - An InfoStructure object</li>
     *               <li>object - An InfoObject object</li>
     *               <li>setting - A PageSetting object</li>
     *               <li>posts - A list of DiscussionPost objects</li>
     *             </ul>
     *     </li>
     *   </ul>
     */
    public Map getPosts(HttpServletRequest request, Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        Long isid = null;
        InfoStructure structure = null;
        Long ioid = null;
        InfoObject object = null;
        
        try {
            isid = new Long((String) params.get("isid"));
            if (isid==null) {
                map.put("reason", "no such InfoStructure object");
                return map;
            }
            
            structure = sdService.getInfoStructureById(isid);
            if (structure==null) {
                map.put("reason", "no such InfoStructure object");
                return map;
            }
            
            String ioidStr = (String) params.get("ioid");
            if (ioidStr!=null && !"".equals(ioidStr)) {
                ioid = new Long(ioidStr);
                object = sdService.getInfoObjectById(ioid);
                if (object==null) {
                    map.put("reason", "no such InfoStructure object");
                    return map;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
            return map;
        }
        
        try {
            PageSetting setting = new PageSetting();
            setting.setPage((String) params.get("page"));
            setting.setRowOfPage((String) params.get("count"));
            
            Collection posts = sdService.getPosts(structure, object, setting);
            
            request.setAttribute("structure", structure);
            request.setAttribute("object", object);
            request.setAttribute("setting", setting);
            request.setAttribute("posts", posts);
            
            map.put("html", WebContextFactory.get().forwardToString("/WEB-INF/jsp/discussion/sdPosts.jsp"));
            
            map.put("successful", true);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
            return map;
        }
        
        return map;
    }//getPosts()
    
    
    /**
     * Get second level discussion (replies) with the given conditions
     * 
     * @param params A map contains:
     *   <ul>
     *     <li>isid - int, id of a InfoStructure object</li>
     *     <li>ioid - int, id of a InfoObject object. Optional, default value is null, means the discussion is on InfoStructure object</li>
     *     <li>postid - int, id of a DiscussionPost object. Required.</li>
     *     <li>page - int, current page to get. Optional, default value is 1.</li>
     *     <li>count - int, number of posts to be displayed in a page. Optional, default value is -1, means to get all posts.</li>
     *   </ul>
     *   
     * @return A map contains:<br>
     *   <ul>
     *     <li>successful - a boolean value denoting if the operation succeeds</li>
     *     <li>reason - reason why operation failed (valid when successful==false)</li>
     *     <li>html - a HTML source segment. (valid when successful==true)<br>
     *         generated by /WEB-INF/jsp/discussion/sdReplies.jsp<br>
     *         the following variables are available for use in jsp page:
     *             <ul>
     *               <li>structure - An InfoStructure object</li>
     *               <li>object - An InfoObject object</li>
     *               <li>post - A DiscussionPost object</li>
     *               <li>setting - A PageSetting object</li>
     *               <li>replies - A list of DiscussionPost objects</li>
     *             </ul>
     *     </li>
     *   </ul>
     */
    public Map getReplies(HttpServletRequest request, Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        Long isid = null;
        InfoStructure structure = null;
        Long ioid = null;
        InfoObject object = null;
        Long postid = null;
        DiscussionPost post = null;
        
        try {
            isid = new Long((String) params.get("isid"));
            if (isid==null) {
                map.put("reason", "no such InfoStructure object");
                return map;
            }
            
            structure = sdService.getInfoStructureById(isid);
            if (structure==null) {
                map.put("reason", "no such InfoStructure object");
                return map;
            }
            
            String ioidStr = (String) params.get("ioid");
            if (ioidStr!=null && !"".equals(ioidStr)) {
                ioid = new Long(ioidStr);
                object = sdService.getInfoObjectById(ioid);
                if (object==null) {
                    map.put("reason", "no such InfoStructure object");
                    return map;
                }
            }
            
            postid = new Long((String) params.get("postid"));
            if (postid==null) {
                map.put("reason", "no such DiscussionPost object");
                return map;
            }
            
            post = sdService.getPostById(postid);
            if (post==null) {
                map.put("reason", "no such DiscussionPost object");
                return map;
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
            return map;
        }
        
        try {
            PageSetting setting = new PageSetting();
            setting.setPage((String) params.get("page"));
            setting.setRowOfPage((String) params.get("count"));
            
            Collection replies = sdService.getReplies(post, setting);
            
            request.setAttribute("structure", structure);
            request.setAttribute("object", object);
            request.setAttribute("post", post);
            request.setAttribute("setting", setting);
            request.setAttribute("replies", replies);
            
            map.put("html", WebContextFactory.get().forwardToString("/WEB-INF/jsp/discussion/sdReplies.jsp"));
            
            map.put("successful", true);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
            return map;
        }
        
        return map;
    }//getReplies()
    
    
    /**
     * Get the discussion targets view
     * 
     * @param params A map contains:
     *   <ul>
     *     <li>isid - int, id of a InfoStructure object</li>
     *   </ul>
     *   
     * @return A map contains:<br>
     *   <ul>
     *     <li>successful - a boolean value denoting if the operation succeeds</li>
     *     <li>reason - reason why operation failed (valid when successful==false)</li>
     *     <li>structure - an InfoStructure object (valid when successful==true)</li>
     *     <li>voting - an InfoVoting object, null if the current participant has not voted. (valid when successful==true)</li>
     *     <li>
     *       source - a PageSource object (valid when successful==true), it has the following properties:
     *       <ul>
     *         <li>html - a HTML source segment.<br>
     *           generated by /WEB-INF/jsp/discussion/sdTargets_XXX.jsp, here the XXX will be replaced by structure.type<br>
     *           the following variables are available for use in jsp page:
     *             <ul>
     *               <li>structure - An InfoStructure object</li>
     *             </ul>
     *         </li>
     *         <li>script - a Javascript segment.<br>
     *           generated by /WEB-INF/jsp/discussion/sdTargets_XXX.jsp, here the XXX will be replaced by structure.type<br>
     *           the following variables are available for use in jsp page:
     *             <ul>
     *               <li>structure - An InfoStructure object</li>
     *             </ul>
     *         </li>
     *       </ul>
     *     </li>
     *   </ul>
     */
    public Map getTargets(HttpServletRequest request, Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        Long isid = null;
        InfoStructure structure = null;
        
        try {
            isid = new Long((String) params.get("isid"));
            if (isid==null) {
                map.put("reason", "no such InfoStructure object");
                return map;
            }
            
            structure = sdService.getInfoStructureById(isid);
            if (structure==null) {
                map.put("reason", "no such InfoStructure object");
                return map;
            }
            
            request.setAttribute("structure", structure);
            
            InfoVoting voting = sdService.getVoting(structure);
            
            if (voting!=null) {
                map.put("voting", voting);
                request.setAttribute("voting", voting);
            }
            
            PageSource source = new PageSource();
            map.put("source", source);
            
            String file = "/WEB-INF/jsp/discussion/sdTargets_"+structure.getType()+".jsp";
            
            request.setAttribute(FragmentTag.FRAGMENT_TYPE, FragmentTag.HTML);
            source.setHtml(WebContextFactory.get().forwardToString(file));
            
            request.setAttribute(FragmentTag.FRAGMENT_TYPE, FragmentTag.SCRIPT);
            source.setScript(WebContextFactory.get().forwardToString(file));
            
            map.put("structure", structure);
            
            map.put("successful", true);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
            return map;
        }
        
        return map;
    }//getTargets()
    
    
    /**
     * Create a new Post to the given target
     * 
     * @param params A map contains:
     *   <ul>
     *     <li>isid - int, id of a InfoStructure object</li>
     *     <li>ioid - int, id of the InfoObject object. Optinal. If omitted, the dicussion is on the whole structure.</li>
     *     <li>title - string, title of the post. Optional.</li>
     *     <li>content - string, content of the post</li>
     *     <li>tags - string, comma separated tag names. Optional.</li>
     *   </ul>
     *   
     * @return A map contains:<br>
     *   <ul>
     *     <li>successful - a boolean value denoting if the operation succeeds</li>
     *     <li>reason - reason why operation failed (valid when successful==false)</li>
     *   </ul>
     */
    public Map createPost(Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        String title = (String) params.get("title");
        if (title==null) title = "";
        
        String content = (String) params.get("content");
        if (content==null || "".equals(content)) {
            map.put("reason", "content can't be empty.");
            return map;
        }
        
        String tagStr = (String) params.get("tags");
        if (tagStr==null) tagStr = "";
        String[] tags = tagStr.split(",");
        
        Long isid = null;
        InfoStructure structure = null;
        
        Long ioid = null;
        InfoObject object = null;
        
        try {
            isid = new Long((String) params.get("isid"));
            if (isid==null) {
                map.put("reason", "no such InfoStructure object");
                return map;
            }
            
            structure = sdService.getInfoStructureById(isid);
            if (structure==null) {
                map.put("reason", "no such InfoStructure object");
                return map;
            }
            
            try {
                ioid = new Long((String) params.get("ioid"));
            } catch(Exception e) {
            }
            
            if (ioid!=null) {
                object = sdService.getInfoObjectById(ioid);
                
                if (object==null) {
                    map.put("reason", "no such InfoObject object");
                    return map;
                }
            }
            
            if (object==null) {
                sdService.createPost(structure, title, content, tags);
            } else {
                sdService.createPost(object, title, content, tags);
            }
            
            map.put("successful", true);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
            return map;
        }
        
        return map;
    }//createPost()
    
    
    /**
     * Create a new reply to a discussion.
     * 
     * @param params A map contains:
     *   <ul>
     *     <li>isid - int, id of a InfoStructure object</li>
     *     <li>pid - int, id of the parent DiscussionPost object</li>
     *     <li>qid - int, id of the quoted DiscussionPost object. Optional, default is null, means no quote.</li>
     *     <li>title - string, title of the post. Optional.</li>
     *     <li>content - string, content of the post</li>
     *     <li>tags - string, comma separated tag names. Optional.</li>
     *   </ul>
     *   
     * @return A map contains:<br>
     *   <ul>
     *     <li>successful - a boolean value denoting if the operation succeeds</li>
     *     <li>reason - reason why operation failed (valid when successful==false)</li>
     *   </ul>
     */
    public Map createReply(Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        String title = (String) params.get("title");
        if (title==null) title = "";
        
        String content = (String) params.get("content");
        if (content==null || "".equals(content)) {
            map.put("reason", "content can't be empty.");
            return map;
        }
        
        String tagStr = (String) params.get("tags");
        if (tagStr==null) tagStr = "";
        String[] tags = tagStr.split(",");
        
        Long isid = null;
        InfoStructure structure = null;
        
        Long pid = null;
        DiscussionPost parent = null;
        
        Long qid = null;
        DiscussionPost quote = null;
        
        try {
            isid = new Long((String) params.get("isid"));
            if (isid==null) {
                map.put("reason", "no such InfoStructure object");
                return map;
            }
            
            structure = sdService.getInfoStructureById(isid);
            if (structure==null) {
                map.put("reason", "no such InfoStructure object");
                return map;
            }
            
            pid = new Long((String) params.get("pid"));
            if (pid==null) {
                map.put("reason", "no such DiscussionPost object");
                return map;
            }
            
            parent = sdService.getPostById(pid);
            if (parent==null) {
                map.put("reason", "no such DiscussionPost object");
                return map;
            }
            
            try {
                qid = new Long((String) params.get("qid"));
                if (qid!=null) {
                    quote = sdService.getPostById(qid);
                }
            } catch (Exception ex) {
            }
            
            sdService.createReply(parent, title, content, tags);
            
            map.put("successful", true);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
            return map;
        }
        
        return map;
    }//createReply()
    
    
    /**
     * Delete the given DiscussionPost object.
     * 
     * @param params A map contains:
     *   <ul>
     *     <li>pid - int, id of the DiscussionPost object</li>
     *   </ul>
     *   
     * @return A map contains:<br>
     *   <ul>
     *     <li>successful - a boolean value denoting if the operation succeeds</li>
     *     <li>reason - reason why operation failed (valid when successful==false)</li>
     *   </ul>
     */
    public Map deletePost(Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        Long pid = null;
        DiscussionPost post = null;
        
        try {
            pid = new Long((String) params.get("pid"));
            if (pid==null) {
                map.put("reason", "no such DiscussionPost object");
                return map;
            }
            
            post = sdService.getPostById(pid);
            if (post==null) {
                map.put("reason", "no such DiscussionPost object");
                return map;
            }
            
            if (post.getOwner().getId().equals(WebUtils.currentUserId())) {
                sdService.deletePost(post);
            } else {
                map.put("reason", "You are not the owner of this Discussion Post");
                return map;
            }
            
            map.put("successful", true);
        } catch (Exception e) {
            map.put("reason", e.getMessage());
            return map;
        }
        
        return map;
    }//deletePost()
    
    
    /**
     * Edit the content of the given Discussion Post object.
     * 
     * @param params A map contains:
     *   <ul>
     *     <li>pid - int, id of the DiscussionPost object</li>
     *     <li>title - string, title of the post. Optional.</li>
     *     <li>content - string, content of the post</li>
     *     <li>tags - string, comma separated tag names. Optional.</li>
     *   </ul>
     *   
     * @return A map contains:<br>
     *   <ul>
     *     <li>successful - a boolean value denoting if the operation succeeds</li>
     *     <li>reason - reason why operation failed (valid when successful==false)</li>
     *   </ul>
     */
    public Map editPost(Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        String title = (String) params.get("title");
        if (title==null) title = "";
        
        String content = (String) params.get("content");
        if (content==null || "".equals(content)) {
            map.put("reason", "content can't be empty.");
            return map;
        }
        
        String tagStr = (String) params.get("tags");
        if (tagStr==null) tagStr = "";
        String[] tags = tagStr.split(",");
        
        Long pid = null;
        DiscussionPost post = null;
        
        try {
            pid = new Long((String) params.get("pid"));
            if (pid==null) {
                map.put("reason", "no such DiscussionPost object");
                return map;
            }
            
            post = sdService.getPostById(pid);
            if (post==null) {
                map.put("reason", "no such DiscussionPost object");
                return map;
            }
            
            if (post.getOwner().getId()==WebUtils.currentUserId()) {
                sdService.editPost(post, title, content, tags);
            } else {
                map.put("reason", "You are not the owner of this Discussion Post");
            }
            
            map.put("successful", true);
        } catch (Exception e) {
            map.put("reason", e.getMessage());
            return map;
        }
        
        return map;
    }//editPost()
    
    
    /**
     * Get the summary of the given Theme.
     * 
     * @param params A map contains:
     *   <ul>
     *     <li>ioid - int, id of the InfoObject object</li>
     *     <li>type - string, ["asHTML" | "asObject"]. Optional, default is "asHTML"</li>
     *   </ul>
     *   
     * @return A map contains:<br>
     *   <ul>
     *     <li>successful - a boolean value denoting if the operation succeeds</li>
     *     <li>reason - reason why operation failed (valid when successful==false)</li>
     *     <li>infoObject - An InfoObject object (valid when successful==false and type==asObject)</li>
     *     <li>voting - an InfoVoting object, null if the current participant has not voted. (valid when successful==true)</li>
     *     <li>
     *       source - a PageSource object (valid when successful==true), it has the following properties:
     *       <ul>
     *         <li>html - a HTML source segment.<br>
     *           generated by /WEB-INF/jsp/discussion/sdcSummary.jsp<br>
     *           the following variables are available for use in jsp page:
     *             <ul>
     *               <li>infoObject - An InfoObject object</li>
     *             </ul>
     *         </li>
     *         <li>script - a Javascript segment.<br>
     *           generated by /WEB-INF/jsp/discussion/sdcSummary.jsp<br>
     *           the following variables are available for use in jsp page:
     *             <ul>
     *               <li>infoObject - An InfoObject object</li>
     *             </ul>
     *         </li>
     *       </ul>
     *     </li>
     *   </ul>
     */
    public Map getSummary(HttpServletRequest request, Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        Long ioid = null;
        InfoObject infoObject = null;
        try {
            ioid = new Long((String) params.get("ioid"));
            infoObject = sdService.getInfoObjectById(ioid);
            if (infoObject==null) {
                map.put("reason", "no such DiscussionPost object");
                return map;
            }
            
            InfoVoting voting = sdService.getVoting(infoObject);
            
            if (voting!=null) {
                request.setAttribute("voting", voting);
                map.put("voting", voting);
            }
            
        } catch (Exception e) {
            map.put("reason", "no such DiscussionPost object");
            return map;
        }
        
        try {
            String type = (String) params.get("type");
            
            if (type==null || "".equals(type) || "asHTML".equals(type)) {
                request.setAttribute("infoObject", infoObject);
                
                PageSource source = new PageSource();
                map.put("source", source);
                
                request.setAttribute(FragmentTag.FRAGMENT_TYPE, FragmentTag.HTML);
                source.setHtml(WebContextFactory.get().forwardToString("/WEB-INF/jsp/discussion/sdcSummary.jsp"));
                
                request.setAttribute(FragmentTag.FRAGMENT_TYPE, FragmentTag.SCRIPT);
                source.setScript(WebContextFactory.get().forwardToString("/WEB-INF/jsp/discussion/sdcSummary.jsp"));
            } else if ("asObject".equals(type)) {
                map.put("infoObject", infoObject);
            } else {
                map.put("reason", "unsupported type");
                return map;
            }
            
            map.put("successful", true);
        } catch (Exception e) {
            map.put("reason", e.getMessage());
            return map;
        }
        
        return map;
    }//getSummary()
    
    
    /**
     * Set the voting choice on the given InfoStructure OR InfoObject.
     * 
     * @param params A map contains:
     *   <ul>
     *     <li>isid - int, id of the InfoStructure object. Must be omitted if ioid is given.</li>
     *     <li>ioid - int, id of the InfoObject object. Must be omitted if isid is given.</li>
     *     <li>agree - boolean, whether or not the current user agree with the current object.</li>
     *   </ul>
     *   
     * @return A map contains:<br>
     *   <ul>
     *     <li>successful - a boolean value denoting if the operation succeeds</li>
     *     <li>reason - reason why operation failed (valid when successful==false)</li>
     *   </ul>
     */
    public Map setVoting(Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        Long isid = null;
        Long ioid = null;
        
        try {
            isid = new Long((String) params.get("isid"));
        } catch (Exception e) {
        }
        
        try {
            ioid = new Long((String) params.get("ioid"));
        } catch (Exception e) {
        }
        
        if (isid==null && ioid==null) {
            map.put("reason", "Either isid or ioid has to be given.");
            return map;
        }
        
        try {
            boolean agree = "true".equalsIgnoreCase((String) params.get("agree"));
            
            if (isid!=null) {
                InfoStructure structure = sdService.getInfoStructureById(isid);
                if (structure==null) {
                    map.put("reason", "Can't find the given InfoStructure object.");
                    return map;
                }
                
                sdService.setVoting(structure, agree);
            } else if (ioid!=null) {
                InfoObject object = sdService.getInfoObjectById(ioid);
                if (object==null) {
                    map.put("reason", "Can't find the given InfoObject object.");
                    return map;
                }
                
                sdService.setVoting(object, agree);
            }
            
            map.put("successful", true);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
            return map;
        }
        
        return map;
    }//setVoting()
    
    
    /**
     * Get the related concerns in this SDX instance.
     * 
     * @param params a map contains:<br>
     *     <ul>
     *       <li>isid - the id of the current InfoStructure object</li>
     *       <li>ioid - the id of the current InfoObject object. (Optional, if omitted means at the InfoStructure level)</li>
     *       <li>count - int, concerns shown per page. (Optional, default is -1, means show all)</li>
     *       <li>page - int, current page number (Optional, default is 1).</li>
     *     </ul>
     * 
     * @return a map contains:<br>
     *     <ul>
     *       <li>successful - a boolean value denoting if the operation succeeds</li>
     *       <li>reason - reason why operation failed (valid when successful==false)</li>
     *       <li>
     *         source - a PageSource object (valid when successful==true), it has the following properties:
     *         <ul>
     *           <li>html - a HTML source segment.<br>
     *             generated by /WEB-INF/jsp/discussion/sidebar-concerns.jsp<br>
     *             the following variables are available for use in jsp page:
     *               <ul>
     *                 <li>structure - An InfoStructure object</li>
     *                 <li>object - An InfoObject object (valid if ioid is provided)</li>
     *                 <li>setting - An PageSetting object</li>
     *               </ul>
     *           </li>
     *           <li>script - a Javascript segment.<br>
     *             generated by /WEB-INF/jsp/discussion/sidebar-concerns.jsp<br>
     *             the following variables are available for use in jsp page:
     *               <ul>
     *                 <li>structure - An InfoStructure object</li>
     *                 <li>object - An InfoObject object (valid if ioid is provided)</li>
     *                 <li>setting - An PageSetting object</li>
     *               </ul>
     *           </li>
     *         </ul>
     *       </li>
     *     </ul>
     */
    public Map getConcerns(HttpServletRequest request, Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        Long isid = null;
        
        try {
            isid = new Long((String) params.get("isid"));
        } catch (Exception e) {
            map.put("reason", "can't find this InfoStructure object.");
            return map;
        }
        
        Long ioid = null;
        try {
            ioid = new Long((String) params.get("ioid"));
        } catch (Exception e) {
        }
        
        int count = -1;
        try {
            count = Integer.parseInt((String) params.get("count"));
        } catch (Exception e) {
        }
        
        int page = 1;
        try {
            page = Integer.parseInt((String) params.get("page"));
        } catch (Exception e) {
        }
        
        try {
            InfoStructure structure = sdService.getInfoStructureById(isid);
            if (structure==null) {
                map.put("reason", "can't find this InfoStructure object.");
                return map;
            }
            
            request.setAttribute("structure", structure);
            
            PageSetting setting = new PageSetting();
            setting.setRowOfPage(count);
            setting.setPage(page);
            
            Collection concerns = null;
            
            if (ioid==null) {
                concerns = sdService.getConcerns(structure, setting);
            } else {
                InfoObject object = sdService.getInfoObjectById(ioid);
                
                if (object==null) {
                    map.put("reason", "can't find this InfoObject object.");
                    return map;
                }
                
                request.setAttribute("object", object);
                
                concerns = sdService.getConcerns(object, setting);
            }
            
            request.setAttribute("concerns", concerns);
            
            PageSource source = new PageSource();
            map.put("source", source);
            
            request.setAttribute(FragmentTag.FRAGMENT_TYPE, FragmentTag.HTML);
            source.setHtml(WebContextFactory.get().forwardToString("/WEB-INF/jsp/discussion/sidebar-concerns.jsp"));
            
            request.setAttribute(FragmentTag.FRAGMENT_TYPE, FragmentTag.SCRIPT);
            source.setScript(WebContextFactory.get().forwardToString("/WEB-INF/jsp/discussion/sidebar-concerns.jsp"));
            
            map.put("successful", true);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
            return map;
        }
        
        return map;
    }//getConcerns()
    
    
}//class SDAgent
