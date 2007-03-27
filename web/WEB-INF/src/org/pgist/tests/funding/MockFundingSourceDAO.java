package org.pgist.tests.funding;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;

import org.pgist.funding.FundingDAO;
import org.pgist.funding.FundingSource;
import org.pgist.funding.FundingSourceAltRef;
import org.pgist.funding.FundingSourceAlternative;
import org.pgist.funding.FundingSourceRef;
import org.pgist.funding.FundingSourceSuite;
import org.pgist.packages.Package;
import org.pgist.projects.Project;
import org.pgist.projects.ProjectAltRef;
import org.pgist.projects.ProjectAlternative;
import org.pgist.projects.ProjectDAO;
import org.pgist.projects.ProjectRef;
import org.pgist.projects.ProjectSuite;
import org.pgist.users.User;

/**
 * Use this class to create a mock interface to be used with
 * @author Matt Paulin
 *
 */
public class MockFundingSourceDAO implements FundingDAO {

	//A collection of the objects deleted
	private ArrayList deleted = new ArrayList();
	
	public ArrayList getDeleted() {
		return deleted;
	}
	/**
	 * Resets the deleted
	 */
	public void clearDeleted() {
		this.deleted.clear();
	}
	
	
	//A collection of all that was saved;
	private ArrayList saved = new ArrayList();
	
	public ArrayList getSaved() {
		return saved;		
	}
	
	/**
	 * Resets the saved collection
	 */
	public void clearSaved() {
		saved.clear();
	}
	public void delete(FundingSource source) {
		this.deleted.add(source);		
	}
	public void delete(FundingSourceAlternative alt) {
		this.deleted.add(alt);
	}
	public void delete(FundingSourceAltRef altRef) {
		this.deleted.add(altRef);
	}
	public void delete(FundingSourceRef fundingRef) {
		this.deleted.add(fundingRef);
	}
	public FundingSourceAlternative getFundingSourceAltById(Long id) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}
	private FundingSourceAlternative alt;
	public void setFundingSourceAlternative(FundingSourceAlternative alt) {
		this.alt = alt;
	}
	public FundingSourceAlternative getFundingSourceAlternative(Long altId) {
		return alt;
	}
	
	private FundingSourceAltRef fundingSourceAltRef; 
	public void setFundingAlternativeReference(FundingSourceAltRef altRef1) {
		fundingSourceAltRef = altRef1;
	}
	public FundingSourceAltRef getFundingSourceAlternativeReference(Long altId) {
		return fundingSourceAltRef;
	}
	public FundingSource getFundingSourceById(Long id) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}
	public FundingSource getFundingSourceByName(String name) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}
	public Collection getFundingSources() throws Exception {
		// TODO Auto-generated method stub
		return null;
	}
	FundingSourceSuite funSuite;
	public void setFundingSuite(FundingSourceSuite suite) {
		this.funSuite = suite;
	}	
	public FundingSourceSuite getFundingSuite(Long suiteID) throws Exception {
		return this.funSuite;
	}
	public void save(FundingSource source) {
		this.saved.add(source);
		
	}
	public void save(FundingSourceAlternative alt) {
		this.saved.add(alt);		
	}
	public User getUserById(Long id) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}
	public Object load(Class klass, Long id) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}
	public void save(Object object) throws Exception {
		this.saved.add(object);
	}
}