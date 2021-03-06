package org.pgist.discussion;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.search.Hits;
import org.apache.lucene.search.IndexSearcher;
import org.directwebremoting.WebContextFactory;
import org.pgist.cvo.Concern;
import org.pgist.other.Experiment;
import org.pgist.other.ImportService;
import org.pgist.search.SearchHelper;
import org.pgist.system.EmailSender;
import org.pgist.system.SystemService;
import org.pgist.system.YesNoVoting;
import org.pgist.tagging.Tag;
import org.pgist.tags.FragmentTag;
import org.pgist.users.User;
import org.pgist.util.PageSetting;
import org.pgist.util.PageSource;
import org.pgist.util.WebUtils;
import org.pgist.wfengine.web.WorkflowUtils;


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
    
    private SystemService systemService;
    
    private EmailSender emailSender;
    
    private SearchHelper searchHelper;
    
    private WorkflowUtils workflowUtils;
    
    private ImportService importService;
    
    
    public void setSdService(SDService sdService) {
        this.sdService = sdService;
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


    public void setImportService(ImportService importService) {
        this.importService = importService;
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
     *     <li>voting - a YesNoVoting object (may be null if the current user hasn't voted yet.)</li>
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
            
            YesNoVoting voting = systemService.getVoting(YesNoVoting.TYPE_DISCUSSION_POST, id);
            if (voting!=null) {
                map.put("voting", voting);
            }
            
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
     *     <li>filter - string, tag name as filter</li>
     *     <li>sorting - int, the sorting index, 1-7, referencing DiscussionDAOImpl.java for the meaning</li>
     *     <li>page - int, current page to get. Optional, default value is 1.</li>
     *     <li>count - int, number of posts to be displayed in a page. Optional, default value is -1, means to get all posts.</li>
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
     *     <li>html - a HTML source segment. (valid when successful==true)<br>
     *         generated by /WEB-INF/jsp/discussion/sdPosts.jsp<br>
     *         the following variables are available for use in jsp page:
     *             <ul>
     *               <li>structure - An InfoStructure object</li>
     *               <li>object - An InfoObject object</li>
     *               <li>setting - A PageSetting object</li>
     *               <li>posts - A list of DiscussionPost objects, each object has a field named "object"
     *                which is a YesNoVoting object or null if the current user has not voted on this reply yet.</li>
     *             </ul>
     *     </li>
     *   </ul>
     */
    public Map getPosts(HttpServletRequest request, Map params, Map wfinfo) {
        Map map = new HashMap();
        map.put("successful", false);
        
        Long isid = null;
        InfoStructure structure = null;
        Long ioid = null;
        InfoObject object = null;
        
        try {
            request.setAttribute("wfinfo", wfinfo);
            
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
            int sorting = 0;
            try {
                sorting = Integer.parseInt((String) params.get("sorting"));
            } catch (Exception e) {
            }
            
            PageSetting setting = new PageSetting();
            setting.setPage((String) params.get("page"));
            setting.setRowOfPage((String) params.get("count"));
            
            String filter = (String) params.get("filter");
            if (filter==null) filter = "";
            else filter = filter.trim();
            
            Collection posts = null;
            
            if ("".equals(filter)) {
                //without filter
                posts = sdService.getPosts(structure, object, setting, sorting);
            } else {
                //with filter
                posts = sdService.getPosts(structure, object, setting, filter, sorting);
            }
            
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
     *     <li>filter - string, tag name as filter</li>
     *     <li>page - int, current page to get. Optional, default value is 1.</li>
     *     <li>count - int, number of posts to be displayed in a page. Optional, default value is -1, means to get all posts.</li>
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
     *     <li>html - a HTML source segment. (valid when successful==true)<br>
     *         generated by /WEB-INF/jsp/discussion/sdReplies.jsp<br>
     *         the following variables are available for use in jsp page:
     *             <ul>
     *               <li>structure - An InfoStructure object</li>
     *               <li>object - An InfoObject object</li>
     *               <li>post - A DiscussionPost object, it may contains a YesNoVoting object in the field
     *               named "object" or null if the current user has not voted on this post yet.</li>
     *               <li>setting - A PageSetting object</li>
     *               <li>replies - A list of DiscussionPost objects, each object has a field named "object"
     *                which is a YesNoVoting object or null if the current user has not voted on this reply yet.</li>
     *             </ul>
     *     </li>
     *   </ul>
     */
    public Map getReplies(HttpServletRequest request, Map params, Map wfinfo) {
        Map map = new HashMap();
        map.put("successful", false);
        
        Long isid = null;
        InfoStructure structure = null;
        Long ioid = null;
        InfoObject object = null;
        Long postid = null;
        DiscussionPost post = null;
        
        try {
            request.setAttribute("wfinfo", wfinfo);
            
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
            
            YesNoVoting voting = systemService.getVoting(YesNoVoting.TYPE_DISCUSSION_POST, post.getId());
            if (voting!=null) {
                request.setAttribute("voting", voting);
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
            
            String filter = (String) params.get("filter");
            if (filter==null) filter = "";
            else filter = filter.trim();
            
            Collection replies = null;
            
            if ("".equals(filter)) {
                //without filter
                replies = sdService.getReplies(post, setting);
            } else {
                //with filter
                replies = sdService.getReplies(post, setting, filter);
            }
            
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
     *     <li>structure - an InfoStructure object (valid when successful==true)</li>
     *     <li>voting - an YesNoVoting object, null if the current participant has not voted. (valid when successful==true)</li>
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
    public Map getTargets(HttpServletRequest request, Map params, Map wfinfo) {
        Map map = new HashMap();
        map.put("successful", false);
        
        Long isid = null;
        InfoStructure structure = null;
        
        try {
            request.setAttribute("wfinfo", wfinfo);
            
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
            
            YesNoVoting voting = systemService.getVoting(YesNoVoting.TYPE_INFO_STRUCTURE, isid);
            
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
     *     <li>emailNotify - string, "true" means sending email notification, "false" means not. Default is "false".</li>
     *   </ul>
     *   
     * @param wfinfo A map contains:
     *   <ul>
     *     <li>workflowId - long</li>
     *     <li>contextId - long</li>
     *     <li>activityId - long</li>
     *   </ul>
     * 
     * @return A map contains:<br>
     *   <ul>
     *     <li>successful - a boolean value denoting if the operation succeeds</li>
     *     <li>reason - reason why operation failed (valid when successful==false)</li>
     *     <li>id - int, the id of the new Post</li>
     *   </ul>
     */
    public Map createPost(HttpServletRequest request, Map params, Map wfinfo) {
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
        
        DiscussionPost post = null;
        
        try {
            request.setAttribute("wfinfo", wfinfo);
            
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
            
            String emailNotify = (String) params.get("emailNotify");
            
            if (object==null) {
                post = sdService.createPost(structure, title, content, tags, "true".equals(emailNotify));
            } else {
                post = sdService.createPost(object, title, content, tags, "true".equals(emailNotify));
            }
            
            map.put("id", post.getId());
            map.put("successful", true);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
            return map;
        }
        
        try {
            if (post!=null) {
                /*
                 * Indexing with Lucene.
                 */
                IndexWriter writer = null;
                try {
                    writer = searchHelper.getIndexWriter();
                    Document doc = new Document();
                    doc.add( new Field("type", "post", Field.Store.YES, Field.Index.UN_TOKENIZED) );
                    doc.add( new Field("author", post.getOwner().getLoginname(), Field.Store.YES, Field.Index.TOKENIZED) );
                    doc.add( new Field("date", post.getCreateTime().toString(), Field.Store.YES, Field.Index.UN_TOKENIZED) );
                    doc.add( new Field("title", post.getTitle(), Field.Store.YES, Field.Index.UN_TOKENIZED) );
                    doc.add( new Field("body", post.getContent(), Field.Store.YES, Field.Index.UN_TOKENIZED) );
                    doc.add( new Field("tags", tagStr, Field.Store.YES, Field.Index.UN_TOKENIZED) );
                    doc.add( new Field("contents", post.getTitle()+" "+Arrays.toString(tags)+" "+post.getContent(), Field.Store.NO, Field.Index.TOKENIZED) );
                    doc.add( new Field("workflowid", post.getDiscussion().getWorkflowId().toString(), Field.Store.YES, Field.Index.UN_TOKENIZED) );
                    doc.add( new Field("contextid", wfinfo.get("contextId").toString(), Field.Store.YES, Field.Index.UN_TOKENIZED) );
                    doc.add( new Field("activityid", wfinfo.get("activityId").toString(), Field.Store.YES, Field.Index.UN_TOKENIZED) );
                    doc.add( new Field("postid", post.getId().toString(), Field.Store.YES, Field.Index.UN_TOKENIZED) );
                    doc.add( new Field("isid", isid==null ? "" : isid.toString(), Field.Store.YES, Field.Index.UN_TOKENIZED) );
                    doc.add( new Field("ioid", ioid==null ? "" : ioid.toString(), Field.Store.YES, Field.Index.UN_TOKENIZED) );
                    writer.addDocument(doc);
                } catch(Exception e) {
                    e.printStackTrace();
                } finally {
                    if (writer!=null) writer.close();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
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
     *     <li>rid - int, id of the parent DiscussionReply object, optional</li>
     *     <li>title - string, title of the post. Optional.</li>
     *     <li>content - string, content of the post</li>
     *     <li>tags - string, comma separated tag names. Optional.</li>
     *     <li>emailNotify - string, "true" means sending email notification, "false" means not. Default is "false".</li>
     *   </ul>
     *   
     * @param wfinfo A map contains:
     *   <ul>
     *     <li>workflowId - long</li>
     *     <li>contextId - long</li>
     *     <li>activityId - long</li>
     *   </ul>
     * 
     * @return A map contains:<br>
     *   <ul>
     *     <li>successful - a boolean value denoting if the operation succeeds</li>
     *     <li>reason - reason why operation failed (valid when successful==false)</li>
     *     <li>id - int, the id of the new reply</li>
     *   </ul>
     */
    public Map createReply(HttpServletRequest request, Map params, Map wfinfo) {
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
        InfoObject infoObject = null;
        
        Long pid = null;
        Long rid = null;
        
        DiscussionReply reply = null;
        
        try {
            request.setAttribute("wfinfo", wfinfo);
            
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
            
            try {
                rid = new Long((String) params.get("rid"));
            } catch (Exception e) {
            }
            
            String emailNotify = (String) params.get("emailNotify");
            
            reply = sdService.createReply(pid, rid, title, content, tags, "true".equals(emailNotify));
            
            map.put("id", reply.getId());
            map.put("successful", true);
            
            infoObject = sdService.getInfoObjectByDiscussionId(reply.getParent().getDiscussion().getId());
            
            //sending email notification
            try {
                Map values = new HashMap();
                values.put("reply", reply);
                
                Set set = sdService.getEmailUsers(reply);
                
                for (User user : (Set<User>) set) {
                    values.put("user", user);
                    String ioid = "";
                    if (infoObject!=null) ioid = ""+infoObject.getId();
                    
                    StringBuilder url = new StringBuilder(100);
                    url.append("http://").append(request.getServerName());
                    
                    int port = request.getLocalPort();
                    if (port!=80) {
                        url.append(":").append(port);
                    }
                    
                    url.append("/sdThread.do?");
                    url.append("workflowId=").append(wfinfo.get("workflowId"));
                    url.append("&contextId=").append(wfinfo.get("contextId"));
                    url.append("&activityId=").append(wfinfo.get("activityId"));
                    url.append("&isid=").append(isid);
                    url.append("&ioid=").append(ioid);
                    url.append("&pid=").append(pid);
                    
                    values.put("url", url.toString());
                    emailSender.send(user, "post_reply", values);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
            return map;
        }
        
        if (reply!=null) {
            IndexWriter writer = null;
            
            try {
                /*
                 * Indexing with Lucene.
                 */
                writer = searchHelper.getIndexWriter();
                Document doc = new Document();
                doc.add( new Field("type", "reply", Field.Store.YES, Field.Index.UN_TOKENIZED) );
                doc.add( new Field("author", reply.getOwner().getLoginname(), Field.Store.YES, Field.Index.TOKENIZED) );
                doc.add( new Field("date", reply.getCreateTime().toString(), Field.Store.YES, Field.Index.UN_TOKENIZED) );
                doc.add( new Field("title", reply.getTitle(), Field.Store.YES, Field.Index.UN_TOKENIZED) );
                doc.add( new Field("body", reply.getContent(), Field.Store.YES, Field.Index.UN_TOKENIZED) );
                doc.add( new Field("tags", tagStr, Field.Store.YES, Field.Index.UN_TOKENIZED) );
                doc.add( new Field("contents", reply.getTitle()+" "+Arrays.toString(tags)+" "+reply.getContent(), Field.Store.NO, Field.Index.TOKENIZED) );
                doc.add( new Field("workflowid", reply.getParent().getDiscussion().getWorkflowId().toString(), Field.Store.YES, Field.Index.UN_TOKENIZED) );
                doc.add( new Field("contextid", wfinfo.get("contextId").toString(), Field.Store.YES, Field.Index.UN_TOKENIZED) );
                doc.add( new Field("activityid", wfinfo.get("activityId").toString(), Field.Store.YES, Field.Index.UN_TOKENIZED) );
                doc.add( new Field("postid", reply.getParent().getId().toString(), Field.Store.YES, Field.Index.UN_TOKENIZED) );
                doc.add( new Field("replyid", reply.getId().toString(), Field.Store.YES, Field.Index.UN_TOKENIZED) );
                doc.add( new Field("isid", isid==null ? "" : isid.toString(), Field.Store.YES, Field.Index.UN_TOKENIZED) );
                doc.add( new Field("ioid", infoObject==null ? "" : infoObject.getId().toString(), Field.Store.YES, Field.Index.UN_TOKENIZED) );
                writer.addDocument(doc);
                writer.close();
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (writer!=null) {
                    try {
                        writer.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        }
        
        return map;
    }//createReply()
    
    
    /**
     * Delete the given DiscussionPost object. Only used by moderator.
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
                
                /*
                 * delete from lucene
                 */
                IndexSearcher searcher = null;
                IndexReader reader = null;
                try {
                    searcher = searchHelper.getIndexSearcher();
                    
                    Hits hits = searcher.search(searchHelper.getParser().parse(
                        "workflowid:"+post.getDiscussion().getWorkflowId()
                       +" AND postid:"+post.getId()
                    ));
                    
                    if (hits.length()>0) {
                        reader = searchHelper.getIndexReader();
                        for (int i=0; i<hits.length(); i++) {
                            reader.deleteDocument(hits.id(i));
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (searcher!=null) searcher.close();
                    if (reader!=null) reader.close();
                }
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
     * Delete the given DiscussionReply object. Only used by moderator.
     * 
     * @param params A map contains:
     *   <ul>
     *     <li>rid - int, id of the DiscussionReply object</li>
     *   </ul>
     *   
     * @return A map contains:<br>
     *   <ul>
     *     <li>successful - a boolean value denoting if the operation succeeds</li>
     *     <li>reason - reason why operation failed (valid when successful==false)</li>
     *   </ul>
     */
    public Map deleteReply(Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        Long rid = null;
        DiscussionReply reply = null;
        
        try {
            rid = new Long((String) params.get("rid"));
            if (rid==null) {
                map.put("reason", "no such DiscussionReply object");
                return map;
            }
            
            reply = sdService.getReplyById(rid);
            if (reply==null) {
                map.put("reason", "no such DiscussionPost object");
                return map;
            }
            
            //check if it's moderator, TODO
            if (reply.getOwner().getId().equals(WebUtils.currentUserId())) {
                sdService.deleteReply(reply);
                
                /*
                 * delete from lucene
                 */
                IndexSearcher searcher = null;
                IndexReader reader = null;
                try {
                    searcher = searchHelper.getIndexSearcher();
                    
                    Hits hits = searcher.search(searchHelper.getParser().parse(
                        "workflowid:"+reply.getParent().getDiscussion().getWorkflowId()
                       +" AND type:reply AND postid:"+reply.getParent().getId()+" AND replyid:"+reply.getId()
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
                map.put("reason", "You are not the owner of this Discussion Post");
                return map;
            }
            
            map.put("successful", true);
        } catch (Exception e) {
            map.put("reason", e.getMessage());
            return map;
        }
        
        return map;
    }//deleteReply()
    
    
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
     * @param wfinfo A map contains:
     *   <ul>
     *     <li>workflowId - long</li>
     *     <li>contextId - long</li>
     *     <li>activityId - long</li>
     *   </ul>
     * 
     * @return A map contains:<br>
     *   <ul>
     *     <li>successful - a boolean value denoting if the operation succeeds</li>
     *     <li>reason - reason why operation failed (valid when successful==false)</li>
     *   </ul>
     */
    public Map editPost(Map params, Map wfinfo) {
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
                
                Document doc = new Document();
                
                /*
                 * delete from lucene
                 */
                IndexSearcher searcher = null;
                IndexWriter writer = null;
                try {
                    searcher = searchHelper.getIndexSearcher();
                    
                    Hits hits = searcher.search(searchHelper.getParser().parse(
                        "workflowid:"+post.getDiscussion().getWorkflowId()
                       +" AND type:post AND postid:"+post.getId()
                    ));
                    
                    if (hits.length()>0) {
                        Document hit = hits.doc(0);
                        doc.add( new Field("type", "post", Field.Store.YES, Field.Index.UN_TOKENIZED) );
                        doc.add( new Field("author", post.getOwner().getLoginname(), Field.Store.YES, Field.Index.TOKENIZED) );
                        doc.add( new Field("date", post.getCreateTime().toString(), Field.Store.YES, Field.Index.UN_TOKENIZED) );
                        doc.add( new Field("title", post.getTitle(), Field.Store.YES, Field.Index.UN_TOKENIZED) );
                        doc.add( new Field("body", post.getContent(), Field.Store.YES, Field.Index.UN_TOKENIZED) );
                        doc.add( new Field("tags", tagStr, Field.Store.YES, Field.Index.UN_TOKENIZED) );
                        doc.add( new Field("contents", post.getTitle()+" "+Arrays.toString(tags)+" "+post.getContent(), Field.Store.NO, Field.Index.TOKENIZED) );
                        doc.add( new Field("workflowid", post.getDiscussion().getWorkflowId().toString(), Field.Store.YES, Field.Index.UN_TOKENIZED) );
                        doc.add( new Field("contextid", wfinfo.get("contextId").toString(), Field.Store.YES, Field.Index.UN_TOKENIZED) );
                        doc.add( new Field("activityid", wfinfo.get("activityId").toString(), Field.Store.YES, Field.Index.UN_TOKENIZED) );
                        doc.add( new Field("postid", post.getId().toString(), Field.Store.YES, Field.Index.UN_TOKENIZED) );
                        doc.add( new Field("isid", hit.getField("isid").stringValue(), Field.Store.YES, Field.Index.UN_TOKENIZED) );
                        doc.add( new Field("ioid", hit.getField("ioid").stringValue(), Field.Store.YES, Field.Index.UN_TOKENIZED) );
                        
                        IndexReader reader = searchHelper.getIndexReader();
                        reader.deleteDocument(hits.id(0));
                        reader.close();
                    }
                    
                    /*
                     * reindexing in lucene
                     */
                    writer = searchHelper.getIndexWriter();
                    writer.addDocument(doc);
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (searcher!=null) searcher.close();
                    if (writer!=null) writer.close();
                }
                
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
     *     <li>isid - int, id of the InfoStructure object, can be ommitted if ioid is given</li>
     *     <li>ioid - int, id of the InfoObject object. Optional, if isid is given</li>
     *     <li>type - string, ["asHTML" | "asObject"]. Optional, default is "asHTML"</li>
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
     *     <li>infoObject - An InfoObject object (valid when successful==false and type==asObject)</li>
     *     <li>voting - an YesNoVoting object, null if the current participant has not voted. (valid when successful==true)</li>
     *     <li>
     *       source - a PageSource object (valid when successful==true), it has the following properties:
     *       <ul>
     *         <li>html - a HTML source segment.<br>
     *           generated by /WEB-INF/jsp/discussion/sdcSummary.jsp if ioid is given<br>
     *           the following variables are available for use in jsp page:
     *             <ul>
     *               <li>infoObject - An InfoObject object</li>
     *               <li>voting - An YesNoVoting object</li>
     *             </ul>
     *           Or if ioid is not given and isid is given,
     *           generated by /WEB-INF/jsp/discussion/sdcStructureSummary.jsp if ioid is given<br>
     *           the following variables are available for use in jsp page:
     *             <ul>
     *               <li>infoStructure - An InfoStructure object</li>
     *             </ul>
     *         </li>
     *         <li>script - a Javascript segment.<br>
     *           generated by /WEB-INF/jsp/discussion/sdcSummary.jsp if ioid is given<br>
     *           the following variables are available for use in jsp page:
     *             <ul>
     *               <li>infoObject - An InfoObject object</li>
     *               <li>voting - An YesNoVoting object</li>
     *             </ul>
     *           Or if ioid is not given and isid is given,
     *           generated by /WEB-INF/jsp/discussion/sdcStructureSummary.jsp if ioid is given<br>
     *           the following variables are available for use in jsp page:
     *             <ul>
     *               <li>infoStructure - An InfoStructure object</li>
     *             </ul>
     *         </li>
     *       </ul>
     *     </li>
     *   </ul>
     */
    public Map getSummary(HttpServletRequest request, Map params, Map wfinfo) {
        Map map = new HashMap();
        map.put("successful", false);
        
        Long isid = null;
        try {
            isid = new Long((String) params.get("isid"));
        } catch (Exception e) {
        }
        
        Long ioid = null;
        try {
            ioid = new Long((String) params.get("ioid"));
        } catch (Exception e) {
        }
        
        if (isid==null && ioid==null) {
            map.put("reason", "Either isid or ioid is required.");
            return map;
        }
        
        try {
            request.setAttribute("wfinfo", wfinfo);
            
            String type = (String) params.get("type");
            
            if (ioid!=null) {
                InfoObject infoObject = sdService.getInfoObjectById(ioid);
                
                YesNoVoting voting = systemService.getVoting(YesNoVoting.TYPE_INFO_OBJECT, ioid);
                if (voting!=null) {
                    request.setAttribute("voting", voting);
                    map.put("voting", voting);
                }
                
                if (type==null || "".equals(type) || "asHTML".equals(type)) {
                    request.setAttribute("infoObject", infoObject);
                    request.setAttribute("structure", infoObject.getStructure());
                    
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
            } else {
                InfoStructure structure = sdService.getInfoStructureById(isid);
                
                request.setAttribute("structure", structure);
                
                YesNoVoting voting = systemService.getVoting(YesNoVoting.TYPE_INFO_STRUCTURE, isid);
                if (voting!=null) {
                    request.setAttribute("voting", voting);
                    map.put("voting", voting);
                }
                
                if (type==null || "".equals(type) || "asHTML".equals(type)) {
                    request.setAttribute("infoStructure", structure);
                    
                    PageSource source = new PageSource();
                    map.put("source", source);
                    
                    request.setAttribute(FragmentTag.FRAGMENT_TYPE, FragmentTag.HTML);
                    source.setHtml(WebContextFactory.get().forwardToString("/WEB-INF/jsp/discussion/sdcStructureSummary.jsp"));
                    
                    request.setAttribute(FragmentTag.FRAGMENT_TYPE, FragmentTag.SCRIPT);
                    source.setScript(WebContextFactory.get().forwardToString("/WEB-INF/jsp/discussion/sdcStructureSummary.jsp"));
                } else if ("asObject".equals(type)) {
                    map.put("infoStructure", structure);
                } else {
                    map.put("reason", "unsupported type");
                    return map;
                }
            }
            
            map.put("successful", true);
        } catch (Exception e) {
            map.put("reason", e.getMessage());
            return map;
        }
        
        return map;
    }//getSummary()
    
    
    /**
     * Get a target for the given room.
     * 
     * @param params A map contains:
     *   <ul>
     *     <li>isid - int, id of the InfoStructure object, can be ommitted if ioid is given</li>
     *     <li>ioid - int, id of the InfoObject object. Optional, if isid is given</li>
     *   </ul>
     *   
     * @param wfinfo A map contains:
     *   <ul>
     *     <li>workflowId - long</li>
     *     <li>contextId - long</li>
     *     <li>activityId - long</li>
     *   </ul>
     * 
     * @return A map contains:<br>
     *   <ul>
     *     <li>successful - a boolean value denoting if the operation succeeds</li>
     *     <li>reason - reason why operation failed (valid when successful==false)</li>
     *     <li>voting - an YesNoVoting object, null if the current participant has not voted. (valid when successful==true)</li>
     *     <li>
     *       source - a PageSource object (valid when successful==true), it has the following properties:
     *       <br>xxx means a type string constant in InfoStructure object.
     *       <ul>
     *         <li>html - a HTML source segment.<br>
     *           generated by /WEB-INF/jsp/discussion/xxxStructureTarget.jsp if ioid is given<br>
     *           the following variables are available for use in jsp page:
     *             <ul>
     *               <li>infoObject - An InfoObject object</li>
     *               <li>voting - An YesNoVoting object</li>
     *             </ul>
     *           Or if ioid is not given and isid is given,
     *           generated by /WEB-INF/jsp/discussion/xxxStructureTarget.jsp if ioid is given<br>
     *           the following variables are available for use in jsp page:
     *             <ul>
     *               <li>infoStructure - An InfoStructure object</li>
     *             </ul>
     *         </li>
     *         <li>script - a Javascript segment.<br>
     *           generated by /WEB-INF/jsp/discussion/xxxTarget.jsp if ioid is given<br>
     *           the following variables are available for use in jsp page:
     *             <ul>
     *               <li>infoObject - An InfoObject object</li>
     *               <li>voting - An YesNoVoting object</li>
     *             </ul>
     *           Or if ioid is not given and isid is given,
     *           generated by /WEB-INF/jsp/discussion/xxxTarget.jsp if ioid is given<br>
     *           the following variables are available for use in jsp page:
     *             <ul>
     *               <li>infoStructure - An InfoStructure object</li>
     *             </ul>
     *         </li>
     *       </ul>
     *     </li>
     *   </ul>
     */
    public Map getTarget(HttpServletRequest request, Map params, Map wfinfo) {
        Map map = new HashMap();
        map.put("successful", false);
        
        Long isid = null;
        try {
            isid = new Long((String) params.get("isid"));
        } catch (Exception e) {
        }
        
        Long ioid = null;
        try {
            ioid = new Long((String) params.get("ioid"));
        } catch (Exception e) {
        }
        
        if (isid==null && ioid==null) {
            map.put("reason", "Either isid or ioid is required.");
            return map;
        }
        
        try {
            request.setAttribute("wfinfo", wfinfo);
            workflowUtils.processWorkflowInfo(
                request,
                new Long(wfinfo.get("workflowId").toString()),
                new Long(wfinfo.get("contextId").toString()),
                new Long(wfinfo.get("activityId").toString())
            );
            
            Experiment experiment = importService.getExperimentByWorkflowId(new Long(wfinfo.get("workflowId").toString()));
            request.setAttribute("experiment", experiment);
            
            String type = null;
            if(ioid != null && isid != null) {
            	InfoStructure structure = sdService.getInfoStructureById(isid);
            	InfoObject infoObject = sdService.getInfoObjectById(ioid);
                
                type = infoObject.getStructure().getType();
                
                YesNoVoting voting = systemService.getVoting(YesNoVoting.TYPE_INFO_OBJECT, ioid);
                if (voting!=null) {
                    request.setAttribute("voting", voting);
                    map.put("voting", voting);
                }
                
                request.setAttribute("infoObject", infoObject);
                
                PageSource source = new PageSource();
                map.put("source", source);
                request.setAttribute("infoStructure", structure);
                request.setAttribute(FragmentTag.FRAGMENT_TYPE, FragmentTag.HTML);
                source.setHtml(WebContextFactory.get().forwardToString("/WEB-INF/jsp/discussion/"+type+"Target.jsp"));
                
                request.setAttribute(FragmentTag.FRAGMENT_TYPE, FragmentTag.SCRIPT);
                source.setScript(WebContextFactory.get().forwardToString("/WEB-INF/jsp/discussion/"+type+"Target.jsp"));
            } else if (ioid!=null) {
                InfoObject infoObject = sdService.getInfoObjectById(ioid);
                
                type = infoObject.getStructure().getType();
                
                YesNoVoting voting = systemService.getVoting(YesNoVoting.TYPE_INFO_OBJECT, ioid);
                if (voting!=null) {
                    request.setAttribute("voting", voting);
                    map.put("voting", voting);
                }
                
                request.setAttribute("infoObject", infoObject);
                
                PageSource source = new PageSource();
                map.put("source", source);
                
                request.setAttribute(FragmentTag.FRAGMENT_TYPE, FragmentTag.HTML);
                source.setHtml(WebContextFactory.get().forwardToString("/WEB-INF/jsp/discussion/"+type+"Target.jsp"));
                
                request.setAttribute(FragmentTag.FRAGMENT_TYPE, FragmentTag.SCRIPT);
                source.setScript(WebContextFactory.get().forwardToString("/WEB-INF/jsp/discussion/"+type+"Target.jsp"));
            } else {
                InfoStructure structure = sdService.getInfoStructureById(isid);
                
                type = structure.getType();
                
                YesNoVoting voting = systemService.getVoting(YesNoVoting.TYPE_INFO_STRUCTURE, isid);
                if (voting!=null) {
                    request.setAttribute("voting", voting);
                    map.put("voting", voting);
                }
                
                request.setAttribute("infoStructure", structure);
                
                PageSource source = new PageSource();
                map.put("source", source);
                
                request.setAttribute(FragmentTag.FRAGMENT_TYPE, FragmentTag.HTML);
                source.setHtml(WebContextFactory.get().forwardToString("/WEB-INF/jsp/discussion/"+type+"StructureTarget.jsp"));
                
                request.setAttribute(FragmentTag.FRAGMENT_TYPE, FragmentTag.SCRIPT);
                source.setScript(WebContextFactory.get().forwardToString("/WEB-INF/jsp/discussion/"+type+"StructureTarget.jsp"));
            }
            
            map.put("successful", true);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
            return map;
        }
        
        return map;
    }//getTarget()
    
    
    /**
     * Set the voting choice on the given target.
     * 
     * @param params A map contains:
     *   <ul>
     *     <li>target - string, the voting taget. Required. Valid values include:
     *       <ul>
     *         <li>"structure" - InfoStructure</li>
     *         <li>"object" - InfoObject</li>
     *         <li>"post" - DiscussionPost</li>
     *         <li>"reply" - DiscussionReply</li>
     *       </ul>
     *     </li>
     *     <li>id - int, id of the target object. Required.</li>
     *     <li>agree - string, "true" or "false". Whether or not the current user agree with the current object.</li>
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
        
        Long id = null;
        try {
            id = new Long((String) params.get("id"));
        } catch (Exception e) {
            map.put("reason", "id is required.");
            return map;
        }
        
        boolean agree = "true".equalsIgnoreCase((String) params.get("agree"));
        
        try {
            String target = (String) params.get("target");
            
            int type = 0;
            
            if ("structure".equals(target)) {
                type = YesNoVoting.TYPE_INFO_STRUCTURE;
            } else if ("object".equals(target)) {
                type = YesNoVoting.TYPE_INFO_OBJECT;
            } else if ("post".equals(target)) {
                type = YesNoVoting.TYPE_DISCUSSION_POST;
            } else if ("reply".equals(target)) {
                type = YesNoVoting.TYPE_DISCUSSION_REPLY;
            } else {
                map.put("reason", "Unknown target type: "+target);
                return map;
            }
            
            sdService.setVoting(type, id, agree);
            
            map.put("successful", true);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
            return map;
        }
        
        return map;
    }//setVoting()
    
    
    /**
     * Get a concern by its Id
     * 
     * @param string id - the Id of the concern as a string
     * 
     * @return a map contains:<br>
     *     <ul>
     *       <li>successful - a boolean value denoting if the operation succeeds</li>
     *       <li>reason - reason why operation failed (valid when successful==false)</li>
     *       <li>concern - conern object</li>
     *       </li>
     *     </ul>
     */
    public Map getConcernById(HttpServletRequest request, String strId) {
    	Map map = new HashMap();
        map.put("successful", false);
        
        Long Id;
        
        try {
            Id = Long.parseLong(strId);
        } catch (Exception e) {
            map.put("reason", "Could not convert ID from String");
            return map;
        }
        
        try {
            Concern myConcern = sdService.getConcernById(Id);
            map.put("concern", myConcern);
            map.put("successful", true);
            
        } catch (Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
            return map;
        }
        
    	return map;
    }
    
    
    /**
     * Get the related concerns in this SDX instance for sidebar.
     * 
     * @param params a map contains:<br>
     *     <ul>
     *       <li>isid - the id of the current InfoStructure object</li>
     *       <li>ioid - the id of the current InfoObject object. (Optional, if omitted means at the InfoStructure level)</li>
     *       <li>type - the type of the tag id. "tag" means tag id, "tagref" means tag reference id</li>
     *       <li>tags - a comma separated string of tag/reference (depends on type) ids to filter the concerns. (Optional)</li>
     *       <li>count - int, concerns shown per page. (Optional, default is -1, means show all)</li>
     *       <li>page - int, current page number (Optional, default is 1).</li>
     *     </ul>
     * 
     * @param wfinfo A map contains:
     *   <ul>
     *   <li>workflowId - long</li>
     *   <li>contextId - long</li>
     *   <li>activityId - long</li>
     * </ul>
     * 
     * @return a map contains:<br>
     *     <ul>
     *       <li>successful - a boolean value denoting if the operation succeeds</li>
     *       <li>reason - reason why operation failed (valid when successful==false)</li>
     *       <li>num - number of tags this structure/object relates</li>
     *       <li>
     *         source - a PageSource object (valid when successful==true), it has the following properties:
     *         <ul>
     *           <li>html - a HTML source segment.<br>
     *             generated by /WEB-INF/jsp/discussion/sidebar-concerns.jsp<br>
     *             the following variables are available for use in jsp page:
     *               <ul>
     *                 <li>structure - An InfoStructure object</li>
     *                 <li>object - An InfoObject object (valid if ioid is provided)</li>
     *                 <li>concerns - a list of Concern objects</li>
     *                 <li>setting - An PageSetting object</li>
     *                 <li>num - number of tags this structure/object relates</li>
     *               </ul>
     *           </li>
     *           <li>script - a Javascript segment.<br>
     *             generated by /WEB-INF/jsp/discussion/sidebar-concerns.jsp<br>
     *             the following variables are available for use in jsp page:
     *               <ul>
     *                 <li>structure - An InfoStructure object</li>
     *                 <li>object - An InfoObject object (valid if ioid is provided)</li>
     *                 <li>concerns - a list of Concern objects</li>
     *                 <li>setting - An PageSetting object</li>
     *                 <li>num - number of tags this structure/object relates</li>
     *               </ul>
     *           </li>
     *         </ul>
     *       </li>
     *     </ul>
     */
    public Map getConcerns(HttpServletRequest request, Map params, Map wfinfo) {
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
            
            String ids = (String) params.get("tags");
            
            PageSetting setting = new PageSetting();
            setting.setRowOfPage(count);
            setting.setPage(page);
            
            Collection concerns = null;
            int num = 0;
            
            String type = (String) params.get("type");
            
            if (ioid==null) {
                concerns = sdService.getConcerns(structure, ids, setting, "tag".equals(type));
                num = sdService.getConcernTagCount(structure);
            } else {
                InfoObject object = sdService.getInfoObjectById(ioid);
                
                if (object==null) {
                    map.put("reason", "can't find this InfoObject object.");
                    return map;
                }
                
                request.setAttribute("object", object);
                
                num = sdService.getConcernTagCount(object);
                
                concerns = sdService.getConcerns(object, ids, setting, "tag".equals(type));
            }
            
            request.setAttribute("setting", setting);
            request.setAttribute("concerns", concerns);
            request.setAttribute("num", num);
            
            PageSource source = new PageSource();
            map.put("source", source);
            map.put("num", num);
            
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
    
    
    /**
     * Get the related discussions (to current post) in this SDX instance for sidebar.
     * 
     * @param params a map contains:<br>
     *     <ul>
     *       <li>isid - the id of the current InfoStructure object</li>
     *       <li>pid - the id of the current DiscussionPost object. (Optional, if omitted, return all posts)</li>
     *       <li>type - the type of the tag id. "tag" means tag id, "tagref" means tag reference id</li>
     *       <li>tags - a comma separated string of tag/reference (depends on type) ids filter the discussion. (Optional)</li>
     *       <li>count - int, discussion shown per page. (Optional, default is -1, means show all)</li>
     *       <li>page - int, current page number (Optional, default is 1).</li>
     *     </ul>
     * 
     * @return a map contains:<br>
     *     <ul>
     *       <li>successful - a boolean value denoting if the operation succeeds</li>
     *       <li>reason - reason why operation failed (valid when successful==false)</li>
     *       <li>num - number of tags this post/replies relates</li>
     *       <li>
     *         source - a PageSource object (valid when successful==true), it has the following properties:
     *         <ul>
     *           <li>html - a HTML source segment.<br>
     *             generated by /WEB-INF/jsp/discussion/sidebar-posts.jsp<br>
     *             the following variables are available for use in jsp page:
     *               <ul>
     *                 <li>posts - a list of DiscussionPost objects, and each post's value field hold a InfoObject object (which contain a CategoryReference object) OR null</li>
     *                 <li>setting - An PageSetting object</li>
     *                 <li>num - number of tags this post/replies relates</li>
     *               </ul>
     *           </li>
     *           <li>script - a Javascript segment.<br>
     *             generated by /WEB-INF/jsp/discussion/sidebar-posts.jsp<br>
     *             the following variables are available for use in jsp page:
     *               <ul>
     *                 <li>posts - a list of DiscussionPost objects, and each post's value field hold a InfoObject object (which contain a CategoryReference object) OR null</li>
     *                 <li>setting - An PageSetting object</li>
     *                 <li>num - number of tags this post/replies relates</li>
     *               </ul>
     *           </li>
     *         </ul>
     *       </li>
     *     </ul>
     */
    public Map getContextPosts(HttpServletRequest request, Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        Long isid = null;
        
        try {
            isid = new Long((String) params.get("isid"));
        } catch (Exception e) {
            map.put("reason", "can't find this InfoStructure object.");
            return map;
        }
        
        Long pid = null;
        try {
            pid = new Long((String) params.get("pid"));
        } catch (Exception e) {
        }
        
        try {
            int sorting = 0;
            try {
                sorting = Integer.parseInt((String) params.get("sorting"));
            } catch (Exception e) {
            }
            
            InfoStructure structure = sdService.getInfoStructureById(isid);
            if (structure==null) {
                map.put("reason", "can't find this InfoStructure object.");
                return map;
            }
            
            String ids = (String) params.get("tags");
            
            PageSetting setting = new PageSetting();
            setting.setRowOfPage((String) params.get("count"));
            setting.setPage((String) params.get("page"));
            
            Collection posts = null;
            int num = 0;
            
            String type = (String) params.get("type");
            
            posts = sdService.getContextPosts(isid, pid, ids, setting, "tag".equals(type), sorting);
            
            if (pid!=null) {
                num = sdService.getPostTagCount(isid, pid);
            }
            
            request.setAttribute("structure", structure);
            request.setAttribute("setting", setting);
            request.setAttribute("posts", posts);
            request.setAttribute("num", num);
            
            PageSource source = new PageSource();
            map.put("source", source);
            map.put("num", num);
            
            request.setAttribute(FragmentTag.FRAGMENT_TYPE, FragmentTag.HTML);
            source.setHtml(WebContextFactory.get().forwardToString("/WEB-INF/jsp/discussion/sidebar-posts.jsp"));
            
            request.setAttribute(FragmentTag.FRAGMENT_TYPE, FragmentTag.SCRIPT);
            source.setScript(WebContextFactory.get().forwardToString("/WEB-INF/jsp/discussion/sidebar-posts.jsp"));
            
            map.put("successful", true);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
            return map;
        }
        
        return map;
    }//getContextPosts()
    
    
    /**
     * Search all matched tags in the given InfoStructure by tag name. Approximate match is used for the tag string.
     *
     * @param params A map contains:<br>
     *         <ul>
     *           <li>isid - int, the current InfoStructure instance id</li>
     *           <li>ioid - int, the current InfoObject instance id. Optional.</li>
     *           <li>tag - A string, all or part of a Tag name</li>
     *           <li>count - int, discussion shown per page. (Optional, default is -1, means show all)</li>
     *           <li>page - int, current page number (Optional, default is 1).</li>
     *         </ul>
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *           <li>count - amount of matched Tag objects (valid when successful==true)</li>
     *           <li>html - a HTML source segment. (valid when count>0) <br>
     *                  (Generated by /WEB-INF/jsp/discussion/tagSearch.jsp)<br>
     *                  The following variables are available for use in the jsp:
     *                  <ul>
     *                    <li>structure - A InfoStructure object</li>
     *                    <li>infoObject - A InfoObject object</li>
     *                    <li>setting - An PageSetting object</li>
     *                    <li>tags - A list of Tag objects</li>
     *                  </ul>
     *           </li>
     *         </ul>
     */
    public Map searchTags(HttpServletRequest request, Map params) {
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
        
        String tag = (String) params.get("tag");
        if (tag == null || tag.trim().equals("")) {
            map.put("reason", "tag string to be searched is required!");
            return map;
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
            
            PageSetting setting = new PageSetting();
            setting.setRowOfPage(count);
            setting.setPage(page);
            
            Collection tags = null;
            
            if (ioid==null) {
                tags = sdService.searchTags(structure, tag, setting);
            } else {
                InfoObject infoObject = sdService.getInfoObjectById(ioid);
                if (infoObject==null) {
                    map.put("reason", "can't find this InfoObject object.");
                    return map;
                }
                
                request.setAttribute("infoObject", infoObject);
                
                tags = sdService.searchTags(structure, infoObject, tag, setting);
            }
            
            map.put("count", tags.size());
            
            request.setAttribute("structure", structure);
            request.setAttribute("tags", tags);
            request.setAttribute("setting", setting);
            map.put("html", WebContextFactory.get().forwardToString("/WEB-INF/jsp/discussion/tagSearch.jsp"));
            
            map.put("successful", true);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
            return map;
        }
        
        return map;
    }//searchTags()
    
    
    /**
     * Get the name of the tag based on the Tag ID
     *
     * @param String tagID
     * 
     * @return Map
     *        <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *           <li>tag - a single tag object</li>
     *         </ul>
     */
    public Map getTagById(String strTagId) {
    	Map map = new HashMap();
        map.put("successful", false);
         
     	Long tagId = null;
     	try {
            tagId = new Long(strTagId);
        } catch (Exception e) {
            map.put("reason", "Could not convert TagId to Long.");
            return map;
        }
         
         try {   
             Tag myTag = sdService.findTagById(tagId);
             map.put("tag", myTag);
         } catch (Exception e) {
             e.printStackTrace();
             map.put("reason", e.getMessage());
             return map;
         }
         map.put("successful", true);
         
    	return map;
    } //getTagById()
    
    
    /**
     * Get tag cloud in the give structure.
     *
     * @param params A map contains:<br>
     *         <ul>
     *           <li>isid - long int, the current InfoStructure instance id</li>
     *           <li>count - int, discussion shown per page. (Optional, default is -1, means show all)</li>
     *           <li>page - int, current page number (Optional, default is 1).</li>
     *         </ul>
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *           <li>html - a HTML source segment. (Generated by /WEB-INF/jsp/discussion/tagCloud.jsp)<br>
     *                  The following variables are available for use in the jsp:
     *                  <ul>
     *                    <li>structure - an InfoStructure object</li>
     *                    <li>tags - a list of TagInfo objects</li>
     *                    <li>setting - An PageSetting object</li>
     *                  </ul>
     *           </li>
     *         </ul>
     */
    public Map getTagCloud(HttpServletRequest request, Map params) {
        Map map = new HashMap();
        map.put("successful", false);

        Long isid = null;
        
        try {
            isid = new Long((String) params.get("isid"));
        } catch (Exception e) {
            map.put("reason", "can't find this InfoStructure object.");
            return map;
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
            
            PageSetting setting = new PageSetting();
            setting.setRowOfPage(count);
            setting.setPage(page);
            
            Collection tags = sdService.getTagCloud(structure, setting);
            
            request.setAttribute("structure", structure);
            request.setAttribute("setting", setting);
            request.setAttribute("tags", tags);
            map.put("html", WebContextFactory.get().forwardToString("/WEB-INF/jsp/discussion/tagCloud.jsp"));
            
            map.put("successful", true);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
            return map;
        }
        
        return map;
    }//getTagCloud()
    
    
    /**
     * Setup the email notification for the given Post/Reply.
     *
     * @param params A map contains:<br>
     *         <ul>
     *           <li>id - int, id of the DiscussionPost/DiscussionReply</li>
     *           <li>
     *              type - String, specify the type of the id
     *              <ul>
     *                <li>"post" - id is for DiscussionPost, default.</li>
     *                <li>"reply" - id is for DiscussionReply</li>
     *              </ul>
     *           </li>
     *           <li>turnon - boolean, true for turn on the email notification, false for turn off (default).</li>
     *         </ul>
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *         </ul>
     */
    public Map setupEmailNotify(HttpServletRequest request, Map params) {
        Map map = new HashMap();
        map.put("successful", false);

        Long id = null;
        
        try {
            id = new Long((String) params.get("id"));
        } catch (Exception e) {
            map.put("reason", "invalid id.");
            return map;
        }
        
        String type = (String) params.get("type");
        if (!"reply".equalsIgnoreCase(type)) type = "post";
        
        boolean turnon = "true".equalsIgnoreCase((String) params.get("turnon"));
        
        try {
            sdService.setupEmailNotify(id, type, turnon);
            
            map.put("successful", true);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
            return map;
        }
        
        return map;
    }//setupEmailNotify()
    
    
    /**
     * Search discussion in the specified info structure.
     * 
     * @param params A map contains:<br>
     *         <ul>
     *           <li>isid - int, id of the InfoStructure object, disregarded if ioid is not null</li>
     *           <li>ioid - int, id of the InfoObject object</li>
     *           <li>queryStr - string, the key words to be searched</li>
     *           <li>count - int, discussion shown per page. (Optional, default is -1, means show all)</li>
     *           <li>page - int, current page number (Optional, default is 1).</li>
     *         </ul>
     * 
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *           <li>html - a HTML source segment. (Generated by /WEB-INF/jsp/discussion/discussionSearch.jsp)<br>
     *                  The following variables are available for use in the jsp:
     *                  <ul>
     *                    <li>results - a list of Map objects, the content of the map is similar to that in Global Search</li>
     *                    <li>setting - An PageSetting object</li>
     *                  </ul>
     *           </li>
     *         </ul>
     */
    public Map search(HttpServletRequest request, Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        String isid = (String) params.get("isid");
        String ioid = (String) params.get("ioid");
        String queryStr = (String) params.get("queryStr");
        
        PageSetting setting = new PageSetting();
        setting.setRowOfPage((String) params.get("count"));
        setting.setPage((String) params.get("page"));
        request.setAttribute("setting", setting);
        
        List results = new ArrayList();
        request.setAttribute("results", results);
        
        queryStr = searchHelper.prefixString(queryStr);
        
        if (queryStr==null || queryStr.length()==0) {
            map.put("successful", true);
            return map;
        }
        
        IndexSearcher searcher = null;
        try {
            searcher = searchHelper.getIndexSearcher();
            
            Hits hits = null;
            
            if (ioid!=null) { 
                hits = searcher.search(searchHelper.getParser().parse(
                    "ioid:" + ioid + " AND (type:post OR type:reply) AND " + queryStr
                ));
            } else if (isid!=null) {
                hits = searcher.search(searchHelper.getParser().parse(
                    "isid:" + isid + " AND (type:post OR type:reply) AND " + queryStr
                ));
            } else {
                map.put("reason", "Either ioid or isid is required!");
                return map;
            }
            
            setting.setRowSize(hits.length());
            
            int start = setting.getFirstRow();
            int end = Math.min(hits.length(), start+setting.getRowOfPage());
            
            for (int i=start; i<end; i++) {
                Document doc = hits.doc(i);
                
                String type = doc.get("type");
                
                Map result = new HashMap();
                result.put("type", type);
                result.put("doc", doc);
                result.put("body", doc.get("body"));
                
                if ("post".equals(type)) {
                    result.put("isid", doc.get("isid"));
                    result.put("ioid", doc.get("ioid"));
                    result.put("postid", doc.get("postid"));
                    result.put("title", doc.get("title"));
                    result.put("tags", doc.get("tags"));
                } else if ("reply".equals(type)) {
                    result.put("postid", doc.get("postid"));
                    result.put("replyid", doc.get("replyid"));
                    result.put("isid", doc.get("isid"));
                    result.put("ioid", doc.get("ioid"));
                    result.put("title", doc.get("title"));
                    result.put("tags", doc.get("tags"));
                }
                
                results.add(result);
            }//for i
            
            map.put("html", WebContextFactory.get().forwardToString("/WEB-INF/jsp/discussion/discussionSearch.jsp"));
            
            map.put("successful", true);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//search()
    
    
}//class SDAgent
