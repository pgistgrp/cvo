package org.pgist.glossary;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.directwebremoting.WebContextFactory;
import org.pgist.discussion.DiscussionPost;
import org.pgist.system.EmailSender;
import org.pgist.util.PageSetting;


/**
 * DWR AJAX Agent class.<br>
 * Provide AJAX services to client programs.<br>
 * In this document, all the NON-AJAX methods are marked out. So all methods
 * <span style="color:red;">without</span> such a description
 * <span style="color:red;">ARE</span> AJAX service methods.<br>
 * 
 * @author kenny
 *
 */
public class GlossaryManageAgent {
    
    
    private GlossaryService glossaryService;
    
    private EmailSender emailSender;
    
    
    /**
     * This is not an AJAX service method.
     * 
     * @param glossaryService
     */
    public void setGlossaryService(GlossaryService glossaryService) {
        this.glossaryService = glossaryService;
    }
    
    
    public void setEmailSender(EmailSender emailSender) {
        this.emailSender = emailSender;
    }


    /*
     * ------------------------------------------------------------------------
     */
    
    
    /**
     * Get proposed glossary terms by participants.
     * 
     * @param params - empty<br>
     * 
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *           <li>html - a HTML source segment. (generated by /WEB-INF/jsp/glossary/gmProposedTerms.jsp)
     *                  The following variables are available for use in the jsp:
     *                  <ul>
     *                    <li>terms - A list of Term objects</li>
     *                  </ul>
     *           </li>
     *         </ul>
     */
    public Map getProposedTerms(HttpServletRequest request, Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        try {
            Collection terms = glossaryService.getTerms(new int[] {Term.STATUS_PENDING});
            
            request.setAttribute("terms", terms);
            
            map.put("html", WebContextFactory.get().forwardToString("/WEB-INF/jsp/glossary/gmProposedTerms.jsp"));
            
            map.put("successful", true);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//getProposedTerms()
    
    
    /**
     * Get glossary terms with the given filter and sorting conditions.
     * 
     * @param params - A map contains:<br>
     *         <ul>
     *           <li>filter - string</li>
     *           <li>sort - string, ['name' | 'views' | 'comments', 'createtime'], optional, default is 'name'</li>
     *           <li>direction - string, ['asc' | 'desc'], optional, default is 'asc'</li>
     *         </ul>
     *         
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *           <li>html - a HTML source segment. (if sorting by name, it's generated by /WEB-INF/jsp/glossary/gmTermsAlpha.jsp; 
     *           else it's generated by /WEB-INF/jsp/glossary/gmTerms.jsp)<br>
     *                  The following variables are available for use in the jsp:
     *                  <ul>
     *                    <li>terms - A list of Term objects</li>
     *                    <li>filter - string</li>
     *                    <li>sort - string, ['name' | 'views' | 'comments', 'createtime']</li>
     *                    <li>direction - string, ['asc' | 'desc']</li>
     *                  </ul>
     *           </li>
     *         </ul>
     */
    public Map getTerms(HttpServletRequest request, Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        try {
            String filter = (String) params.get("filter");
            if (filter==null) filter = "";
            
            String sort = (String) params.get("sort");
            if (sort==null) sort = "name";
            
            String direction = (String) params.get("direction");
            if (direction==null) direction = "asc";
            
            Collection terms = glossaryService.getTerms(filter, sort, direction, new int[] {Term.STATUS_OFFICIAL});
            
            char ch = 0;
            List initials = new ArrayList(27);
            for (Term term : (Collection<Term>) terms) {
                if (ch!=term.getInitial()) {
                    ch = term.getInitial();
                    initials.add(new Character(ch));
                }
            }
            
            request.setAttribute("filter", filter);
            request.setAttribute("sort", sort);
            request.setAttribute("direction", direction);
            request.setAttribute("terms", terms);
            request.setAttribute("initials", initials);
            
            if (sort==null || "".equals(sort) || "name".equalsIgnoreCase(sort)) {
                map.put("html", WebContextFactory.get().forwardToString("/WEB-INF/jsp/glossary/gmTermsAlpha.jsp"));
            } else {
                map.put("html", WebContextFactory.get().forwardToString("/WEB-INF/jsp/glossary/gmTerms.jsp"));
            }
            
            map.put("successful", true);
        } catch (Exception e) {
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//getTerms()
    
    
    /**
     * Get term object with the given termId. By specifying "type" parameter, a page for viewing or
     * editing will be returned.
     * 
     * @param params - A map contains:<br>
     *         <ul>
     *           <li>id - int, id of term object</li>
     *           <li>type - string, 'view' | 'edit'</li>
     *         </ul>
     *         
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *           <li>term - a Term object (valid when successful==true)</li>
     *           <li>html - a HTML source segment.
     *                  if type=='view', generated by /WEB-INF/jsp/glossary/gmTermView.jsp<br>
     *                  else if type=='edit', generated by /WEB-INF/jsp/glossary/gmTermEdit.jsp<br>
     *                  The following variables are available for use in the jsp:
     *                  <ul>
     *                    <li>term - A Term object</li>
     *                    <li>comments - A collection of DiscussionPost objects</li>
     *                  </ul>
     *           </li>
     *         </ul>
     */
    public Map getTerm(HttpServletRequest request, Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        try {
            Long id = new Long((String) params.get("id"));
            String type = (String) params.get("type");
            
            Term term = glossaryService.getTermById(id);
            if (term==null) {
                map.put("reason", "term with id "+id+" is not found!");
                return map;
            }
            
            map.put("term", term);
            
            Collection comments = glossaryService.getComments(term);
            
            request.setAttribute("term", term);
            request.setAttribute("comments", comments);
            
            if ("view".equals(type)) {
                map.put("html", WebContextFactory.get().forwardToString("/WEB-INF/jsp/glossary/gmTermView.jsp"));
            } else if ("edit".equals(type)) {
                map.put("html", WebContextFactory.get().forwardToString("/WEB-INF/jsp/glossary/gmTermEdit.jsp"));
            } else {
                map.put("reason", "type must be either 'view' or 'edit'");
                return map;
            }
            
            map.put("successful", true);
        } catch (Exception e) {
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//getTerm()
    
    
    /**
     * Save the given term object.
     * 
     * @param params - A map contains:<br>
     *         <ul>
     *           <li>id - int, id of term object, -1 denotes to create a new term, else modify an existing term</li>
     *           <li>name - string, the name of term</li>
     *           <li>shortDefinition - string, the short definition of term</li>
     *           <li>extDefinition - string, the extended definition of term</li>
     *         </ul>
     *         
     * @param relatedTerms - string[], array of related terms
     * 
     * @param links - string[], array of term links
     * 
     * @param sources - string[][], string[x][0] is the citation of the xth TermSource, string[x][1] is the url of the xth TermSource
     * 
     * @param categories - string[], array of term categories
     * 
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *         </ul>
     */
    public Map saveTerm(Map params, String[] relatedTerms, String[] links, String[][] sources, String[] categories) {
        Map map = new HashMap();
        map.put("successful", false);
        
        try {
            Term term;
            Long id = new Long((String) params.get("id"));
            if (id==-1) {
                term = new Term();
                term.setViewCount(0);
                term.setHighlightCount(0);
                term.setCommentCount(0);
            } else {
                term = glossaryService.getTermById(id);
                if (term==null) {
                    map.put("reason", "term with id "+id+" is not found!");
                    return map;
                }
            }
            
            String name = (String) params.get("name");
            if (name==null || "".equals(name)) {
                map.put("reason", "name is required for term");
                return map;
            }
            term.setName(name);
            
            String shortDefinition = (String) params.get("shortDefinition");
            term.setShortDefinition(shortDefinition);
            
            String extDefinition = (String) params.get("extDefinition");
            term.setExtDefinition(extDefinition);
            
            if (id==-1) {
                glossaryService.createTerm(term, relatedTerms, links, sources, categories, Term.STATUS_OFFICIAL);
            } else {
                if (term.getStatus()==Term.STATUS_PENDING) term.setStatus(Term.STATUS_OFFICIAL);
                glossaryService.updateTerm(term, relatedTerms, links, sources, categories);
            }
            
            map.put("successful", true);
        } catch (Exception e) {
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//saveTerm()
    
    
    /**
     * Delete the given term object.
     * 
     * @param params - A map contains:<br>
     *         <ul>
     *           <li>id - int, id of term object to be deleted</li>
     *         </ul>
     *         
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *         </ul>
     */
    public Map deleteTerm(Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        try {
            Long id = new Long((String) params.get("id"));
            
            Term term = glossaryService.getTermById(id);
            if (term==null) {
                map.put("reason", "term with id "+id+" is not found!");
                return map;
            }
            
            glossaryService.deleteTerm(term);
            
            map.put("successful", true);
        } catch (Exception e) {
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//deleteTerm()
    
    
    /**
     * Accept the given term object proposed by participant.
     * 
     * @param params - A map contains:<br>
     *         <ul>
     *           <li>id - int, id of proposed term object to be accepted</li>
     *         </ul>
     *         
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *         </ul>
     */
    public Map acceptTerm(Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        try {
            Long id = new Long((String) params.get("id"));
            
            Term term = glossaryService.getTermById(id);
            if (term==null) {
                map.put("reason", "term with id "+id+" is not found!");
                return map;
            }
            
            glossaryService.acceptTerm(term);
            
            map.put("successful", true);
        } catch (Exception e) {
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//deleteTerm()
    
    
    /**
     * Reject the given term object proposed by participant.
     * 
     * @param params - A map contains:<br>
     *         <ul>
     *           <li>id - int, id of proposed term object to be accepted</li>
     *           <li>reason - string, why the term is rejected</li>
     *         </ul>
     *         
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *           <li>email - Whether or not the email is sent out. "success" | "failure".</li>
     *         </ul>
     */
    public Map rejectTerm(Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        try {
            Long id = new Long((String) params.get("id"));
            
            Term term = glossaryService.getTermById(id);
            if (term==null) {
                map.put("reason", "term with id "+id+" is not found!");
                return map;
            }
            
            String reason = (String) params.get("reason");
            
            glossaryService.rejectTerm(term, reason);
            
            try {
                Map values = new HashMap();
                values.put("term", term);
                values.put("user", term.getCreator());
                values.put("reason", reason);
                
                emailSender.send(term.getCreator(), "term_rejected", values);
                
                map.put("email", "success");
            } catch (Exception e) {
                map.put("email", "failure");
            }
            
            map.put("successful", true);
        } catch (Exception e) {
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//rejectTerm()
    
    
    /**
     * Search in terms with the given prefix.
     * 
     * @param params - A map contains:<br>
     *         <ul>
     *           <li>prefix - string, prefix to be matched.</li>
     *         </ul>
     *         
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *           <li>html - a HTML source segment, generated by /WEB-INF/jsp/glossary/gmSearch.jsp
     *                  The following variables are available for use in the jsp:
     *                  <ul>
     *                    <li>prefix - prefix</li>
     *                    <li>terms - A collection of term objects</li>
     *                  </ul>
     *           </li>
     *         </ul>
     */
    public Map searchTerm(HttpServletRequest request, Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        try {
            String prefix = (String) params.get("prefix");
            
            PageSetting setting = new PageSetting();
            setting.setPageOfScreen(-1);
            setting.setPage(1);
            setting.setFilter(prefix);
            
            Collection terms = glossaryService.getTerms(setting, true);
            request.setAttribute("prefix", prefix);
            request.setAttribute("terms", terms);
            
            map.put("html", WebContextFactory.get().forwardToString("/WEB-INF/jsp/glossary/gmSearch.jsp"));
            
            map.put("successful", true);
        } catch (Exception e) {
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//searchTerm()
    
    
    /**
     * Get the comments to the specified term.
     * 
     * @param params - A map contains:<br>
     *         <ul>
     *           <li>id - int, id of the term object</li>
     *         </ul>
     *         
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *           <li>html - a HTML source segment, generated by /WEB-INF/jsp/glossary/gmComments.jsp.
     *                  The following variables are available for use in the jsp:
     *                  <ul>
     *                    <li>term - A Term object</li>
     *                    <li>comments - array of DiscussionPost objects</li>
     *                  </ul>
     *           </li>
     *         </ul>
     */
    public Map getComments(HttpServletRequest request, Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        try {
            Long id = new Long((String) params.get("id"));
            
            Term term = glossaryService.getTermById(id);
            if (term==null) {
                map.put("reason", "term with id "+id+" is not found!");
                return map;
            }
            
            request.setAttribute("term", term);
            
            Collection comments = glossaryService.getComments(term);
            request.setAttribute("comments", comments);
            
            map.put("html", WebContextFactory.get().forwardToString("/WEB-INF/jsp/glossary/gpComments.jsp"));
            map.put("successful", true);
        } catch (Exception e) {
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//getComments()
    
    
    /**
     * Delete the given comment to the specified term.
     * 
     * @param params - A map contains:<br>
     *         <ul>
     *           <li>termId - int, id of the term object</li>
     *           <li>commentId - int, id of the DiscussionPost object</li>
     *         </ul>
     *         
     * @return A map contains:<br>
     *         <ul>
     *           <li>successful - a boolean value denoting if the operation succeeds</li>
     *           <li>reason - reason why operation failed (valid when successful==false)</li>
     *         </ul>
     */
    public Map deleteComment(Map params) {
        Map map = new HashMap();
        map.put("successful", false);
        
        try {
            Long termId = new Long((String) params.get("termId"));
            
            Term term = glossaryService.getTermById(termId);
            if (term==null) {
                map.put("reason", "term with id "+termId+" is not found!");
                return map;
            }
            
            Long commentId = new Long((String) params.get("commentId"));
            
            DiscussionPost comment = glossaryService.getCommentById(commentId);
            if (comment==null) {
                map.put("reason", "comment with id "+commentId+" is not found!");
                return map;
            }
            
            glossaryService.deleteComment(term, comment);
            
            map.put("successful", true);
        } catch (Exception e) {
            map.put("reason", e.getMessage());
        }
        
        return map;
    }//deleteComment()
    
    
}//class GlossaryManageAgent
