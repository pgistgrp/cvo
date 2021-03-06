package org.pgist.ddl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.dom4j.Document;
import org.dom4j.Element;
import org.pgist.glossary.Term;
import org.pgist.glossary.TermAcronym;
import org.pgist.glossary.TermCategory;
import org.pgist.glossary.TermLink;
import org.pgist.glossary.TermSource;
import org.pgist.glossary.TermVariation;
import org.pgist.users.User;


/**
 * Handler for importing/exporting glossary terms.
 * 
 * @author kenny
 *
 */
public class GlossaryHandler extends XMLHandler {
    
    
    public void doImports(Element root) throws Exception {
        /*
         * At first we don't process related terms. We just persist each terms without related terms.
         * All related terms are recorded in map, and in the next step, the related terms will be handled.
         */
        Map map = new HashMap();
        
        List<Element> termElements = root.elements("term");
        for (Element element : (List<Element>) termElements) {
            String name = element.attributeValue("name");
            if (name==null || "".equals(name)) throw new Exception("name is required for term");
            name = name.trim();
            
            String status = element.attributeValue("status");
            if (status==null || "".equals(status)) status = "official";
            
            Term term = new Term();
            
            name = Character.toUpperCase(name.charAt(0)) + name.substring(1);
            term.setName(name);
            
            String acronym = element.elementTextTrim("abbreviation");
            if (acronym!=null) {
                TermAcronym ta = new TermAcronym();
                ta.setName(acronym);
                
                persist(ta);
                
                term.setAcronym(ta);
            }
            
            Element variations = element.element("variations");
            if (variations!=null) {
                List vars = variations.elements("variation");
                for (Element e : (List<Element>) vars) {
                    String variation = e.getTextTrim();
                    if (variation==null || "".equals(variation.trim())) continue;
                    
                    TermVariation tv = new TermVariation();
                    tv.setName(variation);
                    
                    persist(tv);
                    
                    term.getVariations().add(tv);
                }//for
            }
            
            if ("pending".equalsIgnoreCase(status)) {
                term.setStatus(Term.STATUS_PENDING);
            } else if ("official".equalsIgnoreCase(status)) {
                term.setStatus(Term.STATUS_OFFICIAL);
            } else {
                throw new Exception("Unknown status for term: "+name);
            }
            
            term.setInitial(name.charAt(0));
            term.setDeleted(false);
            
            String shortDefinition = element.elementTextTrim("shortDefinition");
            if (shortDefinition==null) shortDefinition = "";
            term.setShortDefinition(shortDefinition);
            
            String extDefinition = element.elementTextTrim("extDefinition");
            if (extDefinition==null) extDefinition = "";
            term.setExtDefinition(extDefinition);
            
            String loginname = element.elementTextTrim("creator");
            if (loginname==null || "".equals(loginname.trim())) loginname = "admin";
            
            User creator = getUserByLoginName(loginname);
            if (creator==null) throw new Exception("can't find user with loginname "+loginname);
            term.setCreator(creator);
            
            String createTimeStr = element.elementTextTrim("createTime");
            if (createTimeStr==null || "".equals(createTimeStr)) {
                term.setCreateTime(new Date());
            } else {
                Date createTime = format.parse(createTimeStr);
                term.setCreateTime(createTime);
            }
            
            Element relatedTermsElement = element.element("relatedTerms");
            if (relatedTermsElement!=null) {
                map.put(term, relatedTermsElement.elements("term"));
            }
            
            Element linksElement = element.element("links");
            if (linksElement!=null) {
                List links = linksElement.elements("link");
                for (int j=0,m=links.size(); j<m; j++) {
                    Element linkElement = (Element) links.get(j);
                    String link = linkElement.getTextTrim();
                    
                    if (link==null || "".equals(link)) continue;
                    
                    TermLink termLink = new TermLink();
                    termLink.setLink(link);
                    
                    persist(termLink);
                    
                    term.getLinks().add(termLink);
                }//for j
            }
            
            Element sourcesElement = element.element("sources");
            if (sourcesElement!=null) {
                List sources = sourcesElement.elements("source");
                for (Element sourceElement : (List<Element>) sources) {
                    /*
                     * citation is required
                     */
                    String citation = sourceElement.elementTextTrim("citation");
                    if (citation==null || "".equals(citation.trim())) continue;
                    citation = citation.trim();
                    
                    /*
                     * url is not required
                     */
                    String url = sourceElement.elementTextTrim("url");
                    if (url!=null) {
                        url = url.trim();
                        if ("".equals(url)) {
                            url = null;
                        }
                    }
                    
                    TermSource termSource = new TermSource();
                    termSource.setCitation(citation);
                    termSource.setUrl(url);
                    
                    persist(termSource);
                    
                    term.getSources().add(termSource);
                }//for j
            }
            
            Element catsElement = element.element("categories");
            if (catsElement!=null) {
                List cats = catsElement.elements("category");
                for (int j=0,m=cats.size(); j<m; j++) {
                    Element catElement = (Element) cats.get(j);
                    String category = catElement.getTextTrim();
                    if (category==null || "".equals(category)) throw new Exception("category can't be empty");
                    
                    TermCategory termCat = getTermCatByName(category);
                    if (termCat==null) {
                        termCat = new TermCategory();
                        termCat.setName(category);
                        persist(termCat);
                    }
                    term.getCategories().add(termCat);
                }//for j
            }
            
            String refCount = element.elementTextTrim("refCount");
            if (refCount==null || "".equals(refCount)) term.setViewCount(0);
            else term.setViewCount(Integer.parseInt(refCount));
            
            String hitCount = element.elementTextTrim("hitCount");
            if (hitCount==null || "".equals(hitCount)) term.setHighlightCount(0);
            else term.setHighlightCount(Integer.parseInt(hitCount));
            
            String commentCount = element.elementTextTrim("commentCount");
            if (commentCount==null || "".equals(commentCount)) term.setCommentCount(0);
            else term.setCommentCount(Integer.parseInt(commentCount));
            
            persist(term);
            System.out.println("Term ---> "+term.getName());
        }//for i
        
        /*
         * Now that all terms are persisted, we can handle the relationship between them
         */
        for (Map.Entry<Term, List<Element>> entry : (Set<Map.Entry>) map.entrySet()) {
            Term term = entry.getKey();
            List<Element> elements = entry.getValue();
            
            for (Element element : elements) {
                String name = element.getTextTrim();
                if (name==null || "".equals(name.trim())) continue;
                name = name.trim();
                
                Term relatedTerm = getTermByName(name);
                if (relatedTerm==null) throw new Exception("related term "+name+" is not found!");
                
                term.getRelatedTerms().add(relatedTerm);
                relatedTerm.getRelatedTerms().add(term);
                
                persist(relatedTerm);
            }//for i
            
            persist(term);
        }
    }//imports()
    
    
    public void doExports(Document document) throws Exception {
        Element root = document.addElement("glossary");
        
        List<Term> terms = getTerms();
        
        for (Term term : terms) {
            Element one = root.addElement("term");
            one.addAttribute("name", term.getName());
            
            switch(term.getStatus()) {
                case Term.STATUS_PENDING:
                    one.addAttribute("status", "pending");
                    break;
                case Term.STATUS_OFFICIAL:
                    one.addAttribute("status", "official");
                    break;
                default:
                    throw new Exception("Unknown status for term: "+term.getName());
            }//switch
            
            one.addElement("shortDefinition").setText(term.getShortDefinition());
            one.addElement("extDefinition").setText(term.getExtDefinition());
            
            Element abbreviation = one.addElement("abbreviation");
            abbreviation.setText(term.getAcronym().getName());
            
            Element creator = one.addElement("creator");
            creator.addAttribute("type", "loginname");
            creator.addText(term.getCreator().getLoginname());
            
            Element createTime = one.addElement("createTime");
            createTime.setText(format.format(term.getCreateTime()));
            
            Element relatedTerms = one.addElement("relatedTerms");
            for (Term relatedTerm : (Set<Term>)term.getRelatedTerms()) {
                Element oneTerm = relatedTerms.addElement("term");
                oneTerm.setText(relatedTerm.getName());
            }
            
            Element links = one.addElement("links");
            for (TermLink link : (Set<TermLink>)term.getLinks()) {
                Element oneLink = links.addElement("link");
                oneLink.setText(link.getLink());
            }
            
            Element sources = one.addElement("sources");
            for (TermSource source : (Set<TermSource>)term.getSources()) {
                Element oneSource = sources.addElement("source");
                oneSource.setText(source.getCitation());
            }
            
            Element categories = one.addElement("categories");
            for (TermCategory category : (Set<TermCategory>)term.getCategories()) {
                Element oneCategory = categories.addElement("category");
                oneCategory.setText(category.getName());
            }
            
            one.addElement("refCount").setText(""+term.getViewCount());
            one.addElement("hitCount").setText(""+term.getHighlightCount());
            one.addElement("commentCount").setText(""+term.getCommentCount());
        }//for
    }//doExports()


}//class GlossaryHandler
